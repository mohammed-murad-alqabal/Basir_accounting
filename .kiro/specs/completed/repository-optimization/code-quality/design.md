# Design Document - تحسينات جودة الكود

**المشروع:** بصير MVP  
**التاريخ:** 3 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** 🔄 قيد التنفيذ

---

## Overview

هذا التصميم يحدد كيفية تنفيذ تحسينات جودة الكود المحددة في المراجعة الهندسية. التحسينات تشمل:

1. إزالة get_it غير المستخدم
2. إضافة freezed للنماذج
3. تحويل Entities إلى freezed classes
4. التحقق من عدم كسر الكود الموجود

## Architecture

### Current Architecture

```
lib/features/
├── customers/
│   ├── domain/
│   │   ├── entities/
│   │   │   └── customer.dart (Manual immutable class)
│   │   └── repositories/
│   ├── data/
│   │   ├── models/
│   │   └── repositories/
│   └── presentation/
│
├── invoices/
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── invoice.dart (Manual immutable class)
│   │   │   └── invoice_item.dart (Manual immutable class)
│   │   └── repositories/
│   ├── data/
│   └── presentation/
```

### Target Architecture

```
lib/features/
├── customers/
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── customer.dart (freezed class)
│   │   │   └── customer.freezed.dart (generated)
│   │   └── repositories/
│   ├── data/
│   └── presentation/
│
├── invoices/
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── invoice.dart (freezed class)
│   │   │   ├── invoice.freezed.dart (generated)
│   │   │   ├── invoice_item.dart (freezed class)
│   │   │   └── invoice_item.freezed.dart (generated)
│   │   └── repositories/
│   ├── data/
│   └── presentation/
```

## Components and Interfaces

### 1. Dependencies Management

#### pubspec.yaml Changes

**Before:**

```yaml
dependencies:
  flutter_riverpod: ^2.4.0
  get_it: ^7.6.0 # ❌ غير مستخدم
  isar: ^3.1.0+1
  # ...

dev_dependencies:
  build_runner: ^2.4.0
  # ...
```

**After:**

```yaml
dependencies:
  flutter_riverpod: ^2.4.0
  # get_it removed ✅
  isar: ^3.1.0+1
  freezed_annotation: ^2.4.1 # ✅ جديد
  # ...

dev_dependencies:
  build_runner: ^2.4.0
  freezed: ^2.4.5 # ✅ جديد
  # ...
```

### 2. Customer Entity with freezed

#### Before (Manual Implementation)

```dart
// lib/features/customers/domain/entities/customer.dart
@immutable
class Customer {
  const Customer({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Manual copyWith (15+ lines)
  Customer copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Manual equals (10+ lines)
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Customer &&
        other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.email == email &&
        other.address == address &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  // Manual hashCode (5+ lines)
  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        address.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
```

**Total Lines:** ~60 lines

#### After (freezed Implementation)

```dart
// lib/features/customers/domain/entities/customer.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer.freezed.dart';

@freezed
class Customer with _$Customer {
  const factory Customer({
    required String id,
    required String name,
    String? phone,
    String? email,
    String? address,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Customer;
}
```

**Total Lines:** ~15 lines (75% reduction!)

**Generated Features:**

- ✅ copyWith method
- ✅ equals operator
- ✅ hashCode
- ✅ toString
- ✅ Immutability
- ✅ Type safety

### 3. Invoice Entity with freezed

#### Before (Manual Implementation)

```dart
// lib/features/invoices/domain/entities/invoice.dart
@immutable
class Invoice {
  const Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.customerId,
    required this.customerName,
    required this.items,
    required this.subtotal,
    required this.taxRate,
    required this.taxAmount,
    required this.total,
    required this.status,
    this.notes,
    required this.issueDate,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String invoiceNumber;
  final String customerId;
  final String customerName;
  final List<InvoiceItem> items;
  final double subtotal;
  final double taxRate;
  final double taxAmount;
  final double total;
  final InvoiceStatus status;
  final String? notes;
  final DateTime issueDate;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Manual copyWith (30+ lines)
  // Manual equals (20+ lines)
  // Manual hashCode (10+ lines)
}
```

