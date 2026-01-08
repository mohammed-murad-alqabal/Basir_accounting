-- Add classification to accounts for IFRS 18 support
ALTER TABLE accounts ADD COLUMN classification TEXT;
