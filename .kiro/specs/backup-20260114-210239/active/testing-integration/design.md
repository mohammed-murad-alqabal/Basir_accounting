# Design Document - نظام الاختبارات لتطبيق بصير

**المشروع:** بصير MVP  
**التاريخ:** 2 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الإصدار:** 1.1  
**الحالة:** معتمد

---

## Overview

هذا المستند يصف التصميم الشامل لنظام الاختبارات في تطبيق بصير. الهدف هو بناء نظام اختبار قوي وشامل يغطي جميع طبقات التطبيق (Data, Domain, Presentation) لضمان جودة الكود واستقراره. يعتمد التصميم على أفضل الممارسات في اختبارات Flutter ويستخدم مكتبات موثوقة مثل flutter_test و mockito لضمان اختبارات فعالة وقابلة للصيانة.

### الأهداف الرئيسية

1. **تحقيق تغطية 70%+** من الكود بالاختبارات
2. **ضمان استقرار** جميع المكونات الأساسية
3. **تسهيل الصيانة** من خلال اختبارات واضحة
4. **تسريع التطوير** من خلال اكتشاف الأخطاء مبكراً

---

## Architecture

### بنية نظام الاختبارات

```
test/
├── helpers/                    # دوال مساعدة للاختبارات
│   ├── test_helpers.dart      # دوال عامة
│   ├── mock_data.dart         # بيانات اختبار جاهزة
│   └── test_utils.dart        # أدوات مساعدة
├── mocks/                      # Mock objects
│   ├── mock_isar.dart         # Mock لـ Isar
│   ├── mock_secure_storage.dart
│   └── mock_repositories.dart
├── fixtures/                   # بيانات ثابتة للاختبار
│   ├── customer_fixtures.dart
│   └── invoice_fixtures.dart
├── unit/                       # اختبارات الوحدة
│   ├── data/
│   │   ├── models/
│   │   ├── repositories/
│   │   └── services/
│   ├── domain/
│   │   └── entities/
│   └── services/
├── widget/                     # اختبارات الـ Widgets
│   ├── core/
│   │   └── widgets/
│   └── features/
│       └── */presentation/screens/
└── integration/                # اختبارات التكامل (مستقبلية)
```

### مبادئ التصميم

1. **Isolation**: كل اختبار مستقل ولا يعتمد على اختبارات أخرى
2. **Repeatability**: الاختبارات تعطي نفس النتيجة في كل مرة
3. **Fast Execution**: الاختبارات سريعة (< 30 ثانية للكل)
4. **Clear Naming**: أسماء واضحة تصف ما يتم اختباره
5. **AAA Pattern**: Arrange, Act, Assert في كل اختبار

---

## Components and Interfaces

### 1. Test Helpers

#### TestHelpers Class

```dart
class TestHelpers {
  /// إنشاء Isar instance للاختبار في الذاكرة
  static Future<Isar> createTestIsar() async {
    return await Isar.open(
      [CustomerModelSchema, InvoiceModelSchema],
      directory: '',
      name: 'test_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  /// تنظيف قاعدة البيانات بعد الاختبار
  static Future<void> cleanupTestIsar(Isar isar) async {
    await isar.close(deleteFromDisk: true);
  }

  /// إنشاء ProviderContainer للاختبار
  static ProviderContainer createTestContainer({
    List<Override>? overrides,
  }) {
    return ProviderContainer(
      overrides: overrides ?? [],
    );
  }
}
```

#### MockData Class

```dart
class MockData {
  /// عميل اختبار افتراضي
  static Customer createTestCustomer({
    String? id,
    String? name,
  }) {
    return Customer(
      id: id ?? 'test-customer-1',
      name: name ?? 'عميل اختبار',
      phone: '0501234567',
      email: 'test@example.com',
    );
  }

  /// فاتورة اختبار افتراضية
  static Invoice createTestInvoice({
    String? id,
    String? customerId,
  }) {
    return Invoice(
      id: id ?? 'test-invoice-1',
      customerId: customerId ?? 'test-customer-1',
      issuedDate: DateTime.now(),
      dueDate: DateTime.now().add(Duration(days: 30)),
      items: [
        InvoiceItem(
          description: 'منتج اختبار',
          quantity: 1,
          price: 100.0,
        ),
      ],
    );
  }
}
```

