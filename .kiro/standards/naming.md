# معايير التسمية

**المشروع:** بصير MVP  
**الحالة:** ✅ نشط

---

## القواعد الأساسية

### الملفات والمجلدات

- **الصيغة:** `snake_case`
- **مثال:** `customer_repository.dart`, `invoice_model.dart`

### Classes و Enums

- **الصيغة:** `PascalCase`
- **مثال:** `CustomerRepository`, `InvoiceStatus`

### Functions و Methods

- **الصيغة:** `camelCase`
- **مثال:** `getAllCustomers()`, `validateEmail()`

### Variables و Properties

- **الصيغة:** `camelCase`
- **مثال:** `customerName`, `invoiceCount`

### Constants

- **الصيغة:** `lowerCamelCase`
- **مثال:** `maxRetries`, `apiTimeout`

### Private Members

- **الصيغة:** `_prefix`
- **مثال:** `_privateToken`, `_validateInput()`

---

## الأخطاء الشائعة

| ❌ خطأ                    | ✅ صحيح                      |
| :------------------------ | :--------------------------- |
| `CustomerRepository.dart` | `customer_repository.dart`   |
| `customer_repository`     | `CustomerRepository` (class) |
| `GetAllCustomers()`       | `getAllCustomers()`          |
| `MAX_RETRIES`             | `maxRetries`                 |

---

## قواعد إضافية

### Widget Names

- استخدام prefixes واضحة: `AppButton`, `CustomerCard`
- تجنب أسماء عامة: ❌ `Button`, ✅ `AppButton`

### Provider Names

- استخدام suffixes مناسبة: `customersProvider`, `authNotifier`

### Test Files

- نفس اسم الملف + `.test.dart`
- مثال: `customer_repository.dart` → `customer_repository.test.dart`

---

**للأمثلة التفصيلية:** `.kiro/steering/reference/naming-examples.md`
