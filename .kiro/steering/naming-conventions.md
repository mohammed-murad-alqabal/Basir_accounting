---
inclusion: always
---

# معايير التسميات والجودة اللغوية

**المشروع:** بصير MVP  
**التاريخ:** 29 نوفمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ نشط ومعتمد

---

## المبدأ الأساسي

**الوضوح والاتساق أولاً** - يجب أن تكون جميع التسميات والتعليقات والتوثيق واضحة، متسقة، وذات جودة عالية.

---

## 1. معايير التسمية (Naming Conventions)

### 1.1 الملفات والمجلدات

#### القواعد الأساسية

- **snake_case** لجميع الملفات والمجلدات
- أسماء وصفية ودقيقة
- تجنب الاختصارات غير الواضحة

#### أمثلة صحيحة ✅

```
customer_repository.dart
invoice_model.dart
auth_service.dart
login_screen.dart
app_button.dart
```

#### أمثلة خاطئة ❌

```
CustomerRepository.dart  // PascalCase
custRepo.dart           // اختصار غير واضح
login.dart              // غير محدد
btn.dart                // اختصار مبهم
```

### 1.2 Classes و Enums

#### القواعد

- **PascalCase** دائماً
- أسماء واضحة تعبر عن الغرض
- استخدام أسماء كاملة

#### أمثلة صحيحة ✅

```dart
class CustomerRepository { }
class InvoiceModel { }
class AuthService { }
enum InvoiceStatus { }
enum PaymentMethod { }
```

#### أمثلة خاطئة ❌

```dart
class customerRepository { }  // camelCase
class CustRepo { }            // اختصار
class Repo { }                // غير محدد
```

### 1.3 Methods و Functions

#### القواعد

- **camelCase** دائماً
- أفعال واضحة تصف الإجراء
- معلمات بأسماء وصفية

#### أمثلة صحيحة ✅

```dart
Future<void> addCustomer(Customer customer) async { }
List<Invoice> getAllInvoices() { }
bool isValidEmail(String email) { }
void updateInvoiceStatus(String id, InvoiceStatus status) { }
```

#### أمثلة خاطئة ❌

```dart
Future<void> AddCustomer() { }     // PascalCase
List<Invoice> getAll() { }         // غير محدد
bool valid(String e) { }           // غير واضح
void update(String i, var s) { }  // معلمات مبهمة
```

### 1.4 Variables و Properties

#### القواعد

- **camelCase** للمتغيرات العادية
- **lowerCamelCase** للثوابت
- **\_prefix** للمتغيرات الخاصة
- أسماء وصفية ودقيقة

#### أمثلة صحيحة ✅

```dart
String customerName;
int invoiceCount;
bool isLoggedIn;
final maxRetries = 3;
const apiTimeout = 30;
String _privateToken;
```

#### أمثلة خاطئة ❌

```dart
String name;           // غير محدد
int count;             // غير واضح
bool flag;             // مبهم
final MAX_RETRIES = 3; // SCREAMING_SNAKE_CASE
```

---

## 2. التعليقات والتوثيق (Comments & Documentation)

### 2.1 DartDoc للـ Public APIs

#### القواعد

- **إلزامي** لجميع الـ public classes, methods, properties
- استخدام `///` للتوثيق
- شرح واضح للغرض
- توثيق المعاملات والقيم المرجعة
- إضافة أمثلة عند الحاجة

#### مثال صحيح ✅

````dart
/// يمثل عميل في النظام.
///
/// يحتوي على جميع المعلومات الأساسية للعميل بما في ذلك
/// الاسم، رقم الهاتف، والعنوان.
///
/// مثال:
/// ```dart
/// final customer = Customer(
///   id: 'customer-1',
///   name: 'أحمد محمد',
///   phone: '0501234567',
/// );
/// ```
class Customer {
  /// معرف فريد للعميل.
  final String id;

  /// اسم العميل الكامل.
  final String name;

  /// رقم هاتف العميل.
  final String phone;
}
````

#### مثال خاطئ ❌

```dart
// Customer class
class Customer {
  String id;  // id
  String name;  // name
  String phone;  // phone number
}
```

### 2.2 TODO Comments

