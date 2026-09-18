package com.example.interviewtracker;

import org.junit.jupiter.api.*;

import static org.junit.jupiter.api.Assertions.*;

class QuestionImportServiceTest {

    @Test
    void sanity() {
        assertTrue("Checklist No.".trim().replaceAll("\s+", " ").equals("Checklist No."));
    }
}
