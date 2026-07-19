import 'package:basir_accounting_system/features/settings/data/models/barcode_config_model.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/barcode_config.dart';
import 'package:basir_accounting_system/features/settings/domain/repositories/barcode_config_repository.dart';
import 'package:isar/isar.dart';

/// تنفيذ مستودع إعدادات الباركود باستخدام Isar
class IsarBarcodeConfigRepository implements BarcodeConfigRepository {
  /// المنشئ
  IsarBarcodeConfigRepository(this.isar);

  /// مثيل Isar
  final Isar isar;

  @override
  Future<BarcodeConfig> getConfig() async {
    final model = await isar.barcodeConfigModels
        .filter()
        .idEqualTo('default')
        .findFirst();
    return model?.toEntity() ?? const BarcodeConfig();
  }

  @override
  Future<void> saveConfig(BarcodeConfig config) async {
    await isar.writeTxn(() async {
      final model = BarcodeConfigModel.fromEntity(config);
      await isar.barcodeConfigModels.put(model);
    });
  }
}
