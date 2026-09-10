# The Basir Accounting Forensic Atlas
**Generated:** 2026-01-12T19:56:27.553465
**Scope:** Deep Step-by-Step Analysis of Legacy Source Images (001-099)
**Standard:** Diamond Engineering Purity
---

## Table of Contents
- [001: Main Dashboard](#image-001)
- [002: Invoice Settings](#image-002)
- [003: Sales Invoice](#image-003)
- [004: Sales Invoice Detail](#image-004)
- [005: Added Invoices List](#image-005)
- [006: Invoice Editing Screen](#image-006)
- [007: Select Report Fields](#image-007)
- [008: Currency Selection](#image-008)
- [009: Item Index](#image-009)
- [010: Returns and Damages](#image-010)
- [011: Invoice Search Engine](#image-011)
- [012: Data Processing State](#image-012)
- [013: Selection Error](#image-013)
- [014: Sort Results](#image-014)
- [015: Quotes - Purchase Orders - Drafts](#image-015)
- [016: Daily Total Sales and Purchases](#image-016)
- [017: Category Reports](#image-017)
- [018: Customer Reports](#image-018)
- [019: Account Movement Filtering](#image-019)
- [020: Item Search Options](#image-020)
- [021: Pricing Method](#image-021)
- [022: Account Management and Financial Operations](#image-022)
- [023: Inventory Adjustments](#image-023)
- [024: Barcode Creation Engine](#image-024)
- [025: Financial Services and Shortcuts List](#image-025)
- [026: Reports Dashboard](#image-026)
- [027: Security and Backup Settings](#image-027)
- [028: System Information](#image-028)
- [029: Set Manager PIN Request](#image-029)
- [030: Select User](#image-030)
- [031: Built-in Calculator](#image-031)
- [032: Select Database Request](#image-032)
- [033: Cloud Backup Settings](#image-033)
- [034: Tax and E-Invoice Settings](#image-034)
- [035: Pricing Strategy](#image-035)
- [036: Advanced Item Search Filters](#image-036)
- [037: Company Data and Logo Printing](#image-037)
- [038: Select Language Request](#image-038)
- [039: Rename Invoice Labels](#image-039)
- [040: Select Document Type for Editing](#image-040)
- [041: Print Template Selection Interface](#image-041)
- [042: Print Template Preview](#image-042)
- [043: Paper Size Settings](#image-043)
- [044: Invoice and Account Statement Printing Options](#image-044)
- [045: Currency Search Engine](#image-045)
- [046: Currency Information](#image-046)
- [047: Item Index Management](#image-047)
- [048: Index Name Registration](#image-048)
- [049: Unit of Measure Search](#image-049)
- [050: Select Profit Calculation Method Request](#image-050)
- [051: Upgrade to Professional Version](#image-051)
- [052: Login Credentials Request](#image-052)
- [053: System Side Drawer](#image-053)
- [054: Profit Report](#image-054)
- [055: Daily Transaction Movement](#image-055)
- [056: Daily Movement Processing State](#image-056)
- [057: Balance Sheet and Fair Valuation](#image-057)
- [058: Debt and Liability Registration](#image-058)
- [059: Cash Receipts Voucher](#image-059)
- [060: Cash Payments Voucher](#image-060)
- [061: Debt List Dashboard](#image-061)
- [062: Currency Movement Registration Interface](#image-062)
- [063: Journal Entry History](#image-063)
- [064: Account Statement Query Options](#image-064)
- [065: Cashier Movement Report](#image-065)
- [066: Expenses Dashboard](#image-066)
- [067: Journal Entry Search Engine](#image-067)
- [068: Adjust Opening Account Balances](#image-068)
- [069: Cash Reconciliation and Repair](#image-069)
- [070: Cash Reconciliation Audit](#image-070)
- [071: Select Currency for Exchange Rate Request](#image-071)
- [072: Financial Operations List](#image-072)
- [073: System Behavior and Maintenance Options](#image-073)
- [074: Inventory Item List](#image-074)
- [075: Main Control Dashboard](#image-075)
- [076: Services and Backup Dashboard](#image-076)
- [077: Chart of Accounts](#image-077)
- [078: Fixed and Current Assets Index](#image-078)
- [079: Current Assets Breakdown](#image-079)
- [080: Liabilities and Owners Equity Index](#image-080)
- [081: Administrative and Operating Expenses Index](#image-081)
- [082: Revenues and Activities Index](#image-082)
- [083: Excel Data Import Gateway](#image-083)
- [084: User Printing and Security Settings](#image-084)
- [085: Inventory Operations List](#image-085)
- [086: Account Entries and Ledgers List](#image-086)
- [087: Comprehensive Index and Advanced Features](#image-087)
- [088: Data Storage and Persistence Paths](#image-088)
- [089: Sales Policies and Financial Controls](#image-089)
- [090: Communication and Auto-Messaging Settings](#image-090)
- [091: Units of Measurement Index](#image-091)
- [092: Users and Permissions Management](#image-092)
- [093: System Admin Permissions Matrix](#image-093)
- [094: User Data Edit Interface](#image-094)
- [095: Brand Identity and Logo Settings](#image-095)
- [096: Advanced Invoice Printing Options](#image-096)
- [097: Tax Configuration](#image-097)
- [098: Barcode Engine Configuration](#image-098)
- [099: Annual Subscription Activation Interface](#image-099)

---

## Image 001
### **Main Dashboard**

#### 1. Deep Visual Forensic Analysis
- **Status Bar**: Shows 91% battery, system icons, and time 7:09.
- **Header**:
  - Green Promo Bar: Click here to buy full version.
  - Sub-header: Main Database with Cloud Sync icon.
  - Current User: Current User: Manager.
  - Last Backup: Last backup in: Air Mohammad.
- **Navigation Tabs**:
  - Invoices (Invoices) - _Active_
  - Accounts (Accounts)
  - Reports (Reports)
  - Settings (Settings)
- **Main Grid**:
  - Create Sales Invoice - Icon: Person with cart/box.
  - Create Purchase Invoice - Icon: Cart.
  - Create Sales Draft - Icon: Mouse click.
  - Create Purchase Draft - Icon: Mouse click.
  - Warehouse Inventory - Icon: Boxes.
  - Return and Damage Invoices - Icon: Number 5 with arrow.
- **List Items (Scrollable)**:
  - View Previous Invoices.
  - Item List.
  - Price Quotes - Purchase Orders - Invoice Drafts.
  - Daily Total Sales and Purchases.
  - Item Movement.
  - Item Movement by Account.
  - Edit and Export Sales/Purchase Prices.
  - Pricing Policy - Value: Specific Price (Specific Price).
  - Enter current warehouse goods - Inventory Invoice.
  - Inventory Reconciliation and Repair.
  - Last item prices in currencies.
  - Barcode Designer.
- **Footer**:
  - Floating Action Button (Blue): Calculator icon.
  - Bottom Bar: Main Box: 0.
  - System Navigation: Android soft keys.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Reporting & Analytics
- **Component ID**: `REPORTING-001`
- **Route / Slug**: `/app/main-dashboard`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `ReportingService`
- **Method Signature**:
    ```rust
    pub async fn handle_main_dashboard(
        ctx: &RequestContext,
        payload: MainDashboardRequest
    ) -> Result<MainDashboardResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 002
### **Invoice Settings**

#### 1. Deep Visual Forensic Analysis
- **Header**:
  - Title: Invoice Settings - Appears as a modal/popup over the Sales screen.
  - Status: 91% battery, 7:09.
- **Form Fields (Active Overlay)**:
  - **Row 1**: Invoice No, Date, Time.
  - **Customer Picker**: General Customer with an Edit/Clear icon.
  - **Account Balance**: Account Balance - Currently empty/zero.
  - **Payment Type**: Radio buttons for Cash Payment - _Selected_ and On Credit.
  - **Notes**: Notes - Empty text field.
  - **Tax Toggle**: Tax - Switch is OFF.
- **Main Action**: Large Green Button Start Invoice.
- **Background (Sales UI)**:
  - Search field: Enter item name.
  - Column Headers: Qty, Unit, Individual Price, Total.
  - Icons: Image/Attachment icon, Microphone (Voice), Barcode scanner.
- **Footer UI**:
  - Totals Bar: 0 Credit Sale.
  - Quick Actions: Discount, Calculator, Search.
  - System: Bluetooth Print, New Invoice.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Sales & Revenue
- **Component ID**: `SALES-002`
- **Route / Slug**: `/app/invoice-settings`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `SalesService`
- **Method Signature**:
    ```rust
    pub async fn handle_invoice_settings(
        ctx: &RequestContext,
        payload: InvoiceSettingsRequest
    ) -> Result<InvoiceSettingsResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sales_invoices`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sales_invoices_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 003
### **Sales Invoice**

#### 1. Deep Visual Forensic Analysis
- **Header**: Sales Invoice - Top right.
- **Input Area**:
  - Enter item name to add it....
  - Icons: Image/Gallery icon, Microphone (Voice), Barcode icon.
- **Column Headers**: Quantity (Qty), Unit (Unit), Unit Price (Unit Price), Total (Total).
- **Line Items**: _Currently Empty_.
- **Footer Calculations**:
  - Total [ 0 ] Cash Sale - General Customer.
  - Discount Field: "Discount : 0".
  - Net Field: Numeric display.
- **Bottom Navigation**:
  - Bluetooth Print - Bottom right.
  - New Invoice - Center.
  - More - Bottom left with a dropdown arrow.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Sales & Revenue
- **Component ID**: `SALES-003`
- **Route / Slug**: `/app/sales-invoice`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `SalesService`
- **Method Signature**:
    ```rust
    pub async fn handle_sales_invoice(
        ctx: &RequestContext,
        payload: SalesInvoiceRequest
    ) -> Result<SalesInvoiceResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sales_invoices`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sales_invoices_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 004
### **Sales Invoice Detail**

#### 1. Deep Visual Forensic Analysis
- **Header**: Sales Invoice.
- **Active State**: This is the "Item Picker" or "Search Result" state.
- **Grid Categories**:
  - Uncategorized.
  - Clothes.
  - Shoes.
  - Perfumes.
  - Cosmetics.
- **Item Cards**:
  - Visual thumbnails for items (e.g., shoe icons, generic box icons).
  - Price labels on the cards (e.g., 500, 300, 3500).
- **Cart Summary**:
  - Added items in numbers: 1.
  - "Net : 3500".
- **Bottom Action**: Added / Finished adding.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Sales & Revenue
- **Component ID**: `SALES-004`
- **Route / Slug**: `/app/sales-invoice-detail`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `SalesService`
- **Method Signature**:
    ```rust
    pub async fn handle_sales_invoice_detail(
        ctx: &RequestContext,
        payload: SalesInvoiceDetailRequest
    ) -> Result<SalesInvoiceDetailResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sales_invoices`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sales_invoices_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 005
### **Added Invoices List**

#### 1. Deep Visual Forensic Analysis
- **Header**: List of Added Invoices.
- **Filter Bar**:
  - All Invoices - _Selected_.
  - Sales.
  - Purchase.
  - Sales Return.
  - Purchase Return.
- **Secondary Filters**: From date / To date (2025-12-30).
- **List Items**:
  - Row 1: Sales Invoice #1, General Customer, "19:09:47", "3,500.00".
- **Summary Footer**:
  - No. of Invoices: 1.
  - "Total : 3,500.00".
- **Bottom Actions**: Share Photos, Excel Export, Sorting Options.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Sales & Revenue
- **Component ID**: `SALES-005`
- **Route / Slug**: `/app/added-invoices-list`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `SalesService`
- **Method Signature**:
    ```rust
    pub async fn handle_added_invoices_list(
        ctx: &RequestContext,
        payload: AddedInvoicesListRequest
    ) -> Result<AddedInvoicesListResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sales_invoices`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sales_invoices_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 006
### **Invoice Editing Screen**

#### 1. Deep Visual Forensic Analysis
- **Header Actions**:
  - Save Invoice - Primary action button (Top Right).
  - Print and Share - Secondary action (Center).
  - Custom Print - Specialized action (Top Left).
- **Search/Input Bar**:
  - Enter item name to add it to the invoice.
  - Icons: Attachment, Mirror/Voice, Barcode.
- **Column Headers**: Quantity, Unit, Unit Price, Total.
- **Footer UI**:
  - Summary Text: "Content [ 0 ] Cash Sale - General Customer".
  - Value Fields: Net (Net) and Discount (Discount).
  - Bottom Buttons: More (More), New Invoice (New Invoice), Bluetooth Print.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Sales & Revenue
- **Component ID**: `SALES-006`
- **Route / Slug**: `/app/invoice-editing-screen`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `SalesService`
- **Method Signature**:
    ```rust
    pub async fn handle_invoice_editing_screen(
        ctx: &RequestContext,
        payload: InvoiceEditingScreenRequest
    ) -> Result<InvoiceEditingScreenResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sales_invoices`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sales_invoices_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 007
### **Select Report Fields**

#### 1. Deep Visual Forensic Analysis
- **Modal Title**: Choose Report Fields.
- **Checkbox List**:
  - **Index/No**.
  - **Item Name**.
  - **Unit Price**.
  - **Unit**.
  - **Count/Quantity**.
  - **Total**.
  - **Notes**.
  - **Product Image**.
  - **Headers**.
- **Bottom Action**: View Report.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Reporting & Analytics
- **Component ID**: `REPORTING-007`
- **Route / Slug**: `/app/select-report-fields`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `ReportingService`
- **Method Signature**:
    ```rust
    pub async fn handle_select_report_fields(
        ctx: &RequestContext,
        payload: SelectReportFieldsRequest
    ) -> Result<SelectReportFieldsResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `analytics_reports`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (analytics_reports_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 008
### **Currency Selection**

#### 1. Deep Visual Forensic Analysis
- **Context**: The user is in the "New Invoice" setup modal (from ).
- **Active Selection**: A dropdown/picker has been triggered for currency.
- **Options**:
  - **Yemeni Rial**.
  - **Dollar**.
  - **Euro**.
- **Background State**: Invoice No #1, Date 2025-12-30.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-008`
- **Route / Slug**: `/app/currency-selection`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_currency_selection(
        ctx: &RequestContext,
        payload: CurrencySelectionRequest
    ) -> Result<CurrencySelectionResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_currencies`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_currencies_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 009
### **Item Index**

#### 1. Deep Visual Forensic Analysis
- **Header**: Item Index / Catalog.
- **Search Bar**: All - implies a search or category filter.
- **Advanced Options Toggles**:
  - Show all with currency adjustment.
  - According to last purchase.
  - According to average purchase.
- **Main Result Filters (Checkboxes)**:
  - **In stock** - _SELECTED_.
  - **Out of stock**.
  - **Negative stock**.
  - **Frozen/Inactive** - _SELECTED_.
- **Bottom Action**: View Results.
- **Secondary Actions**:
  - Show items with quantity less than....
  - Show items that reached minimum level.
  - Create new inventory invoice.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Inventory & Supply Chain
- **Component ID**: `INVENTORY-009`
- **Route / Slug**: `/app/item-index`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `InventoryService`
- **Method Signature**:
    ```rust
    pub async fn handle_item_index(
        ctx: &RequestContext,
        payload: ItemIndexRequest
    ) -> Result<ItemIndexResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `inventory_items`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (inventory_items_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 010
### **Returns and Damages**

#### 1. Deep Visual Forensic Analysis
- **Context**: A prominent central modal popped over the Main Dashboard.
- **Options**:
  - **Sales Return** - Visual: Cart with back arrow.
  - **Purchase Return** - Visual: Box with back arrow.
  - **Damage Invoice** - Visual: Flame icon (Fire).
- **Header Background**: The main app header is visible (Cloud Sync, Manager name).
- **Footer Background**: "Main Cashier/Vault" and "Trial Version" are visible.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-010`
- **Route / Slug**: `/app/returns-and-damages`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_returns_and_damages(
        ctx: &RequestContext,
        payload: ReturnsAndDamagesRequest
    ) -> Result<ReturnsAndDamagesResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 011
### **Invoice Search Engine**

#### 1. Deep Visual Forensic Analysis
- **Header Selection**:
  - **Sales** - Checked.
  - **Purchase** - Checked.
  - **Sales Return** - Checked.
  - **Purchase Return** - Checked.
- **Search Input**: Search in Invoices with a magnifying glass icon.
- **Main List Area**: _Currently Empty (Grey placeholder)_.
- **Bottom Status**:
  - No matching results - Blue pill-style alert.
- **Footer Action**: Print Batch of Invoices with a printer icon.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Sales & Revenue
- **Component ID**: `SALES-011`
- **Route / Slug**: `/app/invoice-search-engine`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `SalesService`
- **Method Signature**:
    ```rust
    pub async fn handle_invoice_search_engine(
        ctx: &RequestContext,
        payload: InvoiceSearchEngineRequest
    ) -> Result<InvoiceSearchEngineResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sales_invoices`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sales_invoices_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 012
### **Data Processing State**

#### 1. Deep Visual Forensic Analysis
- **Context**: State change during a high-latency operation from .
- **Active Overlay**: A blue progress/loading pill.
- **Text**: Preparing data, please wait....
- **Background**: Frayed/Greyed out search UI from the previous screen.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-012`
- **Route / Slug**: `/app/data-processing-state`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_data_processing_state(
        ctx: &RequestContext,
        payload: DataProcessingStateRequest
    ) -> Result<DataProcessingStateResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 013
### **Selection Error**

#### 1. Deep Visual Forensic Analysis
- **Context**: Logical error following the search/batch print attempt in .
- **Active Overlay**: A Salmon/Reddish pill-style error message.
- **Text**: Please select invoices.
- **Background**: The persistent batch-filter UI.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-013`
- **Route / Slug**: `/app/selection-error`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_selection_error(
        ctx: &RequestContext,
        payload: SelectionErrorRequest
    ) -> Result<SelectionErrorResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 014
### **Sort Results**

#### 1. Deep Visual Forensic Analysis
- **Header**: Sort Results - Indicates the catalog view.
- **Search Input**: Card-style Search with a lens icon.
- **Category Chips**:
  - **All** - _Selected/Pale Green_.
  - **Main Items**.
- **Footer Bar (Deep Blue)**:
  - Import from Excel.
  - Export to Excel.
  - New Item.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-014`
- **Route / Slug**: `/app/sort-results`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_sort_results(
        ctx: &RequestContext,
        payload: SortResultsRequest
    ) -> Result<SortResultsResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 015
### **Quotes - Purchase Orders - Drafts**

#### 1. Deep Visual Forensic Analysis
- **Header**: Price Quotes - Purchase Orders - Drafts.
- **Warning Text (Yellow on Blue)**: These invoices have no accounting impact and do not affect the warehouse.
- **Search Bar**: Search by name or number.
- **Tabs**:
  - **All** - _Selected_.
  - **Price Quotes**.
  - **Purchase Orders**.
  - **Drafts**.
- **Main Content**: _Empty List_.
- **Bottom Actions**:
  - New Price Quote.
  - New Purchase Order.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Sales & Revenue
- **Component ID**: `SALES-015`
- **Route / Slug**: `/app/quotes---purchase-orders---drafts`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `SalesService`
- **Method Signature**:
    ```rust
    pub async fn handle_quotes___purchase_orders___drafts(
        ctx: &RequestContext,
        payload: QuotesPurchaseOrdersDraftsRequest
    ) -> Result<QuotesPurchaseOrdersDraftsResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 016
### **Daily Total Sales and Purchases**

#### 1. Deep Visual Forensic Analysis
- **Header**: Daily Total Sales and Purchases.
- **Secondary Header**: Share and Print with a yellow printer icon.
- **Data Card (White)**:
  - **Total Sales**: 0.
  - **Total Purchases**: 0.
  - **Profits**: 0.
  - **Sales Quantities**: 0.
  - **Purchase Quantities**: 0.
- **Time Filter Chips (Blue)**:
  - **Today** - _Selected_.
  - **Yesterday**.
  - **This Month**.
  - **Custom**.
- **Bottom Navigation (White)**:
  - **Items/Suppliers** - _Selected with Grid Icon_.
  - **Categories**.
  - **Customers**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Sales & Revenue
- **Component ID**: `SALES-016`
- **Route / Slug**: `/app/daily-total-sales-and-purchases`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `SalesService`
- **Method Signature**:
    ```rust
    pub async fn handle_daily_total_sales_and_purchases(
        ctx: &RequestContext,
        payload: DailyTotalSalesAndPurchasesRequest
    ) -> Result<DailyTotalSalesAndPurchasesResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 017
### **Category Reports**

#### 1. Deep Visual Forensic Analysis
- **Context**: State change from .
- **Active Navigation**: The **Categories** tab is now selected in the bottom navigation.
- **UI Elements**: Persistent header and data card from the previous screen.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Reporting & Analytics
- **Component ID**: `REPORTING-017`
- **Route / Slug**: `/app/category-reports`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `ReportingService`
- **Method Signature**:
    ```rust
    pub async fn handle_category_reports(
        ctx: &RequestContext,
        payload: CategoryReportsRequest
    ) -> Result<CategoryReportsResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `analytics_reports`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (analytics_reports_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 018
### **Customer Reports**

#### 1. Deep Visual Forensic Analysis
- **Context**: State change from .
- **Active Navigation**: The **Customers** tab is now selected in the bottom navigation.
- **UI Elements**: Persistent header and data card.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Reporting & Analytics
- **Component ID**: `REPORTING-018`
- **Route / Slug**: `/app/customer-reports`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `ReportingService`
- **Method Signature**:
    ```rust
    pub async fn handle_customer_reports(
        ctx: &RequestContext,
        payload: CustomerReportsRequest
    ) -> Result<CustomerReportsResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `analytics_reports`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (analytics_reports_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 019
### **Account Movement Filtering**

#### 1. Deep Visual Forensic Analysis
- **Context**: Filter setup for a Ledger or Transaction report.
- **Input Fields**:
  - Name of Customer, Supplier, Account.
  - **Date Range**: From: 2022-01-01 To: 2025-12-30.
- **Checkboxes (Transaction Types)**:
  - **Sales** - Checked.
  - **Purchase** - Checked.
  - **Sales Return** - Checked.
  - **Purchase Return** - Checked.
- **Checkboxes (Display Options)**:
  - **Show Quantity** - Checked.
  - **Show Value** - Checked.
- **Action Button**: View Results.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Accounting Core
- **Component ID**: `ACCOUNTING-019`
- **Route / Slug**: `/app/account-movement-filtering`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `LedgerService`
- **Method Signature**:
    ```rust
    pub async fn handle_account_movement_filtering(
        ctx: &RequestContext,
        payload: AccountMovementFilteringRequest
    ) -> Result<AccountMovementFilteringResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `gl_accounts`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (gl_accounts_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 020
### **Item Search Options**

#### 1. Deep Visual Forensic Analysis
- **Header Selection**: Search in Items with a Barcode icon.
- **Result Filter Options**:
  - **Show only items with positive balance**.
  - **Don't show frozen items**.
- **Column Labels (Teal Bar)**: Content, Content, Tax %.
- **Constraint Label (Red/Orange)**: Prices do not include tax.
- **Main List Area**: _Empty_.
- **Bottom Action Bar**:
  - Export Prices - Bottom Left.
  - Import and Edit Prices - Bottom Right.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Inventory & Supply Chain
- **Component ID**: `INVENTORY-020`
- **Route / Slug**: `/app/item-search-options`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `InventoryService`
- **Method Signature**:
    ```rust
    pub async fn handle_item_search_options(
        ctx: &RequestContext,
        payload: ItemSearchOptionsRequest
    ) -> Result<ItemSearchOptionsResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `inventory_items`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (inventory_items_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 021
### **Pricing Method**

#### 1. Deep Visual Forensic Analysis
- **Header**: Pricing Method.
- **Core Strategy (Radio Buttons)**:
  - **Price by last transaction**.
  - **Fixed price** - _Selected_.
  - **Last transaction for account**.
- **Modification Options (Radio Buttons)**:
  - **Increase profit margin based on cost**.
  - **Increase current sales price** - _Selected_.
  - **Decrease current sales price**.
  - **Increase current purchase price**.
  - **Decrease current purchase price**.
- **Target Selection**: Item Catalog - Field: "All".
- **Adjustment Tool**:
  - Value Input: "Content ContentEdit".
  - Toggle: Percentage (%) - _Checked_.
  - Action: **Modify** - Green Button.
- **Filters**:
  - "Content Content Content ContentBalance Content Content".
  - "Content Content Content Content".

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-021`
- **Route / Slug**: `/app/pricing-method`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_pricing_method(
        ctx: &RequestContext,
        payload: PricingMethodRequest
    ) -> Result<PricingMethodResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 022
### **Account Management and Financial Operations**

#### 1. Deep Visual Forensic Analysis
- **Modal Header**: "Invoice Number: 1", "Date: 2025-12-30", "Content: 19:11:42".
- **Fields**:
  - Currency Drawer: **Rial**.
  - Title: **Inventory Invoice**.
  - Toggle: **Tax** - _OFF_.
- **Main Action**: **Start Invoice**.
- **Background Warning (Blue Pill)**: You can create more than one inventory invoice; it's not necessary to inventory all items in one invoice.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Accounting Core
- **Component ID**: `ACCOUNTING-022`
- **Route / Slug**: `/app/account-management-and-financial-operations`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `LedgerService`
- **Method Signature**:
    ```rust
    pub async fn handle_account_management_and_financial_operations(
        ctx: &RequestContext,
        payload: AccountManagementAndFinancialOperationsRequest
    ) -> Result<AccountManagementAndFinancialOperationsResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `gl_accounts`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (gl_accounts_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 023
### **Inventory Adjustments**

#### 1. Deep Visual Forensic Analysis
- **Header**: Inventory Reconciliation.
- **Summary Cards**:
  - **Revenue from Adjustments**: 0.
  - **Losses from Adjustments**: 0.
  - **Net**: 0.
- **Navigation Tabs**:
  - **All** - _Selected_.
  - **Entry Invoices**.
  - **Exit/Outlet Invoices**.
- **Primary Action**: **Create New Reconciliation** - Button with Green [+] icon.
- **Footer Navigation**: Left, Right.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Inventory & Supply Chain
- **Component ID**: `INVENTORY-023`
- **Route / Slug**: `/app/inventory-adjustments`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `InventoryService`
- **Method Signature**:
    ```rust
    pub async fn handle_inventory_adjustments(
        ctx: &RequestContext,
        payload: InventoryAdjustmentsRequest
    ) -> Result<InventoryAdjustmentsResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `inventory_items`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (inventory_items_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 024
### **Barcode Creation Engine**

#### 1. Deep Visual Forensic Analysis
- **Modal Content**:
  - Visual: A large Blue Printer icon.
  - Title/Sub-header: Making Barcode.
- **Input Fields**:
  - **Item Name**.
  - **Price**.
  - **Barcode**.
- **Helper Link**: Generate random barcode with a refresh icon.
- **Footer Links**: Choose from item list.
- **Primary Button**: **Create Barcode** - Large Green Button.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Inventory & Supply Chain
- **Component ID**: `INVENTORY-024`
- **Route / Slug**: `/app/barcode-creation-engine`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `InventoryService`
- **Method Signature**:
    ```rust
    pub async fn handle_barcode_creation_engine(
        ctx: &RequestContext,
        payload: BarcodeCreationEngineRequest
    ) -> Result<BarcodeCreationEngineResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_barcodes`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_barcodes_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 025
### **Financial Services and Shortcuts List**

#### 1. Deep Visual Forensic Analysis
- **Dashboard Tab**: **Accounts** - _Active_.
- **Quick Action Grid (Top)**:
  - **Payment to Account**.
  - **Receipt from Account**.
  - **Register New Debt**.
- **Functional List**:
  - **Debt List**.
  - **Account List**.
  - **Account to Account Transfer - Double Entry**.
  - **Account Statement**.
  - **Box/Cash Movement**.
  - **Expense Registration**.
  - **External Income Registration**.
  - **Search by Entry Number**.
  - **Register Old Debts**.
  - **Cash Reconciliation and Repair**.
  - **Opening Balance Entry**.
  - **Exchange Rates**.
- **Footer**: "Main Cashier/Vault: 0".

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-025`
- **Route / Slug**: `/app/financial-services-and-shortcuts-list`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_financial_services_and_shortcuts_list(
        ctx: &RequestContext,
        payload: FinancialServicesAndShortcutsListRequest
    ) -> Result<FinancialServicesAndShortcutsListResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 026
### **Reports Dashboard**

#### 1. Deep Visual Forensic Analysis
- **Header**: **Reports** - _Active Tab_.
- **Primary Grid (Cards)**:
  - **Daily Movement** - Icon with analytics sheet.
  - **Profit and Loss** - Icon with rising chart.
- **Vertical List Items**:
  - **Capital - Balance Sheet**.
  - **Fastest Moving Items**.
  - **Most Active Customers**.
  - **Show items at Minimum Stock**.
  - **Show items with quantity less than...**.
  - **Slowest Moving Items**.
  - **Least Active Customers**.
- **Sticky Footer Bar**: "Main Cashier/Vault: 0".

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Reporting & Analytics
- **Component ID**: `REPORTING-026`
- **Route / Slug**: `/app/reports-dashboard`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `ReportingService`
- **Method Signature**:
    ```rust
    pub async fn handle_reports_dashboard(
        ctx: &RequestContext,
        payload: ReportsDashboardRequest
    ) -> Result<ReportsDashboardResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `analytics_reports`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (analytics_reports_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 027
### **Security and Backup Settings**

#### 1. Deep Visual Forensic Analysis
- **Tab**: **Settings** - _Active_.
- **Security & General (Section)**:
  - Toggle: **Security by PIN on entry** - _OFF_.
  - Toggle: **Show secondary item name in print** - _ON_.
  - Toggle: **Always backup on exit** - _OFF_.
  - Toggle: **Maintain calculator state across screens** - _ON_.
  - Input: **Decimal places**.
- **Language (Section)**:
  - Icons for Flags: AR (Jordan/Saudi), EN (UK), FR (France), TR (Turkey).
- **Printer & Layout (Section)**:
  - **Tax custom settings**.
  - **Print improvements**.
  - **Bluetooth Printer Settings**.
  - **Choose printer model**.
  - **Print Font Size : 10**.
- **Accounting Policy (Section)**:
  - Toggle: **Combine duplicates in invoice** - _OFF_.
  - Toggle: **Allow selling below cost**.
  - Toggle: **Enable low stock alert** - _ON_.
  - Toggle: **Allow selling when out of stock** - _ON_.
- **Maintenance (Bottom)**:
  - **Invoice Repair**, **Red text**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Administration
- **Component ID**: `ADMINISTRATION-027`
- **Route / Slug**: `/app/security-and-backup-settings`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `AdminService`
- **Method Signature**:
    ```rust
    pub async fn handle_security_and_backup_settings(
        ctx: &RequestContext,
        payload: SecurityAndBackupSettingsRequest
    ) -> Result<SecurityAndBackupSettingsResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `system_configs`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (system_configs_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 028
### **System Information**

#### 1. Deep Visual Forensic Analysis
- **Header**: System Info.
- **Main Visual**: Large QR Code in the center.
- **Data Attributes**:
  - **App Version**: 1.166.240825.
  - **Activation Status**: Trial Version (Trial).
  - **Country**: KSA-0.
  - **Account ID**: E-240825.
  - **Account Phone**: 0096716088873.
  - **Android Version**: SDK: 31 (12).
  - **Device Name**: samsung-SM-N975U.
  - **Backup**: Inactive (Inactive).
  - **DB Count**: 1.
  - **DB Path**: `/storage/emulated/150/Android/data/.../files/basir.accounting_data`.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-028`
- **Route / Slug**: `/app/system-information`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_system_information(
        ctx: &RequestContext,
        payload: SystemInformationRequest
    ) -> Result<SystemInformationResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 029
### **Set Manager PIN Request**

#### 1. Deep Visual Forensic Analysis
- **Context**: Modal popup over the Settings screen ( ).
- **Title**: Please set a secret code for the Manager.
- **Fields**:
  - **Secret Code/PIN**.
  - **Name when printing**.
- **Primary Button**: **Edit/Set** - Green.
- **Overlay Status (Green Pill)**: "Content Content Content Content Content" with a checkmark.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-029`
- **Route / Slug**: `/app/set-manager-pin-request`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_set_manager_pin_request(
        ctx: &RequestContext,
        payload: SetManagerPinRequestRequest
    ) -> Result<SetManagerPinRequestResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 030
### **Select User**

#### 1. Deep Visual Forensic Analysis
- **Context**: Modal popup over Settings ( ).
- **Title**: Choose User.
- **User Profile Card**:
  - Icon: Head/Shoulders avatar (professional illustration).
  - Text: **The Manager**.
- **Background**: Settings UI with visible language flags (AR, EN, FR, TR).

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Administration
- **Component ID**: `ADMINISTRATION-030`
- **Route / Slug**: `/app/select-user`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `AdminService`
- **Method Signature**:
    ```rust
    pub async fn handle_select_user(
        ctx: &RequestContext,
        payload: SelectUserRequest
    ) -> Result<SelectUserResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_users`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_users_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 031
### **Built-in Calculator**

#### 1. Deep Visual Forensic Analysis
- **Header**: Back arrow with a calculator icon on the right.
- **Display Area**: _Empty_ (Initial state).
- **Keypad (Orange/Cream)**:
  - Row 1: `/`, `(`, `)`, **Clear - Orange**.
  - Row 2: `7`, `8`, `9`, `X` (Orange).
  - Row 3: `4`, `5`, `6`, `-` (Orange).
  - Row 4: `1`, `2`, `3`, `+` (Orange).
  - Row 5: `%`, `0`, `.`, `=` (Orange).
- **Footer Option**: Checkbox: Convert to currencies.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-031`
- **Route / Slug**: `/app/built-in-calculator`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_built_in_calculator(
        ctx: &RequestContext,
        payload: CalculatorRequest
    ) -> Result<CalculatorResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 032
### **Select Database Request**

#### 1. Deep Visual Forensic Analysis
- **Modal Title**: Please choose a database.
- **Active Card**: Main Database - Focused with a soft shadow.
- **Statistical Footer**: Count: 1.
- **Background**: Dashboard showing "basir.accounting" Cloud Backup icon.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-032`
- **Route / Slug**: `/app/select-database-request`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_select_database_request(
        ctx: &RequestContext,
        payload: SelectDatabaseRequestRequest
    ) -> Result<SelectDatabaseRequestResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 033
### **Cloud Backup Settings**

#### 1. Deep Visual Forensic Analysis
- **Tabbed Interface**:
  - **Local Backup** - _Inactive_.
  - **Backup to Drive** - _Selected/Active_.
- **Local Options**: Button: "Enable Local Backup" with an SD card/Chip icon.
- **Cloud Options**: Button: "Enable Google Drive Backup" with the official Drive icon.
- **Path Disclosure**: `/storage/emulated/150/Android/data/basir.accounting/files/basir.accounting_data`.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Administration
- **Component ID**: `ADMINISTRATION-033`
- **Route / Slug**: `/app/cloud-backup-settings`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `AdminService`
- **Method Signature**:
    ```rust
    pub async fn handle_cloud_backup_settings(
        ctx: &RequestContext,
        payload: CloudBackupSettingsRequest
    ) -> Result<CloudBackupSettingsResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `system_configs`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (system_configs_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 034
### **Tax and E-Invoice Settings**

#### 1. Deep Visual Forensic Analysis
- **Header Info (Green Pill)**: This feature is only for E-Invoicing... ZATCA/Saudi Arabia.
- **Core Toggles**:
  - **Enable Tax on Invoices** - _OFF_.
  - **Price includes tax by default** - _OFF_.
- **Fields**:
  - **Tax ID/VAT Number**.
  - **Default Tax Value** - Input: **15**.
- **Action Buttons**:
  - **Modify tax for all items**.
  - **Pricing Policy**.
  - **Edit Prices and Taxes**.
- **Print Labels (Input)**:
  - **B2C Simplified**: "Simplified Tax Invoice".
  - **B2B Standard**: "Tax Invoice".
- **Primary Action**: **Save Labels**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Sales & Revenue
- **Component ID**: `SALES-034`
- **Route / Slug**: `/app/tax-and-e-invoice-settings`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `SalesService`
- **Method Signature**:
    ```rust
    pub async fn handle_tax_and_e_invoice_settings(
        ctx: &RequestContext,
        payload: TaxAndSettingsRequest
    ) -> Result<TaxAndSettingsResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sales_invoices`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sales_invoices_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 035
### **Pricing Strategy**

#### 1. Deep Visual Forensic Analysis
- **Header**: Pricing Method.
- **Radio Selection**:
  - **Price by last transaction**.
  - **Fixed price** - _Selected_.
  - **Last transaction for account**.
- **Modification Options**: Consistent with .
- **State Check**: Shows the "Everything/All" selection in the item index.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-035`
- **Route / Slug**: `/app/pricing-strategy`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_pricing_strategy(
        ctx: &RequestContext,
        payload: PricingStrategyRequest
    ) -> Result<PricingStrategyResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 036
### **Advanced Item Search Filters**

#### 1. Deep Visual Forensic Analysis
- **Header**: Search bar "ContentSearch Content Content" with Barcode icon.
- **Result Filters**:
  - "Content Content Content ContentBalance Content Content".
  - "Content Content Content Content".
- **Column Headers (Teal)**: Content, Content, Tax %.
- **Constraint Label (Red)**: "Content Content Content Tax".
- **Empty State**: No items listed (initial load or zero results).
- **Footer Actions**: Left, Right.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Inventory & Supply Chain
- **Component ID**: `INVENTORY-036`
- **Route / Slug**: `/app/advanced-item-search-filters`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `InventoryService`
- **Method Signature**:
    ```rust
    pub async fn handle_advanced_item_search_filters(
        ctx: &RequestContext,
        payload: AdvancedItemSearchFiltersRequest
    ) -> Result<AdvancedItemSearchFiltersResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `inventory_items`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (inventory_items_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 037
### **Company Data and Logo Printing**

#### 1. Deep Visual Forensic Analysis
- **Branding Header**:
  - Image Box: Company Logo Image Here.
  - Checkbox: **Print Logo** - _Checked_.
- **Business Identity Fields**:
  - **Company Phone Numbers**.
  - **Company Activity/Industry**.
  - **Company Address**.
- **Invoice Content Toggles**:
  - **Show Account Address** - _Checked_.
  - **Show Account Mobile** - _Checked_.
  - **Show Tax Info** - _Checked_.
  - **Show Item Number Separately** - _OFF_.
  - **Show Item Notes** - _Checked_.
  - **Show Employee Name** - _Checked_.
  - **Show Balance Before/After Invoice** - _OFF_.
  - **Show Total Quantities** - _Checked_.
- **Report Customization**:
  - Label: **Customize Report Color**.
  - Dynamic Text Area: Footer notes/T&Cs.
  - Checkbox: **Show Print Date/Time** - _Checked_.
  - Lower Footer: Bottom of page header.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-037`
- **Route / Slug**: `/app/company-data-and-logo-printing`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_company_data_and_logo_printing(
        ctx: &RequestContext,
        payload: CompanyDataAndLogoPrintingRequest
    ) -> Result<CompanyDataAndLogoPrintingResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_print_templates`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_print_templates_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 038
### **Select Language Request**

#### 1. Deep Visual Forensic Analysis
- **Context**: Modal popup on top of the "Rename Labels" screen.
- **Title**: Please choose language.
- **Options List**:
  - **Arabic** with Jordan/Saudi flag.
  - **English** with UK flag.
  - **French** with France flag.
  - **Turkish** with Turkey flag.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-038`
- **Route / Slug**: `/app/select-language-request`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_select_language_request(
        ctx: &RequestContext,
        payload: SelectLanguageRequestRequest
    ) -> Result<SelectLanguageRequestResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 039
### **Rename Invoice Labels**

#### 1. Deep Visual Forensic Analysis
- **Header Selection**: Invoices.
- **Data Rows (Key-Value Edit)**:
  - **Customer Tax ID** -> **Customer Tax ID**.
  - **Invoice Number** -> **Invoice Number**.
  - **Grand Total Tax** -> **Grand Total Tax**.
  - **Notes** -> **Notes**.
  - **Previous Balance** -> **Previous Balance**.
  - **Mobile Number** -> **Mobile Number**.
  - **Unit** -> **Unit**.
  - **Item Name** -> **Item Name**.
  - **Seller Gift** -> **Seller Gift**.
  - **Invoice Total** -> **Invoice Total**.
  - **Net Excluding VAT**.
  - **Balance Before Invoice**.
  - **Total VAT Amount**.
- **Action**: Edit button next to each row.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Sales & Revenue
- **Component ID**: `SALES-039`
- **Route / Slug**: `/app/rename-invoice-labels`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `SalesService`
- **Method Signature**:
    ```rust
    pub async fn handle_rename_invoice_labels(
        ctx: &RequestContext,
        payload: RenameInvoiceLabelsRequest
    ) -> Result<RenameInvoiceLabelsResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sales_invoices`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sales_invoices_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 040
### **Select Document Type for Editing**

#### 1. Deep Visual Forensic Analysis
- **Context**: Dropdown menu for picking which document type to rename.
- **Options**:
  - **Invoices**.
  - **Thermal/Roll Invoice**.
  - **Vouchers/Bonds**.
  - **Price Quotes**.
  - **Report Headers**.
  - **Account Statement**.
  - **Mini Statement - Roll**.
  - **Warehouse Inventory**.
  - **Debt List**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-040`
- **Route / Slug**: `/app/select-document-type-for-editing`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_select_document_type_for_editing(
        ctx: &RequestContext,
        payload: SelectDocumentTypeForEditingRequest
    ) -> Result<SelectDocumentTypeForEditingResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 041
### **Print Template Selection Interface**

#### 1. Deep Visual Forensic Analysis
- **Table Label Customization**: Specifically for the **Debt List** module.
- **Editable Keys**:
  - **Title**.
  - **User/Customer Name**.
  - **Amount**.
  - **Transaction Type**.
  - **Account Name**.
  - **Row Number/ID**.
  - **Our Credit / Debit to them**.
  - **Their Credit / Debt on us**.
  - **Running Balance**.
  - **Total Liability**.
  - **Total Assets**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-041`
- **Route / Slug**: `/app/print-template-selection-interface`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_print_template_selection_interface(
        ctx: &RequestContext,
        payload: PrintTemplateSelectionInterfaceRequest
    ) -> Result<PrintTemplateSelectionInterfaceResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_print_templates`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_print_templates_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 042
### **Print Template Preview**

#### 1. Deep Visual Forensic Analysis
- **UI State**: Dropdown overlay menu for selecting document types (Invoices, Bonds, Quotes, etc.).
- **Background**: Faded view of the Label Customization screen.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-042`
- **Route / Slug**: `/app/print-template-preview`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_print_template_preview(
        ctx: &RequestContext,
        payload: PrintTemplatePreviewRequest
    ) -> Result<PrintTemplatePreviewResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_print_templates`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_print_templates_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 043
### **Paper Size Settings**

#### 1. Deep Visual Forensic Analysis
- **Header**: Paper Measurement.
- **Physical Options**:
  - Radio: **Size 58 mm**.
  - Radio: **Size 80 mm** - _Selected_.
- **Numerical Inputs**:
  - **Other/Custom width** -> Value: **375**.
  - **Font Size** -> Value: **20**.
  - **Padding/Empty lines at end** -> Value: **7**.
- **Toggles**:
  - **Print 2 copies** - _OFF_.
  - **Print item unit** - _OFF_.
- **Font Selection**:
  - Radio: **basir.accounting 2021** - _Selected_.
  - Radio: **Alternate**.
- **Action**: **Save Settings**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Administration
- **Component ID**: `ADMINISTRATION-043`
- **Route / Slug**: `/app/paper-size-settings`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `AdminService`
- **Method Signature**:
    ```rust
    pub async fn handle_paper_size_settings(
        ctx: &RequestContext,
        payload: PaperSizeSettingsRequest
    ) -> Result<PaperSizeSettingsResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `system_configs`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (system_configs_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 044
### **Invoice and Account Statement Printing Options**

#### 1. Deep Visual Forensic Analysis
- **Template Gallery Mode**:
  - **A4 Invoice**: Shows a professional layout with Header, Table, Summary, and QR.
  - **Bluetooth Receipt**: Shows a vertically stacked layout with large logo, centered text, and simplified table.
  - **Account Statement**: Shows a landscape-focused ledger view.
- **Selection**: Radio buttons next to each preview image.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Sales & Revenue
- **Component ID**: `SALES-044`
- **Route / Slug**: `/app/invoice-and-account-statement-printing-options`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `SalesService`
- **Method Signature**:
    ```rust
    pub async fn handle_invoice_and_account_statement_printing_options(
        ctx: &RequestContext,
        payload: InvoiceAndAccountStatementPrintingOptionsRequest
    ) -> Result<InvoiceAndAccountStatementPrintingOptionsResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sales_invoices`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sales_invoices_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 045
### **Currency Search Engine**

#### 1. Deep Visual Forensic Analysis
- **Header**: Search bar Search in currencies.
- **Constants List**:
  - **Dollar**.
  - **Yemeni Rial**.
  - **Euro**.
- **Footer**: Results: 3.
- **Action**: Floating Action Button (FAB) with `+` for adding new currencies.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-045`
- **Route / Slug**: `/app/currency-search-engine`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_currency_search_engine(
        ctx: &RequestContext,
        payload: CurrencySearchEngineRequest
    ) -> Result<CurrencySearchEngineResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_currencies`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_currencies_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 046
### **Currency Information**

#### 1. Deep Visual Forensic Analysis
- **Header**: Currency Information - Purple.
- **Form Fields (Grey Border)**:
  - **Currency Name**.
  - **Symbol**.
  - **Fractional Unit, e.g., Cents/Fils**.
  - **Exchange Rate Coefficient**.
- **Global Setting**: Checkbox: Default for Sales/Payments.
- **Action**: **Save - Teal**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-046`
- **Route / Slug**: `/app/currency-information`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_currency_information(
        ctx: &RequestContext,
        payload: CurrencyInformationRequest
    ) -> Result<CurrencyInformationResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_currencies`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_currencies_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 047
### **Item Index Management**

#### 1. Deep Visual Forensic Analysis
- **Header**: Search bar Search in Item Index.
- **List Item**: Primary Items.
- **Metadata**: Circular icon/placeholder on the left.
- **Footer**: "Result count : 1".
- **Action**: Floating Action Button (FAB) `+`.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Inventory & Supply Chain
- **Component ID**: `INVENTORY-047`
- **Route / Slug**: `/app/item-index-management`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `InventoryService`
- **Method Signature**:
    ```rust
    pub async fn handle_item_index_management(
        ctx: &RequestContext,
        payload: ItemIndexManagementRequest
    ) -> Result<ItemIndexManagementResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `inventory_items`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (inventory_items_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 048
### **Index Name Registration**

#### 1. Deep Visual Forensic Analysis
- **Header**: Index Name.
- **Field**: Single input box for naming the index.
- **Action**: **Save**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-048`
- **Route / Slug**: `/app/index-name-registration`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_index_name_registration(
        ctx: &RequestContext,
        payload: IndexNameRegistrationRequest
    ) -> Result<IndexNameRegistrationResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 049
### **Unit of Measure Search**

#### 1. Deep Visual Forensic Analysis
- **Header**: Search in Units - UoM.
- **List Items**:
  - **Piece**.
  - **Box**.
  - **Pack**.
  - **Gram**.
  - **Kilogram**.
  - **Ton**.
  - **Meter**.
- **Icons**: Weighing scale / weight icon for each.
- **Footer**: "Result count : 8". (Note: One item is likely off-screen or empty in the render).

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-049`
- **Route / Slug**: `/app/unit-of-measure-search`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_unit_of_measure_search(
        ctx: &RequestContext,
        payload: UnitOfMeasureSearchRequest
    ) -> Result<UnitOfMeasureSearchResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 050
### **Select Profit Calculation Method Request**

#### 1. Deep Visual Forensic Analysis
- **Title**: Please select the method used for profit calculation.
- **Two Modals/Cards**:
  - **Modern Method** - _Selected/Bordered Teal_: Recommended for most cases.
  - **Old Method** - _Light Blue_: Used when selling in the negative/short-selling.
- **Buttons**:
  - **Continue - Teal**.
  - **Cancel - Text link**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Accounting Core
- **Component ID**: `ACCOUNTING-050`
- **Route / Slug**: `/app/select-profit-calculation-method-request`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `LedgerService`
- **Method Signature**:
    ```rust
    pub async fn handle_select_profit_calculation_method_request(
        ctx: &RequestContext,
        payload: SelectProfitCalculationMethodRequestRequest
    ) -> Result<SelectProfitCalculationMethodRequestResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `profit_loss_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (profit_loss_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 051
### **Upgrade to Professional Version**

#### 1. Deep Visual Forensic Analysis
- **Modal Title (Teal/Blue)**: This feature is for the activated version only.
- **Incentive Text**: Get your activated version for unlimited invoices and reports.
- **Core Action (Green Border)**: **Click here to subscribe** with a cursor icon.
- **Secondary Action (Blue Button)**: **Continue with trial version**.
- **Pop-up Toast (Bottom Green)**: Operation completed successfully.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-051`
- **Route / Slug**: `/app/upgrade-to-professional-version`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_upgrade_to_professional_version(
        ctx: &RequestContext,
        payload: UpgradeToProfessionalVersionRequest
    ) -> Result<UpgradeToProfessionalVersionResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 052
### **Login Credentials Request**

#### 1. Deep Visual Forensic Analysis
- **Modal Title**: Please enter mobile and PIN.
- **Fields**:
  - **Mobile Number**: `0096716088873`.
  - **PIN**: _Password/Hidden field_.
- **Hint**: Please enter your account info.
- **Action**: **Verify Info**.
- **Link**: Forgot password.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Administration
- **Component ID**: `ADMINISTRATION-052`
- **Route / Slug**: `/app/login-credentials-request`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `AdminService`
- **Method Signature**:
    ```rust
    pub async fn handle_login_credentials_request(
        ctx: &RequestContext,
        payload: LoginCredentialsRequestRequest
    ) -> Result<LoginCredentialsRequestResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_users`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_users_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 053
### **System Side Drawer**

#### 1. Deep Visual Forensic Analysis
- **Drawer Header**:
  - App Name: **Easy Accountant**.
  - Version: **August 2024 Build**.
  - Database: Main.
  - User: Manager.
- **List Items**:
  - **Buy App**.
  - **Support**.
  - **Send Suggestion**.
  - **Backup & Restore**.
  - **Change PIN**.
  - **App Tutorials - Video/Link**.
  - **Share App**.
  - **Change-log**.
  - **Logout**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-053`
- **Route / Slug**: `/app/system-side-drawer`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_system_side_drawer(
        ctx: &RequestContext,
        payload: SystemSideDrawerRequest
    ) -> Result<SystemSideDrawerResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 054
### **Profit Report**

#### 1. Deep Visual Forensic Analysis
- **Header**: **Profit Report** with Share/Print icon.
- **Recalculation Action (Green)**: **Recalculate Profits**.
- **Caveat Label (Yellow)**: Profits shown are estimated... Balance Sheet is more accurate.
- **Metrics Grid**:
  - **Sales Profits**: **0**.
  - **Revenues**: **0**.
  - **Total**: **0**.
  - **Expenses/Losses**: **Red text**.
  - **Net Profit**: **0**.
- **Time Selection Tabs**:
  - **All days** - _Selected_.
  - **Monthly**.
  - **Daily**.
  - **Custom**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Accounting Core
- **Component ID**: `ACCOUNTING-054`
- **Route / Slug**: `/app/profit-report`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `LedgerService`
- **Method Signature**:
    ```rust
    pub async fn handle_profit_report(
        ctx: &RequestContext,
        payload: ProfitReportRequest
    ) -> Result<ProfitReportResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `analytics_reports`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (analytics_reports_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 055
### **Daily Transaction Movement**

#### 1. Deep Visual Forensic Analysis
- **Header**: **Daily Movement**.
- **Date Display**: **2025-12-30**.
- **Top Card (Cash Flow)**:
  - **Receipts**: **0**.
  - **Payments**: **0**.
  - **Net Cash**: **0**.
- **Pivot Table (Cash vs. Credit)**:
  - Rows: Content (Sales), Content (Purchase), Content Content (Sales Return), Content Content (Purchase Return).
  - Columns: Content (Cash), Content (Credit).
- **Bottom Summary**:
  - Content Content: **0**.
  - Content ContentRevenues: **0**.
  - Content Content: **0**.
  - Content: **0**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-055`
- **Route / Slug**: `/app/daily-transaction-movement`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_daily_transaction_movement(
        ctx: &RequestContext,
        payload: DailyTransactionMovementRequest
    ) -> Result<DailyTransactionMovementResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 056
### **Daily Movement Processing State**

#### 1. Deep Visual Forensic Analysis
- **UI State**: Active loading overlay on the Daily Movement report.
- **Message**: Preparing data, please wait.
- **Context**: This typically appears when changing the time period (e.g., from "Daily" to "Monthly") or when recalculating profit for a large transaction history.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-056`
- **Route / Slug**: `/app/daily-movement-processing-state`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_daily_movement_processing_state(
        ctx: &RequestContext,
        payload: DailyMovementProcessingStateRequest
    ) -> Result<DailyMovementProcessingStateResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 057
### **Balance Sheet and Fair Valuation**

#### 1. Deep Visual Forensic Analysis
- **Valuation Strategy Toggles**:
  - **Last Purchase Price** - _Selected_.
  - **Average Purchase Price**.
- **Split View (Assets vs. Liabilities)**:
  - **For Us / Assets**:
    - Content Content (Accounts Receivable): **0**.
    - Content Content Content (Inventory Value): **0**.
    - Main Cashier/Vault (Main Cash): **0**.
  - **Against Us / Liabilities**:
    - Content Content (Accounts Payable): **0**.
- **Footer**: **Total Capital/Equity**: **0**. (Calculation: Assets - Liabilities).

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Accounting Core
- **Component ID**: `ACCOUNTING-057`
- **Route / Slug**: `/app/balance-sheet-and-fair-valuation`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `LedgerService`
- **Method Signature**:
    ```rust
    pub async fn handle_balance_sheet_and_fair_valuation(
        ctx: &RequestContext,
        payload: BalanceSheetAndFairValuationRequest
    ) -> Result<BalanceSheetAndFairValuationResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 058
### **Debt and Liability Registration**

#### 1. Deep Visual Forensic Analysis
- **Title (Implicit)**: Bond/Debt Entry.
- **Transaction Direction Tabs**:
  - **Debt on him** - _Selected_.
  - **Debt for him**.
- **Form Fields**:
  - **Customer/Supplier/Account Name**.
  - **Date**: **2025-12-30**.
  - **Sequence Number**: **1**.
  - **Amount**.
  - **Notes**.
- **Action Dashboard**:
  - **Save - Green icon**.
  - **Other Operations**.
  - **Currency Shortcut**: Blue button with currency/calculator icon.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-058`
- **Route / Slug**: `/app/debt-and-liability-registration`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_debt_and_liability_registration(
        ctx: &RequestContext,
        payload: DebtAndLiabilityRegistrationRequest
    ) -> Result<DebtAndLiabilityRegistrationResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `liabilities`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (liabilities_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 059
### **Cash Receipts Voucher**

#### 1. Deep Visual Forensic Analysis
- **Header Title**: **Receipts**.
- **Search Component**: Suggestion field for accounts.
- **Voucher ID**: **1**.
- **Numeric Fields**: Amount, Note.
- **Action**: Floating "Save" button with a floppy disk icon.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-059`
- **Route / Slug**: `/app/cash-receipts-voucher`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_cash_receipts_voucher(
        ctx: &RequestContext,
        payload: CashReceiptsVoucherRequest
    ) -> Result<CashReceiptsVoucherResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `cash_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (cash_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 060
### **Cash Payments Voucher**

#### 1. Deep Visual Forensic Analysis
- **Header Title**: **Payments**.
- **Fields**: (Mirror of Receipts screen).
- **Action**: **Save**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-060`
- **Route / Slug**: `/app/cash-payments-voucher`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_cash_payments_voucher(
        ctx: &RequestContext,
        payload: CashPaymentsVoucherRequest
    ) -> Result<CashPaymentsVoucherResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `cash_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (cash_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 061
### **Debt List Dashboard**

#### 1. Deep Visual Forensic Analysis
- **Header Title**: **Debt List** with Print/Share icon.
- **Aggregate Card**:
  - **Total Receivables**: **0**.
  - **Total Payables**: **0**.
- **Contextual Filters (Checkboxes)**:
  - **Customers**.
  - **Suppliers**.
  - **Others**.
- **Navigation Tabs**:
  - **All**, **Dr**, **Cr**, **Overdue/Aged**.
- **Bottom Navigation**:
  - **New Debt Record**.
  - **Payment to Account**.
  - **Receipt from Account**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Reporting & Analytics
- **Component ID**: `REPORTING-061`
- **Route / Slug**: `/app/debt-list-dashboard`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `ReportingService`
- **Method Signature**:
    ```rust
    pub async fn handle_debt_list_dashboard(
        ctx: &RequestContext,
        payload: DebtListDashboardRequest
    ) -> Result<DebtListDashboardResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `liabilities`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (liabilities_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 062
### **Currency Movement Registration Interface**

#### 1. Deep Visual Forensic Analysis
- **UI State**: Full-screen search mode for accounts.
- **Header**: Omnibar with search icon and Search placeholder.
- **Bottom Actions**:
  - **New Account - Folder/Plus icon**.
  - **Sort Results - List/Arrows icon**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-062`
- **Route / Slug**: `/app/currency-movement-registration-interface`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_currency_movement_registration_interface(
        ctx: &RequestContext,
        payload: CurrencyMovementRegistrationInterfaceRequest
    ) -> Result<CurrencyMovementRegistrationInterfaceResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_currencies`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_currencies_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 063
### **Journal Entry History**

#### 1. Deep Visual Forensic Analysis
- **Modal Header**: **From Account** / **To Account**.
- **Fields**:
  - **Select Account** dropdowns for both Source and Destination.
  - **Amount Field**: Default `0.00`.
  - **Currency Display**: Rial.
  - **Entry Date**: **2025-12-30**.
  - **Entry Description/Memo**.
- **Actions**:
  - **Save + Repeat/Duplicate**.
  - **Save + New**.
  - **Close**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Accounting Core
- **Component ID**: `ACCOUNTING-063`
- **Route / Slug**: `/app/journal-entry-history`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `LedgerService`
- **Method Signature**:
    ```rust
    pub async fn handle_journal_entry_history(
        ctx: &RequestContext,
        payload: JournalEntryHistoryRequest
    ) -> Result<JournalEntryHistoryResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `gl_journal_entries`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (gl_journal_entries_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 064
### **Account Statement Query Options**

#### 1. Deep Visual Forensic Analysis
- **Search Component**: Suggestion box for "Customer, Supplier, Account Name".
- **Options (Checkboxes)**:
  - **Show data since last reconciliation**.
  - **Show cash movements**.
- **Date Range**: **From** 2022-01-01 **To** 2025-12-30.
- **Currency Filters (Radio)**:
  - **Show all with adjusted rate**.
  - **One currency only**.
  - **All currencies separately**.
- **Action**: **Show Results**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Accounting Core
- **Component ID**: `ACCOUNTING-064`
- **Route / Slug**: `/app/account-statement-query-options`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `LedgerService`
- **Method Signature**:
    ```rust
    pub async fn handle_account_statement_query_options(
        ctx: &RequestContext,
        payload: AccountStatementQueryOptionsRequest
    ) -> Result<AccountStatementQueryOptionsResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `gl_accounts`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (gl_accounts_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 065
### **Cashier Movement Report**

#### 1. Deep Visual Forensic Analysis
- **Title**: **Cashier Movement**.
- **Currency Chips**: **Selected**, **Rial**, **$**, **EUR**.
- **Summary Metrics**:
  - **Receipts**: **0 Rial**.
  - **Payments**: **0 Rial**.
- **Contextual Search**: Customize types and date.
- **Bottom Navigation (Toggle)**:
  - **Daily Aggregate**.
  - **Detailed View** - _Selected_.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Reporting & Analytics
- **Component ID**: `REPORTING-065`
- **Route / Slug**: `/app/cashier-movement-report`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `ReportingService`
- **Method Signature**:
    ```rust
    pub async fn handle_cashier_movement_report(
        ctx: &RequestContext,
        payload: CashierMovementReportRequest
    ) -> Result<CashierMovementReportResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `cash_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (cash_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 066
### **Expenses Dashboard**

#### 1. Deep Visual Forensic Analysis
- **Header Title**: **Expenses**.
- **Secondary Action**: **Expense Details**.
- **Developer/Placeholder Overlay (Yellow)**: A religious phrase, likely used as a temporary toast or developer note.
- **Voucher ID**: **1**.
- **Action**: **Save**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Reporting & Analytics
- **Component ID**: `REPORTING-066`
- **Route / Slug**: `/app/expenses-dashboard`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `ReportingService`
- **Method Signature**:
    ```rust
    pub async fn handle_expenses_dashboard(
        ctx: &RequestContext,
        payload: ExpensesDashboardRequest
    ) -> Result<ExpensesDashboardResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 067
### **Journal Entry Search Engine**

#### 1. Deep Visual Forensic Analysis
- **Modal Header**: **Search in Entry Number**.
- **Numeric Field**: **Entry Number**.
- **Radio Selection Matrix**:
  - **Receipts**, **Debit (Assets)**.
  - **Payments**, **Credit (Liabilities)**.
  - **Expenses**, **Credit Entry**.
  - **Revenues**, **Debit Entry**.
- **Action**: **Search - Green button**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Accounting Core
- **Component ID**: `ACCOUNTING-067`
- **Route / Slug**: `/app/journal-entry-search-engine`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `LedgerService`
- **Method Signature**:
    ```rust
    pub async fn handle_journal_entry_search_engine(
        ctx: &RequestContext,
        payload: JournalEntrySearchEngineRequest
    ) -> Result<JournalEntrySearchEngineResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `gl_journal_entries`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (gl_journal_entries_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 068
### **Adjust Opening Account Balances**

#### 1. Deep Visual Forensic Analysis
- **Overlay State**: Custom initial/adjustment balance modal.
- **Fields**:
  - **Account Name - Selection**.
  - **Amount**.
  - **Direction Toggle**: **Selected** vs **on him (Debit)**.
  - **Entry Description**.
- **Action**: **Save**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Accounting Core
- **Component ID**: `ACCOUNTING-068`
- **Route / Slug**: `/app/adjust-opening-account-balances`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `LedgerService`
- **Method Signature**:
    ```rust
    pub async fn handle_adjust_opening_account_balances(
        ctx: &RequestContext,
        payload: AdjustOpeningAccountBalancesRequest
    ) -> Result<AdjustOpeningAccountBalancesResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `gl_accounts`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (gl_accounts_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 069
### **Cash Reconciliation and Repair**

#### 1. Deep Visual Forensic Analysis
- **Header**: **Cashier Repair/Correction**.
- **Instructional Text**: The difference will be posted to the Main Cashier Reconciliation account.
- **Primary Input**: Enter real cash value.
- **Warning (Orange)**: To modify later, use the Account Statement for the reconciliation account.
- **Action**: **Save**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-069`
- **Route / Slug**: `/app/cash-reconciliation-and-repair`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_cash_reconciliation_and_repair(
        ctx: &RequestContext,
        payload: CashReconciliationAndRepairRequest
    ) -> Result<CashReconciliationAndRepairResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `cash_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (cash_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 070
### **Cash Reconciliation Audit**

#### 1. Deep Visual Forensic Analysis
- **Duplicate Context**: This is visually identical to 191915, likely captured as a "success" state or a multi-step verification of the same module.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-070`
- **Route / Slug**: `/app/cash-reconciliation-audit`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_cash_reconciliation_audit(
        ctx: &RequestContext,
        payload: CashReconciliationAuditRequest
    ) -> Result<CashReconciliationAuditResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `cash_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (cash_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 071
### **Select Currency for Exchange Rate Request**

#### 1. Deep Visual Forensic Analysis
- **Header**: **Select Currency to Set Exchange Rate**.
- **Core Strategy**: Base currency is Rial.
- **Exchange Table**:
  - **Yemeni Rial** <-> 1 <-> **Yemeni Rial**.
  - **Euro** <-> 1 <-> **Yemeni Rial**.
  - **Dollar** <-> 1 <-> **Yemeni Rial**.
- **Action**: **Save Changes - Blue icon**.
- **Status Toast**: Currencies are linked to the selected base currency above.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-071`
- **Route / Slug**: `/app/select-currency-for-exchange-rate-request`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_select_currency_for_exchange_rate_request(
        ctx: &RequestContext,
        payload: SelectCurrencyForExchangeRateRequestRequest
    ) -> Result<SelectCurrencyForExchangeRateRequestResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_currencies`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_currencies_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 072
### **Financial Operations List**

#### 1. Deep Visual Forensic Analysis
- **UI Tab**: **Accounts**.
- **Quick Action Row**:
  - **Record New Debt**.
  - **Receipt**.
  - **Payment**.
- **Master Index**:
  - **Debt List**.
  - **Account List**.
  - **Account Transfer**.
  - **Statement**.
  - **Cash Flow**.
  - **Expenses**.
  - **Other Income**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-072`
- **Route / Slug**: `/app/financial-operations-list`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_financial_operations_list(
        ctx: &RequestContext,
        payload: FinancialOperationsListRequest
    ) -> Result<FinancialOperationsListResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 073
### **System Behavior and Maintenance Options**

#### 1. Deep Visual Forensic Analysis
- **UI Tab**: **Settings**.
- **Behavioral Toggles**:
  - **Show frozen accounts**.
  - **Default Qty = 1**.
- **Profit Strategy Section**: Identify profit calculation method.
- **Maintenance Section (Maintenance)**:
  - **Repair Invoices**.
  - **Repair Permissions**.
  - **Reconcile/Rollover**.
  - **Renumber Invoices**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-073`
- **Route / Slug**: `/app/system-behavior-and-maintenance-options`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_system_behavior_and_maintenance_options(
        ctx: &RequestContext,
        payload: SystemBehaviorAndMaintenanceOptionsRequest
    ) -> Result<SystemBehaviorAndMaintenanceOptionsResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 074
### **Inventory Item List**

#### 1. Deep Visual Forensic Analysis
- **Header**: **Items**.
- **Columns**:
  - **Item Name**.
  - **Category**.
  - **Opening Qty**.
  - **Unit Cost**.
- **Action Dashboard**:
  - **Red icon**.
  - **Green icon**.
  - **Circular blue '+' icon**.
- **Status**: **Empty State**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Inventory & Supply Chain
- **Component ID**: `INVENTORY-074`
- **Route / Slug**: `/app/inventory-item-list`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `InventoryService`
- **Method Signature**:
    ```rust
    pub async fn handle_inventory_item_list(
        ctx: &RequestContext,
        payload: InventoryItemListRequest
    ) -> Result<InventoryItemListResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `inventory_items`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (inventory_items_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 075
### **Main Control Dashboard**

#### 1. Deep Visual Forensic Analysis
- **App Name**: **basir.accounting**.
- **Hero Grid (Cards)**:
  - **Collect/Pay**.
  - **Sales**.
  - **Purchases**.
  - **Accounts**.
- **Navigation Accordion**:
  - **Warehouse Ops**.
  - **Entries/Accounts**.
  - **Items**.
  - **Currencies**.
  - **Reports**.
- **Footer**: **Main Warehouse**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Reporting & Analytics
- **Component ID**: `REPORTING-075`
- **Route / Slug**: `/app/main-control-dashboard`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `ReportingService`
- **Method Signature**:
    ```rust
    pub async fn handle_main_control_dashboard(
        ctx: &RequestContext,
        payload: MainControlDashboardRequest
    ) -> Result<MainControlDashboardResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 076
### **Services and Backup Dashboard**

#### 1. Deep Visual Forensic Analysis
- **Side Drawer Header**: **basir.accounting**.
- **Utility List**:
  - **Backups**: Save Backup, Restore, Google Drive sync.
  - **Accounting Core**: **Chart of Accounts**.
  - **System**: Settings, Support, About.
- **Action**: **Exit**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Reporting & Analytics
- **Component ID**: `REPORTING-076`
- **Route / Slug**: `/app/services-and-backup-dashboard`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `ReportingService`
- **Method Signature**:
    ```rust
    pub async fn handle_services_and_backup_dashboard(
        ctx: &RequestContext,
        payload: ServicesAndBackupDashboardRequest
    ) -> Result<ServicesAndBackupDashboardResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 077
### **Chart of Accounts**

#### 1. Deep Visual Forensic Analysis
- **Header**: **Chart of Accounts**.
- **Table Headers**: **Account Name**, **Account Type**, **Count of children**.
- **Root Categories**:
  - **Assets** - Content.
  - **Liabilities/Equity** - Content.
  - **Expenses** - Content.
  - **Revenues** - Content.
- **Action Dashboard**: ADD (+) icon and PDF icon.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Accounting Core
- **Component ID**: `ACCOUNTING-077`
- **Route / Slug**: `/app/chart-of-accounts`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `LedgerService`
- **Method Signature**:
    ```rust
    pub async fn handle_chart_of_accounts(
        ctx: &RequestContext,
        payload: ChartOfAccountsRequest
    ) -> Result<ChartOfAccountsResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `gl_accounts`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (gl_accounts_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 078
### **Fixed and Current Assets Index**

#### 1. Deep Visual Forensic Analysis
- **Hierarchy Level 2 (Assets)**:
  - **Fixed Assets**: 0 children.
  - **Current Assets**: 2 children.
- **Fields**: Parent Account, Account Type, Child Count.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-078`
- **Route / Slug**: `/app/fixed-and-current-assets-index`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_fixed_and_current_assets_index(
        ctx: &RequestContext,
        payload: FixedAndCurrentAssetsIndexRequest
    ) -> Result<FixedAndCurrentAssetsIndexResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 079
### **Current Assets Breakdown**

#### 1. Deep Visual Forensic Analysis
- **Hierarchy Level 3 (Current Assets)**:
  - **Cash Boxes** - 1 child.
  - **Banks** - 0 child.
  - **Customers** - 0 child.
  - **Others** - 0 child.
  - **Inventory** - 1 child.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-079`
- **Route / Slug**: `/app/current-assets-breakdown`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_current_assets_breakdown(
        ctx: &RequestContext,
        payload: CurrentAssetsBreakdownRequest
    ) -> Result<CurrentAssetsBreakdownResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 080
### **Liabilities and Owners Equity Index**

#### 1. Deep Visual Forensic Analysis
- **Hierarchy Level 2 (Liabilities/Equity)**:
  - **Owners Equity** - 2 children.
  - **Current Liabilities** - 1 child.
  - **Fixed Liabilities** - 0 child.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-080`
- **Route / Slug**: `/app/liabilities-and-owners-equity-index`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_liabilities_and_owners_equity_index(
        ctx: &RequestContext,
        payload: LiabilitiesAndOwnersEquityIndexRequest
    ) -> Result<LiabilitiesAndOwnersEquityIndexResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 081
### **Administrative and Operating Expenses Index**

#### 1. Deep Visual Forensic Analysis
- **Hierarchy Level 2 (Expenses)**:
  - **Direct Operating Costs/COGS** - 8 sub-accounts.
  - **SG&A Expenses** - 2 sub-accounts.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Administration
- **Component ID**: `ADMINISTRATION-081`
- **Route / Slug**: `/app/administrative-and-operating-expenses-index`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `AdminService`
- **Method Signature**:
    ```rust
    pub async fn handle_administrative_and_operating_expenses_index(
        ctx: &RequestContext,
        payload: AdministrativeAndOperatingExpensesIndexRequest
    ) -> Result<AdministrativeAndOperatingExpensesIndexResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 082
### **Revenues and Activities Index**

#### 1. Deep Visual Forensic Analysis
- **Hierarchy Level 2 (Revenues)**:
  - **Main Business Revenue/Sales** - 5 sub-accounts.
  - **Other Income** - 1 sub-account.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-082`
- **Route / Slug**: `/app/revenues-and-activities-index`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_revenues_and_activities_index(
        ctx: &RequestContext,
        payload: RevenuesAndActivitiesIndexRequest
    ) -> Result<RevenuesAndActivitiesIndexResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 083
### **Excel Data Import Gateway**

#### 1. Deep Visual Forensic Analysis
- **Header**: **Import from Excel**.
- **Template Instructions**:
  - File must contain 5 columns: **Account Name**, **Phone**, **Address**, **Debit/Credit Balance**, **Balances in Local Currency**.
- **Actions**:
  - **Select file**.
  - **Download Template - Red text**.
  - **Save**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-083`
- **Route / Slug**: `/app/excel-data-import-gateway`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_excel_data_import_gateway(
        ctx: &RequestContext,
        payload: ExcelDataImportGatewayRequest
    ) -> Result<ExcelDataImportGatewayResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 084
### **User Printing and Security Settings**

#### 1. Deep Visual Forensic Analysis
- **Header**: **Settings**.
- **Comprehensive List**:
  - **Personal Data/Profile**.
  - **Printing Options**.
  - **Security: PIN/Biometric**.
  - **Users & Permissions**.
  - **Categories**.
  - **Item Groups**.
  - **Units of Measure**.
  - **Barcode Printer**.
  - **Activate Subscription**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Administration
- **Component ID**: `ADMINISTRATION-084`
- **Route / Slug**: `/app/user-printing-and-security-settings`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `AdminService`
- **Method Signature**:
    ```rust
    pub async fn handle_user_printing_and_security_settings(
        ctx: &RequestContext,
        payload: UserPrintingAndSecuritySettingsRequest
    ) -> Result<UserPrintingAndSecuritySettingsResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_users`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_users_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 085
### **Inventory Operations List**

#### 1. Deep Visual Forensic Analysis
- **Accordion Toggle**: **Warehouse Operations** - _Expanded_.
- **Sub-Items**:
  - **Issues/Outbound**.
  - **Receipts/Inbound**.
  - **Transfers**.
  - **Adjustment/Reconciliation**.
  - **Add New Warehouse**.
  - **Stocktaking**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Inventory & Supply Chain
- **Component ID**: `INVENTORY-085`
- **Route / Slug**: `/app/inventory-operations-list`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `InventoryService`
- **Method Signature**:
    ```rust
    pub async fn handle_inventory_operations_list(
        ctx: &RequestContext,
        payload: InventoryOperationsListRequest
    ) -> Result<InventoryOperationsListResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `inventory_items`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (inventory_items_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 086
### **Account Entries and Ledgers List**

#### 1. Deep Visual Forensic Analysis
- **Accordion Toggle**: **Entries and Accounts** - _Expanded_.
- **Sub-Items**:
  - **Manual Journal Entry**.
  - **Opening Entry for migration**.
  - **Add New Account Shortcut**.
  - **Specific Cashier Ledger**.
  - **Chart of Accounts**.
  - **Year-End Closing**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Accounting Core
- **Component ID**: `ACCOUNTING-086`
- **Route / Slug**: `/app/account-entries-and-ledgers-list`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `LedgerService`
- **Method Signature**:
    ```rust
    pub async fn handle_account_entries_and_ledgers_list(
        ctx: &RequestContext,
        payload: AccountEntriesAndLedgersListRequest
    ) -> Result<AccountEntriesAndLedgersListResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `gl_accounts`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (gl_accounts_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 087
### **Comprehensive Index and Advanced Features**

#### 1. Deep Visual Forensic Analysis
- **Unified Expanded View**:
  - **Items (Items)**: Prices, Units, Quotes, Purchase Requests.
  - **Currencies (Currencies)**: New Currency, Exchange Rates, Credit Limits (Account Credit Limit).
  - **Reports (Reports)**: Trial Balance (Trial Balance), P&L (Income Statement), Balance Sheet (Financial Position).

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-087`
- **Route / Slug**: `/app/comprehensive-index-and-advanced-features`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_comprehensive_index_and_advanced_features(
        ctx: &RequestContext,
        payload: ComprehensiveIndexAndAdvancedFeaturesRequest
    ) -> Result<ComprehensiveIndexAndAdvancedFeaturesResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 088
### **Data Storage and Persistence Paths**

#### 1. Deep Visual Forensic Analysis
- **Settings Sub-section**: **Data Persistence**.
- **Toggles**:
  - **Enable daily auto-save**.
- **Paths**: `/storage/emulated/150/Documents/INV_APP/...`
- **Cloud Reference**: "Google Drive" folder naming.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-088`
- **Route / Slug**: `/app/data-storage-and-persistence-paths`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_data_storage_and_persistence_paths(
        ctx: &RequestContext,
        payload: DataStorageAndPersistencePathsRequest
    ) -> Result<DataStorageAndPersistencePathsResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 089
### **Sales Policies and Financial Controls**

#### 1. Deep Visual Forensic Analysis
- **Settings Sub-section**: **Policy & Calculation**.
- **Critical Toggles**:
  - **Allow negative stock - _Disabled_**.
  - **Allow back-dating - _Disabled_**.
  - **Enable Barcode**.
  - **Auto-update sales price**.
  - **Expiry Date tracking**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Sales & Revenue
- **Component ID**: `SALES-089`
- **Route / Slug**: `/app/sales-policies-and-financial-controls`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `SalesService`
- **Method Signature**:
    ```rust
    pub async fn handle_sales_policies_and_financial_controls(
        ctx: &RequestContext,
        payload: SalesPoliciesAndFinancialControlsRequest
    ) -> Result<SalesPoliciesAndFinancialControlsResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 090
### **Communication and Auto-Messaging Settings**

#### 1. Deep Visual Forensic Analysis
- **Settings Sub-section**: **Communications & Social**.
- **Text Areas**:
  - **Header**.
  - **Footer**.
- **Toggles**:
  - **Send WhatsApp on save**.
  - **Send SMS on save**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Administration
- **Component ID**: `ADMINISTRATION-090`
- **Route / Slug**: `/app/communication-and-auto-messaging-settings`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `AdminService`
- **Method Signature**:
    ```rust
    pub async fn handle_communication_and_auto_messaging_settings(
        ctx: &RequestContext,
        payload: CommunicationAndSettingsRequest
    ) -> Result<CommunicationAndSettingsResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `system_configs`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (system_configs_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 091
### **Units of Measurement Index**

#### 1. Deep Visual Forensic Analysis
- **Header**: **Units of Measure**.
- **Core Units**:
  - **Piece**.
  - **KG**.
  - **Carton**.
  - **Bag**.
- **Table Headers**: **Content Unit**, **ContentNoContent**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-091`
- **Route / Slug**: `/app/units-of-measurement-index`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_units_of_measurement_index(
        ctx: &RequestContext,
        payload: UnitsOfMeasurementIndexRequest
    ) -> Result<UnitsOfMeasurementIndexResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 092
### **Users and Permissions Management**

#### 1. Deep Visual Forensic Analysis
- **Header**: **Users & Permissions**.
- **Active User**: **System Admin / Root**.
- **Metadata**: Associated with **Main Warehouse**.
- **Toolbar**: Edit User (Pencil), Permissions (Wrench), Audit Log (Calendar).

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Administration
- **Component ID**: `ADMINISTRATION-092`
- **Route / Slug**: `/app/users-and-permissions-management`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `AdminService`
- **Method Signature**:
    ```rust
    pub async fn handle_users_and_permissions_management(
        ctx: &RequestContext,
        payload: UsersAndPermissionsManagementRequest
    ) -> Result<UsersAndPermissionsManagementResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_users`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_users_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 093
### **System Admin Permissions Matrix**

#### 1. Deep Visual Forensic Analysis
- **Header**: **Permissions for Admin**.
- **Matrix**: Long vertical list of permissions.
- **Actions**: **Read**, **Add**, **Edit**, **Delete**.
- **Modules Covered**: Accounts, Sales, Purchases, Backups, Warehouse, Items, Reports.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Administration
- **Component ID**: `ADMINISTRATION-093`
- **Route / Slug**: `/app/system-admin-permissions-matrix`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `AdminService`
- **Method Signature**:
    ```rust
    pub async fn handle_system_admin_permissions_matrix(
        ctx: &RequestContext,
        payload: SystemAdminPermissionsMatrixRequest
    ) -> Result<SystemAdminPermissionsMatrixResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_permissions`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_permissions_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 094
### **User Data Edit Interface**

#### 1. Deep Visual Forensic Analysis
- **Modal Header**: **Edit User Data**.
- **Fields**:
  - **Name**: System Admin.
  - **Password**: (Password field).
  - **Cashier/Vault**: Cashier/Vault (Linked Cash Account).
  - **Warehouse**: Main Warehouse (Linked Warehouse).
  - **Enabled**: (Status Toggle).

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Administration
- **Component ID**: `ADMINISTRATION-094`
- **Route / Slug**: `/app/user-data-edit-interface`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `AdminService`
- **Method Signature**:
    ```rust
    pub async fn handle_user_data_edit_interface(
        ctx: &RequestContext,
        payload: UserDataEditInterfaceRequest
    ) -> Result<UserDataEditInterfaceResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_users`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_users_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 095
### **Brand Identity and Logo Settings**

#### 1. Deep Visual Forensic Analysis
- **Header**: **Branding/Identity**.
- **Logo Area**: Square placeholder with the app icon.
- **Identity Fields**: Name, Address, Phone Number.
- **Signatures**: **Change Logo**, **Change Signature**.
- **VAT**: **Tax ID**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Administration
- **Component ID**: `ADMINISTRATION-095`
- **Route / Slug**: `/app/brand-identity-and-logo-settings`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `AdminService`
- **Method Signature**:
    ```rust
    pub async fn handle_brand_identity_and_logo_settings(
        ctx: &RequestContext,
        payload: BrandIdentityAndLogoSettingsRequest
    ) -> Result<BrandIdentityAndLogoSettingsResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `system_configs`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (system_configs_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 096
### **Advanced Invoice Printing Options**

#### 1. Deep Visual Forensic Analysis
- **Header**: **Printing Options**.
- **Toggles**:
  - **Print E-Invoice / QR**.
  - **Ascending order**.
  - **Show Date**.
  - **Hide Doc Column**.
- **Placeholders**: **Debtor/Debit**, **Custom labels for Debtor/Creditor**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Sales & Revenue
- **Component ID**: `SALES-096`
- **Route / Slug**: `/app/advanced-invoice-printing-options`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `SalesService`
- **Method Signature**:
    ```rust
    pub async fn handle_advanced_invoice_printing_options(
        ctx: &RequestContext,
        payload: AdvancedInvoicePrintingOptionsRequest
    ) -> Result<AdvancedInvoicePrintingOptionsResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sales_invoices`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sales_invoices_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 097
### **Tax Configuration**

#### 1. Deep Visual Forensic Analysis
- **Header**: **Taxation**.
- **List**:
  - **None** - 0%. Default: YES.
  - **VAT** - 5%. Default: NO.
- **Table Headers**: **Tax Name**, **Percentage**, **Show**, **Default**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-097`
- **Route / Slug**: `/app/tax-configuration`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_tax_configuration(
        ctx: &RequestContext,
        payload: TaxConfigurationRequest
    ) -> Result<TaxConfigurationResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `tax_configs`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (tax_configs_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 098
### **Barcode Engine Configuration**

#### 1. Deep Visual Forensic Analysis
- **Header**: **Barcode Engine**.
- **Parameters**:
  - **Columns per row**.
  - **Height / Width**.
  - **Total count**.
  - **Margin**.
- **Categories**: Thermal Printer vs A4 Printer layouts.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: Inventory & Supply Chain
- **Component ID**: `INVENTORY-098`
- **Route / Slug**: `/app/barcode-engine-configuration`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `InventoryService`
- **Method Signature**:
    ```rust
    pub async fn handle_barcode_engine_configuration(
        ctx: &RequestContext,
        payload: BarcodeEngineConfigurationRequest
    ) -> Result<BarcodeEngineConfigurationResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_barcodes`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_barcodes_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

## Image 099
### **Annual Subscription Activation Interface**

#### 1. Deep Visual Forensic Analysis
- **Modal Header**: **Activation**.
- **Contact Matrix**: Primary contact numbers for activation support.
- **Device ID**: `33C1A88112932E6A-35773905785243` (Unique Hardware ID).
- **Action**: **Request Annual Subscription**.

#### 2. Engineering Implementation Directives
### 6.1 Module Class & Topological route
- **Module**: General System
- **Component ID**: `GENERAL-099`
- **Route / Slug**: `/app/annual-subscription-activation-interface`
- **Security Scope**: `Authenticated` (Session Required)

### 6.2 Rust Implementation (Backend)
- **Crate**: `accounting_core`
- **Service**: `CoreService`
- **Method Signature**:
    ```rust
    pub async fn handle_annual_subscription_activation_interface(
        ctx: &RequestContext,
        payload: AnnualSubscriptionActivationInterfaceRequest
    ) -> Result<AnnualSubscriptionActivationInterfaceResponse, ServiceError>;
    ```

### 6.3 Database Level (PostgreSQL)
- **Primary Table**: `sys_general_ledger`
- **Integrity**: Enforce `protect_append_only()` trigger where applicable.
- **Isolation**: SERIALIZABLE transaction level required for financial commits.

### 6.4 Key logic & Constraints
- Ensure strict `Decimal` usage for all financial values.
- Validate all UUID references (sys_general_ledger_id) before execution.
- detailed audit logging required for this action.

#### 3. Systemic Context
> This screen is an integral part of the **Basir Unified Architecture**. It adheres to the strict design tokens of the system (Teal/White Palette, Card-based Layout, Transactional Density).

---

