import 'package:basir_accounting_system/core/storage/drift/inventory/inventory_connection_native.dart';
import 'package:basir_accounting_system/core/storage/drift/inventory/inventory_database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InventoryDatabase database;

  setUp(() {
    database = constructInventoryDatabase();
  });

  tearDown(() async {
    await database.close();
  });

  test('read repository filters by user and warehouse', () async {
    final now = DateTime.utc(2026, 8, 17);
    await database.into(database.inventoryItems).insert(
          InventoryItemsCompanion.insert(
            id: 'item-1',
            nameAr: 'صنف أول',
            nameEn: 'First item',
            createdAt: now,
            updatedAt: now,
            userId: const Value('user-1'),
            warehouseId: const Value('warehouse-1'),
          ),
        );
    await database.into(database.inventoryItems).insert(
          InventoryItemsCompanion.insert(
            id: 'item-2',
            nameAr: 'صنف آخر',
            nameEn: 'Other item',
            createdAt: now,
            updatedAt: now,
            userId: const Value('user-1'),
            warehouseId: const Value('warehouse-2'),
          ),
        );
    await database.into(database.inventoryItems).insert(
          InventoryItemsCompanion.insert(
            id: 'item-3',
            nameAr: 'صنف مستخدم آخر',
            nameEn: 'Other user item',
            createdAt: now,
            updatedAt: now,
            userId: const Value('user-2'),
            warehouseId: const Value('warehouse-1'),
          ),
        );

    final repository = InventoryReadRepository(
      database: database,
      userId: 'user-1',
      warehouseId: 'warehouse-1',
    );

    expect((await repository.getAllItems()).map((item) => item.id), ['item-1']);
    expect(await repository.getItemBySku('missing'), isNull);
    expect((await repository.searchItems('first')).single.id, 'item-1');
    expect(await repository.getItemById('item-3'), isNull);
  });
}
