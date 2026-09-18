package com.example.interviewtracker.service;

import com.example.interviewtracker.dto.ApiDtos.*;
import com.example.interviewtracker.repository.CategoryRepository;
import org.springframework.stereotype.Service;

@Service
public class DashboardService {

    private final QuestionService q;
    private final WorkspaceNoteService n;
    private final CategoryRepository c;

    public DashboardService(QuestionService q, WorkspaceNoteService n, CategoryRepository c) {
        this.q = q;
        this.n = n;
        this.c = c;
    }

    public DashboardStats stats(String email) {
        long total = q.total(), stud = q.studied();
        return new DashboardStats(total, stud,
                total - stud, q.practices(), n.count(email), c.count(), q.recent(), q.notStudied());
    }
}
