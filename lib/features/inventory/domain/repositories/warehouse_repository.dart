import 'package:basir_accounting_system/features/inventory/domain/entities/warehouse.dart';

/// واجهة مستودع المستودعات
abstract class WarehouseRepository {
  /// جلب جميع المستودعات
  Future<List<Warehouse>> getAllWarehouses();

  /// جلب مستودع محدد بالمعرف
  Future<Warehouse?> getWarehouseById(String id);

  /// إضافة مستودع جديد
  Future<void> addWarehouse(Warehouse warehouse);

  /// تحديث بيانات مستودع
  Future<void> updateWarehouse(Warehouse warehouse);

  /// حذف مستودع
  Future<void> deleteWarehouse(String id);
}
