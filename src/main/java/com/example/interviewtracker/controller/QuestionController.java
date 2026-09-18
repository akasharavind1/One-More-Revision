package com.example.interviewtracker.controller;

import com.example.interviewtracker.dto.ApiDtos.*;
import com.example.interviewtracker.service.QuestionService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Sort;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/questions")
public class QuestionController {

    private final QuestionService s;

    public QuestionController(QuestionService s) {
        this.s = s;
    }

    @GetMapping
    public PageResponse<QuestionResponse> all(@RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "20") int size, @RequestParam(required = false) Long categoryId, @RequestParam(required = false) Long subcategoryId, @RequestParam(required = false) Boolean studiedBefore, @RequestParam(required = false) String search, @RequestParam(defaultValue = "question,asc") String sort) {
        String[] p = sort.split(",", 2);
        Sort so = Sort.by(
                p.length > 1 && p[1].equalsIgnoreCase("desc") ? Sort.Direction.DESC : Sort.Direction.ASC, p[0]);
        return s.search(page, Math.min(size, 100), categoryId, subcategoryId, studiedBefore, search, org.springframework.data.domain.PageRequest.of(page, Math.min(size, 100), so));
    }

    @GetMapping("/{id}")
    public QuestionResponse get(@PathVariable Long id) {
        return s.getResponse(id);
    }

    @PostMapping
    public QuestionResponse create(@Valid @RequestBody QuestionRequest r) {
        return s.create(r);
    }

    @PutMapping("/{id}")
    public QuestionResponse update(@PathVariable Long id, @Valid @RequestBody QuestionRequest r) {
        return s.update(id, r);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        s.delete(id);
    }

    @PatchMapping("/{id}/studied")
    public QuestionResponse studied(@PathVariable Long id, @Valid @RequestBody StudiedRequest r) {
        return s.studied(id, r);
    }

    @PatchMapping("/{id}/practice-count")
    public QuestionResponse practice(@PathVariable Long id, @Valid @RequestBody PracticeRequest r) {
        return s.practice(id, r);
    }
}
