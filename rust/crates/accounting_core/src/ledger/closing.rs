//! Year-End Closing Logic
//!
//! Implements Req 4.4: Automated Year-End Closing entries.
//!
//! Revenue and Expense accounts are cleared to zero, and the net
//! profit/loss is transferred to the Retained Earnings account.

use chrono::{NaiveDate, Utc};
use rust_decimal::Decimal;
use uuid::Uuid;

use crate::accounts::models::{Account, AccountKind};
use crate::ledger::models::{
    EntryStatus, EntryType, JournalEntry, JournalEntryLine, StandardsJustification,
    TemporalJustification,
};
use crate::reporting::generate_trial_balance;

/// Generator for specialized closing entries.
pub struct ClosingEntryGenerator;

impl ClosingEntryGenerator {
    /// Generates a year-end closing entry for a specified period.
    ///
    /// # Logic
    /// 1. Calculate the Trial Balance for the period.
    /// 2. For each Income and Expense account with a non-zero balance:
    ///    - Create a line that reverses the balance to zero.
    /// 3. Calculate the net difference (Profit or Loss).
    /// 4. Create a final line to the Retained Earnings account to balance the entry.
    ///
    /// # Arguments
    /// * `period_name` - Descriptive name for the entry (e.g., "Year-End Closing 2025")
    /// * `closing_date` - The date of the closing (usually last day of period)
    /// * `entries` - All posted journal entries in the period
    /// * `accounts` - Full chart of accounts
    /// * `retained_earnings_id` - UUID of the Retained Earnings account (Equity)
    pub fn generate_year_end_entry(
        period_name: &str,
        closing_date: NaiveDate,
        entries: &[JournalEntry],
        accounts: &[Account],
        retained_earnings_id: Uuid,
    ) -> JournalEntry {
        // 1. Get the Trial Balance for the period
        let tb = generate_trial_balance(entries, accounts, closing_date, None);

        let mut lines = Vec::new();
        let mut net_balance = Decimal::ZERO;
        let mut line_num = 1;

        // 2. Identify and reverse Income/Expense accounts
        for tb_line in tb.lines {
            // Find the account kind to verify if it's Income or Expense
            let account = accounts.iter().find(|a| a.code == tb_line.account_code);
            if let Some(acc) = account {
                if acc.kind == AccountKind::Income || acc.kind == AccountKind::Expense {
                    let balance = tb_line.debit_balance - tb_line.credit_balance;

                    if balance != Decimal::ZERO {
                        // Reversing line:
                        // If balance is Debit (positive), we Credit it.
                        // If balance is Credit (negative), we Debit it.
                        let debit = if balance < Decimal::ZERO {
                            balance.abs()
                        } else {
                            Decimal::ZERO
                        };
                        let credit = if balance > Decimal::ZERO {
                            balance
                        } else {
                            Decimal::ZERO
                        };

                        lines.push(JournalEntryLine {
                            line_id: Uuid::new_v4(),
                            line_number: line_num,
                            account_id: acc.id,
                            debit_amount: debit,
                            credit_amount: credit,
                            description: format!("Year-end clearance of {}", acc.name_en),
                            source_document_ref: None,
                            original_currency: None,
                            exchange_rate: None,
                            original_amount: None,
                            partner_id: None,
                        });

                        net_balance += balance; // Net of reversed items
                        line_num += 1;
                    }
                }
            }
        }

        // 3. Balance against Retained Earnings
        let (re_debit, re_credit) = if net_balance > Decimal::ZERO {
            (net_balance, Decimal::ZERO) // Loss
        } else {
            (Decimal::ZERO, net_balance.abs()) // Profit
        };

        lines.push(JournalEntryLine {
            line_id: Uuid::new_v4(),
            line_number: line_num,
            account_id: retained_earnings_id,
            debit_amount: re_debit,
            credit_amount: re_credit,
            description: "Transfer of net profit/loss to Retained Earnings".to_string(),
            source_document_ref: None,
            original_currency: None,
            exchange_rate: None,
            original_amount: None,
            partner_id: None,
        });

        JournalEntry {
            entry_id: Uuid::new_v4(),
            entry_number: format!("CLS-{}", period_name),
            description: format!("Year-end closing entry for {}", period_name),
            entry_type: EntryType::Closing,
            status: EntryStatus::Draft,
            linked_entry_id: None,
            adjustment_reason: None,
            temporal: TemporalJustification::new(closing_date, closing_date),
            standards: StandardsJustification::simple("IAS 1.25"),
            lines,
            created_by: Uuid::nil(),
            created_at: Utc::now(),
            approved_by: None,
            approved_at: None,
            posted_by: None,
            posted_at: None,
            hash: String::new(),
            previous_hash: String::new(),
        }
    }
}
