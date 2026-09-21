// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fixed_asset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FixedAsset _$FixedAssetFromJson(Map<String, dynamic> json) {
  return _FixedAsset.fromJson(json);
}

/// @nodoc
mixin _$FixedAsset {
  /// كود الأصل (مثلاً: AST-001)
  String get code => throw _privateConstructorUsedError;

  /// الاسم بالعربية
  String get nameAr => throw _privateConstructorUsedError;

  /// الاسم بالإنجليزية
  String get nameEn => throw _privateConstructorUsedError;

  /// معرف الفئة
  String get categoryId => throw _privateConstructorUsedError;

  /// تاريخ الاستحواذ
  DateTime get acquisitionDate => throw _privateConstructorUsedError;

  /// التكلفة التاريخية
  double get cost => throw _privateConstructorUsedError;

  /// القيمة المتبقية (الخرداة)
  double get residualValue => throw _privateConstructorUsedError;

  /// العمر الإنتاجي بالسنوات
  int get usefulLifeYears => throw _privateConstructorUsedError;

  /// طريقة الإهلاك
  String get depreciationMethod => throw _privateConstructorUsedError;

  /// معرف حساب الأصل
  String get assetAccountId => throw _privateConstructorUsedError;

  /// معرف حساب مصروف الإهلاك
  String get depreciationAccountId => throw _privateConstructorUsedError;

  /// معرف حساب مجمع الإهلاك
  String get accumDepreciationAccountId => throw _privateConstructorUsedError;

  /// مجمع الإهلاك الحالي
  double get accumulatedDepreciation => throw _privateConstructorUsedError;

  /// معرف فريد للأصل
  String? get id => throw _privateConstructorUsedError;

  /// هل الأصل ما زال نشطاً (قيد الاستخدام)
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FixedAssetCopyWith<FixedAsset> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FixedAssetCopyWith<$Res> {
  factory $FixedAssetCopyWith(
          FixedAsset value, $Res Function(FixedAsset) then) =
      _$FixedAssetCopyWithImpl<$Res, FixedAsset>;
  @useResult
  $Res call(
      {String code,
      String nameAr,
      String nameEn,
      String categoryId,
      DateTime acquisitionDate,
      double cost,
      double residualValue,
      int usefulLifeYears,
      String depreciationMethod,
      String assetAccountId,
      String depreciationAccountId,
      String accumDepreciationAccountId,
      double accumulatedDepreciation,
      String? id,
      bool isActive});
}

/// @nodoc
class _$FixedAssetCopyWithImpl<$Res, $Val extends FixedAsset>
    implements $FixedAssetCopyWith<$Res> {
  _$FixedAssetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? categoryId = null,
    Object? acquisitionDate = null,
    Object? cost = null,
    Object? residualValue = null,
    Object? usefulLifeYears = null,
    Object? depreciationMethod = null,
    Object? assetAccountId = null,
    Object? depreciationAccountId = null,
    Object? accumDepreciationAccountId = null,
    Object? accumulatedDepreciation = null,
    Object? id = freezed,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      acquisitionDate: null == acquisitionDate
          ? _value.acquisitionDate
          : acquisitionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cost: null == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as double,
      residualValue: null == residualValue
          ? _value.residualValue
          : residualValue // ignore: cast_nullable_to_non_nullable
              as double,
      usefulLifeYears: null == usefulLifeYears
          ? _value.usefulLifeYears
          : usefulLifeYears // ignore: cast_nullable_to_non_nullable
              as int,
      depreciationMethod: null == depreciationMethod
          ? _value.depreciationMethod
          : depreciationMethod // ignore: cast_nullable_to_non_nullable
              as String,
      assetAccountId: null == assetAccountId
          ? _value.assetAccountId
          : assetAccountId // ignore: cast_nullable_to_non_nullable
              as String,
      depreciationAccountId: null == depreciationAccountId
          ? _value.depreciationAccountId
          : depreciationAccountId // ignore: cast_nullable_to_non_nullable
              as String,
      accumDepreciationAccountId: null == accumDepreciationAccountId
          ? _value.accumDepreciationAccountId
          : accumDepreciationAccountId // ignore: cast_nullable_to_non_nullable
              as String,
      accumulatedDepreciation: null == accumulatedDepreciation
          ? _value.accumulatedDepreciation
          : accumulatedDepreciation // ignore: cast_nullable_to_non_nullable
              as double,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FixedAssetImplCopyWith<$Res>
    implements $FixedAssetCopyWith<$Res> {
  factory _$$FixedAssetImplCopyWith(
          _$FixedAssetImpl value, $Res Function(_$FixedAssetImpl) then) =
      __$$FixedAssetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String code,
      String nameAr,
      String nameEn,
      String categoryId,
      DateTime acquisitionDate,
      double cost,
      double residualValue,
      int usefulLifeYears,
      String depreciationMethod,
      String assetAccountId,
      String depreciationAccountId,
      String accumDepreciationAccountId,
      double accumulatedDepreciation,
      String? id,
      bool isActive});
}

