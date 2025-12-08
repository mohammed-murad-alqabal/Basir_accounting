# أمثلة تفصيلية - مرجع شامل

**المشروع:** بصير MVP  
**التاريخ:** 7 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ نشط

---

## نظرة عامة

هذا الملف يحتوي على أمثلة تفصيلية وعملية لجميع المعايير والممارسات في المشروع.

---

## الفهرس

1. [أمثلة التسمية](#أمثلة-التسمية)
2. [أمثلة جودة الكود](#أمثلة-جودة-الكود)
3. [أمثلة Flutter](#أمثلة-flutter)
4. [أمثلة اللغة العربية](#أمثلة-اللغة-العربية)
5. [أمثلة التوثيق](#أمثلة-التوثيق)
6. [أمثلة الاختبارات](#أمثلة-الاختبارات)

---

## أمثلة التسمية

### مثال 1: Repository Class

```dart
// ✅ صحيح - تسمية واضحة ومتسقة
class CustomerRepository {
  final Isar isar;

  CustomerRepository(this.isar);

  Future<List<Customer>> getAllCustomers() async {
    return await isar.customerModels.where().findAll();
  }

  Future<void> addCustomer(Customer customer) async {
    await isar.writeTxn(() async {
      await isar.customerModels.put(customer.toModel());
    });
  }
}

// ❌ خطأ - تسمية غير واضحة
class CustRepo {
  final Isar db;

  CustRepo(this.db);

  Future<List<Customer>> getAll() async {
    return await db.customerModels.where().findAll();
  }

  Future<void> add(Customer c) async {
    await db.writeTxn(() async {
      await db.customerModels.put(c.toModel());
    });
  }
}
```

### مثال 2: Widget Names

```dart
// ✅ صحيح - أسماء واضحة ومحددة
class CustomerCard extends StatelessWidget {
  final Customer customer;

  const CustomerCard({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(customer.name),
        subtitle: Text(customer.phone),
      ),
    );
  }
}

// ❌ خطأ - اسم عام جداً
class Card extends StatelessWidget {
  final Customer data;

  const Card({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(data.name),
        subtitle: Text(data.phone),
      ),
    );
  }
}
```

---

## أمثلة جودة الكود

### مثال 1: SOLID Principles

#### Single Responsibility Principle

```dart
// ✅ صحيح - مسؤولية واحدة لكل class
class CustomerRepository {
  Future<List<Customer>> getAllCustomers() async { }
  Future<void> addCustomer(Customer customer) async { }
}

class CustomerValidator {
  static String? validateName(String? value) { }
  static String? validatePhone(String? value) { }
}

class CustomerService {
  final CustomerRepository repository;
  final CustomerValidator validator;

  Future<void> createCustomer(Customer customer) async {
    validator.validateName(customer.name);
    validator.validatePhone(customer.phone);
    await repository.addCustomer(customer);
  }
}

// ❌ خطأ - مسؤوليات متعددة
class CustomerManager {
  Future<List<Customer>> getAllCustomers() async { }
  String? validateName(String? value) { }
  Widget buildCustomerCard(Customer customer) { }
}
```

#### Open/Closed Principle

```dart
// ✅ صحيح - مفتوح للتوسع، مغلق للتعديل
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
class MobilePayment implements PaymentMethod {
  @override
  Future<bool> processPayment(double amount) async {
    // معالجة الدفع عبر الموبايل
    return true;
  }
}
```

### مثال 2: Clean Code

#### Meaningful Names

```dart
// ✅ صحيح - أسماء واضحة
final customerList = <Customer>[];
final invoiceCount = invoices.length;
final isValidEmail = emailRegex.hasMatch(email);
final maxRetryAttempts = 3;

// ❌ خطأ - أسماء غير واضحة
final cl = <Customer>[];
final cnt = invoices.length;
final flag = emailRegex.hasMatch(email);
final mra = 3;
```

#### Small Functions

```dart
// ✅ صحيح - دوال صغيرة ومحددة
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

// ❌ خطأ - دالة كبيرة ومعقدة
Future<void> addCustomer(Customer customer) async {
  if (customer.name.isEmpty) {
    throw ValidationException('اسم العميل مطلوب');
  }
  if (customer.phone.isEmpty) {
    throw ValidationException('رقم الهاتف مطلوب');
  }
  if (!customer.phone.startsWith('05')) {
    throw ValidationException('رقم الهاتف يجب أن يبدأ بـ 05');
  }
  await isar.writeTxn(() async {
    await isar.customerModels.put(customer.toModel());
  });
  notifyListeners();
  debugPrint('Customer added: ${customer.name}');
}
```

---

## أمثلة Flutter

### مثال 1: State Management مع Riverpod

```dart
// ✅ صحيح - استخدام Riverpod بشكل صحيح
@riverpod
class CustomersNotifier extends _$CustomersNotifier {
  @override
  Future<List<Customer>> build() async {
    final repository = ref.watch(customerRepositoryProvider);
    return repository.getAllCustomers();
  }

  Future<void> addCustomer(Customer customer) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(customerRepositoryProvider);
      await repository.addCustomer(customer);
      return repository.getAllCustomers();
    });
  }
}
```

### مثال 2: Repository Pattern

```dart
// ✅ صحيح - Repository Pattern
class CustomerRepositoryImpl implements CustomerRepository {
  final Isar isar;

  CustomerRepositoryImpl(this.isar);

  @override
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

  @override
  Future<void> addCustomer(Customer customer) async {
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
}
```

### مثال 3: Widget مع RTL Support

```dart
// ✅ صحيح - دعم RTL
class CustomerCard extends StatelessWidget {
  final Customer customer;

  const CustomerCard({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              customer.name,
              style: Theme.of(context).textTheme.titleLarge,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8),
            Text(
              customer.phone,
              style: Theme.of(context).textTheme.bodyMedium,
              textDirection: TextDirection.ltr,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## أمثلة اللغة العربية

### مثال 1: رسائل المستخدم

```dart
// ✅ صحيح - رسائل واضحة بالعربية
'هل أنت متأكد من حذف هذا العميل؟'
'تم إضافة العميل بنجاح.'
'رقم الهاتف يجب أن يبدأ بـ 05 ويتكون من 10 أرقام.'

// ❌ خطأ - رسائل غير واضحة أو بالإنجليزية
'حذف؟'
'Done'
'Invalid phone'
```

### مثال 2: Validation Messages

```dart
// ✅ صحيح - رسائل validation واضحة
String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'اسم العميل مطلوب';
  }
  if (value.length < 2) {
    return 'اسم العميل يجب أن يحتوي على حرفين على الأقل';
  }
  if (value.length > 100) {
    return 'اسم العميل طويل جداً (الحد الأقصى 100 حرف)';
  }
  return null;
}

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

## أمثلة التوثيق

### مثال 1: DartDoc كامل

````dart
/// يمثل عميل في النظام.
///
/// يحتوي على جميع المعلومات الأساسية للعميل بما في ذلك
/// الاسم، رقم الهاتف، والعنوان. يتم استخدام هذا الكلاس
/// في جميع عمليات إدارة العملاء.
///
/// مثال:
/// ```dart
/// final customer = Customer(
///   id: 'customer-1',
///   name: 'أحمد محمد',
///   phone: '0501234567',
///   email: 'ahmed@example.com',
/// );
/// ```
class Customer {
  /// معرف فريد للعميل.
  ///
  /// يتم توليده تلقائياً عند إنشاء عميل جديد.
  final String id;

  /// اسم العميل الكامل.
  ///
  /// يجب أن يكون غير فارغ ويحتوي على حرفين على الأقل.
  final String name;

  /// رقم هاتف العميل.
  ///
  /// يجب أن يبدأ بـ 05 ويتكون من 10 أرقام.
  final String phone;

  /// ينشئ عميل جديد.
  ///
  /// [id] معرف فريد للعميل.
  /// [name] اسم العميل الكامل.
  /// [phone] رقم هاتف العميل.
  const Customer({
    required this.id,
    required this.name,
    required this.phone,
  });
}
````

### مثال 2: Repository Documentation

````dart
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
  ///
  /// Throws [DatabaseException] إذا فشلت عملية القراءة.
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

## أمثلة الاختبارات

### مثال 1: Unit Test كامل

```dart
void main() {
  group('CustomerRepository', () {
    late Isar isar;
    late CustomerRepositoryImpl repository;

    setUp(() async {
      isar = await Isar.open(
        [CustomerModelSchema],
        directory: '',
        name: 'test_${DateTime.now().millisecondsSinceEpoch}',
      );
      repository = CustomerRepositoryImpl(isar);
    });

    tearDown(() async {
      await isar.close(deleteFromDisk: true);
    });

    group('getAllCustomers', () {
      test('should return empty list when no customers', () async {
        final customers = await repository.getAllCustomers();
        expect(customers, isEmpty);
      });

      test('should return all customers', () async {
        final customer1 = Customer(
          id: 'test-1',
          name: 'أحمد محمد',
          phone: '0501234567',
        );
        final customer2 = Customer(
          id: 'test-2',
          name: 'محمد علي',
          phone: '0509876543',
        );

        await repository.addCustomer(customer1);
        await repository.addCustomer(customer2);

        final customers = await repository.getAllCustomers();

        expect(customers.length, 2);
        expect(customers[0].name, 'أحمد محمد');
        expect(customers[1].name, 'محمد علي');
      });
    });

    group('addCustomer', () {
      test('should add customer successfully', () async {
        final customer = Customer(
          id: 'test-1',
          name: 'أحمد محمد',
          phone: '0501234567',
        );

        await repository.addCustomer(customer);
        final customers = await repository.getAllCustomers();

        expect(customers.length, 1);
        expect(customers.first.name, 'أحمد محمد');
      });

      test('should throw ValidationException for empty name', () async {
        final customer = Customer(
          id: 'test-1',
          name: '',
          phone: '0501234567',
        );

        expect(
          () => repository.addCustomer(customer),
          throwsA(isA<ValidationException>()),
        );
      });

      test('should throw ValidationException for invalid phone', () async {
        final customer = Customer(
          id: 'test-1',
          name: 'أحمد محمد',
          phone: '1234567890',
        );

        expect(
          () => repository.addCustomer(customer),
          throwsA(isA<ValidationException>()),
        );
      });
    });
  });
}
```

### مثال 2: Widget Test

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

  testWidgets('CustomerCard handles long names', (tester) async {
    final customer = Customer(
      id: 'test-1',
      name: 'أحمد محمد علي حسن عبدالله إبراهيم',
      phone: '0501234567',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 200,
            child: CustomerCard(customer: customer),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
```

---

## المراجع

### للمزيد من الأمثلة

راجع الملفات التالية:

- `standards/naming.md` - أمثلة التسمية الأساسية
- `standards/code-quality.md` - أمثلة الجودة الأساسية
- `standards/flutter.md` - أمثلة Flutter الأساسية
- `standards/arabic.md` - أمثلة العربية الأساسية
- `standards/documentation.md` - أمثلة التوثيق الأساسية
- `standards/testing.md` - أمثلة الاختبارات الأساسية

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 7 ديسمبر 2025  
**الإصدار:** 1.0  
**الحالة:** ✅ نشط ومعتمد
