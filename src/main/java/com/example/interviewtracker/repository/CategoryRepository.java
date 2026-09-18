package com.example.interviewtracker.repository;

import com.example.interviewtracker.entity.Category;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;

import java.util.*;

public interface CategoryRepository extends JpaRepository<Category, Long> {

    Optional<Category> findByNameIgnoreCase(String name);

    @Query("select count(q) from Question q where q.category.id=:id")
    long countQuestions(@Param("id") Long id);
}
