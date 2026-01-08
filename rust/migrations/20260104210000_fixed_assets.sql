-- Migration for Fixed Assets (IAS 16)
CREATE TABLE asset_categories (
    id UUID PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    default_depreciation_method TEXT NOT NULL,
    default_useful_life_years INTEGER NOT NULL
);

CREATE TABLE fixed_assets (
    id UUID PRIMARY KEY,
    code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    category_id UUID NOT NULL REFERENCES asset_categories(id),
    purchase_date TIMESTAMP NOT NULL,
    cost NUMERIC NOT NULL,
    salvage_value NUMERIC NOT NULL,
    useful_life_years INTEGER NOT NULL,
    depreciation_method TEXT NOT NULL,
    accumulated_depreciation NUMERIC NOT NULL DEFAULT 0,
    asset_account_id UUID NOT NULL REFERENCES accounts(id),
    depreciation_account_id UUID NOT NULL REFERENCES accounts(id),
    accum_depreciation_account_id UUID NOT NULL REFERENCES accounts(id),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE asset_depreciation_log (
    id UUID PRIMARY KEY,
    asset_id UUID NOT NULL REFERENCES fixed_assets(id),
    journal_entry_id UUID NOT NULL REFERENCES journal_entries(id),
    amount NUMERIC NOT NULL,
    period_end TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Trigger to prevent direct deletion of assets with historical depreciation
CREATE OR REPLACE FUNCTION prevent_asset_deletion()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM asset_depreciation_log WHERE asset_id = OLD.id) THEN
        RAISE EXCEPTION 'Cannot delete asset with depreciation history. Deactivate it instead.';
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_asset_deletion
BEFORE DELETE ON fixed_assets
FOR EACH ROW
EXECUTE FUNCTION prevent_asset_deletion();