#### القواعد

- استخدام صيغة: `// TODO(username): وصف واضح`
- إضافة issue reference إن وجد
- تجنب TODO بدون تفاصيل

#### أمثلة صحيحة ✅

```dart
// TODO(developer): إضافة validation لرقم الهاتف
// TODO(developer): تحسين أداء البحث - Issue #123
// TODO(developer): إضافة دعم للعملات المتعددة
```

#### أمثلة خاطئة ❌

```dart
// TODO: fix this
// TODO
// FIXME
```

### 2.3 التعليقات الداخلية

#### القواعد

- استخدام `//` للتعليقات القصيرة
- استخدام `/* */` للتعليقات الطويلة
- تعليقات واضحة ومفيدة
- تجنب التعليقات الواضحة

#### أمثلة صحيحة ✅

```dart
// التحقق من صحة البريد الإلكتروني باستخدام regex
if (!emailRegex.hasMatch(email)) {
  throw ValidationException('بريد إلكتروني غير صحيح');
}

/*
 * هذا الكود يقوم بحساب الضريبة بناءً على النسبة المحددة
 * في الإعدادات. إذا لم تكن النسبة محددة، يتم استخدام
 * القيمة الافتراضية 15%.
 */
final taxRate = settings.taxRate ?? 0.15;
```

#### أمثلة خاطئة ❌

```dart
// increment counter
counter++;  // واضح بدون تعليق

// check if user is logged in
if (isLoggedIn) { }  // واضح من اسم المتغير
```

---

## 3. الرسائل والنصوص (Messages & Strings)

### 3.1 رسائل الأخطاء

#### القواعد

- واضحة ومحددة
- تشرح المشكلة والحل
- باللغة العربية للمستخدم النهائي
- باللغة الإنجليزية للـ logs التقنية

#### أمثلة صحيحة ✅

```dart
throw ValidationException('رقم الهاتف يجب أن يبدأ بـ 05 ويتكون من 10 أرقام');
throw AuthException('كلمة المرور غير صحيحة. يرجى المحاولة مرة أخرى');
debugPrint('Error: Failed to save customer - ${error.toString()}');
```

#### أمثلة خاطئة ❌

```dart
throw Exception('Error');  // غير محدد
throw Exception('Invalid input');  // غير واضح
throw Exception('خطأ');  // غير مفيد
```

### 3.2 رسائل النجاح

#### القواعد

- إيجابية ومشجعة
- واضحة ومحددة
- باللغة العربية

#### أمثلة صحيحة ✅

```dart
'تم إضافة العميل بنجاح'
'تم حفظ الفاتورة بنجاح'
'تم تصدير الفاتورة كملف PDF'
'تم تحديث البيانات بنجاح'
```

#### أمثلة خاطئة ❌

```dart
'Done'  // إنجليزي
'تم'  // غير محدد
'Success'  // غير واضح
```

### 3.3 نصوص الواجهة

#### القواعد

- واضحة ومباشرة
- باللغة العربية الفصحى
- تجنب العامية
- استخدام مصطلحات متسقة

#### أمثلة صحيحة ✅

```dart
'إضافة عميل جديد'
'قائمة الفواتير'
'تصدير كـ PDF'
'حفظ التغييرات'
'إلغاء'
```

#### أمثلة خاطئة ❌

```dart
'أضف كاستمر'  // عامية
'الفواتير'  // غير محدد
'Export'  // إنجليزي
'Save'  // إنجليزي
```

---

## 4. البنية والتنظيم (Structure & Organization)

### 4.1 ترتيب الأعضاء في Class

#### الترتيب الموصى به

1. Static constants
2. Static variables
3. Instance variables (public)
4. Instance variables (private)
5. Constructors
6. Static methods
7. Public methods
8. Private methods
9. Getters
10. Setters

#### مثال صحيح ✅