### 2. Mock Objects

#### MockSecureStorage

```dart
class MockSecureStorage extends Mock implements FlutterSecureStorage {
  final Map<String, String> _storage = {};

  @override
  Future<void> write({
    required String key,
    required String? value,
  }) async {
    if (value != null) {
      _storage[key] = value;
    }
  }

  @override
  Future<String?> read({required String key}) async {
    return _storage[key];
  }

  @override
  Future<void> delete({required String key}) async {
    _storage.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _storage.clear();
  }
}
```

#### MockCustomerRepository

```dart
class MockCustomerRepository extends Mock implements CustomerRepository {
  final List<Customer> _customers = [];

  @override
  Future<List<Customer>> getAllCustomers() async {
    return List.from(_customers);
  }

  @override
  Future<void> addCustomer(Customer customer) async {
    _customers.add(customer);
  }

  @override
  Future<void> updateCustomer(Customer customer) async {
    final index = _customers.indexWhere((c) => c.id == customer.id);
    if (index != -1) {
      _customers[index] = customer;
    }
  }

  @override
  Future<void> deleteCustomer(String id) async {
    _customers.removeWhere((c) => c.id == id);
  }
}
```

### 3. Fixtures

#### CustomerFixtures

```dart
class CustomerFixtures {
  static final customer1 = Customer(
    id: 'customer-1',
    name: 'أحمد محمد',
    phone: '0501234567',
    email: 'ahmed@example.com',
    address: 'الرياض، السعودية',
  );

  static final customer2 = Customer(
    id: 'customer-2',
    name: 'فاطمة علي',
    phone: '0507654321',
    email: 'fatima@example.com',
  );

  static List<Customer> get allCustomers => [customer1, customer2];
}
```

---

## Data Models

### Test Data Structure

#### Customer Test Data

```dart
{
  "id": "test-customer-1",
  "name": "عميل اختبار",
  "phone": "0501234567",
  "email": "test@example.com",
  "address": "عنوان اختبار"
}
```

#### Invoice Test Data

```dart
{
  "id": "test-invoice-1",
  "customerId": "test-customer-1",
  "customerName": "عميل اختبار",
  "issuedDate": "2025-11-24T00:00:00.000",
  "dueDate": "2025-12-24T00:00:00.000",
  "status": "draft",
  "items": [
    {
      "description": "منتج اختبار",
      "quantity": 1,
      "price": 100.0
    }
  ],
  "subtotal": 100.0,
  "taxRate": 0.15,
  "taxAmount": 15.0,
  "grandTotal": 115.0
}
```

---

## Testing Strategy

### 1. Unit Tests (اختبارات الوحدة)

#### Repositories

**الهدف:** اختبار عمليات CRUD على قاعدة البيانات

**الاستراتيجية:**

- استخدام Isar في الذاكرة
- اختبار كل عملية بشكل منفصل
- التحقق من معالجة الأخطاء

**مثال:**

```dart
group('CustomerRepository', () {
  late Isar isar;
  late CustomerRepositoryImpl repository;

  setUp(() async {
    isar = await TestHelpers.createTestIsar();
    repository = CustomerRepositoryImpl(isar);
  });

  tearDown(() async {
    await TestHelpers.cleanupTestIsar(isar);
  });

  test('should add customer successfully', () async {
    // Arrange
    final customer = MockData.createTestCustomer();

    // Act
    await repository.addCustomer(customer);
    final customers = await repository.getAllCustomers();

    // Assert
    expect(customers.length, 1);
    expect(customers.first.name, customer.name);
  });
});
```

#### Services

**الهدف:** اختبار منطق الأعمال

**الاستراتيجية:**

