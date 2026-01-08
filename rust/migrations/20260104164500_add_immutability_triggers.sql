-- Immutability Enforcement (CP-003)

CREATE OR REPLACE FUNCTION prevent_modification()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'Modification of immutable accounting records is strictly forbidden';
END;
$$ LANGUAGE plpgsql;

-- Prevent UPDATE/DELETE on journal_entry_lines (Strictly Append-Only)
CREATE TRIGGER prevent_line_modification
BEFORE UPDATE OR DELETE ON journal_entry_lines
FOR EACH ROW EXECUTE FUNCTION prevent_modification();

-- Note: We do NOT trigger on journal_entries because strict audit logic might update status/hash, 
-- though conceptually they should be immutable except regarding status workflow.
-- Ideally we would have a separate table for status history, but for MVP we allow status updates.
