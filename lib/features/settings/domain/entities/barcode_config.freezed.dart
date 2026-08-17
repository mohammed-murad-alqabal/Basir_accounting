// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'barcode_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BarcodeConfig _$BarcodeConfigFromJson(Map<String, dynamic> json) {
  return _BarcodeConfig.fromJson(json);
}

/// @nodoc
mixin _$BarcodeConfig {
  /// المعرف الفريد للإعداد
  String get id => throw _privateConstructorUsedError;

  /// نوع الطابعة
  PrinterType get printerType => throw _privateConstructorUsedError;

  /// عدد الأعمدة في الصف الواحد (خاص بـ A4)
  int get columnsPerRow => throw _privateConstructorUsedError;

  /// طول الملصق بالمليمتر
  double get height => throw _privateConstructorUsedError;

  /// عرض الملصق بالمليمتر
  double get width => throw _privateConstructorUsedError;

  /// الهامش بالمليمتر
  double get margin => throw _privateConstructorUsedError;

  /// هل يتم طباعة اسم الصنف
  bool get showItemName => throw _privateConstructorUsedError;

  /// هل يتم طباعة السعر
  bool get showPrice => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BarcodeConfigCopyWith<BarcodeConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BarcodeConfigCopyWith<$Res> {
  factory $BarcodeConfigCopyWith(
          BarcodeConfig value, $Res Function(BarcodeConfig) then) =
      _$BarcodeConfigCopyWithImpl<$Res, BarcodeConfig>;
  @useResult
  $Res call(
      {String id,
      PrinterType printerType,
      int columnsPerRow,
      double height,
      double width,
      double margin,
      bool showItemName,
      bool showPrice});
}

/// @nodoc
class _$BarcodeConfigCopyWithImpl<$Res, $Val extends BarcodeConfig>
    implements $BarcodeConfigCopyWith<$Res> {
  _$BarcodeConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? printerType = null,
    Object? columnsPerRow = null,
    Object? height = null,
    Object? width = null,
    Object? margin = null,
    Object? showItemName = null,
    Object? showPrice = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      printerType: null == printerType
          ? _value.printerType
          : printerType // ignore: cast_nullable_to_non_nullable
              as PrinterType,
      columnsPerRow: null == columnsPerRow
          ? _value.columnsPerRow
          : columnsPerRow // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      margin: null == margin
          ? _value.margin
          : margin // ignore: cast_nullable_to_non_nullable
              as double,
      showItemName: null == showItemName
          ? _value.showItemName
          : showItemName // ignore: cast_nullable_to_non_nullable
              as bool,
      showPrice: null == showPrice
          ? _value.showPrice
          : showPrice // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BarcodeConfigImplCopyWith<$Res>
    implements $BarcodeConfigCopyWith<$Res> {
  factory _$$BarcodeConfigImplCopyWith(
          _$BarcodeConfigImpl value, $Res Function(_$BarcodeConfigImpl) then) =
      __$$BarcodeConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      PrinterType printerType,
      int columnsPerRow,
      double height,
      double width,
      double margin,
      bool showItemName,
      bool showPrice});
}

