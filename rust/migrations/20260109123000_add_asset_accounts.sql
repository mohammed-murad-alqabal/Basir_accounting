-- Add account mappings to Asset Categories
ALTER TABLE asset_categories
ADD COLUMN asset_account_id UUID REFERENCES accounts(id);
ALTER TABLE asset_categories
ADD COLUMN depreciation_account_id UUID REFERENCES accounts(id);
ALTER TABLE asset_categories
ADD COLUMN accum_depreciation_account_id UUID REFERENCES accounts(id);
-- Drop legacy account mappings from Fixed Assets (moving to Category level)
-- We drop these because the new FixedAsset model relies on Category for this configuration.
-- If per-asset override is needed later, we can re-add them as nullable columns.
ALTER TABLE fixed_assets DROP COLUMN IF EXISTS asset_account_id;
ALTER TABLE fixed_assets DROP COLUMN IF EXISTS depreciation_account_id;
ALTER TABLE fixed_assets DROP COLUMN IF EXISTS accum_depreciation_account_id;