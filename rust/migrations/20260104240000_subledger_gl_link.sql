-- Add gl_entry_id to link sub-ledgers with General Ledger
-- 20260104240000_subledger_gl_link.sql

-- Sales Invoices
ALTER TABLE sales_invoices ADD COLUMN gl_entry_id UUID REFERENCES journal_entries(id);

-- Customer Payments
ALTER TABLE customer_payments ADD COLUMN gl_entry_id UUID REFERENCES journal_entries(id);

-- Purchase Bills
ALTER TABLE purchase_bills ADD COLUMN gl_entry_id UUID REFERENCES journal_entries(id);

-- Bill Payments
ALTER TABLE bill_payments ADD COLUMN gl_entry_id UUID REFERENCES journal_entries(id);
