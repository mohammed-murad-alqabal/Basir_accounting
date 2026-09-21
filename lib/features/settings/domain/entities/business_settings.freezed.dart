// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BusinessSettings _$BusinessSettingsFromJson(Map<String, dynamic> json) {
  return _BusinessSettings.fromJson(json);
}

/// @nodoc
mixin _$BusinessSettings {
  String get id => throw _privateConstructorUsedError;
  String get companyName => throw _privateConstructorUsedError;
  String? get taxNumber => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  double get defaultTaxRate => throw _privateConstructorUsedError;
  String get currencyCode => throw _privateConstructorUsedError;
  String get currencySymbol => throw _privateConstructorUsedError;

  /// معرف المستخدم لغرض عزل البيانات
  String? get userId => throw _privateConstructorUsedError;

  /// حالة المزامنة
  SyncStatus get syncStatus => throw _privateConstructorUsedError;

  /// تاريخ آخر تحديث من السيرفر
  DateTime? get serverUpdatedAt => throw _privateConstructorUsedError;

  /// هل السجل محذوف (حذف ناعم)
  bool get isDeleted => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BusinessSettingsCopyWith<BusinessSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessSettingsCopyWith<$Res> {
  factory $BusinessSettingsCopyWith(
          BusinessSettings value, $Res Function(BusinessSettings) then) =
      _$BusinessSettingsCopyWithImpl<$Res, BusinessSettings>;
  @useResult
  $Res call(
      {String id,
      String companyName,
      String? taxNumber,
      String? address,
      String? logoUrl,
      double defaultTaxRate,
      String currencyCode,
      String currencySymbol,
      String? userId,
      SyncStatus syncStatus,
      DateTime? serverUpdatedAt,
      bool isDeleted});
}

/// @nodoc
class _$BusinessSettingsCopyWithImpl<$Res, $Val extends BusinessSettings>
    implements $BusinessSettingsCopyWith<$Res> {
  _$BusinessSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyName = null,
    Object? taxNumber = freezed,
    Object? address = freezed,
    Object? logoUrl = freezed,
    Object? defaultTaxRate = null,
    Object? currencyCode = null,
    Object? currencySymbol = null,
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
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      taxNumber: freezed == taxNumber
          ? _value.taxNumber
          : taxNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultTaxRate: null == defaultTaxRate
          ? _value.defaultTaxRate
          : defaultTaxRate // ignore: cast_nullable_to_non_nullable
              as double,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$BusinessSettingsImplCopyWith<$Res>
    implements $BusinessSettingsCopyWith<$Res> {
  factory _$$BusinessSettingsImplCopyWith(_$BusinessSettingsImpl value,
          $Res Function(_$BusinessSettingsImpl) then) =
      __$$BusinessSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String companyName,
      String? taxNumber,
      String? address,
      String? logoUrl,
      double defaultTaxRate,
      String currencyCode,
      String currencySymbol,
      String? userId,
      SyncStatus syncStatus,
      DateTime? serverUpdatedAt,
      bool isDeleted});
}

/// @nodoc
class __$$BusinessSettingsImplCopyWithImpl<$Res>
    extends _$BusinessSettingsCopyWithImpl<$Res, _$BusinessSettingsImpl>
    implements _$$BusinessSettingsImplCopyWith<$Res> {
  __$$BusinessSettingsImplCopyWithImpl(_$BusinessSettingsImpl _value,
      $Res Function(_$BusinessSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyName = null,
    Object? taxNumber = freezed,
    Object? address = freezed,
    Object? logoUrl = freezed,
    Object? defaultTaxRate = null,
    Object? currencyCode = null,
    Object? currencySymbol = null,
    Object? userId = freezed,
    Object? syncStatus = null,
    Object? serverUpdatedAt = freezed,
    Object? isDeleted = null,
  }) {
    return _then(_$BusinessSettingsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      taxNumber: freezed == taxNumber
          ? _value.taxNumber
          : taxNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultTaxRate: null == defaultTaxRate
          ? _value.defaultTaxRate
          : defaultTaxRate // ignore: cast_nullable_to_non_nullable
              as double,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
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
class _$BusinessSettingsImpl implements _BusinessSettings {
  const _$BusinessSettingsImpl(
      {required this.id,
      required this.companyName,
      this.taxNumber,
      this.address,
      this.logoUrl,
      this.defaultTaxRate = 15.0,
      this.currencyCode = 'SAR',
      this.currencySymbol = 'ر.س',
      this.userId,
      this.syncStatus = SyncStatus.synced,
      this.serverUpdatedAt,
      this.isDeleted = false});

  factory _$BusinessSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusinessSettingsImplFromJson(json);

  @override
  final String id;
  @override
  final String companyName;
  @override
  final String? taxNumber;
  @override
  final String? address;
  @override
  final String? logoUrl;
  @override
  @JsonKey()
  final double defaultTaxRate;
  @override
  @JsonKey()
  final String currencyCode;
  @override
  @JsonKey()
  final String currencySymbol;

  /// معرف المستخدم لغرض عزل البيانات
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
    return 'BusinessSettings(id: $id, companyName: $companyName, taxNumber: $taxNumber, address: $address, logoUrl: $logoUrl, defaultTaxRate: $defaultTaxRate, currencyCode: $currencyCode, currencySymbol: $currencySymbol, userId: $userId, syncStatus: $syncStatus, serverUpdatedAt: $serverUpdatedAt, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessSettingsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.taxNumber, taxNumber) ||
                other.taxNumber == taxNumber) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.defaultTaxRate, defaultTaxRate) ||
                other.defaultTaxRate == defaultTaxRate) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol) &&
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
      companyName,
      taxNumber,
      address,
      logoUrl,
      defaultTaxRate,
      currencyCode,
      currencySymbol,
      userId,
      syncStatus,
      serverUpdatedAt,
      isDeleted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessSettingsImplCopyWith<_$BusinessSettingsImpl> get copyWith =>
      __$$BusinessSettingsImplCopyWithImpl<_$BusinessSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BusinessSettingsImplToJson(
      this,
    );
  }
}

abstract class _BusinessSettings implements BusinessSettings {
  const factory _BusinessSettings(
      {required final String id,
      required final String companyName,
      final String? taxNumber,
      final String? address,
      final String? logoUrl,
      final double defaultTaxRate,
      final String currencyCode,
      final String currencySymbol,
      final String? userId,
      final SyncStatus syncStatus,
      final DateTime? serverUpdatedAt,
      final bool isDeleted}) = _$BusinessSettingsImpl;

  factory _BusinessSettings.fromJson(Map<String, dynamic> json) =
      _$BusinessSettingsImpl.fromJson;

  @override
  String get id;
  @override
  String get companyName;
  @override
  String? get taxNumber;
  @override
  String? get address;
  @override
  String? get logoUrl;
  @override
  double get defaultTaxRate;
  @override
  String get currencyCode;
  @override
  String get currencySymbol;
  @override

  /// معرف المستخدم لغرض عزل البيانات
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
  _$$BusinessSettingsImplCopyWith<_$BusinessSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
