---
inclusion: always
---

# معايير جودة الكود

**المشروع:** بصير MVP  
**التاريخ:** 29 نوفمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ نشط ومعتمد

---

## المبدأ الأساسي

**الجودة قبل السرعة** - كود نظيف، قابل للصيانة، ومختبر جيداً أهم من كود سريع ولكن معقد.

---

## 1. مبادئ SOLID

### 1.1 Single Responsibility Principle (SRP)

**المبدأ:** كل class يجب أن يكون له مسؤولية واحدة فقط.

#### مثال صحيح ✅

```dart
// مسؤولية واحدة: إدارة العملاء في قاعدة البيانات
class CustomerRepository {
  Future<List<Customer>> getAllCustomers() async { }
  Future<void> addCustomer(Customer customer) async { }
  Future<void> updateCustomer(Customer customer) async { }
  Future<void> deleteCustomer(String id) async { }
}

// مسؤولية واحدة: التحقق من صحة بيانات العميل
class CustomerValidator {
  static String? validateName(String? value) { }
  static String? validatePhone(String? value) { }
  static String? validateEmail(String? value) { }
}
```

#### مثال خاطئ ❌

```dart
// مسؤوليات متعددة: قاعدة البيانات + التحقق + UI
class CustomerManager {
  Future<List<Customer>> getAllCustomers() async { }
  String? validateName(String? value) { }
  Widget buildCustomerCard(Customer customer) { }
}
```

### 1.2 Open/Closed Principle (OCP)

**المبدأ:** مفتوح للتوسع، مغلق للتعديل.

#### مثال صحيح ✅

```dart
abstract class PaymentMethod {
  Future<bool> processPayment(double amount);
}

class CashPayment implements PaymentMethod {
  @override
  Future<bool> processPayment(double amount) async {
    // معالجة الدفع النقدي
    return true;
  }
}

class CardPayment implements PaymentMethod {
  @override
  Future<bool> processPayment(double amount) async {
    // معالجة الدفع بالبطاقة
    return true;
  }
}

// يمكن إضافة طرق دفع جديدة بدون تعديل الكود الموجود
```

### 1.3 Liskov Substitution Principle (LSP)

**المبدأ:** يجب أن تكون الأنواع الفرعية قابلة للاستبدال بأنواعها الأساسية.

#### مثال صحيح ✅

```dart
abstract class Repository<T> {
  Future<List<T>> getAll();
  Future<void> add(T item);
}

class CustomerRepository implements Repository<Customer> {
  @override
  Future<List<Customer>> getAll() async {
    // implementation
  }

  @override
  Future<void> add(Customer customer) async {
    // implementation
  }
}

// يمكن استخدام CustomerRepository في أي مكان يتوقع Repository<Customer>
```

### 1.4 Interface Segregation Principle (ISP)

**المبدأ:** لا تجبر class على تنفيذ interfaces لا يحتاجها.

#### مثال صحيح ✅

```dart
abstract class Readable {
  Future<List<T>> getAll<T>();
}

abstract class Writable {
  Future<void> add<T>(T item);
}

// Repository يحتاج القراءة والكتابة
class CustomerRepository implements Readable, Writable {
  // implementation
}

// ReadOnlyRepository يحتاج القراءة فقط
class ReadOnlyCustomerRepository implements Readable {
  // implementation
}
```

### 1.5 Dependency Inversion Principle (DIP)

**المبدأ:** الاعتماد على abstractions وليس على implementations.

#### مثال صحيح ✅

```dart
// Abstract interface
abstract class CustomerRepository {
  Future<List<Customer>> getAllCustomers();
}

// Implementation
class IsarCustomerRepository implements CustomerRepository {
  final Isar isar;

  IsarCustomerRepository(this.isar);

  @override
  Future<List<Customer>> getAllCustomers() async {
    // implementation
  }
}

// Provider يعتمد على interface وليس implementation
class CustomerProvider {
  final CustomerRepository repository;

  CustomerProvider(this.repository);
}
```

---

## 2. Clean Code Principles

### 2.1 Meaningful Names

#### القواعد

- أسماء واضحة تعبر عن الغرض
- تجنب الاختصارات المبهمة
- استخدام أسماء قابلة للنطق

#### أمثلة صحيحة ✅

