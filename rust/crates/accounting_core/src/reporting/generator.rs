//! Financial Report Generation Logic
//!
//! Synthesizes raw account balances into structured IFRS 18 compliant reports.

use super::models::{FinancialReport, FinancialReportLine};
use super::zakah::{ZakahBase, ZakahCalculator, ZakahCalendarType};
use crate::accounts::models::{Account, AccountClassification, AccountKind};
use chrono::NaiveDate;
use rust_decimal::Decimal;

/// Comparative balance for an account over two points in time.
#[derive(Debug, Clone)]
pub struct ComparativeBalance {
    pub account: Account,
    pub start_balance: Decimal,
    pub end_balance: Decimal,
}

impl ComparativeBalance {
    /// Difference: End - Start.
    /// Positive means increase, Negative means decrease.
    pub fn delta(&self) -> Decimal {
        self.end_balance - self.start_balance
    }
}

/// Engine for synthesizing financial statements.
pub struct FinancialReportGenerator;

impl FinancialReportGenerator {
    /// Synthesizes an Income Statement (Statement of Profit or Loss) according to IFRS 18.
    ///
    /// # Requirement: IFRS 18 Subtotals
    /// - Operating Profit
    /// - Profit or loss before financing and income tax
    /// - Profit or loss
    pub fn synthesize_income_statement(
        from_date: NaiveDate,
        to_date: NaiveDate,
        accounts: &[(Account, Decimal)],
    ) -> FinancialReport {
        let mut lines = Vec::new();

        // 1. Operating Category
        let operating_balance = Self::add_category_section(
            &mut lines,
            "النشاط التشغيلي (Operating Activity)",
            AccountClassification::Operating,
            accounts,
            true, // Income is positive
        );

        // Subtotal: Operating Profit (IFRS 18 Required)
        lines.push(FinancialReportLine {
            label: "الربح التشغيلي (Operating Profit)".to_string(),
            amount: operating_balance,
            is_title: false,
            is_total: true,
            indent_level: 0,
        });

        // 2. Investing Category
        let investing_balance = Self::add_category_section(
            &mut lines,
            "النشاط الاستثماري (Investing Activity)",
            AccountClassification::Investing,
            accounts,
            true,
        );

        // Subtotal: Profit or loss before financing and income tax (IFRS 18 Required)
        let ebit = operating_balance + investing_balance;
        lines.push(FinancialReportLine {
            label: "الربح قبل التمويل والضرائب (Profit before Financing & Tax)".to_string(),
            amount: ebit,
            is_title: false,
            is_total: true,
            indent_level: 0,
        });

        // 3. Financing Category
        let financing_balance = Self::add_category_section(
            &mut lines,
            "النشاط التمويلي (Financing Activity)",
            AccountClassification::Financing,
            accounts,
            true,
        );

        // 4. Income Taxes
        let tax_balance = Self::add_category_section(
            &mut lines,
            "ضرائب الدخل (Income Taxes)",
            AccountClassification::IncomeTaxes,
            accounts,
            true,
        );

        // Final Subtotal: Net Profit or Loss
        let net_profit = ebit + financing_balance + tax_balance;
        lines.push(FinancialReportLine {
            label: "صافي الربح أو الخسارة (Net Profit/Loss)".to_string(),
            amount: net_profit,
            is_title: true,
            is_total: true,
            indent_level: 0,
        });

        FinancialReport {
            title: "قائمة الأرباح أو الخسائر (IFRS 18)".to_string(),
            from_date,
            to_date,
            lines,
            generated_at: to_date, // Simplified for core logic
        }
    }
    /// Synthesizes a Statement of Cash Flows (Indirect Method) according to IAS 7.
    ///
    /// # Inputs
    /// - `net_profit`: Profit from the Income Statement for the period.
    /// - `comparative_balances`: Beginning and ending balances for Balance Sheet accounts.
    pub fn synthesize_cash_flow_statement(
        from_date: NaiveDate,
        to_date: NaiveDate,
        net_profit: Decimal,
        comparative_balances: &[ComparativeBalance],
    ) -> FinancialReport {
        let mut lines = Vec::new();

        // 1. Operating Activities
        lines.push(FinancialReportLine {
            label: "التدفقات النقدية من الأنشطة التشغيلية (Operating Activities)".to_string(),
            amount: Decimal::ZERO,
            is_title: true,
            is_total: false,
            indent_level: 0,
        });

        lines.push(FinancialReportLine {
            label: "صافي الربح قبل الزكاة والضريبة (Net Profit)".to_string(),
            amount: net_profit,
            is_title: false,
            is_total: false,
            indent_level: 1,
        });

        let mut operating_adjustments = Decimal::ZERO;

        // Adjustments for non-cash items and working capital
        for comp in comparative_balances {
            let delta = comp.delta();
            if delta == Decimal::ZERO {
                continue;
            }

            if let Some(AccountClassification::Operating) = comp.account.classification {
                // Logic:
                // - Asset increase = Outflow (-)
                // - Asset decrease = Inflow (+)
                // - Liability increase = Inflow (+)
                // - Liability decrease = Outflow (-)
                let effect = if comp.account.kind.is_debit_normal() {
                    -delta // Asset
                } else {
                    delta // Liability/Equity
                };

                lines.push(FinancialReportLine {
                    label: format!("التغير في {}", comp.account.name_ar),
                    amount: effect,
                    is_title: false,
                    is_total: false,
                    indent_level: 1,
                });
                operating_adjustments += effect;
            }
        }

        let net_operating_cash = net_profit + operating_adjustments;
        lines.push(FinancialReportLine {
            label: "صافي النقد من الأنشطة التشغيلية".to_string(),
            amount: net_operating_cash,
            is_title: false,
            is_total: true,
            indent_level: 0,
        });

        // 2. Investing Activities
        lines.push(FinancialReportLine {
            label: "التدفقات النقدية من الأنشطة الاستثمارية (Investing Activities)".to_string(),
            amount: Decimal::ZERO,
            is_title: true,
            is_total: false,
            indent_level: 0,
        });
        let mut net_investing_cash = Decimal::ZERO;
        for comp in comparative_balances {
            if matches!(
                comp.account.classification,
                Some(AccountClassification::Investing)
            ) {
                let delta = comp.delta();
                if delta != Decimal::ZERO {
                    let effect = if comp.account.kind.is_debit_normal() {
                        -delta
                    } else {
                        delta
                    };
                    lines.push(FinancialReportLine {
                        label: comp.account.name_en.clone(),
                        amount: effect,
                        is_title: false,
                        is_total: false,
                        indent_level: 1,
                    });
                    net_investing_cash += effect;
                }
            }
        }
        lines.push(FinancialReportLine {
            label: "صافي النقد من الأنشطة الاستثمارية".to_string(),
            amount: net_investing_cash,
            is_title: false,
            is_total: true,
            indent_level: 0,
        });

        // 3. Financing Activities
        lines.push(FinancialReportLine {
            label: "التدفقات النقدية من الأنشطة التمويلية (Financing Activities)".to_string(),
            amount: Decimal::ZERO,
            is_title: true,
            is_total: false,
            indent_level: 0,
        });
        let mut net_financing_cash = Decimal::ZERO;
        for comp in comparative_balances {
            if matches!(
                comp.account.classification,
                Some(AccountClassification::Financing)
            ) {
                let delta = comp.delta();
                if delta != Decimal::ZERO {
                    let effect = if comp.account.kind.is_debit_normal() {
                        -delta
                    } else {
                        delta
                    };
                    lines.push(FinancialReportLine {
                        label: comp.account.name_en.clone(),
                        amount: effect,
                        is_title: false,
                        is_total: false,
                        indent_level: 1,
                    });
                    net_financing_cash += effect;
                }
            }
        }
        lines.push(FinancialReportLine {
            label: "صافي النقد من الأنشطة التمويلية".to_string(),
            amount: net_financing_cash,
            is_title: false,
            is_total: true,
            indent_level: 0,
        });

        // 4. Reconciliation
        let net_increase = net_operating_cash + net_investing_cash + net_financing_cash;
        lines.push(FinancialReportLine {
            label: "صافي الزيادة (النقص) في النقد".to_string(),
            amount: net_increase,
            is_title: true,
            is_total: true,
            indent_level: 0,
        });

        FinancialReport {
            title: "قائمة التدفقات النقدية - الطريقة غير المباشرة (IAS 7)".to_string(),
            from_date,
            to_date,
            lines,
            generated_at: to_date,
        }
    }

