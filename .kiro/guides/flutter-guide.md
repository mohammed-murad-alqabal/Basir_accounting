# دليل Flutter الكامل

**المشروع:** بصير MVP  
**التاريخ:** 8 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ نشط

---

## 🎯 نظرة عامة

هذا الدليل يحتوي على جميع أفضل الممارسات والمعايير لتطوير تطبيقات Flutter في مشروع بصير MVP.

---

## 📐 البنية المعمارية

### Clean Architecture

نستخدم Clean Architecture بثلاث طبقات:

#### 1. Presentation Layer (UI)

```
lib/features/[feature]/presentation/
├── screens/          # الشاشات
├── widgets/          # المكونات
└── providers/        # إدارة الحالة
```

**المسؤوليات:**

- عرض البيانات للمستخدم
- التفاعل مع المستخدم
- إدارة الحالة المحلية

**القواعد:**

- ✅ لا منطق أعمال في هذه الطبقة
- ✅ استخدام Providers للحالة
- ✅ Widgets قابلة لإعادة الاستخدام

#### 2. Domain Layer (Business Logic)

```
lib/features/[feature]/domain/
├── entities/         # الكيانات
├── repositories/     # واجهات المستودعات
└── usecases/         # حالات الاستخدام
```

**المسؤوليات:**

- منطق الأعمال
- قواعد التحقق
- تعريف العقود

**القواعد:**

- ✅ مستقلة عن الإطار
- ✅ لا dependencies خارجية
- ✅ Pure Dart فقط

#### 3. Data Layer (Data Access)

```
lib/features/[feature]/data/
├── models/           # نماذج البيانات
├── repositories/     # تنفيذ المستودعات
└── datasources/      # مصادر البيانات
```

**المسؤوليات:**

- الوصول للبيانات
- التحويل بين Models و Entities
- التعامل مع APIs والقواعد

**القواعد:**

- ✅ تنفيذ واجهات Domain
- ✅ معالجة الأخطاء
- ✅ Caching عند الحاجة

### Feature-First Organization

```
lib/
├── core/                    # مشترك
│   ├── constants/
│   ├── utils/
│   ├── widgets/
│   └── theme/
├── features/                # الميزات
│   ├── customers/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── invoices/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart
```

**الفوائد:**

- سهولة العثور على الكود
- تقليل الاعتماديات
- تسهيل العمل الجماعي
- قابلية التوسع

---

## 🔄 إدارة الحالة

### Riverpod (الموصى به)

#### أنواع Providers

##### 1. Provider - للقيم الثابتة

```dart
@riverpod
Isar isar(IsarRef ref) {
  return Isar.getInstance()!;
}
```

##### 2. FutureProvider - للعمليات Async

```dart
@riverpod
Future<List<Customer>> customers(CustomersRef ref) async {
  final repository = ref.watch(customerRepositoryProvider);
  return repository.getAllCustomers();
}
```

##### 3. StateNotifierProvider - للحالات المعقدة

```dart
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

#### أفضل الممارسات

```dart
// ✅ صحيح - استخدام ref.watch في build
@override
Widget build(BuildContext context, WidgetRef ref) {
  final customers = ref.watch(customersProvider);
  return customers.when(
    data: (data) => ListView(...),
    loading: () => CircularProgressIndicator(),
    error: (error, stack) => ErrorWidget(error),
  );
}

// ✅ صحيح - استخدام ref.read في callbacks
onPressed: () {
  ref.read(customersNotifierProvider.notifier).addCustomer(customer);
}

// ❌ خطأ - استخدام ref.watch في callbacks
onPressed: () {
  ref.watch(customersNotifierProvider); // سيسبب rebuild غير ضروري
}
```

---

## 💾 قاعدة البيانات

### Isar (المعتمد)

#### التعريف

```dart
@collection
class CustomerModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String name;

  late String phone;

  String? email;
  String? address;

  late DateTime createdAt;
  DateTime? updatedAt;
}
```

#### الاستخدام

##### فتح الاتصال

```dart
final isar = await Isar.open(
  [CustomerModelSchema, InvoiceModelSchema],
  directory: await getApplicationDocumentsDirectory(),
);
```

##### القراءة

```dart
// قراءة الكل
final customers = await isar.customerModels.where().findAll();

// قراءة بشرط
final customer = await isar.customerModels
    .filter()
    .nameContains('أحمد')
    .findFirst();

// البحث بالـ Index
final customers = await isar.customerModels
    .where()
    .nameStartsWith('أحمد')
    .findAll();
```

##### الكتابة

```dart
// إضافة
await isar.writeTxn(() async {
  await isar.customerModels.put(customer);
});

// تحديث
await isar.writeTxn(() async {
  customer.name = 'اسم جديد';
  await isar.customerModels.put(customer);
});

// حذف
await isar.writeTxn(() async {
  await isar.customerModels.delete(customer.id);
});
```

##### Transactions

```dart
// ✅ صحيح - استخدام transaction للعمليات المتعددة
await isar.writeTxn(() async {
  await isar.customerModels.put(customer);
  await isar.invoiceModels.put(invoice);
});