```dart
final customerList = <Customer>[];
final invoiceCount = invoices.length;
final isValidEmail = emailRegex.hasMatch(email);
final maxRetryAttempts = 3;
```

#### أمثلة خاطئة ❌

```dart
final cl = <Customer>[];  // غير واضح
final cnt = invoices.length;  // اختصار مبهم
final flag = emailRegex.hasMatch(email);  // غير محدد
final mra = 3;  // غير قابل للنطق
```

### 2.2 Small Functions

#### القواعد

- دالة واحدة = مسؤولية واحدة
- الحد الأقصى: 20-30 سطر
- مستوى واحد من التجريد

#### مثال صحيح ✅

```dart
Future<void> addCustomer(Customer customer) async {
  _validateCustomer(customer);
  await _saveToDatabase(customer);
  _notifyListeners();
}

void _validateCustomer(Customer customer) {
  if (customer.name.isEmpty) {
    throw ValidationException('اسم العميل مطلوب');
  }
}

Future<void> _saveToDatabase(Customer customer) async {
  await isar.writeTxn(() async {
    await isar.customerModels.put(customer.toModel());
  });
}

void _notifyListeners() {
  notifyListeners();
}
```

### 2.3 DRY (Don't Repeat Yourself)

#### القواعد

- تجنب تكرار الكود
- استخدام functions للكود المتكرر
- استخدام constants للقيم المتكررة

#### مثال صحيح ✅

```dart
class ValidationConstants {
  static const int minNameLength = 2;
  static const int maxNameLength = 100;
  static const String phonePrefix = '05';
  static const int phoneLength = 10;
}

String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'الاسم مطلوب';
  }
  if (value.length < ValidationConstants.minNameLength) {
    return 'الاسم قصير جداً';
  }
  if (value.length > ValidationConstants.maxNameLength) {
    return 'الاسم طويل جداً';
  }
  return null;
}
```

---

## 3. Error Handling

### 3.1 استخدام Exceptions بشكل صحيح

#### القواعد

- استخدام custom exceptions
- معالجة الأخطاء في المستوى المناسب
- عدم ابتلاع الأخطاء

#### مثال صحيح ✅

```dart
class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);

  @override
  String toString() => 'ValidationException: $message';
}

Future<void> addCustomer(Customer customer) async {
  try {
    _validateCustomer(customer);
    await _repository.addCustomer(customer);
  } on ValidationException catch (e) {
    debugPrint('Validation error: ${e.message}');
    rethrow;
  } on Exception catch (e, stackTrace) {
    debugPrint('Error adding customer: $e');
    debugPrintStack(stackTrace: stackTrace);
    throw CustomerException('فشل إضافة العميل: ${e.toString()}');
  }
}
```

### 3.2 Async Error Handling

#### القواعد

- استخدام try-catch في async functions
- معالجة جميع الحالات المحتملة
- تسجيل الأخطاء للتتبع

#### مثال صحيح ✅

```dart
Future<void> loadCustomers() async {
  state = const AsyncValue.loading();

  try {
    final customers = await _repository.getAllCustomers();
    state = AsyncValue.data(customers);
  } on NetworkException catch (e) {
    state = AsyncValue.error(
      'خطأ في الاتصال: ${e.message}',
      StackTrace.current,
    );
  } on DatabaseException catch (e) {
    state = AsyncValue.error(
      'خطأ في قاعدة البيانات: ${e.message}',
      StackTrace.current,
    );
  } on Exception catch (e, stackTrace) {
    debugPrint('Unexpected error: $e');
    debugPrintStack(stackTrace: stackTrace);
    state = AsyncValue.error(
      'حدث خطأ غير متوقع',
      stackTrace,
    );
  }
}
```

---

## 4. Testing Standards

### 4.1 Unit Tests

#### القواعد

- اختبار كل دالة public
- اختبار الحالات الطبيعية والاستثنائية
- اختبارات مستقلة

#### مثال صحيح ✅

```dart
void main() {
  group('CustomerValidator', () {
    group('validateName', () {
      test('should return null for valid name', () {
        final result = CustomerValidator.validateName('أحمد محمد');
        expect(result, isNull);
      });

      test('should return error for empty name', () {
        final result = CustomerValidator.validateName('');
        expect(result, equals('اسم العميل مطلوب'));
      });

      test('should return error for short name', () {
        final result = CustomerValidator.validateName('أ');
        expect(result, contains('قصير'));
      });

      test('should return error for long name', () {
        final result = CustomerValidator.validateName('أ' * 101);
        expect(result, contains('طويل'));
      });
    });
  });
}
```

