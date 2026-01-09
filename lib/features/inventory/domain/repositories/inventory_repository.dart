import 'package:basir_app/features/inventory/domain/entities/inventory_item.dart';

/// واجهة مستودع المخزون (Inventory Repository Interface)
abstract class InventoryRepository {
  /// الحصول على كل أصناف المخزون.
  Future<List<InventoryItem>> getAllItems();

  /// الحصول على صنف بواسطة المعرف.
  Future<InventoryItem?> getItemById(String id);

  /// إضافة صنف جديد.
  Future<void> addItem(InventoryItem item);

  /// تحديث بيانات صنف.
  Future<void> updateItem(InventoryItem item);

  /// حذف صنف.
  Future<void> deleteItem(String id);

  /// البحث عن أصناف.
  Future<List<InventoryItem>> searchItems(String query);
}
