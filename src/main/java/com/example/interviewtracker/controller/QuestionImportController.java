package com.example.interviewtracker.controller;

import com.example.interviewtracker.dto.ApiDtos.*;
import com.example.interviewtracker.service.QuestionImportService;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/questions/import")
public class QuestionImportController {

    private final QuestionImportService s;

    public QuestionImportController(QuestionImportService s) {
        this.s = s;
    }

    @PostMapping(value = "/validate", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ImportValidationResponse validate(@RequestPart("file") MultipartFile f) {
        return s.validate(f);
    }

    @PostMapping("/confirm")
    public ImportConfirmResponse confirm(@RequestParam String importId) {
        return s.confirm(importId);
    }
}
