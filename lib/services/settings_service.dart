import 'package:basser_app/core/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// خدمة الإعدادات (Settings Service)
/// تتعامل مع تخزين واسترجاع إعدادات التطبيق
class SettingsService {
  SettingsService({required this.secureStorage});
  final FlutterSecureStorage secureStorage;

  /// الحصول على نسبة الضريبة
  Future<double> getTaxRate() async {
    try {
      final taxRate = await secureStorage.read(key: StorageKeys.taxRate);
      return double.tryParse(taxRate ?? '') ?? AppConfig.defaultTaxRate;
    } catch (e) {
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
    } catch (e) {
      throw Exception('خطأ في حفظ نسبة الضريبة: $e');
    }
  }

  /// الحصول على اسم الشركة
  Future<String?> getCompanyName() async {
    try {
      return await secureStorage.read(key: StorageKeys.companyName);
    } catch (e) {
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
    } catch (e) {
      throw Exception('خطأ في حفظ اسم الشركة: $e');
    }
  }

  /// الحصول على الرقم الضريبي للشركة
  Future<String?> getCompanyTaxNumber() async {
    try {
      return await secureStorage.read(key: StorageKeys.companyTaxNumber);
    } catch (e) {
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
    } catch (e) {
      throw Exception('خطأ في حفظ الرقم الضريبي: $e');
    }
  }

  /// الحصول على جميع إعدادات الشركة
  Future<Map<String, String?>> getCompanySettings() async {
    try {
      return {
        'companyName': await getCompanyName(),
        'taxNumber': await getCompanyTaxNumber(),
        'taxRate': (await getTaxRate()).toString(),
      };
    } catch (e) {
      throw Exception('خطأ في جلب إعدادات الشركة: $e');
    }
  }

  /// تعيين جميع إعدادات الشركة
  Future<void> setCompanySettings({
    required String companyName,
    required String taxNumber,
    required double taxRate,
  }) async {
    try {
      await setCompanyName(companyName);
      await setCompanyTaxNumber(taxNumber);
      await setTaxRate(taxRate);
    } catch (e) {
      throw Exception('خطأ في حفظ إعدادات الشركة: $e');
    }
  }
}
