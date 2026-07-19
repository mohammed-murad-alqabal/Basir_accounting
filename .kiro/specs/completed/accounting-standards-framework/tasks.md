# Implementation Plan: Accounting Standards Framework

## MVP Phase 1: Core Accounting Engine

**Document Classification:** Implementation Task List  
**Effective Date:** January 3, 2026  
**Document Status:** Approved ✅  
**Governing Documents:** requirements.md, design.md, pre-implementation-governance.md  
**Scope:** MVP Phase 1 Only (Core Accounting Engine)  
**Technology Stack:** Rust + PostgreSQL + proptest

---

## Overview

This implementation plan covers MVP Phase 1 as defined in the Pre-Implementation Governance Framework. The scope is strictly limited to:

- **Standards Registry** — Foundation for all standards references
- **Chart of Accounts** — IFRS-aligned account hierarchy
- **Double-Entry Ledger Engine** — Core accounting logic
- **Audit Trail** — Immutable, tamper-evident change tracking
- **Basic Reporting** — Trial balance with drill-down

**Technology Stack (Approved):**

- **Language:** Rust
- **Database:** PostgreSQL (Append-Only Ledger + Hash Chain)
- **Testing:** Property-Based Tests (proptest/quickcheck) — Invariant-Driven
- **Architecture:** Accounting-First, Event-Ledger Core

---

## Pre-Implementation Checklist

Before starting any task, verify:

- [x] Pre-Implementation Governance Framework approved ✅
- [x] Requirements document reviewed and understood ✅
- [x] Design document reviewed and understood ✅
- [x] Technology stack selected: Rust + PostgreSQL ✅
- [x] Development environment prepared
  - Rust toolchain (rustup, cargo)
  - PostgreSQL 15+ installed
  - proptest crate for property-based testing
  - sqlx or diesel for database access
  - tokio for async runtime

---

## Tasks

### Phase 1.1: Standards Registry Foundation

- [x] 1. Implement Standards Registry Core

  - [x] 1.1 Define Standards Reference data model

    - Standard body (IFRS, IAS, US_GAAP, UK_GAAP, AAOIFI)
    - Standard number and paragraph
    - Title, full text, effective date
    - Supersedes/superseded_by relationships
    - _Requirements: 1.1, 1.6_

  - [x] 1.2 Implement Standards Registry storage

    - Create storage mechanism for standards entries
    - Support paragraph-level granularity
    - Enable effective date tracking
    - _Requirements: 1.6_

  - [x] 1.3 Implement Standards Lookup interface

    - Query by standard number (e.g., "IFRS 15")
    - Query by paragraph (e.g., "IFRS 15.35")
    - Query by topic/keyword
    - _Requirements: 1.6_

  - [x] 1.4 Implement Reference Validation

    - Validate Standard.Paragraph format
    - Verify reference exists in registry
    - Check effective date applicability
    - _Requirements: 1.6, 2.3_

  - [x] 1.5 Write property test for Standards Registry (proptest)
    - **Property 2: Standards Reference Completeness**
    - _For any_ standards reference, it must exist in the registry and have valid format
    - Use proptest to generate arbitrary Standard.Paragraph strings
    - Verify validation rejects invalid formats, accepts valid ones
    - **Validates: Requirements 1.6, 2.3**

- [x] 2. Populate Initial Standards Data

  - [x] 2.1 Load IFRS Conceptual Framework 2018

    - Chapters 1-8 with paragraph references
    - Element definitions (Asset, Liability, Equity, Income, Expense)
    - Recognition criteria (CF 5.1-5.25)
    - Measurement bases (CF 6.1-6.22)
    - _Requirements: 1.1_

  - [x] 2.2 Load Core IFRS Standards for MVP

    - IAS 1 (Presentation)
    - IAS 8 (Accounting Policies)
    - IAS 10 (Events After Reporting Period)
    - IFRS 15 (Revenue Recognition) - structure only
    - _Requirements: 1.1_

  - [x] 2.3 Load Audit/Control Standards References
    - ISA 500 (Audit Evidence)
    - SOX 404 references
    - COSO Framework references
    - _Requirements: 5.1, 10.1_

- [x] 3. Checkpoint - Standards Registry Complete
  - Verify all core standards loaded
  - Test lookup functionality
  - Verify reference validation works
  - _Ask user if questions arise_

---

### Phase 1.2: Chart of Accounts Foundation

