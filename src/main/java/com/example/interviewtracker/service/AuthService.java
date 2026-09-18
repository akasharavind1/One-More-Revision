package com.example.interviewtracker.service;

import com.example.interviewtracker.dto.ApiDtos.*;
import com.example.interviewtracker.repository.UserRepository;
import com.example.interviewtracker.security.JwtService;
import org.springframework.security.authentication.*;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final AuthenticationManager auth;
    private final JwtService jwt;
    private final UserRepository users;

    public AuthService(AuthenticationManager a, JwtService j, UserRepository u) {
        auth = a;
        jwt = j;
        users = u;
    }

    public LoginResponse login(LoginRequest r) {
        var a = auth.authenticate(new UsernamePasswordAuthenticationToken(r.username(), r.password()));
        var u = users.findByEmailIgnoreCase(a.getName()).orElseThrow();
        return new LoginResponse(jwt.generate(u.getEmail()), new UserResponse(u.getId(), u.getEmail(), u.getDisplayName()));
    }

    public UserResponse me(String email) {
        var u = users.findByEmailIgnoreCase(email).orElseThrow();
        return new UserResponse(u.getId(), u.getEmail(), u.getDisplayName());
    }
}
