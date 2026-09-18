package com.example.interviewtracker.service;

import com.example.interviewtracker.dto.ApiDtos.*;
import com.example.interviewtracker.entity.*;
import com.example.interviewtracker.exception.AppExceptions.*;
import com.example.interviewtracker.mapper.DtoMapper;
import com.example.interviewtracker.repository.*;
import org.apache.poi.ss.usermodel.*;
import org.slf4j.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.net.*;
import java.util.*;
import java.util.concurrent.*;

@Service
public class QuestionImportService {

    private static final Logger log = LoggerFactory.getLogger(QuestionImportService.class);
    private static final List<String> REQUIRED = List.of("Category", "Subcategory", "Question", "Question Source", "Question Source URL", "Answer Source");
    private static final String OPTIONAL = "Answer Source URL";
    private static final int MAX_TAXONOMY_NAME_LEN = 120;
    private final Map<String, ImportBatch> batches = new ConcurrentHashMap<>();
    private final CategoryRepository cats;
    private final SubcategoryRepository subs;
    private final QuestionRepository questions;

    public QuestionImportService(CategoryRepository c, SubcategoryRepository s, QuestionRepository q) {
        cats = c;
        subs = s;
        questions = q;
    }

    record ImportRow(int row, String category, String subcategory, String question, String questionSource,
                     String questionSourceUrl, String answerSource, String answerSourceUrl, List<String> errors) {

    }

    record ImportBatch(List<ImportRow> rows) {

    }

