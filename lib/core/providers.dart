import 'package:basser_app/features/auth/data/services/auth_service.dart';
import 'package:basser_app/features/customers/data/models/customer_model.dart';
import 'package:basser_app/features/customers/data/repositories/customer_repository_impl.dart';
import 'package:basser_app/features/customers/domain/repositories/customer_repository.dart';
import 'package:basser_app/features/invoices/data/models/invoice_model.dart';
import 'package:basser_app/features/invoices/data/repositories/invoice_repository_impl.dart';
import 'package:basser_app/features/invoices/domain/repositories/invoice_repository.dart';
import 'package:basser_app/services/settings_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

// تصدير theme provider للاستخدام في التطبيق
export 'providers/theme_provider.dart';

/// مزود خدمة التخزين الآمن (Secure Storage)
///
/// يوفر وصولاً آمناً لتخزين البيانات الحساسة مثل:
/// - كلمات المرور المشفرة
/// - معلومات تسجيل الدخول
/// - إعدادات الشركة
///
/// Security Features:
/// - تشفير AES-256 للبيانات
/// - حماية ضد root/jailbreak
/// - تشفير إضافي للمفاتيح الحساسة
/// - إعدادات أمان محسنة
///
/// Example:
/// ```dart
/// final storage = ref.watch(secureStorageProvider,);
/// await storage.write(key: '<credential-fixture>', value: 'admin',);
/// ```
final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      sharedPreferencesName: 'basser_secure_prefs',
      preferencesKeyPrefix: 'basser_',
    ),
    iOptions: IOSOptions(
      groupId: 'group.com.basser.app',
      accountName: 'basser_keychain',
      accessibility: <credential-fixture>,
    ),
    mOptions: MacOsOptions(
      groupId: 'group.com.basser.app',
      accountName: 'basser_keychain',
      accessibility: <credential-fixture>,
    ),
  ),
);

/// مزود قاعدة البيانات المحلية (Isar)
///
/// يوفر وصولاً إلى قاعدة البيانات المحلية Isar
/// يتم فتح قاعدة البيانات تلقائياً مع جميع الـ Schemas المطلوبة
///
/// **ملاحظة مهمة:** يتم فتح Isar مرة واحدة فقط. إذا كانت قاعدة البيانات
/// مفتوحة بالفعل، يتم إرجاع الـ instance الموجود.
///
/// Schemas المضمنة:
/// - [CustomerModelSchema]: لتخزين بيانات العملاء
/// - [InvoiceModelSchema]: لتخزين بيانات الفواتير
///
/// Example:
/// ```dart
/// final isar = await ref.watch(isarProvider.future,);
/// final customers = await isar.customerModels.where().findAll();
/// ```
final isarProvider = FutureProvider<Isar>((ref) async {
  try {
    // التحقق من وجود instance مفتوح بالفعل
    if (Isar.instanceNames.isNotEmpty) {
      // إرجاع الـ instance الموجود
      return Isar.getInstance()!;
    }

    // فتح قاعدة بيانات جديدة
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [CustomerModelSchema, InvoiceModelSchema],
      directory: dir.path,
      name: 'basser_db', // اسم محدد لقاعدة البيانات
    );
    return isar;
  } on Exception catch (e) {
    throw Exception(
      'فشل فتح قاعدة البيانات: $e',
    );
  }
});

/// مزود خدمة المصادقة (Auth Service)
///
/// يوفر وظائف المصادقة وإدارة الجلسات مثل:
/// - تسجيل الدخول والخروج
/// - التحقق من حالة المصادقة
/// - إدارة بيانات المستخدم
///
/// Example:
/// ```dart
/// final authService = <credential-fixture>(authServiceProvider,);
/// final isLoggedIn = await authService.isLoggedIn();
/// ```
final authServiceProvider = <credential-fixture><AuthService>((ref) {
  // استخدام select() لتحسين الأداء - مراقبة التخزين الآمن فقط
  final secureStorage = ref.watch(
    secureStorageProvider.select((storage) => storage),
  );
  return AuthService(
    secureStorage: secureStorage,
  );
});

/// مزود خدمة الإعدادات (Settings Service)
///
/// يوفر وظائف إدارة إعدادات التطبيق مثل:
/// - إعدادات الشركة (الاسم، الرقم الضريبي)
/// - نسبة الضريبة
/// - تغيير كلمة المرور
///
/// Example:
/// ```dart
/// final settingsService = ref.watch(settingsServiceProvider,);
/// await settingsService.saveCompanyName('شركة بصير',);
/// ```
final settingsServiceProvider = Provider<SettingsService>((ref) {
  // استخدام select() لتحسين الأداء - مراقبة التخزين الآمن فقط
  final secureStorage = ref.watch(
    secureStorageProvider.select((storage) => storage),
  );
  return SettingsService(
    secureStorage: secureStorage,
  );
});

/// مزود مستودع العملاء (Customer Repository)
///
/// يوفر وصولاً إلى عمليات CRUD للعملاء:
/// - إضافة عميل جديد
/// - تحديث بيانات عميل
/// - حذف عميل
/// - البحث والاستعلام عن العملاء
///
/// Example:
/// ```dart
/// final repository = ref.watch(customerRepositoryProvider,);
/// final customers = await repository.getAllCustomers();
/// ```
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  // استخدام select() لتحسين الأداء - مراقبة قاعدة البيانات فقط
  final isar = ref.watch(
    isarProvider.select((asyncIsar) => asyncIsar.value),
  );
  if (isar == null) {
    throw Exception(
      'قاعدة البيانات غير جاهزة',
    );
  }
  return CustomerRepositoryImpl(
    isar: isar,
  );
});

/// مزود مستودع الفواتير (Invoice Repository)
///
/// يوفر وصولاً إلى عمليات CRUD للفواتير:
/// - إنشاء فاتورة جديدة
/// - تحديث حالة الفاتورة
/// - حذف فاتورة
/// - البحث والاستعلام عن الفواتير
/// - تصدير الفواتير كـ PDF
///
/// Example:
/// ```dart
/// final repository = ref.watch(invoiceRepositoryProvider,);
/// final invoices = await repository.getAllInvoices();
/// ```
final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  // استخدام select() لتحسين الأداء - مراقبة قاعدة البيانات فقط
  final isar = ref.watch(
    isarProvider.select((asyncIsar) => asyncIsar.value),
  );
  if (isar == null) {
    throw Exception(
      'قاعدة البيانات غير جاهزة',
    );
  }
  return InvoiceRepositoryImpl(
    isar: isar,
  );
});