```dart
class CustomerRepository {
  // 1. Static constants
  static const String collectionName = 'customers';

  // 2. Static variables
  static int instanceCount = 0;

  // 3. Instance variables (public)
  final Isar isar;

  // 4. Instance variables (private)
  final List<Customer> _cache = [];

  // 5. Constructor
  CustomerRepository(this.isar) {
    instanceCount++;
  }

  // 6. Static methods
  static CustomerRepository create(Isar isar) {
    return CustomerRepository(isar);
  }

  // 7. Public methods
  Future<List<Customer>> getAllCustomers() async {
    return await isar.customerModels.where().findAll();
  }

  // 8. Private methods
  void _updateCache(Customer customer) {
    _cache.add(customer);
  }

  // 9. Getters
  int get cacheSize => _cache.length;

  // 10. Setters
  set maxCacheSize(int value) {
    // implementation
  }
}
```

### 4.2 ترتيب Imports

#### الترتيب الموصى به

1. Dart SDK imports
2. Flutter imports
3. Package imports
4. Relative imports

#### مثال صحيح ✅

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:convert';

// 2. Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Packages
import 'package:riverpod/riverpod.dart';
import 'package:isar/isar.dart';

// 4. Relative
import '../models/customer.dart';
import '../../core/widgets/app_button.dart';
```

---

## 5. معايير الجودة (Quality Standards)

### 5.1 طول الأسطر

#### القواعد

- **الحد الأقصى:** 80 حرف
- استخدام line breaks للأسطر الطويلة
- محاذاة المعاملات بشكل واضح

#### مثال صحيح ✅

```dart
final customer = Customer(
  id: 'customer-1',
  name: 'أحمد محمد علي',
  phone: '0501234567',
  email: 'ahmed@example.com',
  address: 'الرياض، المملكة العربية السعودية',
);
```

#### مثال خاطئ ❌

```dart
final customer = Customer(id: 'customer-1', name: 'أحمد محمد علي', phone: '0501234567', email: 'ahmed@example.com', address: 'الرياض، المملكة العربية السعودية');
```

### 5.2 التعقيد (Complexity)

#### القواعد

- **الحد الأقصى للـ Cyclomatic Complexity:** 10
- تقسيم الدوال المعقدة إلى دوال أصغر
- استخدام early returns

#### مثال صحيح ✅

```dart
bool isValidCustomer(Customer customer) {
  if (customer.name.isEmpty) return false;
  if (customer.phone.isEmpty) return false;
  if (!_isValidPhone(customer.phone)) return false;
  return true;
}

bool _isValidPhone(String phone) {
  return phone.startsWith('05') && phone.length == 10;
}
```

#### مثال خاطئ ❌

```dart
bool isValidCustomer(Customer customer) {
  if (customer.name.isNotEmpty) {
    if (customer.phone.isNotEmpty) {
      if (customer.phone.startsWith('05')) {
        if (customer.phone.length == 10) {
          return true;
        }
      }
    }
  }
  return false;
}
```

### 5.3 DRY (Don't Repeat Yourself)

#### القواعد

- تجنب تكرار الكود
- استخدام functions للكود المتكرر
- استخدام constants للقيم المتكررة

#### مثال صحيح ✅

```dart
const String phonePrefix = '05';
const int phoneLength = 10;

bool isValidPhone(String phone) {
  return phone.startsWith(phonePrefix) && phone.length == phoneLength;
}
```

#### مثال خاطئ ❌

```dart
bool isValidPhone1(String phone) {
  return phone.startsWith('05') && phone.length == 10;
}

bool isValidPhone2(String phone) {
  return phone.startsWith('05') && phone.length == 10;
}
```

---

## 6. معايير خاصة بـ Flutter

### 6.1 Widget Names

#### القواعد

- أسماء واضحة تصف الغرض
- استخدام prefixes مناسبة (App, Custom, etc.)
- تجنب أسماء عامة جداً

#### أمثلة صحيحة ✅

```dart
class AppButton extends StatelessWidget { }
class CustomerCard extends StatelessWidget { }
class InvoiceListItem extends StatelessWidget { }
class CustomTextField extends StatelessWidget { }
```

#### أمثلة خاطئة ❌

```dart
class Button extends StatelessWidget { }  // عام جداً
class Card extends StatelessWidget { }    // يتعارض مع Flutter
class Item extends StatelessWidget { }    // غير محدد
```

### 6.2 State Management

#### القواعد

- أسماء واضحة للـ Providers
- استخدام suffixes مناسبة (Provider, Notifier, etc.)
- توثيق الحالة والأحداث

#### أمثلة صحيحة ✅

```dart
final customersProvider = StateNotifierProvider<CustomersNotifier, AsyncValue<List<Customer>>>((ref) {
  return CustomersNotifier(ref);
});

