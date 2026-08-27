import 'package:basir_drift_storage/src/basir_database.dart';
import 'package:basir_drift_storage/src/storage_contract.dart';
import 'package:basir_drift_storage/src/user_scope.dart';
import 'package:drift/drift.dart';

/// DTO محايد لحركة المخزون؛ لا يخزن رصيدًا مشتقًا داخل السجل.
class StockMovementRecord {
  const StockMovementRecord({
    required this.id,
    required this.itemId,
    required this.warehouseId,
    required this.type,
    required this.quantity,
    required this.unitCost,
    required this.date,
    required this.referenceId,
    required this.description,
    required this.userId,
    required this.syncStatus,
    required this.createdAt,
  });

  final String id;
  final String itemId;
  final String? warehouseId;
  final String type;
  final double quantity;
  final double unitCost;
  final DateTime date;
  final String? referenceId;
  final String? description;
  final String? userId;
  final String syncStatus;
  final DateTime createdAt;
}

/// عقد تخزين مستقل عن StockMovement domain وIsar repository النشط.
abstract interface class StockMovementStorage {
  Future<List<StockMovementRecord>> readForItem(
    String itemId,
    String? userId, {
    String? warehouseId,
    DateTime? asOfDate,
  });

  Future<List<StockMovementRecord>> readByReference(
    String referenceId,
    String? userId,
  );

  Future<List<StockMovementRecord>> readAllForUser(String? userId);

  Future<double> readStockLevel(
    String itemId,
    String? userId, {
    String? warehouseId,
    DateTime? asOfDate,
  });

  Future<void> addMovement(StockMovementRecord movement);

  Future<void> addMovements(List<StockMovementRecord> movements);
}

/// DAO تجريبي لـStockMovements؛ لا يغير Providers أو Isar أو sync_service.
class StockMovementStore implements StockMovementStorage {
  StockMovementStore(this._database);

  final BasirDatabase _database;

  @override
  Future<List<StockMovementRecord>> readForItem(
    String itemId,
    String? userId, {
    String? warehouseId,
    DateTime? asOfDate,
  }) async {
    final scope = userScopeKey(userId);
    final rows = await (_database.select(_database.stockMovements)
          ..where(
            (table) =>
                table.scopeKey.equals(scope) &
                table.itemId.equals(itemId) &
                _warehouseScope(table, warehouseId) &
                _asOfScope(table, asOfDate),
          )
          ..orderBy([
            (table) => OrderingTerm.desc(table.date),
            (table) => OrderingTerm.asc(table.uuid),
          ]))
        .get();
    return rows.map(_toRecord).toList(growable: false);
  }

  @override
  Future<List<StockMovementRecord>> readByReference(
    String referenceId,
    String? userId,
  ) async {
    final rows = await (_database.select(_database.stockMovements)
          ..where(
            (table) =>
                table.scopeKey.equals(userScopeKey(userId)) &
                table.referenceId.equals(referenceId),
          )
          ..orderBy([
            (table) => OrderingTerm.asc(table.date),
            (table) => OrderingTerm.asc(table.uuid),
          ]))
        .get();
    return rows.map(_toRecord).toList(growable: false);
  }

  @override
  Future<List<StockMovementRecord>> readAllForUser(String? userId) async {
    final rows = await (_database.select(_database.stockMovements)
          ..where((table) => table.scopeKey.equals(userScopeKey(userId)))
          ..orderBy([
            (table) => OrderingTerm.asc(table.date),
            (table) => OrderingTerm.asc(table.uuid),
          ]))
        .get();
    return rows.map(_toRecord).toList(growable: false);
  }

