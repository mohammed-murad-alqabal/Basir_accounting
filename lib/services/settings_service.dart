import 'package:basir_app/core/constants.dart';
import 'package:basir_app/core/models/sync_status.dart';
import 'package:basir_app/features/settings/domain/entities/business_settings.dart';
import 'package:basir_app/features/settings/domain/repositories/business_settings_repository.dart';
import 'package:basir_app/features/settings/domain/repositories/profile_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// خدمة الإعدادات (Settings Service)
/// تتعامل مع تخزين واسترجاع إعدادات التطبيق
class SettingsService {
  /// إنشاء خدمة الإعدادات
  SettingsService({
    required this.secureStorage,
    required this.businessSettingsRepository,
    required this.profileRepository,
  });

  /// خدمة التخزين الآمن
  final FlutterSecureStorage secureStorage;

  /// مستودع إعدادات العمل
  final BusinessSettingsRepository businessSettingsRepository;

  /// مستودع الملف الشخصي
  final ProfileRepository profileRepository;

  /// الحصول على نسبة الضريبة
  Future<double> getTaxRate() async {
    final settings = await businessSettingsRepository.getSettings();
    return settings?.defaultTaxRate ?? AppConfig.defaultTaxRate;
  }

  /// تعيين نسبة الضريبة
  Future<void> setTaxRate(double taxRate) async {
    final settings = await businessSettingsRepository.getSettings() ??
        const BusinessSettings(id: 'default', companyName: '');
    await businessSettingsRepository.saveSettings(
      settings.copyWith(
        defaultTaxRate: taxRate,
        syncStatus: SyncStatus.pendingPush,
      ),
    );
  }

  /// الحصول على اسم الشركة
  Future<String?> getCompanyName() async {
    final settings = await businessSettingsRepository.getSettings();
    return settings?.companyName;
  }

  /// تعيين اسم الشركة
  Future<void> setCompanyName(String companyName) async {
    final settings = await businessSettingsRepository.getSettings() ??
        BusinessSettings(id: 'default', companyName: companyName);
    await businessSettingsRepository.saveSettings(
      settings.copyWith(
        companyName: companyName,
        syncStatus: SyncStatus.pendingPush,
      ),
    );
  }

  /// الحصول على الرقم الضريبي للشركة
  Future<String?> getCompanyTaxNumber() async {
    final settings = await businessSettingsRepository.getSettings();
    return settings?.taxNumber;
  }

  /// تعيين الرقم الضريبي للشركة
  Future<void> setCompanyTaxNumber(String taxNumber) async {
    final settings = await businessSettingsRepository.getSettings() ??
        const BusinessSettings(id: 'default', companyName: '');
    await businessSettingsRepository.saveSettings(
      settings.copyWith(
        taxNumber: taxNumber,
        syncStatus: SyncStatus.pendingPush,
      ),
    );
  }

  /// الحصول على رمز العملة
  Future<String> getCurrencySymbol() async {
    final settings = await businessSettingsRepository.getSettings();
    return settings?.currencySymbol ?? AppConfig.defaultCurrencySymbol;
  }

  /// تعيين رمز العملة
  Future<void> setCurrencySymbol(String symbol) async {
    final settings = await businessSettingsRepository.getSettings() ??
        const BusinessSettings(id: 'default', companyName: '');
    await businessSettingsRepository.saveSettings(
      settings.copyWith(
        currencySymbol: symbol,
        syncStatus: SyncStatus.pendingPush,
      ),
    );
  }

  /// الحصول على كود العملة
  Future<String> getCurrencyCode() async {
    final settings = await businessSettingsRepository.getSettings();
    return settings?.currencyCode ?? AppConfig.defaultCurrencyCode;
  }

  /// تعيين كود العملة
  Future<void> setCurrencyCode(String code) async {
    final settings = await businessSettingsRepository.getSettings() ??
        const BusinessSettings(id: 'default', companyName: '');
    await businessSettingsRepository.saveSettings(
      settings.copyWith(currencyCode: code, syncStatus: SyncStatus.pendingPush),
    );
  }

  /// الحصول على كود الدولة الافتراضي
  Future<String> getDefaultCountryCode() async {
    try {
      final code = await secureStorage.read(
        key: <credential-fixture>,
      );
      return code ?? AppConfig.defaultCountryCode;
    } on Exception {
      return AppConfig.defaultCountryCode;
    }
  }

  /// تعيين كود الدولة الافتراضي
  Future<void> setDefaultCountryCode(String code) async {
    try {
      await secureStorage.write(
        key: <credential-fixture>,
        value: code,
      );
    } on Exception catch (e) {
      throw Exception('خطأ في حفظ كود الدولة: $e');
    }
  }

  /// الحصول على شكل الفاتورة
  Future<String> getInvoiceStyle() async {
    try {
      final style = await secureStorage.read(key: <credential-fixture>);
      return style ?? AppConfig.defaultInvoiceStyle;
    } on Exception {
      return AppConfig.defaultInvoiceStyle;
    }
  }

  /// تعيين شكل الفاتورة
  Future<void> setInvoiceStyle(String style) async {
    try {
      await secureStorage.write(key: <credential-fixture>, value: style);
    } on Exception catch (e) {
      throw Exception('خطأ في حفظ شكل الفاتورة: $e');
    }
  }

  /// الحصول على جميع إعدادات الشركة والتخصيص
  Future<Map<String, String?>> getCompanySettings() async {
    try {
      return {
        'companyName': await getCompanyName(),
        'taxNumber': await getCompanyTaxNumber(),
        'taxRate': (await getTaxRate()).toString(),
        'currencySymbol': await getCurrencySymbol(),
        'currencyCode': await getCurrencyCode(),
        'defaultCountryCode': await getDefaultCountryCode(),
        'invoiceStyle': await getInvoiceStyle(),
      };
    } on Exception catch (e) {
      throw Exception('خطأ في جلب إعدادات الشركة: $e');
    }
  }

  /// تعيين جميع إعدادات الشركة والتخصيص
  Future<void> setCompanySettings({
    required String companyName,
    required String taxNumber,
    required double taxRate,
    String? currencySymbol,
    String? currencyCode,
    String? countryCode,
    String? invoiceStyle,
  }) async {
    final settings = await businessSettingsRepository.getSettings() ??
        BusinessSettings(id: 'default', companyName: companyName);

    await businessSettingsRepository.saveSettings(
      settings.copyWith(
        companyName: companyName,
        taxNumber: taxNumber,
        defaultTaxRate: taxRate,
        currencySymbol: currencySymbol ?? settings.currencySymbol,
        currencyCode: currencyCode ?? settings.currencyCode,
        address: countryCode ?? settings.address,
        syncStatus: SyncStatus.pendingPush,
      ),
    );

    if (invoiceStyle != null) {
      await secureStorage.write(
        key: <credential-fixture>,
        value: invoiceStyle,
      );
    }
  }
}
