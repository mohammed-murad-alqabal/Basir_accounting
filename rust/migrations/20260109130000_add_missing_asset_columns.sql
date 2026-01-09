-- Add is_active to fixed_assets if not exists
ALTER TABLE fixed_assets
ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT TRUE;
-- Add entry_id to depreciation_history if not exists
ALTER TABLE depreciation_history
ADD COLUMN IF NOT EXISTS entry_id UUID;