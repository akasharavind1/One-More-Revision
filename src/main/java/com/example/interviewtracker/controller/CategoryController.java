package com.example.interviewtracker.controller;

import com.example.interviewtracker.dto.ApiDtos.*;
import com.example.interviewtracker.service.CategoryService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/categories")
public class CategoryController {

    private final CategoryService s;

    public CategoryController(CategoryService s) {
        this.s = s;
    }

    @GetMapping
    public List<CategoryResponse> all() {
        return s.all();
    }

    @PostMapping
    public CategoryResponse create(@Valid @RequestBody CategoryRequest r) {
        return s.create(r);
    }

    @PutMapping("/{id}")
    public CategoryResponse update(@PathVariable Long id, @Valid @RequestBody CategoryRequest r) {
        return s.update(id, r);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        s.delete(id);
    }

    @GetMapping("/{id}/subcategories")
    public List<SubcategoryResponse> subs(@PathVariable Long id) {
        return s.subcategories(id);
    }
}
