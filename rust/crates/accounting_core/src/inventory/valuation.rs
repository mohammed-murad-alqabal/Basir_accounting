use crate::inventory::models::{MovementType, StockMovement, ValuationMethod};
use rust_decimal::Decimal;
use thiserror::Error;
use uuid::Uuid;

#[derive(Error, Debug)]
pub enum InventoryError {
    #[error("Insufficient stock for item {0}: requested {1}, available {2}")]
    InsufficientStock(Uuid, Decimal, Decimal),
    #[error("No inventory history found for item {0}")]
    NoHistory(Uuid),
}

pub trait InventoryValuator {
    fn calculate_cogs(
        &self,
        item_id: Uuid,
        quantity: Decimal,
        movements: &[StockMovement],
    ) -> Result<Decimal, InventoryError>;
}

pub struct FifoValuator;

impl InventoryValuator for FifoValuator {
    fn calculate_cogs(
        &self,
        item_id: Uuid,
        quantity: Decimal,
        movements: &[StockMovement],
    ) -> Result<Decimal, InventoryError> {
        let mut sorted_movements = movements.to_vec();
        sorted_movements.sort_by_key(|m| m.date);

        let mut lots: Vec<(Decimal, Decimal)> = Vec::new(); // Each entry is (remaining_qty, unit_cost)

        for m in &sorted_movements {
            match m.movement_type {
                MovementType::Inbound => {
                    lots.push((m.quantity, m.unit_cost));
                }
                MovementType::Outbound => {
                    let mut to_consume = m.quantity;
                    for (lot_qty, _) in lots.iter_mut() {
                        if *lot_qty <= Decimal::ZERO {
                            continue;
                        }
                        let take = to_consume.min(*lot_qty);
                        *lot_qty -= take;
                        to_consume -= take;
                        if to_consume <= Decimal::ZERO {
                            break;
                        }
                    }
                }
                MovementType::Adjustment => {
                    if m.quantity > Decimal::ZERO {
                        lots.push((m.quantity, m.unit_cost));
                    } else {
                        let mut to_consume = m.quantity.abs();
                        for (lot_qty, _) in lots.iter_mut().rev() {
                            // Adjustments consume from the latest lot or first? Usually latest.
                            if *lot_qty <= Decimal::ZERO {
                                continue;
                            }
                            let take = to_consume.min(*lot_qty);
                            *lot_qty -= take;
                            to_consume -= take;
                            if to_consume <= Decimal::ZERO {
                                break;
                            }
                        }
                    }
                }
                MovementType::Impairment => {
                    // Reduce unit cost of all existing lots proportionally
                    let total_qty: Decimal = lots.iter().map(|(q, _)| *q).sum();
                    if total_qty > Decimal::ZERO {
                        let impairment_per_unit = m.unit_cost / total_qty;
                        for (lot_qty, unit_cost) in lots.iter_mut() {
                            if *lot_qty > Decimal::ZERO {
                                *unit_cost += impairment_per_unit; // m.unit_cost is negative for impairment
                            }
                        }
                    }
                }
            }
        }

        // Now calculate COGS for the requested quantity from the current state of lots
        let mut remaining_to_consume = quantity;
        let mut total_cost = Decimal::ZERO;

        for (lot_qty, unit_cost) in lots {
            if lot_qty <= Decimal::ZERO {
                continue;
            }
            let take = remaining_to_consume.min(lot_qty);
            total_cost += take * unit_cost;
            remaining_to_consume -= take;
            if remaining_to_consume <= Decimal::ZERO {
                break;
            }
        }

        if remaining_to_consume > Decimal::ZERO {
            // Check if we have enough stock including adjustments
            let total_available: Decimal = movements
                .iter()
                .map(|m| match m.movement_type {
                    MovementType::Inbound => m.quantity,
                    MovementType::Outbound => -m.quantity,
                    MovementType::Adjustment => m.quantity,
                    MovementType::Impairment => Decimal::ZERO,
                })
                .sum();

            return Err(InventoryError::InsufficientStock(
                item_id,
                quantity,
                total_available,
            ));
        }

        Ok(total_cost)
    }
}

pub struct WeightedAverageValuator;

impl InventoryValuator for WeightedAverageValuator {
    fn calculate_cogs(
        &self,
        item_id: Uuid,
        quantity: Decimal,
        movements: &[StockMovement],
    ) -> Result<Decimal, InventoryError> {
        let mut sorted_movements = movements.to_vec();
        sorted_movements.sort_by_key(|m| m.date);

        let mut total_qty = Decimal::ZERO;
        let mut total_cost_basis = Decimal::ZERO;

        for m in sorted_movements {
            match m.movement_type {
                MovementType::Inbound => {
                    total_qty += m.quantity;
                    total_cost_basis += (m.quantity * m.unit_cost).round_dp(6);
                }
                MovementType::Outbound => {
                    if total_qty > Decimal::ZERO {
                        let avg_cost = (total_cost_basis / total_qty).round_dp(6);
                        total_qty -= m.quantity;
                        total_cost_basis -= (m.quantity * avg_cost).round_dp(6);
                    }
                }
                MovementType::Adjustment => {
                    total_qty += m.quantity;
                    total_cost_basis += (m.quantity * m.unit_cost).round_dp(6);
                }
                MovementType::Impairment => {
                    // Impairment reduces the cost basis but DOES NOT change quantity.
                    // m.quantity should be zero, m.unit_cost is the total impairment amount per unit (negative)
                    // or just use total_cost_basis -= m.unit_cost if quantity is 0?
                    // Let's assume m.unit_cost is the negative total impairment value for the item.
                    total_cost_basis += m.unit_cost.round_dp(6);
                }
            }
        }

        if total_qty < quantity {
            return Err(InventoryError::InsufficientStock(
                item_id, quantity, total_qty,
            ));
        }

        if total_qty <= Decimal::ZERO {
            return Ok(Decimal::ZERO);
        }

        let final_avg_cost = (total_cost_basis / total_qty).round_dp(6);
        Ok((quantity * final_avg_cost).round_dp(4))
    }
}

pub fn get_valuator(method: ValuationMethod) -> Box<dyn InventoryValuator> {
    match method {
        ValuationMethod::Fifo => Box::new(FifoValuator),
        ValuationMethod::WeightedAverage => Box::new(WeightedAverageValuator),
    }
}
