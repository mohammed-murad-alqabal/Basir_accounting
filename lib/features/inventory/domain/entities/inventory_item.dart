import 'package:basir_app/core/models/sync_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_item.freezed.dart';
part 'inventory_item.g.dart';

/// طرق تقييم المخزون (IAS 2)
enum ValuationMethod {
  /// ما يرد أولاً يصرف أولاً
  fifo,

  /// المتوسط المرجح
  weightedAverage,
}

/// ملحق لإضافة وظائف الترجمة لطريقة التقييم
extension ValuationMethodX on ValuationMethod {
  /// الحصول على الاسم المترجم لطريقة التقييم
  String localizedName({required bool isArabic}) {
    if (isArabic) {
      if (this == ValuationMethod.fifo) {
        return 'الوارد أولاً يصرف أولاً (FIFO)';
      }
      return 'المتوسط المرجح';
    } else {
      if (this == ValuationMethod.fifo) {
        return 'First-In First-Out (FIFO)';
      }
      return 'Weighted Average';
    }
  }
}

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

    /// طريقة تقييم المخزون (IAS 2)
    @Default(ValuationMethod.weightedAverage) ValuationMethod valuationMethod,

    /// حساب الأصول (المخزون)
    String? assetAccountId,

    /// حساب تكلفة البضاعة المباعة
    String? cogsAccountId,

    /// حساب إيرادات المبيعات
    String? revenueAccountId,

    /// الحساب الأساسي (للأغراض القديمة، سيتم استبداله بالأعلى)
    String? primaryAccountId,

    /// حالة المزامنة
    @Default(SyncStatus.synced) SyncStatus syncStatus,

    /// تاريخ التحديث من الخادم
    DateTime? serverUpdatedAt,

    /// هل تم الحذف
    @Default(false) bool isDeleted,

    /// معرف المستخدم
    String? userId,

    /// معرف المستودع (لعزل البيانات)
    String? warehouseId,

    /// فئة الضريبة الافتراضية (S=Standard, Z=Zero, etc)
    @Default('S') String taxCategory,
  }) = _InventoryItem;

  /// إنشاء صنف مخزون من JSON.
  // ignore: lines_longer_than_80_chars
  factory InventoryItem.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemFromJson(json);

  const InventoryItem._();

  /// الحصول على الاسم حسب اللغة
  String name({required bool isArabic}) => isArabic ? nameAr : nameEn;
}
