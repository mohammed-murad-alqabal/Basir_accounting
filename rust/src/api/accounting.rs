use flutter_rust_bridge::frb;
use crate::api::simple::greet;

#[frb(sync)]
pub struct JournalEntry {
    pub id: String,
    pub date: String,
    pub description: String,
    pub items: Vec<JournalItem>,
}

#[frb(sync)]
pub struct JournalItem {
    pub account_id: String,
    pub debit: f64,
    pub credit: f64,
}

#[frb(sync)]
pub fn validate_entry(entry: JournalEntry) -> bool {
    let total_debit: f64 = entry.items.iter().map(|item| item.debit).sum();
    let total_credit: f64 = entry.items.iter().map(|item| item.credit).sum();
    
    (total_debit - total_credit).abs() < 1e-10
}

pub fn get_accounting_status() -> String {
    format!("Basir Accounting Engine: Operational. {}", greet("System".to_string()))
}
