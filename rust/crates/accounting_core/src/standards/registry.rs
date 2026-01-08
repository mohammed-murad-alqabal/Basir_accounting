//! Standards Registry
//!
//! Central repository for all accounting standards references.
//! Implements the lookup and storage interfaces from `design.md` Section 3.1.
//!
//! # Interfaces (from spec)
//! - `StandardsLookup`: Query standards by number, paragraph, or keyword
//! - `TreatmentValidation`: Validate treatment against applicable standard
//! - `ReferenceGeneration`: Generate Standard.Paragraph citations
//! - `EffectiveDateCheck`: Verify standard applicability for transaction date

use chrono::NaiveDate;
use std::collections::HashMap;
use uuid::Uuid;

use super::models::{StandardBody, StandardEntry, StandardReference};

/// The Standards Registry - central repository for all accounting standards.
///
/// This implements the core lookup functionality required by Req 1.6:
/// "THE system SHALL maintain a Standards_Registry linking every accounting
/// treatment to its authoritative source with paragraph reference."
#[derive(Debug, Default)]
pub struct StandardsRegistry {
    /// Map from canonical reference string to entry
    entries: HashMap<String, StandardEntry>,
    /// Index by standard number for range queries
    by_number: HashMap<(StandardBody, String), Vec<Uuid>>,
}

impl StandardsRegistry {
    /// Create a new empty registry.
    pub fn new() -> Self {
        Self::default()
    }

    /// Create a registry from a collection of entries.
    pub fn from_entries(entries: Vec<StandardEntry>) -> Self {
        let mut registry = Self::new();
        for entry in entries {
            registry.register(entry);
        }
        registry
    }

    /// Register a new standard entry.
    pub fn register(&mut self, entry: StandardEntry) {
        let key = entry.reference.to_canonical();
        let id = entry.reference.id;
        let body = entry.reference.body;
        let number = entry.reference.number.clone();

        self.entries.insert(key, entry);

        self.by_number
            .entry((body, number))
            .or_default()
            .push(id);
    }

    /// Look up a standard by its canonical reference string.
    ///
    /// # Arguments
    /// * `reference` - Canonical reference (e.g., "IFRS 15.35")
    ///
    /// # Returns
    /// The `StandardEntry` if found.
    pub fn lookup(&self, reference: &str) -> Option<&StandardEntry> {
        self.entries.get(reference)
    }

    /// Look up a standard by its parsed reference.
    pub fn lookup_ref(&self, reference: &StandardReference) -> Option<&StandardEntry> {
        self.lookup(&reference.to_canonical())
    }

    /// Check if a reference exists in the registry.
    pub fn contains(&self, reference: &str) -> bool {
        self.entries.contains_key(reference)
    }

    /// Validate that a reference exists and is effective.
    ///
    /// # Arguments
    /// * `reference` - The reference to validate
    /// * `as_of` - The date to check effectiveness against
    ///
    /// # Returns
    /// `true` if reference exists and is effective on the given date.
    pub fn is_valid(&self, reference: &str, as_of: NaiveDate) -> bool {
        self.lookup(reference)
            .map(|e| e.is_effective(as_of))
            .unwrap_or(false)
    }

    /// Get all entries for a specific standard number.
    ///
    /// # Example
    /// Get all paragraphs for IFRS 15:
    /// ```ignore
    /// registry.get_by_standard(StandardBody::IFRS, "15")
    /// ```
    pub fn get_by_standard(
        &self,
        body: StandardBody,
        number: &str,
    ) -> Vec<&StandardEntry> {
        self.by_number
            .get(&(body, number.to_string()))
            .map(|ids| {
                ids.iter()
                    .filter_map(|id| {
                        self.entries.values().find(|e| e.reference.id == *id)
                    })
                    .collect()
            })
            .unwrap_or_default()
    }

    /// Get the total number of entries in the registry.
    pub fn len(&self) -> usize {
        self.entries.len()
    }

    /// Check if the registry is empty.
    pub fn is_empty(&self) -> bool {
        self.entries.is_empty()
    }

    /// Search for standards by keyword in title or full_text.
    ///
    /// Task 1.3: Query by topic/keyword
    ///
    /// # Arguments
    /// * `keyword` - The search term (case-insensitive)
    ///
    /// # Returns
    /// All entries whose title or full_text contain the keyword.
    pub fn search_by_keyword(&self, keyword: &str) -> Vec<&StandardEntry> {
        let keyword_lower = keyword.to_lowercase();
        self.entries
            .values()
            .filter(|e| {
                e.title.to_lowercase().contains(&keyword_lower)
                    || e.full_text.to_lowercase().contains(&keyword_lower)
            })
            .collect()
    }

    /// Get all entries in the registry.
    pub fn list_all(&self) -> Vec<&StandardEntry> {
        self.entries.values().collect()
    }

    /// Get all entries for a specific standard body.
    ///
    /// # Arguments
    /// * `body` - The standard body (IFRS, IAS, etc.)
    pub fn get_by_body(&self, body: StandardBody) -> Vec<&StandardEntry> {
        self.entries
            .values()
            .filter(|e| e.reference.body == body)
            .collect()
    }

    /// Load the default IFRS standards for MVP Phase 1.
    ///
    /// This loads the core standards required by `tasks.md` Phase 1.1:
    /// - IFRS Conceptual Framework 2018 (Task 2.1)
    /// - IAS 1 (Presentation) (Task 2.2)
    /// - IAS 8 (Accounting Policies) (Task 2.2)
    /// - IAS 10 (Events After Reporting Period) (Task 2.2)
    /// - IFRS 15 (Revenue Recognition) (Task 2.2)
    pub fn load_defaults() -> Self {
        let mut registry = Self::new();

        // Load all standards from the data module
        for entry in super::data::load_all_standards() {
            registry.register(entry);
        }

        // Keep legacy IAS 21 entry for compatibility
        registry.register(StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "21", "23"),
            title: "Reporting at End of Subsequent Periods".to_string(),
            full_text: "At the end of each reporting period: (a) foreign \
                       currency monetary items shall be translated using the \
                       closing rate...".to_string(),
            effective_date: NaiveDate::from_ymd_opt(2005, 1, 1).unwrap(),
            supersedes: vec![],
            superseded_by: None,
        });

        registry
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_load_defaults() {
        let registry = StandardsRegistry::load_defaults();
        assert!(!registry.is_empty());
        assert!(registry.len() >= 7);
    }

    #[test]
    fn test_lookup_ifrs_15() {
        let registry = StandardsRegistry::load_defaults();
        let entry = registry.lookup("IFRS 15.35");
        assert!(entry.is_some());
        assert!(entry.unwrap().title.contains("Performance"));
    }

    #[test]
    fn test_lookup_invalid_ref() {
        let registry = StandardsRegistry::load_defaults();
        assert!(registry.lookup("FICTIONAL 999.1").is_none());
    }

    #[test]
    fn test_is_valid() {
        let registry = StandardsRegistry::load_defaults();
        let today = NaiveDate::from_ymd_opt(2026, 1, 3).unwrap();
        assert!(registry.is_valid("IFRS 15.35", today));
        assert!(!registry.is_valid("FICTIONAL 999.1", today));
    }
}
