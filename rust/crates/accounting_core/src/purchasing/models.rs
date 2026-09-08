//! Purchasing Domain Models
//!
//! Defines models for vendors, purchase bills, and payments.

use chrono::{DateTime, Utc};
use rust_decimal::Decimal;
use serde::{Deserialize, Serialize};
use uuid::Uuid;

/// Status of a purchase bill.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum BillStatus {
    /// Bill is being drafted.
    Draft,
    /// Bill is awaiting payment.
    Open,
    /// Bill is partially paid.
    PartiallyPaid,
    /// Bill is fully paid.
    Paid,
    /// Bill has been cancelled.
    Cancelled,
}

/// Represents a Purchase Bill (Accounts Payable).
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PurchaseBill {
    /// Unique identifier.
    pub id: Uuid,
    /// Human-readable bill number/reference.
    pub bill_number: String,
    /// Vendor reference.
    pub vendor_id: Uuid,
    /// Issue date of the bill.
    pub bill_date: DateTime<Utc>,
    /// Due date for payment.
    pub due_date: DateTime<Utc>,
    /// Total amount of the bill.
    pub total_amount: Decimal,
    /// Remaining balance to be paid.
    pub balance_due: Decimal,
    /// Current status.
    pub status: BillStatus,
    /// GL Account for the purchase (e.g., Expense or Inventory).
    pub expense_account_id: Uuid,
    /// AP Control account (Liability).
    pub ap_account_id: Uuid,
    /// Reference to the General Ledger entry.
    pub gl_entry_id: Option<Uuid>,
    /// Optional description.
    pub description: Option<String>,
}

/// Represents a payment against a bill.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct BillPayment {
    /// Unique identifier.
    pub id: Uuid,
    /// Bill being paid.
    pub bill_id: Uuid,
    /// Date of payment.
    pub payment_date: DateTime<Utc>,
    /// Amount paid.
    pub amount: Decimal,
    /// How it was paid (Cash, Bank Transfer, etc).
    pub payment_method: String,
    /// Side of the transaction (Cr. Cash/Bank).
    pub bank_account_id: Uuid,
    /// Reference to the General Ledger entry.
    pub gl_entry_id: Option<Uuid>,
    /// Optional reference/cheque number.
    pub reference: Option<String>,
}
