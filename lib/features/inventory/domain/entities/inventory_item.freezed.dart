// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InventoryItem _$InventoryItemFromJson(Map<String, dynamic> json) {
  return _InventoryItem.fromJson(json);
}

/// @nodoc
mixin _$InventoryItem {
  /// المعرف الفريد
  String get id => throw _privateConstructorUsedError;

  /// اسم الصنف بالعربية
  String get nameAr => throw _privateConstructorUsedError;

  /// اسم الصنف بالإنجليزية
  String get nameEn => throw _privateConstructorUsedError;

  /// تاريخ الإنشاء
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// تاريخ التحديث
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// كود الصنف (SKU)
  String? get sku => throw _privateConstructorUsedError;

  /// وصف الصنف
  String? get description => throw _privateConstructorUsedError;

  /// سعر الشراء
  double? get purchasePrice => throw _privateConstructorUsedError;

  /// سعر البيع
  double? get salePrice => throw _privateConstructorUsedError;

  /// الكمية الحالية
  double get currentQuantity => throw _privateConstructorUsedError;

  /// وحدة القياس
  String? get unit => throw _privateConstructorUsedError;

  /// معرف الفئة
  String? get categoryId => throw _privateConstructorUsedError;

  /// طريقة تقييم المخزون (IAS 2)
  ValuationMethod get valuationMethod => throw _privateConstructorUsedError;

  /// حساب الأصول (المخزون)
  String? get assetAccountId => throw _privateConstructorUsedError;

  /// حساب تكلفة البضاعة المباعة
  String? get cogsAccountId => throw _privateConstructorUsedError;

  /// حساب إيرادات المبيعات
  String? get revenueAccountId => throw _privateConstructorUsedError;

  /// الحساب الأساسي (للأغراض القديمة، سيتم استبداله بالأعلى)
  String? get primaryAccountId => throw _privateConstructorUsedError;

  /// حالة المزامنة
  SyncStatus get syncStatus => throw _privateConstructorUsedError;

  /// تاريخ التحديث من الخادم
  DateTime? get serverUpdatedAt => throw _privateConstructorUsedError;

  /// هل تم الحذف
  bool get isDeleted => throw _privateConstructorUsedError;

  /// معرف المستخدم
  String? get userId => throw _privateConstructorUsedError;

  /// معرف المستودع (لعزل البيانات)
  String? get warehouseId => throw _privateConstructorUsedError;

  /// باركود الصنف
  String? get barcode => throw _privateConstructorUsedError;

  /// فئة الضريبة الافتراضية (S=Standard, Z=Zero, etc)
  String get taxCategory => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InventoryItemCopyWith<InventoryItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryItemCopyWith<$Res> {
  factory $InventoryItemCopyWith(
          InventoryItem value, $Res Function(InventoryItem) then) =
      _$InventoryItemCopyWithImpl<$Res, InventoryItem>;
  @useResult
  $Res call(
      {String id,
      String nameAr,
      String nameEn,
      DateTime createdAt,
      DateTime updatedAt,
      String? sku,
      String? description,
      double? purchasePrice,
      double? salePrice,
      double currentQuantity,
      String? unit,
      String? categoryId,
      ValuationMethod valuationMethod,
      String? assetAccountId,
      String? cogsAccountId,
      String? revenueAccountId,
      String? primaryAccountId,
      SyncStatus syncStatus,
      DateTime? serverUpdatedAt,
      bool isDeleted,
      String? userId,
      String? warehouseId,
      String? barcode,
      String taxCategory});
}

/// @nodoc
class _$InventoryItemCopyWithImpl<$Res, $Val extends InventoryItem>
    implements $InventoryItemCopyWith<$Res> {
  _$InventoryItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? sku = freezed,
    Object? description = freezed,
    Object? purchasePrice = freezed,
    Object? salePrice = freezed,
    Object? currentQuantity = null,
    Object? unit = freezed,
    Object? categoryId = freezed,
    Object? valuationMethod = null,
    Object? assetAccountId = freezed,
    Object? cogsAccountId = freezed,
    Object? revenueAccountId = freezed,
    Object? primaryAccountId = freezed,
    Object? syncStatus = null,
    Object? serverUpdatedAt = freezed,
    Object? isDeleted = null,
    Object? userId = freezed,
    Object? warehouseId = freezed,
    Object? barcode = freezed,
    Object? taxCategory = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      purchasePrice: freezed == purchasePrice
          ? _value.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      salePrice: freezed == salePrice
          ? _value.salePrice
          : salePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      currentQuantity: null == currentQuantity
          ? _value.currentQuantity
          : currentQuantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      valuationMethod: null == valuationMethod
          ? _value.valuationMethod
          : valuationMethod // ignore: cast_nullable_to_non_nullable
              as ValuationMethod,
      assetAccountId: freezed == assetAccountId
          ? _value.assetAccountId
          : assetAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      cogsAccountId: freezed == cogsAccountId
          ? _value.cogsAccountId
          : cogsAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      revenueAccountId: freezed == revenueAccountId
          ? _value.revenueAccountId
          : revenueAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryAccountId: freezed == primaryAccountId
          ? _value.primaryAccountId
          : primaryAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
      serverUpdatedAt: freezed == serverUpdatedAt
          ? _value.serverUpdatedAt
          : serverUpdatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      warehouseId: freezed == warehouseId
          ? _value.warehouseId
          : warehouseId // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      taxCategory: null == taxCategory
          ? _value.taxCategory
          : taxCategory // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InventoryItemImplCopyWith<$Res>
    implements $InventoryItemCopyWith<$Res> {
  factory _$$InventoryItemImplCopyWith(
          _$InventoryItemImpl value, $Res Function(_$InventoryItemImpl) then) =
      __$$InventoryItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String nameAr,
      String nameEn,
      DateTime createdAt,
      DateTime updatedAt,
      String? sku,
      String? description,
      double? purchasePrice,
      double? salePrice,
      double currentQuantity,
      String? unit,
      String? categoryId,
      ValuationMethod valuationMethod,
      String? assetAccountId,
      String? cogsAccountId,
      String? revenueAccountId,
      String? primaryAccountId,
      SyncStatus syncStatus,
      DateTime? serverUpdatedAt,
      bool isDeleted,
      String? userId,
      String? warehouseId,
      String? barcode,
      String taxCategory});
}

