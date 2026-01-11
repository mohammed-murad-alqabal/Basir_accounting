---
inclusion: always
---

# basir_accounting_system - Technology Stack & Development Standards

**Last Updated:** 2025-01-11

## 🛠️ Core Technology Stack

| Category             | Technology     | Version | Usage                     |
| -------------------- | -------------- | ------- | ------------------------- |
| **Framework**        | **Flutter**    | 3.35.5+ | UI & Application Logic    |
| **Language**         | **Dart**       | 3.9.2+  | Core Language             |
| **State Management** | **Riverpod**   | 2.0+    | App State (AsyncNotifier) |
| **Database**         | **Isar**       | Latest  | Local Persistence         |
| **UI System**        | **Material 3** | Latest  | Design System             |

## 🏗️ Architecture Patterns

### Clean Architecture (Mandatory)

- **Presentation Layer:** `lib/features/*/presentation/` (UI, Widgets, Providers)
- **Domain Layer:** `lib/features/*/domain/` (Entities, Use Cases)
- **Data Layer:** `lib/core/services/` (Repositories, Data Sources)

### State Management Rules

- **ALWAYS** use `ConsumerWidget` or `Consumer` for Riverpod
- **PREFER** `AsyncNotifier` for complex state management
- **AVOID** `StatefulWidget` unless absolutely necessary
- **USE** `ref.watch()` in build methods, `ref.read()` in callbacks

### File Organization

```
lib/features/<feature_name>/
├── domain/
│   ├── entities/
│   └── repositories/
├── presentation/
│   ├── providers/
│   ├── screens/
│   └── widgets/
└── data/
    └── repositories/
```

## 📝 Coding Standards (Enforced)

### Code Quality Rules

- **Line Length:** 80 characters (strict)
- **Linter:** `effective_dart` + custom rules in `analysis_options.yaml`
- **Null Safety:** Sound null safety required
- **Comments:** Use `///` for public APIs, `//` for implementation details
- **Language:** All comments and documentation in English

### Naming Conventions

- **Files:** `snake_case.dart`
- **Classes:** `PascalCase`
- **Variables/Functions:** `camelCase`
- **Constants:** `kConstantName` or `SCREAMING_SNAKE_CASE`
- **Private members:** Prefix with `_`

### Widget Development

- **ALWAYS** use `const` constructors when possible
- **PREFER** `ListView.builder` for dynamic lists
- **USE** `Key` parameters for stateful widgets
- **AVOID** deep widget nesting (max 4-5 levels)
- **EXTRACT** complex widgets into separate classes

## ⚡ Performance Requirements

### Memory Management

- **CACHE** images using `CachedNetworkImage`
- **DISPOSE** controllers and streams properly
- **USE** `AutoDisposeAsyncNotifier` for temporary state

### Build Optimization

- **MINIMIZE** widget rebuilds with proper `Consumer` placement
- **USE** `select` modifier for specific state slices
- **AVOID** creating widgets in build methods
- **PREFER** `const` widgets in lists

### Database Operations

- **USE** Isar queries efficiently with proper indexing
- **BATCH** write operations when possible
- **IMPLEMENT** proper error handling for all DB operations

## 🌲 Git Workflow Standards

### Branch Naming

- `feat/feature-description`: New features
- `fix/bug-description`: Bug fixes
- `refactor/component-name`: Code refactoring
- `docs/section-name`: Documentation updates
- `chore/task-description`: Maintenance tasks

### Commit Messages (Conventional Commits)

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

### Code Review Requirements

- **RUN** `flutter analyze` before commits
- **ENSURE** all tests pass
- **VERIFY** no breaking changes
- **CHECK** performance impact

## 🔧 Development Tools

### Required Commands

- `flutter analyze` - Static analysis (must pass)
- `flutter test` - Unit tests
- `flutter build apk --debug` - Build verification

### IDE Configuration

- **Line Length:** 80 characters
- **Format on Save:** Enabled
- **Auto Import:** Enabled
- **Linting:** All rules enabled

## 🚫 Prohibited Practices

- **NO** `setState()` in new code (use Riverpod)
- **NO** hardcoded strings (use localization)
- **NO** magic numbers (use named constants)
- **NO** deep inheritance hierarchies
- **NO** global variables or singletons (use providers)
- **NO** `print()` statements (use proper logging)

## 📱 Platform-Specific Guidelines

### Android

- Target SDK 34+
- Material 3 design compliance
- Proper back button handling

### iOS

- iOS 12+ support
- Human Interface Guidelines compliance
- Proper navigation patterns

---

**Reference Documentation:**

- [Flutter Standards](../../docs/guides/kiro_reference/flutter-dart-standards.md)
- [Git Standards](../../docs/guides/kiro_reference/git-standards.md)
- [Architecture Guide](../../docs/Core/ARCHITECTURE.md)
