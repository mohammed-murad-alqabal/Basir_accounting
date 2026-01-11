import 'package:basir_app/core/models/sync_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_movement.freezed.dart';
part 'stock_movement.g.dart';

/// أنواع حركة المخزون
enum StockMovementType {
  /// وارد (مشتريات، مرتجع مبيعات)
  inbound,

  /// صادر (مبيعات، مرتجع مشتريات)
  outbound,

  /// تحويل بين المستودعات
  transfer,

  /// تسوية (جرد، تلف، فقدان)
  adjustment,
}

/// كيان حركة المخزون (Stock Movement Entity)
///
/// يمثل حركة واحدة لصنف في المخزون.
@freezed
class StockMovement with _$StockMovement {
  /// تعريف كائن حركة المخزون
  const factory StockMovement({
    /// المعرف الفريد
    required String id,

    /// معرف الصنف
    required String itemId,

    /// معرف المستودع
    required String warehouseId,

    /// نوع الحركة
    required StockMovementType type,

    /// الكمية (تكون موجبة دائماً، والنوع يحدد الاتجاه)
    required double quantity,

    /// تكلفة الوحدة عند الحركة (للتقييم)
    required double unitCost,

    /// تاريخ الحركة
    required DateTime date,

    /// تاريخ الإنشاء
    required DateTime createdAt,

    /// المعرف المرجعي (فاتورة، سند تحويل، قيد)
    String? referenceId,

    /// وصف الحركة
    String? description,

    /// معرف المستخدم الذي قام بالحركة
    String? userId,

    /// حالة المزامنة
    @Default(SyncStatus.synced) SyncStatus syncStatus,
  }) = _StockMovement;

  /// تحويل من JSON
  factory StockMovement.fromJson(Map<String, dynamic> json) =>
      _$StockMovementFromJson(json);
}
