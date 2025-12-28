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

#### 1. التعريف (Schema)

```dart
@collection
class CustomerModel {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value) // فهرس للبحث السريع
  late String name;

  @Index(unique: true, replace: true) // فريد ويستبدل القديم
  late String phone;

  String? email;
  String? address;

  @Index() // فهرس للترتيب
  late DateTime createdAt;

  DateTime? updatedAt;
}
```

#### 2. فتح الاتصال (Setup)

```dart
final dir = await getApplicationDocumentsDirectory();
final isar = await Isar.open(
  [CustomerModelSchema],
  directory: dir.path,
  inspector: kDebugMode, // تفعيل الفاحص في وضع التطوير
  maxSizeMiB: 512, // الحد الأقصى للحجم
);
```

#### 3. العمليات (CRUD)

```dart
// كتابة متزامنة (أسرع للعمليات الصغيرة)
await isar.writeTxn(() async {
  await isar.customerModels.put(customer);
});

// بحث سريع جداً باستخدام الفهرس
final customer = await isar.customerModels
    .where()
    .phoneEqualTo('0501234567') // يستخدم الفهرس تلقائياً
    .findFirst();

// مراقبة التغييرات (Reactive UI)
Stream<List<CustomerModel>> watchCustomers() {
  return isar.customerModels
      .where()
      .sortByName()
      .watch(fireImmediately: true);
}
```

#### 4. أفضل الممارسات

- **Transactions**: دائماً جمع العمليات في `writeTxn` واحد.
- **Indexes**: استخدم `@Index` للحقول التي تبحث بها أو ترتب بناءً عليها.
- **Watchers**: استخدم `watch()` لتحديث الـ UI تلقائياً بدلاً من إعادة الجلب يدوياً.
- **Background**: للعمليات الثقيلة، استخدم Isar في Isolate منفصل.

#### 5. الاختبارات

```dart
setUp(() async {
  await Isar.initializeIsarCore(download: true); // تأكد من تحميل Core
  isar = await Isar.open(
    [CustomerModelSchema],
    directory: '', // ذاكرة مؤقتة
    name: 'test_db',
  );
});

tearDown(() async {
  if (isar.isOpen) {
    await isar.close(deleteFromDisk: true);
  }
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
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // مفاتيح التخزين
  static const String _keyAuthToken = 'auth_token';
  static const String _keyUserPin = 'user_pin';
  static const String _keyDeviceId = 'device_id';

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
      key: ValueKey(items[index].id), // مهم!
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

### تحويل الأرقام العربية

```dart
extension ArabicNumbers on String {
  /// تحويل الأرقام الإنجليزية إلى عربية
  String get toArabicDigits {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String result = this;
    for (int i = 0; i < english.length; i++) {
      result = result.replaceAll(english[i], arabic[i]);
    }
    return result;
  }

  /// تحويل الأرقام العربية إلى إنجليزية
  String get toEnglishDigits {
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    String result = this;
    for (int i = 0; i < arabic.length; i++) {
      result = result.replaceAll(arabic[i], english[i]);
    }
    return result;
  }
}
```

### تنسيق العملة السعودية

```dart
import 'package:intl/intl.dart';

class CurrencyFormatter {
  /// تنسيق الريال السعودي
  static String formatSAR(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'ar_SA',
      symbol: 'ر.س ',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  /// تنسيق مختصر للمبالغ الكبيرة
  static String formatCompact(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}م ر.س';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}ك ر.س';
    }
    return formatSAR(amount);
  }
}

// استخدام
Text(CurrencyFormatter.formatSAR(1500.50)) // 'ر.س ١٬٥٠٠٫٥٠'
Text(CurrencyFormatter.formatCompact(2500000)) // '২.5م ر.س'
```

### AppTheme للعربية

```dart
class AppTheme {
  static ThemeData get arabicTheme => ThemeData(
    fontFamily: 'Cairo',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontFamily: 'Cairo', height: 1.6),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: false, // محاذاة لليمين في RTL
      titleTextStyle: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      floatingLabelAlignment: FloatingLabelAlignment.start,
    ),
  );
}
```

---

## 🧪 الاختبارات

### Unit Tests (Mocktail)

```dart
import 'package:mocktail/mocktail.dart';

class MockCustomerRepository extends Mock implements CustomerRepository {}
class MockCustomer extends Mock implements Customer {}

void main() {
  late MockCustomerRepository repository;
  late CustomerNotifier notifier;

  setUp(() {
    repository = MockCustomerRepository();
    notifier = CustomerNotifier(repository);
  });

  test('should load customers successfully', () async {
    // Arrange
    const customers = [Customer(id: '1', name: 'Test')];
    when(() => repository.getAllCustomers()).thenAnswer((_) async => customers);

    // Act
    await notifier.loadCustomers();

    // Assert
    verify(() => repository.getAllCustomers()).called(1);
    expect(notifier.state, isA<AsyncData>());
  });
}
```

### Widget Tests (Robot Pattern)

نستخدم **Robot Pattern** لفصل منطق الاختبار عن التفاعل مع الـ Widgets.

**1. The Robot:**

```dart
class CustomerRobot {
  final WidgetTester tester;
  CustomerRobot(this.tester);

  Future<void> pumpCustomerScreen(Customer c) async {
    await tester.pumpWidget(MaterialApp(home: CustomerCard(customer: c)));
  }

  Future<void> tapShareButton() async {
    await tester.tap(find.byIcon(Icons.share));
    await tester.pumpAndSettle();
  }

  void expectCustomerName(String name) {
    expect(find.text(name), findsOneWidget);
  }
}
```

**2. The Test:**

```dart
testWidgets('CustomerCard displays info and shares', (tester) async {
  final robot = CustomerRobot(tester);
  final customer = Customer(id: '1', name: 'أحمد', phone: '0500000000');

  await robot.pumpCustomerScreen(customer);

  robot.expectCustomerName('أحمد');
  await robot.tapShareButton();
  // ... مزيد من التحقق
});
```

### Golden Tests

نستخدم `golden_toolkit` لاختبارات الـ UI البصرية.

```dart
testGoldens('CustomerCard golden test', (tester) async {
  final builder = GoldenBuilder.column()
    ..addScenario('Default', CustomerCard(customer: customer1))
    ..addScenario('Long Name', CustomerCard(customer: customer2));

  await tester.pumpWidgetBuilder(builder.build());
  await screenMatchesGolden(tester, 'customer_card_grid');
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

## 📝 توثيق الكود

### 1. توثيق الـ APIs (DartDoc)

استخدم `///` لتوثيق جميع الـ Classes و Methods العامة.

````dart
/// A repository that handles customer data operations.
///
/// Use this repository to fetch, add, or update customers
/// in the local database.
class CustomerRepository {
  /// Fetches a customer by their [id].
  ///
  /// Returns `null` if the customer is not found.
  ///
  /// Example:
  /// ```dart
  /// final customer = await repository.getCustomer('123');
  /// ```
  Future<Customer?> getCustomer(String id) async {
    // ...
  }
}
````

### 2. ملاحظات التنفيذ (Implementation Comments)

استخدم `//` لشرح _سبب_ كتابة الكود بهذه الطريقة (وليس _ماذا_ يفعل).

```dart
// We use a Set here to avoid duplicate customer IDs automatically
final uniqueIds = <String>{};
```

### 3. تتبع المهام (TODOs)

استخدم تنسيقاً موحداً لتسهيل التتبع.

```dart
// TODO(auth): Implement refresh token logic
// TODO(ui): Fix overflow on small screens
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
