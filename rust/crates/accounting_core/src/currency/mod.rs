//! Currency and Exchange Rate Models (IAS 21)
//!
//! # Requirements Alignment
//! - Req 3.5: Multi-Currency Support (IAS 21)

use chrono::NaiveDate;
use rust_decimal::Decimal;
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use thiserror::Error;
use uuid::Uuid;

#[derive(Debug, Error)]
pub enum CurrencyError {
    #[error("Currency not found: {0}")]
    NotFound(String),
    #[error("Invalid exchange rate: {0}")]
    InvalidRate(Decimal),
    #[error("Conversion error: {0}")]
    ConversionError(String),
}

/// Represents a currency (ISO 4217)
#[derive(Debug, Clone, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub struct Currency {
    /// ISO 4217 code (e.g., "SAR", "USD")
    pub code: String,
    /// Human-readable name
    pub name: String,
    /// Number of decimal places (e.g., 2 for USD, 3 for JOD)
    pub decimals: u8,
    /// Optional symbol (e.g., "$", "ر.س")
    pub symbol: Option<String>,
    /// Whether this currency is available for new transactions
    pub is_active: bool,
    /// Whether this is the system's functional currency
    pub is_functional: bool,
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
        source: Option<String>,
    ) -> Result<Self, CurrencyError> {
        if rate <= Decimal::ZERO {
            return Err(CurrencyError::InvalidRate(rate));
        }

        Ok(Self {
            id: Uuid::new_v4(),
            base_currency: base.into(),
            target_currency: target.into(),
            rate,
            effective_date: date,
            source,
        })
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

/// Registry of valid currencies in the system
#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct CurrencyRegistry {
    currencies: HashMap<String, Currency>,
    functional_currency: String,
}

impl CurrencyRegistry {
    pub fn new(functional: &str) -> Self {
        Self {
            currencies: HashMap::new(),
            functional_currency: functional.to_string(),
        }
    }

    pub fn register(&mut self, currency: Currency) {
        self.currencies.insert(currency.code.clone(), currency);
    }

    pub fn get(&self, code: &str) -> Result<&Currency, CurrencyError> {
        self.currencies
            .get(code)
            .ok_or_else(|| CurrencyError::NotFound(code.to_string()))
    }

    pub fn functional_currency(&self) -> &str {
        &self.functional_currency
    }

    pub fn is_functional(&self, code: &str) -> bool {
        self.functional_currency == code
    }
}

pub mod service;
