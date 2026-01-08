-- Create Inventory Management Tables

CREATE TABLE inventory_items (
    id UUID PRIMARY KEY,
    code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    unit TEXT NOT NULL,
    valuation_method TEXT NOT NULL, -- 'Fifo', 'WeightedAverage'
    asset_account_id UUID NOT NULL REFERENCES accounts(id),
    cogs_account_id UUID NOT NULL REFERENCES accounts(id),
    revenue_account_id UUID NOT NULL REFERENCES accounts(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE stock_movements (
    id UUID PRIMARY KEY,
    item_id UUID NOT NULL REFERENCES inventory_items(id),
    movement_type TEXT NOT NULL, -- 'Inbound', 'Outbound', 'Adjustment'
    quantity DECIMAL(19, 4) NOT NULL,
    unit_cost DECIMAL(19, 4) NOT NULL,
    date TIMESTAMPTZ NOT NULL,
    reference_id UUID, -- Link to journal_entries(id) or other documents
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Trigger for stock movements (Append-only)
CREATE OR REPLACE FUNCTION protect_stock_movements()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'UPDATE' OR TG_OP = 'DELETE') THEN
        RAISE EXCEPTION 'Stock movements are immutable. Use adjustment movements instead.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER stock_movements_immutability
BEFORE UPDATE OR DELETE ON stock_movements
FOR EACH ROW EXECUTE FUNCTION protect_stock_movements();
