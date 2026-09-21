// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return _Customer.fromJson(json);
}

/// @nodoc
mixin _$Customer {
  /// معرف فريد للعميل
  String get id => throw _privateConstructorUsedError;

  /// اسم العميل بالعربية
  String get nameAr => throw _privateConstructorUsedError;

  /// اسم العميل بالإنجليزية
  String get nameEn => throw _privateConstructorUsedError;

  /// تاريخ إنشاء العميل
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// تاريخ آخر تحديث للعميل
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// الرقم الضريبي (مطلوب للفواتير الضريبية)
  String? get taxNumber => throw _privateConstructorUsedError;

  /// رقم هاتف العميل (اختياري)
  String? get phone => throw _privateConstructorUsedError;

  /// البريد الإلكتروني للعميل (اختياري)
  String? get email => throw _privateConstructorUsedError;

  /// عنوان العميل (اختياري)
  String? get address => throw _privateConstructorUsedError;

  /// ملاحظات عن العميل (اختياري)
  String? get notes => throw _privateConstructorUsedError;

  /// سقف الرصيد (الائتمان) المسموح به
  double get creditLimit => throw _privateConstructorUsedError;

  /// الرصيد الحالي للعميل
  double get balance => throw _privateConstructorUsedError;

  /// معرف حساب العميل في دليل الحسابات (AR Account)
  String? get receivableAccountId => throw _privateConstructorUsedError;

  /// معرف المستخدم صاحب العميل (لعزل البيانات)
  String? get userId => throw _privateConstructorUsedError;

  /// حالة المزامنة
  SyncStatus get syncStatus => throw _privateConstructorUsedError;

  /// تاريخ آخر تحديث من السيرفر
  DateTime? get serverUpdatedAt => throw _privateConstructorUsedError;

  /// هل السجل محذوف (حذف ناعم)
  bool get isDeleted => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CustomerCopyWith<Customer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerCopyWith<$Res> {
  factory $CustomerCopyWith(Customer value, $Res Function(Customer) then) =
      _$CustomerCopyWithImpl<$Res, Customer>;
  @useResult
  $Res call(
      {String id,
      String nameAr,
      String nameEn,
      DateTime createdAt,
      DateTime updatedAt,
      String? taxNumber,
      String? phone,
      String? email,
      String? address,
      String? notes,
      double creditLimit,
      double balance,
      String? receivableAccountId,
      String? userId,
      SyncStatus syncStatus,
      DateTime? serverUpdatedAt,
      bool isDeleted});
}

/// @nodoc
class _$CustomerCopyWithImpl<$Res, $Val extends Customer>
    implements $CustomerCopyWith<$Res> {
  _$CustomerCopyWithImpl(this._value, this._then);

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
    Object? taxNumber = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? notes = freezed,
    Object? creditLimit = null,
    Object? balance = null,
    Object? receivableAccountId = freezed,
    Object? userId = freezed,
    Object? syncStatus = null,
    Object? serverUpdatedAt = freezed,
    Object? isDeleted = null,
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
      taxNumber: freezed == taxNumber
          ? _value.taxNumber
          : taxNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      creditLimit: null == creditLimit
          ? _value.creditLimit
          : creditLimit // ignore: cast_nullable_to_non_nullable
              as double,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      receivableAccountId: freezed == receivableAccountId
          ? _value.receivableAccountId
          : receivableAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CustomerImplCopyWith<$Res>
    implements $CustomerCopyWith<$Res> {
  factory _$$CustomerImplCopyWith(
          _$CustomerImpl value, $Res Function(_$CustomerImpl) then) =
      __$$CustomerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String nameAr,
      String nameEn,
      DateTime createdAt,
      DateTime updatedAt,
      String? taxNumber,
      String? phone,
      String? email,
      String? address,
      String? notes,
      double creditLimit,
      double balance,
      String? receivableAccountId,
      String? userId,
      SyncStatus syncStatus,
      DateTime? serverUpdatedAt,
      bool isDeleted});
}

