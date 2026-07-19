# Data Schema Specification

**Version:** 1.0 (Diamond Standard)
**Basis:** Inferred Entities from UI Fields (001-099)
**Scope:** Relational Database Model (PostgreSQL)

---

## 1. The Core Backbone (Ledger)

### 1.1 `ACCOUNTS`

(Source: Screen 077, 078-082)

- `id`: UUID
- `code`: String (Hierarchical numbering)
- `name`: String
- `type`: Enumerated (Asset, Liability, Equity, Revenue, Expense)
- `parent_id`: FK -> ACCOUNTS (Adjacency List)
- `currency`: String (ISO)

### 1.2 `JOURNAL_ENTRIES`

(Source: Screen 063, 055)

- `id`: UUID
- `date`: Timestamp (Screen 058)
- `description`: Text
- `reference`: String (Voucher #)
- `status`: Enumerated (Draft, Posted, Archived)

### 1.3 `JOURNAL_ENTRY_LINES`

(Source: Screen 063)

- `entry_id`: FK -> JOURNAL_ENTRIES
- `account_id`: FK -> ACCOUNTS
- `debit`: Decimal
- `credit`: Decimal
- `description`: Text (Line level remark)

---

## 2. Supply Chain Data

### 2.1 `INVENTORY_ITEMS`

(Source: Screen 024, 074, 085)

- `id`: UUID
- `barcode`: String (Unique, Screen 098)
- `name`: String
- `category_id`: FK -> CATEGORIES
- `cost_price`: Decimal (Screen 021)
- `selling_price`: Decimal (Screen 035)
- `stock_quantity`: Decimal

### 2.2 `INVOICES`

(Source: Screen 003, 004, 006)

- `id`: UUID
- `customer_id`: FK -> PARTNERS
- `type`: Enumerated (Sales, Purchase, Return)
- `status`: Enumerated (Draft, Posted)
- `total_amount`: Decimal
- `tax_amount`: Decimal (Screen 097)

---

## 3. Administration & Meta

### 3.1 `SYS_LICENSE`

(Source: Screen 099)

- `id`: UUID
- `device_fingerprint`: String
- `activation_string`: String
- `expiry_date`: Timestamp

### 3.2 `APP_CONFIG`

(Source: Screen 088-091)

- `key`: String (e.g., "backup_path", "company_logo")
- `value`: JSONB (Flexible storage for settings)

---

## 4. Entity Relationships

- **Invoice -> Journal**: 1 Invoice generates 1 Journal Entry (1:1).
- **Partner -> Account**: Each Partner links to a specific Sub-Ledger Account (1:1 or 1:Many).
- **Item -> Account**: Items link to Inventory/Sales/COGS accounts for automated posting.

---

_This schema aligns with the Rust `accounting_data` crate implementation._
