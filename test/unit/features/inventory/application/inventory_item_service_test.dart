import 'package:basir_accounting_system/core/domain/contracts/audit_entry.dart';
import 'package:basir_accounting_system/features/inventory/application/inventory_item_service.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/inventory_item.dart';
import 'package:basir_accounting_system/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeInventoryRepository implements InventoryRepository {
  FakeInventoryRepository([Iterable<InventoryItem> initialItems = const []])
      : _items = {for (final item in initialItems) item.id: item};

  final Map<String, InventoryItem> _items;
  bool throwOnAdd = false;
  bool throwOnUpdate = false;
  InventoryItem? addedItem;
  InventoryItem? updatedItem;

  @override
  Future<void> addItem(InventoryItem item) async {
    if (throwOnAdd) throw StateError('storage unavailable');
    addedItem = item;
    _items[item.id] = item;
  }

  @override
  Future<void> deleteItem(String id) async {
    _items.remove(id);
  }

  @override
  Future<List<InventoryItem>> getAllItems() async => _items.values.toList();

  @override
  Future<InventoryItem?> getItemById(String id) async => _items[id];

  @override
  Future<InventoryItem?> getItemBySku(String sku) async {
    final normalized = sku.toUpperCase();
    for (final item in _items.values) {
      if (item.sku?.toUpperCase() == normalized) return item;
    }
    return null;
  }

  @override
  Future<List<InventoryItem>> searchItems(String query) async =>
      _items.values.toList();

  @override
  Future<void> updateItem(InventoryItem item) async {
    if (throwOnUpdate) throw StateError('storage unavailable');
    updatedItem = item;
    _items[item.id] = item;
  }
}

