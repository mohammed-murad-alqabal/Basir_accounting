//! Sales & Accounts Receivable Domain Models
//!
//! Implements IFRS 15 (Revenue Recognition) and IFRS 9 (Financial Assets).

use rust_decimal::Decimal;
use serde::{Deserialize, Serialize};
use uuid::Uuid;
use chrono::{DateTime, Utc};

/// Status of a sales invoice.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum SalesInvoiceStatus {
    /// Initial draft, not yet posted to ledger.
    Draft,
    /// Posted to ledger, legally binding.
    Posted,
    /// At least one payment recorded.
    PartiallyPaid,
    /// Balance is zero.
    Paid,
    /// Formal reversal/cancellation.
    Cancelled,
}

/// A Sales Invoice representing a revenue event (IFRS 15).
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SalesInvoice {
    pub id: Uuid,
    /// External serial number (e.g., INV-2026-001).
    pub invoice_number: String,
    /// Customer (Partner) identifier.
    pub customer_id: Uuid,
    /// The date the revenue is recognized (Accrual basis).
    pub invoice_date: DateTime<Utc>,
    /// Payment deadline.
    pub due_date: DateTime<Utc>,
    /// Total amount including taxes and discounts.
    pub total_amount: Decimal,
    /// Remaining amount to be paid.
    pub balance_due: Decimal,
    pub status: SalesInvoiceStatus,
    /// Revenue account ID (Income).
    pub income_account_id: Uuid,
    /// Accounts Receivable account ID (Asset).
    pub ar_account_id: Uuid,
    /// Reference to the General Ledger entry.
    pub gl_entry_id: Option<Uuid>,
    pub description: Option<String>,
    
    // ZATCA Compliance
    pub zatca_uuid: Option<Uuid>,
    pub zatca_hash: Option<String>,
    pub zatca_previous_hash: Option<String>,
    pub xml_content: Option<String>,
    pub qr_code_data: Option<String>,
}

/// A line item within a sales invoice.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SalesInvoiceLine {
    pub id: Uuid,
    pub invoice_id: Uuid,
    pub product_id: Option<Uuid>,
    pub description: String,
    pub quantity: Decimal,
    pub unit_price: Decimal,
    pub tax_amount: Decimal,
    pub total_amount: Decimal,
}

/// A payment received from a customer (IFRS 9).
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CustomerPayment {
    pub id: Uuid,
    pub invoice_id: Uuid,
    pub payment_date: DateTime<Utc>,
    pub amount: Decimal,
    /// Bank or Cash account where funds are deposited.
    pub bank_account_id: Uuid,
    pub payment_method: String,
    /// Reference to the General Ledger entry.
    pub gl_entry_id: Option<Uuid>,
    pub reference: Option<String>,
}
