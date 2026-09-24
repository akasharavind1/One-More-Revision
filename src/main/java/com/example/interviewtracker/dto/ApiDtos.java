package com.example.interviewtracker.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.*;

import java.time.Instant;
import java.util.List;

public final class ApiDtos {

    private ApiDtos() {
    }

    public record LoginRequest(@NotBlank String username, @NotBlank String password) {

    }

    public record LoginResponse(String token, UserResponse user) {

    }

    public record UserResponse(Long id, String email, String displayName) {

    }

    public record CategoryRequest(@NotBlank @Size(max = 120) String name) {

    }

    public record CategoryResponse(Long id, String name, long questionCount, List<String> subcategories,
                                   Instant createdAt, Instant updatedAt) {

    }

    public record SubcategoryRequest(@NotNull Long categoryId, @NotBlank @Size(max = 120) String name) {

    }

    public record SubcategoryResponse(Long id, Long categoryId, String name, Instant createdAt, Instant updatedAt) {

    }

    public record CategoryRef(Long id, String name) {

    }

    public record SubcategoryRef(Long id, String name) {

    }

    public record QuestionRequest(@NotNull Long categoryId, Long subcategoryId, @NotBlank String question,
                                  String questionSource, @Size(max = 1000) String questionSourceUrl,
                                  String answerSource, @Size(max = 1000) String answerSourceUrl,
                                  @Min(0) Integer practiceCount, Boolean studiedBefore) {

    }

    public record QuestionResponse(Long id, CategoryRef category, SubcategoryRef subcategory,
                                   String question, String questionSource, String questionSourceUrl,
                                   String answerSource, String answerSourceUrl, boolean studiedBefore,
                                   int practiceCount, Instant createdAt, Instant updatedAt) {

    }

    public record StudiedRequest(@NotNull Boolean studiedBefore) {

    }

    public record PracticeRequest(Integer delta) {

    }

    public record WorkspaceNoteRequest(@NotNull Long questionId, @NotNull String answer) {

    }

    public record WorkspaceNoteResponse(Long id, QuestionResponse question, String answer, Instant createdAt,
                                        Instant updatedAt) {

    }

    public record WorkspaceNoteBulkItemRequest(@NotNull Long questionId, @NotNull String answer) {

    }

    public record WorkspaceNoteBulkRequest(
            @NotNull @jakarta.validation.constraints.Size(min = 1, max = 100)
            java.util.List<@Valid WorkspaceNoteBulkItemRequest> items) {

    }

    public record WorkspaceNoteBulkResponse(int created, int updated, int skipped) {

    }

    public record PageResponse<T>(List<T> content, int page, int size, long totalElements, int totalPages) {

    }

    public record ImportError(int row, String message) {

    }

    public record ImportPreviewRow(int row, String category, String subcategory, String question,
                                   String questionSource, String questionSourceUrl, String answerSource,
                                   String answerSourceUrl, boolean valid, List<String> errors) {

    }

    public record ImportValidationResponse(String importId, boolean valid, int totalRows, int validRows,
                                           int invalidRows, int duplicateRows, List<ImportError> errors,
                                           List<ImportPreviewRow> preview) {

    }

    public record ImportConfirmResponse(int imported, int skipped, int duplicates, int invalid) {

    }

    public record DashboardStats(long totalQuestions, long studied, long notStudied, long practiceSessions,
                                 long workspaceNotes, long categories, List<QuestionResponse> recentlyPracticed,
                                 List<QuestionResponse> notStudiedQuestions) {

    }
}
