# Implementation Plan: Accounting Standards Framework - Phase 2

## MVP Phase 2: Sub-Ledgers, Multi-Currency & Period Management

**Document Classification:** Implementation Task List  
**Effective Date:** January 10, 2026  
**Document Status:** Draft  
**Governing Documents:** requirements.md, design.md, tasks.md (Phase 1)  
**Scope:** MVP Phase 2 (Sub-Ledgers, Multi-Currency, Period Management)  
**Technology Stack:** Rust + PostgreSQL + proptest

---

## Overview

This implementation plan covers MVP Phase 2, building upon the completed Phase 1 foundation:

**Phase 1 Completed (Foundation):**

- ✅ Standards Registry (IFRS/IAS/AAOIFI)
- ✅ Chart of Accounts (IFRS-aligned hierarchy)
- ✅ Double-Entry Ledger Engine
- ✅ Audit Trail (SHA-256 hash chain, 5W+H)
- ✅ Basic Reporting (Trial Balance with drill-down)

**Phase 2 Scope:**

- **Multi-Currency Engine** — IAS 21 compliant currency management
- **Recognition Engine** — IFRS CF Ch.5-6 recognition logic
- **Sub-Ledgers** — AP, AR, Inventory, Fixed Assets
- **Period Management** — Fiscal calendar and closing cycles
- **Internal Control Foundation** — COSO framework basics

**Existing Module Status (Partial Implementation):**

- `currency/` — Basic models exist, needs IAS 21 engine
- `inventory/` — Models and valuation exist, needs GL integration
- `assets/` — Models and depreciation exist, needs GL integration
- `calendar/` — Basic period model exists, needs closing cycles
- `partners/` — Basic model exists, needs sub-ledger integration
- `purchasing/` — Models exist, needs AP sub-ledger engine
- `sales/` — Models exist, needs AR sub-ledger engine

---

## Pre-Implementation Checklist

Before starting any task, verify:

- [x] Phase 1 tasks.md completed and verified ✅
- [x] All Phase 1 property tests passing ✅
- [x] Requirements document reviewed (Req 6, 7, 9) ✅
- [x] Design document reviewed (Components 3.6, 3.7, 3.9) ✅
- [ ] Existing module code reviewed for integration points
- [ ] Database schema migration plan prepared
- [ ] GAP_ANALYSIS_REPORT.md reviewed and gaps addressed ✅

---

## Gap Analysis Integration Notice

**Reference Document:** `GAP_ANALYSIS_REPORT.md` (January 10, 2026)

This task list has been updated to incorporate all identified gaps from the comprehensive gap analysis. Each gap has been mapped to specific subtasks with the following notation:

- **[GAP: XXX-NNN]** — References specific gap from analysis report
- Gaps are integrated into existing tasks where logical
- New subtasks added where gaps require additional work

**Gap Summary by Module:**

| Module     | Gap IDs         | Integration Location |
| ---------- | --------------- | -------------------- |
| Currency   | CUR-001→CUR-006 | Tasks 22-24          |
| Inventory  | INV-001→INV-004 | Task 33              |
| Assets     | AST-001→AST-005 | Task 35              |
| Sales      | SAL-001→SAL-005 | Task 31              |
| Purchasing | PUR-001→PUR-004 | Task 29              |
| Calendar   | CAL-001→CAL-005 | Tasks 37-38          |
| Partners   | PAR-001→PAR-003 | Tasks 29, 31         |

---

## Tasks

### Phase 2.1: Multi-Currency Engine (IAS 21)

**Requirements Alignment:** Req 6.1-6.5  
**Design Reference:** Component 3.7 (Multi-Currency Engine)  
**Correctness Property:** CP-005 (Multi-Currency Compliance)

- [ ] 22. Implement Multi-Currency Engine Core

  - [ ] 22.1 Enhance Currency data model **[GAP: CUR-001]**

    - Functional currency designation per entity
    - Presentation currency support
    - Currency pair relationships
    - Entity-level functional currency configuration
    - _Requirements: 6.1, 6.2_
    - _Reference: IAS 21.9-14_

  - [ ] 22.2 Implement Exchange Rate Service **[GAP: CUR-006]**

    - Historical rate storage with date indexing
    - Spot rate retrieval by transaction date
    - Average rate calculation for periods
    - Closing rate for period-end
    - **Rate source audit trail with timestamp**
    - _Requirements: 6.1_
    - _Reference: IAS 21.21-22, ISA 500_

  - [ ] 22.3 Implement Currency Conversion Logic

    - Transaction currency to functional currency
    - Functional currency to presentation currency
    - Rate source audit trail
    - _Requirements: 6.1, 6.2_

  - [ ] 22.4 Write property test for Exchange Rate Integrity (proptest)
    - **Property CP-005: IAS 21 Currency Compliance**
    - _For any_ foreign currency transaction, exchange_rate = spot_rate(transaction_date)
    - Verify rate source is recorded
    - Test conversion accuracy with arbitrary amounts
    - **Validates: Requirements 6.1**

