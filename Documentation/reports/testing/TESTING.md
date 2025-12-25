# دليل الاختبارات - بصير MVP

**المشروع:** بصير MVP  
**التاريخ:** 2 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الإصدار:** 1.0  
**الحالة:** ✅ نشط ومعتمد

---

## 📋 المحتويات

- [نظرة عامة](#نظرة-عامة)
- [بنية الاختبارات](#بنية-الاختبارات)
- [أنواع الاختبارات](#أنواع-الاختبارات)
- [تشغيل الاختبارات](#تشغيل-الاختبارات)
- [كتابة اختبارات جديدة](#كتابة-اختبارات-جديدة)
- [Best Practices](#best-practices)
- [CI/CD Integration](#cicd-integration)
- [استكشاف الأخطاء](#استكشاف-الأخطاء)

---

## نظرة عامة

يستخدم مشروع بصير استراتيجية اختبار شاملة تغطي جميع طبقات التطبيق:

### الإحصائيات الحالية

| المقياس               | القيمة | الهدف |
| :-------------------- | :----- | :---- |
| **إجمالي الاختبارات** | 497    | -     |
| **معدل النجاح**       | 100%   | 100%  |
| **التغطية**           | ~53%   | ≥70%  |
| **وقت التشغيل**       | ~15s   | <30s  |

### الأهداف

- ✅ **تغطية شاملة** - اختبار جميع المكونات الحيوية
- ✅ **سرعة عالية** - اختبارات سريعة وفعالة
- ✅ **موثوقية** - معدل نجاح 100%
- 🔄 **تحسين مستمر** - الوصول إلى 70%+ تغطية

---

## بنية الاختبارات

### التنظيم الهيكلي

```
test/
├── helpers/                    # أدوات مساعدة للاختبارات
│   ├── test_helpers.dart      # دوال مساعدة عامة
│   └── mock_data.dart         # بيانات اختبار نموذجية
│
├── mocks/                      # Mock Objects
│   ├── mock_secure_storage.dart
│   ├── mock_customer_repository.dart
│   └── mock_invoice_repository.dart
│
├── fixtures/                   # بيانات ثابتة للاختبار
│   ├── customer_fixtures.dart
│   └── invoice_fixtures.dart
│
├── unit/                       # اختبارات الوحدة
│   ├── data/
│   │   ├── models/            # اختبارات Models
│   │   ├── repositories/      # اختبارات Repositories
│   │   └── services/          # اختبارات Services
│   └── presentation/
│       └── providers/         # اختبارات Providers
│
├── widget/                     # اختبارات الواجهات
│   ├── core/
│   │   └── widgets/          # اختبارات Core Widgets
│   └── features/
│       ├── customers/        # اختبارات شاشات العملاء
│       ├── invoices/         # اختبارات شاشات الفواتير
│       └── dashboard/        # اختبارات لوحة التحكم
│
└── run_tests.sh               # سكريبت تشغيل الاختبارات
```

### المبادئ الأساسية

1. **Test Mirroring** - بنية test/ تطابق lib/
2. **Isolation** - كل اختبار مستقل
3. **Clarity** - أسماء واضحة ووصفية
4. **Speed** - اختبارات سريعة التنفيذ

---

## أنواع الاختبارات

### 1. Unit Tests (اختبارات الوحدة)

**الهدف:** اختبار الوحدات المعزولة (Functions, Classes)

**الموقع:** `test/unit/`

**الأمثلة:**

- Models (Customer, Invoice)
- Repositories (CustomerRepository, InvoiceRepository)
- Services (AuthService, SettingsService, PDFService)
- Providers (CustomerProvider, InvoiceProvider)

**مثال:**

```dart
void main() {
  group('CustomerRepository', () {
    late Isar isar;
    late CustomerRepository repository;

    setUp(() async {
      isar = await TestHelpers.createTestIsar();
      repository = CustomerRepository(isar);
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
}
```

### 2. Widget Tests (اختبارات الواجهات)

**الهدف:** اختبار الـ Widgets والتفاعلات

**الموقع:** `test/widget/`

**الأمثلة:**

- Core Widgets (AppButton, AppCard, AppTextField)
- Screens (CustomersScreen, InvoicesScreen, DashboardScreen)

**مثال:**

```dart
void main() {
  testWidgets('AppButton displays text correctly', (tester) async {
    // Arrange
    const buttonText = 'اضغط هنا';
    var pressed = false;

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            text: buttonText,
            onPressed: () => pressed = true,
          ),
        ),
      ),
    );

    // Assert
    expect(find.text(buttonText), findsOneWidget);

    // Act - Tap button
    await tester.tap(find.text(buttonText));
    await tester.pump();

    // Assert
    expect(pressed, true);
  });
}
```

### 3. Integration Tests (اختبارات التكامل)

**الهدف:** اختبار التدفقات الكاملة

**الموقع:** `test/integration/` (قيد التطوير)

**الأمثلة:**

- User flows (تسجيل دخول → إضافة عميل → إنشاء فاتورة)
- End-to-end scenarios

---

## تشغيل الاختبارات

### الطريقة السريعة (باستخدام السكريبت)

```bash
# تشغيل جميع الاختبارات
./test/run_tests.sh

# تشغيل مع تقرير التغطية
./test/run_tests.sh --coverage

# تشغيل وفتح تقرير التغطية
./test/run_tests.sh --coverage --open

# عرض المساعدة
./test/run_tests.sh --help
```

### الطريقة اليدوية

```bash
# تشغيل جميع الاختبارات
flutter test

# تشغيل اختبارات محددة
flutter test test/unit/data/models/
flutter test test/widget/core/widgets/

# تشغيل اختبار واحد
flutter test test/unit/data/models/customer_model_test.dart

# تشغيل مع التغطية
flutter test --coverage

# تشغيل مع reporter محدد
flutter test --reporter expanded
flutter test --reporter json
```

### توليد تقرير التغطية

```bash
# توليد HTML report
genhtml coverage/lcov.info -o coverage/html

# فتح التقرير
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
```

---

## كتابة اختبارات جديدة

### 1. اختبار Model جديد

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:basser_app/data/models/your_model.dart';

void main() {
  group('YourModel', () {
    test('should create model with correct values', () {
      // Arrange
      const id = 'test-id';
      const name = 'Test Name';

      // Act
      final model = YourModel(id: id, name: name);

      // Assert
      expect(model.id, id);
      expect(model.name, name);
    });

    test('should convert to entity correctly', () {
      // Arrange
      final model = YourModel(id: 'test-id', name: 'Test');

      // Act
      final entity = model.toEntity();

      // Assert
      expect(entity.id, model.id);
      expect(entity.name, model.name);
    });
  });
}
```

### 2. اختبار Repository جديد

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('YourRepository', () {
    late Isar isar;
    late YourRepository repository;

    setUp(() async {
      isar = await TestHelpers.createTestIsar();
      repository = YourRepository(isar);
    });

    tearDown(() async {
      await TestHelpers.cleanupTestIsar(isar);
    });

    test('should add item successfully', () async {
      // Test implementation
    });
  });
}
```

### 3. اختبار Widget جديد

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('YourWidget displays correctly', (tester) async {
    // Arrange
    const testText = 'Test Text';

    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: YourWidget(text: testText),
        ),
      ),
    );

    // Assert
    expect(find.text(testText), findsOneWidget);
  });
}
```

### 4. اختبار Provider جديد

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('YourProvider', () {
    test('should load data successfully', () async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act
      final provider = container.read(yourProvider.notifier);
      await provider.loadData();

      // Assert
      final state = container.read(yourProvider);
      expect(state.hasValue, true);
    });
  });
}
```

---

## Best Practices

### 1. التسمية

```dart
// ✅ جيد - واضح ووصفي
test('should add customer successfully when valid data provided')

// ❌ سيء - غير واضح
test('add customer')
```

### 2. البنية (AAA Pattern)

```dart
test('description', () {
  // Arrange - إعداد البيانات
  final customer = Customer(id: '1', name: 'Test');

  // Act - تنفيذ الإجراء
  final result = repository.addCustomer(customer);

  // Assert - التحقق من النتيجة
  expect(result, isNotNull);
});
```

### 3. الاستقلالية

```dart
// ✅ جيد - كل اختبار مستقل
setUp(() async {
  isar = await TestHelpers.createTestIsar();
});

tearDown(() async {
  await TestHelpers.cleanupTestIsar(isar);
});

// ❌ سيء - اختبارات تعتمد على بعضها
```

### 4. استخدام Mocks

```dart
// ✅ جيد - استخدام mocks للتبعيات الخارجية
final mockRepository = MockCustomerRepository();
when(mockRepository.getAllCustomers())
    .thenAnswer((_) async => [customer1, customer2]);

// ❌ سيء - استخدام تبعيات حقيقية في unit tests
```

### 5. التغطية

```dart
// ✅ جيد - اختبار الحالات الطبيعية والاستثنائية
test('should add customer successfully');
test('should throw exception when customer is null');
test('should throw exception when customer ID is empty');

// ❌ سيء - اختبار الحالة الطبيعية فقط
```

### 6. السرعة

```dart
// ✅ جيد - اختبارات سريعة
test('should validate email format', () {
  expect(Validators.isValidEmail('test@example.com'), true);
});

// ❌ سيء - اختبارات بطيئة
test('should process large dataset', () async {
  // معالجة ملايين السجلات
});
```

---

## CI/CD Integration

### GitHub Actions Workflow

يتم تشغيل الاختبارات تلقائياً عند:

- Push إلى main أو develop
- فتح Pull Request
- التشغيل اليدوي (workflow_dispatch)

### Quality Gates

يجب أن تنجح جميع الفحوصات التالية:

1. ✅ **Code Analysis** - `flutter analyze`
2. ✅ **All Tests Pass** - `flutter test`
3. ✅ **Coverage ≥ 70%** - فحص التغطية
4. ✅ **No Security Issues** - فحص الأمان
5. ✅ **APK Size < 50 MB** - فحص حجم التطبيق

### الملفات ذات الصلة

- `.github/workflows/flutter_ci.yml` - Workflow الرئيسي
- `test/run_tests.sh` - سكريبت محلي

---

## استكشاف الأخطاء

### مشكلة: الاختبارات تفشل محلياً ولكن تنجح في CI

**الحل:**

```bash
# تنظيف وإعادة البناء
flutter clean
flutter pub get
flutter test
```

### مشكلة: Isar database locked

**الحل:**

```dart
// تأكد من إغلاق قاعدة البيانات في tearDown
tearDown(() async {
  await isar.close(deleteFromDisk: true);
});
```

### مشكلة: Widget tests تفشل بسبب missing MaterialApp

**الحل:**

```dart
await tester.pumpWidget(
  const MaterialApp(  // ✅ إضافة MaterialApp
    home: Scaffold(
      body: YourWidget(),
    ),
  ),
);
```

### مشكلة: Async tests لا تنتهي

**الحل:**

```dart
test('async test', () async {  // ✅ إضافة async
  await repository.addCustomer(customer);  // ✅ إضافة await
  // ...
});
```

### مشكلة: Coverage report لا يتم توليده

**الحل:**

```bash
# تثبيت lcov
# macOS
brew install lcov

# Linux
sudo apt-get install lcov

# توليد التقرير
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

---

## الموارد الإضافية

### الوثائق الرسمية

- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)

### الوثائق الداخلية

- [CODING_STANDARDS.md](../../Core/CODING_STANDARDS.md) - معايير الكود
- [DEVELOPMENT_GUIDE.md](../../Core/CODING_STANDARDS.md) - دليل التطوير
- [../../../.kiro/steering/testing-best-practices.md](../../../.kiro/steering/testing-best-practices.md) - أفضل الممارسات

### أمثلة في المشروع

- `test/unit/data/models/` - أمثلة اختبارات Models
- `test/unit/data/repositories/` - أمثلة اختبارات Repositories
- `test/widget/core/widgets/` - أمثلة اختبارات Widgets

---

## الخلاصة

### الإحصائيات الحالية

- ✅ **497 اختبار ناجح** (معدل نجاح 100%)
- 🔄 **~53% تغطية** (الهدف: ≥70%)
- ✅ **CI/CD نشط** (GitHub Actions)
- ✅ **Quality Gates مفعّلة**

### الخطوات التالية

1. 🎯 **تحسين التغطية** - الوصول إلى 70%+
2. 📝 **إضافة Integration Tests**
3. 🔄 **تحسين سرعة الاختبارات**
4. 📊 **مراقبة مستمرة للجودة**

---

**تم إعداد هذه الوثيقة بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 2 ديسمبر 2025  
**الإصدار:** 1.0  
**الحالة:** ✅ نشط ومعتمد