/// @nodoc
class __$$FixedAssetImplCopyWithImpl<$Res>
    extends _$FixedAssetCopyWithImpl<$Res, _$FixedAssetImpl>
    implements _$$FixedAssetImplCopyWith<$Res> {
  __$$FixedAssetImplCopyWithImpl(
      _$FixedAssetImpl _value, $Res Function(_$FixedAssetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? categoryId = null,
    Object? acquisitionDate = null,
    Object? cost = null,
    Object? residualValue = null,
    Object? usefulLifeYears = null,
    Object? depreciationMethod = null,
    Object? assetAccountId = null,
    Object? depreciationAccountId = null,
    Object? accumDepreciationAccountId = null,
    Object? accumulatedDepreciation = null,
    Object? id = freezed,
    Object? isActive = null,
  }) {
    return _then(_$FixedAssetImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      acquisitionDate: null == acquisitionDate
          ? _value.acquisitionDate
          : acquisitionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cost: null == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as double,
      residualValue: null == residualValue
          ? _value.residualValue
          : residualValue // ignore: cast_nullable_to_non_nullable
              as double,
      usefulLifeYears: null == usefulLifeYears
          ? _value.usefulLifeYears
          : usefulLifeYears // ignore: cast_nullable_to_non_nullable
              as int,
      depreciationMethod: null == depreciationMethod
          ? _value.depreciationMethod
          : depreciationMethod // ignore: cast_nullable_to_non_nullable
              as String,
      assetAccountId: null == assetAccountId
          ? _value.assetAccountId
          : assetAccountId // ignore: cast_nullable_to_non_nullable
              as String,
      depreciationAccountId: null == depreciationAccountId
          ? _value.depreciationAccountId
          : depreciationAccountId // ignore: cast_nullable_to_non_nullable
              as String,
      accumDepreciationAccountId: null == accumDepreciationAccountId
          ? _value.accumDepreciationAccountId
          : accumDepreciationAccountId // ignore: cast_nullable_to_non_nullable
              as String,
      accumulatedDepreciation: null == accumulatedDepreciation
          ? _value.accumulatedDepreciation
          : accumulatedDepreciation // ignore: cast_nullable_to_non_nullable
              as double,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FixedAssetImpl extends _FixedAsset {
  const _$FixedAssetImpl(
      {required this.code,
      required this.nameAr,
      required this.nameEn,
      required this.categoryId,
      required this.acquisitionDate,
      required this.cost,
      required this.residualValue,
      required this.usefulLifeYears,
      required this.depreciationMethod,
      required this.assetAccountId,
      required this.depreciationAccountId,
      required this.accumDepreciationAccountId,
      this.accumulatedDepreciation = 0.0,
      this.id,
      this.isActive = true})
      : super._();

  factory _$FixedAssetImpl.fromJson(Map<String, dynamic> json) =>
      _$$FixedAssetImplFromJson(json);

  /// كود الأصل (مثلاً: AST-001)
  @override
  final String code;

  /// الاسم بالعربية
  @override
  final String nameAr;

  /// الاسم بالإنجليزية
  @override
  final String nameEn;

  /// معرف الفئة
  @override
  final String categoryId;

  /// تاريخ الاستحواذ
  @override
  final DateTime acquisitionDate;

  /// التكلفة التاريخية
  @override
  final double cost;

  /// القيمة المتبقية (الخرداة)
  @override
  final double residualValue;

  /// العمر الإنتاجي بالسنوات
  @override
  final int usefulLifeYears;

  /// طريقة الإهلاك
  @override
  final String depreciationMethod;

  /// معرف حساب الأصل
  @override
  final String assetAccountId;

  /// معرف حساب مصروف الإهلاك
  @override
  final String depreciationAccountId;

  /// معرف حساب مجمع الإهلاك
  @override
  final String accumDepreciationAccountId;

  /// مجمع الإهلاك الحالي
  @override
  @JsonKey()
  final double accumulatedDepreciation;

  /// معرف فريد للأصل
  @override
  final String? id;

  /// هل الأصل ما زال نشطاً (قيد الاستخدام)
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'FixedAsset(code: $code, nameAr: $nameAr, nameEn: $nameEn, categoryId: $categoryId, acquisitionDate: $acquisitionDate, cost: $cost, residualValue: $residualValue, usefulLifeYears: $usefulLifeYears, depreciationMethod: $depreciationMethod, assetAccountId: $assetAccountId, depreciationAccountId: $depreciationAccountId, accumDepreciationAccountId: $accumDepreciationAccountId, accumulatedDepreciation: $accumulatedDepreciation, id: $id, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FixedAssetImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.acquisitionDate, acquisitionDate) ||
                other.acquisitionDate == acquisitionDate) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.residualValue, residualValue) ||
                other.residualValue == residualValue) &&
            (identical(other.usefulLifeYears, usefulLifeYears) ||
                other.usefulLifeYears == usefulLifeYears) &&
            (identical(other.depreciationMethod, depreciationMethod) ||
                other.depreciationMethod == depreciationMethod) &&
            (identical(other.assetAccountId, assetAccountId) ||
                other.assetAccountId == assetAccountId) &&
            (identical(other.depreciationAccountId, depreciationAccountId) ||
                other.depreciationAccountId == depreciationAccountId) &&
            (identical(other.accumDepreciationAccountId,
                    accumDepreciationAccountId) ||
                other.accumDepreciationAccountId ==
                    accumDepreciationAccountId) &&
            (identical(
                    other.accumulatedDepreciation, accumulatedDepreciation) ||
                other.accumulatedDepreciation == accumulatedDepreciation) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      code,
      nameAr,
      nameEn,
      categoryId,
      acquisitionDate,
      cost,
      residualValue,
      usefulLifeYears,
      depreciationMethod,
      assetAccountId,
      depreciationAccountId,
      accumDepreciationAccountId,
      accumulatedDepreciation,
      id,
      isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FixedAssetImplCopyWith<_$FixedAssetImpl> get copyWith =>
      __$$FixedAssetImplCopyWithImpl<_$FixedAssetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FixedAssetImplToJson(
      this,
    );
  }
}

