import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/auth/domain/models/auth_models.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/inventory_item.dart';
import 'package:basir_accounting_system/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:basir_accounting_system/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeInventoryRepository implements InventoryRepository {
  _FakeInventoryRepository([Iterable<InventoryItem> initialItems = const []])
      : _items = {for (final item in initialItems) item.id: item};

  final Map<String, InventoryItem> _items;
  InventoryItem? addedItem;
  InventoryItem? updatedItem;
  bool throwOnDelete = false;

  @override
  Future<void> addItem(InventoryItem item) async {
    addedItem = item;
    _items[item.id] = item;
  }

  @override
  Future<void> deleteItem(String id) async {
    if (throwOnDelete) throw StateError('storage unavailable');
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
    updatedItem = item;
    _items[item.id] = item;
  }
}

InventoryItem _item({
  String id = 'item-1',
  String nameAr = 'قلم',
  String nameEn = 'Pen',
  String? sku = 'SKU-001',
  String? barcode,
  double quantity = 0,
}) =>
    InventoryItem(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      sku: sku,
      barcode: barcode,
      currentQuantity: quantity,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

ProviderContainer _container(
  _FakeInventoryRepository repository, {
  BasirUser? profile,
  String? username,
}) =>
    ProviderContainer(
      overrides: [
        inventoryRepositoryProvider.overrideWithValue(repository),
        currentUserProfileProvider.overrideWith((ref) => profile),
        currentUsernameProvider.overrideWith((ref) => username),
      ],
    );

void main() {
  test('loads, filters, and finds catalog items using SKU and barcode',
      () async {
    final redPen = _item(barcode: '6291234567890');
    final notebook = _item(
      id: 'item-2',
      nameAr: 'دفتر',
      nameEn: 'Notebook',
      sku: 'SKU-002',
    );
    final container = _container(_FakeInventoryRepository([redPen, notebook]));
    addTearDown(container.dispose);

    expect(await container.read(inventoryItemsProvider.future), hasLength(2));
    expect(await container.read(itemBySkuProvider('sku-001').future), redPen);

    container.read(inventorySearchProvider.notifier).state = '629123';
    final filtered =
        container.read(filteredInventoryItemsProvider).requireValue;
    expect(filtered, [redPen]);
  });

  test('adds through the policy with the authenticated profile as auditor',
      () async {
    final repository = _FakeInventoryRepository();
    final container = _container(
      repository,
      profile: const BasirUser(
        id: 'operator-1',
        email: 'sara@example.com',
        displayName: 'سارة',
      ),
      username: 'مستخدم احتياطي',
    );
    addTearDown(container.dispose);

    final result =
        await container.read(inventoryActionProvider.notifier).addItem(
              _item(),
            );

    expect(result.success, isTrue);
    expect(result.auditTrail!.single.operatorName, 'سارة');
    expect(repository.addedItem, isNotNull);
    expect(container.read(inventoryActionProvider), isA<AsyncData<void>>());
  });

  test('updates through the policy and preserves the stock balance', () async {
    final existing = _item(quantity: 12);
    final repository = _FakeInventoryRepository([existing]);
    final container = _container(repository, username: 'ليان');
    addTearDown(container.dispose);

    final result =
        await container.read(inventoryActionProvider.notifier).updateItem(
              existing.copyWith(nameEn: 'Blue pen'),
            );

    expect(result.success, isTrue);
    expect(result.auditTrail!.single.operatorName, 'ليان');
    expect(repository.updatedItem!.currentQuantity, 12);
    expect(repository.updatedItem!.nameEn, 'Blue pen');
  });

  test('returns the policy failure without refreshing a missing item',
      () async {
    final repository = _FakeInventoryRepository();
    final container = _container(repository, username: 'ليان');
    addTearDown(container.dispose);

    final result =
        await container.read(inventoryActionProvider.notifier).updateItem(
              _item(),
            );

    expect(result.success, isFalse);
    expect(repository.updatedItem, isNull);
    expect(container.read(inventoryActionProvider), isA<AsyncData<void>>());
  });

  test(
      'deletes an item and exposes persistence failures through notifier state',
      () async {
    final existing = _item();
    final repository = _FakeInventoryRepository([existing]);
    final container = _container(repository);
    addTearDown(container.dispose);

    await container
        .read(inventoryActionProvider.notifier)
        .deleteItem(existing.id);
    expect(await container.read(inventoryItemsProvider.future), isEmpty);

    repository.throwOnDelete = true;
    await container.read(inventoryActionProvider.notifier).deleteItem('item-2');
    expect(container.read(inventoryActionProvider).hasError, isTrue);
  });
}
