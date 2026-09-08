import 'package:basir_accounting_system/features/inventory/data/models/inventory_item_model.dart';
import 'package:basir_accounting_system/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/inventory_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

void main() {
  const userId = 'user-warehouse';
  const warehouseId = 'warehouse-riyadh';
  final now = DateTime(2026, 8, 15, 9);

  InventoryItem item({
    required String id,
    required String nameAr,
    String nameEn = 'Inventory item',
    String? sku,
    String? itemUserId,
    String? itemWarehouseId,
    bool isDeleted = false,
    double quantity = 0,
    double? salePrice,
  }) =>
      InventoryItem(
        id: id,
        nameAr: nameAr,
        nameEn: nameEn,
        sku: sku,
        createdAt: now,
        updatedAt: now,
        userId: itemUserId,
        warehouseId: itemWarehouseId,
        isDeleted: isDeleted,
        currentQuantity: quantity,
        salePrice: salePrice,
      );

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  group('InventoryRepositoryImpl', () {
    late Isar isar;
    late InventoryRepositoryImpl repository;

    setUp(() async {
      isar = await Isar.open(
        [InventoryItemModelSchema],
        directory: '',
        name: 'inventory_repository_${DateTime.now().microsecondsSinceEpoch}',
      );
      repository = InventoryRepositoryImpl(
        isar: isar,
        userId: userId,
        warehouseId: warehouseId,
      );
    });

    tearDown(() => isar.close(deleteFromDisk: true));

    test('يعزل قائمة الأصناف حسب المستخدم والمستودع ويستبعد المحذوف', () async {
      await repository.addItem(
        item(
          id: 'local',
          nameAr: 'صنف محلي',
          itemWarehouseId: warehouseId,
        ),
      );
      await repository.addItem(
        item(id: 'global', nameAr: 'صنف عام'),
      );
      await repository.addItem(
        item(
          id: 'other-warehouse',
          nameAr: 'صنف مستودع آخر',
          itemWarehouseId: 'warehouse-jeddah',
        ),
      );
      await isar.writeTxn(() async {
        await isar.inventoryItemModels.put(
          InventoryItemModel.fromEntity(
            item(
              id: 'other-user',
              nameAr: 'صنف مستخدم آخر',
              itemUserId: 'another-user',
              itemWarehouseId: warehouseId,
            ),
          ),
        );
        await isar.inventoryItemModels.put(
          InventoryItemModel.fromEntity(
            item(
              id: 'deleted',
              nameAr: 'صنف محذوف',
              itemWarehouseId: warehouseId,
              isDeleted: true,
            ),
          ),
        );
      });

      final items = await repository.getAllItems();

      expect(items.map((entry) => entry.id), containsAll(['local', 'global']));
      expect(
        items.map((entry) => entry.id),
        isNot(contains('other-warehouse')),
      );
      expect(items.map((entry) => entry.id), isNot(contains('other-user')));
      expect(items.map((entry) => entry.id), isNot(contains('deleted')));
    });

    test('يبحث بالاسم العربي والإنجليزي وSKU ويستعيد الصنف بمعرفه', () async {
      await repository.addItem(
        item(
          id: 'pen',
          nameAr: 'قلم أزرق',
          nameEn: 'Blue pen',
          sku: 'PEN-001',
          itemWarehouseId: warehouseId,
        ),
      );
      await repository.addItem(
        item(
          id: 'paper',
          nameAr: 'ورق',
          nameEn: 'Paper',
          sku: 'PAPER-002',
          itemWarehouseId: warehouseId,
        ),
      );

      final arabicResult = await repository.searchItems('قلم');
      final englishResult = await repository.searchItems('blue');
      final skuResult = await repository.searchItems('paper-');
      final bySku = await repository.getItemBySku('pen-001');
      final byId = await repository.getItemById('paper');

      expect(arabicResult.single.id, 'pen');
      expect(englishResult.single.id, 'pen');
      expect(skuResult.single.id, 'paper');
      expect(bySku?.id, 'pen');
      expect(byId?.nameAr, 'ورق');
      expect(await repository.getItemById('missing'), isNull);
    });

    test('يحدّث الصنف المحفوظ ثم يحذفه حذفاً منطقياً', () async {
      await repository.addItem(
        item(
          id: 'update-me',
          nameAr: 'صنف قديم',
          sku: 'UPDATE-1',
          quantity: 2,
          salePrice: 12,
          itemWarehouseId: warehouseId,
        ),
      );

      await repository.updateItem(
        item(
          id: 'update-me',
          nameAr: 'صنف محدّث',
          sku: 'UPDATE-1',
          quantity: 9,
          salePrice: 18.5,
          itemWarehouseId: warehouseId,
        ),
      );

      final updated = await repository.getItemBySku('UPDATE-1');
      expect(updated?.nameAr, 'صنف محدّث');
      expect(updated?.currentQuantity, 9);
      expect(updated?.salePrice, 18.5);

      await repository.deleteItem('update-me');

      expect(await repository.getAllItems(), isEmpty);
      expect(await repository.getItemBySku('UPDATE-1'), isNull);
      expect((await repository.getItemById('update-me'))?.isDeleted, isTrue);
    });

    test('يرفض تحديث صنف غير موجود في نطاق المستخدم والمستودع', () async {
      final missing = item(
        id: 'not-stored',
        nameAr: 'غير موجود',
        itemWarehouseId: warehouseId,
      );

      await expectLater(
        () => repository.updateItem(missing),
        throwsA(isA<Exception>()),
      );
    });
  });
}
