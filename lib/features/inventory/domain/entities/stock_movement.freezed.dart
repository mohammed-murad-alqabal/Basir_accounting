// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_movement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StockMovement _$StockMovementFromJson(Map<String, dynamic> json) {
  return _StockMovement.fromJson(json);
}

/// @nodoc
mixin _$StockMovement {
  /// المعرف الفريد
  String get id => throw _privateConstructorUsedError;

  /// معرف الصنف
  String get itemId => throw _privateConstructorUsedError;

  /// معرف المستودع
  String get warehouseId => throw _privateConstructorUsedError;

  /// نوع الحركة
  StockMovementType get type => throw _privateConstructorUsedError;

  /// الكمية (تكون موجبة دائماً، والنوع يحدد الاتجاه)
  double get quantity => throw _privateConstructorUsedError;

  /// تكلفة الوحدة عند الحركة (للتقييم)
  double get unitCost => throw _privateConstructorUsedError;

  /// تاريخ الحركة
  DateTime get date => throw _privateConstructorUsedError;

  /// تاريخ الإنشاء
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// المعرف المرجعي (فاتورة، سند تحويل، قيد)
  String? get referenceId => throw _privateConstructorUsedError;

  /// وصف الحركة
  String? get description => throw _privateConstructorUsedError;

  /// معرف المستخدم الذي قام بالحركة
  String? get userId => throw _privateConstructorUsedError;

  /// حالة المزامنة
  SyncStatus get syncStatus => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StockMovementCopyWith<StockMovement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockMovementCopyWith<$Res> {
  factory $StockMovementCopyWith(
          StockMovement value, $Res Function(StockMovement) then) =
      _$StockMovementCopyWithImpl<$Res, StockMovement>;
  @useResult
  $Res call(
      {String id,
      String itemId,
      String warehouseId,
      StockMovementType type,
      double quantity,
      double unitCost,
      DateTime date,
      DateTime createdAt,
      String? referenceId,
      String? description,
      String? userId,
      SyncStatus syncStatus});
}

/// @nodoc
class _$StockMovementCopyWithImpl<$Res, $Val extends StockMovement>
    implements $StockMovementCopyWith<$Res> {
  _$StockMovementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemId = null,
    Object? warehouseId = null,
    Object? type = null,
    Object? quantity = null,
    Object? unitCost = null,
    Object? date = null,
    Object? createdAt = null,
    Object? referenceId = freezed,
    Object? description = freezed,
    Object? userId = freezed,
    Object? syncStatus = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      warehouseId: null == warehouseId
          ? _value.warehouseId
          : warehouseId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as StockMovementType,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unitCost: null == unitCost
          ? _value.unitCost
          : unitCost // ignore: cast_nullable_to_non_nullable
              as double,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      referenceId: freezed == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StockMovementImplCopyWith<$Res>
    implements $StockMovementCopyWith<$Res> {
  factory _$$StockMovementImplCopyWith(
          _$StockMovementImpl value, $Res Function(_$StockMovementImpl) then) =
      __$$StockMovementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String itemId,
      String warehouseId,
      StockMovementType type,
      double quantity,
      double unitCost,
      DateTime date,
      DateTime createdAt,
      String? referenceId,
      String? description,
      String? userId,
      SyncStatus syncStatus});
}