- [x] 4. Implement Chart of Accounts Core

  - [x] 4.1 Define Account data model

    - Account ID, code, name
    - Account type (Asset, Liability, Equity, Income, Expense)
    - IFRS taxonomy element reference
    - Hierarchy (parent_account_id, level)
    - Control flags (is_posting_account, is_active)
    - _Requirements: 3.1, 3.5_

  - [x] 4.2 Implement Account Hierarchy management

    - Create account with parent reference
    - Validate hierarchy integrity (no circular references)
    - Enforce posting only to leaf accounts
    - _Requirements: 3.1_

  - [x] 4.3 Implement IFRS Taxonomy Validation

    - Validate account classification against IFRS taxonomy
    - Ensure major classifications align (Assets, Liabilities, Equity, Income, Expenses)
    - _Requirements: 3.5_

  - [x] 4.4 Implement Account Code Management

    - Enforce unique account codes
    - Prevent duplicate accounts
    - Support hierarchical code structure
    - _Requirements: 3.6_

  - [x] 4.5 Write property test for Chart of Accounts (proptest)
    - **Property 6: Chart of Accounts Validation**
    - _For any_ account, it must have valid IFRS taxonomy element and maintain hierarchy integrity
    - Use proptest to generate arbitrary account hierarchies
    - Verify no circular references, valid taxonomy mapping
    - **Validates: Requirements 3.1, 3.5, 3.6**

- [x] 5. Create Default Chart of Accounts

  - [x] 5.1 Create Level 1 accounts (5 major classifications)

    - 1000: Assets
    - 2000: Liabilities
    - 3000: Equity
    - 4000: Income
    - 5000: Expenses
    - _Requirements: 3.1_

  - [x] 5.2 Create Level 2 sub-classifications per IAS 1.54-80A
    - Current/Non-current for Assets and Liabilities
    - Sub-categories for Income and Expenses
    - _Requirements: 3.1_

- [x] 6. Checkpoint - Chart of Accounts Complete
  - Verify hierarchy integrity
  - Test IFRS taxonomy validation
  - Verify account code uniqueness
  - _Ask user if questions arise_

---

### Phase 1.3: Double-Entry Ledger Engine

- [x] 7. Implement Journal Entry Core

  - [x] 7.1 Define Journal Entry data model

    - Entry ID, entry number, entry type
    - Status (DRAFT, PENDING_APPROVAL, APPROVED, POSTED, REVERSED)
    - Temporal justification (transaction_date, effective_date, recording_date)
    - Standards justification (standard_reference, recognition_basis, measurement_basis)
    - Audit metadata (created_by, approved_by, posted_by, timestamps)
    - Hash for integrity
    - _Requirements: 2.2, 2.3_

  - [x] 7.2 Define Journal Entry Line data model

    - Line ID, entry ID, line number
    - Account ID reference
    - Debit amount, credit amount
    - Description
    - Source document reference
    - _Requirements: 2.1_

  - [x] 7.3 Implement Balance Enforcement

    - Calculate Σ(Debits) and Σ(Credits) for entry
    - Reject entry if not balanced (Σ Debits ≠ Σ Credits)
    - Zero tolerance - no exceptions
    - _Requirements: 2.1, 2.6_

  - [x] 7.4 Write property test for Double-Entry Balance (proptest)
    - **Property 1: Double-Entry Balance Enforcement**
    - _For any_ journal entry, Σ(Debits) must equal Σ(Credits)
    - Use proptest to generate arbitrary entry lines with rust_decimal amounts
    - Verify balanced entries accepted, unbalanced rejected
    - Test with edge cases: zero amounts, many lines, large amounts
    - **Validates: Requirements 2.1, 2.6**

- [x] 8. Implement Temporal Justification

  - [x] 8.1 Implement three-date validation

    - Transaction date: required, must be valid date
    - Effective date: required, must be ≤ recording date
    - Recording date: system-generated timestamp
    - _Requirements: 2.2_

  - [x] 8.2 Implement date relationship validation

    - Effective date cannot be in future beyond tolerance
    - Transaction date must be reasonable
    - _Requirements: 2.2_

  - [x] 8.3 Write property test for Temporal Justification (proptest)
    - **Property 8: Temporal Justification Completeness**
    - _For any_ journal entry, all three dates must be present and valid
    - Use proptest to generate arbitrary date combinations
    - Verify effective_date ≤ recording_date invariant
    - **Validates: Requirements 2.2**

- [x] 9. Implement Standards Justification

  - [x] 9.1 Implement standards reference requirement

    - Standard reference field required for posting
    - Validate reference against Standards Registry
    - Format: Standard.Paragraph (e.g., "IFRS 15.35")
    - _Requirements: 2.3, 1.6_

  - [x] 9.2 Implement recognition and measurement basis
    - Recognition basis field (optional but recommended)
    - Measurement basis field (optional but recommended)
    - _Requirements: 2.3_

