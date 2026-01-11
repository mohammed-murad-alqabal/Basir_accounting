import 'package:basir_app/core/providers/secure_storage_provider.dart';
import 'package:basir_app/features/accounting/data/models/account_model.dart';
import 'package:basir_app/features/accounting/data/models/financial_voucher_model.dart';
import 'package:basir_app/features/accounting/data/models/financial_year_model.dart';
import 'package:basir_app/features/accounting/data/models/journal_entry_model.dart';
import 'package:basir_app/features/accounting/data/repositories/financial_voucher_repository_impl.dart';
import 'package:basir_app/features/accounting/data/repositories/financial_year_repository_impl.dart';
import 'package:basir_app/features/accounting/domain/repositories/financial_voucher_repository.dart';
import 'package:basir_app/features/accounting/domain/repositories/financial_year_repository.dart';
import 'package:basir_app/features/analytics/domain/entities/analytics_event.dart';
import 'package:basir_app/features/assets/data/models/asset_category_model.dart';
import 'package:basir_app/features/assets/data/models/fixed_asset_model.dart';
import 'package:basir_app/features/assets/data/repositories/asset_repository_impl.dart';
import 'package:basir_app/features/assets/domain/repositories/asset_repository.dart';
import 'package:basir_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:basir_app/features/customers/data/models/customer_model.dart';
import 'package:basir_app/features/customers/data/repositories/customer_repository_impl.dart';
import 'package:basir_app/features/customers/data/services/contact_service.dart';
import 'package:basir_app/features/customers/domain/repositories/customer_repository.dart';
import 'package:basir_app/features/inventory/data/models/inventory_item_model.dart';
import 'package:basir_app/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:basir_app/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:basir_app/features/invoices/data/models/invoice_model.dart';
import 'package:basir_app/features/invoices/data/repositories/invoice_repository_impl.dart';
import 'package:basir_app/features/invoices/data/services/sharing_service.dart';
import 'package:basir_app/features/invoices/domain/repositories/invoice_repository.dart';
import 'package:basir_app/features/settings/data/models/business_settings_model.dart';
import 'package:basir_app/features/settings/data/models/profile_model.dart';
import 'package:basir_app/features/settings/data/repositories/business_settings_repository_impl.dart';
import 'package:basir_app/features/settings/data/repositories/profile_repository_impl.dart';
import 'package:basir_app/features/settings/domain/repositories/business_settings_repository.dart';
import 'package:basir_app/features/settings/domain/repositories/profile_repository.dart';
import 'package:basir_app/features/vendors/data/models/vendor_model.dart';
import 'package:basir_app/features/vendors/data/repositories/vendor_repository_impl.dart';
import 'package:basir_app/features/vendors/domain/repositories/vendor_repository.dart';
import 'package:basir_app/services/settings_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

export '../features/accounting/data/repositories/accounting_repository_impl.dart';
// تصدير مزودات المصادقة من مكانها الجديد
export '../features/auth/presentation/providers/auth_provider.dart';
export '../features/reports/services/reporting_service.dart';
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
  final businessSettingsRepository = ref.watch(
    businessSettingsRepositoryProvider,
  );
  final profileRepository = ref.watch(profileRepositoryProvider);

  return SettingsService(
    secureStorage: secureStorage,
    businessSettingsRepository: businessSettingsRepository,
    profileRepository: profileRepository,
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
      [
        CustomerModelSchema,
        InvoiceModelSchema,
        FinancialYearModelSchema,
        AccountModelSchema,
        JournalEntryModelSchema,
        VendorModelSchema,
        FinancialVoucherModelSchema,
        AnalyticsEventSchema,
        ProfileModelSchema,
        BusinessSettingsModelSchema,
        InventoryItemModelSchema,
        FixedAssetModelSchema,
        AssetCategoryModelSchema,
      ],
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
  final user = ref.watch(basirUserProvider);
  return CustomerRepositoryImpl(isar: isar, userId: user?.id);
});

/// مزود مستودع الفواتير (Invoice Repository)
final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  final isar = ref.watch(isarProvider.select((asyncIsar) => asyncIsar.value));
  if (isar == null) {
    throw Exception('قاعدة البيانات غير جاهزة');
  }
  final user = ref.watch(basirUserProvider);
  return InvoiceRepositoryImpl(
    isar: isar,
    userId: user?.id,
    warehouseId: user?.warehouseId,
  );
});

/// مزود مستودع السنوات المالية (Financial Year Repository)
final financialYearRepositoryProvider = Provider<FinancialYearRepository>((
  ref,
) {
  final isar = ref.watch(isarProvider.select((asyncIsar) => asyncIsar.value));
  if (isar == null) {
    throw Exception('قاعدة البيانات غير جاهزة');
  }
  final user = ref.watch(basirUserProvider);
  return FinancialYearRepositoryImpl(isar: isar, userId: user?.id);
});

/// مزود مستودع الموردين (Vendor Repository)
final vendorRepositoryProvider = Provider<VendorRepository>((ref) {
  final isar = ref.watch(isarProvider.select((asyncIsar) => asyncIsar.value));
  if (isar == null) {
    throw Exception('قاعدة البيانات غير جاهزة');
  }
  final user = ref.watch(basirUserProvider);
  return VendorRepositoryImpl(isar: isar, userId: user?.id);
});

/// مزود مستودع السندات المالية (Financial Voucher Repository)
final financialVoucherRepositoryProvider = Provider<FinancialVoucherRepository>(
  (ref) {
    final isar = ref.watch(isarProvider.select((asyncIsar) => asyncIsar.value));
    if (isar == null) {
      throw Exception('قاعدة البيانات غير جاهزة');
    }
    final user = ref.watch(basirUserProvider);
    return FinancialVoucherRepositoryImpl(isar: isar, userId: user?.id);
  },
);

/// مزود مستودع الملف الشخصي (Profile Repository)
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final isar = ref.watch(isarProvider.select((asyncIsar) => asyncIsar.value));
  if (isar == null) throw Exception('قاعدة البيانات غير جاهزة');
  final user = ref.watch(basirUserProvider);
  return ProfileRepositoryImpl(isar: isar, userId: user?.id);
});

/// مزود مستودع إعدادات العمل (Business Settings Repository)
final businessSettingsRepositoryProvider = Provider<BusinessSettingsRepository>(
  (ref) {
    final isar = ref.watch(isarProvider.select((asyncIsar) => asyncIsar.value));
    if (isar == null) throw Exception('قاعدة البيانات غير جاهزة');
    final user = ref.watch(basirUserProvider);
    return BusinessSettingsRepositoryImpl(isar: isar, userId: user?.id);
  },
);

/// مزود مستودع المخزون (Inventory Repository)
final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final isar = ref.watch(isarProvider.select((asyncIsar) => asyncIsar.value));
  if (isar == null) {
    throw Exception('قاعدة البيانات غير جاهزة');
  }
  final user = ref.watch(basirUserProvider);
  return InventoryRepositoryImpl(
    isar: isar,
    userId: user?.id,
    warehouseId: user?.warehouseId,
  );
});

/// مزود مستودع الأصول (Asset Repository)
final assetRepositoryProvider = Provider<AssetRepository>((ref) {
  final isar = ref.watch(isarProvider.select((asyncIsar) => asyncIsar.value));
  if (isar == null) {
    throw Exception('قاعدة البيانات غير جاهزة');
  }
  final user = ref.watch(basirUserProvider);
  return AssetRepositoryImpl(isar: isar, userId: user?.id);
});
