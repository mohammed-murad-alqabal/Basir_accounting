//! Standards Reference Data Models
//!
//! Derived from `design.md` Section 5.2: Standards Reference Model
//!
//! # Requirements Alignment
//! - Req 1.1: IFRS Conceptual Framework as governing basis
//! - Req 1.6: Standards Registry linking every treatment to source
//! - Req 2.3: Standards justification for journal entries

use chrono::NaiveDate;
use serde::{Deserialize, Serialize};
use uuid::Uuid;

/// Standard issuing body enumeration.
///
/// Supports IFRS as primary, with US GAAP/UK GAAP as compatibility layers
/// and AAOIFI for Islamic finance. Also includes audit/control frameworks.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub enum StandardBody {
    /// International Financial Reporting Standards
    IFRS,
    /// International Accounting Standards (legacy, now part of IFRS)
    IAS,
    /// US Generally Accepted Accounting Principles
    UsGaap,
    /// UK Generally Accepted Accounting Principles
    UkGaap,
    /// Accounting and Auditing Organization for Islamic Financial Institutions
    AAOIFI,
    /// International Standards on Auditing (IAASB)
    ISA,
    /// Sarbanes-Oxley Act (US)
    SOX,
    /// Committee of Sponsoring Organizations of the Treadway Commission
    COSO,
}

impl std::fmt::Display for StandardBody {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            StandardBody::IFRS => write!(f, "IFRS"),
            StandardBody::IAS => write!(f, "IAS"),
            StandardBody::UsGaap => write!(f, "US GAAP"),
            StandardBody::UkGaap => write!(f, "UK GAAP"),
            StandardBody::AAOIFI => write!(f, "AAOIFI"),
            StandardBody::ISA => write!(f, "ISA"),
            StandardBody::SOX => write!(f, "SOX"),
            StandardBody::COSO => write!(f, "COSO"),
        }
    }
}

/// A reference to a specific accounting standard at paragraph level.
///
/// This is the core unit of standards traceability. Every journal entry
/// must reference at least one `StandardReference` to satisfy Req 2.3.
///
/// # Format
/// Standard references follow the pattern: `{BODY} {NUMBER}.{PARAGRAPH}`
///
/// # Examples
/// - `IFRS 15.35` - Revenue recognition timing
/// - `IAS 21.23` - Foreign currency translation
/// - `AAOIFI FAS 9.5` - Zakah calculation
#[derive(Debug, Clone, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub struct StandardReference {
    /// Unique identifier for this reference
    pub id: Uuid,
    /// Standard issuing body (IFRS, IAS, etc.)
    pub body: StandardBody,
    /// Standard number (e.g., "15" for IFRS 15)
    pub number: String,
    /// Paragraph reference (e.g., "35" or "B1-B45")
    pub paragraph: String,
}

impl StandardReference {
    /// Create a new standard reference.
    pub fn new(body: StandardBody, number: &str, paragraph: &str) -> Self {
        Self {
            id: Uuid::new_v4(),
            body,
            number: number.to_string(),
            paragraph: paragraph.to_string(),
        }
    }

    /// Parse a standard reference from string format.
    ///
    /// # Format
    /// `{BODY} {NUMBER}.{PARAGRAPH}` e.g., "IFRS 15.35"
    ///
    /// # Returns
    /// `Some(StandardReference)` if valid, `None` otherwise.
    pub fn parse(s: &str) -> Option<Self> {
        let parts: Vec<&str> = s.split_whitespace().collect();
        if parts.len() != 2 {
            return None;
        }

        let body = match parts[0].to_uppercase().as_str() {
            "IFRS" => StandardBody::IFRS,
            "IAS" => StandardBody::IAS,
            "US" | "USGAAP" => StandardBody::UsGaap,
            "UK" | "UKGAAP" => StandardBody::UkGaap,
            "AAOIFI" => StandardBody::AAOIFI,
            "ISA" => StandardBody::ISA,
            "SOX" => StandardBody::SOX,
            "COSO" => StandardBody::COSO,
            _ => return None,
        };

        let num_para: Vec<&str> = parts[1].splitn(2, '.').collect();
        if num_para.len() != 2 {
            return None;
        }

        Some(Self::new(body, num_para[0], num_para[1]))
    }