- [ ] 23. Implement Monetary Item Revaluation **[GAP: CUR-002, CUR-003]**

  - [ ] 23.1 Define Monetary vs Non-Monetary classification **[GAP: CUR-003]**

    - Monetary items: Cash, receivables, payables
    - Non-monetary at historical cost: PPE, inventory
    - Non-monetary at fair value: Investment property
    - **Implement classification service with account tagging**
    - _Requirements: 6.3_
    - _Reference: IAS 21.23-26_

  - [ ] 23.2 Implement Period-End Revaluation Engine **[GAP: CUR-002]**

    - Identify monetary items in foreign currency
    - Calculate revaluation using closing rate
    - Generate revaluation journal entries
    - Route exchange differences to P&L
    - **Batch revaluation for all monetary items**
    - _Requirements: 6.3_

  - [ ] 23.3 Implement Revaluation Audit Trail

    - Record rate used for each revaluation
    - Link revaluation entries to source items
    - Track cumulative exchange differences
    - _Requirements: 6.3, 5.2_

  - [ ] 23.4 Write property test for Revaluation Accuracy (proptest)
    - _For any_ monetary item, period_end_value = original_fc_amount × closing_rate
    - Verify exchange difference = new_value - old_value
    - Test with arbitrary exchange rate movements
    - **Validates: Requirements 6.3**

- [ ] 24. Implement Foreign Operation Translation **[GAP: CUR-004, CUR-005]**

  - [ ] 24.1 Define Foreign Operation Entity Model **[GAP: CUR-004]**

    - Subsidiary functional currency
    - Parent presentation currency
    - Translation method selection
    - **Entity hierarchy for consolidation**
    - _Requirements: 6.4_
    - _Reference: IAS 21.38-49_

  - [ ] 24.2 Implement Translation Engine

    - Assets/Liabilities: closing rate
    - Income/Expenses: transaction date rate (or average)
    - Exchange differences: route to OCI
    - _Requirements: 6.4_

  - [ ] 24.3 Implement OCI Exchange Difference Routing **[GAP: CUR-005]**

    - Create Foreign Currency Translation Reserve account
    - Route translation differences to OCI
    - Track cumulative translation adjustment
    - Recycling on disposal of foreign operation
    - _Requirements: 6.4_
    - _Reference: IAS 21.32, 21.48_

  - [ ] 24.4 Write property test for Translation Compliance (proptest)
    - Verify translation differences route to OCI
    - Test with arbitrary financial statement structures
    - **Validates: Requirements 6.4**

- [ ] 25. Checkpoint - Multi-Currency Engine Complete
  - Verify exchange rate retrieval accuracy
  - Test revaluation journal entry generation
  - Test translation to presentation currency
  - Verify audit trail completeness
  - _Ask user if questions arise_

---

### Phase 2.2: Recognition Engine (IFRS CF Ch.5-6)

**Requirements Alignment:** Req 4.2, 4.3, 6.7  
**Design Reference:** Component 3.2 (Recognition Engine)  
**Correctness Property:** CP-004 (Recognition Logic Evaluation)

- [ ] 26. Implement Recognition Engine Core

  - [ ] 26.1 Define Recognition Decision data model

    - Decision ID, Transaction ID
    - Definition test result (Asset/Liability/Equity/Income/Expense)
    - Recognition test result (relevance, faithful representation)
    - Measurement basis (Historical Cost, Fair Value, Current Value)
    - Standards reference for decision
    - _Requirements: 4.2, 4.3_
    - _Reference: IFRS CF 5.1-5.25_

  - [ ] 26.2 Implement Definition Test Evaluator

    - Asset: Present economic resource controlled from past events
    - Liability: Present obligation to transfer economic resource
    - Equity: Residual interest in assets after liabilities
    - Income: Increases in assets/decreases in liabilities
    - Expense: Decreases in assets/increases in liabilities
    - _Requirements: 4.3_
    - _Reference: IFRS CF 4.3-4.69_

  - [ ] 26.3 Implement Recognition Test Evaluator

    - Relevance criterion evaluation
    - Faithful representation criterion
    - Measurement reliability assessment
    - _Requirements: 4.3_
    - _Reference: IFRS CF 5.6-5.25_

  - [ ] 26.4 Implement Measurement Basis Selector

    - Historical cost determination
    - Fair value determination (IFRS 13 levels)
    - Current value determination
    - _Requirements: 4.3_
    - _Reference: IFRS CF 6.1-6.22_

  - [ ] 26.5 Write property test for Recognition Logic (proptest)
    - **Property CP-004: Recognition Evaluation Invariant**
    - _For any_ journal entry, a recognition decision must exist
    - Verify decision.should_recognize = TRUE for posted entries
    - Test with arbitrary transaction types
    - **Validates: Requirements 4.2, 4.3**

- [ ] 27. Implement IFRS 15 Revenue Recognition Engine

  - [ ] 27.1 Enhance existing Ifrs15StepModel

    - Step 1: Contract identification validation
    - Step 2: Performance obligation identification
    - Step 3: Transaction price determination
    - Step 4: Price allocation to obligations
    - Step 5: Revenue recognition timing
    - _Requirements: 6.7_
    - _Reference: IFRS 15.9-45_

  - [ ] 27.2 Implement Contract Identification Logic

    - Approval and commitment criteria
    - Rights and payment terms identification
    - Commercial substance evaluation
    - Collectability assessment
    - _Requirements: 6.7_
    - _Reference: IFRS 15.9-16_

  - [ ] 27.3 Implement Performance Obligation Tracking

    - Distinct goods/services identification
    - Satisfaction timing (point in time vs over time)
    - Progress measurement methods
    - _Requirements: 6.7_
    - _Reference: IFRS 15.22-30_

  - [ ] 27.4 Write property test for Revenue Recognition (proptest)
    - _For any_ revenue transaction, all 5 steps must be evaluated
    - Verify revenue timing matches obligation satisfaction
    - Test with arbitrary contract structures
    - **Validates: Requirements 6.7**

