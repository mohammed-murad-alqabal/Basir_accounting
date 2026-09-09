# Forensic Atlas: Screen Index & Feature Mapping

**Version:** 2.1 (Legacy Input / Governed Register Transition)
**Basis:** Deep Analysis of Legacy Visuals (001-099)
**Scope:** Historical screen-by-screen feature extraction; the authoritative implementation state is in [`ATLAS_FEATURE_REGISTER.md`](../../../docs/02-domain/ATLAS_FEATURE_REGISTER.md).
**Authority notice:** The status cells below are legacy claims, not evidence of current feature completion. Do not promote them to product status without code, test, and SHA-linked CI evidence.

---

## Overview

This atlas preserves the legacy visual input for the declared `001–099` scope. It is **not** a complete or definitive implementation map: a BKIP reconciliation found 95 source rows, 91 unique IDs, four duplicate IDs, and eight missing IDs. [`ATLAS_FEATURE_REGISTER.md`](../../../docs/02-domain/ATLAS_FEATURE_REGISTER.md) assigns every identifier a stable `FR-ATLAS-*` record and controls evidence status for modernization work.

---

## Module 1: Dashboard & Navigation (001, 053, 075, 087)

| Screen  | Name                | Features                             | Status      |
| ------- | ------------------- | ------------------------------------ | ----------- |
| **001** | Main Dashboard      | Quick actions, KPIs, navigation grid | ✅ Complete |
| **053** | System Drawer       | Global menu, user context            | ✅ Complete |
| **075** | Control Dashboard   | Admin overview, system health        | ✅ Complete |
| **087** | Comprehensive Index | Feature discovery, advanced menu     | ✅ Complete |

---

## Module 2: Sales & Invoicing (002-006, 015)

| Screen  | Name             | Features                           | Status      |
| ------- | ---------------- | ---------------------------------- | ----------- |
| **002** | Invoice Settings | Customer, payment type, tax toggle | ✅ Complete |
| **003** | Sales Invoice    | Line items, barcode, totals        | ✅ Complete |
| **004** | Item Picker      | Category grid, item cards          | ✅ Complete |
| **005** | Invoice List     | Filter, sort, export               | ✅ Complete |
| **006** | Invoice Editing  | Modify line items, recalculate     | ✅ Complete |
| **015** | Quotes/Drafts    | Draft workflow, conversion         | ✅ Complete |

---

## Module 3: Reporting & Analytics (007, 016-019, 026, 054-057, 065)

| Screen  | Name                    | Features                    | Status                |
| ------- | ----------------------- | --------------------------- | --------------------- |
| **007** | Report Field Selection  | Custom column picker        | ✅ Complete           |
| **016** | Daily Sales Summary     | Totals, breakdown           | ✅ Complete           |
| **017** | Category Reports        | Drill-down by category      | ✅ Complete           |
| **018** | Customer Reports        | A/R aging, history          | ✅ Complete           |
| **019** | Account Movement Filter | Date range, account filter  | ✅ Complete           |
| **026** | Reports Dashboard       | Report hub                  | ✅ Complete           |
| **054** | Profit Report           | Income Statement / P&L      | ✅ Complete (IFRS 18) |
| **055** | Daily Movement          | Transaction log             | ✅ Complete           |
| **057** | Balance Sheet           | Assets, Liabilities, Equity | ✅ Complete (IFRS 18) |
| **065** | Cashier Movement        | Shift report                | ✅ Complete           |

---

## Module 4: Inventory Management (009, 020, 023-024, 047-050, 074, 085, 091, 098)

| Screen  | Name                  | Features               | Status      |
| ------- | --------------------- | ---------------------- | ----------- |
| **009** | Item Index            | Master list, search    | ✅ Complete |
| **020** | Item Search Options   | Advanced filters       | ✅ Complete |
| **023** | Inventory Adjustments | Stock corrections      | ✅ Complete |
| **024** | Barcode Engine        | Label generation       | ✅ Complete |
| **047** | Item Index Mgmt       | CRUD operations        | ✅ Complete |
| **048** | Index Registration    | New item creation      | ✅ Complete |
| **049** | UOM Search            | Unit of measure picker | ✅ Complete |
| **050** | Costing Method        | FIFO / Avg selection   | ⚠️ Planned  |
| **074** | Inventory List        | Real-time stock levels | ✅ Complete |
| **085** | Inventory Operations  | Bulk actions           | ✅ Complete |
| **091** | UOM Index             | Manage units           | ✅ Complete |
| **098** | Barcode Config        | Scanner settings       | ✅ Complete |

---

## Module 5: Accounting Core (058-070, 077-082, 086)

| Screen  | Name                    | Features                    | Status      |
| ------- | ----------------------- | --------------------------- | ----------- |
| **058** | Debt Registration       | New receivable/payable      | ✅ Complete |
| **059** | Cash Receipt Voucher    | Receive payment             | ✅ Complete |
| **060** | Cash Payment Voucher    | Issue payment               | ✅ Complete |
| **061** | Debt List               | A/R & A/P dashboard         | ✅ Complete |
| **062** | Currency Movement       | Multi-currency transactions | ✅ Complete |
| **063** | Journal Entry History   | GL transaction log          | ✅ Complete |
| **064** | Account Statement Query | Ledger filter               | ✅ Complete |
| **066** | Expenses Dashboard      | Expense tracking            | ✅ Complete |
| **067** | Journal Search          | Find entries                | ✅ Complete |
| **068** | Opening Balances        | Initial setup               | ✅ Complete |
| **069** | Cash Reconciliation     | Physical vs. book           | ✅ Complete |
| **070** | Reconciliation Audit    | Variance report             | ✅ Complete |
| **077** | Chart of Accounts       | CoA tree                    | ✅ Complete |
| **078** | Fixed Assets Index      | Asset accounts              | ✅ Complete |
| **079** | Current Assets          | Cash, Receivables           | ✅ Complete |
| **080** | Liabilities & Equity    | Payables, Capital           | ✅ Complete |
| **081** | Expenses Index          | Operating costs             | ✅ Complete |
| **082** | Revenue Index           | Sales, Income               | ✅ Complete |
| **086** | Account Entries List    | Ledger drill-down           | ✅ Complete |

