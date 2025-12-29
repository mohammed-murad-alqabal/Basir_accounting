# دليل المطور المحدث - مشروع بصير MVP

**المشروع:** بصير MVP  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 16 ديسمبر 2025  
**الإصدار:** 2.0 - محدث بالكامل لـ Flutter/Dart  
**الحالة:** ✅ دليل شامل ومحدث

---

## 🎯 مرحباً بك في مشروع بصير MVP

هذا الدليل الشامل للمطورين الجدد والحاليين في مشروع بصير MVP. تم تحديث الدليل بالكامل ليركز على **Flutter/Dart فقط** مع إزالة جميع المراجع للتقنيات غير المتوافقة.

### ما هو بصير MVP؟

**بصير** هو تطبيق Flutter محلي أولاً (Local-First) لإدارة الفواتير، مصمم خصيصاً للسوق السعودي مع دعم كامل للغة العربية والتخطيط من اليمين لليسار (RTL).

### المبادئ الأساسية:

- 🏠 **Local-First**: جميع البيانات محلية أولاً
- 📱 **Mobile-First**: مصمم للأجهزة المحمولة
- 🇸🇦 **Arabic-First**: دعم كامل للعربية والـ RTL
- 🔒 **Security-First**: أمان على أعلى مستوى
- ✨ **Quality-First**: جودة لا تقبل التنازل

---

## 🚀 البدء السريع

### المتطلبات الأساسية

#### 1. **Flutter SDK 3.35.5+**

```bash
# تحميل وتثبيت Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# التحقق من التثبيت
flutter doctor
```

#### 2. **Dart SDK 3.9.2+** (مضمن مع Flutter)

```bash
# التحقق من إصدار Dart
dart --version
```

#### 3. **Android Studio أو VS Code**

```bash
# تثبيت إضافات Flutter
# في VS Code: Flutter, Dart
# في Android Studio: Flutter plugin
```

#### 4. **Git 2.0+**

```bash
# التحقق من Git
git --version
```

### إعداد المشروع

#### 1. **استنساخ المشروع**

```bash
git clone [repository-url] baseer-mvp
cd baseer-mvp
```

#### 2. **تثبيت التبعيات**

```bash
# تثبيت حزم Flutter
flutter pub get

# تشغيل code generation
dart run build_runner build
```

#### 3. **إعداد البيئة**

```bash
# نسخ ملف البيئة
cp .env.example .env

# تحرير المتغيرات حسب الحاجة
nano .env
```

#### 4. **تشغيل التطبيق**

```bash
# تشغيل في وضع التطوير
flutter run

# أو تشغيل على جهاز محدد
flutter run -d chrome  # للويب
flutter run -d android # للأندرويد
```

---

## 🏗️ بنية المشروع

### هيكل المجلدات الرئيسية

```
baseer-mvp/
├── lib/                          # الكود الرئيسي
│   ├── core/                     # الوظائف الأساسية
│   │   ├── constants/            # الثوابت
│   │   ├── errors/               # معالجة الأخطاء
│   │   ├── network/              # إدارة الشبكة
│   │   └── utils/                # الأدوات المساعدة
│   ├── features/                 # الميزات (Feature-First)
│   │   ├── invoices/             # إدارة الفواتير
│   │   │   ├── data/             # طبقة البيانات
│   │   │   ├── domain/           # طبقة المنطق
│   │   │   └── presentation/     # طبقة العرض
│   │   ├── customers/            # إدارة العملاء
│   │   └── settings/             # الإعدادات
│   ├── shared/                   # المكونات المشتركة
│   │   ├── widgets/              # الويدجت المشتركة
│   │   ├── providers/            # Riverpod providers
│   │   └── themes/               # السمات والألوان
│   └── main.dart                 # نقطة البداية
├── assets/                       # الموارد (صور، خطوط)
├── test/                         # الاختبارات
├── integration_test/             # اختبارات التكامل
├── .kiro/                        # ملفات Kiro
│   ├── steering/                 # ملفات التوجيه
│   └── specs/                    # المواصفات
└── pubspec.yaml                  # تبعيات المشروع
```

### Clean Architecture في Flutter

#### طبقة العرض (Presentation Layer)

