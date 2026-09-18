# One-More-Revision
One More Revision
# Interview Knowledge Tracker — Backend

Java 17 / Spring Boot 3.5 / Spring Security JWT / PostgreSQL / Flyway / Apache POI.

## Architecture
Modular monolith using controller → service → repository layers. REST DTOs keep JPA entities out of the API. Question Bank, study tracking, and Workspace Notes are separate responsibilities.

## Prerequisites
- JDK 17+
- Maven 3.9+ (or generate/use Maven Wrapper)
- PostgreSQL 15+

## Local setup
1. Start PostgreSQL and create `interview_tracker`, or run `docker compose up postgres -d`.
2. Set `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USERNAME`, `DB_PASSWORD`, and a strong `JWT_SECRET` as needed.
3. Run `mvn spring-boot:run`.
4. API starts on `http://localhost:8080`.

Development seed user: `admin@example.com` / `ChangeMe123!`. Change it for any real deployment.

## Docker
`mvn clean package -DskipTests` then `docker compose up --build`.

## REST API
- `POST /api/auth/login`
- `GET /api/auth/me`
- `GET/POST/PUT/DELETE /api/categories`
- `GET /api/categories/{id}/subcategories`
- `POST/PUT/DELETE /api/subcategories`
- `GET/POST/PUT/DELETE /api/questions`
- `PATCH /api/questions/{id}/studied`
- `PATCH /api/questions/{id}/practice-count` with `{ "delta": 1 }` or `{ "delta": -1 }`
- `POST /api/questions/import/validate` multipart `file`
- `POST /api/questions/import/confirm?importId=...`
- `GET/POST/PUT/DELETE /api/workspace-notes`
- `GET /api/dashboard`

All endpoints except login/health require `Authorization: Bearer <JWT>`.

## Excel import
The first worksheet must contain the required columns: `Checklist No.`, `Category`, `Subcategory`, `Question`, `Question Source`, `Question Source URL`, `Answer Source`. `Answer Source URL` is accepted as an optional recognized column. Headers are trimmed, case-insensitive, and whitespace-normalized. The backend detects missing, unexpected and duplicate columns and validates row data before confirmation. Confirmation is transactional.

## Security
Passwords are BCrypt-hashed. JWTs are signed and expire. User identity for Workspace Notes is derived from the authenticated token, not from a frontend-supplied userId. Do not use the development JWT secret or seed password in production.

## Testing
`mvn test`
