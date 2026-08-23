import 'package:basir_accounting_system/core/persistence/drift_stock_movements_golden.dart';
import 'package:basir_accounting_system/core/persistence/drift_stock_movements_migration.dart';
import 'package:basir_accounting_system/core/persistence/drift_stock_movements_parity.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';

class DriftStockMovementsSnapshotRunReport {
  const DriftStockMovementsSnapshotRunReport({
    required this.fixtureId,
    required this.migration,
    required this.parity,
  });

  final String fixtureId;
  final DriftStockMovementsMigrationReport migration;
  final DriftStockMovementsParityReport parity;

  bool get isClean => migration.isClean && parity.isClean;

  Map<String, Object?> toSafeJson() => {
        'fixtureId': fixtureId,
        'clean': isClean,
        'sourceCount': migration.sourceCount,
        'migratedCount': migration.migratedCount,
        'blockedCount': migration.blockedCount,
        'rawScopes': parity.rawComparisons.length,
        'referenceScopes': parity.referenceComparisons.length,
        'derivedQueries': parity.derivedComparisons.length,
        'duplicateScopedKeys': parity.duplicateScopedKeys.length,
        'blockedReasons': parity.blockedReasons,
      };
}

/// يشغل fixture معقمة داخل SQLite في الذاكرة، ثم يغلق القاعدة قبل العودة.
/// لا يفتح Isar ولا يكتب Provider أو sync_service.
class DriftStockMovementsSnapshotRunner {
  Future<DriftStockMovementsSnapshotRunReport> run(
    StockMovementGoldenFixture fixture, {
    required BasirDatabase Function() databaseFactory,
    int batchSize = 250,
  }) async {
    final database = databaseFactory();
    try {
      final storage = StockMovementStore(database);
      final checkpoints = LocalMetadataMigrationCheckpointStore(database);
      final records = fixture.movements.map(_toRecord).toList(growable: false);
      final queries = fixture.expectedBalances
          .map(
            (expected) => StockMovementBalanceQuery(
              fixtureId: fixture.id,
              itemId: fixture.itemId,
              userId: expected.userId ?? fixture.userId,
              warehouseId: expected.warehouseId,
              asOfDate: expected.asOfDate,
              expectedBalance: expected.quantity,
            ),
          )
          .toList(growable: false);

      final migration = await DriftStockMovementsMigrator(
        source: () async => records,
        storage: storage,
        checkpoints: checkpoints,
      ).migrate(batchSize: batchSize);
      final parity = await DriftStockMovementsParityVerifier(
        source: () async => records,
        storage: storage,
        balanceQueries: queries,
      ).verify();

      return DriftStockMovementsSnapshotRunReport(
        fixtureId: fixture.id,
        migration: migration,
        parity: parity,
      );
    } finally {
      await database.close();
    }
  }

  Future<List<DriftStockMovementsSnapshotRunReport>> runAllClean(
    StockMovementGoldenCatalog catalog, {
    required BasirDatabase Function() databaseFactory,
    int batchSize = 250,
  }) async {
    final reports = <DriftStockMovementsSnapshotRunReport>[];
    for (final fixture in catalog.cleanFixtures) {
      reports.add(
        await run(
          fixture,
          databaseFactory: databaseFactory,
          batchSize: batchSize,
        ),
      );
    }
    return reports;
  }
}

StockMovementRecord _toRecord(StockMovementGoldenRecord movement) =>
    StockMovementRecord(
      id: movement.id,
      itemId: movement.itemId,
      warehouseId: movement.warehouseId,
      type: movement.type.name,
      quantity: movement.quantity,
      unitCost: movement.unitCost,
      date: movement.date,
      referenceId: movement.referenceId,
      description: movement.description,
      userId: movement.userId,
      syncStatus: movement.syncStatus,
      createdAt: movement.createdAt,
    );