---

## Module 6: Currency & Pricing (008, 021, 035, 045-046, 071)

| Screen  | Name                | Features                  | Status      |
| ------- | ------------------- | ------------------------- | ----------- |
| **008** | Currency Selection  | Pick transaction currency | ✅ Complete |
| **021** | Pricing Method      | Margin, markup rules      | ✅ Complete |
| **035** | Pricing Strategy    | Complex pricing           | ✅ Complete |
| **045** | Currency Search     | Find currencies           | ✅ Complete |
| **046** | Currency Info       | Rate details              | ✅ Complete |
| **071** | Exchange Rate Entry | Set rates                 | ✅ Complete |

---

## Module 7: Administration & Settings (027-043, 088-095, 099)

| Screen  | Name                    | Features              | Status      |
| ------- | ----------------------- | --------------------- | ----------- |
| **027** | Backup Settings         | Local backup config   | ✅ Complete |
| **028** | System Info             | Version, device info  | ✅ Complete |
| **029** | Manager PIN             | Security PIN setup    | ✅ Complete |
| **030** | User Selection          | Switch user           | ✅ Complete |
| **031** | Calculator              | Built-in calc         | ✅ Complete |
| **032** | Database Selection      | Choose DB file        | ✅ Complete |
| **033** | Cloud Backup            | Google Drive sync     | ⚠️ Planned  |
| **034** | Tax Settings            | VAT, E-Invoice config | ✅ Complete |
| **037** | Company Data            | Branding setup        | ✅ Complete |
| **038** | Language Selection      | AR/EN switch          | ✅ Complete |
| **039** | Invoice Labels          | Customize terminology | ✅ Complete |
| **040** | Document Type Edit      | Template selection    | ✅ Complete |
| **041** | Print Templates         | Template picker       | ✅ Complete |
| **042** | Template Preview        | WYSIWYG preview       | ✅ Complete |
| **043** | Paper Size              | Printer settings      | ✅ Complete |
| **088** | Data Paths              | Storage locations     | ✅ Complete |
| **089** | Sales Policies          | Business rules        | ✅ Complete |
| **090** | Auto-Messaging          | SMS/Email triggers    | ⚠️ Planned  |
| **092** | User Management         | User CRUD             | ✅ Complete |
| **093** | Permissions Matrix      | RBAC config           | ✅ Complete |
| **094** | User Edit               | Profile update        | ✅ Complete |
| **095** | Brand Identity          | Logo, colors          | ✅ Complete |
| **099** | Subscription Activation | License key entry     | ✅ Complete |

---

## Module 8: Printing & Output (041-044, 096)

| Screen  | Name                  | Features            | Status      |
| ------- | --------------------- | ------------------- | ----------- |
| **041** | Print Template Select | Choose template     | ✅ Complete |
| **042** | Template Preview      | Preview output      | ✅ Complete |
| **043** | Paper Size            | Page dimensions     | ✅ Complete |
| **044** | Print Options         | Layout, copies      | ✅ Complete |
| **096** | Advanced Print        | ZATCA QR, signature | ✅ Complete |

---

## Module 9: Compliance & Tax (034, 097)

| Screen  | Name                     | Features                 | Status      |
| ------- | ------------------------ | ------------------------ | ----------- |
| **034** | Tax & E-Invoice Settings | VAT toggle, ZATCA config | ✅ Complete |
| **097** | Tax Configuration        | Rate setup, account link | ✅ Complete |

---

## Module 10: System States & Dialogs (010-014, 056, 072-073)

| Screen  | Name                 | Features             | Status      |
| ------- | -------------------- | -------------------- | ----------- |
| **010** | Returns & Damages    | RMA module           | ✅ Complete |
| **011** | Invoice Search       | Find invoices        | ✅ Complete |
| **012** | Processing State     | Loading indicator    | ✅ Complete |
| **013** | Selection Error      | Validation message   | ✅ Complete |
| **014** | Sort Options         | List ordering        | ✅ Complete |
| **056** | Daily Movement State | Processing animation | ✅ Complete |
| **072** | Financial Ops List   | Quick actions        | ✅ Complete |
| **073** | System Behavior      | Maintenance options  | ✅ Complete |

---

## Legacy Claim Summary

| Legacy status cell | Atlas self-declared count | Governing interpretation |
| --- | ---: | --- |
| `✅ Complete` including IFRS-qualified cells | 92 source rows | Historical claim only; no status is promoted to `COMPLETE` by this document. |
| `⚠️ Planned` | 3 source rows | Historical planning signal only; requires Product Owner confirmation. |
| Missing / duplicate source ID | 12 reconciliation conditions across eight missing and four duplicate IDs | Explicitly tracked in the feature register; never inferred or deleted automatically. |

> **Migration rule:** New work must cite `FR-ATLAS-*` and update the authoritative [Atlas feature register](../../../docs/02-domain/ATLAS_FEATURE_REGISTER.md), including code, test, and SHA-linked CI evidence. This document remains a preserved legacy input and must not be used to claim feature completion on its own.
