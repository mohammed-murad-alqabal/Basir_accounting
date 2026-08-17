// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'warehouse_transfer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransferItem _$TransferItemFromJson(Map<String, dynamic> json) {
  return _TransferItem.fromJson(json);
}

/// @nodoc
mixin _$TransferItem {
  /// معرف الصنف
  String get itemId => throw _privateConstructorUsedError;

  /// اسم الصنف
  String get itemName => throw _privateConstructorUsedError;

  /// الكمية
  double get quantity => throw _privateConstructorUsedError;

  /// الوحدة (اختياري)
  String? get unit => throw _privateConstructorUsedError;

  /// ملاحظة (اختياري)
  String? get note => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransferItemCopyWith<TransferItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferItemCopyWith<$Res> {
  factory $TransferItemCopyWith(
          TransferItem value, $Res Function(TransferItem) then) =
      _$TransferItemCopyWithImpl<$Res, TransferItem>;
  @useResult
  $Res call(
      {String itemId,
      String itemName,
      double quantity,
      String? unit,
      String? note});
}

/// @nodoc
class _$TransferItemCopyWithImpl<$Res, $Val extends TransferItem>
    implements $TransferItemCopyWith<$Res> {
  _$TransferItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? itemName = null,
    Object? quantity = null,
    Object? unit = freezed,
    Object? note = freezed,
  }) {
    return _then(_value.copyWith(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransferItemImplCopyWith<$Res>
    implements $TransferItemCopyWith<$Res> {
  factory _$$TransferItemImplCopyWith(
          _$TransferItemImpl value, $Res Function(_$TransferItemImpl) then) =
      __$$TransferItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String itemId,
      String itemName,
      double quantity,
      String? unit,
      String? note});
}

/// @nodoc
class __$$TransferItemImplCopyWithImpl<$Res>
    extends _$TransferItemCopyWithImpl<$Res, _$TransferItemImpl>
    implements _$$TransferItemImplCopyWith<$Res> {
  __$$TransferItemImplCopyWithImpl(
      _$TransferItemImpl _value, $Res Function(_$TransferItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? itemName = null,
    Object? quantity = null,
    Object? unit = freezed,
    Object? note = freezed,
  }) {
    return _then(_$TransferItemImpl(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferItemImpl implements _TransferItem {
  const _$TransferItemImpl(
      {required this.itemId,
      required this.itemName,
      required this.quantity,
      this.unit,
      this.note});

  factory _$TransferItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferItemImplFromJson(json);

  /// معرف الصنف
  @override
  final String itemId;

  /// اسم الصنف
  @override
  final String itemName;

  /// الكمية
  @override
  final double quantity;

  /// الوحدة (اختياري)
  @override
  final String? unit;

  /// ملاحظة (اختياري)
  @override
  final String? note;

  @override
  String toString() {
    return 'TransferItem(itemId: $itemId, itemName: $itemName, quantity: $quantity, unit: $unit, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferItemImpl &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, itemId, itemName, quantity, unit, note);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferItemImplCopyWith<_$TransferItemImpl> get copyWith =>
      __$$TransferItemImplCopyWithImpl<_$TransferItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferItemImplToJson(
      this,
    );
  }
}

abstract class _TransferItem implements TransferItem {
  const factory _TransferItem(
      {required final String itemId,
      required final String itemName,
      required final double quantity,
      final String? unit,
      final String? note}) = _$TransferItemImpl;

  factory _TransferItem.fromJson(Map<String, dynamic> json) =
      _$TransferItemImpl.fromJson;

  @override

  /// معرف الصنف
  String get itemId;
  @override

  /// اسم الصنف
  String get itemName;
  @override

  /// الكمية
  double get quantity;
  @override

  /// الوحدة (اختياري)
  String? get unit;
  @override

  /// ملاحظة (اختياري)
  String? get note;
  @override
  @JsonKey(ignore: true)
  _$$TransferItemImplCopyWith<_$TransferItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WarehouseTransfer _$WarehouseTransferFromJson(Map<String, dynamic> json) {
  return _WarehouseTransfer.fromJson(json);
}

/// @nodoc
mixin _$WarehouseTransfer {
  /// المعرف الفريد
  String get id => throw _privateConstructorUsedError;

  /// رقم أمر التحويل
  String get transferNumber => throw _privateConstructorUsedError;

  /// مستودع المصدر
  String get sourceWarehouseId => throw _privateConstructorUsedError;

  /// مستودع الوجهة
  String get destinationWarehouseId => throw _privateConstructorUsedError;

  /// تاريخ التحويل
  DateTime get date => throw _privateConstructorUsedError;

  /// قائمة الأصناف المحولة
  List<TransferItem> get items => throw _privateConstructorUsedError;

  /// تاريخ الإنشاء
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// تاريخ التحديث
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// حالة التحويل
  TransferStatus get status => throw _privateConstructorUsedError;

  /// ملاحظات
  String? get remarks => throw _privateConstructorUsedError;

  /// معرف المستخدم
  String? get userId => throw _privateConstructorUsedError;

  /// حالة المزامنة
  SyncStatus get syncStatus => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WarehouseTransferCopyWith<WarehouseTransfer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WarehouseTransferCopyWith<$Res> {
  factory $WarehouseTransferCopyWith(
          WarehouseTransfer value, $Res Function(WarehouseTransfer) then) =
      _$WarehouseTransferCopyWithImpl<$Res, WarehouseTransfer>;
  @useResult
  $Res call(
      {String id,
      String transferNumber,
      String sourceWarehouseId,
      String destinationWarehouseId,
      DateTime date,
      List<TransferItem> items,
      DateTime createdAt,
      DateTime updatedAt,
      TransferStatus status,
      String? remarks,
      String? userId,
      SyncStatus syncStatus});
}

/// @nodoc
class _$WarehouseTransferCopyWithImpl<$Res, $Val extends WarehouseTransfer>
    implements $WarehouseTransferCopyWith<$Res> {
  _$WarehouseTransferCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? transferNumber = null,
    Object? sourceWarehouseId = null,
    Object? destinationWarehouseId = null,
    Object? date = null,
    Object? items = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? status = null,
    Object? remarks = freezed,
    Object? userId = freezed,
    Object? syncStatus = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      transferNumber: null == transferNumber
          ? _value.transferNumber
          : transferNumber // ignore: cast_nullable_to_non_nullable
              as String,
      sourceWarehouseId: null == sourceWarehouseId
          ? _value.sourceWarehouseId
          : sourceWarehouseId // ignore: cast_nullable_to_non_nullable
              as String,
      destinationWarehouseId: null == destinationWarehouseId
          ? _value.destinationWarehouseId
          : destinationWarehouseId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TransferItem>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TransferStatus,
      remarks: freezed == remarks
          ? _value.remarks
          : remarks // ignore: cast_nullable_to_non_nullable
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
abstract class _$$WarehouseTransferImplCopyWith<$Res>
    implements $WarehouseTransferCopyWith<$Res> {
  factory _$$WarehouseTransferImplCopyWith(_$WarehouseTransferImpl value,
          $Res Function(_$WarehouseTransferImpl) then) =
      __$$WarehouseTransferImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String transferNumber,
      String sourceWarehouseId,
      String destinationWarehouseId,
      DateTime date,
      List<TransferItem> items,
      DateTime createdAt,
      DateTime updatedAt,
      TransferStatus status,
      String? remarks,
      String? userId,
      SyncStatus syncStatus});
}

/// @nodoc
class __$$WarehouseTransferImplCopyWithImpl<$Res>
    extends _$WarehouseTransferCopyWithImpl<$Res, _$WarehouseTransferImpl>
    implements _$$WarehouseTransferImplCopyWith<$Res> {
  __$$WarehouseTransferImplCopyWithImpl(_$WarehouseTransferImpl _value,
      $Res Function(_$WarehouseTransferImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? transferNumber = null,
    Object? sourceWarehouseId = null,
    Object? destinationWarehouseId = null,
    Object? date = null,
    Object? items = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? status = null,
    Object? remarks = freezed,
    Object? userId = freezed,
    Object? syncStatus = null,
  }) {
    return _then(_$WarehouseTransferImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      transferNumber: null == transferNumber
          ? _value.transferNumber
          : transferNumber // ignore: cast_nullable_to_non_nullable
              as String,
      sourceWarehouseId: null == sourceWarehouseId
          ? _value.sourceWarehouseId
          : sourceWarehouseId // ignore: cast_nullable_to_non_nullable
              as String,
      destinationWarehouseId: null == destinationWarehouseId
          ? _value.destinationWarehouseId
          : destinationWarehouseId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TransferItem>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TransferStatus,
      remarks: freezed == remarks
          ? _value.remarks
          : remarks // ignore: cast_nullable_to_non_nullable
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
class _$WarehouseTransferImpl implements _WarehouseTransfer {
  const _$WarehouseTransferImpl(
      {required this.id,
      required this.transferNumber,
      required this.sourceWarehouseId,
      required this.destinationWarehouseId,
      required this.date,
      required final List<TransferItem> items,
      required this.createdAt,
      required this.updatedAt,
      this.status = TransferStatus.completed,
      this.remarks,
      this.userId,
      this.syncStatus = SyncStatus.synced})
      : _items = items;

  factory _$WarehouseTransferImpl.fromJson(Map<String, dynamic> json) =>
      _$$WarehouseTransferImplFromJson(json);

  /// المعرف الفريد
  @override
  final String id;

  /// رقم أمر التحويل
  @override
  final String transferNumber;

  /// مستودع المصدر
  @override
  final String sourceWarehouseId;

  /// مستودع الوجهة
  @override
  final String destinationWarehouseId;

  /// تاريخ التحويل
  @override
  final DateTime date;

  /// قائمة الأصناف المحولة
  final List<TransferItem> _items;

  /// قائمة الأصناف المحولة
  @override
  List<TransferItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// تاريخ الإنشاء
  @override
  final DateTime createdAt;

  /// تاريخ التحديث
  @override
  final DateTime updatedAt;

  /// حالة التحويل
  @override
  @JsonKey()
  final TransferStatus status;

  /// ملاحظات
  @override
  final String? remarks;

  /// معرف المستخدم
  @override
  final String? userId;

  /// حالة المزامنة
  @override
  @JsonKey()
  final SyncStatus syncStatus;

  @override
  String toString() {
    return 'WarehouseTransfer(id: $id, transferNumber: $transferNumber, sourceWarehouseId: $sourceWarehouseId, destinationWarehouseId: $destinationWarehouseId, date: $date, items: $items, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, remarks: $remarks, userId: $userId, syncStatus: $syncStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WarehouseTransferImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.transferNumber, transferNumber) ||
                other.transferNumber == transferNumber) &&
            (identical(other.sourceWarehouseId, sourceWarehouseId) ||
                other.sourceWarehouseId == sourceWarehouseId) &&
            (identical(other.destinationWarehouseId, destinationWarehouseId) ||
                other.destinationWarehouseId == destinationWarehouseId) &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.remarks, remarks) || other.remarks == remarks) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      transferNumber,
      sourceWarehouseId,
      destinationWarehouseId,
      date,
      const DeepCollectionEquality().hash(_items),
      createdAt,
      updatedAt,
      status,
      remarks,
      userId,
      syncStatus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WarehouseTransferImplCopyWith<_$WarehouseTransferImpl> get copyWith =>
      __$$WarehouseTransferImplCopyWithImpl<_$WarehouseTransferImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WarehouseTransferImplToJson(
      this,
    );
  }
}

abstract class _WarehouseTransfer implements WarehouseTransfer {
  const factory _WarehouseTransfer(
      {required final String id,
      required final String transferNumber,
      required final String sourceWarehouseId,
      required final String destinationWarehouseId,
      required final DateTime date,
      required final List<TransferItem> items,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final TransferStatus status,
      final String? remarks,
      final String? userId,
      final SyncStatus syncStatus}) = _$WarehouseTransferImpl;

  factory _WarehouseTransfer.fromJson(Map<String, dynamic> json) =
      _$WarehouseTransferImpl.fromJson;

  @override

  /// المعرف الفريد
  String get id;
  @override

  /// رقم أمر التحويل
  String get transferNumber;
  @override

  /// مستودع المصدر
  String get sourceWarehouseId;
  @override

  /// مستودع الوجهة
  String get destinationWarehouseId;
  @override

  /// تاريخ التحويل
  DateTime get date;
  @override

  /// قائمة الأصناف المحولة
  List<TransferItem> get items;
  @override

  /// تاريخ الإنشاء
  DateTime get createdAt;
  @override

  /// تاريخ التحديث
  DateTime get updatedAt;
  @override

  /// حالة التحويل
  TransferStatus get status;
  @override

  /// ملاحظات
  String? get remarks;
  @override

  /// معرف المستخدم
  String? get userId;
  @override

  /// حالة المزامنة
  SyncStatus get syncStatus;
  @override
  @JsonKey(ignore: true)
  _$$WarehouseTransferImplCopyWith<_$WarehouseTransferImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
