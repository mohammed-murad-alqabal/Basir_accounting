import 'package:basir_accounting_system/features/inventory/domain/entities/stock_movement.dart';

/// واجهة مستودع حركات المخزون
abstract class StockMovementRepository {
  /// جلب حركات صنف ضمن المستودع الفعال حتى تاريخ شامل اختياري.
  ///
  /// يستخدم `date`، لا `createdAt`، لتحديد أهلية الحركة عند وجود
  /// `asOfDate`. الحركة العامة ذات `warehouseId = null` تُعامل وفق
  /// سياسة implementation الحالية عند طلب مستودع محدد.
  Future<List<StockMovement>> getMovementsForItem(
    String itemId, {
    String? warehouseId,
    DateTime? asOfDate,
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