**Total Lines:** ~100 lines

#### After (freezed Implementation)

```dart
// lib/features/invoices/domain/entities/invoice.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'invoice_item.dart';

part 'invoice.freezed.dart';

@freezed
class Invoice with _$Invoice {
  const factory Invoice({
    required String id,
    required String invoiceNumber,
    required String customerId,
    required String customerName,
    required List<InvoiceItem> items,
    required double subtotal,
    required double taxRate,
    required double taxAmount,
    required double total,
    required InvoiceStatus status,
    String? notes,
    required DateTime issueDate,
    DateTime? dueDate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Invoice;
}

enum InvoiceStatus {
  draft,
  sent,
  paid,
  overdue,
  cancelled,
}
```

**Total Lines:** ~30 lines (70% reduction!)

### 4. InvoiceItem Entity with freezed

#### After (freezed Implementation)

```dart
// lib/features/invoices/domain/entities/invoice_item.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'invoice_item.freezed.dart';

@freezed
class InvoiceItem with _$InvoiceItem {
  const factory InvoiceItem({
    required String id,
    required String description,
    required double quantity,
    required double unitPrice,
    required double total,
  }) = _InvoiceItem;
}
```

**Total Lines:** ~15 lines

## Data Models

### Conversion Strategy

#### Step 1: Add freezed Dependencies

```bash
flutter pub add freezed_annotation
flutter pub add --dev freezed
flutter pub add --dev build_runner
```

#### Step 2: Convert Entity Files

For each entity:

1. Add freezed imports
2. Add part directive
3. Convert class to factory constructor
4. Remove manual implementations
5. Run build_runner

#### Step 3: Generate Code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### Step 4: Verify

```bash
flutter analyze
flutter test
```

## Correctness Properties

_A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees._

### Property 1: Dependency Removal Preserves Functionality

_For any_ code path in the application, removing get_it should not affect the application's behavior since it was never used.

**Validates: Requirements 1.2, 1.3, 1.4**

### Property 2: freezed Classes Are Immutable

_For any_ freezed class instance, attempting to modify its fields should be impossible at compile time, ensuring immutability.

**Validates: Requirements 2.3**

### Property 3: copyWith Creates New Instance

_For any_ freezed class instance and any field update, calling copyWith should create a new instance with the updated field while preserving all other fields.

**Validates: Requirements 3.2, 4.2, 5.2**

### Property 4: Equality Based on Values

_For any_ two freezed class instances with identical field values, they should be considered equal regardless of their memory references.

**Validates: Requirements 3.3, 4.3, 5.3**

### Property 5: All Tests Pass After Migration

_For any_ test in the test suite, it should pass after migrating entities to freezed, proving backward compatibility.

**Validates: Requirements 3.4, 4.4, 6.2**

### Property 6: Repository Layer Unchanged

_For any_ repository method, it should work with freezed entities without requiring changes to the repository implementation.

**Validates: Requirements 3.5, 4.5**

### Property 7: Build Success After Changes

_For any_ platform (Android, iOS, Web), the application should build successfully after all changes.

**Validates: Requirements 6.3**

## Error Handling

### Build Errors

**Scenario:** build_runner fails to generate code

**Handling:**

