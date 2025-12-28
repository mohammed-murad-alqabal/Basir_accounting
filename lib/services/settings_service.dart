import 'package:basser_app/core/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// خدمة الإعدادات (Settings Service)
/// تتعامل مع تخزين واسترجاع إعدادات التطبيق
class SettingsService {
  /// إنشاء خدمة الإعدادات
  SettingsService({required this.secureStorage});

  /// خدمة التخزين الآمن
  final FlutterSecureStorage secureStorage;

  /// الحصول على نسبة الضريبة
  Future<double> getTaxRate() async {
    try {
      final taxRate = await secureStorage.read(
        key: StorageKeys.taxRate,
      );
      return double.tryParse(taxRate ?? '') ?? AppConfig.defaultTaxRate;
    } on Exception {
      return AppConfig.defaultTaxRate;
    }
  }

  /// تعيين نسبة الضريبة
  Future<void> setTaxRate(double taxRate) async {
    try {
      await secureStorage.write(
        key: StorageKeys.taxRate,
        value: taxRate.toString(),
      );
    } on Exception catch (e) {
      throw Exception(
        'خطأ في حفظ نسبة الضريبة: $e',
      );
    }
  }

  /// الحصول على اسم الشركة
  Future<String?> getCompanyName() async {
    try {
      return await secureStorage.read(
        key: StorageKeys.companyName,
      );
    } on Exception {
      return null;
    }
  }

  /// تعيين اسم الشركة
  Future<void> setCompanyName(String companyName) async {
    try {
      await secureStorage.write(
        key: StorageKeys.companyName,
        value: companyName,
      );
    } on Exception catch (e) {
      throw Exception(
        'خطأ في حفظ اسم الشركة: $e',
      );
    }
  }

  /// الحصول على الرقم الضريبي للشركة
  Future<String?> getCompanyTaxNumber() async {
    try {
      return await secureStorage.read(
        key: StorageKeys.companyTaxNumber,
      );
    } on Exception {
      return null;
    }
  }

  /// تعيين الرقم الضريبي للشركة
  Future<void> setCompanyTaxNumber(String taxNumber) async {
    try {
      await secureStorage.write(
        key: StorageKeys.companyTaxNumber,
        value: taxNumber,
      );
    } on Exception catch (e) {
      throw Exception(
        'خطأ في حفظ الرقم الضريبي: $e',
      );
    }
  }

  /// الحصول على رمز العملة
  Future<String> getCurrencySymbol() async {
    try {
      final symbol = await secureStorage.read(key: StorageKeys.currencySymbol);
      return symbol ?? AppConfig.defaultCurrencySymbol;
    } on Exception {
      return AppConfig.defaultCurrencySymbol;
    }
  }

  /// تعيين رمز العملة
  Future<void> setCurrencySymbol(String symbol) async {
    try {
      await secureStorage.write(
        key: StorageKeys.currencySymbol,
        value: symbol,
      );
    } on Exception catch (e) {
      throw Exception('خطأ في حفظ رمز العملة: $e');
    }
  }

  /// الحصول على كود العملة
  Future<String> getCurrencyCode() async {
    try {
      final code = await secureStorage.read(key: StorageKeys.currencyCode);
      return code ?? AppConfig.defaultCurrencyCode;
    } on Exception {
      return AppConfig.defaultCurrencyCode;
    }
  }

  /// تعيين كود العملة
  Future<void> setCurrencyCode(String code) async {
    try {
      await secureStorage.write(
        key: StorageKeys.currencyCode,
        value: code,
      );
    } on Exception catch (e) {
      throw Exception('خطأ في حفظ كود العملة: $e');
    }
  }

  /// الحصول على كود الدولة الافتراضي
  Future<String> getDefaultCountryCode() async {
    try {
      final code =
          await secureStorage.read(key: StorageKeys.defaultCountryCode);
      return code ?? AppConfig.defaultCountryCode;
    } on Exception {
      return AppConfig.defaultCountryCode;
    }
  }

  /// تعيين كود الدولة الافتراضي
  Future<void> setDefaultCountryCode(String code) async {
    try {
      await secureStorage.write(
        key: StorageKeys.defaultCountryCode,
        value: code,
      );
    } on Exception catch (e) {
      throw Exception('خطأ في حفظ كود الدولة: $e');
    }
  }

  /// الحصول على شكل الفاتورة
  Future<String> getInvoiceStyle() async {
    try {
      final style = await secureStorage.read(key: StorageKeys.invoiceStyle);
      return style ?? AppConfig.defaultInvoiceStyle;
    } on Exception {
      return AppConfig.defaultInvoiceStyle;
    }
  }

  /// تعيين شكل الفاتورة
  Future<void> setInvoiceStyle(String style) async {
    try {
      await secureStorage.write(
        key: StorageKeys.invoiceStyle,
        value: style,
      );
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
      throw Exception(
        'خطأ في جلب إعدادات الشركة: $e',
      );
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
    try {
      await setCompanyName(companyName);
      await setCompanyTaxNumber(taxNumber);
      await setTaxRate(taxRate);
      if (currencySymbol != null) await setCurrencySymbol(currencySymbol);
      if (currencyCode != null) await setCurrencyCode(currencyCode);
      if (countryCode != null) await setDefaultCountryCode(countryCode);
      if (invoiceStyle != null) await setInvoiceStyle(invoiceStyle);
    } on Exception catch (e) {
      throw Exception(
        'خطأ في حفظ إعدادات الشركة: $e',
      );
    }
  }
}
