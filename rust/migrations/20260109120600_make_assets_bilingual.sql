-- Migration to support bilingual names for assets and categories
-- Update asset_categories
ALTER TABLE asset_categories
ADD COLUMN IF NOT EXISTS name_ar TEXT NOT NULL DEFAULT '';
ALTER TABLE asset_categories
ADD COLUMN IF NOT EXISTS name_en TEXT NOT NULL DEFAULT '';
-- Migrate existing data (fallback to name if it exists)
DO $$ BEGIN IF EXISTS (
  SELECT 1
  FROM information_schema.columns
  WHERE table_name = 'asset_categories'
    AND column_name = 'name'
) THEN
UPDATE asset_categories
SET name_ar = name,
  name_en = name
WHERE name_ar = ''
  AND name_en = '';
END IF;
END $$;
ALTER TABLE asset_categories DROP COLUMN IF EXISTS name;
-- Update fixed_assets
ALTER TABLE fixed_assets
ADD COLUMN IF NOT EXISTS name_ar TEXT NOT NULL DEFAULT '';
ALTER TABLE fixed_assets
ADD COLUMN IF NOT EXISTS name_en TEXT NOT NULL DEFAULT '';
-- Migrate existing data
DO $$ BEGIN IF EXISTS (
  SELECT 1
  FROM information_schema.columns
  WHERE table_name = 'fixed_assets'
    AND column_name = 'name'
) THEN
UPDATE fixed_assets
SET name_ar = name,
  name_en = name
WHERE name_ar = ''
  AND name_en = '';
END IF;
END $$;
ALTER TABLE fixed_assets DROP COLUMN IF EXISTS name;