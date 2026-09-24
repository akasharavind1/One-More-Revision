package com.example.interviewtracker.repository;

import com.example.interviewtracker.entity.WorkspaceNote;
import org.springframework.data.domain.*;
import org.springframework.data.jpa.repository.*;

import java.util.*;

public interface WorkspaceNoteRepository extends JpaRepository<WorkspaceNote, Long> {

    Page<WorkspaceNote> findByUserId(Long userId, Pageable pageable);

    Optional<WorkspaceNote> findByIdAndUserId(Long id, Long userId);

    boolean existsByUserIdAndQuestionId(Long userId, Long questionId);

    long countByUserId(Long userId);
}