```dart
// lib/features/invoices/presentation/pages/invoice_list_page.dart
class InvoiceListPage extends ConsumerWidget {
  const InvoiceListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(invoicesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('الفواتير')),
      body: invoicesAsync.when(
        data: (invoices) => InvoiceListView(invoices: invoices),
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => ErrorWidget(error.toString()),
      ),
    );
  }
}
```

#### طبقة المنطق (Domain Layer)

```dart
// lib/features/invoices/domain/entities/invoice.dart
class Invoice {
  final String id;
  final String customerName;
  final double amount;
  final DateTime createdAt;
  final InvoiceStatus status;

  const Invoice({
    required this.id,
    required this.customerName,
    required this.amount,
    required this.createdAt,
    required this.status,
  });
}

// lib/features/invoices/domain/usecases/create_invoice.dart
class CreateInvoiceUseCase {
  final InvoiceRepository repository;

  CreateInvoiceUseCase(this.repository);

  Future<Either<Failure, Invoice>> call(CreateInvoiceParams params) async {
    return await repository.createInvoice(params.invoice);
  }
}
```

#### طبقة البيانات (Data Layer)

```dart
// lib/features/invoices/data/repositories/invoice_repository_impl.dart
class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  InvoiceRepositoryImpl({
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Invoice>>> getInvoices() async {
    try {
      // دائماً اجلب من المصدر المحلي أولاً
      final localInvoices = await localDataSource.getInvoices();

      // مزامنة في الخلفية إذا كان هناك اتصال
      if (await networkInfo.isConnected) {
        _syncInBackground();
      }

      return Right(localInvoices);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
```

---

## 🎨 تطوير واجهة المستخدم

### Material Design 3 مع دعم العربية

#### إعداد السمة الأساسية

```dart
// lib/shared/themes/app_theme.dart
class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2196F3), // أزرق بصير
      brightness: Brightness.light,
    ),
    fontFamily: 'Cairo', // خط يدعم العربية
    textTheme: _buildTextTheme(),
  );

  static TextTheme _buildTextTheme() => const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      height: 1.5, // ارتفاع أفضل للعربية
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      height: 1.6, // مسافة أفضل بين الأسطر
    ),
  );
}
```

#### دعم RTL والعربية

```dart
// lib/main.dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'بصير MVP',
      theme: AppTheme.lightTheme,

      // دعم اللغات
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'SA'), // العربية السعودية
        Locale('en', 'US'), // الإنجليزية (احتياطي)
      ],
      locale: const Locale('ar', 'SA'),

      // إعداد RTL
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },

      home: const InvoiceListPage(),
    );
  }
}
```

#### ويدجت مخصصة للعربية

```dart
// lib/shared/widgets/arabic_text_field.dart
class ArabicTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const ArabicTextField({
    super.key,
    required this.label,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        // تخصيص للعربية
        alignLabelWithHint: true,
      ),
      // دعم لوحة المفاتيح العربية
      keyboardType: <credential-fixture>,
    );
  }
}
```

---

## 💾 إدارة البيانات المحلية

### Isar Database للتطبيقات المحلية

#### تعريف النماذج

```dart
// lib/features/invoices/data/models/invoice_model.dart
import 'package:isar/isar.dart';

part 'invoice_model.g.dart';

@Collection()
class InvoiceModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String invoiceNumber;

  @Index()
  late String customerName;

  late double amount;
  late double taxAmount;
  late double totalAmount;

  @Index()
  late DateTime createdAt;

  @Index()
  @Enumerated(EnumType.name)
  late InvoiceStatus status;

  late List<InvoiceItemModel> items;

  // تحويل إلى Entity
  Invoice toEntity() => Invoice(
    id: id.toString(),
    invoiceNumber: invoiceNumber,
    customerName: customerName,
    amount: amount,
    createdAt: createdAt,
    status: status,
  );
}

@embedded
class InvoiceItemModel {
  late String name;
  late int quantity;
  late double price;
  late double total;
}
```

#### إعداد قاعدة البيانات

```dart
// lib/core/database/database_service.dart
class DatabaseService {
  static late Isar _isar;

  static Future<void> initialize() async {
    _isar = await Isar.open([
      InvoiceModelSchema,
      CustomerModelSchema,
    ]);
  }

  static Isar get instance => _isar;

  // إنشاء نسخة احتياطية
  static Future<void> backup() async {
    final backupPath = await _getBackupPath();
    await _isar.copyToFile(backupPath);
  }

  // استعادة من النسخة الاحتياطية
  static Future<void> restore(String backupPath) async {
    await _isar.close();
    // استعادة منطق قاعدة البيانات
    await initialize();
  }
}
```