/// @nodoc
class __$$InventoryItemImplCopyWithImpl<$Res>
    extends _$InventoryItemCopyWithImpl<$Res, _$InventoryItemImpl>
    implements _$$InventoryItemImplCopyWith<$Res> {
  __$$InventoryItemImplCopyWithImpl(
      _$InventoryItemImpl _value, $Res Function(_$InventoryItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? sku = freezed,
    Object? description = freezed,
    Object? purchasePrice = freezed,
    Object? salePrice = freezed,
    Object? currentQuantity = null,
    Object? unit = freezed,
    Object? categoryId = freezed,
    Object? valuationMethod = null,
    Object? assetAccountId = freezed,
    Object? cogsAccountId = freezed,
    Object? revenueAccountId = freezed,
    Object? primaryAccountId = freezed,
    Object? syncStatus = null,
    Object? serverUpdatedAt = freezed,
    Object? isDeleted = null,
    Object? userId = freezed,
    Object? warehouseId = freezed,
    Object? barcode = freezed,
    Object? taxCategory = null,
  }) {
    return _then(_$InventoryItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      purchasePrice: freezed == purchasePrice
          ? _value.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      salePrice: freezed == salePrice
          ? _value.salePrice
          : salePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      currentQuantity: null == currentQuantity
          ? _value.currentQuantity
          : currentQuantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      valuationMethod: null == valuationMethod
          ? _value.valuationMethod
          : valuationMethod // ignore: cast_nullable_to_non_nullable
              as ValuationMethod,
      assetAccountId: freezed == assetAccountId
          ? _value.assetAccountId
          : assetAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      cogsAccountId: freezed == cogsAccountId
          ? _value.cogsAccountId
          : cogsAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      revenueAccountId: freezed == revenueAccountId
          ? _value.revenueAccountId
          : revenueAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryAccountId: freezed == primaryAccountId
          ? _value.primaryAccountId
          : primaryAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
      serverUpdatedAt: freezed == serverUpdatedAt
          ? _value.serverUpdatedAt
          : serverUpdatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      warehouseId: freezed == warehouseId
          ? _value.warehouseId
          : warehouseId // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      taxCategory: null == taxCategory
          ? _value.taxCategory
          : taxCategory // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryItemImpl extends _InventoryItem {
  const _$InventoryItemImpl(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      required this.createdAt,
      required this.updatedAt,
      this.sku,
      this.description,
      this.purchasePrice,
      this.salePrice,
      this.currentQuantity = 0.0,
      this.unit,
      this.categoryId,
      this.valuationMethod = ValuationMethod.weightedAverage,
      this.assetAccountId,
      this.cogsAccountId,
      this.revenueAccountId,
      this.primaryAccountId,
      this.syncStatus = SyncStatus.synced,
      this.serverUpdatedAt,
      this.isDeleted = false,
      this.userId,
      this.warehouseId,
      this.barcode,
      this.taxCategory = 'S'})
      : super._();

  factory _$InventoryItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryItemImplFromJson(json);

  /// المعرف الفريد
  @override
  final String id;

  /// اسم الصنف بالعربية
  @override
  final String nameAr;

  /// اسم الصنف بالإنجليزية
  @override
  final String nameEn;

  /// تاريخ الإنشاء
  @override
  final DateTime createdAt;

  /// تاريخ التحديث
  @override
  final DateTime updatedAt;

  /// كود الصنف (SKU)
  @override
  final String? sku;

  /// وصف الصنف
  @override
  final String? description;

  /// سعر الشراء
  @override
  final double? purchasePrice;

  /// سعر البيع
  @override
  final double? salePrice;

  /// الكمية الحالية
  @override
  @JsonKey()
  final double currentQuantity;

  /// وحدة القياس
  @override
  final String? unit;

  /// معرف الفئة
  @override
  final String? categoryId;

  /// طريقة تقييم المخزون (IAS 2)
  @override
  @JsonKey()
  final ValuationMethod valuationMethod;

  /// حساب الأصول (المخزون)
  @override
  final String? assetAccountId;

  /// حساب تكلفة البضاعة المباعة
  @override
  final String? cogsAccountId;

  /// حساب إيرادات المبيعات
  @override
  final String? revenueAccountId;

  /// الحساب الأساسي (للأغراض القديمة، سيتم استبداله بالأعلى)
  @override
  final String? primaryAccountId;

  /// حالة المزامنة
  @override
  @JsonKey()
  final SyncStatus syncStatus;

  /// تاريخ التحديث من الخادم
  @override
  final DateTime? serverUpdatedAt;

  /// هل تم الحذف
  @override
  @JsonKey()
  final bool isDeleted;

  /// معرف المستخدم
  @override
  final String? userId;

  /// معرف المستودع (لعزل البيانات)
  @override
  final String? warehouseId;

  /// باركود الصنف
  @override
  final String? barcode;

  /// فئة الضريبة الافتراضية (S=Standard, Z=Zero, etc)
  @override
  @JsonKey()
  final String taxCategory;

  @override
  String toString() {
    return 'InventoryItem(id: $id, nameAr: $nameAr, nameEn: $nameEn, createdAt: $createdAt, updatedAt: $updatedAt, sku: $sku, description: $description, purchasePrice: $purchasePrice, salePrice: $salePrice, currentQuantity: $currentQuantity, unit: $unit, categoryId: $categoryId, valuationMethod: $valuationMethod, assetAccountId: $assetAccountId, cogsAccountId: $cogsAccountId, revenueAccountId: $revenueAccountId, primaryAccountId: $primaryAccountId, syncStatus: $syncStatus, serverUpdatedAt: $serverUpdatedAt, isDeleted: $isDeleted, userId: $userId, warehouseId: $warehouseId, barcode: $barcode, taxCategory: $taxCategory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.purchasePrice, purchasePrice) ||
                other.purchasePrice == purchasePrice) &&
            (identical(other.salePrice, salePrice) ||
                other.salePrice == salePrice) &&
            (identical(other.currentQuantity, currentQuantity) ||
                other.currentQuantity == currentQuantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.valuationMethod, valuationMethod) ||
                other.valuationMethod == valuationMethod) &&
            (identical(other.assetAccountId, assetAccountId) ||
                other.assetAccountId == assetAccountId) &&
            (identical(other.cogsAccountId, cogsAccountId) ||
                other.cogsAccountId == cogsAccountId) &&
            (identical(other.revenueAccountId, revenueAccountId) ||
                other.revenueAccountId == revenueAccountId) &&
            (identical(other.primaryAccountId, primaryAccountId) ||
                other.primaryAccountId == primaryAccountId) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.serverUpdatedAt, serverUpdatedAt) ||
                other.serverUpdatedAt == serverUpdatedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.warehouseId, warehouseId) ||
                other.warehouseId == warehouseId) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.taxCategory, taxCategory) ||
                other.taxCategory == taxCategory));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        nameAr,
        nameEn,
        createdAt,
        updatedAt,
        sku,
        description,
        purchasePrice,
        salePrice,
        currentQuantity,
        unit,
        categoryId,
        valuationMethod,
        assetAccountId,
        cogsAccountId,
        revenueAccountId,
        primaryAccountId,
        syncStatus,
        serverUpdatedAt,
        isDeleted,
        userId,
        warehouseId,
        barcode,
        taxCategory
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryItemImplCopyWith<_$InventoryItemImpl> get copyWith =>
      __$$InventoryItemImplCopyWithImpl<_$InventoryItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryItemImplToJson(
      this,
    );
  }
}

