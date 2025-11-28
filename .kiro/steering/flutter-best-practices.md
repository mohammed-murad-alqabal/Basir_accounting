---
title: Flutter Best Practices
inclusion: always
---

# Flutter Best Practices لمشروع بصير

## 1. بنية المشروع (Project Structure)

### التنظيم حسب الميزات (Feature-First)
```
lib/
├── core/                    # المكونات الأساسية المشتركة
│   ├── theme/              # نظام التصميم والثيمات
│   ├── widgets/            # Widgets قابلة لإعادة الاستخدام
│   ├── utils/              # دوال مساعدة
│   └── router/             # التوجيه والملاحة
├── features/               # الميزات الرئيسية
│   ├── auth/              # المصادقة
│   ├── customers/         # إدارة العملاء
│   ├── invoices/          # إدارة الفواتير
│   └── dashboard/         # لوحة التحكم
└── data/                   # طبقة البيانات
    ├── models/            # نماذج البيانات
    ├── repositories/      # Repositories
    └── services/          # الخدمات
```

### قاعدة الطبقات الثلاث
1. **Presentation Layer**: Screens, Widgets, Providers
2. **Domain Layer**: Business Logic, Use Cases
3. **Data Layer**: Models, Repositories, Services

## 2. إدارة الحالة (State Management)

### استخدام Riverpod
- **Provider Types:**
  - `Provider`: للقيم الثابتة
  - `StateProvider`: للحالات البسيطة
  - `FutureProvider`: للعمليات الغير متزامنة
  - `StreamProvider`: للبيانات المتدفقة
  - `StateNotifierProvider`: للحالات المعقدة

### مثال على Provider صحيح:
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

## 3. قاعدة البيانات المحلية (Isar)

### قواعد استخدام Isar
1. **استخدام Isar في الذاكرة للاختبارات**
2. **إغلاق الاتصالات بشكل صحيح**
3. **استخدام Transactions للعمليات المتعددة**
4. **إنشاء Indexes للحقول المستخدمة في البحث**

### مثال على Repository:
```dart
class CustomerRepositoryImpl implements CustomerRepository {
  final Isar isar;

  CustomerRepositoryImpl(this.isar);

  @override
  Future<List<Customer>> getAllCustomers() async {
    return await isar.customerModels.where().findAll();
  }

  @override
  Future<void> addCustomer(Customer customer) async {
    await isar.writeTxn(() async {
      await isar.customerModels.put(customer.toModel());
    });
  }
}
```

## 4. الأمان (Security)

### التخزين الآمن
- **استخدام flutter_secure_storage** لتخزين البيانات الحساسة
- **عدم تخزين كلمات المرور بشكل نصي**
- **استخدام Hashing للبيانات الحساسة**

### مثال:
```dart
class AuthService {
  final FlutterSecureStorage _secureStorage;

  Future<void> saveCredentials(String username, String password) async {
    final hashedPassword = _hashPassword(password);
    await _secureStorage.write(key: 'username', value: username);
    await _secureStorage.write(key: 'password', value: hashedPassword);
  }

  String _hashPassword(String password) {
    // استخدام خوارزمية hash آمنة
    return sha256.convert(utf8.encode(password)).toString();
  }
}
```

## 5. الاختبارات (Testing)

### أنواع الاختبارات
1. **Unit Tests**: لاختبار الدوال والـ Classes المعزولة
2. **Widget Tests**: لاختبار الـ Widgets
3. **Integration Tests**: لاختبار التدفقات الكاملة

### قواعد الاختبار
- **تغطية 70%+** من الكود
- **استخدام Mocks** للاعتماديات الخارجية
- **اختبارات سريعة** (< 30 ثانية للكل)
- **اختبارات مستقلة** (لا تعتمد على بعضها)

### مثال على اختبار:
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

    test('should add customer successfully', () async {
      final customer = Customer(
        id: 'test-1',
        name: 'Test Customer',
        phone: '0501234567',
      );

      await repository.addCustomer(customer);
      final customers = await repository.getAllCustomers();

      expect(customers.length, 1);
      expect(customers.first.name, 'Test Customer');
    });
  });
}
```

## 6. الأداء (Performance)

### تحسين الأداء
1. **استخدام const constructors** حيثما أمكن
2. **تجنب إعادة البناء غير الضرورية**
3. **استخدام ListView.builder** للقوائم الطويلة
4. **تحميل الصور بشكل كسول (Lazy Loading)**
5. **استخدام Isolates** للعمليات الثقيلة

### مثال:
```dart
// ✅ جيد - استخدام const
const AppButton(
  text: 'حفظ',
  onPressed: _handleSave,
)

// ❌ سيء - بدون const
AppButton(
  text: 'حفظ',
  onPressed: _handleSave,
)
```

## 7. دعم اللغة العربية (RTL Support)

### قواعد دعم العربية
1. **استخدام Directionality** للتحكم في الاتجاه
2. **اختبار الواجهات** في كلا الاتجاهين
3. **استخدام خطوط عربية** مناسبة
4. **التأكد من محاذاة النصوص** بشكل صحيح

### مثال:
```dart
MaterialApp(
  locale: const Locale('ar', 'SA'),
  supportedLocales: const [
    Locale('ar', 'SA'),
    Locale('en', 'US'),
  ],
  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
)
```

## 8. معالجة الأخطاء (Error Handling)

### استراتيجية معالجة الأخطاء
1. **استخدام try-catch** للعمليات الخطرة
2. **عرض رسائل خطأ واضحة** للمستخدم
3. **تسجيل الأخطاء** للمراجعة
4. **عدم تعطل التطبيق** بسبب أخطاء غير متوقعة

### مثال:
```dart
Future<void> loadCustomers() async {
  state = const AsyncValue.loading();
  state = await AsyncValue.guard(() async {
    try {
      final repository = ref.read(customerRepositoryProvider);
      return await repository.getAllCustomers();
    } catch (e, stack) {
      // تسجيل الخطأ
      debugPrint('Error loading customers: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  });
}
```

## 9. التوثيق (Documentation)

### قواعد التوثيق
1. **توثيق جميع الـ Public APIs**
2. **استخدام DartDoc** للتعليقات
3. **شرح المعاملات المعقدة**
4. **إضافة أمثلة** للاستخدام

### مثال:
```dart
/// يقوم بإضافة عميل جديد إلى قاعدة البيانات
///
/// يتحقق من صحة البيانات قبل الإضافة ويرمي [ValidationException]
/// إذا كانت البيانات غير صحيحة.
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
Future<void> addCustomer(Customer customer);
```

## 10. CI/CD Integration

### GitHub Actions للاختبارات
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
          flutter-version: '3.24.0'
      
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
```

---

**ملاحظة:** هذه الممارسات يجب أن تُطبق في جميع مراحل التطوير وتُراجع بانتظام.
