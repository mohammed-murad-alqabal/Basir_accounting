# Accounting Engine Specification

**Version:** 2.0 (Sovereign Edition)
**Basis:** Forensic Extraction from Screens (050-082) & Live Codebase
**Scope:** GL Logic, CoA Structure, Sub-Ledger Integration

---

## 1. The General Ledger (GL) Logic

### 1.1 The Atom of Truth: The Journal Entry

The `JournalEntry` is the fundamental, immutable unit of financial record in Basir.

| Property          | Type                     | Constraint                           | Source Screen |
| ----------------- | ------------------------ | ------------------------------------ | ------------- |
| `id`              | `UUID`                   | Unique, Auto-generated               | 063           |
| `referenceNumber` | `String`                 | Unique per fiscal year, Sequential   | 063           |
| `date`            | `DateTime`               | Must be within an open fiscal period | 058           |
| `description`     | `String`                 | Required, Auditable                  | 063           |
| `status`          | `Enum`                   | `Draft`, `Posted`, `Void`            | 015           |
| `lines`           | `List<JournalEntryLine>` | At least 2, Balanced                 | 063           |
| `hash`            | `String`                 | SHA-256 of entry data                | Forensic Req. |
| `previousHash`    | `String`                 | Links to prior entry                 | Forensic Req. |

**Core Rules:**

> **Rule 1 (Balance):** `SUM(Debit) == SUM(Credit)` for every committed entry.

> **Rule 2 (Immutability):** Once posted, an entry cannot be deleted, only reversed.

> **Rule 3 (Currency):** Multi-currency entries store both `originalAmount` and `baseCurrencyAmount` with `exchangeRate`.

> **Rule 4 (Period Lock):** Entries cannot be posted to a locked fiscal period.

### 1.2 The Journal Entry Line

| Property       | Type      | Constraint                      |
| -------------- | --------- | ------------------------------- |
| `accountId`    | `UUID`    | FK to `Account`                 |
| `debit`        | `Decimal` | >= 0                            |
| `credit`       | `Decimal` | >= 0                            |
| `description`  | `String`  | Optional, Line-level            |
| `costCenterId` | `UUID?`   | Optional, for segment reporting |

**Validation:** A line can have EITHER a debit OR a credit value, never both.

---

## 2. The Chart of Accounts (CoA)

### 2.1 Structure

Based on Screens **077-082**, the CoA is a **Recursive Hierarchical Tree** using the Adjacency List pattern.

| Root Type       | Account Range | Example                                |
| --------------- | ------------- | -------------------------------------- |
| **Assets**      | 1XXX          | 1101: Cash, 1201: A/R                  |
| **Liabilities** | 2XXX          | 2101: A/P, 2201: VAT Payable           |
| **Equity**      | 3XXX          | 3101: Retained Earnings, 3001: Capital |
| **Revenue**     | 4XXX          | 4101: Sales                            |
| **Expenses**    | 5XXX-8XXX     | 5101: COGS, 6101: Salaries             |

### 2.2 Account Entity

| Property         | Type     | Constraint                                           |
| ---------------- | -------- | ---------------------------------------------------- |
| `id`             | `UUID`   | Unique                                               |
| `code`           | `String` | Unique, Hierarchical (e.g., `1-1-01`)                |
| `name`           | `String` | Localized                                            |
| `nameAr`         | `String` | Arabic name                                          |
| `type`           | `Enum`   | `Asset`, `Liability`, `Equity`, `Revenue`, `Expense` |
| `parentId`       | `UUID?`  | FK to parent `Account`                               |
| `isGroup`        | `bool`   | If true, no direct posting allowed                   |
| `ifrs18Category` | `Enum`   | `Operating`, `Investing`, `Financing`                |
| `normalBalance`  | `Enum`   | `Debit` or `Credit`                                  |

**Logic:**

- **Roll-up Reporting:** Parent account balances are the SUM of their children.
- **Leaf Posting:** Only non-group (leaf) accounts can receive direct transactions.

