package com.example.interviewtracker.exception;

public final class AppExceptions {

    private AppExceptions() {
    }

    public static class NotFound extends RuntimeException {

        public NotFound(String m) {
            super(m);
        }
    }

    public static class BadRequest extends RuntimeException {

        public BadRequest(String m) {
            super(m);
        }
    }

    public static class Conflict extends RuntimeException {

        public Conflict(String m) {
            super(m);
        }
    }
}
