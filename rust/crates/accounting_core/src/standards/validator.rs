//! Standards Reference Validator
//!
//! Implements validation logic for standards references.
//! Ensures that all references follow the correct format and exist in
//! the registry.
//!
//! # Requirements Alignment
//! - Req 1.6: Validate Standard.Paragraph format
//! - Req 2.3: Verify reference exists in registry

use thiserror::Error;

use super::models::StandardReference;
use super::registry::StandardsRegistry;

/// Errors that can occur during standards validation.
#[derive(Debug, Error)]
pub enum ValidationError {
    /// The reference format is invalid.
    #[error("Invalid reference format: {0}. Expected: BODY NUMBER.PARAGRAPH")]
    InvalidFormat(String),

    /// The reference does not exist in the registry.
    #[error("Reference not found in registry: {0}")]
    NotFound(String),

    /// The reference is not effective on the given date.
    #[error("Reference {0} is not effective on {1}")]
    NotEffective(String, String),
}

/// Result type for validation operations.
pub type ValidationResult<T> = Result<T, ValidationError>;

/// Validate a standards reference string.
///
/// # Arguments
/// * `reference` - The reference string to validate (e.g., "IFRS 15.35")
///
/// # Returns
/// `Ok(StandardReference)` if valid, `Err(ValidationError)` otherwise.
pub fn validate_format(reference: &str) -> ValidationResult<StandardReference> {
    StandardReference::parse(reference).ok_or_else(|| {
        ValidationError::InvalidFormat(reference.to_string())
    })
}

/// Validate that a reference exists in the registry.
///
/// # Arguments
/// * `reference` - The reference to validate
/// * `registry` - The registry to check against
///
/// # Returns
/// `Ok(())` if reference exists, `Err(ValidationError)` otherwise.
pub fn validate_exists(
    reference: &str,
    registry: &StandardsRegistry,
) -> ValidationResult<()> {
    if registry.contains(reference) {
        Ok(())
    } else {
        Err(ValidationError::NotFound(reference.to_string()))
    }
}

/// Fully validate a standards reference.
///
/// This performs both format validation and registry lookup.
///
/// # Arguments
/// * `reference` - The reference string to validate
/// * `registry` - The registry to check against
///
/// # Returns
/// `Ok(StandardReference)` if valid and exists, error otherwise.
pub fn validate_complete(
    reference: &str,
    registry: &StandardsRegistry,
) -> ValidationResult<StandardReference> {
    let parsed = validate_format(reference)?;
    validate_exists(reference, registry)?;
    Ok(parsed)
}

/// Validate a standards reference including effective date check.
///
/// Task 1.4: Check effective date applicability
///
/// # Arguments
/// * `reference` - The reference string to validate
/// * `registry` - The registry to check against
/// * `as_of_date` - The date to check effectiveness for
///
/// # Returns
/// `Ok(StandardReference)` if valid, exists, and effective on the given date.
pub fn validate_effective(
    reference: &str,
    registry: &StandardsRegistry,
    as_of_date: chrono::NaiveDate,
) -> ValidationResult<StandardReference> {
    let parsed = validate_format(reference)?;
    validate_exists(reference, registry)?;
    
    let entry = registry.lookup(reference)
        .expect("Entry must exist after validate_exists");
    
    if !entry.is_effective(as_of_date) {
        return Err(ValidationError::NotEffective(
            reference.to_string(),
            as_of_date.to_string(),
        ));
    }
    
    Ok(parsed)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_validate_format_valid() {
        let result = validate_format("IFRS 15.35");
        assert!(result.is_ok());
    }

    #[test]
    fn test_validate_format_invalid() {
        let result = validate_format("InvalidRef");
        assert!(matches!(result, Err(ValidationError::InvalidFormat(_))));
    }

    #[test]
    fn test_validate_exists() {
        let registry = StandardsRegistry::load_defaults();
        assert!(validate_exists("IFRS 15.35", &registry).is_ok());
        assert!(validate_exists("FAKE 999.1", &registry).is_err());
    }

    #[test]
    fn test_validate_complete() {
        let registry = StandardsRegistry::load_defaults();
        let result = validate_complete("IFRS 15.35", &registry);
        assert!(result.is_ok());
    }
}
