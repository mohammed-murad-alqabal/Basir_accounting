# Database Design & ERD: Baseer Intelligent Financial System

**Document ID:** BASEER-P4-002  
**Version:** 1.0  
**Date:** December 27, 2025  
**Status:** ✅ Approved  
**Classification:** Technical Architecture

---

## 1. Database Strategy

### Primary Database

**PostgreSQL 16** - Relational data with strong consistency

### Schema Design Principles

- Soft deletes with `deleted_at` timestamp
- UUID primary keys for distributed systems
- Audit timestamps on all tables
- Multi-tenant with organization_id

---

## 2. Entity Relationship Diagram

```
┌───────────────┐       ┌───────────────┐       ┌───────────────┐
│  Organization │       │     User      │       │   Customer    │
├───────────────┤       ├───────────────┤       ├───────────────┤
│ id (PK)       │◄──────│ org_id (FK)   │       │ id (PK)       │
│ name          │       │ id (PK)       │       │ org_id (FK)   │
│ tax_number    │       │ email         │       │ name          │
│ country       │       │ password_hash │       │ email         │
│ currency      │       │ role          │       │ phone         │
│ settings      │       │ created_at    │       │ tax_number    │
│ created_at    │       └───────────────┘       │ address       │
└───────────────┘                               │ created_at    │
        │                                       └───────────────┘
        │                                               │
        │       ┌───────────────┐                      │
        │       │    Invoice    │◄─────────────────────┘
        │       ├───────────────┤
        └──────▶│ id (PK)       │       ┌───────────────┐
                │ org_id (FK)   │       │ Invoice Item  │
                │ customer_id   │       ├───────────────┤
                │ number        │◄──────│ id (PK)       │
                │ status        │       │ invoice_id FK │
                │ issue_date    │       │ description   │
                │ due_date      │       │ quantity      │
                │ subtotal      │       │ unit_price    │
                │ tax_total     │       │ tax_rate      │
                │ total         │       │ total         │
                │ zatca_qr      │       └───────────────┘
                │ created_at    │
                └───────────────┘
                        │
                ┌───────────────┐
                │   Payment     │
                ├───────────────┤
                │ id (PK)       │
                │ invoice_id FK │
                │ amount        │
                │ method        │
                │ paid_at       │
                │ reference     │
                └───────────────┘

┌───────────────┐       ┌───────────────┐
│   Expense     │       │   Category    │
├───────────────┤       ├───────────────┤
│ id (PK)       │       │ id (PK)       │
│ org_id (FK)   │──────▶│ org_id (FK)   │
│ user_id (FK)  │       │ name          │
│ category_id   │       │ icon          │
│ amount        │       │ color         │
│ currency      │       │ type          │
│ description   │       │ is_default    │
│ merchant      │       └───────────────┘
│ date          │
│ receipt_url   │
│ created_at    │
└───────────────┘

┌───────────────┐       ┌───────────────┐
│   Budget      │       │ Budget Item   │
├───────────────┤       ├───────────────┤
│ id (PK)       │       │ id (PK)       │
│ user_id (FK)  │◄──────│ budget_id FK  │
│ name          │       │ category_id   │
│ total         │       │ limit         │
│ start_date    │       │ spent         │
│ end_date      │       └───────────────┘
│ created_at    │
└───────────────┘
```

---

## 3. Table Definitions

### organizations

```sql
CREATE TABLE organizations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    name_ar VARCHAR(255),
    tax_number VARCHAR(50),
    country CHAR(2) NOT NULL DEFAULT 'SA',
    currency CHAR(3) NOT NULL DEFAULT 'SAR',
    settings JSONB DEFAULT '{}',
    logo_url VARCHAR(500),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE INDEX idx_org_country ON organizations(country);
CREATE INDEX idx_org_deleted ON organizations(deleted_at) WHERE deleted_at IS NULL;
```

### users

```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID REFERENCES organizations(id),
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL DEFAULT 'member',
    phone VARCHAR(50),
    language CHAR(2) DEFAULT 'ar',
    preferences JSONB DEFAULT '{}',
    email_verified_at TIMESTAMPTZ,
    last_login_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE INDEX idx_user_org ON users(org_id);
CREATE INDEX idx_user_email ON users(email);
```

