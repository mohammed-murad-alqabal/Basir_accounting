// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AssetCategory _$AssetCategoryFromJson(Map<String, dynamic> json) {
  return _AssetCategory.fromJson(json);
}

/// @nodoc
mixin _$AssetCategory {
  /// اسم الفئة بالعربية
  String get nameAr => throw _privateConstructorUsedError;

  /// اسم الفئة بالإنجليزية
  String get nameEn => throw _privateConstructorUsedError;

  /// طريقة الإهلاك الافتراضية
  String get defaultDepreciationMethod => throw _privateConstructorUsedError;

  /// العمر الإنتاجي الافتراضي (بالسنوات)
  int get defaultUsefulLifeYears => throw _privateConstructorUsedError;

  /// معرف فريد للفئة
  String? get id => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AssetCategoryCopyWith<AssetCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssetCategoryCopyWith<$Res> {
  factory $AssetCategoryCopyWith(
          AssetCategory value, $Res Function(AssetCategory) then) =
      _$AssetCategoryCopyWithImpl<$Res, AssetCategory>;
  @useResult
  $Res call(
      {String nameAr,
      String nameEn,
      String defaultDepreciationMethod,
      int defaultUsefulLifeYears,
      String? id});
}

/// @nodoc
class _$AssetCategoryCopyWithImpl<$Res, $Val extends AssetCategory>
    implements $AssetCategoryCopyWith<$Res> {
  _$AssetCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nameAr = null,
    Object? nameEn = null,
    Object? defaultDepreciationMethod = null,
    Object? defaultUsefulLifeYears = null,
    Object? id = freezed,
  }) {
    return _then(_value.copyWith(
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      defaultDepreciationMethod: null == defaultDepreciationMethod
          ? _value.defaultDepreciationMethod
          : defaultDepreciationMethod // ignore: cast_nullable_to_non_nullable
              as String,
      defaultUsefulLifeYears: null == defaultUsefulLifeYears
          ? _value.defaultUsefulLifeYears
          : defaultUsefulLifeYears // ignore: cast_nullable_to_non_nullable
              as int,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AssetCategoryImplCopyWith<$Res>
    implements $AssetCategoryCopyWith<$Res> {
  factory _$$AssetCategoryImplCopyWith(
          _$AssetCategoryImpl value, $Res Function(_$AssetCategoryImpl) then) =
      __$$AssetCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String nameAr,
      String nameEn,
      String defaultDepreciationMethod,
      int defaultUsefulLifeYears,
      String? id});
}

/// @nodoc
class __$$AssetCategoryImplCopyWithImpl<$Res>
    extends _$AssetCategoryCopyWithImpl<$Res, _$AssetCategoryImpl>
    implements _$$AssetCategoryImplCopyWith<$Res> {
  __$$AssetCategoryImplCopyWithImpl(
      _$AssetCategoryImpl _value, $Res Function(_$AssetCategoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nameAr = null,
    Object? nameEn = null,
    Object? defaultDepreciationMethod = null,
    Object? defaultUsefulLifeYears = null,
    Object? id = freezed,
  }) {
    return _then(_$AssetCategoryImpl(
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      defaultDepreciationMethod: null == defaultDepreciationMethod
          ? _value.defaultDepreciationMethod
          : defaultDepreciationMethod // ignore: cast_nullable_to_non_nullable
              as String,
      defaultUsefulLifeYears: null == defaultUsefulLifeYears
          ? _value.defaultUsefulLifeYears
          : defaultUsefulLifeYears // ignore: cast_nullable_to_non_nullable
              as int,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AssetCategoryImpl implements _AssetCategory {
  const _$AssetCategoryImpl(
      {required this.nameAr,
      required this.nameEn,
      required this.defaultDepreciationMethod,
      required this.defaultUsefulLifeYears,
      this.id});

  factory _$AssetCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssetCategoryImplFromJson(json);

  /// اسم الفئة بالعربية
  @override
  final String nameAr;

  /// اسم الفئة بالإنجليزية
  @override
  final String nameEn;

  /// طريقة الإهلاك الافتراضية
  @override
  final String defaultDepreciationMethod;

  /// العمر الإنتاجي الافتراضي (بالسنوات)
  @override
  final int defaultUsefulLifeYears;

  /// معرف فريد للفئة
  @override
  final String? id;

  @override
  String toString() {
    return 'AssetCategory(nameAr: $nameAr, nameEn: $nameEn, defaultDepreciationMethod: $defaultDepreciationMethod, defaultUsefulLifeYears: $defaultUsefulLifeYears, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssetCategoryImpl &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.defaultDepreciationMethod,
                    defaultDepreciationMethod) ||
                other.defaultDepreciationMethod == defaultDepreciationMethod) &&
            (identical(other.defaultUsefulLifeYears, defaultUsefulLifeYears) ||
                other.defaultUsefulLifeYears == defaultUsefulLifeYears) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, nameAr, nameEn,
      defaultDepreciationMethod, defaultUsefulLifeYears, id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AssetCategoryImplCopyWith<_$AssetCategoryImpl> get copyWith =>
      __$$AssetCategoryImplCopyWithImpl<_$AssetCategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssetCategoryImplToJson(
      this,
    );
  }
}

abstract class _AssetCategory implements AssetCategory {
  const factory _AssetCategory(
      {required final String nameAr,
      required final String nameEn,
      required final String defaultDepreciationMethod,
      required final int defaultUsefulLifeYears,
      final String? id}) = _$AssetCategoryImpl;

  factory _AssetCategory.fromJson(Map<String, dynamic> json) =
      _$AssetCategoryImpl.fromJson;

  @override

  /// اسم الفئة بالعربية
  String get nameAr;
  @override

  /// اسم الفئة بالإنجليزية
  String get nameEn;
  @override

  /// طريقة الإهلاك الافتراضية
  String get defaultDepreciationMethod;
  @override

  /// العمر الإنتاجي الافتراضي (بالسنوات)
  int get defaultUsefulLifeYears;
  @override

  /// معرف فريد للفئة
  String? get id;
  @override
  @JsonKey(ignore: true)
  _$$AssetCategoryImplCopyWith<_$AssetCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
