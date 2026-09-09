import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BasirDatabase database;
  late StockMovementStore movements;

  setUp(() {
    database = BasirDatabase(NativeDatabase.memory());
    movements = StockMovementStore(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('StockMovementStore isolates user and warehouse scopes', () async {
    await movements.addMovement(
      _movement(id: 'general', warehouseId: null),
    );
    await movements.addMovement(
      _movement(
        id: 'warehouse-a',
        date: DateTime.utc(2026, 8, 2),
      ),
    );
    await movements.addMovement(
      _movement(
        id: 'warehouse-b',
        warehouseId: 'wh-b',
        date: DateTime.utc(2026, 8, 3),
      ),
    );
    await movements.addMovement(
      _movement(
        id: 'other-user',
        userId: 'user-b',
        date: DateTime.utc(2026, 8, 4),
      ),
    );

    final warehouseA = await movements.readForItem(
      'item-a',
      'user-a',
      warehouseId: 'wh-a',
      asOfDate: DateTime.utc(2026, 8, 3),
    );
    final generalOnly = await movements.readForItem('item-a', 'user-a');

    expect(warehouseA.map((movement) => movement.id), [
      'warehouse-a',
      'general',
    ]);
    expect(generalOnly.map((movement) => movement.id), ['general']);
    expect(await movements.readAllForUser('user-a'), hasLength(3));
    expect(await movements.readAllForUser('user-b'), hasLength(1));
  });

  test('StockMovementStore applies inclusive asOfDate and derives balance',
      () async {
    await movements.addMovements([
      _movement(
        id: 'inbound-a',
        quantity: 10,
        date: DateTime.utc(2026, 8),
      ),
      _movement(
        id: 'outbound-a',
        type: 'outbound',
        quantity: 3,
        date: DateTime.utc(2026, 8, 2),
      ),
      _movement(
        id: 'adjustment-a',
        type: 'adjustment',
        quantity: 2,
        date: DateTime.utc(2026, 8, 3),
      ),
    ]);

    expect(
      await movements.readStockLevel(
        'item-a',
        'user-a',
        warehouseId: 'wh-a',
        asOfDate: DateTime.utc(2026, 8, 2),
      ),
      7,
    );
    expect(
      await movements.readStockLevel(
        'item-a',
        'user-a',
        warehouseId: 'wh-a',
        asOfDate: DateTime.utc(2026, 8, 3),
      ),
      9,
    );
  });

  test('StockMovementStore preserves fields and finds dual-entry references',
      () async {
    await movements.addMovements([
      _movement(
        id: 'transfer-out',
        type: 'outbound',
        quantity: 7.5,
        unitCost: 8.25,
        referenceId: 'transfer-001',
        syncStatus: 'pendingPush',
      ),
      _movement(
        id: 'transfer-in',
        warehouseId: 'wh-b',
        quantity: 7.5,
        unitCost: 8.25,
        referenceId: 'transfer-001',
      ),
    ]);

    final byReference = await movements.readByReference(
      'transfer-001',
      'user-a',
    );
    final stored = byReference.firstWhere(
      (movement) => movement.id == 'transfer-out',
    );

    expect(byReference, hasLength(2));
    expect(stored.warehouseId, 'wh-a');
    expect(stored.quantity, 7.5);
    expect(stored.unitCost, 8.25);
    expect(stored.syncStatus, 'pendingPush');
  });

  test('standalone transfer is stored but blocked from derived balance',
      () async {
    await movements.addMovement(
      _movement(id: 'blocked-transfer', type: 'transfer'),
    );

    expect(
      () => movements.readStockLevel('item-a', 'user-a', warehouseId: 'wh-a'),
      throwsA(isA<StockMovementBlockedException>()),
    );
  });

  test(
      'StockMovementStore rejects invalid type, quantity, cost, and sync status',
      () async {
    expect(
      () => movements.addMovement(_movement(type: 'unknown')),
      throwsArgumentError,
    );
    expect(
      () => movements.addMovement(_movement(quantity: 0)),
      throwsArgumentError,
    );
    expect(
      () => movements.addMovement(_movement(unitCost: -1)),
      throwsArgumentError,
    );
    expect(
      () => movements.addMovement(_movement(syncStatus: 'unknown')),
      throwsArgumentError,
    );
    expect(await movements.readAllForUser('user-a'), isEmpty);
  });
}

StockMovementRecord _movement({
  String id = 'movement-a',
  String itemId = 'item-a',
  String? warehouseId = 'wh-a',
  String type = 'inbound',
  double quantity = 4,
  double unitCost = 10,
  DateTime? date,
  String? referenceId = 'reference-a',
  String? description = 'synthetic movement',
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
