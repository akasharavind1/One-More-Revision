package com.example.interviewtracker.service;

import com.example.interviewtracker.dto.ApiDtos.*;
import com.example.interviewtracker.entity.*;
import com.example.interviewtracker.exception.AppExceptions.*;
import com.example.interviewtracker.mapper.DtoMapper;
import com.example.interviewtracker.repository.*;
import org.springframework.data.domain.*;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class QuestionService {

    private final QuestionRepository repo;
    private final CategoryService cats;
    private final DtoMapper mapper;
    private final SubcategoryRepository subs;

    public QuestionService(QuestionRepository r, CategoryService c, DtoMapper m, SubcategoryRepository s) {
        repo = r;
        cats = c;
        mapper = m;
        subs = s;
    }

    public PageResponse<QuestionResponse> search(int page, int size, Long categoryId, Long subcategoryId, Boolean studied, String search, Pageable pageable) {
        var p = repo.findAll(spec(categoryId, subcategoryId, studied, search), PageRequest.of(page, size, pageable.getSort()));
        return new PageResponse<>(p.getContent().stream().map(mapper::question)
                .toList(), p.getNumber(), p.getSize(), p.getTotalElements(), p.getTotalPages());
    }

    private Specification<Question> spec(Long cat, Long sub, Boolean studied, String search) {
        return (root, q, cb) -> {
            var list = new java.util.ArrayList<jakarta.persistence.criteria.Predicate>();
            if (cat != null) {
                list.add(cb.equal(root.get("category").get("id"), cat));
            }
            if (sub != null) {
                list.add(cb.equal(root.get("subcategory").get("id"), sub));
            }
            if (studied != null) {
                list.add(cb.equal(root.get("studiedBefore"), studied));
            }
            if (search != null && !search.isBlank()) {
                list.add(cb.like(cb.lower(root.get("question")), "%" + search.toLowerCase() + "%"));
            }
            return cb.and(list.toArray(new jakarta.persistence.criteria.Predicate[0]));
        };
    }

    public QuestionResponse getResponse(Long id) {
        return mapper.question(get(id));
    }

    public Question get(Long id) {
        return repo.findById(id).orElseThrow(() -> new NotFound("Question not found"));
    }

    @Transactional
    public QuestionResponse create(QuestionRequest r) {
        var q = new Question();
        apply(q, r);
        return mapper.question(repo.save(q));
    }

    @Transactional
    public QuestionResponse update(Long id, QuestionRequest r) {
        var q = get(id);
        apply(q, r);
        return mapper.question(repo.save(q));
    }

    private void apply(Question q, QuestionRequest r) {
        q.setCategory(cats.get(r.categoryId()));
        q.setSubcategory(r.subcategoryId() == null ? null :
                subs.findById(r.subcategoryId()).orElseThrow(() -> new NotFound("Subcategory not found")));
        if (q.getSubcategory() != null && !q.getSubcategory().getCategory().getId().equals(q.getCategory().getId())) {
            throw new BadRequest("Subcategory does not belong to selected category");
        }
        q.setQuestion(r.question().trim());
        q.setQuestionSource(blank(r.questionSource()));
        q.setQuestionSourceUrl(blank(r.questionSourceUrl()));
        q.setAnswerSource(blank(r.answerSource()));
        q.setAnswerSourceUrl(blank(r.answerSourceUrl()));
        if (r.studiedBefore() != null) {
            q.setStudiedBefore(
                    r.studiedBefore()
            );
        }
        if (r.practiceCount() != null) {
            q.setPracticeCount(r.practiceCount());
        }
    }

    private String blank(String s) {
        return s == null || s.isBlank() ? null : s.trim();
    }

    @Transactional
    public QuestionResponse studied(Long id, StudiedRequest r) {
        var q = get(id);
        q.setStudiedBefore(r.studiedBefore());
        return mapper.question(repo.save(q));
    }

    @Transactional
    public QuestionResponse practice(Long id, PracticeRequest r) {
        if (r.delta() == null || !(r.delta() == 1 || r.delta() == -1)) {
            throw new BadRequest("Practice delta must be 1 or -1");
        }
        var q = get(id);
        q.setPracticeCount(Math.max(0, q.getPracticeCount() + r.delta()));
        return mapper.question(repo.save(q));
    }

    @Transactional
    public void delete(Long id) {
        get(id);
        repo.deleteById(id);
    }

    public long total() {
        return repo.count();
    }

    public long studied() {
        return repo.countStudiedQuestions(true);
    }

    public long practices() {
        return repo.findAll().stream().mapToLong(Question::getPracticeCount).sum();
    }

    public java.util.List<QuestionResponse> recent() {
        return repo.findAll(PageRequest.of(0, 5, Sort.by(Sort.Direction.DESC, "updatedAt"))).getContent().stream()
                .map(mapper::question).toList();
    }

    public java.util.List<QuestionResponse> notStudied() {
        return repo.findAll((root, q, cb) -> cb.isFalse(root.get("studiedBefore")), PageRequest.of(0, 5, Sort.by("createdAt")))
                .getContent().stream().map(mapper::question).toList();
    }
}
