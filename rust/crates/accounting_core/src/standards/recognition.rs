//! Recognition Logic (IFRS CF Chapter 5)
//!
//! Provides structured models and helpers for recognizing financial items,
//! ensuring compliance with the IFRS Conceptual Framework and IFRS 15.

use crate::ledger::models::StandardsJustification;
use crate::standards::models::{MeasurementBasis, RecognitionBasis};
use serde::{Deserialize, Serialize};

/// The IFRS 15 Five-Step Model for revenue recognition.
///
/// This model ensures that revenue is only recognized when all criteria
/// from IFRS 15 are met.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Ifrs15StepModel {
    /// Step 1: Identify the contract(s) with a customer
    pub contract_identified: bool,
    /// Step 2: Identify the performance obligations in the contract
    pub performance_obligations_identified: bool,
    /// Step 3: Determine the transaction price
    pub transaction_price_determined: bool,
    /// Step 4: Allocate the transaction price to the performance obligations
    pub price_allocated: bool,
    /// Step 5: Recognize revenue when (or as) the entity satisfies a performance obligation
    pub revenue_recognized_on_transfer: bool,
}

impl Ifrs15StepModel {
    /// Check if all 5 steps are complete.
    pub fn is_complete(&self) -> bool {
        self.contract_identified
            && self.performance_obligations_identified
            && self.transaction_price_determined
            && self.price_allocated
            && self.revenue_recognized_on_transfer
    }

    /// Generate a professional judgment summary based on the steps.
    pub fn to_judgment_summary(&self) -> String {
        let mut summary = Vec::new();
        if self.contract_identified {
            summary.push("Contract verified");
        }
        if self.performance_obligations_identified {
            summary.push("Performance obligations defined");
        }
        if self.transaction_price_determined {
            summary.push("Transaction price confirmed");
        }
        if self.price_allocated {
            summary.push("Allocation complete");
        }
        if self.revenue_recognized_on_transfer {
            summary.push("Control transferred to customer");
        }

        summary.join("; ")
    }
}

/// Helper for generating IFRS 15 compliant justifications.
pub struct Ifrs15Helper;

impl Ifrs15Helper {
    /// Create a StandardsJustification for revenue recognition.
    ///
    /// # Arguments
    /// * `paragraph` - The specific paragraph (e.g., "35" for over-time or "38" for point-in-time)
    /// * `steps` - The IFRS 15 step model status
    pub fn recognize_revenue(paragraph: &str, steps: &Ifrs15StepModel) -> StandardsJustification {
        let mut judgment = steps.to_judgment_summary();
        if !steps.is_complete() {
            judgment = format!("WARNING: Incomplete IFRS 15 Model - {}", judgment);
        }

        StandardsJustification {
            standard_reference: format!("IFRS 15.{}", paragraph),
            recognition_basis: Some(RecognitionBasis::Accrual),
            measurement_basis: Some(MeasurementBasis::HistoricalCost),
            professional_judgment: Some(judgment),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_ifrs_15_step_model_completeness() {
        let steps = Ifrs15StepModel {
            contract_identified: true,
            performance_obligations_identified: true,
            transaction_price_determined: true,
            price_allocated: true,
            revenue_recognized_on_transfer: true,
        };
        assert!(steps.is_complete());
        assert!(steps.to_judgment_summary().contains("Control transferred"));
    }

    #[test]
    fn test_ifrs15_helper_incomplete_warning() {
        let steps = Ifrs15StepModel {
            contract_identified: true,
            performance_obligations_identified: false,
            transaction_price_determined: false,
            price_allocated: false,
            revenue_recognized_on_transfer: false,
        };
        let sj = Ifrs15Helper::recognize_revenue("35", &steps);
        assert!(sj.professional_judgment.unwrap().contains("WARNING"));
    }
}
