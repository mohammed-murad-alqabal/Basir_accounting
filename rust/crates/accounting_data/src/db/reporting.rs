use accounting_core::reporting::models::{
    FinancialReport, FinancialReportLine, TrialBalance, TrialBalanceLine,
};
use chrono::{NaiveDate, Utc};
use rust_decimal::Decimal;
use sqlx::PgPool;
use uuid::Uuid;

/// Repository for generating reports from the database.
pub struct PgReportingRepository {
    pool: PgPool,
}

/// Raw row from the database aggregation query.
#[derive(Debug)]
struct BalanceRow {
    account_id: Uuid,
    account_code: String,
    account_name_ar: String,
    #[allow(dead_code)]
    account_name_en: String,
    account_type: String,
    total_debits: Decimal,
    total_credits: Decimal,
}

impl PgReportingRepository {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }

    /// Generate a Trial Balance by querying the database directly.
    ///
    /// This aggregates all journal entry lines and groups by account,
    /// applying date filters as specified.
    ///
    /// # Task 16.1 & 16.2 Implementation (Database Layer)
    pub async fn generate_trial_balance(
        &self,
        as_of_date: NaiveDate,
        period_start: Option<NaiveDate>,
    ) -> Result<TrialBalance, anyhow::Error> {
        // We use a Recursive CTE to aggregate balances from leaf accounts up to all their parents
        // This ensures the Trial Balance reflects the hierarchy correctly
        let rows = if let Some(start) = period_start {
            sqlx::query_as!(
                BalanceRow,
                r#"
                WITH RECURSIVE account_tree AS (
                    -- Base case: Leaf accounts and their balances in the period
                    SELECT 
                        a.id, 
                        a.parent_id, 
                        COALESCE(SUM(l.debit), 0) as leaf_debits,
                        COALESCE(SUM(l.credit), 0) as leaf_credits
                    FROM accounts a
                    LEFT JOIN journal_entry_lines l ON a.id = l.account_id
                    LEFT JOIN journal_entries e ON l.entry_id = e.id
                    WHERE a.is_leaf = true
                      AND e.effective_date >= $1 AND e.effective_date <= $2
                    GROUP BY a.id, a.parent_id
                    
                    UNION ALL
                    
                    -- Recursive step: Propagate leaf balances up to parents
                    SELECT 
                        p.id, 
                        p.parent_id,
                        t.leaf_debits,
                        t.leaf_credits
                    FROM accounts p
                    JOIN account_tree t ON p.id = t.parent_id
                )
                SELECT 
                    t.id as "account_id!",
                    a.code as "account_code!",
                    a.name_ar as "account_name_ar!",
                    a.name_en as "account_name_en!",
                    a.type as "account_type!",
                    SUM(t.leaf_debits) as "total_debits!: Decimal",
                    SUM(t.leaf_credits) as "total_credits!: Decimal"
                FROM account_tree t
                JOIN accounts a ON t.id = a.id
                GROUP BY t.id, a.code, a.name_ar, a.name_en, a.type
                ORDER BY a.code
                "#,
                start,
                as_of_date
            )
            .fetch_all(&self.pool)
            .await?
        } else {
            sqlx::query_as!(
                BalanceRow,
                r#"
                WITH RECURSIVE account_tree AS (
                    -- Base case: Leaf accounts and their total balances up to date
                    SELECT 
                        a.id, 
                        a.parent_id, 
                        COALESCE(SUM(l.debit), 0) as leaf_debits,
                        COALESCE(SUM(l.credit), 0) as leaf_credits
                    FROM accounts a
                    LEFT JOIN journal_entry_lines l ON a.id = l.account_id
                    LEFT JOIN journal_entries e ON l.entry_id = e.id
                    WHERE a.is_leaf = true
                      AND (e.effective_date IS NULL OR e.effective_date <= $1)
                    GROUP BY a.id, a.parent_id
                    
                    UNION ALL
                    
                    -- Recursive step: Propagate leaf balances up to parents
                    SELECT 
                        p.id, 
                        p.parent_id,
                        t.leaf_debits,
                        t.leaf_credits
                    FROM accounts p
                    JOIN account_tree t ON p.id = t.parent_id
                )
                SELECT 
                    t.id as "account_id!",
                    a.code as "account_code!",
                    a.name_ar as "account_name_ar!",
                    a.name_en as "account_name_en!",
                    a.type as "account_type!",
                    SUM(t.leaf_debits) as "total_debits!: Decimal",
                    SUM(t.leaf_credits) as "total_credits!: Decimal"
                FROM account_tree t
                JOIN accounts a ON t.id = a.id
                GROUP BY t.id, a.code, a.name_ar, a.name_en, a.type
                ORDER BY a.code
                "#,
                as_of_date
            )
            .fetch_all(&self.pool)
            .await?
        };

        // Transform to Trial Balance
        let mut lines = Vec::new();
        let mut total_debits = Decimal::ZERO;
        let mut total_credits = Decimal::ZERO;

        for row in rows {
            let is_debit_normal = matches!(row.account_type.as_str(), "Asset" | "Expense");
            let net = row.total_debits - row.total_credits;

            let (debit_balance, credit_balance) = if is_debit_normal {
                if net >= Decimal::ZERO {
                    (net, Decimal::ZERO)
                } else {
                    (Decimal::ZERO, net.abs())
                }
            } else if net <= Decimal::ZERO {
                (Decimal::ZERO, net.abs())
            } else {
                (net, Decimal::ZERO)
            };

            // Skip zero balances
            if debit_balance == Decimal::ZERO && credit_balance == Decimal::ZERO {
                continue;
            }

            total_debits += debit_balance;
            total_credits += credit_balance;

            lines.push(TrialBalanceLine {
                account_id: row.account_id,
                account_code: row.account_code,
                account_name: row.account_name_ar, // Defaulting to Arabic for the single field in TB model for now
                debit_balance,
                credit_balance,
                source_entries: vec![],
            });
        }

        let is_balanced = total_debits == total_credits;

        Ok(TrialBalance {
            as_of_date,
            period_start,
            period_end: as_of_date,
            lines,
            total_debits,
            total_credits,
            is_balanced,
        })
    }

    /// Task 16.3: Drill-down from account balance to journal entries.
    pub async fn get_account_entries(
        &self,
        account_id: Uuid,
        period_start: Option<NaiveDate>,
        period_end: NaiveDate,
    ) -> Result<Vec<DrillDownEntry>, anyhow::Error> {
        let entries = if let Some(start) = period_start {
            sqlx::query_as!(
                DrillDownEntry,
                r#"
                SELECT 
                    e.id as entry_id,
                    e.entry_number,
                    e.effective_date,
                    l.description,
                    l.debit as "debit: Decimal",
                    l.credit as "credit: Decimal",
                    e.standard_reference
                FROM journal_entries e
                JOIN journal_entry_lines l ON e.id = l.entry_id
                WHERE l.account_id = $1
                  AND e.effective_date >= $2
                  AND e.effective_date <= $3
                ORDER BY e.effective_date, e.entry_number
                "#,
                account_id,
                start,
                period_end
            )
            .fetch_all(&self.pool)
            .await?
        } else {
            sqlx::query_as!(
                DrillDownEntry,
                r#"
                SELECT 
                    e.id as entry_id,
                    e.entry_number,
                    e.effective_date,
                    l.description,
                    l.debit as "debit: Decimal",
                    l.credit as "credit: Decimal",
                    e.standard_reference
                FROM journal_entries e
                JOIN journal_entry_lines l ON e.id = l.entry_id
                WHERE l.account_id = $1
                  AND e.effective_date <= $2
                ORDER BY e.effective_date, e.entry_number
                "#,
                account_id,
                period_end
            )
            .fetch_all(&self.pool)
            .await?
        };

        Ok(entries)
    }

    /// Generate an Income Statement according to IFRS 18.
    pub async fn generate_income_statement(
        &self,
        from_date: NaiveDate,
        to_date: NaiveDate,
    ) -> Result<FinancialReport, anyhow::Error> {
        let rows = sqlx::query!(
            r#"
            SELECT 
                a.id,
                a.code,
                a.name_ar as account_name_ar,
                a.name_en as account_name_en,
                a.type as "account_type!",
                a.classification as account_classification,
                COALESCE(SUM(l.debit), 0) as "total_debits!: Decimal",
                COALESCE(SUM(l.credit), 0) as "total_credits!: Decimal"
            FROM accounts a
            LEFT JOIN journal_entry_lines l ON a.id = l.account_id
            LEFT JOIN journal_entries e ON l.entry_id = e.id
            WHERE a.is_leaf = true
              AND (a.type = 'Income' OR a.type = 'Expense')
              AND e.effective_date >= $1
              AND e.effective_date <= $2
            GROUP BY a.id, a.code, a.name_ar, a.name_en, a.type, a.classification
            "#,
            from_date,
            to_date
        )
        .fetch_all(&self.pool)
        .await?;

        // Map database rows to (Account, Balance) pairs for the generator
        use accounting_core::accounts::models::{Account, AccountClassification, AccountKind};
        use accounting_core::reporting::generator::FinancialReportGenerator;

        let accounts_with_balances: Vec<(Account, Decimal)> = rows
            .into_iter()
            .map(|row| {
                let mut acc = Account::new(
                    row.code,
                    row.account_name_ar,
                    row.account_name_en,
                    match row.account_type.as_str() {
                        "Income" => AccountKind::Income,
                        "Expense" => AccountKind::Expense,
                        _ => AccountKind::Expense, // Should not happen due to WHERE
                    },
                );
                acc.id = row.id;

                // Map string classification back to enum
                acc.classification = row.account_classification.and_then(|c| match c.as_str() {
                    "Operating" => Some(AccountClassification::Operating),
                    "Investing" => Some(AccountClassification::Investing),
                    "Financing" => Some(AccountClassification::Financing),
                    "IncomeTaxes" => Some(AccountClassification::IncomeTaxes),
                    "DiscontinuedOperations" => Some(AccountClassification::DiscontinuedOperations),
                    _ => None,
                });

                // Calculate raw balance (un-normalized)
                // The generator handles normalization based on AccountKind
                let balance = row.total_debits - row.total_credits;

                (acc, balance)
            })
            .collect();

        Ok(FinancialReportGenerator::synthesize_income_statement(
            from_date,
            to_date,
            &accounts_with_balances,
        ))
    }

    /// Generate a Balance Sheet as of a specific date.
    pub async fn generate_balance_sheet(
        &self,
        as_of_date: NaiveDate,
    ) -> Result<FinancialReport, anyhow::Error> {
        // ... (existing logic or refactor to use generator if desired later)
        // For now, I'll keep it as is or refactor it to use the generator too.
        // Actually, let's keep it simple for now and focus on Cash Flow.

        let rows = sqlx::query!(
            r#"
            SELECT 
                a.name_ar as account_name_ar,
                a.name_en as account_name_en,
                a.type as "account_type!",
                a.classification as account_classification,
                COALESCE(SUM(l.debit), 0) as "total_debits!: Decimal",
                COALESCE(SUM(l.credit), 0) as "total_credits!: Decimal"
            FROM accounts a
            LEFT JOIN journal_entry_lines l ON a.id = l.account_id
            LEFT JOIN journal_entries e ON l.entry_id = e.id
            WHERE a.is_leaf = true
              AND (a.type = 'Asset' OR a.type = 'Liability' OR a.type = 'Equity')
              AND e.effective_date <= $1
            GROUP BY a.id, a.name_ar, a.name_en, a.type, a.classification
            "#,
            as_of_date
        )
        .fetch_all(&self.pool)
        .await?;

        let mut lines = Vec::new();

        // Assets
        lines.push(FinancialReportLine {
            label: "الأصول (Assets)".to_string(),
            amount: Decimal::ZERO,
            is_title: true,
            is_total: false,
            indent_level: 0,
        });
        let mut total_assets = Decimal::ZERO;
        for row in rows.iter().filter(|r| r.account_type == "Asset") {
            let balance = row.total_debits - row.total_credits;
            lines.push(FinancialReportLine {
                label: row.account_name_ar.clone(),
                amount: balance,
                is_title: false,
                is_total: false,
                indent_level: 1,
            });
            total_assets += balance;
        }
        lines.push(FinancialReportLine {
            label: "إجمالي الأصول".to_string(),
            amount: total_assets,
            is_title: false,
            is_total: true,
            indent_level: 0,
        });

        // Liabilities & Equity
        lines.push(FinancialReportLine {
            label: "الالتزامات وحقوق الملكية (Liabilities & Equity)".to_string(),
            amount: Decimal::ZERO,
            is_title: true,
            is_total: false,
            indent_level: 0,
        });
        let mut total_le = Decimal::ZERO;
        for row in rows
            .iter()
            .filter(|r| r.account_type == "Liability" || r.account_type == "Equity")
        {
            let balance = row.total_credits - row.total_debits;
            lines.push(FinancialReportLine {
                label: row.account_name_ar.clone(),
                amount: balance,
                is_title: false,
                is_total: false,
                indent_level: 1,
            });
            total_le += balance;
        }
        lines.push(FinancialReportLine {
            label: "إجمالي الالتزامات وحقوق الملكية".to_string(),
            amount: total_le,
            is_title: false,
            is_total: true,
            indent_level: 0,
        });

        Ok(FinancialReport {
            title: "قائمة المركز المالي (Balance Sheet)".to_string(),
            from_date: as_of_date,
            to_date: as_of_date,
            lines,
            generated_at: Utc::now().naive_utc().date(),
        })
    }

    /// Generate an IAS 7 Statement of Cash Flows (Indirect Method).
    pub async fn generate_cash_flow_statement(
        &self,
        from_date: NaiveDate,
        to_date: NaiveDate,
    ) -> Result<FinancialReport, anyhow::Error> {
        use accounting_core::accounts::models::{Account, AccountClassification, AccountKind};
        use accounting_core::reporting::{ComparativeBalance, FinancialReportGenerator};

        // 1. Get Net Profit for the period
        let income_report = self.generate_income_statement(from_date, to_date).await?;
        let net_profit = income_report
            .lines
            .last()
            .map(|l| l.amount)
            .unwrap_or(Decimal::ZERO);

        // 2. Get Comparative Balances for Balance Sheet accounts
        // We need balances at from_date - 1 (opening) and to_date (closing)
        let opening_date = from_date.pred_opt().unwrap_or(from_date);

        // Fetch balances for both dates in one query or two
        // Let's use two for clarity for now, optimized later if needed
        let start_balances = self.get_balances_as_of(opening_date).await?;
        let end_balances = self.get_balances_as_of(to_date).await?;

        // 3. Construct ComparativeBalance list
        let mut comparative = Vec::new();
        for (id, end_val) in &end_balances {
            let start_val = start_balances.get(id).cloned().unwrap_or(Decimal::ZERO);

            // Fetch account details (could be part of the balance query)
            let acc_row = sqlx::query!(
                "SELECT code, name_ar, name_en, type as \"account_type!\", classification FROM accounts WHERE id = $1",
                id
            )
            .fetch_one(&self.pool)
            .await?;

            let mut acc = Account::new(
                acc_row.code,
                acc_row.name_ar,
                acc_row.name_en,
                match acc_row.account_type.as_str() {
                    "Asset" => AccountKind::Asset,
                    "Liability" => AccountKind::Liability,
                    "Equity" => AccountKind::Equity,
                    _ => continue, // Should only be BS accounts
                },
            );
            acc.id = *id;
            acc.classification = acc_row.classification.and_then(|c| match c.as_str() {
                "Operating" => Some(AccountClassification::Operating),
                "Investing" => Some(AccountClassification::Investing),
                "Financing" => Some(AccountClassification::Financing),
                _ => None,
            });

            comparative.push(ComparativeBalance {
                account: acc,
                start_balance: start_val,
                end_balance: *end_val,
            });
        }

        Ok(FinancialReportGenerator::synthesize_cash_flow_statement(
            from_date,
            to_date,
            net_profit,
            &comparative,
        ))
    }

    /// Helper to get account balances as of a specific date.
    async fn get_balances_as_of(
        &self,
        date: NaiveDate,
    ) -> Result<std::collections::HashMap<Uuid, Decimal>, anyhow::Error> {
        let rows = sqlx::query!(
            r#"
            SELECT 
                a.id,
                COALESCE(SUM(l.debit), 0) as "total_debits!: Decimal",
                COALESCE(SUM(l.credit), 0) as "total_credits!: Decimal"
            FROM accounts a
            LEFT JOIN journal_entry_lines l ON a.id = l.account_id
            LEFT JOIN journal_entries e ON l.entry_id = e.id
            WHERE e.effective_date <= $1 OR e.effective_date IS NULL
            GROUP BY a.id
            "#,
            date
        )
        .fetch_all(&self.pool)
        .await?;

        let mut balances = std::collections::HashMap::new();
        for row in rows {
            balances.insert(row.id, row.total_debits - row.total_credits);
        }
        Ok(balances)
    }

    /// Generate an AAOIFI FAS 9 Zakah Statement.
    pub async fn generate_zakah_statement(
        &self,
        as_of_date: NaiveDate,
        calendar: accounting_core::reporting::zakah::ZakahCalendarType,
    ) -> Result<FinancialReport, anyhow::Error> {
        use accounting_core::accounts::models::{Account, AccountClassification, AccountKind};
        use accounting_core::reporting::generator::FinancialReportGenerator;
        use accounting_core::reporting::zakah::ZakahBase;

        // 1. Get current balances for all accounts
        let balances = self.get_balances_as_of(as_of_date).await?;

        let mut zakatable_assets = Vec::new();
        let mut deductible_liabilities = Vec::new();

        // 2. Identify Zakatable Assets and Deductible Liabilities
        for (id, balance) in balances {
            if balance == Decimal::ZERO {
                continue;
            }

            let acc_row = sqlx::query!(
                "SELECT code, name_ar, name_en, type as \"account_type!\", classification FROM accounts WHERE id = $1",
                id
            )
            .fetch_one(&self.pool)
            .await?;

            let kind = match acc_row.account_type.as_str() {
                "Asset" => AccountKind::Asset,
                "Liability" => AccountKind::Liability,
                "Equity" => AccountKind::Equity,
                "Income" => AccountKind::Income,
                "Expense" => AccountKind::Expense,
                _ => continue,
            };

            let classification = acc_row
                .classification
                .and_then(|c: String| match c.as_str() {
                    "ZakahAssets" => Some(AccountClassification::ZakahAssets),
                    "ZakahLiabilities" => Some(AccountClassification::ZakahLiabilities),
                    _ => None,
                });

            if let Some(cls) = classification {
                let mut acc = Account::new(acc_row.code, acc_row.name_ar, acc_row.name_en, kind);
                acc.id = id;
                acc.classification = Some(cls);

                if cls == AccountClassification::ZakahAssets {
                    zakatable_assets.push((acc, balance.abs()));
                } else if cls == AccountClassification::ZakahLiabilities {
                    deductible_liabilities.push((acc, balance.abs()));
                }
            }
        }

        let base = ZakahBase {
            zakatable_assets,
            deductible_liabilities,
        };

        Ok(FinancialReportGenerator::synthesize_zakah_statement(
            as_of_date, // from
            as_of_date, // to
            &base, calendar,
        ))
    }
}