/// @nodoc
class __$$CustomerImplCopyWithImpl<$Res>
    extends _$CustomerCopyWithImpl<$Res, _$CustomerImpl>
    implements _$$CustomerImplCopyWith<$Res> {
  __$$CustomerImplCopyWithImpl(
      _$CustomerImpl _value, $Res Function(_$CustomerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? taxNumber = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? notes = freezed,
    Object? creditLimit = null,
    Object? balance = null,
    Object? receivableAccountId = freezed,
    Object? userId = freezed,
    Object? syncStatus = null,
    Object? serverUpdatedAt = freezed,
    Object? isDeleted = null,
  }) {
    return _then(_$CustomerImpl(
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
      taxNumber: freezed == taxNumber
          ? _value.taxNumber
          : taxNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      creditLimit: null == creditLimit
          ? _value.creditLimit
          : creditLimit // ignore: cast_nullable_to_non_nullable
              as double,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      receivableAccountId: freezed == receivableAccountId
          ? _value.receivableAccountId
          : receivableAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerImpl extends _Customer {
  const _$CustomerImpl(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      required this.createdAt,
      required this.updatedAt,
      this.taxNumber,
      this.phone,
      this.email,
      this.address,
      this.notes,
      this.creditLimit = 0.0,
      this.balance = 0.0,
      this.receivableAccountId,
      this.userId,
      this.syncStatus = SyncStatus.synced,
      this.serverUpdatedAt,
      this.isDeleted = false})
      : super._();

  factory _$CustomerImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerImplFromJson(json);

  /// معرف فريد للعميل
  @override
  final String id;

  /// اسم العميل بالعربية
  @override
  final String nameAr;

  /// اسم العميل بالإنجليزية
  @override
  final String nameEn;

  /// تاريخ إنشاء العميل
  @override
  final DateTime createdAt;

  /// تاريخ آخر تحديث للعميل
  @override
  final DateTime updatedAt;

  /// الرقم الضريبي (مطلوب للفواتير الضريبية)
  @override
  final String? taxNumber;

  /// رقم هاتف العميل (اختياري)
  @override
  final String? phone;

  /// البريد الإلكتروني للعميل (اختياري)
  @override
  final String? email;

  /// عنوان العميل (اختياري)
  @override
  final String? address;

  /// ملاحظات عن العميل (اختياري)
  @override
  final String? notes;

  /// سقف الرصيد (الائتمان) المسموح به
  @override
  @JsonKey()
  final double creditLimit;

  /// الرصيد الحالي للعميل
  @override
  @JsonKey()
  final double balance;

  /// معرف حساب العميل في دليل الحسابات (AR Account)
  @override
  final String? receivableAccountId;

  /// معرف المستخدم صاحب العميل (لعزل البيانات)
  @override
  final String? userId;

  /// حالة المزامنة
  @override
  @JsonKey()
  final SyncStatus syncStatus;

  /// تاريخ آخر تحديث من السيرفر
  @override
  final DateTime? serverUpdatedAt;

  /// هل السجل محذوف (حذف ناعم)
  @override
  @JsonKey()
  final bool isDeleted;

  @override
  String toString() {
    return 'Customer(id: $id, nameAr: $nameAr, nameEn: $nameEn, createdAt: $createdAt, updatedAt: $updatedAt, taxNumber: $taxNumber, phone: $phone, email: $email, address: $address, notes: $notes, creditLimit: $creditLimit, balance: $balance, receivableAccountId: $receivableAccountId, userId: $userId, syncStatus: $syncStatus, serverUpdatedAt: $serverUpdatedAt, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.taxNumber, taxNumber) ||
                other.taxNumber == taxNumber) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.creditLimit, creditLimit) ||
                other.creditLimit == creditLimit) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.receivableAccountId, receivableAccountId) ||
                other.receivableAccountId == receivableAccountId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.serverUpdatedAt, serverUpdatedAt) ||
                other.serverUpdatedAt == serverUpdatedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      nameAr,
      nameEn,
      createdAt,
      updatedAt,
      taxNumber,
      phone,
      email,
      address,
      notes,
      creditLimit,
      balance,
      receivableAccountId,
      userId,
      syncStatus,
      serverUpdatedAt,
      isDeleted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerImplCopyWith<_$CustomerImpl> get copyWith =>
      __$$CustomerImplCopyWithImpl<_$CustomerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerImplToJson(
      this,
    );
  }
}

abstract class _Customer extends Customer {
  const factory _Customer(
      {required final String id,
      required final String nameAr,
      required final String nameEn,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String? taxNumber,
      final String? phone,
      final String? email,
      final String? address,
      final String? notes,
      final double creditLimit,
      final double balance,
      final String? receivableAccountId,
      final String? userId,
      final SyncStatus syncStatus,
      final DateTime? serverUpdatedAt,
      final bool isDeleted}) = _$CustomerImpl;
  const _Customer._() : super._();

  factory _Customer.fromJson(Map<String, dynamic> json) =
      _$CustomerImpl.fromJson;

  @override

  /// معرف فريد للعميل
  String get id;
  @override

  /// اسم العميل بالعربية
  String get nameAr;
  @override

  /// اسم العميل بالإنجليزية
  String get nameEn;
  @override

  /// تاريخ إنشاء العميل
  DateTime get createdAt;
  @override

  /// تاريخ آخر تحديث للعميل
  DateTime get updatedAt;
  @override

  /// الرقم الضريبي (مطلوب للفواتير الضريبية)
  String? get taxNumber;
  @override

  /// رقم هاتف العميل (اختياري)
  String? get phone;
  @override

  /// البريد الإلكتروني للعميل (اختياري)
  String? get email;
  @override

  /// عنوان العميل (اختياري)
  String? get address;
  @override

  /// ملاحظات عن العميل (اختياري)
  String? get notes;
  @override

  /// سقف الرصيد (الائتمان) المسموح به
  double get creditLimit;
  @override

  /// الرصيد الحالي للعميل
  double get balance;
  @override

  /// معرف حساب العميل في دليل الحسابات (AR Account)
  String? get receivableAccountId;
  @override

  /// معرف المستخدم صاحب العميل (لعزل البيانات)
  String? get userId;
  @override

  /// حالة المزامنة
  SyncStatus get syncStatus;
  @override

  /// تاريخ آخر تحديث من السيرفر
  DateTime? get serverUpdatedAt;
  @override

  /// هل السجل محذوف (حذف ناعم)
  bool get isDeleted;
  @override
  @JsonKey(ignore: true)
  _$$CustomerImplCopyWith<_$CustomerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