- [ ] 28. Checkpoint - Recognition Engine Complete
  - Verify definition test accuracy
  - Test recognition criteria evaluation
  - Test IFRS 15 five-step model
  - Verify measurement basis selection
  - _Ask user if questions arise_

---

### Phase 2.3: Accounts Payable Sub-Ledger (AP)

**Requirements Alignment:** Req 7.2  
**Design Reference:** Component 3.8 (Sub-Ledgers)  
**Existing Code:** `purchasing/models.rs` (PurchaseBill, BillPayment)

- [ ] 29. Implement AP Sub-Ledger Engine **[GAP: PUR-001→PUR-004, PAR-001]**

  - [ ] 29.1 Enhance PurchaseBill with GL Integration **[GAP: PUR-001]**

    - Automatic journal entry generation on posting
    - Dr. Expense/Inventory, Cr. Accounts Payable
    - Standards reference: IAS 1 (Presentation)
    - Link bill to journal entry (gl_entry_id)
    - _Requirements: 7.2_

  - [ ] 29.2 Implement AP Posting Service

    - Validate bill completeness
    - Generate balanced journal entry
    - Post to General Ledger
    - Update bill status to Open
    - Record audit trail
    - _Requirements: 7.2, 5.2_

  - [ ] 29.3 Implement Payment Processing

    - Validate payment against bill balance
    - Generate payment journal entry
    - Dr. Accounts Payable, Cr. Cash/Bank
    - Update bill balance_due
    - Update bill status (PartiallyPaid/Paid)
    - _Requirements: 7.2_

  - [ ] 29.4 Implement AP Aging Analysis **[GAP: PUR-003]**

    - Current (0-30 days)
    - 31-60 days
    - 61-90 days
    - Over 90 days
    - **Aging report by vendor**
    - _Requirements: 7.2_

  - [ ] 29.5 Implement Three-Way Matching Foundation **[GAP: PUR-002]**

    - Match PO → Receipt → Invoice
    - Variance tolerance configuration
    - Exception handling workflow
    - _Requirements: 7.2, 9.4_
    - _Reference: Internal Control Best Practices_

  - [ ] 29.6 Implement Vendor Balance Tracking **[GAP: PAR-001]**

    - Real-time vendor balance calculation
    - Vendor statement generation
    - Balance reconciliation with GL
    - _Requirements: 7.2_

  - [ ] 29.7 Implement Sub-Ledger Reconciliation **[GAP: PUR-004]**

    - Σ(vendor_balances) = AP_control_account
    - Automated reconciliation report
    - Variance identification and resolution
    - _Requirements: 7.2, Internal Control_

  - [ ] 29.8 Write property test for AP Balance Integrity (proptest)
    - _For any_ vendor, Σ(bill_balances) = AP_control_account_balance
    - Verify sub-ledger reconciles to GL
    - Test with arbitrary bill/payment sequences
    - **Validates: Requirements 7.2**

- [ ] 30. Checkpoint - AP Sub-Ledger Complete
  - Verify bill posting generates correct journal entry
  - Test payment processing updates balances
  - Test aging analysis accuracy
  - Verify sub-ledger to GL reconciliation
  - _Ask user if questions arise_

---

### Phase 2.4: Accounts Receivable Sub-Ledger (AR)

**Requirements Alignment:** Req 7.3  
**Design Reference:** Component 3.8 (Sub-Ledgers)  
**Existing Code:** `sales/models.rs` (SalesInvoice, CustomerPayment)

- [ ] 31. Implement AR Sub-Ledger Engine **[GAP: SAL-001→SAL-005, PAR-001]**

  - [ ] 31.1 Enhance SalesInvoice with GL Integration **[GAP: SAL-001]**

    - Automatic journal entry generation on posting
    - Dr. Accounts Receivable, Cr. Revenue
    - Standards reference: IFRS 15 (Revenue)
    - Link invoice to journal entry (gl_entry_id)
    - _Requirements: 7.3_

  - [ ] 31.2 Implement AR Posting Service **[GAP: SAL-002]**

    - Validate invoice completeness
    - **Apply IFRS 15 recognition criteria (5-step model)**
    - Generate balanced journal entry
    - Post to General Ledger
    - Update invoice status to Posted
    - Record audit trail
    - _Requirements: 7.3, 6.7_

  - [ ] 31.3 Implement Payment Receipt Processing

    - Validate payment against invoice balance
    - Generate receipt journal entry
    - Dr. Cash/Bank, Cr. Accounts Receivable
    - Update invoice balance_due
    - Update invoice status (PartiallyPaid/Paid)
    - _Requirements: 7.3_

  - [ ] 31.4 Implement AR Aging Analysis **[GAP: SAL-004]**

    - Current (0-30 days)
    - 31-60 days
    - 61-90 days
    - Over 90 days
    - **Aging report by customer**
    - _Requirements: 7.3_

  - [ ] 31.5 Implement Expected Credit Loss (ECL) Foundation **[GAP: SAL-003]**

    - Stage 1: 12-month ECL (performing)
    - Stage 2: Lifetime ECL (significant increase in credit risk)
    - Stage 3: Lifetime ECL (credit-impaired)
    - **ECL provision journal entry generation**
    - **ECL movement schedule**
    - _Requirements: 7.3_
    - _Reference: IFRS 9.5.5_

  - [ ] 31.6 Implement Customer Balance Tracking **[GAP: PAR-001]**

    - Real-time customer balance calculation
    - Customer statement generation
    - Balance reconciliation with GL
    - _Requirements: 7.3_

  - [ ] 31.7 Implement Credit Limit Management **[GAP: PAR-002]**

    - Credit limit per customer
    - Credit check on invoice creation
    - Credit hold workflow
    - _Requirements: 7.3, 9.4_

  - [ ] 31.8 Implement Sub-Ledger Reconciliation **[GAP: SAL-005]**

    - Σ(customer_balances) = AR_control_account
    - Automated reconciliation report
    - Variance identification and resolution
    - _Requirements: 7.3, Internal Control_

  - [ ] 31.9 Write property test for AR Balance Integrity (proptest)
    - _For any_ customer, Σ(invoice_balances) = AR_control_account_balance
    - Verify sub-ledger reconciles to GL
    - Test with arbitrary invoice/payment sequences
    - **Validates: Requirements 7.3**