#### عمليات قاعدة البيانات

```dart
// lib/features/invoices/data/datasources/invoice_local_data_source.dart
class InvoiceLocalDataSourceImpl implements InvoiceLocalDataSource {
  final Isar isar;

  InvoiceLocalDataSourceImpl(this.isar);

  @override
  Future<List<InvoiceModel>> getInvoices() async {
    return await isar.invoiceModels
        .where()
        .sortByCreatedAtDesc()
        .findAll();
  }

  @override
  Future<void> cacheInvoice(InvoiceModel invoice) async {
    await isar.writeTxn(() async {
      await isar.invoiceModels.put(invoice);
    });
  }

  @override
  Future<List<InvoiceModel>> searchInvoices(String query) async {
    return await isar.invoiceModels
        .filter()
        .customerNameContains(query, caseSensitive: false)
        .or()
        .invoiceNumberContains(query, caseSensitive: false)
        .findAll();
  }
}
```

---

## 🔄 إدارة الحالة مع Riverpod

### إعداد Providers

#### State Providers للبيانات البسيطة

```dart
// lib/shared/providers/app_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider للغة الحالية
final currentLocaleProvider = StateProvider<Locale>((ref) {
  return const Locale('ar', 'SA');
});

// Provider للسمة الحالية
final currentThemeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.light;
});

// Provider للعميل المختار
final selectedCustomerProvider = StateProvider<Customer?>((ref) => null);
```

#### StateNotifier للحالات المعقدة

```dart
// lib/features/invoices/presentation/providers/invoice_provider.dart
class InvoiceNotifier extends StateNotifier<AsyncValue<List<Invoice>>> {
  final InvoiceRepository _repository;

  InvoiceNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadInvoices();
  }

  Future<void> loadInvoices() async {
    state = const AsyncValue.loading();

    final result = await _repository.getInvoices();

    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (invoices) => AsyncValue.data(invoices),
    );
  }

  Future<void> createInvoice(Invoice invoice) async {
    final result = await _repository.createInvoice(invoice);

    result.fold(
      (failure) {
        // إظهار رسالة خطأ
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (newInvoice) {
        // إضافة الفاتورة الجديدة للقائمة
        state.whenData((invoices) {
          state = AsyncValue.data([newInvoice, ...invoices]);
        });
      },
    );
  }
}

// Provider definition
final invoiceProvider = StateNotifierProvider<InvoiceNotifier, AsyncValue<List<Invoice>>>((ref) {
  final repository = ref.watch(invoiceRepositoryProvider);
  return InvoiceNotifier(repository);
});
```

#### Family Providers للمعاملات

```dart
// Provider للحصول على فاتورة محددة
final invoiceByIdProvider = FutureProvider.family<Invoice?, String>((ref, id) async {
  final repository = ref.watch(invoiceRepositoryProvider);
  final result = await repository.getInvoiceById(id);

  return result.fold(
    (failure) => null,
    (invoice) => invoice,
  );
});

// Provider لإحصائيات العميل
final customerStatsProvider = FutureProvider.family<CustomerStats, String>((ref, customerId) async {
  final repository = ref.watch(invoiceRepositoryProvider);
  return await repository.getCustomerStats(customerId);
});
```

### استخدام Providers في الواجهة

```dart
// lib/features/invoices/presentation/pages/invoice_list_page.dart
class InvoiceListPage extends ConsumerWidget {
  const InvoiceListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(invoiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة الفواتير'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(invoiceProvider),
          ),
        ],
      ),
      body: invoicesAsync.when(
        data: (invoices) => _buildInvoiceList(invoices),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorWidget(error),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateInvoice(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInvoiceList(List<Invoice> invoices) {
    if (invoices.isEmpty) {
      return const Center(
        child: Text('لا توجد فواتير حالياً'),
      );
    }

    return ListView.builder(
      itemCount: invoices.length,
      itemBuilder: (context, index) {
        final invoice = invoices[index];
        return InvoiceListTile(invoice: invoice);
      },
    );
  }
}
```

