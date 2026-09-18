package com.example.interviewtracker.mapper;

import com.example.interviewtracker.dto.ApiDtos.*;
import com.example.interviewtracker.entity.*;
import org.springframework.stereotype.Component;

@Component
public class DtoMapper {

    public UserResponse user(User u) {
        return new UserResponse(u.getId(), u.getEmail(), u.getDisplayName());
    }

    public CategoryResponse category(Category c, long count, java.util.List<String> subcategories) {
        return new CategoryResponse(c.getId(), c.getName(), count, subcategories, c.getCreatedAt(), c.getUpdatedAt());
    }

    public SubcategoryResponse subcategory(Subcategory s) {
        return new SubcategoryResponse(s.getId(), s.getCategory()
                .getId(), s.getName(), s.getCreatedAt(), s.getUpdatedAt());
    }

    public QuestionResponse question(Question q) {
        return new QuestionResponse(q.getId(), new CategoryRef(q.getCategory()
                .getId(), q.getCategory().getName()), q.getSubcategory() == null ? null :
                new SubcategoryRef(q.getSubcategory().getId(), q.getSubcategory()
                        .getName()), q.getQuestion(), q.getQuestionSource(), q.getQuestionSourceUrl(), q.getAnswerSource(), q.getAnswerSourceUrl(), q.isStudiedBefore(), q.getPracticeCount(), q.getCreatedAt(), q.getUpdatedAt());
    }

    public WorkspaceNoteResponse note(WorkspaceNote n) {
        return new WorkspaceNoteResponse(n.getId(), question(n.getQuestion()), n.getAnswer(), n.getCreatedAt(), n.getUpdatedAt());
    }
}