- [ ] 32. Checkpoint - AR Sub-Ledger Complete
  - Verify invoice posting generates correct journal entry
  - Test payment receipt processing
  - Test aging analysis accuracy
  - Verify ECL staging logic
  - Verify sub-ledger to GL reconciliation
  - _Ask user if questions arise_

---

### Phase 2.5: Inventory Sub-Ledger (IAS 2)

**Requirements Alignment:** Req 7.4  
**Design Reference:** Component 3.8 (Sub-Ledgers)  
**Existing Code:** `inventory/models.rs`, `inventory/valuation.rs`

- [ ] 33. Implement Inventory Sub-Ledger Engine **[GAP: INV-001→INV-004]**

  - [ ] 33.1 Enhance Inventory with GL Integration **[GAP: INV-001]**

    - Link inventory movements to journal entries
    - Automatic COGS calculation on sale
    - Automatic inventory valuation updates
    - **Journal entry generation for all movement types**
    - _Requirements: 7.4_
    - _Reference: IAS 2_

  - [ ] 33.2 Implement Purchase Receipt Processing

    - Record inbound stock movement
    - Generate journal entry: Dr. Inventory, Cr. AP/Cash
    - Update weighted average cost (if applicable)
    - Maintain hash chain for movements
    - _Requirements: 7.4_

  - [ ] 33.3 Implement Sales Issue Processing **[GAP: INV-003]**

    - Record outbound stock movement
    - **Calculate COGS based on valuation method (FIFO/WAC)**
    - Generate journal entry: Dr. COGS, Cr. Inventory
    - Link to sales invoice
    - **Automatic COGS posting on invoice posting**
    - _Requirements: 7.4_

  - [ ] 33.4 Implement Net Realizable Value (NRV) Assessment **[GAP: INV-002]**

    - Compare cost to NRV
    - Generate impairment entry if NRV < Cost
    - Dr. Inventory Write-down Expense, Cr. Inventory
    - **Automated NRV assessment at period-end**
    - **NRV reversal when conditions improve**
    - _Requirements: 7.4_
    - _Reference: IAS 2.28-33_

  - [ ] 33.5 Implement Inventory Valuation Report

    - List all items with quantities and values
    - Show valuation method per item
    - Calculate total inventory value
    - Support as-of-date reporting
    - _Requirements: 7.4_

  - [ ] 33.6 Implement Sub-Ledger Reconciliation **[GAP: INV-004]**

    - Σ(item_values) = Inventory_control_account
    - Automated reconciliation report
    - Variance identification and resolution
    - _Requirements: 7.4, Internal Control_

  - [ ] 33.7 Write property test for Inventory Valuation (proptest)
    - _For any_ item, book_value ≤ max(cost, NRV)
    - Verify FIFO/WAC calculations are accurate
    - Test with arbitrary movement sequences
    - **Validates: Requirements 7.4**

- [ ] 34. Checkpoint - Inventory Sub-Ledger Complete
  - Verify purchase receipt generates correct entries
  - Test COGS calculation accuracy
  - Test NRV impairment logic
  - Verify inventory to GL reconciliation
  - _Ask user if questions arise_

---

### Phase 2.6: Fixed Assets Sub-Ledger (IAS 16)

**Requirements Alignment:** Req 7.5  
**Design Reference:** Component 3.8 (Sub-Ledgers)  
**Existing Code:** `assets/models.rs`, `assets/depreciation.rs`

