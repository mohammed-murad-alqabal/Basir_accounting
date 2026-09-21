// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_price.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MarketPrice _$MarketPriceFromJson(Map<String, dynamic> json) {
  return _MarketPrice.fromJson(json);
}

/// @nodoc
mixin _$MarketPrice {
  /// المعرف الفريد
  String get id => throw _privateConstructorUsedError;

  /// معرف صنف المخزون
  String get itemId => throw _privateConstructorUsedError;

  /// سعر السوق (القيمة العادلة)
  double get price => throw _privateConstructorUsedError;

  /// تاريخ التقييم
  DateTime get asOfDate => throw _privateConstructorUsedError;

  /// تاريخ الإنشاء
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MarketPriceCopyWith<MarketPrice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketPriceCopyWith<$Res> {
  factory $MarketPriceCopyWith(
          MarketPrice value, $Res Function(MarketPrice) then) =
      _$MarketPriceCopyWithImpl<$Res, MarketPrice>;
  @useResult
  $Res call(
      {String id,
      String itemId,
      double price,
      DateTime asOfDate,
      DateTime createdAt});
}

/// @nodoc
class _$MarketPriceCopyWithImpl<$Res, $Val extends MarketPrice>
    implements $MarketPriceCopyWith<$Res> {
  _$MarketPriceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemId = null,
    Object? price = null,
    Object? asOfDate = null,
    Object? createdAt = null,
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
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      asOfDate: null == asOfDate
          ? _value.asOfDate
          : asOfDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MarketPriceImplCopyWith<$Res>
    implements $MarketPriceCopyWith<$Res> {
  factory _$$MarketPriceImplCopyWith(
          _$MarketPriceImpl value, $Res Function(_$MarketPriceImpl) then) =
      __$$MarketPriceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String itemId,
      double price,
      DateTime asOfDate,
      DateTime createdAt});
}

/// @nodoc
class __$$MarketPriceImplCopyWithImpl<$Res>
    extends _$MarketPriceCopyWithImpl<$Res, _$MarketPriceImpl>
    implements _$$MarketPriceImplCopyWith<$Res> {
  __$$MarketPriceImplCopyWithImpl(
      _$MarketPriceImpl _value, $Res Function(_$MarketPriceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemId = null,
    Object? price = null,
    Object? asOfDate = null,
    Object? createdAt = null,
  }) {
    return _then(_$MarketPriceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      asOfDate: null == asOfDate
          ? _value.asOfDate
          : asOfDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketPriceImpl implements _MarketPrice {
  const _$MarketPriceImpl(
      {required this.id,
      required this.itemId,
      required this.price,
      required this.asOfDate,
      required this.createdAt});

  factory _$MarketPriceImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketPriceImplFromJson(json);

  /// المعرف الفريد
  @override
  final String id;

  /// معرف صنف المخزون
  @override
  final String itemId;

  /// سعر السوق (القيمة العادلة)
  @override
  final double price;

  /// تاريخ التقييم
  @override
  final DateTime asOfDate;

  /// تاريخ الإنشاء
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'MarketPrice(id: $id, itemId: $itemId, price: $price, asOfDate: $asOfDate, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketPriceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.asOfDate, asOfDate) ||
                other.asOfDate == asOfDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, itemId, price, asOfDate, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketPriceImplCopyWith<_$MarketPriceImpl> get copyWith =>
      __$$MarketPriceImplCopyWithImpl<_$MarketPriceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketPriceImplToJson(
      this,
    );
  }
}

abstract class _MarketPrice implements MarketPrice {
  const factory _MarketPrice(
      {required final String id,
      required final String itemId,
      required final double price,
      required final DateTime asOfDate,
      required final DateTime createdAt}) = _$MarketPriceImpl;

  factory _MarketPrice.fromJson(Map<String, dynamic> json) =
      _$MarketPriceImpl.fromJson;

  @override

  /// المعرف الفريد
  String get id;
  @override

  /// معرف صنف المخزون
  String get itemId;
  @override

  /// سعر السوق (القيمة العادلة)
  double get price;
  @override

  /// تاريخ التقييم
  DateTime get asOfDate;
  @override

  /// تاريخ الإنشاء
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$MarketPriceImplCopyWith<_$MarketPriceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
