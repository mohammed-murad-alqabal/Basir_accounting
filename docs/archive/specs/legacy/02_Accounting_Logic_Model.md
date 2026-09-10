# Accounting Logic Model

**Version:** 1.0 (Diamond Standard)
**Basis:** Forensic Extraction from Screenshots (050-082)
**Scope:** Accounting Rules & Financial Behavior

---

## 1. The General Ledger (GL) Logic

### 1.1 The Atom of Truth: The Journal Entry

Based on Screenshot **063** and **067**:

- **Rule 1 (Balance)**: Total Debit must equal Total Credit for every committed entry.
- **Rule 2 (Immutability)**: Once posted, an entry cannot be deleted, only reversed (implied by "Repair" terminology in 069).
- **Rule 3 (Currency)**: Every entry has a `Source Currency` and an `Exchange Rate` (071), normalized to the `Base Currency` for reporting.

### 1.2 The Chart of Accounts (CoA)

Based on Screenshots **077-082**:

- **Structure**: Recursive Hierarchical Tree.
- **Root Nodes**:
  1.  Assets (Fixed 078, Current 079)
  2.  Liabilities (080)
  3.  Equity (080)
  4.  Revenue (082)
  5.  Expenses (081)
- **Logic**: Parent accounts allow distinct "Roll-up" reporting. Leaf accounts capture transactions.

---

## 2. Sub-Ledger Integration Logic

### 2.1 Inventory Valuation

Based on **050 (Profit Calculation Method)** and **057**:

- **Methods**: The system supports selectable cost basis (likely FIFO or Weighted Avg).
- **Integration**: Sales triggers COGS (Cost of Goods Sold) entries automatically.

### 2.2 Accounts Receivable/Payable

Based on **061 (Debt List)** and **059/060 (Vouchers)**:

- **Sub-Ledger**: Personal Accounts (Customers/Vendors) are sub-ledgers that roll up to the GL Control Accounts.
- **Aging**: implied by "Debt List" dashboard.

---

## 3. Financial Controls & Integrity

### 3.1 Cash Reconciliation

Based on **069/070**:

- **Audit**: Physical Cash Count is compared against System Balance.
- **Variance**: Discrepancies generate specific "Adjustment Entries" (Expense/Revenue) rather than overriding the ledger.

### 3.2 Tax Logic

Based on **097**:

- **Taxes**: Applied as a "Layer" on top of transaction lines.
- **Posting**: Tax collections post to a specific Liability account ("VAT Payable").

---

## 4. Reporting Logic

Based on **026, 054, 055**:

- **Real-time**: Reports are generated from the live GL (055 Daily Movement).
- **Drill-down**: "Category Reports" (017) implies ability to filter GL by non-financial dimensions (Product Category).

---

_This logic model defines the behavior of the Rust `accounting_core` crate._
