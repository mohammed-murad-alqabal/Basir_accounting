// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'liquidity_forecast.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LiquidityForecast {
  /// Start date of the forecast period.
  DateTime get startDate => throw _privateConstructorUsedError;

  /// End date of the forecast period.
  DateTime get endDate => throw _privateConstructorUsedError;

  /// Total expected cash inflow (Receivables).
  Decimal get totalInflow => throw _privateConstructorUsedError;

  /// Total expected cash outflow (Payables).
  Decimal get totalOutflow => throw _privateConstructorUsedError;

  /// Net cash flow (Inflow - Outflow).
  Decimal get netChange => throw _privateConstructorUsedError;

  /// Daily breakdown of cash flow.
  List<DailyCashFlow> get dailyBreakdown => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LiquidityForecastCopyWith<LiquidityForecast> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LiquidityForecastCopyWith<$Res> {
  factory $LiquidityForecastCopyWith(
          LiquidityForecast value, $Res Function(LiquidityForecast) then) =
      _$LiquidityForecastCopyWithImpl<$Res, LiquidityForecast>;
  @useResult
  $Res call(
      {DateTime startDate,
      DateTime endDate,
      Decimal totalInflow,
      Decimal totalOutflow,
      Decimal netChange,
      List<DailyCashFlow> dailyBreakdown});
}

/// @nodoc
class _$LiquidityForecastCopyWithImpl<$Res, $Val extends LiquidityForecast>
    implements $LiquidityForecastCopyWith<$Res> {
  _$LiquidityForecastCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? totalInflow = null,
    Object? totalOutflow = null,
    Object? netChange = null,
    Object? dailyBreakdown = null,
  }) {
    return _then(_value.copyWith(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalInflow: null == totalInflow
          ? _value.totalInflow
          : totalInflow // ignore: cast_nullable_to_non_nullable
              as Decimal,
      totalOutflow: null == totalOutflow
          ? _value.totalOutflow
          : totalOutflow // ignore: cast_nullable_to_non_nullable
              as Decimal,
      netChange: null == netChange
          ? _value.netChange
          : netChange // ignore: cast_nullable_to_non_nullable
              as Decimal,
      dailyBreakdown: null == dailyBreakdown
          ? _value.dailyBreakdown
          : dailyBreakdown // ignore: cast_nullable_to_non_nullable
              as List<DailyCashFlow>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LiquidityForecastImplCopyWith<$Res>
    implements $LiquidityForecastCopyWith<$Res> {
  factory _$$LiquidityForecastImplCopyWith(_$LiquidityForecastImpl value,
          $Res Function(_$LiquidityForecastImpl) then) =
      __$$LiquidityForecastImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime startDate,
      DateTime endDate,
      Decimal totalInflow,
      Decimal totalOutflow,
      Decimal netChange,
      List<DailyCashFlow> dailyBreakdown});
}

/// @nodoc
class __$$LiquidityForecastImplCopyWithImpl<$Res>
    extends _$LiquidityForecastCopyWithImpl<$Res, _$LiquidityForecastImpl>
    implements _$$LiquidityForecastImplCopyWith<$Res> {
  __$$LiquidityForecastImplCopyWithImpl(_$LiquidityForecastImpl _value,
      $Res Function(_$LiquidityForecastImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? totalInflow = null,
    Object? totalOutflow = null,
    Object? netChange = null,
    Object? dailyBreakdown = null,
  }) {
    return _then(_$LiquidityForecastImpl(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalInflow: null == totalInflow
          ? _value.totalInflow
          : totalInflow // ignore: cast_nullable_to_non_nullable
              as Decimal,
      totalOutflow: null == totalOutflow
          ? _value.totalOutflow
          : totalOutflow // ignore: cast_nullable_to_non_nullable
              as Decimal,
      netChange: null == netChange
          ? _value.netChange
          : netChange // ignore: cast_nullable_to_non_nullable
              as Decimal,
      dailyBreakdown: null == dailyBreakdown
          ? _value._dailyBreakdown
          : dailyBreakdown // ignore: cast_nullable_to_non_nullable
              as List<DailyCashFlow>,
    ));
  }
}

/// @nodoc

class _$LiquidityForecastImpl implements _LiquidityForecast {
  const _$LiquidityForecastImpl(
      {required this.startDate,
      required this.endDate,
      required this.totalInflow,
      required this.totalOutflow,
      required this.netChange,
      required final List<DailyCashFlow> dailyBreakdown})
      : _dailyBreakdown = dailyBreakdown;

  /// Start date of the forecast period.
  @override
  final DateTime startDate;

  /// End date of the forecast period.
  @override
  final DateTime endDate;

  /// Total expected cash inflow (Receivables).
  @override
  final Decimal totalInflow;

  /// Total expected cash outflow (Payables).
  @override
  final Decimal totalOutflow;

  /// Net cash flow (Inflow - Outflow).
  @override
  final Decimal netChange;

  /// Daily breakdown of cash flow.
  final List<DailyCashFlow> _dailyBreakdown;

  /// Daily breakdown of cash flow.
  @override
  List<DailyCashFlow> get dailyBreakdown {
    if (_dailyBreakdown is EqualUnmodifiableListView) return _dailyBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyBreakdown);
  }

  @override
  String toString() {
    return 'LiquidityForecast(startDate: $startDate, endDate: $endDate, totalInflow: $totalInflow, totalOutflow: $totalOutflow, netChange: $netChange, dailyBreakdown: $dailyBreakdown)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LiquidityForecastImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.totalInflow, totalInflow) ||
                other.totalInflow == totalInflow) &&
            (identical(other.totalOutflow, totalOutflow) ||
                other.totalOutflow == totalOutflow) &&
            (identical(other.netChange, netChange) ||
                other.netChange == netChange) &&
            const DeepCollectionEquality()
                .equals(other._dailyBreakdown, _dailyBreakdown));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      startDate,
      endDate,
      totalInflow,
      totalOutflow,
      netChange,
      const DeepCollectionEquality().hash(_dailyBreakdown));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LiquidityForecastImplCopyWith<_$LiquidityForecastImpl> get copyWith =>
      __$$LiquidityForecastImplCopyWithImpl<_$LiquidityForecastImpl>(
          this, _$identity);
}

