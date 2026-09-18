package com.example.interviewtracker.controller;

import com.example.interviewtracker.dto.ApiDtos.*;
import com.example.interviewtracker.service.WorkspaceNoteService;
import jakarta.validation.Valid;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/workspace-notes")
public class WorkspaceNoteController {

    private final WorkspaceNoteService s;

    public WorkspaceNoteController(WorkspaceNoteService s) {
        this.s = s;
    }

    @GetMapping
    public PageResponse<WorkspaceNoteResponse> all(Authentication a, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "20") int size) {
        return s.all(a.getName(), page, Math.min(size, 1000));
    }

    @GetMapping("/all")
    public List<WorkspaceNoteResponse> allNotes() {
        return s.allNotes();
    }

    @GetMapping("/{id}")
    public WorkspaceNoteResponse get(Authentication a, @PathVariable Long id) {
        return s.get(a.getName(), id);
    }

    @PostMapping
    public WorkspaceNoteResponse create(Authentication a, @Valid @RequestBody WorkspaceNoteRequest r) {
        return s.create(a.getName(), r);
    }

    @PutMapping("/{id}")
    public WorkspaceNoteResponse update(Authentication a, @PathVariable Long id, @Valid @RequestBody WorkspaceNoteRequest r) {
        return s.update(a.getName(), id, r);
    }

    @DeleteMapping("/{id}")
    public void delete(Authentication a, @PathVariable Long id) {
        s.delete(a.getName(), id);
    }
}