- [ ] 35. Implement Fixed Assets Sub-Ledger Engine **[GAP: AST-001→AST-005]**

  - [ ] 35.1 Enhance FixedAsset with GL Integration **[GAP: AST-001]**

    - Link asset to journal entries
    - **Automatic depreciation posting to GL**
    - Disposal and retirement processing
    - _Requirements: 7.5_
    - _Reference: IAS 16_

  - [ ] 35.2 Implement Asset Acquisition Processing

    - Record asset at cost
    - Generate journal entry: Dr. Fixed Asset, Cr. Cash/AP
    - Initialize depreciation schedule
    - _Requirements: 7.5_
    - _Reference: IAS 16.15-28_

  - [ ] 35.3 Implement Depreciation Posting Service **[GAP: AST-001]**

    - Calculate periodic depreciation
    - Support methods: Straight-line, Declining Balance, Units of Production
    - **Generate journal entry: Dr. Depreciation Expense, Cr. Accumulated Depreciation**
    - Update accumulated_depreciation on asset
    - **Batch depreciation run for all assets**
    - _Requirements: 7.5_
    - _Reference: IAS 16.50-62_

  - [ ] 35.4 Implement Asset Disposal Processing **[GAP: AST-002]**

    - **Calculate gain/loss on disposal**
    - Generate disposal journal entry
    - Dr. Cash (proceeds), Dr. Accum Depr, Cr. Asset, Cr/Dr. Gain/Loss
    - Update asset status to Disposed
    - **Partial disposal support**
    - _Requirements: 7.5_
    - _Reference: IAS 16.67-72_

  - [ ] 35.5 Implement Impairment Testing Foundation **[GAP: AST-003]**

    - Compare carrying amount to recoverable amount
    - Generate impairment entry if carrying > recoverable
    - Dr. Impairment Loss, Cr. Accumulated Impairment
    - **Impairment reversal (except goodwill)**
    - _Requirements: 7.5_
    - _Reference: IAS 36_

  - [ ] 35.6 Implement Fixed Asset Register Report **[GAP: AST-004]**

    - List all assets with cost, depreciation, NBV
    - Show depreciation method and useful life
    - Support as-of-date reporting
    - **Movement schedule (additions, disposals, depreciation)**
    - _Requirements: 7.5_

  - [ ] 35.7 Implement Sub-Ledger Reconciliation **[GAP: AST-005]**

    - Σ(asset_NBVs) = Fixed_Assets_control_account
    - Σ(accum_depr) = Accumulated_Depreciation_account
    - Automated reconciliation report
    - _Requirements: 7.5, Internal Control_

  - [ ] 35.8 Write property test for Depreciation Accuracy (proptest)
    - _For any_ asset, accumulated_depreciation ≤ (cost - residual_value)
    - Verify NBV = cost - accumulated_depreciation
    - Test with arbitrary depreciation schedules
    - **Validates: Requirements 7.5**

- [ ] 36. Checkpoint - Fixed Assets Sub-Ledger Complete
  - Verify acquisition generates correct entries
  - Test depreciation calculation accuracy
  - Test disposal gain/loss calculation
  - Verify asset register to GL reconciliation
  - _Ask user if questions arise_

---

### Phase 2.7: Period Management and Closing Cycles

**Requirements Alignment:** Req 7.7, 7.8, 7.9  
**Design Reference:** Component 3.4 (General Ledger - Period Management)  
**Existing Code:** `calendar/mod.rs` (FinancialPeriod, PeriodStatus)

- [ ] 37. Implement Fiscal Calendar Management **[GAP: CAL-001]**

  - [ ] 37.1 Enhance FinancialPeriod Model **[GAP: CAL-001]**

    - Support multiple calendar types (Calendar year, Fiscal year, 4-4-5)
    - Period numbering and naming
    - Year-end flag
    - **Fiscal year entity with period collection**
    - _Requirements: 7.7_
    - _Reference: IAS 1.36_

  - [ ] 37.2 Implement Fiscal Year Service **[GAP: CAL-001]**

    - Create fiscal year with periods
    - Support 12-month and 13-period calendars
    - Validate period date continuity
    - **Auto-generate periods from fiscal year definition**
    - _Requirements: 7.7_

  - [ ] 37.3 Implement Period Status Management

    - Open: Normal posting allowed
    - Locked: Restricted posting (adjustments only)
    - Closed: No posting allowed
    - _Requirements: 7.9_

  - [ ] 37.4 Write property test for Period Continuity (proptest)
    - _For any_ fiscal year, periods must be contiguous
    - Verify no date gaps or overlaps
    - Test with arbitrary period structures
    - **Validates: Requirements 7.7**

- [ ] 38. Implement Closing Cycle Engine **[GAP: CAL-002→CAL-005]**

  - [ ] 38.1 Implement Soft Close Process **[GAP: CAL-002]**

    - Validate trial balance is balanced
    - Lock period for normal posting
    - Allow adjustment entries with elevated approval
    - **Pre-close checklist validation**
    - _Requirements: 7.8_

  - [ ] 38.2 Implement Hard Close Process **[GAP: CAL-003]**

    - Validate all adjustments complete
    - **Generate closing entries for temporary accounts**
    - Transfer net income to Retained Earnings
    - Set period status to Closed
    - **Automated closing entry generation**
    - _Requirements: 7.8_

  - [ ] 38.3 Implement Year-End Close Process **[GAP: CAL-004]**

    - Close all income and expense accounts
    - **Generate retained earnings transfer entry**
    - Create opening balances for new year
    - **Comparative period setup**
    - _Requirements: 7.8_

  - [ ] 38.4 Implement Period Reopening (with controls) **[GAP: CAL-005]**

    - Require elevated authorization
    - Document reason for reopening
    - Audit trail of reopen action
    - **Approval workflow for reopening**
    - **Time-limited reopen window**
    - _Requirements: 7.9, 9.4_
    - _Reference: SOX 404_

  - [ ] 38.5 Write property test for Closing Integrity (proptest)
    - _For any_ closed period, no new entries can be posted
    - Verify closing entries balance to zero for temp accounts
    - Test with arbitrary account structures
    - **Validates: Requirements 7.8, 7.9**

