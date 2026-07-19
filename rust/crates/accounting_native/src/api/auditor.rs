use crate::api::ledger::{map_dto_to_entity, EntryDto};
use accounting_core::self_healing::{Anomaly as CoreAnomaly, Auditor as CoreAuditor};
use flutter_rust_bridge::frb;

#[derive(Debug, Clone)]
pub enum AnomalyDto {
    SequenceGap {
        expected: String,
        found: String,
    },
    ReconciliationMismatch {
        account_id: String,
        book_balance: String,
        physical_count: String,
    },
    OrphanedDraft {
        entry_id: String,
        date: String,
    },
}

#[frb(sync)]
pub fn scan_sequence(prefix: String, entries: Vec<EntryDto>) -> anyhow::Result<Vec<AnomalyDto>> {
    let mut core_entries = Vec::new();
    for dto in entries {
        core_entries.push(map_dto_to_entity(dto)?);
    }

    let anomalies = CoreAuditor::scan_sequence(&prefix, &core_entries);

    Ok(anomalies
        .into_iter()
        .map(|a| match a {
            CoreAnomaly::SequenceGap { expected, found } => {
                AnomalyDto::SequenceGap { expected, found }
            }
            CoreAnomaly::ReconciliationMismatch {
                account_id,
                book_balance,
                physical_count,
            } => AnomalyDto::ReconciliationMismatch {
                account_id: account_id.to_string(),
                book_balance: book_balance.to_string(),
                physical_count: physical_count.to_string(),
            },
            CoreAnomaly::OrphanedDraft { entry_id, date } => AnomalyDto::OrphanedDraft {
                entry_id: entry_id.to_string(),
                date: date.to_string(),
            },
        })
        .collect())
}
