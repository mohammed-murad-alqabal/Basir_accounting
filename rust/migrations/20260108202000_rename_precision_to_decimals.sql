-- Rename precision to decimals for consistency with accounting domain
ALTER TABLE currencies
  RENAME COLUMN precision TO decimals;