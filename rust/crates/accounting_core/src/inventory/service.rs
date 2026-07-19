use crate::inventory::models::{InventoryItem, MovementType, StockMovement};
use crate::inventory::valuation::{get_valuator, InventoryError};
use crate::ledger::models::{
    EntryStatus, EntryType, JournalEntry, JournalEntryLine, StandardsJustification,
    TemporalJustification,
};
use chrono::{DateTime, Utc};
use rust_decimal::Decimal;
use uuid::Uuid;

pub struct InventoryService;

impl InventoryService {
    pub fn calculate_cogs(
        item: &InventoryItem,
        quantity: Decimal,
        movements: &[StockMovement],
    ) -> Result<Decimal, InventoryError> {
        let valuator = get_valuator(item.valuation_method);
        valuator.calculate_cogs(item.id, quantity, movements)
    }

    pub fn validate_stock_levels(
        item: &InventoryItem,
        current_movements: &[StockMovement],
        proposed_outbound_qty: Decimal,
    ) -> Result<Option<String>, InventoryError> {
        let (current_qty, _) = Self::calculate_valuation(item, current_movements)?;

        let new_qty = current_qty - proposed_outbound_qty;

        if new_qty < Decimal::ZERO {
            // Return generic error for now as we don't have specific InsufficientStock variant easily accessible here without item_id
            // Actually we do have item.id
            return Err(InventoryError::InsufficientStock(
                item.id,
                proposed_outbound_qty,
                current_qty,
            ));
        }

        if let Some(min) = item.min_stock_level {
            if new_qty < min {
                return Ok(Some(format!(
                    "Warning: Stock level will drop to {} which is below minimum {}",
                    new_qty, min
                )));
            }
        }

        Ok(None)
    }

    pub fn calculate_valuation(
        item: &InventoryItem,
        movements: &[StockMovement],
    ) -> Result<(Decimal, Decimal), InventoryError> {
        let mut total_qty = Decimal::ZERO;
        for m in movements {
            match m.movement_type {
                MovementType::Inbound => total_qty += m.quantity,
                MovementType::Outbound => total_qty -= m.quantity,
                MovementType::Adjustment => {
                    if m.quantity > Decimal::ZERO {
                        total_qty += m.quantity;
                    } else {
                        total_qty -= m.quantity.abs();
                    }
                }
                MovementType::Impairment => {
                    // Impairment does NOT change quantity
                }
            }
        }

        if total_qty <= Decimal::ZERO {
            return Ok((Decimal::ZERO, Decimal::ZERO));
        }

        // The valuation of current stock is (Total Cost of all Inbounds - Total COGS of all Outbounds)
        // Or simply calculate COGS for "Total Inbound Qty - Current Stock"? No, that's confusing.

        // Easier: Total Stock Value = Total Inbound Value - COGS of all sales.
        let mut total_inbound_value = Decimal::ZERO;
        let mut total_outbound_qty = Decimal::ZERO;

        for m in movements {
            match m.movement_type {
                MovementType::Inbound => total_inbound_value += m.quantity * m.unit_cost,
                MovementType::Outbound => total_outbound_qty += m.quantity,
                MovementType::Adjustment => {
                    if m.quantity > Decimal::ZERO {
                        total_inbound_value += m.quantity * m.unit_cost;
                    } else {
                        total_outbound_qty += m.quantity.abs();
                    }
                }
                MovementType::Impairment => {
                    // Impairment reduces the value directly.
                    total_inbound_value += m.unit_cost; // m.unit_cost is negative for impairment
                }
            }
        }

        let cogs = if total_outbound_qty > Decimal::ZERO {
            // Important: We only pass Inbound movements to the valuator
            // because we are calculating the total COGS for all units ever sold.
            let inbound_only: Vec<StockMovement> = movements
                .iter()
                .filter(|m| {
                    matches!(
                        m.movement_type,
                        MovementType::Inbound | MovementType::Adjustment
                    )
                })
                .cloned()
                .collect();
            Self::calculate_cogs(item, total_outbound_qty, &inbound_only)?
        } else {
            Decimal::ZERO
        };

        let current_value = total_inbound_value - cogs;
        Ok((total_qty, current_value))
    }

    pub fn generate_cogs_entry(
        item: &InventoryItem,
        quantity: Decimal,
        cogs_amount: Decimal,
        date: DateTime<Utc>,
        reference_id: Option<Uuid>,
        user_id: Uuid,
    ) -> JournalEntry {
        let mut lines = Vec::new();

        // Debit COGS (Expense)
        lines.push(JournalEntryLine {
            line_id: Uuid::new_v4(),
            line_number: 1,
            account_id: item.cogs_account_id,
            partner_id: None,
            debit_amount: cogs_amount,
            credit_amount: Decimal::ZERO,
            description: format!("COGS for {} units of {}", quantity, item.name_en),
            source_document_ref: reference_id.map(|u| u.to_string()),
            original_currency: None,
            exchange_rate: None,
            original_amount: None,
        });

        // Credit Inventory (Asset)
        lines.push(JournalEntryLine {
            line_id: Uuid::new_v4(),
            line_number: 2,
            account_id: item.asset_account_id,
            partner_id: None,
            debit_amount: Decimal::ZERO,
            credit_amount: cogs_amount,
            description: format!(
                "Inventory reduction for {} units of {}",
                quantity, item.name_en
            ),
            source_document_ref: reference_id.map(|u| u.to_string()),
            original_currency: None,
            exchange_rate: None,
            original_amount: None,
        });

        JournalEntry {
            entry_id: Uuid::new_v4(),
            entry_number: String::new(),
            description: format!("COGS for {} units of {}", quantity, item.name_en),
            entry_type: EntryType::Adjusting,
            status: EntryStatus::Draft,
            linked_entry_id: reference_id,
            adjustment_reason: Some(crate::ledger::models::AdjustmentReason::Correction),
            temporal: TemporalJustification {
                transaction_date: date.date_naive(),
                effective_date: date.date_naive(),
                recording_date: Utc::now(),
            },
            standards: StandardsJustification {
                standard_reference: "IAS 2.10".to_string(),
                recognition_basis: None,
                measurement_basis: None,
                professional_judgment: Some(format!("Auto-generated COGS for {}", item.name_en)),
            },
            lines,
            created_by: user_id,
            created_at: Utc::now(),
            approved_by: None,
            approved_at: None,
            posted_by: None,
            posted_at: None,
            hash: String::new(),
            previous_hash: String::new(),
        }
    }
}
