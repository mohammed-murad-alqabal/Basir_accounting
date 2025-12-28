# Baseer MVP - Technology Stack

**Last Updated:** 2025-12-26

---

## 🛠️ Core Technologies

| Category             | Technology     | Version | Usage                     |
| -------------------- | -------------- | ------- | ------------------------- |
| **Framework**        | **Flutter**    | 3.35.5+ | UI & Application Logic    |
| **Language**         | **Dart**       | 3.9.2+  | Core Language             |
| **State Management** | **Riverpod**   | 2.0+    | App State (AsyncNotifier) |
| **Database**         | **Isar**       | Latest  | Local Persistence         |
| **UI System**        | **Material 3** | Latest  | Design System             |

## 🏗️ Architecture

- **Clean Architecture:** 3 Layers (Presentation, Domain, Data).
- **MVVM Pattern:** Strict separation of UI and Logic.
- **Feature-First:** Modular folder structure `lib/features/<feature_name>`.

## 📝 Coding Standards (Summary)

> **Detailed Reference:** `Documentation/guides/kiro_reference/flutter-dart-standards.md`

- **Line Length:** 100 characters.
- **Linter:** `effective_dart` + project rules.
- **Null Safety:** Strict Sound Null Safety.
- **Comments:** Doc comments `///` for public APIs. English only.

### ⚡ Performance Rules

- **Const:** PREFER `const` constructors.
- **Lists:** USE `ListView.builder` for long lists.
- **Images:** CACHE images; use optimized assets.
- **Builds:** Minimize widget rebuilds; use `ConsumerWidget` wisely.

### 🌲 Git Standards

- **Branches:**
  - `feat/description`: New features
  - `fix/description`: Bug fixes
  - `docs/description`: Documentation
- **Commits:** Conventional Commits (`feat:`, `fix:`, `chore:`, `docs:`).

---

**Core Guides:**

- [Flutter Standards](../../Documentation/guides/kiro_reference/flutter-dart-standards.md)
- [Git Standards](../../Documentation/guides/kiro_reference/git-standards.md)
