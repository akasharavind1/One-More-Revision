package com.example.interviewtracker.controller;

import com.example.interviewtracker.dto.ApiDtos.*;
import com.example.interviewtracker.service.CategoryService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/subcategories")
public class SubcategoryController {

    private final CategoryService s;

    public SubcategoryController(CategoryService s) {
        this.s = s;
    }

    @PostMapping
    public SubcategoryResponse create(@Valid @RequestBody SubcategoryRequest r) {
        return s.createSub(r);
    }

    @PutMapping("/{id}")
    public SubcategoryResponse update(@PathVariable Long id, @Valid @RequestBody SubcategoryRequest r) {
        return s.updateSub(id, r);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        s.deleteSub(id);
    }

    @GetMapping
    public List<SubcategoryResponse> all() {
        return s.allSubcategories();
    }
}
