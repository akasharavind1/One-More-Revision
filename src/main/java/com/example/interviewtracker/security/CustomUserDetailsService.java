package com.example.interviewtracker.security;

import com.example.interviewtracker.repository.UserRepository;
import org.springframework.security.core.userdetails.*;
import org.springframework.stereotype.Service;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository repo;

    public CustomUserDetailsService(UserRepository repo) {
        this.repo = repo;
    }

    public UserDetails loadUserByUsername(String username) {
        var u = repo.findByEmailIgnoreCase(username).orElseThrow(() -> new UsernameNotFoundException("User not found"));
        return User.withUsername(u.getEmail()).password(u.getPasswordHash()).disabled(!u.isEnabled()).roles("USER")
                .build();
    }
}
