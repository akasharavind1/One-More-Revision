package com.example.interviewtracker.repository;

import com.example.interviewtracker.entity.Subcategory;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SubcategoryRepository extends JpaRepository<Subcategory, Long> {

    List<Subcategory> findByCategoryIdOrderByNameAsc(Long categoryId);
}
