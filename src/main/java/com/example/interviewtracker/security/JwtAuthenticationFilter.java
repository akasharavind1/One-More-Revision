package com.example.interviewtracker.security;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtService jwt;
    private final UserDetailsService users;

    public JwtAuthenticationFilter(JwtService jwt, UserDetailsService users) {
        this.jwt = jwt;
        this.users = users;
    }

    protected void doFilterInternal(HttpServletRequest req, HttpServletResponse res, FilterChain chain) throws ServletException, IOException {
        String h = req.getHeader("Authorization");
        if (h != null && h.startsWith("Bearer ")) {
            String t = h.substring(7);
            if (jwt.valid(t)) {
                String sub = jwt.subject(t);
                var ud = users.loadUserByUsername(sub);
                var a = new UsernamePasswordAuthenticationToken(ud, null, ud.getAuthorities());
                SecurityContextHolder.getContext().setAuthentication(a);
            }
        }
        chain.doFilter(req, res);
    }
}