- [ ] 39. Checkpoint - Period Management Complete
  - Verify fiscal calendar creation
  - Test soft close process
  - Test hard close with closing entries
  - Test year-end retained earnings transfer
  - Verify period locking enforcement
  - _Ask user if questions arise_

---

### Phase 2.8: Internal Control Foundation (COSO)

**Requirements Alignment:** Req 9.1-9.4  
**Design Reference:** Component 3.9 (Internal Control)  
**Correctness Property:** All Properties (enforcement layer)

- [ ] 40. Implement Access Control Foundation

  - [ ] 40.1 Define Role-Based Access Control (RBAC) Model

    - Preparer: CREATE_DRAFT, VIEW_OWN, SUBMIT_FOR_APPROVAL
    - Reviewer: VIEW_ALL, REVIEW, RETURN_FOR_CORRECTION
    - Approver: VIEW_ALL, APPROVE, REJECT (with thresholds)
    - Poster: POST_APPROVED_ENTRIES
    - Controller: ALL_ACCOUNTING_FUNCTIONS, PERIOD_CLOSE
    - Auditor: READ_ALL, EXPORT_DATA (no modifications)
    - _Requirements: 9.3_
    - _Reference: COSO Control Activities, SOX 404_

  - [ ] 40.2 Implement Permission Validation Service

    - Check user role against required permission
    - Validate amount thresholds for approvers
    - Log all authorization decisions
    - _Requirements: 9.3_

  - [ ] 40.3 Write property test for Access Control (proptest)
    - _For any_ action, user must have required permission
    - Verify unauthorized actions are rejected
    - Test with arbitrary role/permission combinations
    - **Validates: Requirements 9.3**

- [ ] 41. Implement Segregation of Duties (SoD)

  - [ ] 41.1 Define SoD Rules

    - Entry creator ≠ Entry approver
    - Entry approver ≠ Entry poster
    - Reconciler ≠ Poster
    - _Requirements: 9.2_
    - _Reference: COSO Control Activities_

  - [ ] 41.2 Implement SoD Enforcement Service

    - Check SoD rules before action execution
    - Block conflicting actions
    - Log SoD violations (attempted)
    - _Requirements: 9.2_

  - [ ] 41.3 Write property test for SoD Enforcement (proptest)
    - _For any_ entry, creator_id ≠ approver_id
    - Verify SoD violations are blocked
    - Test with arbitrary user/action sequences
    - **Validates: Requirements 9.2**

- [ ] 42. Implement Approval Workflow Foundation

  - [ ] 42.1 Define Approval Workflow Model

    - Workflow ID, Entry ID
    - Current status (Pending, Approved, Rejected, Returned)
    - Approval history (who, when, action, comments)
    - _Requirements: 9.4_

  - [ ] 42.2 Implement Threshold-Based Routing

    - Define amount thresholds per role
    - Route to appropriate approver based on amount
    - Support multi-level approval for high amounts
    - _Requirements: 9.4_

  - [ ] 42.3 Implement Approval Actions

    - Approve: Move to next level or mark approved
    - Reject: Return to preparer with reason
    - Return for Correction: Request changes
    - _Requirements: 9.4_

  - [ ] 42.4 Write property test for Approval Workflow (proptest)
    - _For any_ posted entry, approval_status = APPROVED
    - Verify approval chain is complete
    - Test with arbitrary threshold configurations
    - **Validates: Requirements 9.4**

- [ ] 43. Checkpoint - Internal Control Foundation Complete
  - Verify RBAC permission enforcement
  - Test SoD rule enforcement
  - Test approval workflow routing
  - Verify audit trail of control decisions
  - _Ask user if questions arise_

---

### Phase 2.9: Integration and Verification

- [ ] 44. End-to-End Integration Testing

  - [ ] 44.1 Test Complete Purchase-to-Pay Cycle

    - Create purchase bill
    - Post to AP sub-ledger
    - Verify GL entry generated
    - Process payment
    - Verify AP balance updated
    - Verify cash/bank balance updated
    - _Requirements: 7.2, All Phase 2_

  - [ ] 44.2 Test Complete Order-to-Cash Cycle

    - Create sales invoice
    - Apply IFRS 15 recognition
    - Post to AR sub-ledger
    - Verify GL entry generated
    - Process payment receipt
    - Verify AR balance updated
    - _Requirements: 7.3, 6.7, All Phase 2_

  - [ ] 44.3 Test Complete Inventory Cycle

    - Purchase inventory
    - Verify inventory valuation
    - Sell inventory
    - Verify COGS calculation
    - Test NRV impairment
    - _Requirements: 7.4, All Phase 2_

  - [ ] 44.4 Test Complete Asset Lifecycle

    - Acquire asset
    - Run depreciation
    - Test impairment
    - Dispose asset
    - Verify gain/loss calculation
    - _Requirements: 7.5, All Phase 2_

  - [ ] 44.5 Test Multi-Currency Transaction Flow

    - Create foreign currency transaction
    - Verify exchange rate application
    - Run period-end revaluation
    - Verify exchange differences
    - _Requirements: 6.1-6.4, All Phase 2_

  - [ ] 44.6 Test Period Close Cycle
    - Post transactions to period
    - Run soft close
    - Post adjustments
    - Run hard close
    - Verify closing entries
    - Test year-end close
    - _Requirements: 7.8, 7.9, All Phase 2_

