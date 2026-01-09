use super::{Currency, CurrencyError, CurrencyRegistry};
use rust_decimal::Decimal;
use std::sync::Arc;
use tokio::sync::RwLock;

/// Service for managing currencies and exchange rates.
pub struct ExchangeRateService {
    registry: Arc<RwLock<CurrencyRegistry>>,
    // In a real system, this might also hold a cache of rates or a repository reference.
}

impl ExchangeRateService {
    pub fn new(functional_currency: &str) -> Self {
        Self {
            registry: Arc::new(RwLock::new(CurrencyRegistry::new(functional_currency))),
        }
    }

    /// Register a new currency in the system.
    pub async fn register_currency(&self, currency: Currency) {
        let mut registry: tokio::sync::RwLockWriteGuard<'_, CurrencyRegistry> =
            self.registry.write().await;
        registry.register(currency);
    }

    /// Register multiple currencies.
    pub async fn register_currencies(&self, currencies: Vec<Currency>) {
        let mut registry: tokio::sync::RwLockWriteGuard<'_, CurrencyRegistry> =
            self.registry.write().await;
        for currency in currencies {
            registry.register(currency);
        }
    }

    /// Convert an amount from foreign currency to functional currency.
    pub async fn to_functional(
        &self,
        amount_fc: Decimal,
        currency_code: &str,
        rate: Decimal,
    ) -> Result<Decimal, CurrencyError> {
        let registry: tokio::sync::RwLockReadGuard<'_, CurrencyRegistry> =
            self.registry.read().await;

        // Ensure currency is registered
        registry.get(currency_code)?;

        // If it's already functional currency, rate must be 1.0 (or just return amount)
        if registry.is_functional(currency_code) {
            return Ok(amount_fc);
        }

        if rate <= Decimal::ZERO {
            return Err(CurrencyError::InvalidRate(rate));
        }

        // Functional = FC * Rate
        Ok((amount_fc * rate).round_dp(10))
    }

    /// Check if a currency is the system's functional currency.
    pub async fn is_functional(&self, code: &str) -> bool {
        self.registry.read().await.is_functional(code)
    }
}
