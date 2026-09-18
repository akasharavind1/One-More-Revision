package com.example.interviewtracker.repository;

import com.example.interviewtracker.entity.Question;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;

import java.util.*;

public interface QuestionRepository extends JpaRepository<Question, Long>, JpaSpecificationExecutor<Question> {

    @Query("SELECT COUNT(q) FROM Question q WHERE q.studiedBefore = :studiedBefore")
    long countStudiedQuestions(@Param("studiedBefore") boolean studiedBefore);

    long countByPracticeCountGreaterThan(int count);
}