// ❌ خطأ - عمليات منفصلة
await isar.writeTxn(() async {
  await isar.customerModels.put(customer);
});
await isar.writeTxn(() async {
  await isar.invoiceModels.put(invoice);
});
```

#### الاختبارات

```dart
// استخدام Isar في الذاكرة للاختبارات
setUp(() async {
  isar = await Isar.open(
    [CustomerModelSchema],
    directory: '',
    name: 'test_${DateTime.now().millisecondsSinceEpoch}',
  );
});

tearDown(() async {
  await isar.close(deleteFromDisk: true);
});
```

---

## 🔒 الأمان

### SecureStorageService (Zero-Trust)

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// خدمة تخزين آمنة مع مبادئ Zero-Trust
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: <credential-fixture>),
  );

  // مفاتيح التخزين
  static const String _keyAuthToken = '<credential-fixture>';
  static const String _keyUserPin = '<credential-fixture>';
  static const String _keyDeviceId = '<credential-fixture>';

  /// حفظ بيانات آمنة
  static Future<void> saveSecure(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } on Exception catch (e) {
      throw SecurityException('فشل الحفظ الآمن: $e');
    }
  }

  /// قراءة بيانات آمنة
  static Future<String?> readSecure(String key) async {
    try {
      return await _storage.read(key: key);
    } on Exception catch (e) {
      throw SecurityException('فشل القراءة الآمنة: $e');
    }
  }

  /// حذف بيانات آمنة
  static Future<void> deleteSecure(String key) async {
    await _storage.delete(key: key);
  }

  /// مسح جميع البيانات الآمنة (عند تسجيل الخروج)
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// حفظ Token المصادقة
  static Future<void> saveAuthToken(String token) async {
    await saveSecure(_keyAuthToken, token);
  }

  /// قراءة Token المصادقة
  static Future<String?> getAuthToken() async {
    return await readSecure(_keyAuthToken);
  }
}

class SecurityException implements Exception {
  final String message;
  SecurityException(this.message);
  @override
  String toString() => 'SecurityException: $message';
}
```

### InputSanitizer (حماية من الهجمات)

```dart
/// تنظيف المدخلات من الأكواد الضارة
class InputSanitizer {
  /// إزالة HTML/Script tags
  static String sanitizeHtml(String input) {
    return input
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'javascript:', caseSensitive: false), '')
        .replaceAll(RegExp(r'on\w+\s*=', caseSensitive: false), '');
  }

  /// تنظيف SQL injection
  static String sanitizeSql(String input) {
    return input
        .replaceAll(RegExp(r"['\";]"), '')
        .replaceAll(RegExp(r'--'), '')
        .replaceAll(RegExp(r'/\*|\*/'), '');
  }

  /// تنظيف للاستخدام العام
  static String sanitize(String input) {
    return sanitizeHtml(sanitizeSql(input.trim()));
  }
}
```

### ValidationUtils (التحقق الشامل)

```dart
/// أدوات التحقق من صحة المدخلات
class ValidationUtils {
  /// التحقق من رقم الهاتف السعودي
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    final clean = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (!clean.startsWith('05')) {
      return 'رقم الهاتف يجب أن يبدأ بـ 05';
    }
    if (clean.length != 10) {
      return 'رقم الهاتف يجب أن يتكون من 10 أرقام';
    }
    return null;
  }

  /// التحقق من البريد الإلكتروني
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return null; // اختياري
    final regex = RegExp(r'^[\w-.]+@[\w-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value)) {
      return 'البريد الإلكتروني غير صحيح';
    }
    return null;
  }

  /// التحقق من الاسم (عربي/إنجليزي)
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'الاسم مطلوب';
    }
    if (value.trim().length < 2) {
      return 'الاسم يجب أن يتكون من حرفين على الأقل';
    }
    if (!RegExp(r'^[\u0600-\u06FFa-zA-Z\s]+$').hasMatch(value)) {
      return 'الاسم يجب أن يحتوي على حروف فقط';
    }
    return null;
  }

  /// التحقق من المبلغ المالي
  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'المبلغ مطلوب';
    }
    final amount = double.tryParse(value);
    if (amount == null || amount <= 0) {
      return 'المبلغ يجب أن يكون رقم موجب';
    }
    if (amount > 999999.99) {
      return 'المبلغ كبير جداً';
    }
    return null;
  }

  /// التحقق من قوة كلمة المرور
  static String? validatePassword(String? value) {
    if (value == null || value.length < 8) {
      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'يجب أن تحتوي على حرف كبير';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'يجب أن تحتوي على رقم';
    }
    return null;
  }
}
```

### Hashing الآمن

```dart
import 'package:crypto/crypto.dart';
import 'dart:convert';

/// تشفير كلمات المرور بـ SHA-256
String hashPassword(String password, {String? salt}) {
  final salted = salt != null ? '$password$salt' : password;
  final bytes = utf8.encode(salted);
  final hash = sha256.convert(bytes);
  return hash.toString();
}
```

---

## ⚡ الأداء

### Const Constructors

