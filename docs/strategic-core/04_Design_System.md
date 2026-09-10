# Design System: Basir Accounting System (Initial Version)

## 1. Design Philosophy

The design of the Basir Accounting System is anchored in three primary pillars: **Trust, Clarity, and Simplicity**. The objective is to provide the user with a sense of high-fidelity professionalism and security while managing their sensitive financial data.

- **Trust**: Established through a palette of reliable, calm tones (Deep Blue and Emerald Green) and a clean, minimalist interface.
- **Clarity**: Achieved via high-legibility Arabic typography, balanced whitespace distribution, and intuitive visual data categorization.
- **Simplicity**: Implemented by minimizing the operational friction in core tasks (e.g., invoice generation) and maintaining a strict focus on primary functionality.

## 2. Visual Identity

### 2.1. Color Palette

| Name               | Hex Code                     | Utilization Logic                                                                                                            |
| :----------------- | :--------------------------- | :--------------------------------------------------------------------------------------------------------------------------- |
| **Primary**        | `#007BFF` (Deep Blue)        | Primary action buttons, active navigation nodes, and page headers. Represents reliability and technical authority.           |
| **Secondary**      | `#28A745` (Success Green)    | Success indicators, paid invoice states, and primary CTA (Call to Action) nodes. Represents financial growth and completion. |
| **Background**     | `#F8F9FA` (Ultra-Light Gray) | Global background to reduce visual fatigue and maximize content prominence.                                                  |
| **Text Primary**   | `#212529` (Rich Black)       | Primary body text, headings, and high-priority information.                                                                  |
| **Text Secondary** | `#6C757D` (Medium Gray)      | Auxiliary text, timestamps, and inactive invoice states.                                                                     |
| **Danger/Error**   | `#DC3545` (Crimson)          | Overdue invoice indicators, destructive actions, and error messages.                                                         |

### 2.2. Typography

We utilize high-fidelity, open-source typefaces optimized for mobile readability in both Arabic and English script.

- **Arabic Typography**: **"Tajawal"** is utilized for its modern aesthetic, balanced metrics, and extensive weight support, ensuring superior legibility across all viewport sizes.
- **English Typography**: **"Roboto"** (the Material Design standard) is utilized to ensure platform consistency and professional alignment with OS-level typography.

### 2.3. Iconography

The system leverages the **Material Icons (Outlined)** library. The outlined style is selected to maintain a clean, modern, and light visual footprint.

## 3. Core Design Components

| Component                 | Engineering Description                                                                           | Visual Logic                                                                                                      |
| :------------------------ | :------------------------------------------------------------------------------------------------ | :---------------------------------------------------------------------------------------------------------------- |
| **Primary Button**        | Background: `#007BFF`, Foreground: White, Border Radius: 8dp.                                     | Signals the most critical intended action on the screen.                                                          |
| **Text Fields**           | Standardized **Outlined** style with white fill and 8dp radius. Full RTL (Right-to-Left) support. | Optimized for high-speed alphanumeric entry and sustained data input.                                             |
| **Cards**                 | Elevation: 2dp, Background: White, Radius: 12dp. Used for logical semantic grouping.              | Primary container for invoice summaries, customer details, and dashboard nodes.                                   |
| **Bottom Navigation Bar** | Minimalist style with vertical icon-text labeling.                                                | Provides persistent access to the four primary operational modules: Dashboard, Invoices, Customers, and Settings. |

---

**Prepared by:** Basir Project Agentic Development Team  
**Status:** ✅ Active and Standardized (English-First)
