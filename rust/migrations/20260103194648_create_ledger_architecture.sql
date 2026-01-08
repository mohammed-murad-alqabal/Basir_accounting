-- Accounts
CREATE TABLE accounts (
    id UUID PRIMARY KEY,
    code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    type TEXT NOT NULL,
    parent_id UUID REFERENCES accounts(id),
    is_leaf BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Journal Entries
CREATE TABLE journal_entries (
    id UUID PRIMARY KEY,
    entry_number TEXT NOT NULL UNIQUE,
    entry_type TEXT NOT NULL,
    status TEXT NOT NULL,
    
    transaction_date DATE NOT NULL,
    effective_date DATE NOT NULL,
    recording_date TIMESTAMP NOT NULL DEFAULT NOW(),
    
    standard_reference TEXT,
    description TEXT NOT NULL,
    
    hash TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Lines
CREATE TABLE journal_entry_lines (
    id UUID PRIMARY KEY,
    entry_id UUID NOT NULL REFERENCES journal_entries(id),
    account_id UUID NOT NULL REFERENCES accounts(id),
    
    description TEXT NOT NULL,
    debit DECIMAL(20, 4) NOT NULL DEFAULT 0,
    credit DECIMAL(20, 4) NOT NULL DEFAULT 0,
    
    CHECK (debit >= 0 AND credit >= 0),
    CHECK (debit > 0 OR credit > 0)
);

-- Audit Log
CREATE TABLE audit_log (
    id UUID PRIMARY KEY,
    timestamp TIMESTAMP NOT NULL DEFAULT NOW(),
    
    user_id TEXT,
    
    entity_type TEXT NOT NULL,
    entity_id UUID NOT NULL,
    action TEXT NOT NULL,
    payload JSONB NOT NULL,
    
    prev_hash TEXT,
    curr_hash TEXT NOT NULL UNIQUE
);

-- Prevent Delete Trigger
CREATE OR REPLACE FUNCTION protect_append_only() RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'Deletion is not allowed on ledger tables';
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_no_del_entries BEFORE DELETE ON journal_entries
FOR EACH ROW EXECUTE PROCEDURE protect_append_only();

CREATE TRIGGER trg_no_del_audit BEFORE DELETE OR UPDATE ON audit_log
FOR EACH ROW EXECUTE PROCEDURE protect_append_only();

-- Protect Journal Entry Lines (No Delete/Update)
CREATE TRIGGER trg_no_mod_lines BEFORE DELETE OR UPDATE ON journal_entry_lines
FOR EACH ROW EXECUTE PROCEDURE protect_append_only();

-- Protect Journal Entries (No Delete; No Update if Posted)
CREATE OR REPLACE FUNCTION protect_posted_entries() RETURNS TRIGGER AS $$
BEGIN
    IF OLD.status = 'Posted' THEN
        RAISE EXCEPTION 'Cannot update a posted journal entry';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_no_upd_posted_entries BEFORE UPDATE ON journal_entries
FOR EACH ROW EXECUTE PROCEDURE protect_posted_entries();
