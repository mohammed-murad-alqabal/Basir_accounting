-- Migration for Purchasing and Accounts Payable (AP)
-- 20260104220000_purchasing_ap.sql

-- 1. Vendors Table (Subsidiary Ledger for AP)
CREATE TABLE vendors (
    id UUID PRIMARY KEY,
    code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    tax_id TEXT,
    contact_info TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. Purchase Bills Table (Accounts Payable)
CREATE TABLE purchase_bills (
    id UUID PRIMARY KEY,
    bill_number TEXT NOT NULL UNIQUE,
    vendor_id UUID NOT NULL REFERENCES vendors(id),
    bill_date DATE NOT NULL,
    due_date DATE NOT NULL,
    total_amount DECIMAL(19, 4) NOT NULL,
    balance_due DECIMAL(19, 4) NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('Draft', 'Open', 'PartiallyPaid', 'Paid', 'Cancelled')),
    expense_account_id UUID NOT NULL REFERENCES accounts(id),
    ap_account_id UUID NOT NULL REFERENCES accounts(id),
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3. Bill Payments Table
CREATE TABLE bill_payments (
    id UUID PRIMARY KEY,
    bill_id UUID NOT NULL REFERENCES purchase_bills(id),
    payment_date DATE NOT NULL,
    amount DECIMAL(19, 4) NOT NULL,
    payment_method TEXT NOT NULL,
    bank_account_id UUID NOT NULL REFERENCES accounts(id),
    reference TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 4. Extend Ledger with Partner Traceability
ALTER TABLE journal_entry_lines ADD COLUMN partner_id UUID;

-- 5. Immutability Triggers for Bill Payments
CREATE TRIGGER trg_no_mod_bill_payments
BEFORE UPDATE OR DELETE ON bill_payments
FOR EACH ROW EXECUTE PROCEDURE protect_append_only();

-- 6. Immutability Triggers for Posted Bills
CREATE OR REPLACE FUNCTION protect_purchase_bills()
RETURNS TRIGGER AS $$
BEGIN
    IF (OLD.status != 'Draft') THEN
        IF (TG_OP = 'DELETE') THEN
            RAISE EXCEPTION 'Cannot delete a posted purchase bill. Use cancellation/reversal.';
        END IF;
        
        -- Prevent changing financial totals once posted
        IF (NEW.total_amount != OLD.total_amount OR NEW.vendor_id != OLD.vendor_id) THEN
             RAISE EXCEPTION 'Cannot modify financial totals of a posted purchase bill.';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_protect_purchase_bills
BEFORE UPDATE OR DELETE ON purchase_bills
FOR EACH ROW EXECUTE PROCEDURE protect_purchase_bills();
