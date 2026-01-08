//! Trial Balance Generation
//!
//! Implements Task 16 from the specification.
//!
//! # Algorithm
//! 1. Aggregate all journal entry lines by account
//! 2. Calculate total debits and credits per account
//! 3. Determine net balance based on account normal balance type
//! 4. Generate trial balance with verification

use chrono::NaiveDate;
use rust_decimal::Decimal;
use std::collections::HashMap;
use uuid::Uuid;

use crate::accounts::models::{Account, AccountKind};
use crate::ledger::models::JournalEntry;

use super::models::{TrialBalance, TrialBalanceLine};

/// Account summary used during aggregation.
struct AccountSummary {
    code: String,
    name_ar: String,
    #[allow(dead_code)]
    name_en: String,
    kind: AccountKind,
    total_debits: Decimal,
    total_credits: Decimal,
    source_entries: Vec<Uuid>,
}

/// Generate a Trial Balance from a set of journal entries and accounts.
///
/// # Arguments
/// * `entries` - All posted journal entries to include
/// * `accounts` - The Chart of Accounts (for metadata lookup)
/// * `as_of_date` - The report date
/// * `period_start` - Optional period start for filtering
///
/// # Returns
/// A complete `TrialBalance` with verification status
///
/// # Task 16.1 & 16.2 Implementation
pub fn generate_trial_balance(
    entries: &[JournalEntry],
    accounts: &[Account],
    as_of_date: NaiveDate,
    period_start: Option<NaiveDate>,
) -> TrialBalance {
    // Build account lookup
    let account_map: HashMap<Uuid, &Account> = accounts.iter().map(|a| (a.id, a)).collect();

    // Aggregate by account
    let mut summaries: HashMap<Uuid, AccountSummary> = HashMap::new();

    for entry in entries {
        // Filter by date if period specified
        let entry_date = entry.temporal.effective_date;

        if let Some(start) = period_start {
            if entry_date < start {
                continue;
            }
        }

        if entry_date > as_of_date {
            continue;
        }

        // Process each line
        for line in &entry.lines {
            let summary = summaries.entry(line.account_id).or_insert_with(|| {
                let acc = account_map.get(&line.account_id);
                AccountSummary {
                    code: acc
                        .map(|a| a.code.clone())
                        .unwrap_or_else(|| "UNKNOWN".to_string()),
                    name_ar: acc
                        .map(|a| a.name_ar.clone())
                        .unwrap_or_else(|| "Unknown Account".to_string()),
                    name_en: acc
                        .map(|a| a.name_en.clone())
                        .unwrap_or_else(|| "Unknown Account".to_string()),
                    kind: acc.map(|a| a.kind).unwrap_or(AccountKind::Asset),
                    total_debits: Decimal::ZERO,
                    total_credits: Decimal::ZERO,
                    source_entries: Vec::new(),
                }
            });

            summary.total_debits += line.debit_amount;
            summary.total_credits += line.credit_amount;

            // Add entry ID to source entries if not already present
            if !summary.source_entries.contains(&entry.entry_id) {
                summary.source_entries.push(entry.entry_id);
            }
        }
    }

    // Generate lines
    let mut lines: Vec<TrialBalanceLine> = Vec::new();
    let mut total_debits = Decimal::ZERO;
    let mut total_credits = Decimal::ZERO;

    for (account_id, summary) in summaries {
        // Calculate net balance
        let net = summary.total_debits - summary.total_credits;

        let (debit_balance, credit_balance) = if summary.kind.is_debit_normal() {
            // For debit-normal accounts, positive net goes to debits
            if net >= Decimal::ZERO {
                (net, Decimal::ZERO)
            } else {
                (Decimal::ZERO, net.abs())
            }
        } else {
            // For credit-normal accounts, negative net (more credits) goes to credits
            if net <= Decimal::ZERO {
                (Decimal::ZERO, net.abs())
            } else {
                (net, Decimal::ZERO)
            }
        };

        total_debits += debit_balance;
        total_credits += credit_balance;

        // Only include accounts with balances
        if debit_balance != Decimal::ZERO || credit_balance != Decimal::ZERO {
            lines.push(TrialBalanceLine {
                account_id,
                account_code: summary.code,
                account_name: summary.name_ar, // Defaulting to Arabic for the report label for now
                debit_balance,
                credit_balance,
                source_entries: summary.source_entries,
            });
        }
    }

    // Sort by account code for presentation
    lines.sort_by(|a, b| a.account_code.cmp(&b.account_code));

    let is_balanced = total_debits == total_credits;

    TrialBalance {
        as_of_date,
        period_start,
        period_end: as_of_date,
        lines,
        total_debits,
        total_credits,
        is_balanced,
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::ledger::models::{
        EntryStatus, EntryType, JournalEntryLine, StandardsJustification, TemporalJustification,
    };
    use chrono::Utc;

    fn create_test_accounts() -> Vec<Account> {
        vec![
            Account::new("1000", "النقد", "Cash", AccountKind::Asset),
            Account::new(
                "2000",
                "الذمم الدائنة",
                "Accounts Payable",
                AccountKind::Liability,
            ),
            Account::new("4000", "الإيرادات", "Revenue", AccountKind::Income),
            Account::new("5000", "المصروفات", "Expenses", AccountKind::Expense),
        ]
    }

    fn create_test_entry(
        accounts: &[Account],
        debit_idx: usize,
        credit_idx: usize,
        amount: Decimal,
    ) -> JournalEntry {
        let today = Utc::now().date_naive();

        JournalEntry {
            entry_id: Uuid::new_v4(),
            entry_number: format!("JE-{}", Uuid::new_v4()),
            description: "Test Entry".to_string(),
            entry_type: EntryType::Standard,
            status: EntryStatus::Posted,
            linked_entry_id: None,
            adjustment_reason: None,
            temporal: TemporalJustification::new(today, today),
            standards: StandardsJustification::simple("IFRS Test"),
            lines: vec![
                JournalEntryLine::debit(accounts[debit_idx].id, amount, "Test Debit"),
                JournalEntryLine::credit(accounts[credit_idx].id, amount, "Test Credit"),
            ],
            created_by: Uuid::new_v4(),
            created_at: Utc::now(),
            approved_by: None,
            approved_at: None,
            posted_by: None,
            posted_at: None,
            hash: String::new(),
            previous_hash: String::new(),
        }
    }

    #[test]
    fn test_generate_trial_balance_balanced() {
        let accounts = create_test_accounts();
        let today = Utc::now().date_naive();

        // Cash Dr 1000, Revenue Cr 1000
        let entry1 = create_test_entry(&accounts, 0, 2, Decimal::from(1000));
        // Expenses Dr 500, Cash Cr 500
        let entry2 = create_test_entry(&accounts, 3, 0, Decimal::from(500));

        let entries = vec![entry1, entry2];
        let tb = generate_trial_balance(&entries, &accounts, today, None);

        assert!(tb.is_balanced, "Trial balance should be balanced");
        assert_eq!(tb.total_debits, tb.total_credits);

        // Cash: 1000 Dr - 500 Cr = 500 Dr balance
        // Revenue: 1000 Cr balance (credit-normal)
        // Expenses: 500 Dr balance (debit-normal)
        assert_eq!(tb.total_debits, Decimal::from(1000)); // 500 (Cash) + 500 (Expenses)
        assert_eq!(tb.total_credits, Decimal::from(1000)); // 1000 (Revenue)
    }

    #[test]
    fn test_generate_trial_balance_with_period_filter() {
        let accounts = create_test_accounts();
        let today = Utc::now().date_naive();
        let yesterday = today - chrono::Duration::days(1);

        // Entry from yesterday (should be excluded with today filter)
        let mut entry1 = create_test_entry(&accounts, 0, 2, Decimal::from(1000));
        entry1.temporal = TemporalJustification::new(yesterday, yesterday);

        // Entry from today
        let entry2 = create_test_entry(&accounts, 0, 2, Decimal::from(500));

        let entries = vec![entry1, entry2];

        // Filter: only today
        let tb = generate_trial_balance(&entries, &accounts, today, Some(today));

        // Only entry2 should be included
        assert_eq!(tb.total_debits, Decimal::from(500));
        assert_eq!(tb.total_credits, Decimal::from(500));
    }

    #[test]
    fn test_empty_trial_balance() {
        let accounts = create_test_accounts();
        let today = Utc::now().date_naive();

        let tb = generate_trial_balance(&[], &accounts, today, None);

        assert!(tb.is_balanced);
        assert_eq!(tb.total_debits, Decimal::ZERO);
        assert_eq!(tb.total_credits, Decimal::ZERO);
        assert!(tb.lines.is_empty());
    }
}
