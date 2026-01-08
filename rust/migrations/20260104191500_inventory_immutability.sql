-- Inventory Immutability Enforcement (CP-003)
-- These triggers ensure that stock movements follow the same strict append-only rules as the main ledger.

-- Prevent UPDATE/DELETE on stock_movements
CREATE TRIGGER prevent_stock_movement_modification
BEFORE UPDATE OR DELETE ON stock_movements
FOR EACH ROW EXECUTE FUNCTION prevent_modification();
