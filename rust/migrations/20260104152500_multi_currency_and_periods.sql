-- Exchange Rates (IAS 21)
CREATE TABLE exchange_rates (
    id UUID PRIMARY KEY,
    base_currency TEXT NOT NULL, -- usually the functional currency (e.g., SAR)
    target_currency TEXT NOT NULL, -- (e.g., USD)
    rate DECIMAL(20, 10) NOT NULL,
    effective_date DATE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    source TEXT, -- (e.g., 'SAMA', 'ECB', 'Manual')
    
    UNIQUE (base_currency, target_currency, effective_date)
);

-- Financial Periods
CREATE TABLE financial_periods (
    id UUID PRIMARY KEY,
    name TEXT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status TEXT NOT NULL DEFAULT 'Open', -- Open, Locked, Closed
    is_year_end BOOLEAN NOT NULL DEFAULT FALSE,
    closed_at TIMESTAMP,
    closed_by TEXT,
    
    CHECK (start_date <= end_date)
);

-- Add currency support to accounts
ALTER TABLE accounts ADD COLUMN currency TEXT;

-- Add multi-currency fields to journal entry lines
ALTER TABLE journal_entry_lines ADD COLUMN original_currency TEXT;
ALTER TABLE journal_entry_lines ADD COLUMN exchange_rate DECIMAL(20, 10);
ALTER TABLE journal_entry_lines ADD COLUMN original_amount DECIMAL(20, 4);

-- Trigger to prevent modification of closed periods (to be added to ledger tables)
CREATE OR REPLACE FUNCTION check_period_status() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM financial_periods 
        WHERE (status = 'Locked' OR status = 'Closed')
          AND (NEW.effective_date >= start_date AND NEW.effective_date <= end_date)
    ) THEN
        RAISE EXCEPTION 'Cannot post to a locked or closed financial period (%)', NEW.effective_date;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply period check to journal entries
CREATE TRIGGER trg_check_period_on_entry
BEFORE INSERT OR UPDATE ON journal_entries
FOR EACH ROW EXECUTE PROCEDURE check_period_status();

-- Note: We use effective_date for financial period compliance.