- [x] 10. Implement Append-Only Ledger

  - [x] 10.1 Implement entry posting mechanism

    - Validate entry is balanced
    - Validate standards reference
    - Validate temporal justification
    - Generate entry hash
    - Post to ledger (append-only)
    - _Requirements: 2.4, 2.6_

  - [x] 10.2 Implement immutability enforcement

    - Prevent modification of posted entries
    - Prevent deletion of posted entries
    - Only allow status changes through defined workflows
    - _Requirements: 2.4_

  - [x] 10.3 Implement entry reversal mechanism

    - Create reversing entry (complete reversal)
    - Link reversal to original entry
    - Require error documentation
    - _Requirements: 2.5_

  - [x] 10.4 Implement adjustment entry mechanism
    - Create adjustment entry with justification
    - Link adjustment to original entry
    - Require adjustment documentation
    - _Requirements: 2.5_

- [x] 11. Checkpoint - Double-Entry Engine Complete
  - Verify balance enforcement (reject unbalanced)
  - Test standards reference requirement
  - Test immutability (cannot modify posted)
  - Test reversal workflow
  - _Ask user if questions arise_

---

### Phase 1.4: Audit Trail Foundation

- [x] 12. Implement Audit Trail Core

  - [x] 12.1 Define Audit Record data model

    - Record ID
    - 5W+H fields:
      - Who: user_id, user_name, role, session_id
      - What: action, entity_type, entity_id, change_description, old_value, new_value
      - When: timestamp (UTC, millisecond precision)
      - Where: system_id, ip_address
      - Why: reason_code, justification
      - How: method, procedure_reference
    - Integrity fields: hash, previous_hash
    - _Requirements: 5.2_

  - [x] 12.2 Implement 5W+H recording

    - Capture all required fields for every change
    - Automatic timestamp from trusted source
    - User context capture
    - _Requirements: 5.2_

  - [x] 12.3 Implement cryptographic hash chain

    - SHA-256 hash of record content
    - Include previous record hash in current record
    - Enable chain verification
    - _Requirements: 5.1_

  - [x] 12.4 Write property test for Audit Trail Immutability (proptest)
    - **Property 3: Audit Trail Immutability**
    - _For any_ audit record, it cannot be modified or deleted after creation
    - Hash chain must remain intact
    - Use proptest to generate arbitrary audit records
    - Verify SHA-256 hash chain integrity
    - Test tamper detection by modifying records
    - **Validates: Requirements 5.1, 5.3, 5.4**

- [x] 13. Implement Audit Trail Operations

  - [x] 13.1 Implement change recording

    - Automatically record all journal entry operations
    - Record account changes
    - Record standards registry changes
    - _Requirements: 5.2_

  - [x] 13.2 Implement tamper detection

    - Verify hash chain integrity
    - Detect any breaks in chain
    - Alert on integrity violations
    - _Requirements: 5.1_

  - [x] 13.3 Implement audit trail query
    - Query by entity (journal entry, account)
    - Query by user
    - Query by date range
    - Query by action type
    - _Requirements: 5.6, 10.4_

- [x] 14. Implement Traceability Chain

  - [x] 14.1 Define Traceability Chain data model

    - Chain ID
    - Links: entry → source_document → transaction → standards_reference
    - _Requirements: 5.6_

  - [x] 14.2 Implement trace-to-source capability

    - From journal entry to standards reference
    - Navigate full chain
    - _Requirements: 5.6, 10.5_

  - [x] 14.3 Write property test for Traceability (proptest)
    - **Property 9: Traceability Completeness**
    - _For any_ journal entry, a complete traceability chain must exist to standards reference
    - Use proptest to generate arbitrary entries
    - Verify chain: entry → source_doc → transaction → standards_ref
    - **Validates: Requirements 5.6, 10.5**

- [x] 15. Checkpoint - Audit Trail Complete
  - Test 5W+H recording completeness
  - Test hash chain integrity verification
  - Test tamper detection
  - Test traceability chain navigation
  - _Ask user if questions arise_

---

### Phase 1.5: Basic Reporting

- [x] 16. Implement Trial Balance

  - [x] 16.1 Implement account balance calculation

    - Sum debits and credits per account
    - Calculate net balance
    - Support period filtering
    - _Requirements: 8.5_

  - [x] 16.2 Implement trial balance generation

    - List all accounts with balances
    - Show opening, movements, closing
    - Verify total debits = total credits
    - _Requirements: 8.5_

  - [x] 16.3 Implement drill-down capability
    - From account balance to journal entries
    - From journal entry to audit trail
    - From entry to standards reference
    - _Requirements: 8.8_

- [x] 17. Implement Basic Query Interface

  - [x] 17.1 Implement journal entry query

    - Query by date range
    - Query by account
    - Query by standards reference
    - Query by status
    - _Requirements: 8.8_

  - [x] 17.2 Implement account balance query
    - Balance as of date
    - Balance for period
    - Movement analysis
    - _Requirements: 8.5_

