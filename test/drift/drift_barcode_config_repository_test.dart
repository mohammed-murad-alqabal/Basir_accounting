import 'package:basir_accounting_system/core/persistence/drift/basir_database.dart';
import 'package:basir_accounting_system/features/settings/data/repositories/drift_barcode_config_repository.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/barcode_config.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BasirDatabase database;
  late DriftBarcodeConfigRepository repository;

  setUp(() {
    database = BasirDatabase(NativeDatabase.memory());
    repository = DriftBarcodeConfigRepository(database);
  });

  tearDown(() => database.close());

  test('returns the same default configuration exposed by the Isar contract', () async {
    expect(await repository.getConfig(), const BarcodeConfig());
  });

  test('persists and reads every BarcodeConfig field', () async {
    const expected = BarcodeConfig(
      printerType: PrinterType.a4,
      columnsPerRow: 3,
      height: 42.5,
      width: 70.0,
      margin: 1.5,
      showItemName: false,
      showPrice: false,
    );

    await repository.saveConfig(expected);

    expect(await repository.getConfig(), expected);
  });

  test('replaces the default configuration instead of creating duplicates', () async {
    await repository.saveConfig(const BarcodeConfig(columnsPerRow: 2));
    await repository.saveConfig(
      const BarcodeConfig(printerType: PrinterType.a4, columnsPerRow: 4),
    );

    final rows = await database.select(database.barcodeConfigs).get();

    expect(rows, hasLength(1));
    expect(await repository.getConfig(),
        const BarcodeConfig(printerType: PrinterType.a4, columnsPerRow: 4));
  });

  test('rejects invalid dimensions before a database write', () async {
    await expectLater(
      repository.saveConfig(const BarcodeConfig(width: 0)),
      throwsArgumentError,
    );
    await expectLater(
      repository.saveConfig(const BarcodeConfig(columnsPerRow: 0)),
      throwsArgumentError,
    );
  });
}