abstract class _FixedAsset extends FixedAsset {
  const factory _FixedAsset(
      {required final String code,
      required final String nameAr,
      required final String nameEn,
      required final String categoryId,
      required final DateTime acquisitionDate,
      required final double cost,
      required final double residualValue,
      required final int usefulLifeYears,
      required final String depreciationMethod,
      required final String assetAccountId,
      required final String depreciationAccountId,
      required final String accumDepreciationAccountId,
      final double accumulatedDepreciation,
      final String? id,
      final bool isActive}) = _$FixedAssetImpl;
  const _FixedAsset._() : super._();

  factory _FixedAsset.fromJson(Map<String, dynamic> json) =
      _$FixedAssetImpl.fromJson;

  @override

  /// كود الأصل (مثلاً: AST-001)
  String get code;
  @override

  /// الاسم بالعربية
  String get nameAr;
  @override

  /// الاسم بالإنجليزية
  String get nameEn;
  @override

  /// معرف الفئة
  String get categoryId;
  @override

  /// تاريخ الاستحواذ
  DateTime get acquisitionDate;
  @override

  /// التكلفة التاريخية
  double get cost;
  @override

  /// القيمة المتبقية (الخرداة)
  double get residualValue;
  @override

  /// العمر الإنتاجي بالسنوات
  int get usefulLifeYears;
  @override

  /// طريقة الإهلاك
  String get depreciationMethod;
  @override

  /// معرف حساب الأصل
  String get assetAccountId;
  @override

  /// معرف حساب مصروف الإهلاك
  String get depreciationAccountId;
  @override

  /// معرف حساب مجمع الإهلاك
  String get accumDepreciationAccountId;
  @override

  /// مجمع الإهلاك الحالي
  double get accumulatedDepreciation;
  @override

  /// معرف فريد للأصل
  String? get id;
  @override

  /// هل الأصل ما زال نشطاً (قيد الاستخدام)
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$FixedAssetImplCopyWith<_$FixedAssetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