    /// Format the reference as a canonical string.
    ///
    /// # Returns
    /// String in format `{BODY} {NUMBER}.{PARAGRAPH}`
    pub fn to_canonical(&self) -> String {
        format!("{} {}.{}", self.body, self.number, self.paragraph)
    }
}

impl std::fmt::Display for StandardReference {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.to_canonical())
    }
}

/// Complete standard entry with full metadata.
///
/// This represents a complete standard or paragraph in the registry,
/// including the full text, effective dates, and supersession chain.
///
/// # Design Reference
/// `design.md` Section 5.2: Standards Reference Model
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct StandardEntry {
    /// The reference identifier
    pub reference: StandardReference,
    /// Human-readable title
    pub title: String,
    /// Full text of the standard/paragraph
    pub full_text: String,
    /// Date this standard became effective
    pub effective_date: NaiveDate,
    /// References this standard supersedes (if any)
    pub supersedes: Vec<StandardReference>,
    /// Reference that superseded this standard (if any)
    pub superseded_by: Option<StandardReference>,
}

impl StandardEntry {
    /// Check if this standard is currently effective.
    pub fn is_effective(&self, as_of: NaiveDate) -> bool {
        self.effective_date <= as_of && self.superseded_by.is_none()
    }
}

/// The basis for recognizing an item in the financial statements.
///
/// Derived from IFRS Conceptual Framework Chapter 5.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub enum RecognitionBasis {
    /// Recognition based on the time transaction/event occurs (Standard IFRS)
    Accrual,
    /// Recognition based on cash receipt/payment
    Cash,
}

impl std::fmt::Display for RecognitionBasis {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            RecognitionBasis::Accrual => write!(f, "Accrual"),
            RecognitionBasis::Cash => write!(f, "Cash"),
        }
    }
}

/// The basis for measuring an item in the financial statements.
///
/// Derived from IFRS Conceptual Framework Chapter 6.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub enum MeasurementBasis {
    /// Transaction price or cost (IFRS CF 6.4-6.9)
    HistoricalCost,
    /// Current price in an active market (IFRS 13)
    FairValue,
    /// Value from using the asset (IFRS CF 6.17)
    ValueInUse,
    /// Cost to replace the asset today (IFRS CF 6.21)
    CurrentCost,
}

impl std::fmt::Display for MeasurementBasis {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            MeasurementBasis::HistoricalCost => write!(f, "Historical Cost"),
            MeasurementBasis::FairValue => write!(f, "Fair Value"),
            MeasurementBasis::ValueInUse => write!(f, "Value in Use"),
            MeasurementBasis::CurrentCost => write!(f, "Current Cost"),
        }
    }
}

/// Status of recognition criteria according to IFRS CF Chapter 5.
///
/// Ensures that an item is only recognized if it meets the definition
/// of an element and provides useful information.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RecognitionStatus {
    /// Does the item meet the definition of an Asset, Liability, Equity, Income, or Expense?
    pub definition_met: bool,
    /// Is acknowledgment of the item relevant?
    pub relevant: bool,
    /// Can the item be measured faithfully?
    pub faithful_representation: bool,
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_ifrs_reference() {
        let ref_ = StandardReference::parse("IFRS 15.35").unwrap();
        assert_eq!(ref_.body, StandardBody::IFRS);
        assert_eq!(ref_.number, "15");
        assert_eq!(ref_.paragraph, "35");
    }

    #[test]
    fn test_parse_ias_reference() {
        let ref_ = StandardReference::parse("IAS 21.23").unwrap();
        assert_eq!(ref_.body, StandardBody::IAS);
        assert_eq!(ref_.number, "21");
        assert_eq!(ref_.paragraph, "23");
    }

    #[test]
    fn test_canonical_format() {
        let ref_ = StandardReference::new(StandardBody::IFRS, "15", "35");
        assert_eq!(ref_.to_canonical(), "IFRS 15.35");
    }

    #[test]
    fn test_invalid_reference_rejected() {
        assert!(StandardReference::parse("InvalidRef").is_none());
        assert!(StandardReference::parse("IFRS 15").is_none()); // No paragraph
        assert!(StandardReference::parse("15.35").is_none()); // No body
    }
}
