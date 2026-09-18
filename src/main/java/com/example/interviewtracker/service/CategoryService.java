package com.example.interviewtracker.service;

import com.example.interviewtracker.dto.ApiDtos.*;
import com.example.interviewtracker.entity.*;
import com.example.interviewtracker.exception.AppExceptions.*;
import com.example.interviewtracker.mapper.DtoMapper;
import com.example.interviewtracker.repository.*;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class CategoryService {

    private final CategoryRepository cats;
    private final SubcategoryRepository subs;
    private final DtoMapper mapper;

    public CategoryService(CategoryRepository c, SubcategoryRepository s, DtoMapper m) {
        cats = c;
        subs = s;
        mapper = m;
    }

    public List<CategoryResponse> all() {
        return cats.findAll(org.springframework.data.domain.Sort.by("name")).stream()
                .map(c -> {
                    var subNames = subs.findByCategoryIdOrderByNameAsc(c.getId()).stream()
                            .map(Subcategory::getName)
                            .toList();
                    return mapper.category(c, cats.countQuestions(c.getId()), subNames);
                })
                .toList();
    }

    public CategoryResponse create(CategoryRequest r) {
        cats.findByNameIgnoreCase(r.name().trim()).ifPresent(x -> {
            throw new Conflict("Category already exists");
        });
        var c = new Category();
        c.setName(r.name().trim());
        return mapper.category(cats.save(c), 0, List.of());
    }

    public CategoryResponse update(Long id, CategoryRequest r) {
        var c = get(id);
        cats.findByNameIgnoreCase(r.name().trim()).filter(x -> !x.getId().equals(id)).ifPresent(x -> {
            throw new Conflict("Category already exists");
        });
        c.setName(r.name().trim());
        var subNames = subs.findByCategoryIdOrderByNameAsc(id).stream().map(Subcategory::getName).toList();
        return mapper.category(cats.save(c), cats.countQuestions(id), subNames);
    }

    public void delete(Long id) {
        get(id);
        long n = cats.countQuestions(id);
        if (n > 0) {
            throw new Conflict("Cannot delete this category because " + n + " questions are associated with it.");
        }
        subs.deleteAll(subs.findByCategoryIdOrderByNameAsc(id));
        cats.deleteById(id);
    }

    public Category get(Long id) {
        return cats.findById(id).orElseThrow(() -> new NotFound("Category not found"));
    }

    public List<SubcategoryResponse> subcategories(Long categoryId) {
        get(categoryId);
        return subs.findByCategoryIdOrderByNameAsc(categoryId).stream().map(mapper::subcategory).toList();
    }

    public List<SubcategoryResponse> allSubcategories() {
        return subs.findAll(Sort.by("name"))
                .stream()
                .map(mapper::subcategory)
                .toList();
    }

    public SubcategoryResponse createSub(SubcategoryRequest r) {
        var c = get(r.categoryId());
        if (subs.findByCategoryIdOrderByNameAsc(c.getId()).stream()
                .anyMatch(s -> s.getName().equalsIgnoreCase(r.name().trim()))) {
            throw new Conflict("Subcategory already exists in this category");
        }
        var s = new Subcategory();
        s.setCategory(c);
        s.setName(r.name().trim());
        return mapper.subcategory(subs.save(s));
    }

    public Subcategory getSub(Long id) {
        return subs.findById(id).orElseThrow(() -> new NotFound("Subcategory not found"));
    }

    public SubcategoryResponse updateSub(Long id, SubcategoryRequest r) {
        var s = getSub(id);
        s.setCategory(get(r.categoryId()));
        s.setName(r.name().trim());
        return mapper.subcategory(subs.save(s));
    }

    public void deleteSub(Long id) {
        getSub(id);
        subs.deleteById(id);
    }
}
