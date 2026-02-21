// ignore_for_file: lines_longer_than_80_chars
import 'dart:io';

import 'package:basir_accounting_system/core/providers/secure_storage_provider.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/data/models/account_model.dart';
import 'package:basir_accounting_system/features/accounting/data/models/financial_voucher_model.dart';
import 'package:basir_accounting_system/features/accounting/data/models/financial_year_model.dart';
import 'package:basir_accounting_system/features/accounting/data/models/journal_entry_model.dart';
import 'package:basir_accounting_system/features/accounting/data/repositories/financial_voucher_repository_impl.dart';
import 'package:basir_accounting_system/features/accounting/data/repositories/financial_year_repository_impl.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/financial_voucher_repository.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/financial_year_repository.dart';
import 'package:basir_accounting_system/features/analytics/domain/entities/analytics_event.dart';
import 'package:basir_accounting_system/features/assets/data/models/asset_category_model.dart';
import 'package:basir_accounting_system/features/assets/data/models/fixed_asset_model.dart';
import 'package:basir_accounting_system/features/assets/data/repositories/asset_repository_impl.dart';
import 'package:basir_accounting_system/features/assets/domain/repositories/asset_repository.dart';
import 'package:basir_accounting_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:basir_accounting_system/features/budget/application/budget_service.dart';
import 'package:basir_accounting_system/features/budget/data/models/budget_model.dart';
import 'package:basir_accounting_system/features/budget/data/repositories/isar_budget_repository.dart';
import 'package:basir_accounting_system/features/budget/domain/repositories/budget_repository.dart';
import 'package:basir_accounting_system/features/customers/data/models/customer_model.dart';
import 'package:basir_accounting_system/features/customers/data/repositories/customer_repository_impl.dart';
import 'package:basir_accounting_system/features/customers/data/services/contact_service.dart';
import 'package:basir_accounting_system/features/customers/domain/repositories/customer_repository.dart';
import 'package:basir_accounting_system/features/goals/application/goal_service.dart';
import 'package:basir_accounting_system/features/goals/data/models/goal_model.dart';
import 'package:basir_accounting_system/features/goals/data/repositories/isar_goal_repository.dart';
import 'package:basir_accounting_system/features/goals/domain/repositories/goal_repository.dart';
import 'package:basir_accounting_system/features/inventory/application/inventory_service.dart';
import 'package:basir_accounting_system/features/inventory/data/models/inventory_item_model.dart';
import 'package:basir_accounting_system/features/inventory/data/models/stock_movement_model.dart';
import 'package:basir_accounting_system/features/inventory/data/models/warehouse_model.dart';
import 'package:basir_accounting_system/features/inventory/data/models/warehouse_transfer_model.dart';
import 'package:basir_accounting_system/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:basir_accounting_system/features/inventory/data/repositories/stock_movement_repository_impl.dart';
import 'package:basir_accounting_system/features/inventory/data/repositories/warehouse_repository_impl.dart';
import 'package:basir_accounting_system/features/inventory/data/repositories/warehouse_transfer_repository_impl.dart';
import 'package:basir_accounting_system/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:basir_accounting_system/features/inventory/domain/repositories/stock_movement_repository.dart';
import 'package:basir_accounting_system/features/inventory/domain/repositories/warehouse_repository.dart';
import 'package:basir_accounting_system/features/inventory/domain/repositories/warehouse_transfer_repository.dart';
import 'package:basir_accounting_system/features/invoices/data/models/invoice_model.dart';
import 'package:basir_accounting_system/features/invoices/data/repositories/invoice_repository_impl.dart';
import 'package:basir_accounting_system/features/invoices/data/services/sharing_service.dart';
import 'package:basir_accounting_system/features/invoices/domain/repositories/invoice_repository.dart';
import 'package:basir_accounting_system/features/reports/application/fair_valuation_service.dart';
import 'package:basir_accounting_system/features/reports/data/models/market_price_model.dart';
import 'package:basir_accounting_system/features/reports/data/repositories/market_price_repository_impl.dart';
import 'package:basir_accounting_system/features/reports/domain/repositories/market_price_repository.dart';
import 'package:basir_accounting_system/features/settings/data/models/barcode_config_model.dart';
import 'package:basir_accounting_system/features/settings/data/models/business_settings_model.dart';
import 'package:basir_accounting_system/features/settings/data/models/profile_model.dart';
import 'package:basir_accounting_system/features/settings/data/repositories/business_settings_repository_impl.dart';
import 'package:basir_accounting_system/features/settings/data/repositories/isar_barcode_config_repository.dart';
import 'package:basir_accounting_system/features/settings/data/repositories/profile_repository_impl.dart';
import 'package:basir_accounting_system/features/settings/domain/repositories/barcode_config_repository.dart';
import 'package:basir_accounting_system/features/settings/domain/repositories/business_settings_repository.dart';
import 'package:basir_accounting_system/features/settings/domain/repositories/profile_repository.dart';
import 'package:basir_accounting_system/features/users/data/models/user_model.dart';
import 'package:basir_accounting_system/features/users/data/repositories/user_repository_impl.dart';
import 'package:basir_accounting_system/features/users/domain/repositories/user_repository.dart';
import 'package:basir_accounting_system/features/vendors/data/models/vendor_model.dart';
import 'package:basir_accounting_system/features/vendors/data/repositories/vendor_repository_impl.dart';
import 'package:basir_accounting_system/features/vendors/domain/repositories/vendor_repository.dart';
import 'package:basir_accounting_system/services/settings_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

