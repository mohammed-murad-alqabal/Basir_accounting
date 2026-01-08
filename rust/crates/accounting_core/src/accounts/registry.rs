//! Account Registry
//!
//! Provides efficient lookup of accounts by ID and code.

use std::collections::HashMap;
use uuid::Uuid;
use super::models::Account;

/// A registry of accounts for efficient lookup.
#[derive(Debug, Clone)]
pub struct AccountRegistry {
    accounts: HashMap<Uuid, Account>,
}

impl AccountRegistry {
    /// Create a new registry from a list of accounts.
    pub fn new(accounts: Vec<Account>) -> Self {
        let mut map = HashMap::new();
        for acc in accounts {
            map.insert(acc.id, acc);
        }
        Self { accounts: map }
    }

    /// Lookup an account by its unique ID.
    pub fn get(&self, id: &Uuid) -> Option<&Account> {
        self.accounts.get(id)
    }

    /// Check if an account exists.
    pub fn contains(&self, id: &Uuid) -> bool {
        self.accounts.contains_key(id)
    }

    /// Returns a reference to the internal map.
    pub fn inner(&self) -> &HashMap<Uuid, Account> {
        &self.accounts
    }
}
