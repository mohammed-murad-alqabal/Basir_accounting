# Code Templates

**Project:** Basser MVP  
**Date:** December 8, 2025  
**Status:** ✅ Active

---

## Available Templates

### 1. repository_template.dart

Repository pattern with Isar database integration.

**Usage:**

```bash
cp repository_template.dart lib/features/[feature]/data/repositories/[entity]_repository.dart
# Replace [Entity] and [entity] with your entity name
```

### 2. model_template.dart

Isar model with entity conversion.

**Usage:**

```bash
cp model_template.dart lib/features/[feature]/data/models/[entity]_model.dart
# Replace [Entity] and [entity] with your entity name
```

### 3. widget_template.dart

Reusable widget components (stateless and stateful).

**Usage:**

```bash
cp widget_template.dart lib/features/[feature]/presentation/widgets/[widget]_widget.dart
# Replace [Widget] with your widget name
```

### 4. provider_template.dart

Riverpod state management providers.

**Usage:**

```bash
cp provider_template.dart lib/features/[feature]/presentation/providers/[entity]_provider.dart
# Replace [Entity] and [entity] with your entity name
```

### 5. service_template.dart

Business logic service layer.

**Usage:**

```bash
cp service_template.dart lib/core/services/[service]_service.dart
# Replace [Service] with your service name
```

### 6. test_template.dart

Unit test template with setup/teardown.

**Usage:**

```bash
cp test_template.dart test/unit/[entity]_repository_test.dart
# Replace [Entity] and [entity] with your entity name
```

### 7. integration_test_template.dart

Integration test for user journeys.

**Usage:**

```bash
cp integration_test_template.dart integration_test/[feature]_test.dart
# Replace [Feature] with your feature name
```

---

## Quick Start

1. Copy the template you need
2. Replace placeholders: `[Entity]`, `[Widget]`, `[Service]`, etc.
3. Implement the logic
4. Run code generation if needed: `flutter pub run build_runner build`
5. Write tests

---

## Naming Conventions

- **Files**: snake_case (e.g., `customer_repository.dart`)
- **Classes**: PascalCase (e.g., `CustomerRepository`)
- **Functions**: camelCase (e.g., `getAllCustomers()`)
- **Variables**: camelCase (e.g., `customerList`)

---

**Prepared by:** Basser Project Development Agents Team
