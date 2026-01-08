-- Add adjustment entry support (Task 10.4)
ALTER TABLE journal_entries ADD COLUMN linked_entry_id UUID REFERENCES journal_entries(id);
ALTER TABLE journal_entries ADD COLUMN adjustment_reason TEXT;
