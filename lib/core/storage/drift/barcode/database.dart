import 'package:basir_accounting_system/features/settings/domain/entities/barcode_config.dart';
import 'package:drift/drift.dart';

part 'database.g.dart';

class BarcodeConfigRows extends Table {
  TextColumn get id => text()();
  IntColumn get printerType => integer()();
  IntColumn get columnsPerRow => integer()();
  RealColumn get height => real()();
  RealColumn get width => real()();
  RealColumn get margin => real()();
  BoolColumn get showItemName => boolean()();
  BoolColumn get showPrice => boolean()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [BarcodeConfigRows])
class BarcodeDatabase extends _$BarcodeDatabase {
  BarcodeDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
      );

  Future<BarcodeConfig?> findDefault() async {
    final row = await (select(barcodeConfigRows)
          ..where((table) => table.id.equals('default')))
        .getSingleOrNull();
    return row == null ? null : _toEntity(row);
  }

  Future<void> saveConfig(BarcodeConfig config) async {
    await into(barcodeConfigRows).insertOnConflictUpdate(
      BarcodeConfigRowsCompanion.insert(
        id: config.id,
        printerType: config.printerType.index,
        columnsPerRow: config.columnsPerRow,
        height: config.height,
        width: config.width,
        margin: config.margin,
        showItemName: config.showItemName,
        showPrice: config.showPrice,
      ),
    );
  }

  BarcodeConfig _toEntity(BarcodeConfigRow row) {
    final printerType = row.printerType == PrinterType.a4.index
        ? PrinterType.a4
        : PrinterType.thermal;
    return BarcodeConfig(
      id: row.id,
      printerType: printerType,
      columnsPerRow: row.columnsPerRow,
      height: row.height,
      width: row.width,
      margin: row.margin,
      showItemName: row.showItemName,
      showPrice: row.showPrice,
    );
  }
}

class DriftBarcodeConfigRepository {
  DriftBarcodeConfigRepository(this.database);

  final BarcodeDatabase database;

  Future<BarcodeConfig> getConfig() async =>
      await database.findDefault() ?? const BarcodeConfig();

  Future<void> saveConfig(BarcodeConfig config) => database.saveConfig(config);
}