export '../features/accounting/data/repositories/accounting_repository_impl.dart';
export '../features/analytics/application/analytics_service.dart';
// تصدير مزودات المصادقة من مكانها الجديد
export '../features/auth/presentation/providers/auth_provider.dart';
export '../features/reports/application/pdf_generation_service.dart';
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
    final dbPath = '${dir.path}/basir_db.isar';
    final restorePath = '$dbPath.restore';

    // التحقق من وجود نسخة للاستعادة
    final restoreFile = File(restorePath);
    // ignore: avoid_slow_async_io
    if (await restoreFile.exists()) {
      debugPrint('🔄 [ISAR] Restore file detected, applying...');
      final dbFile = File(dbPath);
      // ignore: avoid_slow_async_io
      if (await dbFile.exists()) {
        // ignore: avoid_slow_async_io
        await dbFile.delete();
      }
      // ignore: avoid_slow_async_io
      await restoreFile.rename(dbPath);
      debugPrint('✅ [ISAR] Database restored successfully');
    }

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
        StockMovementModelSchema,
        WarehouseTransferModelSchema,
        FixedAssetModelSchema,
        AssetCategoryModelSchema,
        WarehouseModelSchema,
        MarketPriceModelSchema,
        UserModelSchema,
        BarcodeConfigModelSchema,
        BudgetModelSchema,
        GoalModelSchema,
      ],
      directory: dir.path,
      name: 'basir_db',
      // Note: Isar 3.1.0 does not support native encryption
      // Data is protected by device-level encryption
    );
    // Seed default warehouses if none exist
    final count = await isar.warehouseModels.count();
    if (count == 0) {
      await isar.writeTxn(() async {
        await isar.warehouseModels.putAll([
          WarehouseModel()
            ..id = 'wh-main'
            ..nameAr = 'المستودع الرئيسي'
            ..nameEn = 'Main Warehouse'
            ..createdAt = DateTime.now()
            ..updatedAt = DateTime.now(),
          WarehouseModel()
            ..id = 'wh-retail'
            ..nameAr = 'مستودع التجزئة'
            ..nameEn = 'Retail Warehouse'
            ..createdAt = DateTime.now()
            ..updatedAt = DateTime.now(),
        ]);
      });
    }

    return isar;
  } on Exception catch (e) {
    debugPrint('❌ [ISAR] Critical error opening database: $e');
    throw Exception('فشل فتح قاعدة البيانات: $e');
  }
});

/// مزود مستودع العملاء (Customer Repository) - Performance Optimized
final customerRepositoryProvider =
    Provider.autoDispose<CustomerRepository>((ref) {
  final isar = ref.watch(isarProvider.select((asyncIsar) => asyncIsar.value));
  if (isar == null) {
    throw Exception('قاعدة البيانات غير جاهزة');
  }
  final user = ref.watch(basirUserProvider);
  return CustomerRepositoryImpl(isar: isar, userId: user?.id);
});

