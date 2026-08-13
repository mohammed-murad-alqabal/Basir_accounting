// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Vendor _$VendorFromJson(Map<String, dynamic> json) {
  return _Vendor.fromJson(json);
}

/// @nodoc
mixin _$Vendor {
  /// معرف فريد للمورد
  String get id => throw _privateConstructorUsedError;

  /// اسم المورد بالعربية
  String get nameAr => throw _privateConstructorUsedError;

  /// اسم المورد بالإنجليزية
  String get nameEn => throw _privateConstructorUsedError;

  /// تاريخ إنشاء المورد
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// تاريخ آخر تحديث للمورد
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// رقم هاتف المورد (اختياري)
  String? get phone => throw _privateConstructorUsedError;

  /// البريد الإلكتروني للمورد (اختياري)
  String? get email => throw _privateConstructorUsedError;

  /// عنوان المورد (اختياري)
  String? get address => throw _privateConstructorUsedError;

  /// ملاحظات عن المورد (اختياري)
  String? get notes => throw _privateConstructorUsedError;

  /// معرف حساب المورد في دليل الحسابات (AP Account)
  String? get payableAccountId => throw _privateConstructorUsedError;

  /// رقم التسجيل الضريبي (VAT Number)
  String? get vatNumber => throw _privateConstructorUsedError;

  /// رقم السجل التجاري (Commercial Registration Number)
  String? get registrationNumber => throw _privateConstructorUsedError;

  /// الرصيد الحالي للمورد
  double get balance => throw _privateConstructorUsedError;

  /// معرف المستخدم صاحب المورد (لعزل البيانات)
  String? get userId => throw _privateConstructorUsedError;

  /// حالة المزامنة
  SyncStatus get syncStatus => throw _privateConstructorUsedError;

  /// تاريخ آخر تحديث من السيرفر
  DateTime? get serverUpdatedAt => throw _privateConstructorUsedError;

  /// هل السجل محذوف (حذف ناعم)
  bool get isDeleted => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VendorCopyWith<Vendor> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VendorCopyWith<$Res> {
  factory $VendorCopyWith(Vendor value, $Res Function(Vendor) then) =
      _$VendorCopyWithImpl<$Res, Vendor>;
  @useResult
  $Res call(
      {String id,
      String nameAr,
      String nameEn,
      DateTime createdAt,
      DateTime updatedAt,
      String? phone,
      String? email,
      String? address,
      String? notes,
      String? payableAccountId,
      String? vatNumber,
      String? registrationNumber,
      double balance,
      String? userId,
      SyncStatus syncStatus,
      DateTime? serverUpdatedAt,
      bool isDeleted});
}

/// @nodoc
class _$VendorCopyWithImpl<$Res, $Val extends Vendor>
    implements $VendorCopyWith<$Res> {
  _$VendorCopyWithImpl(this._value, this._then);

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
    Object? phone = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? notes = freezed,
    Object? payableAccountId = freezed,
    Object? vatNumber = freezed,
    Object? registrationNumber = freezed,
    Object? balance = null,
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
      payableAccountId: freezed == payableAccountId
          ? _value.payableAccountId
          : payableAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      vatNumber: freezed == vatNumber
          ? _value.vatNumber
          : vatNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      registrationNumber: freezed == registrationNumber
          ? _value.registrationNumber
          : registrationNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
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
abstract class _$$VendorImplCopyWith<$Res> implements $VendorCopyWith<$Res> {
  factory _$$VendorImplCopyWith(
          _$VendorImpl value, $Res Function(_$VendorImpl) then) =
      __$$VendorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String nameAr,
      String nameEn,
      DateTime createdAt,
      DateTime updatedAt,
      String? phone,
      String? email,
      String? address,
      String? notes,
      String? payableAccountId,
      String? vatNumber,
      String? registrationNumber,
      double balance,
      String? userId,
      SyncStatus syncStatus,
      DateTime? serverUpdatedAt,
      bool isDeleted});
}

