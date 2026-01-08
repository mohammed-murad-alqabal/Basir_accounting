-- Rename existing 'name' to 'name_ar' as the primary Arabic name
ALTER TABLE accounts
    RENAME COLUMN name TO name_ar;
-- Add 'name_en' for English name, defaulting to empty string (or copy from ar if preferred, strict empty is safer)
ALTER TABLE accounts
ADD COLUMN name_en TEXT NOT NULL DEFAULT '';
-- Update name_en to be same as name_ar initially to avoid blanks in UI where en is used
UPDATE accounts
SET name_en = name_ar;