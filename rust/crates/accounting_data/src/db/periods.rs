use accounting_core::calendar::{FinancialPeriod, PeriodStatus};
use sqlx::PgPool;
use uuid::Uuid;
use chrono::{NaiveDate, Utc};

pub struct PgPeriodRepository {
    pool: PgPool,
}

impl PgPeriodRepository {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }

    pub async fn save_period(&self, period: &FinancialPeriod) -> Result<(), anyhow::Error> {
        let status_str = format!("{:?}", period.status);
        
        sqlx::query!(
            r#"
            INSERT INTO financial_periods (id, name, start_date, end_date, status, is_year_end)
            VALUES ($1, $2, $3, $4, $5, $6)
            ON CONFLICT (id) DO UPDATE SET
                name = EXCLUDED.name,
                status = EXCLUDED.status,
                is_year_end = EXCLUDED.is_year_end
            "#,
            period.id,
            period.name,
            period.start_date,
            period.end_date,
            status_str,
            period.is_year_end
        )
        .execute(&self.pool)
        .await?;
        
        Ok(())
    }

    pub async fn get_period_by_date(&self, date: NaiveDate) -> Result<Option<FinancialPeriod>, anyhow::Error> {
        let row = sqlx::query!(
            r#"
            SELECT id, name, start_date, end_date, status, is_year_end
            FROM financial_periods
            WHERE $1 >= start_date AND $1 <= end_date
            LIMIT 1
            "#,
            date
        )
        .fetch_optional(&self.pool)
        .await?;

        Ok(row.map(|r| FinancialPeriod {
            id: r.id,
            name: r.name,
            start_date: r.start_date,
            end_date: r.end_date,
            status: match r.status.as_str() {
                "Locked" => PeriodStatus::Locked,
                "Closed" => PeriodStatus::Closed,
                _ => PeriodStatus::Open,
            },
            is_year_end: r.is_year_end,
        }))
    }

    pub async fn close_period(&self, id: Uuid, user_id: &str) -> Result<(), anyhow::Error> {
        sqlx::query!(
            r#"
            UPDATE financial_periods 
            SET status = 'Closed', closed_at = $1, closed_by = $2
            WHERE id = $3
            "#,
            Utc::now().naive_utc(),
            user_id,
            id
        )
        .execute(&self.pool)
        .await?;
        
        Ok(())
    }

    pub async fn list_periods(&self) -> Result<Vec<FinancialPeriod>, anyhow::Error> {
        let rows = sqlx::query!(
            r#"
            SELECT id, name, start_date, end_date, status, is_year_end
            FROM financial_periods
            ORDER BY start_date DESC
            "#
        )
        .fetch_all(&self.pool)
        .await?;

        Ok(rows.into_iter().map(|r| FinancialPeriod {
            id: r.id,
            name: r.name,
            start_date: r.start_date,
            end_date: r.end_date,
            status: match r.status.as_str() {
                "Locked" => PeriodStatus::Locked,
                "Closed" => PeriodStatus::Closed,
                _ => PeriodStatus::Open,
            },
            is_year_end: r.is_year_end,
        }).collect())
    }
}