void main() {
  const recordedAt = '2026-08-14T10:30:00.000Z';
  final now = DateTime.parse(recordedAt);

  InventoryItem makeItem({
    String id = 'item-1',
    String nameAr = 'قلم',
    String nameEn = 'Pen',
    String? sku = 'SKU-001',
    String? barcode,
    double? purchasePrice = 10,
    double? salePrice = 15,
    double quantity = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      InventoryItem(
        id: id,
        nameAr: nameAr,
        nameEn: nameEn,
        sku: sku,
        barcode: barcode,
        purchasePrice: purchasePrice,
        salePrice: salePrice,
        currentQuantity: quantity,
        createdAt: createdAt ?? DateTime.parse('2026-01-01T00:00:00.000Z'),
        updatedAt: updatedAt ?? DateTime.parse('2026-01-01T00:00:00.000Z'),
      );

  group('InventoryItemService', () {
    late FakeInventoryRepository repository;
    late InventoryItemService service;

    setUp(() {
      repository = FakeInventoryRepository();
      service = InventoryItemService(
        repository: repository,
        now: () => now,
      );
    });

    test('creates a normalized zero-balance item with a creation audit entry',
        () async {
      final result = await service.create(
        makeItem(
          sku: ' sku-001 ',
          barcode: ' 6291234567890 ',
          nameAr: ' قلم حبر ',
          nameEn: ' Ink pen ',
        ),
        operatorName: 'أحمد',
      );

      expect(result.success, isTrue);
      expect(result.value, isNotNull);
      expect(result.value!.nameAr, 'قلم حبر');
      expect(result.value!.nameEn, 'Ink pen');
      expect(result.value!.sku, 'SKU-001');
      expect(result.value!.barcode, '6291234567890');
      expect(result.value!.currentQuantity, 0);
      expect(result.value!.createdAt, now);
      expect(result.value!.updatedAt, now);
      expect(repository.addedItem, result.value);
      expect(result.auditTrail, hasLength(1));
      expect(result.auditTrail!.single.type, AuditEventType.created);
      expect(result.auditTrail!.single.operatorName, 'أحمد');
      expect(result.auditTrail!.single.referenceId, 'item-1');
    });

    test('rejects an item without its required bilingual names', () async {
      final result = await service.create(
        makeItem(nameAr: '   '),
        operatorName: 'أحمد',
      );

      expect(result.success, isFalse);
      expect(result.message, InventoryItemService.emptyArabicNameCode);
      expect(repository.addedItem, isNull);
    });

    test('rejects negative purchase or sales prices', () async {
      final result = await service.create(
        makeItem(salePrice: -1),
        operatorName: 'أحمد',
      );

      expect(result.success, isFalse);
      expect(result.message, InventoryItemService.invalidPriceCode);
      expect(repository.addedItem, isNull);
    });

    test('rejects opening quantities because stock changes require a movement',
        () async {
      final result = await service.create(
        makeItem(quantity: 1),
        operatorName: 'أحمد',
      );

      expect(result.success, isFalse);
      expect(
        result.message,
        InventoryItemService.quantityMutationForbiddenCode,
      );
      expect(repository.addedItem, isNull);
    });

    test('rejects a case-insensitive duplicate SKU', () async {
      repository = FakeInventoryRepository([makeItem(sku: 'sku-001')]);
      service = InventoryItemService(repository: repository, now: () => now);

      final result = await service.create(
        makeItem(id: 'item-2'),
        operatorName: 'أحمد',
      );

      expect(result.success, isFalse);
      expect(result.message, InventoryItemService.duplicateSkuCode);
      expect(repository.addedItem, isNull);
    });

    test('rejects a duplicate barcode even when the SKU differs', () async {
      repository = FakeInventoryRepository([
        makeItem(barcode: '6291234567890'),
      ]);
      service = InventoryItemService(repository: repository, now: () => now);

      final result = await service.create(
        makeItem(
          id: 'item-2',
          sku: 'SKU-002',
          barcode: '6291234567890',
        ),
        operatorName: 'أحمد',
      );

      expect(result.success, isFalse);
      expect(result.message, InventoryItemService.duplicateBarcodeCode);
      expect(repository.addedItem, isNull);
    });

    test('updates master data while preserving the existing stock balance',
        () async {
      final existing = makeItem(
        quantity: 12,
        createdAt: DateTime.parse('2025-12-01T00:00:00.000Z'),
      );
      repository = FakeInventoryRepository([existing]);
      service = InventoryItemService(repository: repository, now: () => now);

      final result = await service.update(
        existing.copyWith(
          nameAr: 'قلم أزرق',
          salePrice: 18,
          createdAt: now,
          updatedAt: now,
        ),
        operatorName: 'ليان',
      );

      expect(result.success, isTrue);
      expect(result.value!.nameAr, 'قلم أزرق');
      expect(result.value!.salePrice, 18);
      expect(result.value!.currentQuantity, 12);
      expect(result.value!.createdAt, existing.createdAt);
      expect(result.value!.updatedAt, now);
      expect(repository.updatedItem, result.value);
      expect(result.auditTrail!.single.type, AuditEventType.edited);
      expect(result.auditTrail!.single.operatorName, 'ليان');
    });

    test('rejects direct quantity changes during an item master-data update',
        () async {
      final existing = makeItem(quantity: 12);
      repository = FakeInventoryRepository([existing]);
      service = InventoryItemService(repository: repository, now: () => now);

      final result = await service.update(
        existing.copyWith(currentQuantity: 13),
        operatorName: 'ليان',
      );

      expect(result.success, isFalse);
      expect(
        result.message,
        InventoryItemService.quantityMutationForbiddenCode,
      );
      expect(repository.updatedItem, isNull);
    });

    test('rejects missing English names, item IDs, and operators', () async {
      final emptyEnglish = await service.create(
        makeItem(nameEn: '  '),
        operatorName: 'أحمد',
      );
      final emptyId = await service.create(
        makeItem(id: ''),
        operatorName: 'أحمد',
      );
      final emptyOperator = await service.create(
        makeItem(),
        operatorName: '  ',
      );

      expect(emptyEnglish.message, InventoryItemService.emptyEnglishNameCode);
      expect(emptyId.message, InventoryItemService.emptyIdCode);
      expect(emptyOperator.message, InventoryItemService.operatorRequiredCode);
      expect(repository.addedItem, isNull);
    });

    test('rejects cross-field SKU and barcode identifier collisions', () async {
      repository = FakeInventoryRepository([
        makeItem(barcode: '6291234567890'),
      ]);
      service = InventoryItemService(repository: repository, now: () => now);

      final skuUsesBarcode = await service.create(
        makeItem(id: 'item-2', sku: '6291234567890'),
        operatorName: 'أحمد',
      );
      final barcodeUsesSku = await service.create(
        makeItem(id: 'item-3', sku: 'SKU-003', barcode: 'SKU-001'),
        operatorName: 'أحمد',
      );

      expect(skuUsesBarcode.message, InventoryItemService.duplicateSkuCode);
      expect(
        barcodeUsesSku.message,
        InventoryItemService.duplicateBarcodeCode,
      );
    });

    test('rejects an update that reuses another item barcode', () async {
      final existing = makeItem(barcode: '6291111111111');
      final other = makeItem(
        id: 'item-2',
        sku: 'SKU-002',
        barcode: '6292222222222',
      );
      repository = FakeInventoryRepository([existing, other]);
      service = InventoryItemService(repository: repository, now: () => now);

      final result = await service.update(
        existing.copyWith(barcode: other.barcode),
        operatorName: 'ليان',
      );

      expect(result.success, isFalse);
      expect(result.message, InventoryItemService.duplicateBarcodeCode);
      expect(repository.updatedItem, isNull);
    });

    test('allows an item to retain its own identifiers while updating',
        () async {
      final existing = makeItem(
        barcode: '6291234567890',
        quantity: 5,
      );
      repository = FakeInventoryRepository([existing]);
      service = InventoryItemService(repository: repository, now: () => now);

      final result = await service.update(
        existing.copyWith(nameEn: 'Blue pen'),
        operatorName: 'ليان',
      );

      expect(result.success, isTrue);
      expect(repository.updatedItem!.barcode, '6291234567890');
    });

    test('rejects update of a missing item before persisting', () async {
      final result = await service.update(
        makeItem(),
        operatorName: 'ليان',
      );

      expect(result.success, isFalse);
      expect(result.message, InventoryItemService.itemNotFoundCode);
      expect(repository.updatedItem, isNull);
    });

    test('returns a stable failure result when create persistence fails',
        () async {
      repository.throwOnAdd = true;

      final result = await service.create(
        makeItem(),
        operatorName: 'أحمد',
      );

      expect(result.success, isFalse);
      expect(result.message, InventoryItemService.commitFailedCode);
      expect(result.cause, isA<StateError>());
    });

    test('returns a stable failure result when update persistence fails',
        () async {
      final existing = makeItem();
      repository = FakeInventoryRepository([existing])..throwOnUpdate = true;
      service = InventoryItemService(repository: repository, now: () => now);

      final result = await service.update(
        existing.copyWith(nameAr: 'قلم حبر'),
        operatorName: 'ليان',
      );

      expect(result.success, isFalse);
      expect(result.message, InventoryItemService.commitFailedCode);
      expect(result.cause, isA<StateError>());
    });
  });
}
