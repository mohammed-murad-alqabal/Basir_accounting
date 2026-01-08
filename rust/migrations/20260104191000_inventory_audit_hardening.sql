-- Inventory Audit Hardening: Cryptographic Hash Chain for Stock Movements

ALTER TABLE stock_movements 
ADD COLUMN hash TEXT NOT NULL DEFAULT '',
ADD COLUMN previous_hash TEXT NOT NULL DEFAULT '';

-- Update existing movements (if any) to have a basic hash or a reference
-- (In MVP context, usually empty is fine for previous data or we can re-hash)

-- Note: The protection trigger already exists and will prevent tampering.
-- We keep hash validation at the application/Rust level.
