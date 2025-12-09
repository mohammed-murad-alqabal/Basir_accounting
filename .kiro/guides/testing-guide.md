# دليل الاختبارات الكامل

**المشروع:** بصير MVP  
**التاريخ:** 8 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ نشط

---

## 🎯 نظرة عامة

هذا الدليل يحتوي على جميع معايير وأفضل ممارسات الاختبارات في مشروع بصير MVP.

**الهدف:** تغطية 70%+ من الكود باختبارات شاملة ✅

---

## 📊 أنواع الاختبارات

### 1. Unit Tests

**الهدف:** اختبار الدوال والـ Classes المعزولة

**التغطية:** 70%+  
**السرعة:** سريعة جداً (< 1 ثانية)  
**الموقع:** `test/unit/`

**متى تستخدم:**

- اختبار Repository
- اختبار Services
- اختبار Validators
- اختبار Utils
- اختبار Business Logic

### 2. Widget Tests

**الهدف:** اختبار الـ Widgets

**التغطية:** المسارات الحرجة  
**السرعة:** سريعة (< 5 ثواني)  
**الموقع:** `test/widget/`

**متى تستخدم:**

- اختبار UI Components
- اختبار User Interactions
- اختبار State Changes
- اختبار Navigation

### 3. Integration Tests

**الهدف:** اختبار التدفقات الكاملة

**التغطية:** رحلات المستخدم  
**السرعة:** متوسطة (< 30 ثانية)  
**الموقع:** `integration_test/`

**متى تستخدم:**

- اختبار User Journeys
- اختبار End-to-End Flows
- اختبار API Integration
- اختبار Database Integration

---

## 🧪 Unit Tests

### البنية الأساسية

```dart
void main() {
  group('CustomerRepository', () {
    late Isar isar;
    late CustomerRepository repository;

    setUp(() async {
      // إعداد قبل كل اختبار
      isar = await Isar.open(
        [CustomerModelSchema],
        directory: '',
        name: 'test_${DateTime.now().millisecondsSinceEpoch}',
      );
      repository = CustomerRepositoryImpl(isar);
    });

    tearDown(() async {
      // تنظيف بعد كل اختبار
      await isar.close(deleteFromDisk: true);
    });

    test('should add customer successfully', () async {
      // Arrange
      final customer = Customer(
        id: 'test-1',
        name: 'أحمد محمد',
        phone: '0501234567',
      );

      // Act
      await repository.addCustomer(customer);
      final customers = await repository.getAllCustomers();

      // Assert
      expect(customers.length, 1);
      expect(customers.first.name, 'أحمد محمد');
    });
  });
}
```

### Arrange-Act-Assert Pattern

```dart
test('should calculate invoice total correctly', () {
  // Arrange - إعداد البيانات
  final items = [
    InvoiceItem(name: 'Item 1', price: 100, quantity: 2),
    InvoiceItem(name: 'Item 2', price: 50, quantity: 1),
  ];
  final invoice = Invoice(items: items, taxRate: 0.15);

  // Act - تنفيذ العملية
  final total = invoice.calculateTotal();

  // Assert - التحقق من النتيجة
  expect(total, 287.5); // (100*2 + 50*1) * 1.15
});
```

### اختبار الحالات الاستثنائية

```dart
group('CustomerRepository - Error Cases', () {
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
```

### Mocking مع Mockito

```dart
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([CustomerRepository])
void main() {
  group('CustomersNotifier', () {
    late MockCustomerRepository mockRepository;
    late CustomersNotifier notifier;

    setUp(() {
      mockRepository = MockCustomerRepository();
      notifier = CustomersNotifier(mockRepository);
    });

    test('should load customers successfully', () async {
      // Arrange
      final customers = [
        Customer(id: '1', name: 'أحمد', phone: '0501234567'),
        Customer(id: '2', name: 'محمد', phone: '0509876543'),
      ];

      when(mockRepository.getAllCustomers())
          .thenAnswer((_) async => customers);

      // Act
      await notifier.loadCustomers();

      // Assert
      expect(notifier.state, AsyncValue.data(customers));
      verify(mockRepository.getAllCustomers()).called(1);
    });

    test('should handle error when loading customers', () async {
      // Arrange
      when(mockRepository.getAllCustomers())
          .thenThrow(Exception('Database error'));

      // Act
      await notifier.loadCustomers();

      // Assert
      expect(notifier.state.hasError, true);
      verify(mockRepository.getAllCustomers()).called(1);
    });
  });
}
```

---

## 🎨 Widget Tests

### البنية الأساسية

```dart
void main() {
  testWidgets('CustomerCard displays customer info', (tester) async {
    // Arrange
    final customer = Customer(
      id: 'test-1',
      name: 'أحمد محمد',
      phone: '0501234567',
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomerCard(customer: customer),
        ),
      ),
    );

    // Assert
    expect(find.text('أحمد محمد'), findsOneWidget);
    expect(find.text('0501234567'), findsOneWidget);
  });
}
```