/// @nodoc
class __$$VendorImplCopyWithImpl<$Res>
    extends _$VendorCopyWithImpl<$Res, _$VendorImpl>
    implements _$$VendorImplCopyWith<$Res> {
  __$$VendorImplCopyWithImpl(
      _$VendorImpl _value, $Res Function(_$VendorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? notes = freezed,
    Object? payableAccountId = freezed,
    Object? vatNumber = freezed,
    Object? registrationNumber = freezed,
    Object? balance = null,
    Object? userId = freezed,
    Object? syncStatus = null,
    Object? serverUpdatedAt = freezed,
    Object? isDeleted = null,
  }) {
    return _then(_$VendorImpl(
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
      payableAccountId: freezed == payableAccountId
          ? _value.payableAccountId
          : payableAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      vatNumber: freezed == vatNumber
          ? _value.vatNumber
          : vatNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      registrationNumber: freezed == registrationNumber
          ? _value.registrationNumber
          : registrationNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
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
class _$VendorImpl extends _Vendor {
  const _$VendorImpl(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      required this.createdAt,
      required this.updatedAt,
      this.phone,
      this.email,
      this.address,
      this.notes,
      this.payableAccountId,
      this.vatNumber,
      this.registrationNumber,
      this.balance = 0.0,
      this.userId,
      this.syncStatus = SyncStatus.synced,
      this.serverUpdatedAt,
      this.isDeleted = false})
      : super._();

  factory _$VendorImpl.fromJson(Map<String, dynamic> json) =>
      _$$VendorImplFromJson(json);

  /// معرف فريد للمورد
  @override
  final String id;

  /// اسم المورد بالعربية
  @override
  final String nameAr;

  /// اسم المورد بالإنجليزية
  @override
  final String nameEn;

  /// تاريخ إنشاء المورد
  @override
  final DateTime createdAt;

  /// تاريخ آخر تحديث للمورد
  @override
  final DateTime updatedAt;

  /// رقم هاتف المورد (اختياري)
  @override
  final String? phone;

  /// البريد الإلكتروني للمورد (اختياري)
  @override
  final String? email;

  /// عنوان المورد (اختياري)
  @override
  final String? address;

  /// ملاحظات عن المورد (اختياري)
  @override
  final String? notes;

  /// معرف حساب المورد في دليل الحسابات (AP Account)
  @override
  final String? payableAccountId;

  /// رقم التسجيل الضريبي (VAT Number)
  @override
  final String? vatNumber;

  /// رقم السجل التجاري (Commercial Registration Number)
  @override
  final String? registrationNumber;

  /// الرصيد الحالي للمورد
  @override
  @JsonKey()
  final double balance;

  /// معرف المستخدم صاحب المورد (لعزل البيانات)
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
    return 'Vendor(id: $id, nameAr: $nameAr, nameEn: $nameEn, createdAt: $createdAt, updatedAt: $updatedAt, phone: $phone, email: $email, address: $address, notes: $notes, payableAccountId: $payableAccountId, vatNumber: $vatNumber, registrationNumber: $registrationNumber, balance: $balance, userId: $userId, syncStatus: $syncStatus, serverUpdatedAt: $serverUpdatedAt, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VendorImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.payableAccountId, payableAccountId) ||
                other.payableAccountId == payableAccountId) &&
            (identical(other.vatNumber, vatNumber) ||
                other.vatNumber == vatNumber) &&
            (identical(other.registrationNumber, registrationNumber) ||
                other.registrationNumber == registrationNumber) &&
            (identical(other.balance, balance) || other.balance == balance) &&
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
      phone,
      email,
      address,
      notes,
      payableAccountId,
      vatNumber,
      registrationNumber,
      balance,
      userId,
      syncStatus,
      serverUpdatedAt,
      isDeleted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VendorImplCopyWith<_$VendorImpl> get copyWith =>
      __$$VendorImplCopyWithImpl<_$VendorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VendorImplToJson(
      this,
    );
  }
}

abstract class _Vendor extends Vendor {
  const factory _Vendor(
      {required final String id,
      required final String nameAr,
      required final String nameEn,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String? phone,
      final String? email,
      final String? address,
      final String? notes,
      final String? payableAccountId,
      final String? vatNumber,
      final String? registrationNumber,
      final double balance,
      final String? userId,
      final SyncStatus syncStatus,
      final DateTime? serverUpdatedAt,
      final bool isDeleted}) = _$VendorImpl;
  const _Vendor._() : super._();

  factory _Vendor.fromJson(Map<String, dynamic> json) = _$VendorImpl.fromJson;

  @override

  /// معرف فريد للمورد
  String get id;
  @override

  /// اسم المورد بالعربية
  String get nameAr;
  @override

  /// اسم المورد بالإنجليزية
  String get nameEn;
  @override

  /// تاريخ إنشاء المورد
  DateTime get createdAt;
  @override

  /// تاريخ آخر تحديث للمورد
  DateTime get updatedAt;
  @override

  /// رقم هاتف المورد (اختياري)
  String? get phone;
  @override

  /// البريد الإلكتروني للمورد (اختياري)
  String? get email;
  @override

  /// عنوان المورد (اختياري)
  String? get address;
  @override

  /// ملاحظات عن المورد (اختياري)
  String? get notes;
  @override

  /// معرف حساب المورد في دليل الحسابات (AP Account)
  String? get payableAccountId;
  @override

  /// رقم التسجيل الضريبي (VAT Number)
  String? get vatNumber;
  @override

  /// رقم السجل التجاري (Commercial Registration Number)
  String? get registrationNumber;
  @override

  /// الرصيد الحالي للمورد
  double get balance;
  @override

  /// معرف المستخدم صاحب المورد (لعزل البيانات)
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
  _$$VendorImplCopyWith<_$VendorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