---

## 3. Sub-Ledger Integration

### 3.1 Accounts Receivable (A/R) & Accounts Payable (A/P)

Based on **059-061 (Vouchers, Debt List):**

| Entity | GL Control Account         | Sub-Ledger Entity |
| ------ | -------------------------- | ----------------- |
| A/R    | `1201 Accounts Receivable` | `Customer`        |
| A/P    | `2101 Accounts Payable`    | `Vendor`          |

**Workflow:**

1. A `SalesInvoice` is posted.
2. `AccountingService` creates a `JournalEntry`:
   - **Debit:** `1201 A/R` (Customer sub-ledger)
   - **Credit:** `4101 Sales`
   - **Credit:** `2201 VAT Payable`
3. When payment is received (`CashVoucher` 059):
   - **Debit:** `1101 Cash`
   - **Credit:** `1201 A/R` (Customer sub-ledger)

### 3.2 Inventory Valuation

Based on **050 (Profit Calculation Method):**

| Method           | Logic                                |
| ---------------- | ------------------------------------ |
| **FIFO**         | Oldest purchases are expensed first. |
| **Weighted Avg** | Running average cost per unit.       |

**Posting:**

- **Sales:** `Debit: 5101 COGS`, `Credit: 1301 Inventory` (at cost).
- **Purchase:** `Debit: 1301 Inventory`, `Credit: 2101 A/P or 1101 Cash`.

---

## 4. Financial Controls & Integrity

### 4.1 Fiscal Period Management

**Entity: `FinancialYear`**

| Property          | Type           | Constraint                       |
| ----------------- | -------------- | -------------------------------- |
| `id`              | `UUID`         | Unique                           |
| `name`            | `String`       | e.g., "FY 2026"                  |
| `startDate`       | `DateTime`     | Beginning of year                |
| `endDate`         | `DateTime`     | End of year                      |
| `isClosed`        | `bool`         | Prevents all posting after close |
| `lockedPeriodIds` | `List<String>` | e.g., `['2026-01', '2026-02']`   |

**Logic:**

- **Period Lock:** Individual months can be locked to prevent retrospective changes.
- **Year-End Close:** Triggers `rolloverBalances`, which aggregates P&L into `Retained Earnings` and creates opening entries for the new year.

### 4.2 Cash Reconciliation (Screens 069-070)

| Step | Action                                                           |
| ---- | ---------------------------------------------------------------- |
| 1    | User enters **Physical Cash Count**.                             |
| 2    | System retrieves **GL Cash Balance** from `1101 Cash`.           |
| 3    | **Variance** is calculated: `Physical - GL`.                     |
| 4    | If variance exists, user creates an **Adjustment Entry**:        |
|      | - **Surplus:** `Debit: 1101 Cash`, `Credit: 4901 Sundry Income`  |
|      | - **Shortage:** `Debit: 6901 Cash Shortage`, `Credit: 1101 Cash` |

### 4.3 Forensic Hash Chain

Every `JournalEntry` includes:

```dart
hash = SHA256(id + date + description + lines.toString() + previousHash)
```

This creates an immutable, verifiable chain of custody for every mutation in the ledger.

---

## 5. Reporting Logic

### 5.1 Financial Statements (IFRS 18)

| Report                  | Data Source                                 | Key Accounts                    |
| ----------------------- | ------------------------------------------- | ------------------------------- |
| **Balance Sheet**       | All `Asset`, `Liability`, `Equity` accounts | 1XXX, 2XXX, 3XXX                |
| **Income Statement**    | All `Revenue`, `Expense` accounts           | 4XXX, 5XXX-8XXX                 |
| **Cash Flow Statement** | Filtered by `ifrs18Category`                | Operating, Investing, Financing |

### 5.2 Drill-Down Capability

From any line in the Balance Sheet or Income Statement, users can navigate directly to the underlying `JournalEntry` records for that account.

---

_This logic model defines the behavior of the Rust `accounting_core` crate and the Flutter `AccountingService`._
