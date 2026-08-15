import 'package:basir_accounting_system/features/settings/domain/entities/barcode_config.dart';
import 'package:basir_accounting_system/features/settings/domain/repositories/barcode_config_repository.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';

/// مكيّف تجريبي لعقد إعدادات الباركود باستخدام حزمة Drift الداخلية.
///
/// لا يُسجّل هذا التنفيذ في Riverpod بعد؛ يبقى Isar هو التنفيذ النشط حتى تنجح
/// اختبارات التكافؤ ويُعتمد تبديل feature flag بصورة منفصلة.
class DriftBarcodeConfigRepository implements BarcodeConfigRepository {
  DriftBarcodeConfigRepository(BasirDatabase database)
      : _storage = BarcodeConfigStore(database);

  /// منشئ اختبار/حقن؛ يحافظ على عزل domain عن أنواع Drift.
  DriftBarcodeConfigRepository.withStorage(this._storage);

  final BarcodeConfigStorage _storage;

  @override
  Future<BarcodeConfig> getConfig() async {
    final record = await _storage.read('default');
    if (record == null) return const BarcodeConfig();

    return BarcodeConfig(
      id: record.id,
      printerType: _printerTypeFromStorage(record.printerType),
      columnsPerRow: record.columnsPerRow,
      height: record.heightMm,
      width: record.widthMm,
      margin: record.marginMm,
      showItemName: record.showItemName,
      showPrice: record.showPrice,
    );
  }

  @override
  Future<void> saveConfig(BarcodeConfig config) async {
    _validate(config);
    await _storage.save(
      BarcodeConfigRecord(
        id: config.id,
        printerType: config.printerType.name,
        columnsPerRow: config.columnsPerRow,
        heightMm: config.height,
        widthMm: config.width,
        marginMm: config.margin,
        showItemName: config.showItemName,
        showPrice: config.showPrice,
      ),
    );
  }

  static PrinterType _printerTypeFromStorage(String value) => switch (value) {
        'thermal' => PrinterType.thermal,
        'a4' => PrinterType.a4,
        _ => throw StateError('Unsupported persisted printer type: $value'),
      };

  static void _validate(BarcodeConfig config) {
    if (config.id != 'default') {
      throw ArgumentError.value(
        config.id,
        'config.id',
        'The current BarcodeConfig contract supports the default singleton only.',
      );
    }
    if (config.columnsPerRow <= 0 ||
        config.height <= 0 ||
        config.width <= 0 ||
        config.margin < 0) {
      throw ArgumentError('Invalid barcode dimensions or column count.');
    }
  }
}