- استخدام Mock للاعتماديات الخارجية
- اختبار جميع السيناريوهات (نجاح، فشل)
- التحقق من معالجة الأخطاء

**مثال:**

```dart
group('AuthService', () {
  late MockSecureStorage mockStorage;
  late AuthService authService;

  setUp(() {
    mockStorage = MockSecureStorage();
    authService = AuthService(secureStorage: mockStorage);
  });

  test('should register user successfully', () async {
    // Arrange
    const username = 'testuser';
    const password = 'testpass123';

    // Act
    await authService.register(username, password);
    final hasAccount = await authService.hasAccount();

    // Assert
    expect(hasAccount, true);
  });
});
```

#### Models

**الهدف:** اختبار تحويل البيانات والتحقق من الصحة

**الاستراتيجية:**

- اختبار تحويل من/إلى JSON
- اختبار قواعد التحقق
- اختبار الخصائص المحسوبة

**مثال:**

```dart
group('Customer Model', () {
  test('should convert to JSON correctly', () {
    // Arrange
    final customer = CustomerFixtures.customer1;

    // Act
    final json = customer.toJson();

    // Assert
    expect(json['name'], customer.name);
    expect(json['phone'], customer.phone);
  });

  test('should create from JSON correctly', () {
    // Arrange
    final json = {
      'id': 'test-1',
      'name': 'Test Customer',
      'phone': '0501234567',
    };

    // Act
    final customer = Customer.fromJson(json);

    // Assert
    expect(customer.name, json['name']);
    expect(customer.phone, json['phone']);
  });
});
```

### 2. Widget Tests (اختبارات الـ Widgets)

#### Core Widgets

**الهدف:** اختبار المكونات الأساسية

**الاستراتيجية:**

- اختبار العرض الصحيح
- اختبار التفاعلات
- اختبار الحالات المختلفة

**مثال:**

```dart
group('AppButton', () {
  testWidgets('should display text correctly', (tester) async {
    // Arrange
    const buttonText = 'اضغط هنا';

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            text: buttonText,
            onPressed: () {},
          ),
        ),
      ),
    );

    // Assert
    expect(find.text(buttonText), findsOneWidget);
  });

  testWidgets('should call onPressed when tapped', (tester) async {
    // Arrange
    var pressed = false;

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            text: 'Test',
            onPressed: () => pressed = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(AppButton));

    // Assert
    expect(pressed, true);
  });
});
```

#### Screens

**الهدف:** اختبار الشاشات الكاملة

**الاستراتيجية:**

- استخدام Mock Providers
- اختبار عرض البيانات
- اختبار التفاعلات الأساسية

**مثال:**

```dart
group('CustomersScreen', () {
  testWidgets('should display list of customers', (tester) async {
    // Arrange
    final mockRepository = MockCustomerRepository();
    mockRepository._customers.addAll(CustomerFixtures.allCustomers);

    final container = TestHelpers.createTestContainer(
      overrides: [
        customerRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );

    // Act
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: CustomersScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Assert
    expect(find.text('أحمد محمد'), findsOneWidget);
    expect(find.text('فاطمة علي'), findsOneWidget);
  });
});
```

### 3. Provider Tests (اختبارات الـ Providers)

**الهدف:** اختبار إدارة الحالة

**الاستراتيجية:**

- استخدام Mock Repository
- اختبار تحميل البيانات
- اختبار تحديث الحالة
- التحقق من إشعار المستمعين

**مثال:**

```dart
group('CustomerProvider', () {
  test('should load customers successfully', () async {
    // Arrange
    final mockRepository = MockCustomerRepository();
    mockRepository._customers.addAll(CustomerFixtures.allCustomers);

    final container = TestHelpers.createTestContainer(
      overrides: [
        customerRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );

    // Act
    final customers = await container.read(customersProvider.future);

    // Assert
    expect(customers.length, 2);
  });
});
```

---

## Correctness Properties

_A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees._

### Property 1: Repository CRUD Completeness

