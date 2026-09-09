import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BasirDatabase database;
  late InventoryItemStore items;

  setUp(() {
    database = BasirDatabase(NativeDatabase.memory());
    items = InventoryItemStore(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('InventoryItemStore isolates UUIDs and includes general warehouse rows',
      () async {
    await items.save(_item());
    await items.save(
      _item(
        id: 'item-b',
        nameAr: 'صنف مستودع',
        warehouseId: 'warehouse-a',
      ),
    );
    await items.save(
      _item(
        userId: 'user-b',
        nameAr: 'صنف مستخدم ب',
      ),
    );

    final warehouseRows = await items.readAllForUser(
      'user-a',
      warehouseId: 'warehouse-a',
    );
    final userB = await items.readById('item-a', 'user-b');
    final missing = await items.readById('item-a', 'user-c');

    expect(warehouseRows.map((record) => record.id), ['item-a', 'item-b']);
    expect(userB, isNotNull);
    expect(userB!.userId, 'user-b');
    expect(missing, isNull);
  });

  test('InventoryItemStore search and SKU lookup match Isar behavior',
      () async {
    await items.save(_item());
    await items.save(
      _item(
        id: 'item-b',
        nameAr: 'شركة الرياض',
        nameEn: 'Riyadh Trading',
        sku: 'SKU-RIYADH',
      ),
    );
    await items.save(
      _item(
        id: 'item-deleted',
        nameAr: 'محذوف',
        sku: 'SKU-DELETED',
        isDeleted: true,
      ),
    );

    expect(
      (await items.searchForUser('TRADING', 'user-a'))
          .map((record) => record.id),
      ['item-b'],
    );
    expect(
      (await items.searchForUser('صنف', 'user-a')).map((record) => record.id),
      ['item-a'],
    );
    expect((await items.readBySku('sku-riyadh', 'user-a'))?.id, 'item-b');
    expect(await items.readBySku('SKU-DELETED', 'user-a'), isNull);
    expect((await items.readById('item-deleted', 'user-a'))?.isDeleted, isTrue);
  });

  test(
      'InventoryItemStore preserves accounting, valuation, sync, and barcode fields',
      () async {
    final record = _item(
      purchasePrice: 25.75,
      salePrice: 42.50,
      currentQuantity: 18.25,
      valuationMethod: 'fifo',
      assetAccountId: 'asset-1300',
      cogsAccountId: 'cogs-5100',
      revenueAccountId: 'revenue-4100',
      primaryAccountId: 'legacy-1300',
      syncStatus: 'pendingPush',
      serverUpdatedAt: DateTime.utc(2026, 8, 17, 10),
      barcode: '6281234567890',
      taxCategory: 'Z',
    );

    await items.save(record);
    final stored = await items.readById('item-a', 'user-a');

    expect(stored, isNotNull);
    expect(stored!.purchasePrice, 25.75);
    expect(stored.salePrice, 42.50);
    expect(stored.currentQuantity, 18.25);
    expect(stored.valuationMethod, 'fifo');
    expect(stored.assetAccountId, 'asset-1300');
    expect(stored.cogsAccountId, 'cogs-5100');
    expect(stored.revenueAccountId, 'revenue-4100');
    expect(stored.primaryAccountId, 'legacy-1300');
    expect(stored.syncStatus, 'pendingPush');
    expect(stored.serverUpdatedAt?.toUtc(), DateTime.utc(2026, 8, 17, 10));
    expect(stored.barcode, '6281234567890');
    expect(stored.taxCategory, 'Z');
  });

  test('InventoryItemStore soft-delete is scoped and updates timestamp',
      () async {
    await items.save(_item());
    await items.save(_item(userId: 'user-b'));
    final before = DateTime.now().toUtc();

    await items.softDeleteById('item-a', 'user-a');

    final deleted = await items.readById('item-a', 'user-a');
    final otherUser = await items.readById('item-a', 'user-b');
    expect(deleted, isNotNull);
    expect(deleted!.isDeleted, isTrue);
    expect(
      !deleted.updatedAt.isBefore(
        before.subtract(const Duration(seconds: 1)),
      ),
      isTrue,
    );
    expect(otherUser!.isDeleted, isFalse);
    expect(await items.readAllForUser('user-a'), isEmpty);
  });

  test(
      'InventoryItemStore rejects unknown enum, sync, tax, and identity values',
      () async {
    expect(
      () => items.save(_item(valuationMethod: 'unknown')),
      throwsArgumentError,
    );
    expect(
      () => items.save(_item(syncStatus: 'unknown')),
      throwsArgumentError,
    );
    expect(
      () => items.save(_item(taxCategory: '')),
      throwsArgumentError,
    );
    expect(
      () => items.save(_item(id: '')),
      throwsArgumentError,
    );
    expect(await items.readAll(), isEmpty);
  });
}

InventoryItemRecord _item({
  String id = 'item-a',
  String nameAr = 'صنف أ',
  String nameEn = 'Item A',
  String? sku = 'SKU-A',
  String? description = 'fixture',
  double? purchasePrice = 10.5,
  double? salePrice = 15.0,
  double currentQuantity = 4.0,
  String? unit = 'piece',
  String? categoryId = 'category-a',
  String valuationMethod = 'weightedAverage',
  String? assetAccountId = 'asset-a',
  String? cogsAccountId = 'cogs-a',
  String? revenueAccountId = 'revenue-a',
  String? primaryAccountId = 'primary-a',
  String syncStatus = 'synced',
  DateTime? serverUpdatedAt,
  bool isDeleted = false,
  DateTime? createdAt,
  DateTime? updatedAt,
  String userId = 'user-a',
  String? warehouseId,
  String? barcode = 'barcode-a',
  String taxCategory = 'S',
}) =>
    InventoryItemRecord(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      sku: sku,
      description: description,
      purchasePrice: purchasePrice,
      salePrice: salePrice,
      currentQuantity: currentQuantity,
      unit: unit,
      categoryId: categoryId,
      valuationMethod: valuationMethod,
      assetAccountId: assetAccountId,
      cogsAccountId: cogsAccountId,
      revenueAccountId: revenueAccountId,
      primaryAccountId: primaryAccountId,
      syncStatus: syncStatus,
      serverUpdatedAt: serverUpdatedAt,
      isDeleted: isDeleted,
      createdAt: createdAt ?? DateTime.utc(2026),
      updatedAt: updatedAt ?? DateTime.utc(2026, 8),
      userId: userId,
      warehouseId: warehouseId,
      barcode: barcode,
      taxCategory: taxCategory,
    );
