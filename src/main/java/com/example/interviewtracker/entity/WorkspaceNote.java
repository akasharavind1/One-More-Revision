package com.example.interviewtracker.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "workspace_notes", uniqueConstraints = @UniqueConstraint(name = "uk_note_user_question", columnNames = {"user_id", "question_id"}), indexes = @Index(name = "idx_notes_user", columnList = "user_id"))
@Getter
@Setter
@NoArgsConstructor
public class WorkspaceNote extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "question_id", nullable = false)
    private Question question;
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    @Column(nullable = false, columnDefinition = "text")
    private String answer;
}