### اختبار User Interactions

```dart
testWidgets('should add customer when button pressed', (tester) async {
  // Arrange
  await tester.pumpWidget(
    MaterialApp(
      home: AddCustomerScreen(),
    ),
  );

  // Act - إدخال البيانات
  await tester.enterText(
    find.byKey(Key('name_field')),
    'أحمد محمد',
  );
  await tester.enterText(
    find.byKey(Key('phone_field')),
    '0501234567',
  );

  // Act - الضغط على الزر
  await tester.tap(find.byKey(Key('save_button')));
  await tester.pumpAndSettle();

  // Assert
  expect(find.text('تم إضافة العميل بنجاح'), findsOneWidget);
});
```

### اختبار Navigation

```dart
testWidgets('should navigate to details screen', (tester) async {
  // Arrange
  await tester.pumpWidget(
    MaterialApp(
      home: CustomersListScreen(),
      routes: {
        '/details': (context) => CustomerDetailsScreen(),
      },
    ),
  );

  // Act
  await tester.tap(find.byType(CustomerCard).first);
  await tester.pumpAndSettle();

  // Assert
  expect(find.byType(CustomerDetailsScreen), findsOneWidget);
});
```

### اختبار Async Operations

```dart
testWidgets('should show loading indicator', (tester) async {
  // Arrange
  await tester.pumpWidget(
    MaterialApp(
      home: CustomersListScreen(),
    ),
  );

  // Assert - loading state
  expect(find.byType(CircularProgressIndicator), findsOneWidget);

  // Act - wait for data
  await tester.pumpAndSettle();

  // Assert - data loaded
  expect(find.byType(CircularProgressIndicator), findsNothing);
  expect(find.byType(CustomerCard), findsWidgets);
});
```

### اختبار مع Riverpod

```dart
testWidgets('should display customers from provider', (tester) async {
  // Arrange
  final customers = [
    Customer(id: '1', name: 'أحمد', phone: '0501234567'),
    Customer(id: '2', name: 'محمد', phone: '0509876543'),
  ];

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        customersProvider.overrideWith((ref) => customers),
      ],
      child: MaterialApp(
        home: CustomersListScreen(),
      ),
    ),
  );

  // Assert
  expect(find.text('أحمد'), findsOneWidget);
  expect(find.text('محمد'), findsOneWidget);
});
```

---

## 🔄 Integration Tests

### البنية الأساسية

```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Customer Journey', () {
    testWidgets('should complete full customer flow', (tester) async {
      // Arrange
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      // Act 1 - Navigate to add customer
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Act 2 - Fill form
      await tester.enterText(
        find.byKey(Key('name_field')),
        'أحمد محمد',
      );
      await tester.enterText(
        find.byKey(Key('phone_field')),
        '0501234567',
      );

      // Act 3 - Save
      await tester.tap(find.byKey(Key('save_button')));
      await tester.pumpAndSettle();

      // Assert 1 - Success message
      expect(find.text('تم إضافة العميل بنجاح'), findsOneWidget);

      // Assert 2 - Customer in list
      expect(find.text('أحمد محمد'), findsOneWidget);

      // Act 4 - View details
      await tester.tap(find.text('أحمد محمد'));
      await tester.pumpAndSettle();

      // Assert 3 - Details screen
      expect(find.text('0501234567'), findsOneWidget);
    });
  });
}
```

### اختبار Database Integration

```dart
testWidgets('should persist data across app restarts', (tester) async {
  // Act 1 - Add customer
  await tester.pumpWidget(MyApp());
  await tester.pumpAndSettle();

  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();

  await tester.enterText(find.byKey(Key('name_field')), 'أحمد');
  await tester.tap(find.byKey(Key('save_button')));
  await tester.pumpAndSettle();

  // Act 2 - Restart app
  await tester.pumpWidget(MyApp());
  await tester.pumpAndSettle();

  // Assert - Data persisted
  expect(find.text('أحمد'), findsOneWidget);
});
```

---

## 📈 Coverage

### تشغيل Coverage

```bash
# تشغيل الاختبارات مع coverage
flutter test --coverage

# عرض التقرير
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Coverage Goals

| المكون         | الهدف |
| :------------- | :---: |
| **Repository** | 90%+  |
| **Services**   | 85%+  |
| **Validators** | 95%+  |
| **Utils**      | 90%+  |
| **Widgets**    | 70%+  |
| **Screens**    | 60%+  |
| **Overall**    | 70%+  |

### تحسين Coverage

```dart
// ❌ خطأ - كود غير مختبر
class CustomerService {
  Future<void> addCustomer(Customer customer) async {
    // لا اختبارات!
    await repository.add(customer);
  }
}

// ✅ صحيح - كود مختبر
class CustomerService {
  Future<void> addCustomer(Customer customer) async {
    await repository.add(customer);
  }
}