_For any_ Repository implementation, all CRUD operations (Create, Read, Update, Delete) should work correctly and maintain data integrity.

**Validates: Requirements 1.1, 1.2**

**Test Strategy:**

- Create: Adding an entity should increase collection size by 1
- Read: Retrieved entities should match stored entities
- Update: Modified entities should reflect changes
- Delete: Removed entities should not be retrievable

### Property 2: Mock Isolation

_For any_ test using external dependencies (Secure Storage, Isar), the test should use mocks and not depend on the actual system.

**Validates: Requirements 2.3, 2.4**

**Test Strategy:**

- All tests using FlutterSecureStorage use MockSecureStorage
- All tests using Isar use in-memory database
- No test should fail due to external system unavailability

### Property 3: Widget Interaction Consistency

_For any_ interactive widget, all user interactions should trigger the expected callbacks and state changes.

**Validates: Requirements 3.2, 3.4**

**Test Strategy:**

- Button taps trigger onPressed callbacks
- Text field inputs update state correctly
- All interactive elements respond to user actions

### Property 4: Test Data Availability

_For any_ test requiring data, fixtures and mock data should be readily available without manual creation.

**Validates: Requirements 4.2, 4.4**

**Test Strategy:**

- Helper functions provide test data easily
- Fixtures cover common test scenarios
- Mock objects are reusable across tests

### Property 5: Test Execution Speed

_For any_ test suite execution, the total time should be less than 30 seconds.

**Validates: Requirements 5.1**

**Test Strategy:**

- Individual tests complete in < 100ms
- Use of in-memory databases
- Parallel test execution where possible

### Property 6: Provider State Management

_For any_ Provider state change, all listeners should be notified correctly.

**Validates: Requirements 6.4**

**Test Strategy:**

- State changes trigger listener notifications
- AsyncValue states (loading, data, error) work correctly
- Provider rebuilds happen when expected

### Property 7: Model Serialization Round-Trip

_For any_ model with JSON serialization, converting to JSON and back should produce an equivalent object.

**Validates: Requirements 7.1, 7.2**

**Test Strategy:**

- Customer: `fromJson(toJson(customer)) == customer`
- Invoice: `fromJson(toJson(invoice)) == invoice`
- All fields preserved through serialization

### Property 8: Screen Navigation Consistency

_For any_ screen with navigation, navigating to another screen should work correctly and maintain state.

**Validates: Requirements 8.4**

**Test Strategy:**

- Navigation actions trigger route changes
- Back navigation works correctly
- Screen state is preserved when appropriate

### Property 9: Error Handling Completeness

_For any_ service operation that can fail, errors should be handled gracefully with appropriate messages.

**Validates: Requirements 9.3**

**Test Strategy:**

- Failed operations throw appropriate exceptions
- Error messages are clear and actionable
- System remains stable after errors

### Property 10: Test Coverage Threshold

_For any_ code module, test coverage should meet or exceed the defined thresholds (70% overall, 100% for critical components).

**Validates: Requirements 5.3**

**Test Strategy:**

- Repositories: 100% coverage
- Services: 100% coverage
- Models: 100% coverage
- Widgets: ≥ 80% coverage
- Providers: ≥ 90% coverage

---

## Error Handling

### استراتيجية معالجة الأخطاء في الاختبارات

1. **Database Errors**

   - اختبار فشل الاتصال
   - اختبار فشل العمليات
   - التحقق من رسائل الخطأ

2. **Validation Errors**

   - اختبار البيانات غير الصحيحة
   - اختبار القيم الفارغة
   - اختبار القيود

3. **Network Errors** (مستقبلي)
   - اختبار انقطاع الاتصال
   - اختبار timeout
   - اختبار استجابات الخطأ

### مثال على اختبار معالجة الأخطاء

