package com.example.interviewtracker.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "categories", uniqueConstraints = @UniqueConstraint(name = "uk_category_name", columnNames = "name"))
@Getter
@Setter
@NoArgsConstructor
public class Category extends BaseEntity {

    @Column(nullable = false, length = 120)
    private String name;
}
