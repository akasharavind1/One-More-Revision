package com.example.interviewtracker.service;

import com.example.interviewtracker.dto.ApiDtos.*;
import com.example.interviewtracker.entity.*;
import com.example.interviewtracker.exception.AppExceptions.*;
import com.example.interviewtracker.mapper.DtoMapper;
import com.example.interviewtracker.repository.*;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class WorkspaceNoteService {

    private final WorkspaceNoteRepository notes;
    private final UserRepository users;
    private final QuestionService questions;
    private final DtoMapper mapper;

    public WorkspaceNoteService(WorkspaceNoteRepository n, UserRepository u, QuestionService q, DtoMapper m) {
        notes = n;
        users = u;
        questions = q;
        mapper = m;
    }

    public PageResponse<WorkspaceNoteResponse> all(String email, int page, int size) {
        var u = user(email);
        var p = notes.findByUserId(u.getId(), PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "updatedAt")));
        return new PageResponse<>(p.getContent().stream().map(mapper::note)
                .toList(), p.getNumber(), p.getSize(), p.getTotalElements(), p.getTotalPages());
    }

    public WorkspaceNoteResponse get(String email, Long id) {
        return mapper.note(notes.findByIdAndUserId(id, user(email).getId())
                .orElseThrow(() -> new NotFound("Workspace note not found")));
    }

    public List<WorkspaceNoteResponse> allNotes() {
        return notes.findAll()
                .stream()
                .map(mapper::note)
                .toList();
    }

    @Transactional
    public WorkspaceNoteResponse create(String email, WorkspaceNoteRequest r) {
        var u = user(email);
        var q = questions.get(r.questionId());
        if (notes.existsByUserIdAndQuestionId(u.getId(), q.getId())) {
            throw new Conflict("A workspace note already exists for this question");
        }
        if (r.answer() == null || r.answer().isBlank()) {
            throw new BadRequest("Answer / notes cannot be empty");
        }
        var n = new WorkspaceNote();
        n.setUser(u);
        n.setQuestion(q);
        n.setAnswer(r.answer().trim());
        return mapper.note(notes.save(n));
    }

    @Transactional
    public WorkspaceNoteResponse update(String email, Long id, WorkspaceNoteRequest r) {
        var n = notes.findByIdAndUserId(id, user(email).getId())
                .orElseThrow(() -> new NotFound("Workspace note not found"));
        if (r.answer() == null || r.answer().isBlank()) {
            throw new BadRequest("Answer / notes cannot be empty");
        }
        n.setAnswer(r.answer().trim());
        return mapper.note(notes.save(n));
    }

    @Transactional
    public WorkspaceNoteBulkResponse bulkSave(String email, WorkspaceNoteBulkRequest r) {
        var u = user(email);
        Map<Long, String> byQuestion = new LinkedHashMap<>();
        int skipped = 0;
        for (var item : r.items()) {
            if (item.answer() == null || item.answer().isBlank()) {
                skipped++;
                continue;
            }
            byQuestion.put(item.questionId(), item.answer().trim());
        }
        int created = 0;
        int updated = 0;
        for (var entry : byQuestion.entrySet()) {
            var q = questions.get(entry.getKey());
            var existing = notes.findByUserIdAndQuestionId(u.getId(), q.getId());
            if (existing.isPresent()) {
                existing.get().setAnswer(entry.getValue());
                notes.save(existing.get());
                updated++;
            } else {
                var n = new WorkspaceNote();
                n.setUser(u);
                n.setQuestion(q);
                n.setAnswer(entry.getValue());
                notes.save(n);
                created++;
            }
        }
        return new WorkspaceNoteBulkResponse(created, updated, skipped);
    }

    @Transactional
    public void delete(String email, Long id) {
        var n = notes.findByIdAndUserId(id, user(email).getId())
                .orElseThrow(() -> new NotFound("Workspace note not found"));
        notes.delete(n);
    }

    public long count(String email) {
        return notes.countByUserId(user(email).getId());
    }

    private User user(String e) {
        return users.findByEmailIgnoreCase(e).orElseThrow(() -> new NotFound("User not found"));
    }
}