```dart
test('should throw exception when adding invalid customer', () async {
  // Arrange
  final repository = CustomerRepositoryImpl(isar);
  final invalidCustomer = Customer(
    id: '',  // Invalid: empty ID
    name: '',  // Invalid: empty name
    phone: '',
  );

  // Act & Assert
  expect(
    () => repository.addCustomer(invalidCustomer),
    throwsA(isA<ValidationException>()),
  );
});
```

---

## Testing Tools and Libraries

### المكتبات المستخدمة

| المكتبة              | الإصدار  | الاستخدام             |
| -------------------- | -------- | --------------------- |
| **flutter_test**     | SDK      | إطار الاختبار الأساسي |
| **mockito**          | ^5.4.0   | إنشاء Mock objects    |
| **build_runner**     | ^2.4.0   | توليد Mocks           |
| **flutter_riverpod** | ^2.4.0   | اختبار Providers      |
| **isar**             | ^3.1.0+1 | قاعدة بيانات الاختبار |

### إضافة المكتبات إلى pubspec.yaml

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.0
  build_runner: ^2.4.0
```

### أوامر الاختبار

```bash
# تشغيل جميع الاختبارات
flutter test

# تشغيل اختبارات محددة
flutter test test/unit/data/repositories/

# تشغيل مع تقرير التغطية
flutter test --coverage

# عرض تقرير التغطية
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## Performance Considerations

### تحسين أداء الاختبارات

1. **استخدام setUpAll و tearDownAll**

   - لتهيئة موارد مشتركة مرة واحدة
   - تقليل وقت التنفيذ

2. **Parallel Execution**

   - تشغيل الاختبارات بالتوازي
   - استخدام `flutter test --concurrency=4`

3. **In-Memory Database**

   - استخدام Isar في الذاكرة
   - تجنب عمليات القرص البطيئة

4. **Minimal Widget Trees**
   - استخدام أقل عدد من الـ widgets
   - تجنب بناء شجرة كاملة إذا لم تكن ضرورية

### الأهداف المستهدفة

- **وقت تشغيل الاختبارات:** < 30 ثانية
- **وقت اختبار واحد:** < 100ms
- **استهلاك الذاكرة:** < 500MB

---

## CI/CD Integration

### GitHub Actions Workflow

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.24.0"

      - name: Install dependencies
        run: flutter pub get

      - name: Run tests
        run: flutter test --coverage

      - name: Check coverage
        run: |
          COVERAGE=$(lcov --summary coverage/lcov.info | grep lines | awk '{print $2}' | sed 's/%//')
          if (( $(echo "$COVERAGE < 70" | bc -l) )); then
            echo "Coverage is below 70%: $COVERAGE%"
            exit 1
          fi

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info
```

---

## Documentation Standards

### تعليقات الاختبارات

```dart
/// اختبار إضافة عميل جديد
///
/// يتحقق من:
/// - إضافة العميل إلى قاعدة البيانات
/// - استرجاع العميل بنجاح
/// - صحة البيانات المحفوظة
test('should add customer successfully', () async {
  // ...
});
```

### تسمية الاختبارات

**القاعدة:** `should [expected behavior] when [condition]`

**أمثلة:**

- `should add customer successfully when valid data provided`
- `should throw exception when invalid data provided`
- `should return empty list when no customers exist`

---

## Next Steps

### المرحلة 1: الأساسيات (أسبوع 1)

1. إعداد البنية التحتية
2. إنشاء Helpers و Mocks
3. اختبارات Models
4. اختبارات Repositories

### المرحلة 2: منطق الأعمال (أسبوع 2)

5. اختبارات Services
6. اختبارات Providers

### المرحلة 3: الواجهات (أسبوع 3)

7. اختبارات Widgets
8. اختبارات Screens

### المرحلة 4: التكامل (أسبوع 4)

9. إعداد CI/CD
10. تحقيق التغطية المستهدفة
11. اختبارات الخدمات الإضافية

---

**تم إعداد هذا المستند بواسطة:** فريق وكلاء تطوير مشروع بصير  
**آخر تحديث:** 2 ديسمبر 2025  
**الحالة:** ✅ معتمد ونشط
