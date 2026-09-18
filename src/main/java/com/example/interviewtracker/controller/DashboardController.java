package com.example.interviewtracker.controller;

import com.example.interviewtracker.dto.ApiDtos.DashboardStats;
import com.example.interviewtracker.service.DashboardService;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/dashboard")
public class DashboardController {

    private final DashboardService s;

    public DashboardController(DashboardService s) {
        this.s = s;
    }

    @GetMapping
    public DashboardStats stats(Authentication a) {
        return s.stats(a.getName());
    }
}
