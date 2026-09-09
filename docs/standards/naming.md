# Naming Standards

**Project:** Basir MVP  
**Status:** ✅ Active

---

## Core Rules

### Files and Directories

- **Format:** `snake_case`
- **Example:** `customer_repository.dart`, `invoice_model.dart`

### Classes and Enums

- **Format:** `PascalCase`
- **Example:** `CustomerRepository`, `InvoiceStatus`

### Functions and Methods

- **Format:** `camelCase`
- **Example:** `getAllCustomers()`, `validateEmail()`

### Variables and Properties

- **Format:** `camelCase`
- **Example:** `customerName`, `invoiceCount`

### Constants

- **Format:** `lowerCamelCase` (following official Dart style for most cases)
- **Example:** `maxRetries`, `apiTimeout`

### Private Members

- **Format:** `_prefix` (underscore prefix)
- **Example:** `_privateToken`, `_validateInput()`

---

## Common Corrections

| ❌ Incorrect              | ✅ Correct                      |
| :------------------------ | :------------------------------ |
| `CustomerRepository.dart` | `customer_repository.dart`      |
| `customer_repository`     | `CustomerRepository` (as class) |
| `GetAllCustomers()`       | `getAllCustomers()`             |
| `MAX_RETRIES`             | `maxRetries`                    |

---

## Additional Guidelines

### Widget Naming

- Use clear and descriptive prefixes: `AppButton`, `CustomerCard`.
- Avoid generic names that may conflict: ❌ `Button`, ✅ `AppButton`.

### Provider Naming

- Use appropriate suffixes for clarity: `customersProvider`, `authNotifier`.

### Test Files

- File naming follows the source file name + `.test.dart` or `_test.dart` (following Flutter convention).
- Example: `customer_repository.dart` → `customer_repository_test.dart`.

---

**For detailed examples, refer to:** `.kiro/steering/reference/naming-examples.md`
