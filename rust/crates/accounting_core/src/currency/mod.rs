//! Currency and Exchange Rate Models (IAS 21)
//!
//! # Requirements Alignment
//! - Req 3.5: Multi-Currency Support (IAS 21)

use serde::{Deserialize, Serialize};
use rust_decimal::Decimal;
use chrono::NaiveDate;
use uuid::Uuid;

/// Represents a currency (ISO 4217)
#[derive(Debug, Clone, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub struct Currency {
    /// ISO 4217 code (e.g., "SAR", "USD")
    pub code: String,
    /// Human-readable name
    pub name: String,
    /// Number of decimal places (e.g., 2 for USD, 3 for JOD)
    pub decimals: u8,
}

/// Represents an exchange rate between two currencies
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ExchangeRate {
    pub id: Uuid,
    pub base_currency: String,
    pub target_currency: String,
    pub rate: Decimal,
    pub effective_date: NaiveDate,
    pub source: Option<String>,
}

impl ExchangeRate {
    pub fn new(
        base: impl Into<String>,
        target: impl Into<String>,
        rate: Decimal,
        date: NaiveDate,
    ) -> Self {
        Self {
            id: Uuid::new_v4(),
            base_currency: base.into(),
            target_currency: target.into(),
            rate,
            effective_date: date,
            source: None,
        }
    }

    /// Converts an amount from target to base currency using this rate.
    /// Formula: Base = Target * Rate
    pub fn convert_to_base(&self, amount: Decimal) -> Decimal {
        (amount * self.rate).round_dp(10)
    }

    /// Converts an amount from base to target currency.
    /// Formula: Target = Base / Rate
    pub fn convert_from_base(&self, amount: Decimal) -> Decimal {
        if self.rate.is_zero() {
            Decimal::ZERO
        } else {
            (amount / self.rate).round_dp(10)
        }
    }
}