```bash
# Clean and regenerate
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Import Errors

**Scenario:** Missing part files after conversion

**Handling:**

- Ensure part directive matches filename
- Run build_runner
- Check for syntax errors in freezed class

### Test Failures

**Scenario:** Tests fail after migration

**Handling:**

1. Check if test creates instances correctly
2. Update test to use factory constructor
3. Verify equality comparisons work with freezed

## Testing Strategy

### Unit Tests

**Test Coverage:**

- ✅ Customer entity creation
- ✅ Customer copyWith
- ✅ Customer equality
- ✅ Invoice entity creation
- ✅ Invoice copyWith
- ✅ Invoice equality
- ✅ InvoiceItem entity creation
- ✅ InvoiceItem copyWith
- ✅ InvoiceItem equality

**Example Test:**

```dart
void main() {
  group('Customer with freezed', () {
    test('should create customer with all fields', () {
      final customer = Customer(
        id: 'test-1',
        name: 'Test Customer',
        phone: '0501234567',
        email: 'test@example.com',
        address: 'Test Address',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(customer.id, 'test-1');
      expect(customer.name, 'Test Customer');
    });

    test('should create copy with updated fields', () {
      final customer = Customer(
        id: 'test-1',
        name: 'Test Customer',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final updated = customer.copyWith(name: 'Updated Name');

      expect(updated.id, customer.id);
      expect(updated.name, 'Updated Name');
      expect(updated.createdAt, customer.createdAt);
    });

    test('should compare by value not reference', () {
      final date = DateTime.now();
      final customer1 = Customer(
        id: 'test-1',
        name: 'Test',
        createdAt: date,
        updatedAt: date,
      );
      final customer2 = Customer(
        id: 'test-1',
        name: 'Test',
        createdAt: date,
        updatedAt: date,
      );

      expect(customer1, equals(customer2));
      expect(customer1.hashCode, equals(customer2.hashCode));
    });
  });
}
```

### Integration Tests

**Test Coverage:**

- ✅ Repository works with freezed entities
- ✅ Providers work with freezed entities
- ✅ UI displays freezed entities correctly

### Regression Tests

**Test Coverage:**

- ✅ All existing 518 tests still pass
- ✅ No new warnings or errors
- ✅ Application builds successfully

## Migration Checklist

### Phase 1: Preparation

- [ ] Backup current code
- [ ] Create feature branch
- [ ] Add freezed dependencies
- [ ] Run initial tests (baseline)

### Phase 2: Remove get_it

- [ ] Remove get_it from pubspec.yaml
- [ ] Run flutter pub get
- [ ] Run flutter analyze (should be clean)
- [ ] Run flutter test (all should pass)

### Phase 3: Convert Customer

- [ ] Convert customer.dart to freezed
- [ ] Run build_runner
- [ ] Fix any import errors
- [ ] Run customer tests
- [ ] Verify in UI

### Phase 4: Convert Invoice

- [ ] Convert invoice.dart to freezed
- [ ] Run build_runner
- [ ] Fix any import errors
- [ ] Run invoice tests
- [ ] Verify in UI

### Phase 5: Convert InvoiceItem

- [ ] Convert invoice_item.dart to freezed
- [ ] Run build_runner
- [ ] Fix any import errors
- [ ] Run tests
- [ ] Verify in UI

### Phase 6: Verification

- [ ] Run flutter analyze (0 issues)
- [ ] Run all tests (518 passing)
- [ ] Build for Android
- [ ] Build for iOS
- [ ] Build for Web
- [ ] Manual testing

### Phase 7: Documentation

- [ ] Update CHANGELOG.md
- [ ] Update README.md if needed
- [ ] Document freezed usage
- [ ] Create PR

## Benefits Summary

### Code Reduction

| Entity      | Before | After | Reduction |
| :---------- | :----- | :---- | :-------- |
| Customer    | ~60    | ~15   | 75%       |
| Invoice     | ~100   | ~30   | 70%       |
| InvoiceItem | ~40    | ~15   | 62.5%     |
| **Total**   | ~200   | ~60   | **70%**   |

### Quality Improvements

- ✅ No manual copyWith errors
- ✅ No manual equals errors
- ✅ No manual hashCode errors
- ✅ Guaranteed immutability
- ✅ Better type safety
- ✅ Automatic toString
- ✅ Less maintenance

### Developer Experience

- ✅ Less boilerplate
- ✅ Faster development
- ✅ Fewer bugs
- ✅ Better IDE support
- ✅ Easier refactoring

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 3 ديسمبر 2025  
**الحالة:** 🔄 قيد التنفيذ
