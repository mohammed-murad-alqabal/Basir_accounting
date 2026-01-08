-- Migration for Sales and Accounts Receivable (AR)
-- 20260104230000_sales_ar.sql

-- 1. Customers Table (Subsidiary Ledger for AR)
CREATE TABLE customers (
    id UUID PRIMARY KEY,
    code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    tax_id TEXT,
    contact_info TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. Sales Invoices Table (Accounts Receivable)
CREATE TABLE sales_invoices (
    id UUID PRIMARY KEY,
    invoice_number TEXT NOT NULL UNIQUE,
    customer_id UUID NOT NULL REFERENCES customers(id),
    invoice_date DATE NOT NULL,
    due_date DATE NOT NULL,
    total_amount DECIMAL(19, 4) NOT NULL,
    balance_due DECIMAL(19, 4) NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('Draft', 'Posted', 'PartiallyPaid', 'Paid', 'Cancelled')),
    income_account_id UUID NOT NULL REFERENCES accounts(id),
    ar_account_id UUID NOT NULL REFERENCES accounts(id),
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3. Sales Invoice Lines Table
CREATE TABLE sales_invoice_lines (
    id UUID PRIMARY KEY,
    invoice_id UUID NOT NULL REFERENCES sales_invoices(id) ON DELETE CASCADE,
    product_id UUID,
    description TEXT NOT NULL,
    quantity DECIMAL(19, 4) NOT NULL,
    unit_price DECIMAL(19, 4) NOT NULL,
    tax_amount DECIMAL(19, 4) NOT NULL,
    total_amount DECIMAL(19, 4) NOT NULL
);

-- 4. Customer Payments Table (Receipts)
CREATE TABLE customer_payments (
    id UUID PRIMARY KEY,
    invoice_id UUID NOT NULL REFERENCES sales_invoices(id),
    payment_date DATE NOT NULL,
    amount DECIMAL(19, 4) NOT NULL,
    payment_method TEXT NOT NULL,
    bank_account_id UUID NOT NULL REFERENCES accounts(id),
    reference TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 5. Immutability Triggers for Customer Payments
CREATE TRIGGER trg_no_mod_customer_payments
BEFORE UPDATE OR DELETE ON customer_payments
FOR EACH ROW EXECUTE PROCEDURE protect_append_only();

-- 6. Immutability Triggers for Posted Invoices
CREATE OR REPLACE FUNCTION protect_sales_invoices()
RETURNS TRIGGER AS $$
BEGIN
    IF (OLD.status != 'Draft') THEN
        IF (TG_OP = 'DELETE') THEN
            RAISE EXCEPTION 'Cannot delete a posted sales invoice. Use cancellation/reversal.';
        END IF;
        
        -- Prevent changing financial totals once posted
        IF (NEW.total_amount != OLD.total_amount OR NEW.customer_id != OLD.customer_id) THEN
             RAISE EXCEPTION 'Cannot modify financial totals of a posted sales invoice.';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_protect_sales_invoices
BEFORE UPDATE OR DELETE ON sales_invoices
FOR EACH ROW EXECUTE PROCEDURE protect_sales_invoices();