abstract class _LiquidityForecast implements LiquidityForecast {
  const factory _LiquidityForecast(
          {required final DateTime startDate,
          required final DateTime endDate,
          required final Decimal totalInflow,
          required final Decimal totalOutflow,
          required final Decimal netChange,
          required final List<DailyCashFlow> dailyBreakdown}) =
      _$LiquidityForecastImpl;

  @override

  /// Start date of the forecast period.
  DateTime get startDate;
  @override

  /// End date of the forecast period.
  DateTime get endDate;
  @override

  /// Total expected cash inflow (Receivables).
  Decimal get totalInflow;
  @override

  /// Total expected cash outflow (Payables).
  Decimal get totalOutflow;
  @override

  /// Net cash flow (Inflow - Outflow).
  Decimal get netChange;
  @override

  /// Daily breakdown of cash flow.
  List<DailyCashFlow> get dailyBreakdown;
  @override
  @JsonKey(ignore: true)
  _$$LiquidityForecastImplCopyWith<_$LiquidityForecastImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DailyCashFlow {
  /// The date of the cash flow.
  DateTime get date => throw _privateConstructorUsedError;

  /// Cash inflow for the day.
  Decimal get inflow => throw _privateConstructorUsedError;

  /// Cash outflow for the day.
  Decimal get outflow => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DailyCashFlowCopyWith<DailyCashFlow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyCashFlowCopyWith<$Res> {
  factory $DailyCashFlowCopyWith(
          DailyCashFlow value, $Res Function(DailyCashFlow) then) =
      _$DailyCashFlowCopyWithImpl<$Res, DailyCashFlow>;
  @useResult
  $Res call({DateTime date, Decimal inflow, Decimal outflow});
}

/// @nodoc
class _$DailyCashFlowCopyWithImpl<$Res, $Val extends DailyCashFlow>
    implements $DailyCashFlowCopyWith<$Res> {
  _$DailyCashFlowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? inflow = null,
    Object? outflow = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      inflow: null == inflow
          ? _value.inflow
          : inflow // ignore: cast_nullable_to_non_nullable
              as Decimal,
      outflow: null == outflow
          ? _value.outflow
          : outflow // ignore: cast_nullable_to_non_nullable
              as Decimal,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyCashFlowImplCopyWith<$Res>
    implements $DailyCashFlowCopyWith<$Res> {
  factory _$$DailyCashFlowImplCopyWith(
          _$DailyCashFlowImpl value, $Res Function(_$DailyCashFlowImpl) then) =
      __$$DailyCashFlowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, Decimal inflow, Decimal outflow});
}

/// @nodoc
class __$$DailyCashFlowImplCopyWithImpl<$Res>
    extends _$DailyCashFlowCopyWithImpl<$Res, _$DailyCashFlowImpl>
    implements _$$DailyCashFlowImplCopyWith<$Res> {
  __$$DailyCashFlowImplCopyWithImpl(
      _$DailyCashFlowImpl _value, $Res Function(_$DailyCashFlowImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? inflow = null,
    Object? outflow = null,
  }) {
    return _then(_$DailyCashFlowImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      inflow: null == inflow
          ? _value.inflow
          : inflow // ignore: cast_nullable_to_non_nullable
              as Decimal,
      outflow: null == outflow
          ? _value.outflow
          : outflow // ignore: cast_nullable_to_non_nullable
              as Decimal,
    ));
  }
}

/// @nodoc

class _$DailyCashFlowImpl implements _DailyCashFlow {
  const _$DailyCashFlowImpl(
      {required this.date, required this.inflow, required this.outflow});

  /// The date of the cash flow.
  @override
  final DateTime date;

  /// Cash inflow for the day.
  @override
  final Decimal inflow;

  /// Cash outflow for the day.
  @override
  final Decimal outflow;

  @override
  String toString() {
    return 'DailyCashFlow(date: $date, inflow: $inflow, outflow: $outflow)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyCashFlowImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.inflow, inflow) || other.inflow == inflow) &&
            (identical(other.outflow, outflow) || other.outflow == outflow));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date, inflow, outflow);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyCashFlowImplCopyWith<_$DailyCashFlowImpl> get copyWith =>
      __$$DailyCashFlowImplCopyWithImpl<_$DailyCashFlowImpl>(this, _$identity);
}

abstract class _DailyCashFlow implements DailyCashFlow {
  const factory _DailyCashFlow(
      {required final DateTime date,
      required final Decimal inflow,
      required final Decimal outflow}) = _$DailyCashFlowImpl;

  @override

  /// The date of the cash flow.
  DateTime get date;
  @override

  /// Cash inflow for the day.
  Decimal get inflow;
  @override

  /// Cash outflow for the day.
  Decimal get outflow;
  @override
  @JsonKey(ignore: true)
  _$$DailyCashFlowImplCopyWith<_$DailyCashFlowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
