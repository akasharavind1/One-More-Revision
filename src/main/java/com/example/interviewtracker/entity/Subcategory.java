package com.example.interviewtracker.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "subcategories", uniqueConstraints = @UniqueConstraint(name = "uk_subcategory_category_name", columnNames = {"category_id", "name"}))
@Getter
@Setter
@NoArgsConstructor
public class Subcategory extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;
    @Column(nullable = false, length = 120)
    private String name;
}
