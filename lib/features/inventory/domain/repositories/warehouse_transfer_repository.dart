import 'package:basir_accounting_system/features/inventory/domain/entities/warehouse_transfer.dart';

/// واجهة مستودع تحويلات المخزون
abstract class WarehouseTransferRepository {
  /// جلب جميع عمليات التحويل
  Future<List<WarehouseTransfer>> getAllTransfers();

  /// جلب عملية تحويل محددة بالمعرف
  Future<WarehouseTransfer?> getTransferById(String id);

  /// إضافة عملية تحويل جديدة
  Future<void> addTransfer(WarehouseTransfer transfer);

  /// تحديث بيانات عملية تحويل
  Future<void> updateTransfer(WarehouseTransfer transfer);

  /// حذف عملية تحويل
  Future<void> deleteTransfer(String id);
}
