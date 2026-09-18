CREATE TABLE users
(
    id            BIGSERIAL PRIMARY KEY,
    email         VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    display_name  VARCHAR(120) NOT NULL,
    enabled       BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMPTZ  NOT NULL,
    updated_at    TIMESTAMPTZ  NOT NULL
);
CREATE TABLE categories
(
    id         BIGSERIAL PRIMARY KEY,
    name       VARCHAR(120) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ  NOT NULL,
    updated_at TIMESTAMPTZ  NOT NULL
);
CREATE TABLE subcategories
(
    id          BIGSERIAL PRIMARY KEY,
    category_id BIGINT       NOT NULL REFERENCES categories (id),
    name        VARCHAR(120) NOT NULL,
    created_at  TIMESTAMPTZ  NOT NULL,
    updated_at  TIMESTAMPTZ  NOT NULL,
    CONSTRAINT uk_subcategory_category_name UNIQUE (category_id, name)
);
CREATE TABLE questions
(
    id                  BIGSERIAL PRIMARY KEY,
    checklist_no        VARCHAR(80) NOT NULL UNIQUE,
    category_id         BIGINT      NOT NULL REFERENCES categories (id),
    subcategory_id      BIGINT REFERENCES subcategories (id),
    question            TEXT        NOT NULL,
    question_source     VARCHAR(255),
    question_source_url VARCHAR(1000),
    answer_source       VARCHAR(255),
    answer_source_url   VARCHAR(1000),
    studied_before      BOOLEAN     NOT NULL DEFAULT FALSE,
    practice_count      INTEGER     NOT NULL DEFAULT 0,
    created_at          TIMESTAMPTZ NOT NULL,
    updated_at          TIMESTAMPTZ NOT NULL,
    CONSTRAINT ck_practice_count_nonnegative CHECK (practice_count >= 0)
);
CREATE TABLE workspace_notes
(
    id          BIGSERIAL PRIMARY KEY,
    question_id BIGINT      NOT NULL REFERENCES questions (id) ON DELETE CASCADE,
    user_id     BIGINT      NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    answer      TEXT        NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL,
    updated_at  TIMESTAMPTZ NOT NULL,
    CONSTRAINT uk_note_user_question UNIQUE (user_id, question_id)
);
CREATE INDEX idx_questions_category ON questions (category_id);
CREATE INDEX idx_questions_subcategory ON questions (subcategory_id);
CREATE INDEX idx_questions_studied ON questions (studied_before);
CREATE INDEX idx_questions_checklist ON questions (checklist_no);
CREATE INDEX idx_questions_category_subcategory ON questions (category_id, subcategory_id);
CREATE INDEX idx_notes_user ON workspace_notes (user_id);
