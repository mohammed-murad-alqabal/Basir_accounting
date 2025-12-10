# أفضل الممارسات - مرجع شامل

**المشروع:** بصير MVP  
**التاريخ:** 7 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ نشط

---

## نظرة عامة

هذا الملف يحتوي على أفضل الممارسات التفصيلية لجميع جوانب المشروع.

---

## الفهرس

1. [Flutter Best Practices](#flutter-best-practices)
2. [Git Best Practices](#git-best-practices)
3. [Security Best Practices](#security-best-practices)
4. [Testing Best Practices](#testing-best-practices)
5. [Documentation Best Practices](#documentation-best-practices)
6. [Performance Best Practices](#performance-best-practices)

---

## Flutter Best Practices

### 1. بنية المشروع

#### Feature-First Organization

```
lib/
├── core/          # المكونات المشتركة
├── features/      # الميزات (Feature-First)
└── data/          # طبقة البيانات
```

**الفوائد:**

- سهولة العثور على الكود
- تقليل الاعتماديات
- تسهيل العمل الجماعي

#### Clean Architecture

- **Presentation Layer**: UI فقط
- **Domain Layer**: منطق الأعمال
- **Data Layer**: الوصول للبيانات

### 2. إدارة الحالة

#### استخدام Riverpod

```dart
// ✅ صحيح - Provider محدد وواضح
@riverpod
class CustomersNotifier extends _$CustomersNotifier {
  @override
  Future<List<Customer>> build() async {
    final repository = ref.watch(customerRepositoryProvider);
    return repository.getAllCustomers();
  }
}

// استخدام Provider
final customers = ref.watch(customersNotifierProvider);
```

### 3. قاعدة البيانات

#### Isar Best Practices

```dart
// ✅ استخدام Transactions
await isar.writeTxn(() async {
  await isar.customerModels.put(customer);
});

// ✅ إغلاق الاتصالات
await isar.close();

// ✅ استخدام Indexes
@Index()
final String name;
```

### 4. الأداء

#### Const Constructors

```dart
// ✅ استخدام const
const Text('مرحباً')
const Icon(Icons.add)
const SizedBox(height: 16)
```

#### Lazy Loading

```dart
// ✅ ListView.builder للقوائم الطويلة
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ItemCard(item: items[index]);
  },
)
```

### 5. معالجة الأخطاء

#### Async Error Handling

```dart
// ✅ معالجة شاملة للأخطاء
Future<void> loadData() async {
  state = const AsyncValue.loading();

  try {
    final data = await repository.getData();
    state = AsyncValue.data(data);
  } on NetworkException catch (e) {
    state = AsyncValue.error('خطأ في الاتصال', StackTrace.current);
  } on Exception catch (e, stackTrace) {
    debugPrint('Error: $e');
    state = AsyncValue.error('حدث خطأ غير متوقع', stackTrace);
  }
}
```

---

## Git Best Practices

### 1. Commit Messages

#### Conventional Commits

```bash
# ✅ صحيح
feat(customers): add customer search functionality
fix(invoices): resolve PDF export issue
docs(readme): update installation instructions

# ❌ خطأ
added stuff
fix bug
update
```

### 2. Branching Strategy

#### Feature Branches

```bash
# ✅ إنشاء فرع للميزة
git checkout -b feature/customer-search

# ✅ العمل على الفرع
git add .
git commit -m "feat(customers): add search functionality"

# ✅ الدمج في main
git checkout main
git merge feature/customer-search
git branch -d feature/customer-search
```

### 3. Pull Requests

#### قبل إنشاء PR

- [ ] جميع الاختبارات تنجح
- [ ] flutter analyze بدون أخطاء
- [ ] التوثيق محدث
- [ ] CHANGELOG محدث

---

## Security Best Practices

### 1. التخزين الآمن

#### استخدام Secure Storage

```dart
// ✅ صحيح - تخزين آمن
final storage = FlutterSecureStorage();
await storage.write(key: '<credential-fixture>', value: hashedPassword);

// ❌ خطأ - تخزين غير آمن
SharedPreferences prefs = await SharedPreferences.getInstance();
await prefs.setString('password', password);
```

### 2. Input Validation

#### التحقق من جميع المدخلات

```dart
// ✅ صحيح - validation شامل
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
  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
    return 'رقم الهاتف يجب أن يحتوي على أرقام فقط';
  }
  return null;
}
```

### 3. Hashing

#### استخدام Hashing للبيانات الحساسة

```dart
// ✅ صحيح - hashing
import 'package:crypto/crypto.dart';
import 'dart:convert';

String hashPassword(String password) {
  return sha256.convert(utf8.encode(password)).toString();
}
```

---

## Testing Best Practices

### 1. Unit Tests

#### بنية الاختبار

```dart
void main() {
  group('CustomerRepository', () {
    late Isar isar;
    late CustomerRepository repository;

    setUp(() async {
      // إعداد قبل كل اختبار
      isar = await Isar.open([CustomerModelSchema]);
      repository = CustomerRepository(isar);
    });

    tearDown(() async {
      // تنظيف بعد كل اختبار
      await isar.close(deleteFromDisk: true);
    });

    test('should add customer successfully', () async {
      // Arrange
      final customer = Customer(id: '1', name: 'Test');

      // Act
      await repository.addCustomer(customer);
      final customers = await repository.getAllCustomers();

      // Assert
      expect(customers.length, 1);
      expect(customers.first.name, 'Test');
    });
  });
}
```

### 2. Widget Tests

#### اختبار Widgets

```dart
testWidgets('CustomerCard displays customer info', (tester) async {
  // Arrange
  final customer = Customer(id: '1', name: 'Test', phone: '0501234567');

  // Act
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: CustomerCard(customer: customer),
      ),
    ),
  );

  // Assert
  expect(find.text('Test'), findsOneWidget);
  expect(find.text('0501234567'), findsOneWidget);
});
```

### 3. Mocking

#### استخدام Mockito

```dart
@GenerateMocks([CustomerRepository])
void main() {
  test('should load customers', () async {
    // Arrange
    final mockRepository = MockCustomerRepository();
    final customers = [Customer(id: '1', name: 'Test')];

    when(mockRepository.getAllCustomers())
        .thenAnswer((_) async => customers);

    // Act
    final result = await mockRepository.getAllCustomers();

    // Assert
    expect(result, customers);
    verify(mockRepository.getAllCustomers()).called(1);
  });
}
```

---

## Documentation Best Practices

### 1. DartDoc

#### توثيق شامل

````dart
/// يمثل عميل في النظام.
///
/// يحتوي على جميع المعلومات الأساسية للعميل.
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

  /// ينشئ عميل جديد.
  const Customer({
    required this.id,
    required this.name,
    required this.phone,
  });
}
````

### 2. README

#### بنية README

```markdown
# اسم المشروع

## نظرة عامة

وصف موجز للمشروع

## المتطلبات

- Flutter 3.24.0+
- Dart 3.5.0+

## التثبيت

\`\`\`bash
flutter pub get
\`\`\`

## الاستخدام

\`\`\`dart
// مثال
\`\`\`

## الاختبارات

\`\`\`bash
flutter test
\`\`\`

## المساهمة

راجع CONTRIBUTING.md
```

---

## Performance Best Practices

### 1. تحسين البناء

#### تجنب Rebuilds غير الضرورية

```dart
// ✅ صحيح - استخدام const
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('عنوان'),
        Icon(Icons.home),
      ],
    );
  }
}

// ✅ استخدام keys للحفاظ على الحالة
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ItemCard(
      key: <credential-fixture>(items[index].id),
      item: items[index],
    );
  },
)
```

### 2. تحسين الصور

#### Lazy Loading للصور

```dart
// ✅ صحيح - تحميل كسول
Image.network(
  imageUrl,
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return CircularProgressIndicator();
  },
)

// ✅ استخدام cached_network_image
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

### 3. تحسين القوائم

#### استخدام ListView.builder

```dart
// ✅ صحيح - للقوائم الطويلة
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ItemCard(item: items[index]);
  },
)

// ❌ خطأ - للقوائم الطويلة
ListView(
  children: items.map((item) => ItemCard(item: item)).toList(),
)
```

---

## قائمة التحقق الشاملة

### قبل Commit

- [ ] flutter analyze بدون أخطاء
- [ ] flutter test نجح 100%
- [ ] التوثيق محدث
- [ ] CHANGELOG محدث
- [ ] لا توجد warnings حرجة
- [ ] الكود يتبع جميع المعايير

### قبل PR

- [ ] جميع الاختبارات تنجح
- [ ] التغطية > 70%
- [ ] المراجعة الذاتية مكتملة
- [ ] الوصف واضح
- [ ] Screenshots إذا لزم

### قبل Release

- [ ] جميع الميزات مختبرة
- [ ] التوثيق كامل
- [ ] CHANGELOG محدث
- [ ] Version number محدث
- [ ] Build نجح على جميع المنصات

---

## المراجع

### للمزيد من التفاصيل

- `guides/flutter-guide.md` - دليل Flutter الكامل
- `guides/git-guide.md` - دليل Git الكامل
- `guides/security-guide.md` - دليل الأمان الكامل
- `reference/full-standards.md` - جميع المعايير
- `reference/examples.md` - أمثلة تفصيلية

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 7 ديسمبر 2025  
**الإصدار:** 1.0  
**الحالة:** ✅ نشط ومعتمد
