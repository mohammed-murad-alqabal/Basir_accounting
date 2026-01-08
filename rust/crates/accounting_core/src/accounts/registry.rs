//! Account Registry
//!
//! Provides efficient lookup of accounts by ID and code.

use super::models::{Account, HierarchyError};
use std::collections::HashMap;
use uuid::Uuid;

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

    /// Validate the entire hierarchy for circular references.
    pub fn validate_hierarchy(&self) -> Result<(), HierarchyError> {
        for id in self.accounts.keys() {
            let mut visited = std::collections::HashSet::new();
            let mut current_id = Some(*id);

            while let Some(cid) = current_id {
                if !visited.insert(cid) {
                    return Err(HierarchyError::CircularReference(cid));
                }
                current_id = self.accounts.get(&cid).and_then(|a| a.parent_id);
            }
        }
        Ok(())
    }

    /// Validate taxonomy consistency (children must be compatible with parents).
    pub fn validate_taxonomy(&self) -> Result<(), HierarchyError> {
        for account in self.accounts.values() {
            if let Some(parent_id) = account.parent_id {
                let parent = self
                    .get(&parent_id)
                    .ok_or(HierarchyError::ParentNotFound(parent_id))?;

                if !account.kind.is_compatible_with(&parent.kind) {
                    return Err(HierarchyError::IncompatibleKind {
                        child: account.id,
                        child_kind: account.kind,
                        parent: parent.id,
                        parent_kind: parent.kind,
                    });
                }
            }
        }
        Ok(())
    }

    /// Check if an account is a leaf node (has no children).
    pub fn is_leaf(&self, id: &Uuid) -> bool {
        !self.accounts.values().any(|a| a.parent_id == Some(*id))
    }

    /// Get all direct children of an account.
    pub fn get_children(&self, id: &Uuid) -> Vec<&Account> {
        self.accounts
            .values()
            .filter(|a| a.parent_id == Some(*id))
            .collect()
    }
}