- [ ] 45. Sub-Ledger to GL Reconciliation Testing

  - [ ] 45.1 Verify AP Sub-Ledger Reconciliation

    - Σ(vendor_balances) = AP_control_account
    - Test with multiple vendors and transactions
    - _Requirements: 7.2_

  - [ ] 45.2 Verify AR Sub-Ledger Reconciliation

    - Σ(customer_balances) = AR_control_account
    - Test with multiple customers and transactions
    - _Requirements: 7.3_

  - [ ] 45.3 Verify Inventory Sub-Ledger Reconciliation

    - Σ(item_values) = Inventory_control_account
    - Test with multiple items and movements
    - _Requirements: 7.4_

  - [ ] 45.4 Verify Fixed Assets Sub-Ledger Reconciliation
    - Σ(asset_NBVs) = Fixed_Assets_control_account
    - Σ(accum_depr) = Accumulated_Depreciation_account
    - Test with multiple assets
    - _Requirements: 7.5_

- [ ] 46. MVP Phase 2 Verification Against Success Criteria

  - [ ] 46.1 Verify Multi-Currency Criteria

    - "Foreign currency transactions use spot rate at transaction date" ✓
    - "Monetary items revalued at closing rate" ✓
    - "Exchange differences routed correctly" ✓
    - _Requirements: 6.1-6.4_

  - [ ] 46.2 Verify Sub-Ledger Criteria

    - "Sub-ledgers reconcile to GL control accounts" ✓
    - "Aging analysis accurate" ✓
    - "ECL staging implemented" ✓
    - _Requirements: 7.2-7.5_

  - [ ] 46.3 Verify Period Management Criteria

    - "Period locking prevents unauthorized posting" ✓
    - "Closing entries generated correctly" ✓
    - "Year-end retained earnings transfer works" ✓
    - _Requirements: 7.7-7.9_

  - [ ] 46.4 Verify Internal Control Criteria
    - "RBAC enforced for all actions" ✓
    - "SoD rules prevent conflicts" ✓
    - "Approval workflows route correctly" ✓
    - _Requirements: 9.1-9.4_

- [ ] 47. Final Checkpoint - MVP Phase 2 Complete
  - All functional criteria verified
  - All sub-ledger reconciliations pass
  - All property tests pass
  - Documentation complete
  - Ready for Phase 3 planning
  - _Ask user for final review_

---

## Post-Phase 2 Notes

### Deferred to Phase 3

- Complete Financial Statements (Balance Sheet, Income Statement, Cash Flow)
- XBRL output generation
- Multi-entity consolidation (IFRS 10)
- Intercompany eliminations

### Deferred to Phase 4

- Local Adaptation Engine
- Tax calculations (VAT, Corporate Tax)
- Zakah calculations (AAOIFI FAS 9)
- Islamic finance transactions (Murabahah, Ijarah)
- ESG reporting (IFRS S1/S2)

---

## Correctness Properties Summary (Phase 2)

| Property ID | Name                         | Requirements | Criticality |
| ----------- | ---------------------------- | ------------ | ----------- |
| CP-004      | Recognition Logic Evaluation | Req 4.2, 4.3 | HIGH        |
| CP-005      | Multi-Currency Compliance    | Req 6.1-6.5  | HIGH        |
| CP-011      | Sub-Ledger Reconciliation    | Req 7.2-7.5  | HIGH        |
| CP-012      | Period Integrity             | Req 7.7-7.9  | HIGH        |
| CP-013      | Access Control Enforcement   | Req 9.3      | HIGH        |
| CP-014      | Segregation of Duties        | Req 9.2      | HIGH        |

---

## Database Schema Additions (Phase 2)

```sql
-- Exchange Rates Table
CREATE TABLE exchange_rates (
    id UUID PRIMARY KEY,
    base_currency VARCHAR(3) NOT NULL,
    target_currency VARCHAR(3) NOT NULL,
    rate DECIMAL(18,10) NOT NULL,
    effective_date DATE NOT NULL,
    source VARCHAR(100),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(base_currency, target_currency, effective_date)
);

-- Recognition Decisions Table
CREATE TABLE recognition_decisions (
    id UUID PRIMARY KEY,
    transaction_id UUID NOT NULL,
    definition_test_passed BOOLEAN NOT NULL,
    definition_element VARCHAR(20),
    recognition_test_passed BOOLEAN NOT NULL,
    measurement_basis VARCHAR(20) NOT NULL,
    standard_reference VARCHAR(50) NOT NULL,
    reasoning TEXT,
    created_by UUID NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Approval Workflows Table
CREATE TABLE approval_workflows (
    id UUID PRIMARY KEY,
    entry_id UUID NOT NULL REFERENCES journal_entries(id),
    status VARCHAR(20) NOT NULL,
    current_level INTEGER DEFAULT 1,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Approval History Table
CREATE TABLE approval_history (
    id UUID PRIMARY KEY,
    workflow_id UUID NOT NULL REFERENCES approval_workflows(id),
    approver_id UUID NOT NULL,
    action VARCHAR(20) NOT NULL,
    comments TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Fiscal Periods Table Enhancement
ALTER TABLE fiscal_periods ADD COLUMN period_type VARCHAR(20);
ALTER TABLE fiscal_periods ADD COLUMN fiscal_year_id UUID;
ALTER TABLE fiscal_periods ADD COLUMN period_number INTEGER;
```

