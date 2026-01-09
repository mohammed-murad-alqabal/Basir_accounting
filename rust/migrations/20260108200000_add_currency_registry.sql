-- Currency Registry (IAS 21)
CREATE TABLE currencies (
  code TEXT PRIMARY KEY,
  -- ISO 4217 (e.g., 'SAR', 'USD', 'EUR')
  name TEXT NOT NULL,
  symbol TEXT,
  precision INTEGER NOT NULL DEFAULT 2,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  is_functional BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);
-- Initial currencies
INSERT INTO currencies (code, name, symbol, precision, is_functional)
VALUES ('SAR', 'Saudi Riyal', 'ر.س', 2, TRUE),
  ('USD', 'US Dollar', '$', 2, FALSE),
  ('EUR', 'Euro', '€', 2, FALSE),
  ('GBP', 'British Pound', '£', 2, FALSE);
-- Ensure only one functional currency
CREATE UNIQUE INDEX idx_functional_currency ON currencies (is_functional)
WHERE is_functional = TRUE;