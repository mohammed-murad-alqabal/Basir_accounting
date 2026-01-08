-- Migration to localize names for inventory, partners, and assets
-- 20260107230000_localize_entities_bilingual.sql
-- 1. Inventory Items
ALTER TABLE inventory_items
    RENAME COLUMN name TO name_ar;
ALTER TABLE inventory_items
ADD COLUMN name_en TEXT NOT NULL DEFAULT '';
ALTER TABLE inventory_items
ALTER COLUMN name_en DROP DEFAULT;
-- 2. Customers
ALTER TABLE customers
    RENAME COLUMN name TO name_ar;
ALTER TABLE customers
ADD COLUMN name_en TEXT NOT NULL DEFAULT '';
ALTER TABLE customers
ALTER COLUMN name_en DROP DEFAULT;
-- 3. Vendors
ALTER TABLE vendors
    RENAME COLUMN name TO name_ar;
ALTER TABLE vendors
ADD COLUMN name_en TEXT NOT NULL DEFAULT '';
ALTER TABLE vendors
ALTER COLUMN name_en DROP DEFAULT;
-- 4. Fixed Assets
ALTER TABLE fixed_assets
    RENAME COLUMN name TO name_ar;
ALTER TABLE fixed_assets
ADD COLUMN name_en TEXT NOT NULL DEFAULT '';
ALTER TABLE fixed_assets
ALTER COLUMN name_en DROP DEFAULT;
-- 5. Asset Categories
ALTER TABLE asset_categories
    RENAME COLUMN name TO name_ar;
ALTER TABLE asset_categories
ADD COLUMN name_en TEXT NOT NULL DEFAULT '';
ALTER TABLE asset_categories
ALTER COLUMN name_en DROP DEFAULT;