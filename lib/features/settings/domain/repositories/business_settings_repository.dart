import 'package:basir_accounting_system/features/settings/domain/entities/business_settings.dart';

/// مستودع بيانات إعدادات العمل
abstract class BusinessSettingsRepository {
  /// الحصول على الإعدادات
  Future<BusinessSettings?> getSettings();

  /// حفظ الإعدادات
  Future<void> saveSettings(BusinessSettings settings);
}
