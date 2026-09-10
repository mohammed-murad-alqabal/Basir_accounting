import 'dart:io';

import 'package:basir_accounting_system/core/persistence/drift_stock_movements_golden.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late StockMovementGoldenCatalog catalog;

  setUpAll(() {
    catalog = StockMovementGoldenCatalog.fromJsonString(
      File('test/fixtures/stock_movements_golden_fixtures.json')
          .readAsStringSync(),
    );
  });

  test('SQLite StockMovementStore matches every clean golden balance',
      () async {
    for (final fixture in catalog.cleanFixtures) {
      final database = BasirDatabase(NativeDatabase.memory());
      try {
        final store = StockMovementStore(database);
        await store.addMovements(
          fixture.movements.map(_toRecord).toList(growable: false),
        );

        for (final expected in fixture.expectedBalances) {
          final actual = await store.readStockLevel(
            fixture.itemId,
            expected.userId ?? fixture.userId,
            warehouseId: expected.warehouseId,
            asOfDate: expected.asOfDate,
          );
          expect(
            actual,
            closeTo(expected.quantity, 0.000000001),
            reason: '${fixture.id}/${expected.warehouseId}/'
                '${expected.asOfDate.toIso8601String()}',
          );
        }
      } finally {
        await database.close();
      }
    }
  });

  test('SQLite reference lookup preserves dual-entry transfer references',
      () async {
    final fixture = catalog.cleanFixtures.singleWhere(
      (candidate) => candidate.id == 'transfer_dual_entry',
    );
    final database = BasirDatabase(NativeDatabase.memory());
    try {
      final store = StockMovementStore(database);
      await store.addMovements(
        fixture.movements.map(_toRecord).toList(growable: false),
      );
      final rows = await store.readByReference('transfer-001', 'user-a');

      expect(rows, hasLength(2));
      expect(rows.map((row) => row.warehouseId), containsAll(['wh-a', 'wh-b']));
    } finally {
      await database.close();
    }
  });

  test('SQLite storage blocks standalone transfer from derived balance',
      () async {
    final database = BasirDatabase(NativeDatabase.memory());
    try {
      final store = StockMovementStore(database);
      await store.addMovement(
        StockMovementRecord(
          id: 'blocked-transfer',
          itemId: 'item-blocked',
          warehouseId: 'wh-a',
          type: 'transfer',
          quantity: 1,
          unitCost: 1,
          date: DateTime.utc(2026, 7),
          referenceId: 'blocked-ref',
          description: 'synthetic blocked transfer',
          userId: 'user-a',
          syncStatus: 'synced',
          createdAt: DateTime.utc(2026, 7),
        ),
      );

      expect(
        () => store.readStockLevel(
          'item-blocked',
          'user-a',
          warehouseId: 'wh-a',
        ),
        throwsA(isA<StockMovementBlockedException>()),
      );
    } finally {
      await database.close();
    }
  });
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