---

## Rust Crates Additions (Phase 2)

```toml
[dependencies]
# Existing dependencies from Phase 1...

# Additional for Phase 2
strum = "0.26"
strum_macros = "0.26"
```

---

**Document Status:** Draft → **Updated with Gap Integration**  
**Prepared by:** فريق وكلاء تطوير مشروع بصير (Basir Development Agents Team)  
**Effective Date:** January 10, 2026  
**Last Updated:** January 10, 2026 (Gap Analysis Integration)  
**Scope:** MVP Phase 2  
**Technology:** Rust + PostgreSQL + proptest  
**Governing Documents:** requirements.md, design.md, tasks.md (Phase 1), GAP_ANALYSIS_REPORT.md

---

## Appendix: Gap Integration Summary

### Gaps Addressed in This Update

| Gap ID  | Description                        | Integrated Into | Status       |
| ------- | ---------------------------------- | --------------- | ------------ |
| CUR-001 | Functional currency per entity     | Task 22.1       | ✅ Addressed |
| CUR-002 | Period-end revaluation engine      | Task 23.2       | ✅ Addressed |
| CUR-003 | Monetary/non-monetary class        | Task 23.1       | ✅ Addressed |
| CUR-004 | Foreign operation translation      | Task 24.1       | ✅ Addressed |
| CUR-005 | OCI exchange difference routing    | Task 24.3       | ✅ Addressed |
| CUR-006 | Rate source audit trail            | Task 22.2       | ✅ Addressed |
| INV-001 | GL integration                     | Task 33.1       | ✅ Addressed |
| INV-002 | NRV impairment automation          | Task 33.4       | ✅ Addressed |
| INV-003 | COGS calculation on sale           | Task 33.3       | ✅ Addressed |
| INV-004 | Sub-ledger to GL reconciliation    | Task 33.6       | ✅ Addressed |
| AST-001 | GL integration (depreciation)      | Task 35.1, 35.3 | ✅ Addressed |
| AST-002 | Disposal gain/loss calculation     | Task 35.4       | ✅ Addressed |
| AST-003 | Impairment testing (IAS 36)        | Task 35.5       | ✅ Addressed |
| AST-004 | Asset register report              | Task 35.6       | ✅ Addressed |
| AST-005 | Sub-ledger to GL reconciliation    | Task 35.7       | ✅ Addressed |
| SAL-001 | Automatic journal entry generation | Task 31.1       | ✅ Addressed |
| SAL-002 | IFRS 15 recognition enforcement    | Task 31.2       | ✅ Addressed |
| SAL-003 | ECL staging for AR                 | Task 31.5       | ✅ Addressed |
| SAL-004 | Aging analysis                     | Task 31.4       | ✅ Addressed |
| SAL-005 | Sub-ledger to GL reconciliation    | Task 31.8       | ✅ Addressed |
| PUR-001 | Automatic journal entry generation | Task 29.1       | ✅ Addressed |
| PUR-002 | Three-way matching                 | Task 29.5       | ✅ Addressed |
| PUR-003 | Aging analysis                     | Task 29.4       | ✅ Addressed |
| PUR-004 | Sub-ledger to GL reconciliation    | Task 29.7       | ✅ Addressed |
| CAL-001 | Fiscal year management             | Task 37.1, 37.2 | ✅ Addressed |
| CAL-002 | Soft close process                 | Task 38.1       | ✅ Addressed |
| CAL-003 | Closing entry generation           | Task 38.2       | ✅ Addressed |
| CAL-004 | Year-end retained earnings         | Task 38.3       | ✅ Addressed |
| CAL-005 | Period reopening with controls     | Task 38.4       | ✅ Addressed |
| PAR-001 | Partner balance tracking           | Task 29.6, 31.6 | ✅ Addressed |
| PAR-002 | Credit limit management            | Task 31.7       | ✅ Addressed |

### New Subtasks Added

| Task | New Subtasks Added | Purpose                         |
| ---- | ------------------ | ------------------------------- |
| 24   | 24.3               | OCI Exchange Difference Routing |
| 29   | 29.5, 29.6, 29.7   | Three-way matching, Vendor bal  |
| 31   | 31.6, 31.7, 31.8   | Customer bal, Credit, Reconcile |
| 33   | 33.6               | Inventory reconciliation        |
| 35   | 35.7               | Fixed assets reconciliation     |

### Task Count Summary

| Phase     | Original Tasks | After Gap Integration |
| --------- | -------------- | --------------------- |
| Phase 2.1 | 4 tasks        | 4 tasks (enhanced)    |
| Phase 2.2 | 3 tasks        | 3 tasks               |
| Phase 2.3 | 2 tasks        | 2 tasks (enhanced)    |
| Phase 2.4 | 2 tasks        | 2 tasks (enhanced)    |
| Phase 2.5 | 2 tasks        | 2 tasks (enhanced)    |
| Phase 2.6 | 2 tasks        | 2 tasks (enhanced)    |
| Phase 2.7 | 3 tasks        | 3 tasks (enhanced)    |
| Phase 2.8 | 4 tasks        | 4 tasks               |
| Phase 2.9 | 4 tasks        | 4 tasks               |
| **Total** | **26 tasks**   | **26 tasks**          |

**Note:** Task count remains the same; gaps were integrated as additional subtasks within existing tasks to maintain structural coherence.
