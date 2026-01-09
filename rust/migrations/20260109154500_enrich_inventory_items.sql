-- Migration to enrich inventory items with more fields
-- 20260109154500_enrich_inventory_items.sql
ALTER TABLE inventory_items
ADD COLUMN description TEXT,
  ADD COLUMN purchase_price DECIMAL(19, 4),
  ADD COLUMN sale_price DECIMAL(19, 4);