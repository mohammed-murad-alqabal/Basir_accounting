import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'warehouse_transfer.freezed.dart';
part 'warehouse_transfer.g.dart';

/// حالة أمر التحويل
enum TransferStatus {
  /// مسودة
  draft,

  /// بانتظار الشحن/الخروج
  pending,

  /// تم الشحن/في الطريق
  inTransit,

  /// مكتمل (تم الاستلام)
  completed,

  /// ملغي
  cancelled,
}

/// بند في أمر التحويل (Transfer Item Entity)
@freezed
class TransferItem with _$TransferItem {
  /// تعريف بند التحويل
  const factory TransferItem({
    /// معرف الصنف
    required String itemId,

    /// اسم الصنف
    required String itemName,

    /// الكمية
    required double quantity,

    /// الوحدة (اختياري)
    String? unit,

    /// ملاحظة (اختياري)
    String? note,
  }) = _TransferItem;

  /// تحويل من JSON
  factory TransferItem.fromJson(Map<String, dynamic> json) =>
      _$TransferItemFromJson(json);
}

/// كيان تحويل المخزون (Warehouse Transfer Entity)
///
/// يمثل عملية نقل أصناف بين مستودعين.
@freezed
class WarehouseTransfer with _$WarehouseTransfer {
  /// تعريف تحويل المخزون
  const factory WarehouseTransfer({
    /// المعرف الفريد
    required String id,

    /// رقم أمر التحويل
    required String transferNumber,

    /// مستودع المصدر
    required String sourceWarehouseId,

    /// مستودع الوجهة
    required String destinationWarehouseId,

    /// تاريخ التحويل
    required DateTime date,

    /// قائمة الأصناف المحولة
    required List<TransferItem> items,

    /// تاريخ الإنشاء
    required DateTime createdAt,

    /// تاريخ التحديث
    required DateTime updatedAt,

    /// حالة التحويل
    @Default(TransferStatus.completed) TransferStatus status,

    /// ملاحظات
    String? remarks,

    /// معرف المستخدم
    String? userId,

    /// حالة المزامنة
    @Default(SyncStatus.synced) SyncStatus syncStatus,
  }) = _WarehouseTransfer;

  /// تحويل من JSON
  factory WarehouseTransfer.fromJson(Map<String, dynamic> json) =>
      _$WarehouseTransferFromJson(json);
}
