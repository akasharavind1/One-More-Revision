ALTER TABLE questions DROP CONSTRAINT IF EXISTS questions_checklist_no_key;
DROP INDEX IF EXISTS idx_questions_checklist;
ALTER TABLE questions DROP COLUMN IF EXISTS checklist_no;
