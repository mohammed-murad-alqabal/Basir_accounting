import 'package:basir_accounting_system/core/persistence/drift_stock_movements_migration.dart';
import 'package:basir_accounting_system/core/persistence/drift_stock_movements_parity.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('migrates clean records in batches and parity is clean', () async {
    final database = BasirDatabase(NativeDatabase.memory());
    try {
      final storage = StockMovementStore(database);
      final checkpoints = LocalMetadataMigrationCheckpointStore(database);
      final sourceRecords = _cleanRecords();
      final migrator = DriftStockMovementsMigrator(
        source: () async => sourceRecords,
        storage: storage,
        checkpoints: checkpoints,
      );

      final migration = await migrator.migrate(batchSize: 2);
      final checkpoint = await checkpoints.read(
        DriftStockMovementsMigrationSlice.stockMovements,
      );
      final parity = await DriftStockMovementsParityVerifier(
        source: () async => sourceRecords,
        storage: storage,
        balanceQueries: [
          StockMovementBalanceQuery(
            fixtureId: 'clean-balance',
            itemId: 'item-a',
            userId: 'user-a',
            warehouseId: 'wh-a',
            asOfDate: DateTime.utc(2026, 8, 3),
            expectedBalance: 9,
          ),
        ],
      ).verify();

      expect(migration.isClean, isTrue);
      expect(migration.sourceCount, sourceRecords.length);
      expect(migration.migratedCount, sourceRecords.length);
      expect(checkpoint?.isComplete, isTrue);
      expect(parity.isClean, isTrue);
      expect(
        parity.rawComparisons.every((comparison) => comparison.matches),
        isTrue,
      );
      expect(
        parity.derivedComparisons.single.matches,
        isTrue,
      );
    } finally {
      await database.close();
    }
  });

  test('blocks standalone transfer before any storage write', () async {
    final database = BasirDatabase(NativeDatabase.memory());
    try {
      final storage = StockMovementStore(database);
      final checkpoints = LocalMetadataMigrationCheckpointStore(database);
      final migrator = DriftStockMovementsMigrator(
        source: () async => [
          _record(id: 'blocked', type: 'transfer'),
        ],
        storage: storage,
        checkpoints: checkpoints,
      );

      final report = await migrator.migrate();

      expect(report.isClean, isFalse);
      expect(report.blockedCount, 1);
      expect(report.migratedCount, 0);
      expect(await storage.readAllForUser('user-a'), isEmpty);
    } finally {
      await database.close();
    }
  });

  test('blocks signed adjustment before any storage write', () async {
    final database = BasirDatabase(NativeDatabase.memory());
    try {
      final storage = StockMovementStore(database);
      final checkpoints = LocalMetadataMigrationCheckpointStore(database);
      final migrator = DriftStockMovementsMigrator(
        source: () async => [
          _record(id: 'negative-adjustment', type: 'adjustment', quantity: -3),
        ],
        storage: storage,
        checkpoints: checkpoints,
      );

      final report = await migrator.migrate();

      expect(report.isClean, isFalse);
      expect(report.issues.single.reason, 'signed-adjustment');
      expect(report.migratedCount, 0);
      expect(await storage.readAllForUser('user-a'), isEmpty);
    } finally {
      await database.close();
    }
  });

  test('blocks duplicate scoped UUIDs but permits same UUID across users',
      () async {
    final database = BasirDatabase(NativeDatabase.memory());
    try {
      final storage = StockMovementStore(database);
      final checkpoints = LocalMetadataMigrationCheckpointStore(database);
      final duplicateRecords = [
        _record(id: 'same-id'),
        _record(id: 'same-id', date: DateTime.utc(2026, 8, 2)),
      ];
      final duplicateReport = await DriftStockMovementsMigrator(
        source: () async => duplicateRecords,
        storage: storage,
        checkpoints: checkpoints,
      ).migrate();

      expect(duplicateReport.isClean, isFalse);
      expect(duplicateReport.duplicateScopedKeys, hasLength(1));
      expect(await storage.readAllForUser('user-a'), isEmpty);

      final crossUserReport = await DriftStockMovementsMigrator(
        source: () async => [
          _record(id: 'same-id'),
          _record(id: 'same-id', userId: 'user-b'),
        ],
        storage: storage,
        checkpoints: checkpoints,
      ).migrate();
      expect(crossUserReport.isClean, isTrue);
      expect(await storage.readAllForUser('user-a'), hasLength(1));
      expect(await storage.readAllForUser('user-b'), hasLength(1));
    } finally {
      await database.close();
    }
  });
}

List<StockMovementRecord> _cleanRecords() => [
      _record(id: 'inbound', quantity: 10),
      _record(
        id: 'outbound',
        type: 'outbound',
        quantity: 3,
        date: DateTime.utc(2026, 8, 2),
      ),
      _record(
        id: 'adjustment',
        type: 'adjustment',
        quantity: 2,
        date: DateTime.utc(2026, 8, 3),
      ),
    ];

StockMovementRecord _record({
  required String id,
  String itemId = 'item-a',
  String? warehouseId = 'wh-a',
  String type = 'inbound',
  double quantity = 4,
  double unitCost = 10,
  DateTime? date,
  String? referenceId = 'reference-a',
  String? description = 'synthetic migration record',
  String userId = 'user-a',
  String syncStatus = 'synced',
  DateTime? createdAt,
}) =>
    StockMovementRecord(
      id: id,
      itemId: itemId,
      warehouseId: warehouseId,
      type: type,
      quantity: quantity,
      unitCost: unitCost,
      date: date ?? DateTime.utc(2026, 8),
      referenceId: referenceId,
      description: description,
      userId: userId,
      syncStatus: syncStatus,
      createdAt: createdAt ?? DateTime.utc(2026, 8),
    );