/// مزود مستودع الفواتير (Invoice Repository) - Performance Optimized
final invoiceRepositoryProvider =
    Provider.autoDispose<InvoiceRepository>((ref) {
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

/// مزود مستودع الأصول (Asset Repository) - Performance Optimized
final assetRepositoryProvider = Provider.autoDispose<AssetRepository>((ref) {
  final isar = ref.watch(isarProvider.select((asyncIsar) => asyncIsar.value));
  if (isar == null) {
    throw Exception('قاعدة البيانات غير جاهزة');
  }
  final user = ref.watch(basirUserProvider);
  return AssetRepositoryImpl(isar: isar, userId: user?.id);
});

/// مزود مستودع حركات المخزون (Stock Movement Repository) - Performance Optimized
final stockMovementRepositoryProvider =
    Provider.autoDispose<StockMovementRepository>((ref) {
  final isar = ref.watch(isarProvider.select((asyncIsar) => asyncIsar.value));
  if (isar == null) throw Exception('قاعدة البيانات غير جاهزة');
  final user = ref.watch(basirUserProvider);
  return StockMovementRepositoryImpl(
    isar: isar,
    userId: user?.id,
    warehouseId: user?.warehouseId,
  );
});

/// مزود مستودع تحويلات المخزون (Warehouse Transfer Repository) - Performance Optimized
final warehouseTransferRepositoryProvider =
    Provider.autoDispose<WarehouseTransferRepository>((ref) {
  final isar = ref.watch(isarProvider.select((asyncIsar) => asyncIsar.value));
  if (isar == null) throw Exception('قاعدة البيانات غير جاهزة');
  final user = ref.watch(basirUserProvider);
  return WarehouseTransferRepositoryImpl(
    isar: isar,
    userId: user?.id,
    warehouseId: user?.warehouseId,
  );
});

/// مزود خدمة المخزون (Inventory Service) - Performance Optimized
final inventoryServiceProvider = Provider.autoDispose<InventoryService>((ref) {
  final inventoryRepo = ref.watch(inventoryRepositoryProvider);
  final movementRepo = ref.watch(stockMovementRepositoryProvider);
  final transferRepo = ref.watch(warehouseTransferRepositoryProvider);

  return InventoryService(
    inventoryRepo: inventoryRepo,
    movementRepo: movementRepo,
    transferRepo: transferRepo,
  );
});

/// مزود مستودع المستودعات (Warehouse Repository)
final warehouseRepositoryProvider = Provider<WarehouseRepository>((ref) {
  final isar = ref.watch(
    isarProvider.select((asyncIsar) => asyncIsar.value),
  );
  if (isar == null) throw Exception('قاعدة البيانات غير جاهزة');
  final user = ref.watch(basirUserProvider);
  return WarehouseRepositoryImpl(isar: isar, userId: user?.id);
});

/// مزود مستودع أسعار السوق (Market Price Repository)
final marketPriceRepositoryProvider = Provider<MarketPriceRepository>((ref) {
  final isar = ref.watch(
    isarProvider.select((asyncIsar) => asyncIsar.value),
  );
  if (isar == null) throw Exception('قاعدة البيانات غير جاهزة');
  return MarketPriceRepositoryImpl(isar: isar);
});

/// مزود خدمة التقييم العادل (Fair Valuation Service)
final fairValuationServiceProvider = Provider<FairValuationService>((ref) {
  final marketPriceRepo = ref.watch(marketPriceRepositoryProvider);
  final movementRepo = ref.watch(stockMovementRepositoryProvider);
  final inventoryRepo = ref.watch(inventoryRepositoryProvider);

  return FairValuationService(
    marketPriceRepo: marketPriceRepo,
    movementRepo: movementRepo,
    inventoryRepo: inventoryRepo,
  );
});

/// مزود مستودع المستخدمين (User Repository)
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final isar = ref.watch(isarProvider.select((async) => async.value));
  if (isar == null) throw Exception('قاعدة البيانات غير جاهزة');
  return UserRepositoryImpl(isar);
});

/// مزود مستودع إعدادات الباركود (Barcode Config Repository)
final barcodeConfigRepositoryProvider =
    Provider<BarcodeConfigRepository>((ref) {
  final isar = ref.watch(isarProvider.select((async) => async.value));
  if (isar == null) throw Exception('قاعدة البيانات غير جاهزة');
  return IsarBarcodeConfigRepository(isar);
});

/// مزود مستودع الميزانية (Budget Repository)
final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  final isar = ref.watch(isarProvider.select((async) => async.value));
  if (isar == null) throw Exception('قاعدة البيانات غير جاهزة');
  final user = ref.watch(basirUserProvider);
  return IsarBudgetRepository(isar, userId: user?.id);
});

/// مزود خدمة الميزانية (Budget Service)
final budgetServiceProvider = Provider<BudgetService>((ref) {
  final budgetRepo = ref.watch(budgetRepositoryProvider);
  return BudgetService(budgetRepo);
});

/// مزود مستودع الأهداف (Goal Repository)
final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  final isar = ref.watch(isarProvider.select((async) => async.value));
  if (isar == null) throw Exception('قاعدة البيانات غير جاهزة');
  final user = ref.watch(basirUserProvider);
  return IsarGoalRepository(isar, userId: user?.id);
});

/// مزود خدمة الأهداف (Goal Service)
final goalServiceProvider = Provider<GoalService>((ref) {
  final goalRepo = ref.watch(goalRepositoryProvider);
  return GoalService(goalRepo);
});

/// Provider for Google Sign-In instance.
/// Note: In google_sign_in v7.x, scopes are set via initialize() call.
final googleSignInProvider = Provider<GoogleSignIn>(
  (ref) => GoogleSignIn.instance,
);

/// Provider for the complete list of accounts.
final getAccountsProvider = FutureProvider.autoDispose<List<Account>>((ref) {
  final service = ref.watch(accountingServiceProvider.notifier);
  return service.getAccounts();
});