    fn add_category_section(
        lines: &mut Vec<FinancialReportLine>,
        title: &str,
        category: AccountClassification,
        accounts: &[(Account, Decimal)],
        income_is_positive: bool,
    ) -> Decimal {
        lines.push(FinancialReportLine {
            label: title.to_string(),
            amount: Decimal::ZERO,
            is_title: true,
            is_total: false,
            indent_level: 0,
        });

        let mut section_total = Decimal::ZERO;

        for (acc, balance) in accounts {
            if acc.classification == Some(category) && *balance != Decimal::ZERO {
                let display_amount = if acc.kind == AccountKind::Income {
                    if income_is_positive {
                        *balance
                    } else {
                        -*balance
                    }
                } else if income_is_positive {
                    -*balance
                } else {
                    *balance
                };

                lines.push(FinancialReportLine {
                    label: acc.name_en.clone(),
                    amount: display_amount,
                    is_title: false,
                    is_total: false,
                    indent_level: 1,
                });
                section_total += display_amount;
            }
        }

        lines.push(FinancialReportLine {
            label: format!("إجمالي {}", title),
            amount: section_total,
            is_title: false,
            is_total: true,
            indent_level: 0,
        });

        section_total
    }

    /// Synthesizes a Zakah Statement according to AAOIFI FAS 9.
    pub fn synthesize_zakah_statement(
        from_date: NaiveDate,
        to_date: NaiveDate,
        base: &ZakahBase,
        calendar: ZakahCalendarType,
    ) -> FinancialReport {
        let mut lines = Vec::new();

        lines.push(FinancialReportLine {
            label: "حساب الزكاة - معيار الأيوفي المالي رقم 9 (AAOIFI FAS 9)".to_string(),
            amount: Decimal::ZERO,
            is_title: true,
            is_total: false,
            indent_level: 0,
        });

        // 1. Zakatable Assets
        lines.push(FinancialReportLine {
            label: "الأصول الزكوية (Zakatable Assets)".to_string(),
            amount: Decimal::ZERO,
            is_title: true,
            is_total: false,
            indent_level: 0,
        });
        let mut total_assets = Decimal::ZERO;
        for (acc, balance) in &base.zakatable_assets {
            lines.push(FinancialReportLine {
                label: acc.name_en.clone(),
                amount: *balance,
                is_title: false,
                is_total: false,
                indent_level: 1,
            });
            total_assets += *balance;
        }
        lines.push(FinancialReportLine {
            label: "إجمالي الأصول الزكوية".to_string(),
            amount: total_assets,
            is_title: false,
            is_total: true,
            indent_level: 0,
        });

        // 2. Deductible Liabilities
        lines.push(FinancialReportLine {
            label: "الخصوم الحسيمة (Deductible Liabilities)".to_string(),
            amount: Decimal::ZERO,
            is_title: true,
            is_total: false,
            indent_level: 0,
        });
        let mut total_liab = Decimal::ZERO;
        for (acc, balance) in &base.deductible_liabilities {
            lines.push(FinancialReportLine {
                label: acc.name_en.clone(),
                amount: *balance,
                is_title: false,
                is_total: false,
                indent_level: 1,
            });
            total_liab += *balance;
        }
        lines.push(FinancialReportLine {
            label: "إجمالي الخصوم الحسيمة".to_string(),
            amount: total_liab,
            is_title: false,
            is_total: true,
            indent_level: 0,
        });

        // 3. Zakah Base
        let zakah_base = base.net_zakatable_assets();
        lines.push(FinancialReportLine {
            label: "وعاء الزكاة (Zakah Base)".to_string(),
            amount: zakah_base,
            is_title: true,
            is_total: true,
            indent_level: 0,
        });

        // 4. Zakah Due
        let zakah_due = ZakahCalculator::calculate(base, calendar);
        let rate_pct = (calendar.rate() * Decimal::from(100)).round_dp(4);

        lines.push(FinancialReportLine {
            label: format!("الزكاة المستحقة (Zakah Due - {}%)", rate_pct),
            amount: zakah_due,
            is_title: true,
            is_total: true,
            indent_level: 0,
        });

        FinancialReport {
            title: "قائمة حساب الزكاة (Zakah Statement)".to_string(),
            from_date,
            to_date,
            lines,
            generated_at: to_date,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use chrono::NaiveDate;
    #[test]
    fn test_sythesize_ifrs18_income_statement() {
        let from = NaiveDate::from_ymd_opt(2026, 1, 1).unwrap();
        let to = NaiveDate::from_ymd_opt(2026, 12, 31).unwrap();

        let mut sales = Account::new("4100", "المبيعات", "Sales", AccountKind::Income);
        sales.classification = Some(AccountClassification::Operating);

        let mut cogs = Account::new(
            "5100",
            "تكلفة البضاعة المباعة",
            "COGS",
            AccountKind::Expense,
        );
        cogs.classification = Some(AccountClassification::Operating);

        let mut dev_expense = Account::new("5200", "مصاريف التطوير", "R&D", AccountKind::Expense);
        dev_expense.classification = Some(AccountClassification::Investing);

        let mut interest = Account::new(
            "5300",
            "مصاريف الفوائد",
            "Interest Expense",
            AccountKind::Expense,
        );
        interest.classification = Some(AccountClassification::Financing);

        let mut tax = Account::new("5400", "ضريبة الدخل", "Income Tax", AccountKind::Expense);
        tax.classification = Some(AccountClassification::IncomeTaxes);

        let accounts = vec![
            (sales, Decimal::from(10000)),      // Credit balance for Income
            (cogs, Decimal::from(4000)),        // Debit balance for Expense
            (dev_expense, Decimal::from(1000)), // Debit balance for Expense
            (interest, Decimal::from(500)),     // Debit balance for Expense
            (tax, Decimal::from(1200)),         // Debit balance for Expense
        ];

        let report = FinancialReportGenerator::synthesize_income_statement(from, to, &accounts);

        // Verify sub-totals
        // Operating Profit = 10000 - 4000 = 6000
        let op_profit = report
            .lines
            .iter()
            .find(|l| l.label == "الربح التشغيلي (Operating Profit)")
            .unwrap();
        assert_eq!(op_profit.amount, Decimal::from(6000));

        // Profit before Financing & Tax = Op Profit (6000) - Investing (1000) = 5000
        let ebit = report
            .lines
            .iter()
            .find(|l| l.label == "الربح قبل التمويل والضرائب (Profit before Financing & Tax)")
            .unwrap();
        assert_eq!(ebit.amount, Decimal::from(5000));

        // Net Profit = EBIT (5000) - Financing (500) - Tax (1200) = 3300
        let net_profit = report
            .lines
            .iter()
            .find(|l| l.label == "صافي الربح أو الخسارة (Net Profit/Loss)")
            .unwrap();
        assert_eq!(net_profit.amount, Decimal::from(3300));

        assert_eq!(report.lines.len() > 10, true); // Visual check for sections and lines
    }

    #[test]
    fn test_synthesize_cash_flow_statement() {
        let from = NaiveDate::from_ymd_opt(2026, 1, 1).unwrap();
        let to = NaiveDate::from_ymd_opt(2026, 12, 31).unwrap();

        // Scenario:
        // Net Profit: 5000
        // AR Increased by 1000 (Asset Increase = -1000 Cash)
        // AP Increased by 500 (Liability Increase = +500 Cash)
        // Equipment Purchased for 2000 (Asset Increase = -2000 Cash)
        // Loan Taken for 1500 (Liability Increase = +1500 Cash)

        let mut ar = Account::new("1200", "المدينون", "AR", AccountKind::Asset);
        ar.classification = Some(AccountClassification::Operating);

        let mut ap = Account::new("2100", "الدائنون", "AP", AccountKind::Liability);
        ap.classification = Some(AccountClassification::Operating);

        let mut equip = Account::new("1500", "المعدات", "Equipment", AccountKind::Asset);
        equip.classification = Some(AccountClassification::Investing);

        let mut loan = Account::new("2500", "القروض", "Loan", AccountKind::Liability);
        loan.classification = Some(AccountClassification::Financing);

        let balances = vec![
            ComparativeBalance {
                account: ar,
                start_balance: Decimal::from(0),
                end_balance: Decimal::from(1000),
            },
            ComparativeBalance {
                account: ap,
                start_balance: Decimal::from(2000),
                end_balance: Decimal::from(2500),
            },
            ComparativeBalance {
                account: equip,
                start_balance: Decimal::from(5000),
                end_balance: Decimal::from(7000),
            },
            ComparativeBalance {
                account: loan,
                start_balance: Decimal::from(0),
                end_balance: Decimal::from(1500),
            },
        ];

        let net_profit = Decimal::from(5000);
        let report = FinancialReportGenerator::synthesize_cash_flow_statement(
            from, to, net_profit, &balances,
        );

        // Operating: 5000 (Profit) - 1000 (AR) + 500 (AP) = 4500
        let net_op = report
            .lines
            .iter()
            .find(|l| l.label == "صافي النقد من الأنشطة التشغيلية")
            .unwrap();
        assert_eq!(net_op.amount, Decimal::from(4500));

        // Investing: -2000 (Equip)
        let net_inv = report
            .lines
            .iter()
            .find(|l| l.label == "صافي النقد من الأنشطة الاستثمارية")
            .unwrap();
        assert_eq!(net_inv.amount, Decimal::from(-2000));

        // Financing: +1500 (Loan)
        let net_fin = report
            .lines
            .iter()
            .find(|l| l.label == "صافي النقد من الأنشطة التمويلية")
            .unwrap();
        assert_eq!(net_fin.amount, Decimal::from(1500));

        // Total Increase: 4500 - 2000 + 1500 = 4000
        let net_total = report
            .lines
            .iter()
            .find(|l| l.label == "صافي الزيادة (النقص) في النقد")
            .unwrap();
        assert_eq!(net_total.amount, Decimal::from(4000));
    }

    #[test]
    fn test_synthesize_zakah_statement() {
        let from = NaiveDate::from_ymd_opt(2026, 1, 1).unwrap();
        let to = NaiveDate::from_ymd_opt(2026, 12, 31).unwrap();

        let mut cash = Account::new("1000", "النقدية", "Cash", AccountKind::Asset);
        cash.classification = Some(AccountClassification::ZakahAssets);

        let mut inventory = Account::new("1300", "المخزون", "Inventory", AccountKind::Asset);
        inventory.classification = Some(AccountClassification::ZakahAssets);

        let mut ap = Account::new("2100", "الدائنون", "AP", AccountKind::Liability);
        ap.classification = Some(AccountClassification::ZakahLiabilities);

        let base = ZakahBase {
            zakatable_assets: vec![
                (cash, Decimal::from(50000)),
                (inventory, Decimal::from(100000)),
            ],
            deductible_liabilities: vec![(ap, Decimal::from(30000))],
        };

        // Base = 50000 + 100000 - 30000 = 120000
        // Zakah (Gregorian 2.5775%) = 120000 * 0.025775 = 3093
        let report = FinancialReportGenerator::synthesize_zakah_statement(
            from,
            to,
            &base,
            ZakahCalendarType::Gregorian,
        );

        let zakah_due = report
            .lines
            .iter()
            .find(|l| l.label.contains("الزكاة المستحقة"))
            .unwrap();
        assert_eq!(zakah_due.amount, Decimal::from(3093));
    }
}