---

## 🧪 الاختبارات والجودة

### أنواع الاختبارات في Flutter

#### 1. Unit Tests

```dart
// test/features/invoices/domain/usecases/create_invoice_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

class MockInvoiceRepository extends Mock implements InvoiceRepository {}

void main() {
  late CreateInvoiceUseCase useCase;
  late MockInvoiceRepository mockRepository;

  setUp(() {
    mockRepository = MockInvoiceRepository();
    useCase = CreateInvoiceUseCase(mockRepository);
  });

  group('CreateInvoiceUseCase', () {
    const testInvoice = Invoice(
      id: '1',
      customerName: 'أحمد محمد',
      amount: 1000.0,
      createdAt: '2025-12-16',
      status: InvoiceStatus.draft,
    );

    test('should create invoice successfully', () async {
      // arrange
      when(mockRepository.createInvoice(any))
          .thenAnswer((_) async => const Right(testInvoice));

      // act
      final result = await useCase(CreateInvoiceParams(testInvoice));

      // assert
      expect(result, const Right(testInvoice));
      verify(mockRepository.createInvoice(testInvoice));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      when(mockRepository.createInvoice(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      // act
      final result = await useCase(CreateInvoiceParams(testInvoice));

      // assert
      expect(result, Left(ServerFailure()));
    });
  });
}
```

#### 2. Widget Tests

```dart
// test/features/invoices/presentation/widgets/invoice_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('InvoiceCard Widget', () {
    const testInvoice = Invoice(
      id: '1',
      customerName: 'أحمد محمد',
      amount: 1500.0,
      createdAt: '2025-12-16',
      status: InvoiceStatus.paid,
    );

    testWidgets('should display invoice information correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: InvoiceCard(invoice: testInvoice),
            ),
          ),
        ),
      );

      // التحقق من عرض اسم العميل
      expect(find.text('أحمد محمد'), findsOneWidget);

      // التحقق من عرض المبلغ
      expect(find.text('1,500.00 ر.س'), findsOneWidget);

      // التحقق من عرض الحالة
      expect(find.text('مدفوعة'), findsOneWidget);
    });

    testWidgets('should handle RTL layout correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            locale: const Locale('ar', 'SA'),
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: InvoiceCard(invoice: testInvoice),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // التحقق من اتجاه النص
      final cardWidget = tester.widget<Card>(find.byType(Card));
      expect(cardWidget, isNotNull);
    });
  });
}
```

#### 3. Integration Tests

```dart
// integration_test/invoice_flow_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:baseer_mvp/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Invoice Management Flow', () {
    testWidgets('complete invoice creation flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // الانتقال لصفحة إنشاء فاتورة
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // ملء بيانات الفاتورة
      await tester.enterText(
        find.byKey(const Key('customer_name_field')),
        'أحمد محمد',
      );

      await tester.enterText(
        find.byKey(const Key('amount_field')),
        '1500',
      );

      // حفظ الفاتورة
      await tester.tap(find.byKey(const Key('save_button')));
      await tester.pumpAndSettle();

      // التحقق من إنشاء الفاتورة
      expect(find.text('تم إنشاء الفاتورة بنجاح'), findsOneWidget);
      expect(find.text('أحمد محمد'), findsOneWidget);
    });
  });
}
```

### تشغيل الاختبارات

```bash
# تشغيل جميع الاختبارات
flutter test

# تشغيل اختبارات محددة
flutter test test/features/invoices/

# تشغيل مع تقرير التغطية
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# تشغيل اختبارات التكامل
flutter test integration_test/
```

---

## 🔒 الأمان وأفضل الممارسات

### تأمين البيانات المحلية

#### استخدام Flutter Secure Storage

```dart
// lib/core/security/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: <credential-fixture>,
    ),
  );

  // حفظ بيانات حساسة
  static Future<void> storeSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // قراءة بيانات حساسة
  static Future<String?> getSecureData(String key) async {
    return await _storage.read(key: key);
  }

  // حذف بيانات حساسة
  static Future<void> deleteSecureData(String key) async {
    await _storage.delete(key: key);
  }

  // مسح جميع البيانات
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
```

#### تشفير قاعدة البيانات

