package com.example.interviewtracker.controller;

import com.example.interviewtracker.dto.ApiDtos.*;
import com.example.interviewtracker.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService s;

    public AuthController(AuthService s) {
        this.s = s;
    }

    @PostMapping("/login")
    public LoginResponse login(@Valid @RequestBody LoginRequest r) {
        return s.login(r);
    }

    @GetMapping("/me")
    public UserResponse me(Authentication a) {
        return s.me(a.getName());
    }
}
