use accounting_core::currency::ExchangeRate;
use chrono::NaiveDate;
use rust_decimal::Decimal;
use sqlx::PgPool;

pub struct PgExchangeRateRepository {
    pool: PgPool,
}

impl PgExchangeRateRepository {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }

    pub async fn save_rate(&self, rate: &ExchangeRate) -> Result<(), anyhow::Error> {
        sqlx::query!(
            r#"
            INSERT INTO exchange_rates (id, base_currency, target_currency, rate, effective_date, source)
            VALUES ($1, $2, $3, $4, $5, $6)
            ON CONFLICT (base_currency, target_currency, effective_date) DO UPDATE SET
                rate = EXCLUDED.rate,
                source = EXCLUDED.source
            "#,
            rate.id,
            rate.base_currency,
            rate.target_currency,
            rate.rate,
            rate.effective_date,
            rate.source
        )
        .execute(&self.pool)
        .await?;

        Ok(())
    }

    pub async fn get_rate(
        &self,
        base: &str,
        target: &str,
        date: NaiveDate,
    ) -> Result<Option<ExchangeRate>, anyhow::Error> {
        let row = sqlx::query!(
            r#"
            SELECT id, base_currency, target_currency, rate, effective_date, source
            FROM exchange_rates
            WHERE base_currency = $1 AND target_currency = $2 AND effective_date <= $3
            ORDER BY effective_date DESC
            LIMIT 1
            "#,
            base,
            target,
            date
        )
        .fetch_optional(&self.pool)
        .await?;

        Ok(row.map(|r| ExchangeRate {
            id: r.id,
            base_currency: r.base_currency,
            target_currency: r.target_currency,
            rate: r.rate,
            effective_date: r.effective_date,
            source: r.source,
        }))
    }

    pub async fn list_rates(
        &self,
        base: Option<&str>,
        target: Option<&str>,
    ) -> Result<Vec<ExchangeRate>, anyhow::Error> {
        let rows = sqlx::query!(
            r#"
            SELECT id, base_currency, target_currency, rate, effective_date, source
            FROM exchange_rates
            WHERE ($1::text IS NULL OR base_currency = $1)
              AND ($2::text IS NULL OR target_currency = $2)
            ORDER BY effective_date DESC
            "#,
            base,
            target
        )
        .fetch_all(&self.pool)
        .await?;

        Ok(rows
            .into_iter()
            .map(|r| ExchangeRate {
                id: r.id,
                base_currency: r.base_currency,
                target_currency: r.target_currency,
                rate: r.rate,
                effective_date: r.effective_date,
                source: r.source,
            })
            .collect())
    }

    /// Calculates unrealized gains/losses for all accounts with foreign currency balances.
    pub async fn calculate_revaluation_adjustments(
        &self,
        as_of_date: NaiveDate,
        system_base: &str,
    ) -> Result<Vec<RevaluationAdjustment>, anyhow::Error> {
        let rows = sqlx::query!(
            r#"
            SELECT 
                l.account_id,
                l.original_currency as "original_currency!",
                SUM(l.original_amount) as "foreign_balance!: Decimal",
                SUM(l.debit - l.credit) as "book_value!: Decimal"
            FROM journal_entry_lines l
            JOIN journal_entries e ON l.entry_id = e.id
            WHERE l.original_currency IS NOT NULL 
              AND e.effective_date <= $1
              AND e.status = 'Posted'
            GROUP BY l.account_id, l.original_currency
            HAVING SUM(l.original_amount) != 0
            "#,
            as_of_date
        )
        .fetch_all(&self.pool)
        .await?;

        let mut adjustments = Vec::new();

        for row in rows {
            if row.original_currency == system_base {
                continue;
            }

            let rate_opt = self
                .get_rate(&row.original_currency, system_base, as_of_date)
                .await?;

            if let Some(rate_obj) = rate_opt {
                let market_value = row.foreign_balance * rate_obj.rate;
                let adjustment_amount = market_value - row.book_value;

                if !adjustment_amount.is_zero() {
                    adjustments.push(RevaluationAdjustment {
                        account_id: row.account_id,
                        original_currency: row.original_currency,
                        foreign_balance: row.foreign_balance,
                        book_value: row.book_value,
                        market_value,
                        adjustment_amount,
                        exchange_rate: rate_obj.rate,
                    });
                }
            }
        }

        Ok(adjustments)
    }

    pub async fn save_currency(
        &self,
        currency: &accounting_core::currency::Currency,
    ) -> anyhow::Result<()> {
        sqlx::query!(
            r#"
            INSERT INTO currencies (code, name, symbol, decimals, is_active, is_functional)
            VALUES ($1, $2, $3, $4, $5, $6)
            ON CONFLICT (code) DO UPDATE SET
                name = EXCLUDED.name,
                symbol = EXCLUDED.symbol,
                decimals = EXCLUDED.decimals,
                is_active = EXCLUDED.is_active,
                is_functional = EXCLUDED.is_functional
            "#,
            currency.code,
            currency.name,
            currency.symbol,
            currency.decimals as i32,
            currency.is_active,
            currency.is_functional
        )
        .execute(&self.pool)
        .await?;
        Ok(())
    }

    pub async fn get_currency(
        &self,
        code: &str,
    ) -> anyhow::Result<Option<accounting_core::currency::Currency>> {
        let row = sqlx::query!(
            r#"
            SELECT code, name, symbol, decimals, is_active, is_functional
            FROM currencies
            WHERE code = $1
            "#,
            code
        )
        .fetch_optional(&self.pool)
        .await?;

        Ok(row.map(|r| accounting_core::currency::Currency {
            code: r.code,
            name: r.name,
            symbol: r.symbol,
            decimals: r.decimals as u8,
            is_active: r.is_active,
            is_functional: r.is_functional,
        }))
    }

    pub async fn list_currencies(
        &self,
    ) -> anyhow::Result<Vec<accounting_core::currency::Currency>> {
        let rows = sqlx::query!(
            r#"
            SELECT code, name, symbol, decimals, is_active, is_functional
            FROM currencies
            ORDER BY code ASC
            "#
        )
        .fetch_all(&self.pool)
        .await?;

        Ok(rows
            .into_iter()
            .map(|r| accounting_core::currency::Currency {
                code: r.code,
                name: r.name,
                symbol: r.symbol,
                decimals: r.decimals as u8,
                is_active: r.is_active,
                is_functional: r.is_functional,
            })
            .collect())
    }
}

pub struct RevaluationAdjustment {
    pub account_id: uuid::Uuid,
    pub original_currency: String,
    pub foreign_balance: Decimal,
    pub book_value: Decimal,
    pub market_value: Decimal,
    pub adjustment_amount: Decimal,
    pub exchange_rate: Decimal,
}