```dart
// lib/core/database/encrypted_database_service.dart
class EncryptedDatabaseService {
  static Future<void> initializeWithEncryption() async {
    final encryptionKey = await _getOrCreateEncryptionKey();

    _isar = await Isar.open(
      [InvoiceModelSchema, CustomerModelSchema],
      directory: await _getSecureDirectory(),
      // تشفير قاعدة البيانات
      encryptionKey: <credential-fixture>,
    );
  }

  static Future<List<int>> _getOrCreateEncryptionKey() async {
    const keyName = '<credential-fixture>';

    String? existingKey = await SecureStorageService.getSecureData(keyName);

    if (existingKey != null) {
      return base64Decode(existingKey);
    }

    // إنشاء مفتاح تشفير جديد
    final key = <credential-fixture>();
    await SecureStorageService.storeSecureData(
      keyName,
      base64Encode(key),
    );

    return key;
  }
}
```

### التحقق من صحة البيانات

```dart
// lib/core/validation/input_validators.dart
class InputValidators {
  // التحقق من اسم العميل العربي
  static String? validateArabicName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الاسم مطلوب';
    }

    if (value.trim().length < 2) {
      return 'الاسم يجب أن يكون أكثر من حرفين';
    }

    // التحقق من الأحرف العربية
    final arabicRegex = RegExp(r'^[\u0600-\u06FF\s]+$');
    if (!arabicRegex.hasMatch(value.trim())) {
      return 'الاسم يجب أن يكون باللغة العربية فقط';
    }

    return null;
  }

  // التحقق من رقم الهاتف السعودي
  static String? validateSaudiPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رقم الهاتف مطلوب';
    }

    final phoneRegex = RegExp(r'^05\d{8}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'رقم الهاتف يجب أن يبدأ بـ 05 ويتكون من 10 أرقام';
    }

    return null;
  }

  // التحقق من المبلغ
  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'المبلغ مطلوب';
    }

    final amount = double.tryParse(value.trim());
    if (amount == null) {
      return 'المبلغ يجب أن يكون رقماً صحيحاً';
    }

    if (amount <= 0) {
      return 'المبلغ يجب أن يكون أكبر من صفر';
    }

    if (amount > 1000000) {
      return 'المبلغ كبير جداً';
    }

    return null;
  }
}
```

---

## 📱 تحسين الأداء

### تحسين الويدجت

```dart
// lib/shared/widgets/optimized_invoice_list.dart
class OptimizedInvoiceList extends StatelessWidget {
  final List<Invoice> invoices;

  const OptimizedInvoiceList({
    super.key,
    required this.invoices,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // تحسين الأداء للقوائم الطويلة
      itemExtent: 80.0, // ارتفاع ثابت للعناصر
      cacheExtent: 200.0, // تخزين مؤقت للعناصر

      itemCount: invoices.length,
      itemBuilder: (context, index) {
        final invoice = invoices[index];

        // استخدام RepaintBoundary لتحسين الرسم
        return RepaintBoundary(
          child: InvoiceListTile(
            key: <credential-fixture>(invoice.id), // مفتاح فريد
            invoice: invoice,
          ),
        );
      },
    );
  }
}

// ويدجت محسنة للأداء
class InvoiceListTile extends StatelessWidget {
  final Invoice invoice;

  const InvoiceListTile({
    super.key,
    required this.invoice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(invoice.status),
          child: Text(
            invoice.customerName.substring(0, 1),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          invoice.customerName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'رقم الفاتورة: ${invoice.invoiceNumber}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${invoice.totalAmount.toStringAsFixed(2)} ر.س',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              _getStatusText(invoice.status),
              style: TextStyle(
                color: _getStatusColor(invoice.status),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.draft:
        return Colors.grey;
      case InvoiceStatus.sent:
        return Colors.blue;
      case InvoiceStatus.paid:
        return Colors.green;
      case InvoiceStatus.overdue:
        return Colors.red;
    }
  }

  String _getStatusText(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.draft:
        return 'مسودة';
      case InvoiceStatus.sent:
        return 'مرسلة';
      case InvoiceStatus.paid:
        return 'مدفوعة';
      case InvoiceStatus.overdue:
        return 'متأخرة';
    }
  }
}
```

### تحسين قاعدة البيانات