abstract class _InventoryItem extends InventoryItem {
  const factory _InventoryItem(
      {required final String id,
      required final String nameAr,
      required final String nameEn,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String? sku,
      final String? description,
      final double? purchasePrice,
      final double? salePrice,
      final double currentQuantity,
      final String? unit,
      final String? categoryId,
      final ValuationMethod valuationMethod,
      final String? assetAccountId,
      final String? cogsAccountId,
      final String? revenueAccountId,
      final String? primaryAccountId,
      final SyncStatus syncStatus,
      final DateTime? serverUpdatedAt,
      final bool isDeleted,
      final String? userId,
      final String? warehouseId,
      final String? barcode,
      final String taxCategory}) = _$InventoryItemImpl;
  const _InventoryItem._() : super._();

  factory _InventoryItem.fromJson(Map<String, dynamic> json) =
      _$InventoryItemImpl.fromJson;

  @override

  /// المعرف الفريد
  String get id;
  @override

  /// اسم الصنف بالعربية
  String get nameAr;
  @override

  /// اسم الصنف بالإنجليزية
  String get nameEn;
  @override

  /// تاريخ الإنشاء
  DateTime get createdAt;
  @override

  /// تاريخ التحديث
  DateTime get updatedAt;
  @override

  /// كود الصنف (SKU)
  String? get sku;
  @override