### customers

```sql
CREATE TABLE customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id),
    name VARCHAR(255) NOT NULL,
    name_ar VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(50),
    tax_number VARCHAR(50),
    address TEXT,
    city VARCHAR(100),
    country CHAR(2),
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE INDEX idx_customer_org ON customers(org_id);
CREATE INDEX idx_customer_name ON customers(name);
```

### invoices

```sql
CREATE TABLE invoices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id),
    customer_id UUID REFERENCES customers(id),
    created_by UUID REFERENCES users(id),
    number VARCHAR(50) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'draft',
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    currency CHAR(3) NOT NULL DEFAULT 'SAR',
    subtotal DECIMAL(15,2) NOT NULL DEFAULT 0,
    tax_rate DECIMAL(5,2) NOT NULL DEFAULT 15,
    tax_total DECIMAL(15,2) NOT NULL DEFAULT 0,
    discount DECIMAL(15,2) DEFAULT 0,
    total DECIMAL(15,2) NOT NULL DEFAULT 0,
    notes TEXT,
    terms TEXT,
    zatca_uuid UUID,
    zatca_hash VARCHAR(500),
    zatca_qr TEXT,
    zatca_xml TEXT,
    sent_at TIMESTAMPTZ,
    paid_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,
    UNIQUE(org_id, number)
);

CREATE INDEX idx_invoice_org ON invoices(org_id);
CREATE INDEX idx_invoice_customer ON invoices(customer_id);
CREATE INDEX idx_invoice_status ON invoices(status);
CREATE INDEX idx_invoice_date ON invoices(issue_date);
```

### invoice_items

```sql
CREATE TABLE invoice_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_id UUID NOT NULL REFERENCES invoices(id) ON DELETE CASCADE,
    description VARCHAR(500) NOT NULL,
    quantity DECIMAL(10,3) NOT NULL DEFAULT 1,
    unit_price DECIMAL(15,2) NOT NULL,
    tax_rate DECIMAL(5,2),
    tax_amount DECIMAL(15,2) DEFAULT 0,
    discount DECIMAL(15,2) DEFAULT 0,
    total DECIMAL(15,2) NOT NULL,
    sort_order INT DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_item_invoice ON invoice_items(invoice_id);
```

### expenses

```sql
CREATE TABLE expenses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id),
    user_id UUID NOT NULL REFERENCES users(id),
    category_id UUID REFERENCES categories(id),
    amount DECIMAL(15,2) NOT NULL,
    currency CHAR(3) NOT NULL DEFAULT 'SAR',
    description VARCHAR(500),
    merchant VARCHAR(255),
    expense_date DATE NOT NULL,
    receipt_url VARCHAR(500),
    receipt_data JSONB,
    is_recurring BOOLEAN DEFAULT FALSE,
    tags TEXT[],
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE INDEX idx_expense_org ON expenses(org_id);
CREATE INDEX idx_expense_user ON expenses(user_id);
CREATE INDEX idx_expense_date ON expenses(expense_date);
CREATE INDEX idx_expense_category ON expenses(category_id);
```

---

## 4. Indexes Strategy

### Primary Indexes

- UUID primary keys (B-tree)
- Foreign key columns
- Status/type enum columns
- Date columns for range queries

### Composite Indexes

```sql
CREATE INDEX idx_invoice_org_status_date
    ON invoices(org_id, status, issue_date DESC);

CREATE INDEX idx_expense_user_date
    ON expenses(user_id, expense_date DESC);
```

### Partial Indexes

```sql
-- Only active records
CREATE INDEX idx_active_invoices
    ON invoices(org_id, status)
    WHERE deleted_at IS NULL;

-- Overdue only
CREATE INDEX idx_overdue_invoices
    ON invoices(due_date)
    WHERE status = 'sent' AND due_date < CURRENT_DATE;
```

---

## 5. Data Integrity

### Constraints

- Foreign keys with appropriate ON DELETE behavior
- CHECK constraints for valid amounts
- UNIQUE constraints for business keys

### Triggers

- `updated_at` auto-update trigger
- Invoice total calculation trigger
- Audit log trigger

---

**Document Control:**

- Prepared by: Baseer Development Agent Team
- Date: December 27, 2025