  @override
  Future<double> readStockLevel(
    String itemId,
    String? userId, {
    String? warehouseId,
    DateTime? asOfDate,
  }) async {
    final movements = await readForItem(
      itemId,
      userId,
      warehouseId: warehouseId,
      asOfDate: asOfDate,
    );
    var total = 0.0;
    for (final movement in movements) {
      switch (movement.type) {
        case 'inbound':
          total += movement.quantity;
        case 'outbound':
          total -= movement.quantity;
        case 'adjustment':
          total += movement.quantity;
        case 'transfer':
          throw StockMovementBlockedException(
            'Cannot derive balance from standalone transfer ${movement.id}.',
          );
        default:
          throw StockMovementBlockedException(
            'Unsupported movement type ${movement.type}.',
          );
      }
    }
    return total;
  }

  @override
  Future<void> addMovement(StockMovementRecord movement) {
    _validate(movement);
    return _database.into(_database.stockMovements).insertOnConflictUpdate(
          _toCompanion(movement),
        );
  }

  @override
  Future<void> addMovements(List<StockMovementRecord> movements) async {
    movements.forEach(_validate);
    if (movements.isEmpty) return;
    await _database.batch((batch) {
      batch.insertAll(
        _database.stockMovements,
        movements.map(_toCompanion).toList(growable: false),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  static Expression<bool> _warehouseScope(
    $StockMovementsTable table,
    String? warehouseId,
  ) {
    if (warehouseId == null) return table.warehouseId.isNull();
    return table.warehouseId.isNull() | table.warehouseId.equals(warehouseId);
  }

  static Expression<bool> _asOfScope(
    $StockMovementsTable table,
    DateTime? asOfDate,
  ) {
    if (asOfDate == null) return const Constant(true);
    return table.date.isSmallerOrEqualValue(asOfDate.toUtc());
  }

  static StockMovementRecord _toRecord(StockMovement row) =>
      StockMovementRecord(
        id: row.uuid,
        itemId: row.itemId,
        warehouseId: row.warehouseId,
        type: row.type,
        quantity: row.quantity,
        unitCost: row.unitCost,
        date: row.date,
        referenceId: row.referenceId,
        description: row.description,
        userId: row.userId,
        syncStatus: row.syncStatus,
        createdAt: row.createdAt,
      );

  static StockMovementsCompanion _toCompanion(StockMovementRecord movement) =>
      StockMovementsCompanion.insert(
        scopeKey: userScopeKey(movement.userId),
        uuid: movement.id,
        itemId: movement.itemId,
        warehouseId: Value(movement.warehouseId),
        type: movement.type,
        quantity: movement.quantity,
        unitCost: movement.unitCost,
        date: movement.date.toUtc(),
        referenceId: Value(movement.referenceId),
        description: Value(movement.description),
        userId: Value(movement.userId),
        syncStatus: Value(movement.syncStatus),
        createdAt: movement.createdAt.toUtc(),
      );

  static void _validate(StockMovementRecord movement) {
    DriftStorageContract.validateIdentity(
      userId: movement.userId,
      recordId: movement.id,
    );
    if (movement.id.isEmpty || movement.itemId.isEmpty) {
      throw ArgumentError.value(
        movement,
        'movement',
        'Movement id and itemId are required.',
      );
    }
    if (!const {'inbound', 'outbound', 'transfer', 'adjustment'}
        .contains(movement.type)) {
      throw ArgumentError.value(
        movement.type,
        'type',
        'Unsupported movement type.',
      );
    }
    if (!movement.quantity.isFinite || movement.quantity <= 0) {
      throw ArgumentError.value(
        movement.quantity,
        'quantity',
        'Movement quantity must be positive and finite.',
      );
    }
    if (!movement.unitCost.isFinite || movement.unitCost < 0) {
      throw ArgumentError.value(
        movement.unitCost,
        'unitCost',
        'Movement unit cost must be non-negative and finite.',
      );
    }
    if (!const {'synced', 'pendingPush', 'pendingPull', 'conflict'}
        .contains(movement.syncStatus)) {
      throw ArgumentError.value(
        movement.syncStatus,
        'syncStatus',
        'Unsupported sync status.',
      );
    }
  }
}

class StockMovementBlockedException implements Exception {
  const StockMovementBlockedException(this.message);

  final String message;

  @override
  String toString() => 'StockMovementBlockedException: $message';
}
