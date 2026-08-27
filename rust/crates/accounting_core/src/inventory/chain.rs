use crate::inventory::models::StockMovement;
use sha2::{Digest, Sha256};

pub const GENESIS_HASH: &str = "0000000000000000000000000000000000000000000000000000000000000000";

pub fn compute_hash(content: &str) -> String {
    let mut hasher = Sha256::new();
    hasher.update(content.as_bytes());
    let result = hasher.finalize();
    hex::encode(result)
}

pub fn compute_movement_hash(movement: &StockMovement) -> String {
    let content = movement.hashable_content();
    compute_hash(&content)
}

pub fn verify_movement_hash(movement: &StockMovement) -> bool {
    let computed = compute_movement_hash(movement);
    computed == movement.hash
}

pub fn verify_chain(movements: &[StockMovement]) -> bool {
    // Sort movements by date to ensure proper chain validation
    let mut sorted = movements.to_vec();
    sorted.sort_by_key(|m| m.date);

    let mut expected_prev_hash = GENESIS_HASH.to_string();
    for m in &sorted {
        if m.previous_hash != expected_prev_hash {
            return false;
        }
        if !verify_movement_hash(m) {
            return false;
        }
        expected_prev_hash = m.hash.clone();
    }
    true
}