/// @nodoc
class __$$BarcodeConfigImplCopyWithImpl<$Res>
    extends _$BarcodeConfigCopyWithImpl<$Res, _$BarcodeConfigImpl>
    implements _$$BarcodeConfigImplCopyWith<$Res> {
  __$$BarcodeConfigImplCopyWithImpl(
      _$BarcodeConfigImpl _value, $Res Function(_$BarcodeConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? printerType = null,
    Object? columnsPerRow = null,
    Object? height = null,
    Object? width = null,
    Object? margin = null,
    Object? showItemName = null,
    Object? showPrice = null,
  }) {
    return _then(_$BarcodeConfigImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      printerType: null == printerType
          ? _value.printerType
          : printerType // ignore: cast_nullable_to_non_nullable
              as PrinterType,
      columnsPerRow: null == columnsPerRow
          ? _value.columnsPerRow
          : columnsPerRow // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      margin: null == margin
          ? _value.margin
          : margin // ignore: cast_nullable_to_non_nullable
              as double,
      showItemName: null == showItemName
          ? _value.showItemName
          : showItemName // ignore: cast_nullable_to_non_nullable
              as bool,
      showPrice: null == showPrice
          ? _value.showPrice
          : showPrice // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BarcodeConfigImpl implements _BarcodeConfig {
  const _$BarcodeConfigImpl(
      {this.id = 'default',
      this.printerType = PrinterType.thermal,
      this.columnsPerRow = 1,
      this.height = 30.0,
      this.width = 50.0,
      this.margin = 2.0,
      this.showItemName = true,
      this.showPrice = true});

  factory _$BarcodeConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$BarcodeConfigImplFromJson(json);

  /// المعرف الفريد للإعداد
  @override
  @JsonKey()
  final String id;

  /// نوع الطابعة
  @override
  @JsonKey()
  final PrinterType printerType;

  /// عدد الأعمدة في الصف الواحد (خاص بـ A4)
  @override
  @JsonKey()
  final int columnsPerRow;

  /// طول الملصق بالمليمتر
  @override
  @JsonKey()
  final double height;

  /// عرض الملصق بالمليمتر
  @override
  @JsonKey()
  final double width;

  /// الهامش بالمليمتر
  @override
  @JsonKey()
  final double margin;

  /// هل يتم طباعة اسم الصنف
  @override
  @JsonKey()
  final bool showItemName;

  /// هل يتم طباعة السعر
  @override
  @JsonKey()
  final bool showPrice;

  @override
  String toString() {
    return 'BarcodeConfig(id: $id, printerType: $printerType, columnsPerRow: $columnsPerRow, height: $height, width: $width, margin: $margin, showItemName: $showItemName, showPrice: $showPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BarcodeConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.printerType, printerType) ||
                other.printerType == printerType) &&
            (identical(other.columnsPerRow, columnsPerRow) ||
                other.columnsPerRow == columnsPerRow) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.margin, margin) || other.margin == margin) &&
            (identical(other.showItemName, showItemName) ||
                other.showItemName == showItemName) &&
            (identical(other.showPrice, showPrice) ||
                other.showPrice == showPrice));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, printerType, columnsPerRow,
      height, width, margin, showItemName, showPrice);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BarcodeConfigImplCopyWith<_$BarcodeConfigImpl> get copyWith =>
      __$$BarcodeConfigImplCopyWithImpl<_$BarcodeConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BarcodeConfigImplToJson(
      this,
    );
  }
}

abstract class _BarcodeConfig implements BarcodeConfig {
  const factory _BarcodeConfig(
      {final String id,
      final PrinterType printerType,
      final int columnsPerRow,
      final double height,
      final double width,
      final double margin,
      final bool showItemName,
      final bool showPrice}) = _$BarcodeConfigImpl;

  factory _BarcodeConfig.fromJson(Map<String, dynamic> json) =
      _$BarcodeConfigImpl.fromJson;

  @override

  /// المعرف الفريد للإعداد
  String get id;
  @override

  /// نوع الطابعة
  PrinterType get printerType;
  @override

  /// عدد الأعمدة في الصف الواحد (خاص بـ A4)
  int get columnsPerRow;
  @override

  /// طول الملصق بالمليمتر
  double get height;
  @override

  /// عرض الملصق بالمليمتر
  double get width;
  @override

  /// الهامش بالمليمتر
  double get margin;
  @override

  /// هل يتم طباعة اسم الصنف
  bool get showItemName;
  @override

  /// هل يتم طباعة السعر
  bool get showPrice;
  @override
  @JsonKey(ignore: true)
  _$$BarcodeConfigImplCopyWith<_$BarcodeConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
