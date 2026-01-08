-- Add ZATCA Phase 2 compliance columns to sales_invoices table

ALTER TABLE sales_invoices
ADD COLUMN zatca_uuid UUID,
ADD COLUMN zatca_hash TEXT,
ADD COLUMN zatca_previous_hash TEXT,
ADD COLUMN xml_content TEXT,
ADD COLUMN qr_code_data TEXT;

-- Create an index on ZATCA UUID for lookups
CREATE INDEX idx_sales_invoices_zatca_uuid ON sales_invoices(zatca_uuid);
