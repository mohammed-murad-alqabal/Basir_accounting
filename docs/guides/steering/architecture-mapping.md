# Architectural Mapping: Basir Accounting System

This document maps the **Kiro Advanced Agentic Framework** concepts to the physical structure of the **Basir Intelligent Accounting System** codebase.

## 1. Structural Overview

The project follows a **Feature-First Clean Architecture** approach, ensuring separation of concerns and maintainability.

| Kiro Layer             | Philosophy                | Physical Location              |
| ---------------------- | ------------------------- | ------------------------------ |
| **L1: Context**        | Project Rules & Standards | `.kiro/steering/`              |
| **L2: Decision**       | Business Logic & Domain   | `lib/features/*/domain/`       |
| **L3: Execution**      | UI & Presentation Layer   | `lib/features/*/presentation/` |
| **L4: Infrastructure** | Data & External Services  | `lib/core/` / `lib/services/`  |

---

## 2. Layer Deep-Dive

### L2: Decision Layer (Domain)

- **Entities**: Found in `lib/features/[feature]/domain/entities/`. These are the pure business objects (e.g., `Customer`, `Invoice`).
- **Use Cases**: Encapsulated in Riverpod providers located in `lib/features/[feature]/presentation/providers/` (acting as a simplified bridge for MVP logic).

### L3: Execution Layer (Presentation)

- **Screens**: Located in `lib/features/[feature]/presentation/screens/`.
- **Widgets**: Feature-specific widgets in `lib/features/[feature]/presentation/widgets/`. Global widgets in `lib/core/widgets/`.
- **Controllers**: Riverpod `Notifiers` manage the state flow between domain and UI.

### L4: Infrastructure (Core)

- **Database (Isar)**: Managed via `lib/core/services/isar_service.dart`.
- **Theme (Tokens)**: Found in `lib/core/theme/tokens/`. Includes colors, typography, and spacing.
- **Localization (i18n)**: ARB files in `lib/l10n/` with 100% Arabic/English parity.

---

## 3. Communication Patterns

- **State Management**: Using `flutter_riverpod` for reactive execution.
- **Navigation**: Using a central `AppRouter` in `lib/core/router.dart`.
- **Dependency Injection**: Handled automatically by Riverpod providers.

---

## 4. Brand Purity Standards

- **Project Identity**: All references strictly use "Basir Accounting System".
- **Team Identity**: "Basir Accounting System Development Agents Team".
- **Line Length**: Strictly enforced 80-character limit for all steering documentation.
