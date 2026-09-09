import 'package:basir_accounting_system/features/inventory/data/models/stock_movement_model.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:isar/isar.dart';

/// معرف مستقل لموجة StockMovements حتى لا تختلط checkpoints بالموجات الأخرى.
abstract final class DriftStockMovementsMigrationSlice {
  static const stockMovements = 'stock-movements-v1';
}

typedef StockMovementMigrationReader = Future<List<StockMovementRecord>>
    Function();

/// قارئ Isar محايد؛ لا يكتب Isar ولا يربط Provider أو sync_service.
class IsarStockMovementMigrationSource {
  IsarStockMovementMigrationSource(this._isar);

  final Isar _isar;

  Future<List<StockMovementRecord>> readAll() async {
    final records = (await _isar.stockMovementModels.where().findAll())
        .map(_toRecord)
        .toList(growable: false)
      ..sort(_compareMovements);
    return records;
  }

  static StockMovementRecord _toRecord(StockMovementModel model) =>
      StockMovementRecord(
        id: model.id ?? '',
        itemId: model.itemId,
        warehouseId: model.warehouseId,
        type: model.type.name,
        quantity: model.quantity,
        unitCost: model.unitCost,
        date: model.date.toUtc(),
        referenceId: model.referenceId,
        description: model.description,
        userId: model.userId,
        syncStatus: model.syncStatus.name,
        createdAt: model.createdAt.toUtc(),
      );
}

class StockMovementMigrationIssue {
  const StockMovementMigrationIssue({
    required this.reason,
    required this.count,
  });

  final String reason;
  final int count;
}

class DriftStockMovementsMigrationReport {
  const DriftStockMovementsMigrationReport({
    required this.checkpoint,
    required this.sourceCount,
    required this.migratedCount,
    required this.issues,
    required this.duplicateScopedKeys,
  });

  final MigrationCheckpoint checkpoint;
  final int sourceCount;
  final int migratedCount;
  final List<StockMovementMigrationIssue> issues;
  final List<String> duplicateScopedKeys;

  bool get isClean =>
      checkpoint.isComplete && issues.isEmpty && duplicateScopedKeys.isEmpty;

  int get blockedCount => issues.fold(0, (total, issue) => total + issue.count);
}

/// يستورد الحركات النظيفة فقط؛ عند وجود hazard لا يسقط السجلات بصمت ولا يكتب
/// دفعة جزئية، بل يعيد تقريرًا غير نظيف ليوقف parity أو rollout.
class DriftStockMovementsMigrator {
  DriftStockMovementsMigrator({
    required StockMovementMigrationReader source,
    required StockMovementStorage storage,
    required MigrationCheckpointStorage checkpoints,
  })  : _source = source,
        _storage = storage,
        _checkpoints = checkpoints;

  final StockMovementMigrationReader _source;
  final StockMovementStorage _storage;
  final MigrationCheckpointStorage _checkpoints;

  Future<DriftStockMovementsMigrationReport> migrate({
    int batchSize = 250,
  }) async {
    if (batchSize <= 0) {
      throw ArgumentError.value(batchSize, 'batchSize', 'Must be positive.');
    }

    final sourceRecords = (await _source())..sort(_compareMovements);
    final duplicateScopedKeys = _duplicateScopedKeys(sourceRecords);
    final issues = _issues(sourceRecords);
    if (duplicateScopedKeys.isNotEmpty || issues.isNotEmpty) {
      final checkpoint = MigrationCheckpoint(
        slice: DriftStockMovementsMigrationSlice.stockMovements,
        sourceCount: sourceRecords.length,
        migratedCount: 0,
        completedAt: null,
      );
      await _checkpoints.save(checkpoint);
      return DriftStockMovementsMigrationReport(
        checkpoint: checkpoint,
        sourceCount: sourceRecords.length,
        migratedCount: 0,
        issues: issues,
        duplicateScopedKeys: duplicateScopedKeys,
      );
    }

    var migratedCount = 0;
    for (var start = 0; start < sourceRecords.length; start += batchSize) {
      final end = start + batchSize < sourceRecords.length
          ? start + batchSize
          : sourceRecords.length;
      await _storage.addMovements(sourceRecords.sublist(start, end));
      migratedCount = end;
      await _checkpoints.save(
        MigrationCheckpoint(
          slice: DriftStockMovementsMigrationSlice.stockMovements,
          sourceCount: sourceRecords.length,
          migratedCount: migratedCount,
          completedAt: null,
        ),
      );
    }

    final checkpoint = MigrationCheckpoint(
      slice: DriftStockMovementsMigrationSlice.stockMovements,
      sourceCount: sourceRecords.length,
      migratedCount: migratedCount,
      completedAt: DateTime.now().toUtc(),
    );
    await _checkpoints.save(checkpoint);
    return DriftStockMovementsMigrationReport(
      checkpoint: checkpoint,
      sourceCount: sourceRecords.length,
      migratedCount: migratedCount,
      issues: const [],
      duplicateScopedKeys: const [],
    );
  }
}

List<StockMovementMigrationIssue> _issues(
  List<StockMovementRecord> records,
) {
  final counts = <String, int>{};
  for (final record in records) {
    final reason = switch (record.type) {
      'transfer' => 'standalone-transfer',
      'adjustment' when record.quantity <= 0 => 'signed-adjustment',
      _ when !record.quantity.isFinite => 'non-finite-quantity',
      _ when record.quantity <= 0 => 'non-positive-quantity',
      _ when !record.unitCost.isFinite || record.unitCost < 0 =>
        'invalid-unit-cost',
      _ => null,
    };
    if (reason != null) {
      counts.update(reason, (value) => value + 1, ifAbsent: () => 1);
    }
  }
  return counts.entries
      .map(
        (entry) => StockMovementMigrationIssue(
          reason: entry.key,
          count: entry.value,
        ),
      )
      .toList(growable: false)
    ..sort((left, right) => left.reason.compareTo(right.reason));
}

List<String> _duplicateScopedKeys(List<StockMovementRecord> records) {
  final counts = <String, int>{};
  for (final record in records) {
    final key = '${userScopeKey(record.userId)}\u0000${record.id}';
    counts.update(key, (value) => value + 1, ifAbsent: () => 1);
  }
  return counts.entries
      .where((entry) => entry.value > 1)
      .map((entry) => entry.key)
      .toList(growable: false)
    ..sort();
}

int _compareMovements(StockMovementRecord left, StockMovementRecord right) {
  final scope = userScopeKey(left.userId).compareTo(userScopeKey(right.userId));
  if (scope != 0) return scope;
  final date = left.date.toUtc().compareTo(right.date.toUtc());
  if (date != 0) return date;
  return left.id.compareTo(right.id);
}
