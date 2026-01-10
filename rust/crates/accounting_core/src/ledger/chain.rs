//! Ledger Hash Chain Implementation
//!
//! Implements forensic data integrity for the accounting ledger.
//! Each posted journal entry is hashed and linked to the previous entry,
//! creating a tamper-evident sequence.
//!
//! # Algorithm
//! entry.hash = SHA256(entry.hashable_content())
//! where hashable_content includes previous_entry.hash.

use super::models::JournalEntry;
use sha2::{Digest, Sha256};

/// The genesis hash for the first entry in the ledger.
pub const LEDGER_GENESIS_HASH: &str =
    "0000000000000000000000000000000000000000000000000000000000000000";

/// Compute the SHA-256 hash of entry content.
pub fn compute_entry_hash(entry: &JournalEntry) -> String {
    let content = entry.hashable_content();
    let mut hasher = Sha256::new();
    hasher.update(content.as_bytes());
    let result = hasher.finalize();
    hex::encode(result)
}

/// Verify that an entry's hash is correct.
pub fn verify_entry_hash(entry: &JournalEntry) -> bool {
    // If entry is not posted, it might not have a hash yet
    if entry.hash.is_empty() {
        return true;
    }
    let computed = compute_entry_hash(entry);
    computed == entry.hash
}

/// Verify the integrity of a sequence of entries.
///
/// # Returns
/// - `Ok(())` if chain is valid
/// - `Err(index)` where index is the first broken link
pub fn verify_ledger_chain(entries: &[JournalEntry]) -> Result<(), usize> {
    if entries.is_empty() {
        return Ok(());
    }

    // First entry should have genesis hash or be checked against a known root
    // For simplicity in this core engine, we assume the first in the slice
    // is either the start or we verify relative links.

    for (i, entry) in entries.iter().enumerate() {
        // 1. Verify self-hash
        if !verify_entry_hash(entry) {
            return Err(i);
        }

        // 2. Verify link to previous
        if i > 0 {
            if entry.previous_hash != entries[i - 1].hash {
                return Err(i);
            }
        }
    }

    Ok(())
}
