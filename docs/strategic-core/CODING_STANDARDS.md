# Coding Standards: Basir Accounting System MVP

**Date:** November 17, 2025  
**Author:** Basir Project Agentic Development Team  
**Objective**: Ensure the highest standards of code quality, readability, maintainability, and visual consistency across the source codebase.

---

## 1. Design System Alignment

Our design system prioritizes professional technical clarity, visual ergonomics, and high-fidelity functional focus.

### 1.1. Core Color Palette

Values are selected to ensure high contrast and psychological alignment with financial reliability.

| Token              | Hex Value | Strategic Utiltization                       |
| :----------------- | :-------- | :------------------------------------------- |
| **Primary**        | `#007BFF` | Blue: Represents trust, technical authority. |
| **Secondary**      | `#28A745` | Green: Represents success and completion.    |
| **Background**     | `#F8F9FA` | Light Gray: Maximizes content prominence.    |
| **Surface**        | `#FFFFFF` | White: Used for card and form containers.    |
| **Error**          | `#DC3545` | Red: Represents failure and critical alerts. |
| **Text Primary**   | `#212529` | Rich Black: Primary data and headers.        |
| **Text Secondary** | `#6C757D` | Medium Gray: Secondary metadata.             |

### 1.2. Typography and Layout

- **Arabic Font**: **Tajawal** or **Cairo** (Ensuring modern, high-legibility script).
- **English Font**: **Roboto** (Material Design standard).
- **Alignment**: Full **Right-to-Left (RTL)** support is mandatory for all interfaces.

---

## 2. Engineering Standards

These standards govern the implementations within the `Presentation` and `Core` layers, following Flutter and Clean Architecture best practices.

### 2.1. State Management (Riverpod)

- **Orchestrator**: **Riverpod** is the exclusive state management engine.
- **Data Access**: All UI consumption of data must occurs via Riverpod Providers.
- **Logic Separation**: Business logic must be strictly decoupled from UI code utilizing `StateNotifierProvider` or `NotifierProvider`.

### 2.2. Interface (UI) Architecture

- **Widget Decomposition**: Complex screens must be decomposed into atomic, reusable sub-widgets.
- **Constraint**: A single `build` method should not exceed **50 lines** of layout code.
- **Naming Conventions**:
  - **Files**: `snake_case` (e.g., `invoice_card.dart`).
  - **Classes**: `PascalCase` (e.g., `InvoiceCard`).
- **Widget Selection**: Use `StatelessWidget` by default. Use `ConsumerWidget` or `ConsumerStatefulWidget` only when Riverpod interaction is required.

### 2.3. Constants and Geometry

- **Centralization**: All colors, static strings, and dimensional tokens (Padding/Margin) must reside in `core/constants.dart`.
- **Layout**: Use `SizedBox` for explicit spacing; avoid empty `Padding` or `Container` wrappers for geometry control.

### 2.4. Source Documentation

- **Obligation**: All public classes, methods, and providers must feature triple-slash (`///`) DartDoc documentation.
- **Clarity**: Comments should explain the **rationale (why)** rather than the **implementation (what)**.

---

## 3. Implementation Workflow

1.  **Theme Synthesis**: Maintain `theme.dart` within the `core` directory to centralize typography and palette logic.
2.  **Interface Refinement**: Audit all MVP screens (Setup, Login, Dashboard, Customers, Invoices, Settings) against these standards.
3.  **Governance**: Enforce zero-lint tolerance during the development lifecycle.

---

**Prepared by:** Basir Project Agentic Development Team  
**Status:** ✅ Active Technical Baseline