```dart
// lib/core/database/optimized_queries.dart
class OptimizedQueries {
  static Future<List<Invoice>> getRecentInvoices({int limit = 50}) async {
    final isar = DatabaseService.instance;

    return await isar.invoiceModels
        .where()
        .sortByCreatedAtDesc()
        .limit(limit) // تحديد عدد النتائج
        .findAll()
        .then((models) => models.map((m) => m.toEntity()).toList());
  }

  static Future<List<Invoice>> searchInvoicesOptimized(String query) async {
    final isar = DatabaseService.instance;

    // استخدام الفهارس للبحث السريع
    return await isar.invoiceModels
        .filter()
        .customerNameContains(query, caseSensitive: false)
        .or()
        .invoiceNumberContains(query, caseSensitive: false)
        .limit(20) // تحديد النتائج للبحث
        .findAll()
        .then((models) => models.map((m) => m.toEntity()).toList());
  }

  static Future<CustomerStats> getCustomerStatsOptimized(String customerId) async {
    final isar = DatabaseService.instance;

    // استعلام محسن للإحصائيات
    final invoices = await isar.invoiceModels
        .filter()
        .customerIdEqualTo(customerId)
        .findAll();

    return CustomerStats(
      totalInvoices: invoices.length,
      totalAmount: invoices.fold(0.0, (sum, inv) => sum + inv.totalAmount),
      paidAmount: invoices
          .where((inv) => inv.status == InvoiceStatus.paid)
          .fold(0.0, (sum, inv) => sum + inv.totalAmount),
    );
  }
}
```

---

## 🚀 النشر والتوزيع

### بناء التطبيق للإنتاج

#### Android APK/AAB

```bash
# بناء APK للتوزيع
flutter build apk --release

# بناء Android App Bundle (موصى به لـ Play Store)
flutter build appbundle --release

# بناء مع تحسينات إضافية
flutter build apk --release --shrink --obfuscate --split-debug-info=build/debug-info/
```

#### iOS IPA

```bash
# بناء للـ iOS (يتطلب macOS و Xcode)
flutter build ios --release

# بناء IPA للتوزيع
flutter build ipa --release
```

### إعداد التوقيع والشهادات

#### Android Signing

```bash
# إنشاء keystore
keytool -genkey -v -keystore baseer-release-key.keystore -alias baseer -keyalg RSA -keysize 2048 -validity 10000

# إعداد key.properties
echo "storePassword=your_store_password
keyPassword=<credential-fixture>
keyAlias=baseer
storeFile=../baseer-release-key.keystore" > android/key.properties
```

#### تحديث build.gradle

```gradle
// android/app/build.gradle
android {
    compileSdkVersion 34

    defaultConfig {
        applicationId "com.baseer.mvp"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName

        // دعم العربية
        resConfigs "ar", "en"
    }

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

---

## 🔧 أدوات التطوير المفيدة

### سكريبتات مفيدة

#### سكريبت التحقق من الجودة

```bash
#!/bin/bash
# scripts/quality_check.sh

echo "🔍 فحص جودة الكود..."

# تنسيق الكود
echo "📝 تنسيق الكود..."
dart format .

# تحليل الكود
echo "🔍 تحليل الكود..."
flutter analyze

# تشغيل الاختبارات
echo "🧪 تشغيل الاختبارات..."
flutter test

# فحص التبعيات
echo "📦 فحص التبعيات..."
flutter pub deps

echo "✅ اكتمل فحص الجودة"
```

#### سكريبت البناء والنشر

```bash
#!/bin/bash
# scripts/build_release.sh

echo "🚀 بناء إصدار الإنتاج..."

# تنظيف المشروع
flutter clean
flutter pub get

# إنشاء الكود المولد
dart run build_runner build --delete-conflicting-outputs

# بناء للأندرويد
echo "📱 بناء Android..."
flutter build appbundle --release

# بناء للويب (إذا كان مدعوماً)
echo "🌐 بناء Web..."
flutter build web --release

