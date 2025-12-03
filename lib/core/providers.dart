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

/// مزود خدمة التخزين الآمن (Secure Storage)
///
/// يوفر وصولاً آمناً لتخزين البيانات الحساسة مثل:
/// - كلمات المرور المشفرة
/// - معلومات تسجيل الدخول
/// - إعدادات الشركة
///
/// Example:
/// ```dart
/// final storage = ref.watch(secureStorageProvider);
/// await storage.write(key: 'username', value: 'admin');
/// ```
final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

/// مزود قاعدة البيانات المحلية (Isar)
///
/// يوفر وصولاً إلى قاعدة البيانات المحلية Isar
/// يستخدم الـ instance المفتوحة مسبقاً في main.dart
///
/// Schemas المضمنة:
/// - [CustomerModelSchema]: لتخزين بيانات العملاء
/// - [InvoiceModelSchema]: لتخزين بيانات الفواتير
///
/// Example:
/// ```dart
/// final isar = ref.watch(isarProvider);
/// final customers = await isar.customerModels.where().findAll();
/// ```
final isarProvider = Provider<Isar>(
  // استخدام الـ instance المفتوحة في main.dart
  // تجنب فتح instance جديدة
  (ref) => Isar.getInstance()!,
);

/// مزود خدمة المصادقة (Auth Service)
///
/// يوفر وظائف المصادقة وإدارة الجلسات مثل:
/// - تسجيل الدخول والخروج
/// - التحقق من حالة المصادقة
/// - إدارة بيانات المستخدم
///
/// Example:
/// ```dart
/// final authService = ref.watch(authServiceProvider);
/// final isLoggedIn = await authService.isLoggedIn();
/// ```
final authServiceProvider = Provider<AuthService>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthService(secureStorage: secureStorage);
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
/// final settingsService = ref.watch(settingsServiceProvider);
/// await settingsService.saveCompanyName('شركة بصير');
/// ```
final settingsServiceProvider = Provider<SettingsService>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return SettingsService(secureStorage: secureStorage);
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
/// final repository = ref.watch(customerRepositoryProvider);
/// final customers = await repository.getAllCustomers();
/// ```
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return CustomerRepositoryImpl(isar: isar);
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
/// final repository = ref.watch(invoiceRepositoryProvider);
/// final invoices = await repository.getAllInvoices();
/// ```
final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return InvoiceRepositoryImpl(isar: isar);
});
