# User Interface (UI) Wireframes & Logic: Basir MVP

These interfaces are designed based on the approved Product Requirements Document (PRD) and Design System, with a primary focus on professional Right-to-Left (RTL) alignment and high-fidelity UX.

## 1. Initial Setup / Login Screen

**Objective**: Secure the local environment with baseline authentication credentials.

| Element            | Specification                                   | Visual Representation                        |
| :----------------- | :---------------------------------------------- | :------------------------------------------- |
| **Background**     | Minimalist white container.                     | Focused and distraction-free.                |
| **Header**         | "Secure Your Local Data" or "Login".            | High-legibility Tajawal Bold typography.     |
| **Username Field** | Standardized Outlined Text Field.               | Leading person icon (Left alignment in RTL). |
| **Password Field** | Secured input with toggle for visibility.       | Leading lock icon.                           |
| **Action Button**  | "Initialize System" or "Access".                | Primary High-Visibility Blue (`#007BFF`).    |
| **Privacy Note**   | "Data is persisted exclusively on this device." | Technical disclaimer for user confidence.    |

## 2. Dashboard Screen

**Objective**: Provide a high-velocity financial summary and actionable insights.

| Element           | Specification                                                      | Visual Representation                             |
| :---------------- | :----------------------------------------------------------------- | :------------------------------------------------ |
| **AppBar**        | "Basir" logo (Right) / Settings (Left).                            | Professional white background.                    |
| **Summary Card**  | Primary container for "Paid Revenue" vs "Pending Receivables".     | High-prominence numerical readout.                |
| **Metric Nodes**  | Dual-column cards for "Customer Count" and "Total Invoices".       | Semantic iconography.                             |
| **Quick Actions** | High-visibility action nodes for "New Invoice" and "Add Customer". | "New Invoice" utilizes Success Green (`#28A745`). |
| **Bottom Nav**    | Active state: Dashboard.                                           | Persistent navigation anchor.                     |

## 3. Invoices List Screen

**Objective**: High-speed navigation, filtering, and searching of ledger records.

| Element           | Specification                                 | Visual Representation                                              |
| :---------------- | :-------------------------------------------- | :----------------------------------------------------------------- |
| **AppBar**        | "Invoices" title with search trigger.         | Minimalist header.                                                 |
| **Filter Chips**  | Horizontal scroll: All, Draft, Overdue, Paid. | Active state: Primary Blue.                                        |
| **Invoice Cards** | Scrollable list of transaction summaries.     | Detail-rich: Customer name, ID, due date, total, and status badge. |
| **Action FAB**    | Floating Action Button for "New Invoice".     | Position: Bottom Left (RTL optimization).                          |

## 4. Invoice Orchestration (Create/Edit)

**Objective**: Precision data entry, itemization, and totalization logic.

| Element               | Specification                                               | Visual Representation                    |
| :-------------------- | :---------------------------------------------------------- | :--------------------------------------- |
| **AppBar**            | "Generate New Invoice" with persistent Save node.           | Operational header.                      |
| **Header Data**       | Customer selection (Dropdown), Issue Date, Due Date.        | Standardized spacing and alignment.      |
| **Line Items**        | Dynamic list for multi-line itemization.                    | Name, Quantity, and Unit Price fields.   |
| **Financial Summary** | Sticky footer: Subtotal, VAT (Adjustable), and Grand Total. | High-prominence totalization.            |
| **Action Suite**      | "Save Draft" vs "Finalize & Issue".                         | Balanced primary/secondary action nodes. |

## 5. Customer Management Screen

**Objective**: Lifecycle management of customer relationships and contact indices.

| Element          | Specification                              | Visual Representation                |
| :--------------- | :----------------------------------------- | :----------------------------------- |
| **AppBar**       | "Customer Index" with search capability.   | Clean header.                        |
| **Contact List** | Scrollable index of customer profiles.     | Primary data: Name and Phone Number. |
| **Action FAB**   | Floating Action Button for "New Customer". | Primary Blue.                        |

## 6. System Settings Screen

**Objective**: Management of operational parameters and security settings.

| Element             | Specification                               | Visual Representation                    |
| :------------------ | :------------------------------------------ | :--------------------------------------- |
| **Business Config** | Company Info, Default VAT settings.         | Standard ListTiles with semantic icons.  |
| **Security**        | "Reset Local Password" workflow.            | Leading Lock icon.                       |
| **About**           | System versioning and technical build info. | Informational footer.                    |
| **Termination**     | "Secure Logout" (Returns to Auth layer).    | Crimson (`#DC3545`) for critical action. |

---

**Prepared by:** Basir Project Agentic Development Team  
**Last Updated:** December 10, 2025  
**Status:** ✅ English-First Documentation Standardized
