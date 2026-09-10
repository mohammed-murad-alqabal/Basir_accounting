import 'dart:io';

import 'package:basir_accounting_system/core/persistence/drift_pilot_migration.dart';
import 'package:basir_accounting_system/core/persistence/drift_pilot_parity.dart';
import 'package:basir_accounting_system/features/reports/data/models/market_price_model.dart';
import 'package:basir_accounting_system/features/settings/data/models/barcode_config_model.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/barcode_config.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

void main() {
  late Directory temporaryDirectory;
  late Isar isar;
  late BasirDatabase driftDatabase;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp('basir-drift-');
    isar = await Isar.open(
      [BarcodeConfigModelSchema, MarketPriceModelSchema],
      directory: temporaryDirectory.path,
      name: 'pilot-source',
    );
    driftDatabase = BasirDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await driftDatabase.close();
    await isar.close(deleteFromDisk: true);
    if (temporaryDirectory.existsSync()) {
      await temporaryDirectory.delete(recursive: true);
    }
  });

  test('migrates a real Isar pilot snapshot and verifies it against Drift',
      () async {
    await isar.writeTxn(() async {
      await isar.barcodeConfigModels.put(
        BarcodeConfigModel()
          ..id = 'default'
          ..printerType = PrinterType.thermal
          ..columnsPerRow = 2
          ..height = 30
          ..width = 50
          ..margin = 2
          ..showItemName = true
          ..showPrice = true,
      );
      await isar.marketPriceModels.putAll([
        _marketPrice(
          id: 'price-a1',
          itemId: 'item-a',
          day: 1,
          value: 12.5,
        ),
        _marketPrice(
          id: 'price-a2',
          itemId: 'item-a',
          day: 2,
          value: 13,
        ),
        _marketPrice(
          id: 'price-b1',
          itemId: 'item-b',
          day: 1,
          value: 40,
        ),
      ]);
    });

    final barcodeSource = IsarBarcodeConfigMigrationSource(isar);
    final marketPriceSource = IsarMarketPriceMigrationSource(isar);
    final barcodeStorage = BarcodeConfigStore(driftDatabase);
    final marketPriceStorage = MarketPriceStore(driftDatabase);
    final checkpointStorage = LocalMetadataMigrationCheckpointStore(
      driftDatabase,
    );

    final migration = await DriftPilotMigrator(
      barcodeSource: barcodeSource.readDefault,
      marketPriceSource: marketPriceSource.readAll,
      barcodeStorage: barcodeStorage,
      marketPriceStorage: marketPriceStorage,
      checkpoints: checkpointStorage,
    ).migrate(batchSize: 2);

    final parity = await DriftPilotParityVerifier(
      barcodeSource: barcodeSource.readDefault,
      marketPriceSource: marketPriceSource.readAll,
      barcodeStorage: barcodeStorage,
      marketPriceStorage: marketPriceStorage,
    ).verify();

    expect(migration.isComplete, isTrue);
    expect(parity.isClean, isTrue);
    expect(
      (await checkpointStorage.read(DriftPilotMigrationSlice.marketPrices))
          ?.isComplete,
      isTrue,
    );
    expect(
      (await marketPriceStorage.latestForItem(
        'item-a',
        DateTime.utc(2026, 1, 3),
      ))
          ?.id,
      'price-a2',
    );
    expect(
      await isar.marketPriceModels.count(),
      3,
      reason: 'The pilot migration must not modify the Isar source.',
    );
  });
}

MarketPriceModel _marketPrice({
  required String id,
  required String itemId,
  required int day,
  required double value,
}) =>
    MarketPriceModel()
      ..id = id
      ..itemId = itemId
      ..price = value
      ..asOfDate = DateTime.utc(2026, 1, day)
      ..createdAt = DateTime.utc(2026, 1, day, 8);
