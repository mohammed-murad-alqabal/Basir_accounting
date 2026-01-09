-- Refine Asset Categories
ALTER TABLE asset_categories
ADD COLUMN description TEXT;
-- Refine Fixed Assets
ALTER TABLE fixed_assets
  RENAME COLUMN purchase_date TO acquisition_date;
ALTER TABLE fixed_assets
  RENAME COLUMN salvage_value TO residual_value;
ALTER TABLE fixed_assets
ADD COLUMN status TEXT NOT NULL DEFAULT 'Active';
ALTER TABLE fixed_assets
ADD COLUMN description TEXT;
-- Move data from is_active to status (if any exists, though currently empty likely)
UPDATE fixed_assets
SET status = 'Disposed'
WHERE is_active = FALSE;
ALTER TABLE fixed_assets DROP COLUMN is_active;
-- Rename Log table to History
ALTER TABLE asset_depreciation_log
  RENAME TO depreciation_history;
ALTER TABLE depreciation_history
  RENAME COLUMN period_end TO period_end_date;
-- To allow adding start date
ALTER TABLE depreciation_history
ADD COLUMN period_start_date DATE NOT NULL DEFAULT CURRENT_DATE;
-- Fix timestamps to dates where appropriate if needed, but keeping timestamps is fine if logic handles it. 
-- My Rust models use NaiveDate, so casting might be needed in queries or changing column types.
-- Changing to DATE for standard alignment.
ALTER TABLE fixed_assets
ALTER COLUMN acquisition_date TYPE DATE;
ALTER TABLE depreciation_history
ALTER COLUMN period_end_date TYPE DATE;