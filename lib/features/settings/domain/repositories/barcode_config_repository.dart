import 'package:basir_accounting_system/features/settings/domain/entities/barcode_config.dart';

/// مستودع إعدادات الباركود (Barcode Config Repository Interface)
abstract class BarcodeConfigRepository {
  /// الحصول على الإعدادات الحالية
  Future<BarcodeConfig> getConfig();

  /// حفظ الإعدادات
  Future<void> saveConfig(BarcodeConfig config);
}
