import 'package:basir_accounting_system/core/persistence/drift_pilot_migration.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DriftPilotMigrator', () {
    late _BarcodeSource barcodeSource;
    late _MarketPriceSource marketPriceSource;
    late _BarcodeStorage barcodeStorage;
    late _MarketPriceStorage marketPriceStorage;
    late _CheckpointStorage checkpoints;
    late DriftPilotMigrator migrator;

    setUp(() {
      barcodeSource = _BarcodeSource(_barcode());
      marketPriceSource = _MarketPriceSource([
        _price(id: 'p-1', itemId: 'item-a', day: 1),
        _price(id: 'p-2', itemId: 'item-a', day: 2),
        _price(id: 'p-3', itemId: 'item-b', day: 1),
      ]);
      barcodeStorage = _BarcodeStorage();
      marketPriceStorage = _MarketPriceStorage();
      checkpoints = _CheckpointStorage();
      migrator = DriftPilotMigrator(
        barcodeSource: barcodeSource.readDefault,
        marketPriceSource: marketPriceSource.readAll,
        barcodeStorage: barcodeStorage,
        marketPriceStorage: marketPriceStorage,
        checkpoints: checkpoints,
      );
    });

    test('imports both pilot slices in deterministic batches', () async {
      final report = await migrator.migrate(batchSize: 2);

      expect(report.isComplete, isTrue);
      expect(barcodeStorage.records['default'], _barcode());
      expect(marketPriceStorage.records.keys, ['p-1', 'p-2', 'p-3']);
      expect(
        checkpoints.records[DriftPilotMigrationSlice.marketPrices]?.isComplete,
        isTrue,
      );
      expect(checkpoints.saves, hasLength(4));
    });

    test('is idempotent when an import is re-run after a prior completion',
        () async {
      await migrator.migrate(batchSize: 2);
      final firstRunRecords = Map.of(marketPriceStorage.records);

      final report = await migrator.migrate(batchSize: 1);

      expect(report.isComplete, isTrue);
      expect(marketPriceStorage.records, firstRunRecords);
      expect(marketPriceStorage.upsertCalls, 6);
    });

    test('records completed empty slices without synthesizing defaults',
        () async {
      barcodeSource.record = null;
      marketPriceSource.records = const [];

      final report = await migrator.migrate();

      expect(report.isComplete, isTrue);
      expect(barcodeStorage.records, isEmpty);
      expect(marketPriceStorage.records, isEmpty);
      expect(report.barcodeConfig.sourceCount, 0);
      expect(report.marketPrices.sourceCount, 0);
    });

    test('rejects non-positive batch sizes before writing a checkpoint',
        () async {
      await expectLater(
        () => migrator.migrate(batchSize: 0),
        throwsArgumentError,
      );
      expect(checkpoints.records, isEmpty);
      expect(marketPriceStorage.records, isEmpty);
    });
  });
}

class _BarcodeSource {
  _BarcodeSource(this.record);

  BarcodeConfigRecord? record;

  Future<BarcodeConfigRecord?> readDefault() async => record;
}

class _MarketPriceSource {
  _MarketPriceSource(this.records);

  List<MarketPriceRecord> records;

  Future<List<MarketPriceRecord>> readAll() async => List.of(records);
}

class _BarcodeStorage implements BarcodeConfigStorage {
  final records = <String, BarcodeConfigRecord>{};

  @override
  Future<BarcodeConfigRecord?> read(String id) async => records[id];

  @override
  Future<void> save(BarcodeConfigRecord record) async {
    records[record.id] = record;
  }
}

class _MarketPriceStorage implements MarketPriceStorage {
  final records = <String, MarketPriceRecord>{};
  int upsertCalls = 0;

  @override
  Future<List<MarketPriceRecord>> historyForItem(String itemId) async =>
      records.values.where((record) => record.itemId == itemId).toList();

  @override
  Future<MarketPriceRecord?> latestForItem(
    String itemId,
    DateTime asOfDate,
  ) async =>
      null;

  @override
  Future<List<MarketPriceRecord>> latestForAllItems(DateTime asOfDate) async =>
      const [];

  @override
  Future<void> upsert(MarketPriceRecord record) async {
    upsertCalls += 1;
    records[record.id] = record;
  }
}

class _CheckpointStorage implements MigrationCheckpointStorage {
  final records = <String, MigrationCheckpoint>{};
  final saves = <MigrationCheckpoint>[];

  @override
  Future<MigrationCheckpoint?> read(String slice) async => records[slice];

  @override
  Future<void> save(MigrationCheckpoint checkpoint) async {
    saves.add(checkpoint);
    records[checkpoint.slice] = checkpoint;
  }
}

BarcodeConfigRecord _barcode() => const BarcodeConfigRecord(
      id: 'default',
      printerType: 'thermal',
      columnsPerRow: 2,
      heightMm: 30,
      widthMm: 50,
      marginMm: 2,
      showItemName: true,
      showPrice: true,
    );

MarketPriceRecord _price({
  required String id,
  required String itemId,
  required int day,
}) =>
    MarketPriceRecord(
      id: id,
      itemId: itemId,
      price: 10 + day.toDouble(),
      asOfDate: DateTime.utc(2026, 1, day),
      createdAt: DateTime.utc(2026, 1, day, 8),
    );