- [x] 18. Checkpoint - Basic Reporting Complete
  - Test trial balance generation
  - Test drill-down from balance to entry
  - Test drill-down from entry to standards
  - Verify total debits = total credits in trial balance
  - _Ask user if questions arise_

---

### Phase 1.6: Integration and Verification

- [x] 19. End-to-End Integration Testing

  - [x] 19.1 Test complete entry workflow

    - Create entry with standards reference
    - Validate balance
    - Post to ledger
    - Verify audit trail
    - Query in trial balance
    - Drill down to source
    - _Requirements: All MVP requirements_

  - [x] 19.2 Test error scenarios

    - Unbalanced entry rejection
    - Missing standards reference rejection
    - Immutability enforcement
    - Audit trail integrity
    - _Requirements: 2.1, 2.3, 2.4, 2.6, 5.1_

  - [x] 19.3 Test reversal workflow
    - Create entry
    - Post entry
    - Create reversal
    - Verify audit trail captures both
    - Verify net balance is zero
    - _Requirements: 2.5_

- [x] 20. MVP Verification Against Success Criteria

  - [x] 20.1 Verify functional criteria

    - "A journal entry cannot be created without a valid standards reference" ✓
    - "A journal entry cannot be posted if debits ≠ credits" ✓
    - "A posted entry cannot be modified or deleted" ✓
    - "Every change is recorded with 5W+H in tamper-evident audit trail" ✓
    - "Any entry can be traced to its authoritative standard" ✓
    - _Requirements: MVP Success Criteria_

  - [x] 20.2 Verify audit criteria

    - External auditor can verify audit trail integrity
    - External auditor can trace any balance to source entries
    - External auditor can verify standards compliance for any entry
    - _Requirements: 10.1, 10.2, 10.5_

  - [x] 20.3 Verify quality criteria
    - Zero tolerance for unbalanced entries
    - Zero tolerance for entries without standards reference
    - 100% audit trail coverage
    - Hash chain integrity maintained
    - _Requirements: MVP Success Criteria_

- [x] 21. Final Checkpoint - MVP Phase 1 Complete
  - All functional criteria verified
  - All audit criteria verified
  - All quality criteria verified
  - Documentation complete
  - Ready for Phase 2 planning
  - _Ask user for final review_

---

## Post-MVP Notes

### Deferred to Phase 2

- Multi-entity support
- Multi-currency engine (IAS 21)
- Recognition engine (IFRS CF Ch.5-6)
- Sub-ledgers (AP, AR, Inventory, Fixed Assets)
- Period management and closing cycles
- Full internal control implementation

### Deferred to Phase 3

- Complete financial statements
- XBRL output
- Consolidation

### Deferred to Phase 4

- Local Adaptation Engine
- Tax calculations
- Zakah calculations
- Islamic finance transactions
- ESG reporting

---

## Technology Decision Point

### Approved Technology Stack ✅

| Component        | Selection         | Rationale                                                             |
| :--------------- | :---------------- | :-------------------------------------------------------------------- |
| **Language**     | Rust              | Memory safety, performance, strong type system for financial accuracy |
| **Database**     | PostgreSQL        | ACID compliance, append-only support, hash chain integrity            |
| **Testing**      | proptest          | Property-based testing for invariant verification                     |
| **Architecture** | Event-Ledger Core | Accounting-first, immutable event sourcing                            |

### Rust Crates (Recommended)

```toml
[dependencies]
# Async runtime
tokio = { version = "1", features = ["full"] }

# Database
sqlx = { version = "0.7", features = ["runtime-tokio", "postgres", "uuid", "chrono", "rust_decimal"] }

# Serialization
serde = { version = "1", features = ["derive"] }
serde_json = "1"

# Cryptography (for hash chain)
sha2 = "0.10"
hex = "0.4"

# Decimal arithmetic (financial precision)
rust_decimal = { version = "1", features = ["db-postgres"] }

# UUID generation
uuid = { version = "1", features = ["v4", "serde"] }

# Date/Time
chrono = { version = "0.4", features = ["serde"] }

# Error handling
thiserror = "1"
anyhow = "1"

[dev-dependencies]
# Property-based testing
proptest = "1"
```

### PostgreSQL Schema Principles

```sql
-- Append-only enforcement via triggers
-- Hash chain integrity via CHECK constraints
-- No UPDATE/DELETE on ledger tables
-- Audit trail with cryptographic verification
```

---

**Document Status:** Approved ✅
**Prepared by:** Basir Global Development Team
**Effective Date:** January 3, 2026
**Scope:** MVP Phase 1 Only
**Technology:** Rust + PostgreSQL + proptest
