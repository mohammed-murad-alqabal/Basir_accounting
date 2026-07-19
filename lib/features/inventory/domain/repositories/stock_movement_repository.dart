import 'package:basir_accounting_system/features/inventory/domain/entities/stock_movement.dart';

/// واجهة مستودع حركات المخزون
abstract class StockMovementRepository {
  /// جلب الحركات لصنف معين (مع إمكانية الفلترة حسب المستودع)
  Future<List<StockMovement>> getMovementsForItem(
    String itemId, {
    String? warehouseId,
  });

  /// جلب الحركات بناءً على مرجع معين (مثل رقم الفاتورة)
  Future<List<StockMovement>> getMovementsByReference(String referenceId);

  /// إضافة حركة مخزون واحدة
  Future<void> addMovement(StockMovement movement);

  /// إضافة قائمة من حركات المخزون
  Future<void> addMovements(List<StockMovement> movements);

  /// جلب الرصيد الحالي لصنف (في مستودع معين أو إجمالاً) في تاريخ محدد
  Future<double> getStockLevel(
    String itemId, {
    String? warehouseId,
    DateTime? asOfDate,
  });
}