### 4.2 Widget Tests

#### القواعد

- اختبار عرض الـ widgets
- اختبار التفاعلات
- استخدام mocks للـ dependencies

#### مثال صحيح ✅

```dart
void main() {
  testWidgets('CustomerCard displays customer info', (tester) async {
    final customer = Customer(
      id: 'test-1',
      name: 'أحمد محمد',
      phone: '0501234567',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomerCard(customer: customer),
        ),
      ),
    );

    expect(find.text('أحمد محمد'), findsOneWidget);
    expect(find.text('0501234567'), findsOneWidget);
  });
}
```

---

## 5. Performance Standards

### 5.1 Const Constructors

#### القواعد

- استخدام const حيثما أمكن
- تقليل rebuilds
- تحسين الأداء

#### مثال صحيح ✅

```dart
const Text('مرحباً')
const Icon(Icons.add)
const SizedBox(height: 16)
const EdgeInsets.all(8)
```

### 5.2 Lazy Loading

#### القواعد

- تحميل البيانات عند الحاجة
- استخدام pagination للقوائم الطويلة
- تجنب تحميل كل شيء مرة واحدة

#### مثال صحيح ✅

```dart
class CustomerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: customers.length,
      itemBuilder: (context, index) {
        return CustomerCard(customer: customers[index]);
      },
    );
  }
}
```

---

## 6. Security Standards

### 6.1 Input Validation

#### القواعد

- التحقق من جميع المدخلات
- استخدام whitelist validation
- تجنب injection attacks

#### مثال صحيح ✅

```dart
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'البريد الإلكتروني مطلوب';
  }

  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
  );

  if (!emailRegex.hasMatch(value)) {
    return 'البريد الإلكتروني غير صحيح';
  }

  return null;
}
```

### 6.2 Secure Storage

#### القواعد

- استخدام secure storage للبيانات الحساسة
- تشفير البيانات
- عدم تخزين بيانات حساسة في plain text

#### مثال صحيح ✅

```dart
class AuthService {
  final FlutterSecureStorage _secureStorage;

  Future<void> saveCredentials(String username, String password) async {
    final hashedPassword = _hashPassword(password);
    await _secureStorage.write(key: 'username', value: username);
    await _secureStorage.write(key: 'password', value: hashedPassword);
  }

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }
}
```

---

## 7. Documentation Standards

### 7.1 DartDoc

#### القواعد

- توثيق جميع الـ public APIs
- شرح المعاملات والقيم المرجعة
- إضافة أمثلة

#### مثال صحيح ✅

````dart
/// يضيف عميل جديد إلى قاعدة البيانات.
///
/// يتحقق من صحة بيانات العميل قبل الإضافة. إذا كانت البيانات
/// غير صحيحة، يتم رمي [ValidationException].
///
/// [customer] العميل المراد إضافته.
///
/// Throws [ValidationException] إذا كانت بيانات العميل غير صحيحة.
/// Throws [DatabaseException] إذا فشلت عملية الإضافة.
///
/// مثال:
/// ```dart
/// final customer = Customer(
///   id: 'customer-1',
///   name: 'أحمد محمد',
///   phone: '0501234567',
/// );
/// await repository.addCustomer(customer);
/// ```
Future<void> addCustomer(Customer customer) async {
  // implementation
}
````

---

## 8. Code Review Checklist

### قبل Submit للمراجعة

- [ ] الكود يتبع معايير التسمية
- [ ] جميع الـ public APIs موثقة
- [ ] الاختبارات موجودة وتعمل
- [ ] لا توجد أخطاء في flutter analyze
- [ ] الكود يتبع مبادئ SOLID
- [ ] لا يوجد كود مكرر
- [ ] معالجة الأخطاء صحيحة
- [ ] الأداء محسّن
- [ ] الأمان مضمون
- [ ] التعليقات واضحة ومفيدة

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 29 نوفمبر 2025  
**الإصدار:** 1.0  
**الحالة:** ✅ نشط ومعتمد
