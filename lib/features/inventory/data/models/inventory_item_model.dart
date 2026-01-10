import 'package:basir_app/core/models/sync_status.dart';
import 'package:basir_app/features/inventory/domain/entities/inventory_item.dart';
import 'package:isar/isar.dart';

part 'inventory_item_model.g.dart';

/// نموذج صنف المخزون لقاعدة بيانات Isar
@collection
class InventoryItemModel {
  /// إنشاء نموذج صنف مخزون
  InventoryItemModel();

  /// إنشاء نموذج صنف مخزون من كيان
  factory InventoryItemModel.fromEntity(
    InventoryItem item,
  ) =>
      InventoryItemModel()
        ..id = item.id
        ..nameAr = item.nameAr
        ..nameEn = item.nameEn
        ..sku = item.sku
        ..description = item.description
        ..purchasePrice = item.purchasePrice
        ..salePrice = item.salePrice
        ..currentQuantity = item.currentQuantity
        ..unit = item.unit
        ..categoryId = item.categoryId
        ..valuationMethod = item.valuationMethod
        ..assetAccountId = item.assetAccountId
        ..cogsAccountId = item.cogsAccountId
        ..revenueAccountId = item.revenueAccountId
        ..primaryAccountId = item.primaryAccountId
        ..syncStatus = item.syncStatus
        ..serverUpdatedAt = item.serverUpdatedAt
        ..isDeleted = item.isDeleted
        ..createdAt = item.createdAt
        ..updatedAt = item.updatedAt
        ..userId = item.userId
        ..taxCategory = item.taxCategory;

  /// معرف Isar التلقائي
  Id? isarId;

  /// المعرف الفريد (UUID)
  @Index(unique: true, replace: true)
  String? id;

  /// الاسم بالعربية
  @Index(type: IndexType.value)
  late String nameAr;

  /// الاسم بالإنجليزية
  @Index(type: IndexType.value)
  late String nameEn;

  /// كود الصنف (SKU)
  String? sku;

  /// وصف الصنف
  String? description;

  /// سعر الشراء
  double? purchasePrice;

  /// سعر البيع
  double? salePrice;

  /// الكمية الحالية
  double? currentQuantity;

  /// وحدة القياس
  String? unit;

  /// معرف الفئة
  String? categoryId;

  /// طريقة تقييم المخزون
  @Enumerated(EnumType.name)
  ValuationMethod valuationMethod = ValuationMethod.weightedAverage;

  /// حساب الأصول (المخزون)
  String? assetAccountId;

  /// حساب تكلفة البضاعة المباعة
  String? cogsAccountId;

  /// حساب إيرادات المبيعات
  String? revenueAccountId;

  /// الحساب الأساسي المرتبط
  String? primaryAccountId;

  /// حالة المزامنة
  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.synced;

  /// تاريخ التحديث من الخادم
  DateTime? serverUpdatedAt;

  /// هل تم الحذف
  bool isDeleted = false;

  /// تاريخ الإنشاء
  late DateTime createdAt;

  /// تاريخ التحديث
  late DateTime updatedAt;

  /// معرف المستخدم
  String? userId;

  /// فئة الضريبة
  late String taxCategory;

  /// تحويل النموذج إلى كيان
  InventoryItem toEntity() => InventoryItem(
        id: id ?? '',
        nameAr: nameAr,
        nameEn: nameEn,
        sku: sku,
        description: description,
        purchasePrice: purchasePrice,
        salePrice: salePrice,
        currentQuantity: currentQuantity ?? 0,
        unit: unit,
        categoryId: categoryId,
        valuationMethod: valuationMethod,
        assetAccountId: assetAccountId,
        cogsAccountId: cogsAccountId,
        revenueAccountId: revenueAccountId,
        primaryAccountId: primaryAccountId,
        syncStatus: syncStatus,
        serverUpdatedAt: serverUpdatedAt,
        isDeleted: isDeleted,
        createdAt: createdAt,
        updatedAt: updatedAt,
        userId: userId,
        taxCategory: taxCategory,
      );
}