/// Entry details for drill-down reports.
#[derive(Debug, sqlx::FromRow)]
pub struct DrillDownEntry {
    pub entry_id: Uuid,
    pub entry_number: String,
    pub effective_date: NaiveDate,
    pub description: String,
    pub debit: Decimal,
    pub credit: Decimal,
    pub standard_reference: Option<String>,
}

/// Row for Aging Reports (AR/AP).
#[derive(Debug, sqlx::FromRow)]
pub struct AgingRow {
    pub partner_id: Uuid,
    pub partner_name: String,
    pub current_amount: Decimal,
    pub period_1_30: Decimal,
    pub period_31_60: Decimal,
    pub period_61_90: Decimal,
    pub period_over_90: Decimal,
    pub total_amount: Decimal,
}

impl PgReportingRepository {
    /// Generates Accounts Receivable Aging Report.
    pub async fn get_receivables_aging(
        &self,
        as_of_date: NaiveDate,
    ) -> Result<Vec<AgingRow>, anyhow::Error> {
        // We calculate age as (as_of_date - due_date).
        // If due_date > as_of_date, it is Current (not overdue).
        // If due_date <= as_of_date, it is overdue.
        let rows = sqlx::query_as!(
            AgingRow,
            r#"
            SELECT
                c.id as partner_id,
                c.name_ar as partner_name,
                COALESCE(SUM(CASE WHEN i.due_date > $1 THEN i.balance_due ELSE 0 END), 0) as "current_amount!: Decimal",
                COALESCE(SUM(CASE WHEN i.due_date <= $1 AND ($1 - i.due_date) <= 30 THEN i.balance_due ELSE 0 END), 0) as "period_1_30!: Decimal",
                COALESCE(SUM(CASE WHEN i.due_date <= $1 AND ($1 - i.due_date) > 30 AND ($1 - i.due_date) <= 60 THEN i.balance_due ELSE 0 END), 0) as "period_31_60!: Decimal",
                COALESCE(SUM(CASE WHEN i.due_date <= $1 AND ($1 - i.due_date) > 60 AND ($1 - i.due_date) <= 90 THEN i.balance_due ELSE 0 END), 0) as "period_61_90!: Decimal",
                COALESCE(SUM(CASE WHEN i.due_date <= $1 AND ($1 - i.due_date) > 90 THEN i.balance_due ELSE 0 END), 0) as "period_over_90!: Decimal",
                COALESCE(SUM(i.balance_due), 0) as "total_amount!: Decimal"
            FROM sales_invoices i
            JOIN customers c ON i.customer_id = c.id
            WHERE (i.status = 'Posted' OR i.status = 'PartiallyPaid' OR i.status = 'Open')
              AND i.balance_due > 0
              AND i.invoice_date <= $1
            GROUP BY c.id, c.name_ar
            ORDER BY c.name_ar
            "#,
            as_of_date
        )
        .fetch_all(&self.pool)
        .await?;

        Ok(rows)
    }

