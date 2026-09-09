import 'package:drift/drift.dart';

import 'package:basir_drift_storage/src/basir_database.dart';

/// DTO محايد بين جدول Drift وطبقة domain في التطبيق المضيف.
class BarcodeConfigRecord {
  const BarcodeConfigRecord({
    required this.id,
    required this.printerType,
    required this.columnsPerRow,
    required this.heightMm,
    required this.widthMm,
    required this.marginMm,
    required this.showItemName,
    required this.showPrice,
  });

  final String id;
  final String printerType;
  final int columnsPerRow;
  final double heightMm;
  final double widthMm;
  final double marginMm;
  final bool showItemName;
  final bool showPrice;
}

/// عقد تخزين بسيط يسمح لطبقة التطبيق بالاختبار دون استيراد Drift مباشرة.
abstract interface class BarcodeConfigStorage {
  Future<BarcodeConfigRecord?> read(String id);

  Future<void> save(BarcodeConfigRecord record);
}

/// DAO منخفض المستوى؛ لا يعرف شيئًا عن Riverpod أو Supabase أو كيان التطبيق.
class BarcodeConfigStore implements BarcodeConfigStorage {
  BarcodeConfigStore(this._database);

  final BasirDatabase _database;

  @override
  Future<BarcodeConfigRecord?> read(String id) async {
    final row = await (_database.select(_database.barcodeConfigs)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;

    return BarcodeConfigRecord(
      id: row.id,
      printerType: row.printerType,
      columnsPerRow: row.columnsPerRow,
      heightMm: row.heightMm,
      widthMm: row.widthMm,
      marginMm: row.marginMm,
      showItemName: row.showItemName,
      showPrice: row.showPrice,
    );
  }

  @override
  Future<void> save(BarcodeConfigRecord record) async {
    _validate(record);

    await _database.into(_database.barcodeConfigs).insertOnConflictUpdate(
          BarcodeConfigsCompanion.insert(
            id: record.id,
            printerType: Value(record.printerType),
            columnsPerRow: Value(record.columnsPerRow),
            heightMm: Value(record.heightMm),
            widthMm: Value(record.widthMm),
            marginMm: Value(record.marginMm),
            showItemName: Value(record.showItemName),
            showPrice: Value(record.showPrice),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );
  }

  static void _validate(BarcodeConfigRecord record) {
    if (record.id.isEmpty ||
        (record.printerType != 'thermal' && record.printerType != 'a4') ||
        record.columnsPerRow <= 0 ||
        record.heightMm <= 0 ||
        record.widthMm <= 0 ||
        record.marginMm < 0) {
      throw ArgumentError.value(record, 'record', 'Invalid barcode config.');
    }
  }
}
