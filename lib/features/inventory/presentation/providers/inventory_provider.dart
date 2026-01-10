import 'package:basir_app/core/providers.dart';
import 'package:basir_app/features/inventory/domain/entities/inventory_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// مزود قائمة أصناف المخزون
final inventoryItemsProvider = FutureProvider<List<InventoryItem>>((ref) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  return repository.getAllItems();
});

/// مزود جلب صنف بواسطة الكود
final itemBySkuProvider = FutureProvider.family<InventoryItem?, String>((ref, sku) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  return repository.getItemBySku(sku);
});

/// مزود البحث في المخزون
final inventorySearchProvider = StateProvider<String>((ref) => '');

/// مزود أصناف المخزون المفلترة بناءً على البحث
final filteredInventoryItemsProvider = Provider<AsyncValue<List<InventoryItem>>>((ref) {
  final itemsAsync = ref.watch(inventoryItemsProvider);
  final searchQuery = ref.watch(inventorySearchProvider).toLowerCase();

  if (searchQuery.isEmpty) return itemsAsync;

  return itemsAsync.whenData(
    (items) => items.where((item) {
      final nameAr = item.nameAr.toLowerCase();
      final nameEn = item.nameEn.toLowerCase();
      final sku = (item.sku ?? '').toLowerCase();

      return nameAr.contains(searchQuery) ||
          nameEn.contains(searchQuery) ||
          sku.contains(searchQuery);
    }).toList(),
  );
});

/// صنف المورد/الخدمة (نوتيفاير لإدارة العمليات)
class InventoryNotifier extends StateNotifier<AsyncValue<void>> {
  /// إنشاء نوتيفاير إجراءات المخزون
  InventoryNotifier({required this.ref}) : super(const AsyncValue.data(null));

  /// مرجع الموفر (Riverpod)
  final Ref ref;

  /// إضافة صنف مخزون جديد
  Future<void> addItem(InventoryItem item) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(inventoryRepositoryProvider);
      await repository.addItem(item);
      ref.invalidate(inventoryItemsProvider);
      state = const AsyncValue.data(null);
    } on Object catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// تحديث صنف مخزون موجود
  Future<void> updateItem(InventoryItem item) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(inventoryRepositoryProvider);
      await repository.updateItem(item);
      ref.invalidate(inventoryItemsProvider);
      state = const AsyncValue.data(null);
    } on Object catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// حذف صنف مخزون
  Future<void> deleteItem(String id) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(inventoryRepositoryProvider);
      await repository.deleteItem(id);
      ref.invalidate(inventoryItemsProvider);
      state = const AsyncValue.data(null);
    } on Object catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

/// مزود العمليات على المخزون
final inventoryActionProvider = StateNotifierProvider<InventoryNotifier, AsyncValue<void>>(
  (ref) => InventoryNotifier(ref: ref),
);