    /// Generates Accounts Payable Aging Report.
    pub async fn get_payables_aging(
        &self,
        as_of_date: NaiveDate,
    ) -> Result<Vec<AgingRow>, anyhow::Error> {
        let rows = sqlx::query_as!(
            AgingRow,
            r#"
            SELECT
                v.id as partner_id,
                v.name_ar as partner_name,
                COALESCE(SUM(CASE WHEN b.due_date > $1 THEN b.balance_due ELSE 0 END), 0) as "current_amount!: Decimal",
                COALESCE(SUM(CASE WHEN b.due_date <= $1 AND ($1 - b.due_date) <= 30 THEN b.balance_due ELSE 0 END), 0) as "period_1_30!: Decimal",
                COALESCE(SUM(CASE WHEN b.due_date <= $1 AND ($1 - b.due_date) > 30 AND ($1 - b.due_date) <= 60 THEN b.balance_due ELSE 0 END), 0) as "period_31_60!: Decimal",
                COALESCE(SUM(CASE WHEN b.due_date <= $1 AND ($1 - b.due_date) > 60 AND ($1 - b.due_date) <= 90 THEN b.balance_due ELSE 0 END), 0) as "period_61_90!: Decimal",
                COALESCE(SUM(CASE WHEN b.due_date <= $1 AND ($1 - b.due_date) > 90 THEN b.balance_due ELSE 0 END), 0) as "period_over_90!: Decimal",
                COALESCE(SUM(b.balance_due), 0) as "total_amount!: Decimal"
            FROM purchase_bills b
            JOIN vendors v ON b.vendor_id = v.id
            WHERE (b.status = 'Open' OR b.status = 'PartiallyPaid')
              AND b.balance_due > 0
              AND b.bill_date <= $1
            GROUP BY v.id, v.name_ar
            ORDER BY v.name_ar
            "#,
            as_of_date
        )
        .fetch_all(&self.pool)
        .await?;

        Ok(rows)
    }
}
