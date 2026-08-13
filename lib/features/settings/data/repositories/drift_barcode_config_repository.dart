import 'package:basir_accounting_system/core/persistence/drift/basir_database.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/barcode_config.dart';
import 'package:basir_accounting_system/features/settings/domain/repositories/barcode_config_repository.dart';
import 'package:drift/drift.dart';

/// تنفيذ تجريبي لعقد إعدادات الباركود باستخدام Drift.
///
/// لا يُسجّل هذا التنفيذ في Riverpod بعد؛ يظل Isar هو التنفيذ النشط حتى تنجح
/// اختبارات التكافؤ ويُعتمد تبديل feature flag بصورة منفصلة.
class DriftBarcodeConfigRepository implements BarcodeConfigRepository {
  DriftBarcodeConfigRepository(this._database);

  final BasirDatabase _database;

  @override
  Future<BarcodeConfig> getConfig() async {
    final row = await (_database.select(_database.barcodeConfigs)
          ..where((table) => table.id.equals('default')))
        .getSingleOrNull();

    if (row == null) {
      return const BarcodeConfig();
    }

    return BarcodeConfig(
      id: row.id,
      printerType: _printerTypeFromStorage(row.printerType),
      columnsPerRow: row.columnsPerRow,
      height: row.heightMm,
      width: row.widthMm,
      margin: row.marginMm,
      showItemName: row.showItemName,
      showPrice: row.showPrice,
    );
  }

  @override
  Future<void> saveConfig(BarcodeConfig config) async {
    _validate(config);

    await _database.into(_database.barcodeConfigs).insertOnConflictUpdate(
          BarcodeConfigsCompanion.insert(
            id: config.id,
            printerType: Value(config.printerType.name),
            columnsPerRow: Value(config.columnsPerRow),
            heightMm: Value(config.height),
            widthMm: Value(config.width),
            marginMm: Value(config.margin),
            showItemName: Value(config.showItemName),
            showPrice: Value(config.showPrice),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );
  }

  static PrinterType _printerTypeFromStorage(String value) {
    return switch (value) {
      'thermal' => PrinterType.thermal,
      'a4' => PrinterType.a4,
      _ => throw StateError('Unsupported persisted printer type: $value'),
    };
  }

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