// test
test('should add customer', () async {
  await service.addCustomer(customer);
  verify(mockRepository.add(customer)).called(1);
});
```

---

## 🎯 أفضل الممارسات

### 1. اختبارات مستقلة

```dart
// ✅ صحيح - اختبارات مستقلة
test('test 1', () {
  final data = createTestData();
  // test logic
});

test('test 2', () {
  final data = createTestData();
  // test logic
});

// ❌ خطأ - اختبارات تعتمد على بعضها
var sharedData;

test('test 1', () {
  sharedData = createTestData();
  // test logic
});

test('test 2', () {
  // يعتمد على test 1!
  expect(sharedData, isNotNull);
});
```

### 2. أسماء واضحة

```dart
// ✅ صحيح
test('should add customer successfully when valid data provided', () {
  // ...
});

test('should throw ValidationException when name is empty', () {
  // ...
});

// ❌ خطأ
test('test 1', () {
  // ...
});

test('customer test', () {
  // ...
});
```

### 3. استخدام Matchers

```dart
// ✅ صحيح - استخدام matchers مناسبة
expect(result, isNotNull);
expect(customers.length, equals(2));
expect(customers, contains(customer));
expect(() => validate(''), throwsException);
expect(future, completes);

// ❌ خطأ - استخدام == فقط
expect(result != null, true);
expect(customers.length == 2, true);
```

### 4. Setup و Teardown

```dart
group('CustomerRepository', () {
  late Isar isar;
  late CustomerRepository repository;

  setUp(() async {
    // إعداد قبل كل اختبار
    isar = await Isar.open([CustomerModelSchema]);
    repository = CustomerRepositoryImpl(isar);
  });

  tearDown(() async {
    // تنظيف بعد كل اختبار
    await isar.close(deleteFromDisk: true);
  });

  // tests...
});
```

### 5. Test Data Builders

```dart
class CustomerBuilder {
  String id = 'test-1';
  String name = 'أحمد محمد';
  String phone = '0501234567';
  String? email;
  String? address;

  CustomerBuilder withId(String id) {
    this.id = id;
    return this;
  }

  CustomerBuilder withName(String name) {
    this.name = name;
    return this;
  }

  CustomerBuilder withPhone(String phone) {
    this.phone = phone;
    return this;
  }

  Customer build() {
    return Customer(
      id: id,
      name: name,
      phone: phone,
      email: email,
      address: address,
    );
  }
}

// استخدام
test('should add customer', () {
  final customer = CustomerBuilder()
      .withName('محمد')
      .withPhone('0509876543')
      .build();

  // test logic
});
```

---

## ❌ الأخطاء الشائعة

### 1. اختبارات بطيئة

```dart
// ❌ خطأ - اختبار بطيء
test('should wait', () async {
  await Future.delayed(Duration(seconds: 5));
  expect(true, true);
});

// ✅ صحيح - اختبار سريع
test('should complete quickly', () {
  expect(true, true);
});
```

### 2. اختبارات تعتمد على الترتيب

```dart
// ❌ خطأ
var counter = 0;

test('test 1', () {
  counter++;
  expect(counter, 1);
});

test('test 2', () {
  counter++;
  expect(counter, 2); // يعتمد على test 1!
});

// ✅ صحيح
test('test 1', () {
  var counter = 0;
  counter++;
  expect(counter, 1);
});

test('test 2', () {
  var counter = 0;
  counter++;
  expect(counter, 1);
});
```

### 3. عدم تنظيف الموارد

```dart
// ❌ خطأ
test('should use database', () async {
  final isar = await Isar.open([CustomerModelSchema]);
  // test logic
  // لم يتم إغلاق isar!
});

// ✅ صحيح
test('should use database', () async {
  final isar = await Isar.open([CustomerModelSchema]);
  try {
    // test logic
  } finally {
    await isar.close(deleteFromDisk: true);
  }
});
```

---

## 🚀 CI/CD Integration

### GitHub Actions

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.24.0"

      - name: Install dependencies
        run: flutter pub get

      - name: Run tests
        run: flutter test --coverage

      - name: Upload coverage
        uses: codecov/codecov-action@v2
        with:
          file: coverage/lcov.info
```

---

## 📚 المراجع

### الوثائق الرسمية

- [Flutter Testing](https://flutter.dev/docs/testing)
- [Mockito](https://pub.dev/packages/mockito)
- [Integration Testing](https://flutter.dev/docs/testing/integration-tests)

### المعايير الداخلية

- `.kiro/steering/standards/testing.md` - معايير الاختبارات المختصرة
- `.kiro/steering/standards/code-quality.md` - معايير الجودة
- `.kiro/steering/reference/examples.md` - أمثلة تفصيلية

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 8 ديسمبر 2025  
**الإصدار:** 1.0  
**الحالة:** ✅ نشط ومعتمد