/// @nodoc
class __$$StockMovementImplCopyWithImpl<$Res>
    extends _$StockMovementCopyWithImpl<$Res, _$StockMovementImpl>
    implements _$$StockMovementImplCopyWith<$Res> {
  __$$StockMovementImplCopyWithImpl(
      _$StockMovementImpl _value, $Res Function(_$StockMovementImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemId = null,
    Object? warehouseId = null,
    Object? type = null,
    Object? quantity = null,
    Object? unitCost = null,
    Object? date = null,
    Object? createdAt = null,
    Object? referenceId = freezed,
    Object? description = freezed,
    Object? userId = freezed,
    Object? syncStatus = null,
  }) {
    return _then(_$StockMovementImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      warehouseId: null == warehouseId
          ? _value.warehouseId
          : warehouseId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as StockMovementType,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unitCost: null == unitCost
          ? _value.unitCost
          : unitCost // ignore: cast_nullable_to_non_nullable
              as double,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      referenceId: freezed == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockMovementImpl implements _StockMovement {
  const _$StockMovementImpl(
      {required this.id,
      required this.itemId,
      required this.warehouseId,
      required this.type,
      required this.quantity,
      required this.unitCost,
      required this.date,
      required this.createdAt,
      this.referenceId,
      this.description,
      this.userId,
      this.syncStatus = SyncStatus.synced});

  factory _$StockMovementImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockMovementImplFromJson(json);

  /// المعرف الفريد
  @override
  final String id;

  /// معرف الصنف
  @override
  final String itemId;

  /// معرف المستودع
  @override
  final String warehouseId;

  /// نوع الحركة
  @override
  final StockMovementType type;

  /// الكمية (تكون موجبة دائماً، والنوع يحدد الاتجاه)
  @override
  final double quantity;

  /// تكلفة الوحدة عند الحركة (للتقييم)
  @override
  final double unitCost;

  /// تاريخ الحركة
  @override
  final DateTime date;

  /// تاريخ الإنشاء
  @override
  final DateTime createdAt;

  /// المعرف المرجعي (فاتورة، سند تحويل، قيد)
  @override
  final String? referenceId;

  /// وصف الحركة
  @override
  final String? description;

  /// معرف المستخدم الذي قام بالحركة
  @override
  final String? userId;

  /// حالة المزامنة
  @override
  @JsonKey()
  final SyncStatus syncStatus;

  @override
  String toString() {
    return 'StockMovement(id: $id, itemId: $itemId, warehouseId: $warehouseId, type: $type, quantity: $quantity, unitCost: $unitCost, date: $date, createdAt: $createdAt, referenceId: $referenceId, description: $description, userId: $userId, syncStatus: $syncStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockMovementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.warehouseId, warehouseId) ||
                other.warehouseId == warehouseId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitCost, unitCost) ||
                other.unitCost == unitCost) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.referenceId, referenceId) ||
                other.referenceId == referenceId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      itemId,
      warehouseId,
      type,
      quantity,
      unitCost,
      date,
      createdAt,
      referenceId,
      description,
      userId,
      syncStatus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StockMovementImplCopyWith<_$StockMovementImpl> get copyWith =>
      __$$StockMovementImplCopyWithImpl<_$StockMovementImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockMovementImplToJson(
      this,
    );
  }
}

abstract class _StockMovement implements StockMovement {
  const factory _StockMovement(
      {required final String id,
      required final String itemId,
      required final String warehouseId,
      required final StockMovementType type,
      required final double quantity,
      required final double unitCost,
      required final DateTime date,
      required final DateTime createdAt,
      final String? referenceId,
      final String? description,
      final String? userId,
      final SyncStatus syncStatus}) = _$StockMovementImpl;

  factory _StockMovement.fromJson(Map<String, dynamic> json) =
      _$StockMovementImpl.fromJson;

  @override

  /// المعرف الفريد
  String get id;
  @override

  /// معرف الصنف
  String get itemId;
  @override

  /// معرف المستودع
  String get warehouseId;
  @override

  /// نوع الحركة
  StockMovementType get type;
  @override

  /// الكمية (تكون موجبة دائماً، والنوع يحدد الاتجاه)
  double get quantity;
  @override

  /// تكلفة الوحدة عند الحركة (للتقييم)
  double get unitCost;
  @override

  /// تاريخ الحركة
  DateTime get date;
  @override

  /// تاريخ الإنشاء
  DateTime get createdAt;
  @override

  /// المعرف المرجعي (فاتورة، سند تحويل، قيد)
  String? get referenceId;
  @override

  /// وصف الحركة
  String? get description;
  @override

  /// معرف المستخدم الذي قام بالحركة
  String? get userId;
  @override

  /// حالة المزامنة
  SyncStatus get syncStatus;
  @override
  @JsonKey(ignore: true)
  _$$StockMovementImplCopyWith<_$StockMovementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
