package com.example.interviewtracker.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "questions", indexes = {
        @Index(name = "idx_questions_category", columnList = "category_id"),
        @Index(name = "idx_questions_subcategory", columnList = "subcategory_id"),
        @Index(name = "idx_questions_studied", columnList = "studied_before"),
        @Index(name = "idx_questions_category_subcategory", columnList = "category_id,subcategory_id")})
@Getter
@Setter
@NoArgsConstructor
public class Question extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "subcategory_id")
    private Subcategory subcategory;
    @Column(nullable = false, columnDefinition = "text")
    private String question;
    @Column(name = "question_source", length = 255)
    private String questionSource;
    @Column(name = "question_source_url", length = 1000)
    private String questionSourceUrl;
    @Column(name = "answer_source", length = 255)
    private String answerSource;
    @Column(name = "answer_source_url", length = 1000)
    private String answerSourceUrl;
    @Column(name = "studied_before", nullable = false)
    private boolean studiedBefore = false;
    @Column(name = "practice_count", nullable = false)
    private int practiceCount = 0;
}