  /// وصف الصنف
  String? get description;
  @override

  /// سعر الشراء
  double? get purchasePrice;
  @override

  /// سعر البيع
  double? get salePrice;
  @override

  /// الكمية الحالية
  double get currentQuantity;
  @override

  /// وحدة القياس
  String? get unit;
  @override

  /// معرف الفئة
  String? get categoryId;
  @override

  /// طريقة تقييم المخزون (IAS 2)
  ValuationMethod get valuationMethod;
  @override

  /// حساب الأصول (المخزون)
  String? get assetAccountId;
  @override

  /// حساب تكلفة البضاعة المباعة
  String? get cogsAccountId;
  @override

  /// حساب إيرادات المبيعات
  String? get revenueAccountId;
  @override

  /// الحساب الأساسي (للأغراض القديمة، سيتم استبداله بالأعلى)
  String? get primaryAccountId;
  @override

  /// حالة المزامنة
  SyncStatus get syncStatus;
  @override

  /// تاريخ التحديث من الخادم
  DateTime? get serverUpdatedAt;
  @override

  /// هل تم الحذف
  bool get isDeleted;
  @override

  /// معرف المستخدم
  String? get userId;
  @override

  /// معرف المستودع (لعزل البيانات)
  String? get warehouseId;
  @override

  /// باركود الصنف
  String? get barcode;
  @override

  /// فئة الضريبة الافتراضية (S=Standard, Z=Zero, etc)
  String get taxCategory;
  @override
  @JsonKey(ignore: true)
  _$$InventoryItemImplCopyWith<_$InventoryItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