class CustomersNotifier extends StateNotifier<AsyncValue<List<Customer>>> {
  CustomersNotifier(this.ref) : super(const AsyncValue.loading());

  final Ref ref;

  /// تحميل جميع العملاء من قاعدة البيانات.
  Future<void> loadCustomers() async {
    // implementation
  }
}
```

### 6.3 Build Methods

#### القواعد

- استخدام const constructors حيثما أمكن
- تقسيم build methods الكبيرة
- استخدام extract widget للأجزاء المعقدة

#### مثال صحيح ✅

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: _buildAppBar(),
    body: _buildBody(),
    floatingActionButton: _buildFAB(),
  );
}

AppBar _buildAppBar() {
  return const AppBar(
    title: Text('قائمة العملاء'),
  );
}

Widget _buildBody() {
  return const CustomerList();
}

Widget _buildFAB() {
  return FloatingActionButton(
    onPressed: _handleAddCustomer,
    child: const Icon(Icons.add),
  );
}
```

---

## 7. معايير الأمان (Security Standards)

### 7.1 Sensitive Data

#### القواعد

- عدم تخزين بيانات حساسة في الكود
- استخدام secure storage للبيانات الحساسة
- عدم طباعة بيانات حساسة في logs

#### مثال صحيح ✅

```dart
// حفظ كلمة المرور بشكل آمن
await _secureStorage.write(
  key: 'password',
  value: hashedPassword,
);

// قراءة كلمة المرور
final password = await _secureStorage.read(key: 'password');
```

#### مثال خاطئ ❌

```dart
const String apiKey = 'redacted';  // في الكود!
debugPrint('Password: $password');  // في logs!
```

### 7.2 Input Validation

#### القواعد

- التحقق من جميع المدخلات
- استخدام validation functions واضحة
- رسائل خطأ مفيدة

#### مثال صحيح ✅

```dart
String? validatePhone(String? value) {
  if (value == null || value.isEmpty) {
    return 'رقم الهاتف مطلوب';
  }
  if (!value.startsWith('05')) {
    return 'رقم الهاتف يجب أن يبدأ بـ 05';
  }
  if (value.length != 10) {
    return 'رقم الهاتف يجب أن يتكون من 10 أرقام';
  }
  return null;
}
```

---

## 8. معايير الأداء (Performance Standards)

### 8.1 Const Constructors

#### القواعد

- استخدام const حيثما أمكن
- تقليل rebuilds غير الضرورية
- استخدام const للـ widgets الثابتة

#### مثال صحيح ✅

```dart
const Text('مرحباً')
const Icon(Icons.add)
const SizedBox(height: 16)
const Padding(padding: EdgeInsets.all(8))
```

#### مثال خاطئ ❌

```dart
Text('مرحباً')  // يمكن أن يكون const
Icon(Icons.add)  // يمكن أن يكون const
```

### 8.2 Async Operations

#### القواعد

- استخدام async/await بشكل صحيح
- معالجة الأخطاء في async operations
- تجنب blocking operations

#### مثال صحيح ✅

```dart
Future<void> loadCustomers() async {
  try {
    state = const AsyncValue.loading();
    final customers = await _repository.getAllCustomers();
    state = AsyncValue.data(customers);
  } on Exception catch (error, stackTrace) {
    state = AsyncValue.error(error, stackTrace);
    debugPrint('Error loading customers: $error');
  }
}
```

---

## 9. قائمة التحقق (Checklist)

### قبل Commit

- [ ] جميع الأسماء تتبع المعايير
- [ ] جميع الـ public APIs موثقة
- [ ] TODO comments بصيغة صحيحة
- [ ] لا توجد بيانات حساسة في الكود
- [ ] استخدام const حيثما أمكن
- [ ] طول الأسطر < 80 حرف
- [ ] لا يوجد كود مكرر
- [ ] جميع الـ imports منظمة
- [ ] رسائل الأخطاء واضحة
- [ ] التعليقات مفيدة وواضحة