    public ImportValidationResponse validate(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new BadRequest("Please select an Excel file");
        }
        if (!Objects.requireNonNullElse(file.getOriginalFilename(), "").toLowerCase().endsWith(".xlsx")) {
            throw new BadRequest("Only .xlsx files are supported");
        }
        try (InputStream in = file.getInputStream(); Workbook wb = WorkbookFactory.create(in)) {
            Sheet sh = wb.getSheetAt(0);
            org.apache.poi.ss.usermodel.Row header = readHeader(sh);
            Map<String, Integer> cols = new LinkedHashMap<>();
            List<String> errors = new ArrayList<>();
            for (int i = 0; i < header.getLastCellNum(); i++) {
                String raw = text(header.getCell(i));
                String n = normalize(raw);
                if (n.isBlank()) {
                    continue;
                }
                if (cols.containsKey(n)) {
                    errors.add("Duplicate column: " + raw);
                    continue;
                }
                cols.put(n, i);
            }
            for (String req : REQUIRED) {
                if (!cols.containsKey(normalize(req))) {
                    errors.add("Missing required column: " + req);
                }
            }
            Set<String> known = new HashSet<>();
            REQUIRED.forEach(x -> known.add(normalize(x)));
            known.add(normalize(OPTIONAL));
            for (String h : cols.keySet()) {
                if (!known.contains(h)) {
                    errors.add("Unexpected column: " + h);
                }
            }
            if (!errors.isEmpty()) {
                return new ImportValidationResponse(null, false, 0, 0, 0, 0, errors.stream()
                        .map(x -> new ImportError(1, x)).toList(), List.of());
            }
            List<ImportRow> rows = new ArrayList<>();
            Set<String> questionSeen = new HashSet<>();
            int valid = 0, invalid = 0, dups = 0;
            for (int i = 1; i <= sh.getLastRowNum(); i++) {
                org.apache.poi.ss.usermodel.Row r = sh.getRow(i);
                if (r == null || isBlankRow(r)) {
                    continue;
                }
                int rowNo = i + 1;
                String cat = normalizeTaxonomyName(cell(r, cols, "Category"));
                String sub = normalizeTaxonomyName(cell(r, cols, "Subcategory"));
                String q = cell(r, cols, "Question");
                String qs = cell(r, cols, "Question Source");
                String qu = cell(r, cols, "Question Source URL");
                String as = cell(r, cols, "Answer Source");
                String au = cellOptional(r, cols, OPTIONAL);
                List<String> er = new ArrayList<>();
                if (cat.isBlank()) {
                    er.add("Category is required");
                } else if (cat.length() > MAX_TAXONOMY_NAME_LEN) {
                    er.add("Category must be at most " + MAX_TAXONOMY_NAME_LEN + " characters");
                }
                if (!sub.isBlank() && sub.length() > MAX_TAXONOMY_NAME_LEN) {
                    er.add("Subcategory must be at most " + MAX_TAXONOMY_NAME_LEN + " characters");
                }
                if (q.isBlank()) {
                    er.add("Question is required");
                }
                if (!qu.isBlank() && !validUrl(qu)) {
                    er.add("Question Source URL is not a valid URL");
                }
                if (!au.isBlank() && !validUrl(au)) {
                    er.add("Answer Source URL is not a valid URL");
                }
                String qkey = (cat + "|" + sub + "|" + q).trim().toLowerCase();
                if (!q.isBlank() && !questionSeen.add(qkey)) {
                    er.add("Possible duplicate question detected");
                    dups++;
                }
                rows.add(new ImportRow(rowNo, cat, sub, q, qs, qu, as, au, er));
                if (er.isEmpty()) {
                    valid++;
                } else {
                    invalid++;
                }
            }
            String id = UUID.randomUUID().toString();
            batches.put(id, new ImportBatch(rows));
            log.info("Excel import validation completed: importId={}, total={}, valid={}, invalid={}", id, rows.size(), valid, invalid);
            var preview = rows.stream()
                    .map(r -> new ImportPreviewRow(r.row, r.category, r.subcategory, r.question, r.questionSource, r.questionSourceUrl, r.answerSource, r.answerSourceUrl, r.errors.isEmpty(), r.errors))
                    .toList();
            var ie = rows.stream().flatMap(r -> r.errors.stream().map(e -> new ImportError(r.row, e))).toList();
            return new ImportValidationResponse(id,
                    invalid == 0 && !rows.isEmpty(), rows.size(), valid, invalid, dups, ie, preview);
        } catch (IOException | RuntimeException e) {
            if (e instanceof BadRequest b) {
                throw b;
            }
            throw new BadRequest("Could not read Excel file: " + e.getMessage());
        }
    }

    private org.apache.poi.ss.usermodel.Row readHeader(Sheet s) {
        var r = s.getRow(0);
        if (r == null) {
            throw new BadRequest("Excel file must contain a header row");
        }
        return r;
    }

    private String normalize(String s) {
        return s == null ? "" : s.trim().replaceAll("\s+", " ").toLowerCase();
    }

    private String text(Cell c) {
        if (c == null) {
            return "";
        }
        DataFormatter f = new DataFormatter();
        return f.formatCellValue(c).trim();
    }

    private String cell(org.apache.poi.ss.usermodel.Row r, Map<String, Integer> cols, String h) {
        Integer i = cols.get(normalize(h));
        if (i == null) {
            return "";
        }
        return text(r.getCell(i));
    }

    /**
     * Excel exports (e.g. from pandas) sometimes put multi-line debug text in a single cell.
     * This keeps the human-readable category/subcategory name within DB limits.
     */
    private String normalizeTaxonomyName(String raw) {
        if (raw == null || raw.isBlank()) {
            return "";
        }
        String s = raw.replace('\r', '\n').trim();
        if (s.contains("|")) {
            String afterPipe = s.substring(s.lastIndexOf('|') + 1).trim();
            if (!afterPipe.isBlank() && !afterPipe.contains("dtype:")) {
                s = afterPipe;
            }
        }
        if (s.contains("\n")) {
            String best = pickBestTaxonomyLine(s);
            if (!best.isBlank()) {
                s = best;
            } else {
                s = Arrays.stream(s.split("\n"))
                        .map(String::trim)
                        .filter(line -> !line.isBlank())
                        .findFirst()
                        .orElse(s);
            }
        }
        s = stripCategoryLabel(s);
        return s.replaceAll("\\s+", " ").trim();
    }

    private String pickBestTaxonomyLine(String multiline) {
        String[] lines = multiline.split("\n");
        for (int i = lines.length - 1; i >= 0; i--) {
            String line = stripCategoryLabel(lines[i].trim());
            if (line.isBlank() || line.contains("dtype:")) {
                continue;
            }
            if (line.length() <= MAX_TAXONOMY_NAME_LEN) {
                return line.replaceAll("\\s+", " ");
            }
        }
        return "";
    }

    private String stripCategoryLabel(String value) {
        if (value == null) {
            return "";
        }
        String s = value.trim();
        if (s.regionMatches(true, 0, "category", 0, "category".length())) {
            s = s.substring("category".length()).trim();
        }
        return s;
    }

    private String cellOptional(org.apache.poi.ss.usermodel.Row r, Map<String, Integer> cols, String h) {
        Integer i = cols.get(normalize(h));
        return i == null ? "" : text(r.getCell(i));
    }

    private boolean isBlankRow(org.apache.poi.ss.usermodel.Row r) {
        for (int i = 0; i < r.getLastCellNum(); i++) {
            if (!text(r.getCell(i)).isBlank()) {
                return false;
            }
        }
        return true;
    }

    private boolean validUrl(String u) {
        try {
            var x = URI.create(u);
            return ("http".equalsIgnoreCase(x.getScheme()) || "https".equalsIgnoreCase(x.getScheme())) &&
                    x.getHost() != null;
        } catch (Exception e) {
            return false;
        }
    }

    @Transactional
    public ImportConfirmResponse confirm(String importId) {
        var batch = batches.remove(importId);
        if (batch == null) {
            throw new BadRequest("Import preview expired or does not exist");
        }
        if (batch.rows.stream().anyMatch(r -> !r.errors.isEmpty())) {
            throw new BadRequest("Only a fully valid import can be confirmed");
        }
        int imported = 0;
        for (ImportRow r : batch.rows) {
            var c = cats.findByNameIgnoreCase(r.category.trim()).orElseGet(() -> {
                var x = new Category();
                x.setName(r.category.trim());
                return cats.save(x);
            });
            Subcategory sub = null;
            if (!r.subcategory.isBlank()) {
                sub = subs.findByCategoryIdOrderByNameAsc(c.getId()).stream()
                        .filter(x -> x.getName().equalsIgnoreCase(r.subcategory.trim())).findFirst().orElseGet(() -> {
                            var x = new Subcategory();
                            x.setCategory(c);
                            x.setName(r.subcategory.trim());
                            return subs.save(x);
                        });
            }
            var q = new Question();
            q.setCategory(c);
            q.setSubcategory(sub);
            q.setQuestion(r.question.trim());
            q.setQuestionSource(blank(r.questionSource));
            q.setQuestionSourceUrl(blank(r.questionSourceUrl));
            q.setAnswerSource(blank(r.answerSource));
            q.setAnswerSourceUrl(blank(r.answerSourceUrl));
            questions.save(q);
            imported++;
        }
        log.info("Excel import completed: importId={}, imported={}", importId, imported);
        return new ImportConfirmResponse(imported, 0, 0, 0);
    }

    private String blank(String s) {
        return s == null || s.isBlank() ? null : s.trim();
    }
}
