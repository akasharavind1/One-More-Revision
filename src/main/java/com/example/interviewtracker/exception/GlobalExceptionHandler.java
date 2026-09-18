package com.example.interviewtracker.exception;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.*;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.util.*;

@RestControllerAdvice
public class GlobalExceptionHandler {

    record ErrorResponse(Instant timestamp, int status, String error, String message, List<String> details) {

    }

    @ExceptionHandler(AppExceptions.NotFound.class)
    ResponseEntity<ErrorResponse> notFound(AppExceptions.NotFound e) {
        return build(HttpStatus.NOT_FOUND, "NOT_FOUND", e.getMessage(), List.of());
    }

    @ExceptionHandler(AppExceptions.BadRequest.class)
    ResponseEntity<ErrorResponse> bad(AppExceptions.BadRequest e) {
        return build(HttpStatus.BAD_REQUEST, "VALIDATION_ERROR", e.getMessage(), List.of());
    }

    @ExceptionHandler(AppExceptions.Conflict.class)
    ResponseEntity<ErrorResponse> conflict(AppExceptions.Conflict e) {
        return build(HttpStatus.CONFLICT, "CONFLICT", e.getMessage(), List.of());
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    ResponseEntity<ErrorResponse> validation(MethodArgumentNotValidException e) {
        return build(HttpStatus.BAD_REQUEST, "VALIDATION_ERROR", "Invalid request data", e.getBindingResult()
                .getFieldErrors().stream().map(x -> x.getField() + ": " + x.getDefaultMessage()).toList());
    }

    @ExceptionHandler(DataIntegrityViolationException.class)
    ResponseEntity<ErrorResponse> dataIntegrity(DataIntegrityViolationException e) {
        String message = "Could not save imported data. Check category and subcategory lengths (max 120 characters).";
        if (e.getMessage() != null && e.getMessage().contains("character varying")) {
            message = "A value in the import file is too long. Category and subcategory names must be at most 120 characters.";
        }
        return build(HttpStatus.BAD_REQUEST, "VALIDATION_ERROR", message, List.of());
    }

    @ExceptionHandler(Exception.class)
    ResponseEntity<ErrorResponse> generic(Exception e) {
        return build(HttpStatus.INTERNAL_SERVER_ERROR, "INTERNAL_ERROR", "An unexpected error occurred", List.of());
    }

    private ResponseEntity<ErrorResponse> build(HttpStatus s, String err, String msg, List<String> d) {
        return ResponseEntity.status(s).body(new ErrorResponse(Instant.now(), s.value(), err, msg, d));
    }
}