### قبل PR

- [ ] flutter analyze بدون أخطاء
- [ ] flutter test نجح 100%
- [ ] التوثيق محدث
- [ ] CHANGELOG محدث
- [ ] لا توجد warnings حرجة
- [ ] الكود يتبع جميع المعايير

---

## 10. أدوات المساعدة (Tools)

### 10.1 Linting

استخدام `analysis_options.yaml` مع قواعد صارمة:

```yaml
linter:
  rules:
    - always_declare_return_types
    - always_use_package_imports
    - avoid_print
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_final_fields
    - public_member_api_docs
    - sort_pub_dependencies
    - unawaited_futures
```

### 10.2 Formatting

استخدام `dart format`:

```bash
dart format lib/ test/
```

### 10.3 Analysis

استخدام `flutter analyze`:

```bash
flutter analyze --no-pub
```

---

## 11. أمثلة كاملة

### مثال: Repository Class

````dart
import 'package:isar/isar.dart';

import '../models/customer_model.dart';
import '../../domain/entities/customer.dart';

/// مستودع لإدارة عمليات العملاء في قاعدة البيانات.
///
/// يوفر هذا المستودع جميع العمليات الأساسية (CRUD) للعملاء
/// باستخدام قاعدة بيانات Isar المحلية.
///
/// مثال:
/// ```dart
/// final repository = CustomerRepository(isar);
/// final customers = await repository.getAllCustomers();
/// ```
class CustomerRepository {
  /// اسم المجموعة في قاعدة البيانات.
  static const String collectionName = 'customers';

  /// مثيل قاعدة البيانات Isar.
  final Isar isar;

  /// ينشئ مستودع عملاء جديد.
  ///
  /// [isar] مثيل قاعدة البيانات المطلوب للعمليات.
  CustomerRepository(this.isar);

  /// يسترجع جميع العملاء من قاعدة البيانات.
  ///
  /// Returns قائمة بجميع العملاء المخزنين.
  /// Returns قائمة فارغة إذا لم يكن هناك عملاء.
  Future<List<Customer>> getAllCustomers() async {
    try {
      final models = await isar.customerModels.where().findAll();
      return models.map((model) => model.toEntity()).toList();
    } on Exception catch (error, stackTrace) {
      debugPrint('Error getting all customers: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  /// يضيف عميل جديد إلى قاعدة البيانات.
  ///
  /// [customer] العميل المراد إضافته.
  ///
  /// Throws [ValidationException] إذا كانت بيانات العميل غير صحيحة.
  /// Throws [DuplicateException] إذا كان العميل موجود مسبقاً.
  Future<void> addCustomer(Customer customer) async {
    _validateCustomer(customer);

    try {
      await isar.writeTxn(() async {
        await isar.customerModels.put(customer.toModel());
      });
    } on Exception catch (error, stackTrace) {
      debugPrint('Error adding customer: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  /// يتحقق من صحة بيانات العميل.
  ///
  /// Throws [ValidationException] إذا كانت البيانات غير صحيحة.
  void _validateCustomer(Customer customer) {
    if (customer.name.isEmpty) {
      throw ValidationException('اسم العميل مطلوب');
    }
    if (customer.phone.isEmpty) {
      throw ValidationException('رقم الهاتف مطلوب');
    }
    if (!_isValidPhone(customer.phone)) {
      throw ValidationException('رقم الهاتف غير صحيح');
    }
  }

  /// يتحقق من صحة رقم الهاتف.
  bool _isValidPhone(String phone) {
    return phone.startsWith('05') && phone.length == 10;
  }
}
````

---

## 12. المراجع والموارد

### الوثائق الرسمية

- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Flutter Style Guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)

### أدوات مفيدة

- [dartfmt](https://dart.dev/tools/dartfmt)
- [dartanalyzer](https://dart.dev/tools/dartanalyzer)
- [flutter_lints](https://pub.dev/packages/flutter_lints)

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 29 نوفمبر 2025  
**الإصدار:** 1.0  
**الحالة:** ✅ نشط ومعتمد
