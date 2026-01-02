import 'package:basir_app/core/providers/secure_storage_provider.dart';
import 'package:basir_app/features/customers/data/models/customer_model.dart';
import 'package:basir_app/features/customers/data/repositories/customer_repository_impl.dart';
import 'package:basir_app/features/customers/data/services/contact_service.dart';
import 'package:basir_app/features/customers/domain/repositories/customer_repository.dart';
import 'package:basir_app/features/invoices/data/models/invoice_model.dart';
import 'package:basir_app/features/invoices/data/repositories/invoice_repository_impl.dart';
import 'package:basir_app/features/invoices/data/services/sharing_service.dart';
import 'package:basir_app/features/invoices/domain/repositories/invoice_repository.dart';
import 'package:basir_app/services/settings_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

// تصدير مزودات المصادقة من مكانها الجديد
export '../features/auth/presentation/providers/auth_provider.dart';
// تصدير المزودات الأساسية
export 'providers/calendar_provider.dart';
export 'providers/locale_provider.dart';
export 'providers/secure_storage_provider.dart';
export 'providers/theme_provider.dart';
export 'services/notification_service.dart';
export 'theme/services/icon_customization_service.dart';

/// مزود خدمة الإعدادات (Settings Service)
///
/// يوفر وظائف إدارة إعدادات التطبيق مثل:
/// - إعدادات الشركة (الاسم، الرقم الضريبي)
/// - نسبة الضريبة
/// - تغيير كلمة المرور
final settingsServiceProvider = Provider<SettingsService>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return SettingsService(
    secureStorage: secureStorage,
  );
});

/// مزود إعدادات الشركة والتخصيص
final companySettingsProvider = FutureProvider<Map<String, String?>>(
  (ref) => ref.watch(settingsServiceProvider).getCompanySettings(),
);

/// مزود خدمة جهات الاتصال (Contact Service)
final contactServiceProvider = Provider<ContactService>(
  (ref) => ContactService(),
);

/// مزود خدمة المشاركة (Sharing Service)
final sharingServiceProvider = Provider<SharingService>(
  (ref) => SharingService(),
);

/// مزود قاعدة البيانات المحلية (Isar)
final isarProvider = FutureProvider<Isar>((ref) async {
  try {
    if (Isar.instanceNames.isNotEmpty) {
      return Isar.getInstance()!;
    }

    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [CustomerModelSchema, InvoiceModelSchema],
      directory: dir.path,
      name: 'basir_db',
      // Note: Isar 3.1.0 does not support native encryption
      // Data is protected by device-level encryption
    );
    return isar;
  } on Exception catch (e) {
    debugPrint('❌ [ISAR] Critical error opening database: $e');
    throw Exception('فشل فتح قاعدة البيانات: $e');
  }
});

/// مزود مستودع العملاء (Customer Repository)
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final isar = ref.watch(isarProvider.select((asyncIsar) => asyncIsar.value));
  if (isar == null) {
    throw Exception('قاعدة البيانات غير جاهزة');
  }
  return CustomerRepositoryImpl(isar: isar);
});

/// مزود مستودع الفواتير (Invoice Repository)
final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  final isar = ref.watch(isarProvider.select((asyncIsar) => asyncIsar.value));
  if (isar == null) {
    throw Exception('قاعدة البيانات غير جاهزة');
  }
  return InvoiceRepositoryImpl(isar: isar);
});
