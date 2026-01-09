import 'package:basir_app/core/models/sync_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_item.freezed.dart';
part 'inventory_item.g.dart';

/// كيان صنف المخزون (Inventory Item Entity)
///
/// يمثل صنفاً في المخزون مع دعم التسمية ثنائية اللغة وتكامل الحسابات.
@freezed
class InventoryItem with _$InventoryItem {
  /// إنشاء كيان صنف مخزون جديد.
  const factory InventoryItem({
    /// المعرف الفريد
    required String id,

    /// اسم الصنف بالعربية
    required String nameAr,

    /// اسم الصنف بالإنجليزية
    required String nameEn,

    /// تاريخ الإنشاء
    required DateTime createdAt,

    /// تاريخ التحديث
    required DateTime updatedAt,

    /// كود الصنف (SKU)
    String? sku,

    /// وصف الصنف
    String? description,

    /// سعر الشراء
    double? purchasePrice,

    /// سعر البيع
    double? salePrice,

    /// الكمية الحالية
    @Default(0.0) double currentQuantity,

    /// وحدة القياس
    String? unit,

    /// معرف الفئة
    String? categoryId,

    /// الحساب الأساسي
    String? primaryAccountId,

    /// حالة المزامنة
    @Default(SyncStatus.synced) SyncStatus syncStatus,

    /// تاريخ التحديث من الخادم
    DateTime? serverUpdatedAt,

    /// هل تم الحذف
    @Default(false) bool isDeleted,

    /// معرف المستخدم
    String? userId,
  }) = _InventoryItem;

  /// إنشاء صنف مخزون من JSON.
  factory InventoryItem.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemFromJson(json);
  const InventoryItem._();

  /// الحصول على الاسم حسب اللغة
  String name({required bool isArabic}) => isArabic ? nameAr : nameEn;
}
