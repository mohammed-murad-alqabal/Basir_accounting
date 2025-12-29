# Coding Standards & Guidelines: Baseer Intelligent Financial System

**Document ID:** BASEER-P5-002  
**Version:** 1.0  
**Date:** December 27, 2025  
**Status:** ✅ Approved  
**Classification:** SDLC & Delivery

---

## 1. General Principles

| Principle             | Description                      |
| --------------------- | -------------------------------- |
| **Readability First** | Code is read more than written   |
| **Consistency**       | Follow established patterns      |
| **Simplicity**        | Prefer simple over clever        |
| **Documentation**     | Self-documenting code + comments |
| **Testability**       | Design for testing               |

---

## 2. Flutter/Dart Standards

### Naming Conventions

| Element    | Convention                 | Example              |
| ---------- | -------------------------- | -------------------- |
| Classes    | UpperCamelCase             | `InvoiceService`     |
| Extensions | UpperCamelCase             | `StringExtension`    |
| Libraries  | lowercase_with_underscores | `invoice_utils.dart` |
| Variables  | lowerCamelCase             | `invoiceTotal`       |
| Constants  | lowerCamelCase             | `defaultTaxRate`     |
| Private    | \_prefix                   | `_calculateTax`      |
| Parameters | lowerCamelCase             | `customerId`         |

### File Organization

```dart
// 1. Imports (sorted)
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

import '../core/extensions.dart';
import 'invoice_model.dart';

// 2. Part directives (if any)
part 'invoice_state.dart';

// 3. Constants
const double kDefaultTaxRate = 0.15;

// 4. Class definition
class InvoiceService {
  // ...
}
```

### Widget Guidelines

````dart
/// A widget that displays invoice summary.
///
/// Example:
/// ```dart
/// InvoiceSummaryCard(invoice: myInvoice)
/// ```
class InvoiceSummaryCard extends ConsumerWidget {
  const InvoiceSummaryCard({
    super.key,
    required this.invoice,
    this.onTap,
  });

  /// The invoice to display.
  final Invoice invoice;

  /// Called when the card is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    // Implementation
  }
}
````

### State Management (Riverpod)

```dart
// Provider definition
final invoicesProvider = AsyncNotifierProvider<InvoicesNotifier, List<Invoice>>(
  InvoicesNotifier.new,
);

// Notifier implementation
class InvoicesNotifier extends AsyncNotifier<List<Invoice>> {
  @override
  Future<List<Invoice>> build() async {
    return _loadInvoices();
  }

  Future<void> addInvoice(Invoice invoice) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.create(invoice);
      return _loadInvoices();
    });
  }
}
```

---

## 3. Go Backend Standards

### Naming Conventions

| Element        | Convention     | Example              |
| -------------- | -------------- | -------------------- |
| Packages       | lowercase      | `invoice`            |
| Exported Types | UpperCamelCase | `InvoiceService`     |
| Unexported     | lowerCamelCase | `calculateTax`       |
| Constants      | UpperCamelCase | `DefaultTaxRate`     |
| Errors         | ErrPrefix      | `ErrInvoiceNotFound` |
| Interfaces     | -er suffix     | `InvoiceCreator`     |

### File Organization

```go
// invoice_service.go
package invoice

import (
    "context"
    "errors"

    "github.com/baseer/backend/internal/model"
)

// Errors
var (
    ErrInvoiceNotFound = errors.New("invoice not found")
    ErrInvalidAmount   = errors.New("invalid amount")
)

// Service handles invoice business logic.
type Service struct {
    repo Repository
    tax  TaxCalculator
}

// NewService creates a new invoice service.
func NewService(repo Repository, tax TaxCalculator) *Service {
    return &Service{
        repo: repo,
        tax:  tax,
    }
}

// Create creates a new invoice.
func (s *Service) Create(ctx context.Context, req CreateRequest) (*model.Invoice, error) {
    // Validate
    if err := req.Validate(); err != nil {
        return nil, err
    }

    // Create
    invoice := &model.Invoice{
        // ...
    }

    if err := s.repo.Create(ctx, invoice); err != nil {
        return nil, err
    }

    return invoice, nil
}
```

### Error Handling

```go
// Always wrap errors with context
if err != nil {
    return fmt.Errorf("create invoice: %w", err)
}

// Use custom errors for business logic
if invoice.Total < 0 {
    return ErrInvalidAmount
}
```

---

## 4. Documentation Standards

### Code Comments

```dart
/// Calculates the total including tax.
///
/// The calculation follows ZATCA specifications for Saudi Arabia.
///
/// [subtotal] - The pre-tax amount
/// [taxRate] - The tax rate as a decimal (e.g., 0.15 for 15%)
///
/// Returns the total amount including tax.
///
/// Throws [ArgumentError] if [taxRate] is negative.
double calculateTotal(double subtotal, double taxRate) {
  if (taxRate < 0) {
    throw ArgumentError('Tax rate cannot be negative');
  }
  return subtotal * (1 + taxRate);
}
```

### API Documentation

```go
// CreateInvoice creates a new invoice.
//
// @Summary Create invoice
// @Description Creates a new invoice for the organization
// @Tags invoices
// @Accept json
// @Produce json
// @Param invoice body CreateInvoiceRequest true "Invoice data"
// @Success 201 {object} InvoiceResponse
// @Failure 400 {object} ErrorResponse
// @Router /invoices [post]
func (h *Handler) CreateInvoice(c *gin.Context) {
    // ...
}
```

---

## 5. Testing Standards

### Test File Naming

| Type        | Convention                              |
| ----------- | --------------------------------------- |
| Unit test   | `feature_test.dart` / `feature_test.go` |
| Widget test | `feature_widget_test.dart`              |
| Integration | `feature_integration_test.dart`         |

### Test Structure (Arrange-Act-Assert)

```dart
test('should calculate total with tax', () {
  // Arrange
  const subtotal = 100.0;
  const taxRate = 0.15;
  final calculator = TaxCalculator();

  // Act
  final result = calculator.calculateTotal(subtotal, taxRate);

  // Assert
  expect(result, equals(115.0));
});
```

---

## 6. Git Commit Standards

### Commit Message Format

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types

| Type       | Description        |
| ---------- | ------------------ |
| `feat`     | New feature        |
| `fix`      | Bug fix            |
| `docs`     | Documentation      |
| `style`    | Formatting         |
| `refactor` | Code restructuring |
| `test`     | Adding tests       |
| `chore`    | Maintenance        |

### Examples

```
feat(invoice): add ZATCA QR code generation

Implements Phase 2 ZATCA-compliant QR code generation
for Saudi invoices.

Closes #123
```

---

## 7. Linting Rules

### Flutter (analysis_options.yaml)

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - always_declare_return_types
    - avoid_dynamic_calls
    - avoid_print
    - prefer_const_constructors
    - prefer_final_fields
    - sort_constructors_first

analyzer:
  errors:
    missing_required_param: error
    missing_return: error
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
```

### Go (.golangci.yml)

```yaml
linters:
  enable:
    - errcheck
    - govet
    - ineffassign
    - staticcheck
    - unused
    - gofmt
    - goimports
```

---

**Document Control:**

- Prepared by: Baseer Development Agent Team
- Date: December 27, 2025
