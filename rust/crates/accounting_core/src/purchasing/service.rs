use crate::purchasing::models::PurchaseBill;
use crate::ledger::models::{
    EntryStatus, EntryType, JournalEntry, JournalEntryLine, StandardsJustification,
    TemporalJustification,
};
use rust_decimal::Decimal;
use uuid::Uuid;
use chrono::Utc;

pub struct PurchasingService;

impl PurchasingService {
    /// Generates a Journal Entry for a purchase bill according to IFRS 9.
    /// Dr Expense/Asset
    /// Cr Accounts Payable
    pub fn generate_gl_entry(
        bill: &PurchaseBill,
        created_by: Uuid,
    ) -> JournalEntry {
        let entry_id = Uuid::new_v4();
        let lines = vec![
            // Debit Expense/Asset
            JournalEntryLine {
                line_id: Uuid::new_v4(),
                line_number: 1,
                account_id: bill.expense_account_id,
                debit_amount: bill.total_amount,
                credit_amount: Decimal::ZERO,
                description: format!("Expense Recognition - {}", bill.bill_number),
                source_document_ref: Some(bill.id.to_string()),
                original_currency: None,
                exchange_rate: None,
                original_amount: None,
                partner_id: Some(bill.vendor_id),
            },
            // Credit Accounts Payable
            JournalEntryLine {
                line_id: Uuid::new_v4(),
                line_number: 2,
                account_id: bill.ap_account_id,
                debit_amount: Decimal::ZERO,
                credit_amount: bill.total_amount,
                description: format!("Accounts Payable - {}", bill.bill_number),
                source_document_ref: Some(bill.id.to_string()),
                original_currency: None,
                exchange_rate: None,
                original_amount: None,
                partner_id: Some(bill.vendor_id),
            },
        ];

        JournalEntry {
            entry_id,
            entry_number: format!("PBILL-{}", bill.bill_number),
            description: format!("Purchase Bill {}", bill.bill_number),
            entry_type: EntryType::Standard,
            status: EntryStatus::Draft,
            linked_entry_id: None,
            adjustment_reason: None,
            temporal: TemporalJustification::new(
                bill.bill_date.date_naive(),
                bill.bill_date.date_naive(),
            ),
            standards: StandardsJustification::simple("IFRS 9"),
            lines,
            created_by,
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