echo "✅ اكتمل البناء"
echo "📁 الملفات في: build/app/outputs/bundle/release/"
```

### إضافات VS Code المفيدة

```json
// .vscode/extensions.json
{
  "recommendations": [
    "dart-code.flutter",
    "dart-code.dart-code",
    "ms-vscode.vscode-json",
    "bradlc.vscode-tailwindcss",
    "usernamehw.errorlens",
    "gruntfuggly.todo-tree",
    "streetsidesoftware.code-spell-checker"
  ]
}
```

### إعدادات VS Code للمشروع

```json
// .vscode/settings.json
{
  "dart.flutterSdkPath": "flutter",
  "dart.lineLength": 80,
  "dart.insertArgumentPlaceholders": false,
  "dart.previewFlutterUiGuides": true,
  "dart.previewFlutterUiGuidesCustomTracking": true,
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  },
  "files.associations": {
    "*.dart": "dart"
  }
}
```

---

## 📚 مراجع ومصادر إضافية

### التوثيق الرسمي

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design 3](https://m3.material.io/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Isar Database](https://isar.dev/)

### أفضل الممارسات

- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Best Practices](https://docs.flutter.dev/development/best-practices)
- [Clean Architecture in Flutter](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

### مجتمع بصير

- **Slack**: #baseer-development
- **GitHub**: [مستودع المشروع]
- **Wiki**: [صفحة المشروع الداخلية]

---

## 🆘 استكشاف الأخطاء وإصلاحها

### مشاكل شائعة وحلولها

#### 1. مشاكل البناء

```bash
# مشكلة: فشل في بناء المشروع
# الحل:
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

#### 2. مشاكل قاعدة البيانات

```dart
// مشكلة: خطأ في Isar schema
// الحل: إعادة توليد الملفات
// dart run build_runner build --delete-conflicting-outputs
```

#### 3. مشاكل RTL

```dart
// مشكلة: عدم ظهور RTL بشكل صحيح
// الحل: التأكد من Directionality
return Directionality(
  textDirection: TextDirection.rtl,
  child: YourWidget(),
);
```

#### 4. مشاكل الأداء

```dart
// مشكلة: بطء في القوائم الطويلة
// الحل: استخدام ListView.builder مع RepaintBoundary
ListView.builder(
  itemExtent: 80.0, // ارتفاع ثابت
  itemBuilder: (context, index) => RepaintBoundary(
    child: YourListItem(data: items[index]),
  ),
);
```

### أدوات التشخيص

```bash
# فحص حالة Flutter
flutter doctor -v

# فحص الأداء
flutter run --profile

# تشغيل مع DevTools
flutter run --observatory-port=9999
```

---

## 🎉 الخلاصة

تهانينا! أنت الآن جاهز للبدء في تطوير مشروع بصير MVP. هذا الدليل يغطي:

### ما تعلمته:

- ✅ إعداد بيئة التطوير بـ Flutter/Dart
- ✅ بنية المشروع وClean Architecture
- ✅ تطوير واجهات مستخدم تدعم العربية والـ RTL
- ✅ إدارة البيانات المحلية مع Isar
- ✅ إدارة الحالة مع Riverpod
- ✅ كتابة الاختبارات الشاملة
- ✅ تطبيق معايير الأمان
- ✅ تحسين الأداء
- ✅ النشر والتوزيع

### الخطوات التالية:

1. **ابدأ بمهمة صغيرة**: اختر ميزة بسيطة وطبق عليها ما تعلمته
2. **اقرأ الكود الموجود**: استكشف الكود الحالي لفهم التطبيق العملي
3. **اكتب اختبارات**: ابدأ بكتابة اختبارات للكود الجديد
4. **شارك واطلب المساعدة**: لا تتردد في طلب المساعدة من الفريق

### نصائح للنجاح:

- 🎯 **ركز على الجودة**: اكتب كود نظيف ومختبر
- 📱 **فكر محلياً أولاً**: تذكر أن التطبيق local-first
- 🇸🇦 **اهتم بالعربية**: تأكد من دعم RTL في كل ما تطوره
- 🔒 **الأمان أولاً**: لا تتنازل عن الأمان أبداً
- 🤝 **تعاون مع الفريق**: شارك المعرفة واطلب المراجعة

---

**مرحباً بك في فريق بصير! نتطلع لمساهماتك المميزة** 🚀

---

**تم إعداد هذا الدليل بواسطة:** فريق وكلاء تطوير مشروع بصير  
**آخر تحديث:** 16 ديسمبر 2025  
**الإصدار:** 2.0 - محدث بالكامل لـ Flutter/Dart  
**للاستفسارات:** راجع قسم "مجتمع بصير" أعلاه