```dart
// ✅ صحيح - استخدام const
const Text('مرحباً')
const Icon(Icons.add)
const SizedBox(height: 16)
const Padding(padding: EdgeInsets.all(8))

// ❌ خطأ - بدون const
Text('مرحباً')
Icon(Icons.add)
```

### Lazy Loading

```dart
// ✅ صحيح - ListView.builder للقوائم الطويلة
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ItemCard(item: items[index]);
  },
)

// ❌ خطأ - ListView للقوائم الطويلة
ListView(
  children: items.map((item) => ItemCard(item: item)).toList(),
)
```

### Keys للحفاظ على الحالة

```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ItemCard(
      key: <credential-fixture>(items[index].id), // مهم!
      item: items[index],
    );
  },
)
```

### تجنب Rebuilds غير الضرورية

```dart
// ✅ صحيح - استخدام Consumer محدد
Consumer(
  builder: (context, ref, child) {
    final count = ref.watch(counterProvider);
    return Text('$count');
  },
)

// ❌ خطأ - rebuild للشجرة كاملة
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Column(
      children: [
        ExpensiveWidget(), // سيُعاد بناؤه مع كل تغيير!
        Text('$count'),
      ],
    );
  }
}
```

---

## 🌍 دعم RTL

### Directionality

```dart
MaterialApp(
  locale: Locale('ar'),
  supportedLocales: [
    Locale('ar'),
    Locale('en'),
  ],
  builder: (context, child) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: child!,
    );
  },
)
```

### TextAlign

```dart
// ✅ صحيح - استخدام start/end
Text(
  'نص عربي',
  textAlign: TextAlign.start, // يتكيف مع الاتجاه
)

// ❌ خطأ - استخدام left/right
Text(
  'نص عربي',
  textAlign: TextAlign.left, // ثابت
)
```

### الخطوط العربية

```dart
// pubspec.yaml
flutter:
  fonts:
    - family: Cairo
      fonts:
        - asset: assets/fonts/Cairo-Regular.ttf
        - asset: assets/fonts/Cairo-Bold.ttf
          weight: 700

// استخدام
Text(
  'نص عربي',
  style: TextStyle(
    fontFamily: 'Cairo',
    fontSize: 16,
  ),
)
```

---

## 🧪 الاختبارات

### Unit Tests

```dart
void main() {
  group('CustomerRepository', () {
    late Isar isar;
    late CustomerRepository repository;

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
  });
}
```

### Widget Tests

```dart
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
```

---

## ❌ الأخطاء الشائعة

### 1. استخدام BuildContext بعد async

```dart
// ❌ خطأ
Future<void> loadData(BuildContext context) async {
  await Future.delayed(Duration(seconds: 1));
  Navigator.pop(context); // قد يكون context غير صالح!
}

// ✅ صحيح
Future<void> loadData(BuildContext context) async {
  await Future.delayed(Duration(seconds: 1));
  if (context.mounted) {
    Navigator.pop(context);
  }
}
```

### 2. عدم معالجة الأخطاء

```dart
// ❌ خطأ
Future<void> loadData() async {
  final data = await repository.getData();
  state = data;
}

// ✅ صحيح
Future<void> loadData() async {
  try {
    final data = await repository.getData();
    state = AsyncValue.data(data);
  } on NetworkException catch (e) {
    state = AsyncValue.error('خطأ في الاتصال', StackTrace.current);
  } on Exception catch (e, stackTrace) {
    state = AsyncValue.error('حدث خطأ غير متوقع', stackTrace);
  }
}
```

### 3. عدم إغلاق الموارد

```dart
// ❌ خطأ
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(controller: controller);
  }
  // لم يتم إغلاق controller!
}

// ✅ صحيح
class _MyWidgetState extends State<MyWidget> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(controller: controller);
  }
}
```

---

## 💡 نصائح وحيل

### 1. استخدام Extensions

```dart
extension StringExtensions on String {
  bool get isValidPhone {
    return startsWith('05') && length == 10;
  }

  String get toArabicDigits {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String result = this;
    for (int i = 0; i < english.length; i++) {
      result = result.replaceAll(english[i], arabic[i]);
    }
    return result;
  }
}
```

### 2. استخدام Freezed للـ Models

```dart
@freezed
class Customer with _$Customer {
  const factory Customer({
    required String id,
    required String name,
    required String phone,
    String? email,
    String? address,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}
```

### 3. استخدام Go Router للتنقل

```dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/customers',
      builder: (context, state) => CustomersScreen(),
    ),
    GoRoute(
      path: '/customers/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return CustomerDetailsScreen(id: id);
      },
    ),
  ],
);
```

---

## 📚 المراجع

### الوثائق الرسمية

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Riverpod Documentation](https://riverpod.dev)
- [Isar Documentation](https://isar.dev)

### المعايير الداخلية

- `.kiro/steering/standards/flutter.md` - معايير Flutter المختصرة
- `.kiro/steering/standards/code-quality.md` - معايير الجودة
- `.kiro/steering/standards/testing.md` - معايير الاختبارات
- `.kiro/steering/reference/examples.md` - أمثلة تفصيلية

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 8 ديسمبر 2025  
**الإصدار:** 1.0  
**الحالة:** ✅ نشط ومعتمد
