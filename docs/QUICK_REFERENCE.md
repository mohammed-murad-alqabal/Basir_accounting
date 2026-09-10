# Quick Reference for Basir Developers

## Essential Commands

```bash
# Quality Checks
flutter analyze                    # Static analysis
dart format lib/                    # Format code
flutter test                        # Run tests
./scripts/check_spec_compliance.sh # Full compliance check

# Git Hooks (auto-activated)
git config core.hooksPath .githooks # Activate hooks

# Build
flutter build apk --debug           # Debug APK
flutter build ios                   # iOS build
```

---

## Mandatory Standards

| Rule | Location |
|------|----------|
| Flutter/Dart | `docs/standards/flutter.md` |
| Naming | `docs/standards/naming.md` |
| Architecture | `docs/guides/steering/architecture-mapping.md` |
| Accounting | `docs/standards/accounting.md` |

---

## Line Length: 80 Characters

```dart
// ✓ Correct
final String customerName = 
    customers.firstWhere((c) => c.id == id).name;

// ✗ Wrong
final String customerName = customers.firstWhere((c) => c.id == id).name;
```

---

## Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Files | snake_case | `customer_list_screen.dart` |
| Classes | PascalCase | `CustomerListScreen` |
| Variables | camelCase | `customerName` |
| Constants | kConstantName | `kDefaultTimeout` |
| Private | _prefix | `_customerRepository` |

---

## Feature Structure

```
lib/features/<feature_name>/
├── domain/
│   └── entities/
├── presentation/
│   ├── providers/
│   ├── screens/
│   └── widgets/
└── data/
    └── repositories/
```

---

## Commit Message Format

```
type(scope): description

Types: feat, fix, docs, style, refactor, test, chore

Examples:
feat(invoicing): add ZATCA Phase 2 compliance
fix(customers): resolve search pagination issue
docs(api): update endpoint documentation
```

---

## Team Identity

> **Author:** Basir Accounting System Development Agents Team

**Forbidden:**
- "Kiro AI Agent"
- "AI Assistant"
- "MVP" (use "accounting system")

---

## Pre-Commit Checklist

- [ ] `flutter analyze` = 0 errors
- [ ] Code formatted (80 chars line)
- [ ] No hardcoded secrets
- [ ] Commit message follows Conventional Commits
- [ ] CHANGELOG.md updated (if needed)

---

## Key Files to Read

1. `docs/guides/steering/product.md` - Vision
2. `docs/guides/steering/tech.md` - Tech stack
3. `docs/guides/steering/philosophy.md` - PPP principles
4. `docs/standards/flutter.md` - Flutter rules
