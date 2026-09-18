package com.example.interviewtracker.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
public class User extends BaseEntity {

    @Column(nullable = false, unique = true, length = 255)
    private String email;
    @Column(nullable = false)
    private String passwordHash;
    @Column(nullable = false, length = 120)
    private String displayName;
    @Column(nullable = false)
    private boolean enabled = true;
}
