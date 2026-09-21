// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'strategic_outlook.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StrategicOutlook _$StrategicOutlookFromJson(Map<String, dynamic> json) {
  return _StrategicOutlook.fromJson(json);
}

/// @nodoc
mixin _$StrategicOutlook {
  /// Timestamp when the outlook was generated.
  DateTime get generatedAt => throw _privateConstructorUsedError;

  /// Predicted P&L metrics for future periods.
  List<PredictiveMetric> get pnlForecast => throw _privateConstructorUsedError;

  /// Predicted Cash Flow metrics for future periods.
  List<PredictiveMetric> get cashFlowForecast =>
      throw _privateConstructorUsedError;

  /// List of AI-generated insights based on the forecast.
  List<StrategicInsight> get insights => throw _privateConstructorUsedError;

  /// Confidence score (0.0 to 1.0) of the prediction model.
  double get confidenceScore => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StrategicOutlookCopyWith<StrategicOutlook> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StrategicOutlookCopyWith<$Res> {
  factory $StrategicOutlookCopyWith(
          StrategicOutlook value, $Res Function(StrategicOutlook) then) =
      _$StrategicOutlookCopyWithImpl<$Res, StrategicOutlook>;
  @useResult
  $Res call(
      {DateTime generatedAt,
      List<PredictiveMetric> pnlForecast,
      List<PredictiveMetric> cashFlowForecast,
      List<StrategicInsight> insights,
      double confidenceScore});
}

/// @nodoc
class _$StrategicOutlookCopyWithImpl<$Res, $Val extends StrategicOutlook>
    implements $StrategicOutlookCopyWith<$Res> {
  _$StrategicOutlookCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? generatedAt = null,
    Object? pnlForecast = null,
    Object? cashFlowForecast = null,
    Object? insights = null,
    Object? confidenceScore = null,
  }) {
    return _then(_value.copyWith(
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      pnlForecast: null == pnlForecast
          ? _value.pnlForecast
          : pnlForecast // ignore: cast_nullable_to_non_nullable
              as List<PredictiveMetric>,
      cashFlowForecast: null == cashFlowForecast
          ? _value.cashFlowForecast
          : cashFlowForecast // ignore: cast_nullable_to_non_nullable
              as List<PredictiveMetric>,
      insights: null == insights
          ? _value.insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<StrategicInsight>,
      confidenceScore: null == confidenceScore
          ? _value.confidenceScore
          : confidenceScore // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StrategicOutlookImplCopyWith<$Res>
    implements $StrategicOutlookCopyWith<$Res> {
  factory _$$StrategicOutlookImplCopyWith(_$StrategicOutlookImpl value,
          $Res Function(_$StrategicOutlookImpl) then) =
      __$$StrategicOutlookImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime generatedAt,
      List<PredictiveMetric> pnlForecast,
      List<PredictiveMetric> cashFlowForecast,
      List<StrategicInsight> insights,
      double confidenceScore});
}

/// @nodoc
class __$$StrategicOutlookImplCopyWithImpl<$Res>
    extends _$StrategicOutlookCopyWithImpl<$Res, _$StrategicOutlookImpl>
    implements _$$StrategicOutlookImplCopyWith<$Res> {
  __$$StrategicOutlookImplCopyWithImpl(_$StrategicOutlookImpl _value,
      $Res Function(_$StrategicOutlookImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? generatedAt = null,
    Object? pnlForecast = null,
    Object? cashFlowForecast = null,
    Object? insights = null,
    Object? confidenceScore = null,
  }) {
    return _then(_$StrategicOutlookImpl(
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      pnlForecast: null == pnlForecast
          ? _value._pnlForecast
          : pnlForecast // ignore: cast_nullable_to_non_nullable
              as List<PredictiveMetric>,
      cashFlowForecast: null == cashFlowForecast
          ? _value._cashFlowForecast
          : cashFlowForecast // ignore: cast_nullable_to_non_nullable
              as List<PredictiveMetric>,
      insights: null == insights
          ? _value._insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<StrategicInsight>,
      confidenceScore: null == confidenceScore
          ? _value.confidenceScore
          : confidenceScore // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StrategicOutlookImpl implements _StrategicOutlook {
  const _$StrategicOutlookImpl(
      {required this.generatedAt,
      required final List<PredictiveMetric> pnlForecast,
      required final List<PredictiveMetric> cashFlowForecast,
      required final List<StrategicInsight> insights,
      required this.confidenceScore})
      : _pnlForecast = pnlForecast,
        _cashFlowForecast = cashFlowForecast,
        _insights = insights;

  factory _$StrategicOutlookImpl.fromJson(Map<String, dynamic> json) =>
      _$$StrategicOutlookImplFromJson(json);

  /// Timestamp when the outlook was generated.
  @override
  final DateTime generatedAt;

  /// Predicted P&L metrics for future periods.
  final List<PredictiveMetric> _pnlForecast;

  /// Predicted P&L metrics for future periods.
  @override
  List<PredictiveMetric> get pnlForecast {
    if (_pnlForecast is EqualUnmodifiableListView) return _pnlForecast;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pnlForecast);
  }

  /// Predicted Cash Flow metrics for future periods.
  final List<PredictiveMetric> _cashFlowForecast;

  /// Predicted Cash Flow metrics for future periods.
  @override
  List<PredictiveMetric> get cashFlowForecast {
    if (_cashFlowForecast is EqualUnmodifiableListView)
      return _cashFlowForecast;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cashFlowForecast);
  }

  /// List of AI-generated insights based on the forecast.
  final List<StrategicInsight> _insights;

  /// List of AI-generated insights based on the forecast.
  @override
  List<StrategicInsight> get insights {
    if (_insights is EqualUnmodifiableListView) return _insights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_insights);
  }

  /// Confidence score (0.0 to 1.0) of the prediction model.
  @override
  final double confidenceScore;

  @override
  String toString() {
    return 'StrategicOutlook(generatedAt: $generatedAt, pnlForecast: $pnlForecast, cashFlowForecast: $cashFlowForecast, insights: $insights, confidenceScore: $confidenceScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StrategicOutlookImpl &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            const DeepCollectionEquality()
                .equals(other._pnlForecast, _pnlForecast) &&
            const DeepCollectionEquality()
                .equals(other._cashFlowForecast, _cashFlowForecast) &&
            const DeepCollectionEquality().equals(other._insights, _insights) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      generatedAt,
      const DeepCollectionEquality().hash(_pnlForecast),
      const DeepCollectionEquality().hash(_cashFlowForecast),
      const DeepCollectionEquality().hash(_insights),
      confidenceScore);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StrategicOutlookImplCopyWith<_$StrategicOutlookImpl> get copyWith =>
      __$$StrategicOutlookImplCopyWithImpl<_$StrategicOutlookImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StrategicOutlookImplToJson(
      this,
    );
  }
}

abstract class _StrategicOutlook implements StrategicOutlook {
  const factory _StrategicOutlook(
      {required final DateTime generatedAt,
      required final List<PredictiveMetric> pnlForecast,
      required final List<PredictiveMetric> cashFlowForecast,
      required final List<StrategicInsight> insights,
      required final double confidenceScore}) = _$StrategicOutlookImpl;

  factory _StrategicOutlook.fromJson(Map<String, dynamic> json) =
      _$StrategicOutlookImpl.fromJson;

  @override

  /// Timestamp when the outlook was generated.
  DateTime get generatedAt;
  @override

  /// Predicted P&L metrics for future periods.
  List<PredictiveMetric> get pnlForecast;
  @override

  /// Predicted Cash Flow metrics for future periods.
  List<PredictiveMetric> get cashFlowForecast;
  @override

  /// List of AI-generated insights based on the forecast.
  List<StrategicInsight> get insights;
  @override

  /// Confidence score (0.0 to 1.0) of the prediction model.
  double get confidenceScore;
  @override
  @JsonKey(ignore: true)
  _$$StrategicOutlookImplCopyWith<_$StrategicOutlookImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PredictiveMetric _$PredictiveMetricFromJson(Map<String, dynamic> json) {
  return _PredictiveMetric.fromJson(json);
}

/// @nodoc
mixin _$PredictiveMetric {
  /// The period (month) this metric refers to.
  DateTime get period => throw _privateConstructorUsedError;

  /// Forecasted revenue.
  Decimal get revenue => throw _privateConstructorUsedError;

  /// Forecasted expenses.
  Decimal get expense => throw _privateConstructorUsedError;

  /// Forecasted net income.
  Decimal get netIncome => throw _privateConstructorUsedError;

  /// Forecasted cash inflow.
  Decimal get cashInflow => throw _privateConstructorUsedError;

  /// Forecasted cash outflow.
  Decimal get cashOutflow => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PredictiveMetricCopyWith<PredictiveMetric> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PredictiveMetricCopyWith<$Res> {
  factory $PredictiveMetricCopyWith(
          PredictiveMetric value, $Res Function(PredictiveMetric) then) =
      _$PredictiveMetricCopyWithImpl<$Res, PredictiveMetric>;
  @useResult
  $Res call(
      {DateTime period,
      Decimal revenue,
      Decimal expense,
      Decimal netIncome,
      Decimal cashInflow,
      Decimal cashOutflow});
}

/// @nodoc
class _$PredictiveMetricCopyWithImpl<$Res, $Val extends PredictiveMetric>
    implements $PredictiveMetricCopyWith<$Res> {
  _$PredictiveMetricCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? revenue = null,
    Object? expense = null,
    Object? netIncome = null,
    Object? cashInflow = null,
    Object? cashOutflow = null,
  }) {
    return _then(_value.copyWith(
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as DateTime,
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as Decimal,
      expense: null == expense
          ? _value.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as Decimal,
      netIncome: null == netIncome
          ? _value.netIncome
          : netIncome // ignore: cast_nullable_to_non_nullable
              as Decimal,
      cashInflow: null == cashInflow
          ? _value.cashInflow
          : cashInflow // ignore: cast_nullable_to_non_nullable
              as Decimal,
      cashOutflow: null == cashOutflow
          ? _value.cashOutflow
          : cashOutflow // ignore: cast_nullable_to_non_nullable
              as Decimal,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PredictiveMetricImplCopyWith<$Res>
    implements $PredictiveMetricCopyWith<$Res> {
  factory _$$PredictiveMetricImplCopyWith(_$PredictiveMetricImpl value,
          $Res Function(_$PredictiveMetricImpl) then) =
      __$$PredictiveMetricImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime period,
      Decimal revenue,
      Decimal expense,
      Decimal netIncome,
      Decimal cashInflow,
      Decimal cashOutflow});
}

/// @nodoc
class __$$PredictiveMetricImplCopyWithImpl<$Res>
    extends _$PredictiveMetricCopyWithImpl<$Res, _$PredictiveMetricImpl>
    implements _$$PredictiveMetricImplCopyWith<$Res> {
  __$$PredictiveMetricImplCopyWithImpl(_$PredictiveMetricImpl _value,
      $Res Function(_$PredictiveMetricImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? revenue = null,
    Object? expense = null,
    Object? netIncome = null,
    Object? cashInflow = null,
    Object? cashOutflow = null,
  }) {
    return _then(_$PredictiveMetricImpl(
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as DateTime,
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as Decimal,
      expense: null == expense
          ? _value.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as Decimal,
      netIncome: null == netIncome
          ? _value.netIncome
          : netIncome // ignore: cast_nullable_to_non_nullable
              as Decimal,
      cashInflow: null == cashInflow
          ? _value.cashInflow
          : cashInflow // ignore: cast_nullable_to_non_nullable
              as Decimal,
      cashOutflow: null == cashOutflow
          ? _value.cashOutflow
          : cashOutflow // ignore: cast_nullable_to_non_nullable
              as Decimal,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PredictiveMetricImpl implements _PredictiveMetric {
  const _$PredictiveMetricImpl(
      {required this.period,
      required this.revenue,
      required this.expense,
      required this.netIncome,
      required this.cashInflow,
      required this.cashOutflow});

  factory _$PredictiveMetricImpl.fromJson(Map<String, dynamic> json) =>
      _$$PredictiveMetricImplFromJson(json);

  /// The period (month) this metric refers to.
  @override
  final DateTime period;

  /// Forecasted revenue.
  @override
  final Decimal revenue;

  /// Forecasted expenses.
  @override
  final Decimal expense;

  /// Forecasted net income.
  @override
  final Decimal netIncome;

  /// Forecasted cash inflow.
  @override
  final Decimal cashInflow;

  /// Forecasted cash outflow.
  @override
  final Decimal cashOutflow;

  @override
  String toString() {
    return 'PredictiveMetric(period: $period, revenue: $revenue, expense: $expense, netIncome: $netIncome, cashInflow: $cashInflow, cashOutflow: $cashOutflow)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PredictiveMetricImpl &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.revenue, revenue) || other.revenue == revenue) &&
            (identical(other.expense, expense) || other.expense == expense) &&
            (identical(other.netIncome, netIncome) ||
                other.netIncome == netIncome) &&
            (identical(other.cashInflow, cashInflow) ||
                other.cashInflow == cashInflow) &&
            (identical(other.cashOutflow, cashOutflow) ||
                other.cashOutflow == cashOutflow));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, period, revenue, expense,
      netIncome, cashInflow, cashOutflow);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PredictiveMetricImplCopyWith<_$PredictiveMetricImpl> get copyWith =>
      __$$PredictiveMetricImplCopyWithImpl<_$PredictiveMetricImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PredictiveMetricImplToJson(
      this,
    );
  }
}

abstract class _PredictiveMetric implements PredictiveMetric {
  const factory _PredictiveMetric(
      {required final DateTime period,
      required final Decimal revenue,
      required final Decimal expense,
      required final Decimal netIncome,
      required final Decimal cashInflow,
      required final Decimal cashOutflow}) = _$PredictiveMetricImpl;

  factory _PredictiveMetric.fromJson(Map<String, dynamic> json) =
      _$PredictiveMetricImpl.fromJson;

  @override

  /// The period (month) this metric refers to.
  DateTime get period;
  @override

  /// Forecasted revenue.
  Decimal get revenue;
  @override

  /// Forecasted expenses.
  Decimal get expense;
  @override

  /// Forecasted net income.
  Decimal get netIncome;
  @override

  /// Forecasted cash inflow.
  Decimal get cashInflow;
  @override

  /// Forecasted cash outflow.
  Decimal get cashOutflow;
  @override
  @JsonKey(ignore: true)
  _$$PredictiveMetricImplCopyWith<_$PredictiveMetricImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StrategicInsight _$StrategicInsightFromJson(Map<String, dynamic> json) {
  return _StrategicInsight.fromJson(json);
}

/// @nodoc
mixin _$StrategicInsight {
  /// Short title of the insight.
  String get title => throw _privateConstructorUsedError;

  /// Detailed observation based on data trends.
  String get observation => throw _privateConstructorUsedError;

  /// Actionable recommendation for the user.
  String get recommendation => throw _privateConstructorUsedError;

  /// Impact level (positive, negative, neutral).
  InsightImpact get impact => throw _privateConstructorUsedError;

  /// Priority level ('high', 'medium', 'low').
  String get priority => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StrategicInsightCopyWith<StrategicInsight> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StrategicInsightCopyWith<$Res> {
  factory $StrategicInsightCopyWith(
          StrategicInsight value, $Res Function(StrategicInsight) then) =
      _$StrategicInsightCopyWithImpl<$Res, StrategicInsight>;
  @useResult
  $Res call(
      {String title,
      String observation,
      String recommendation,
      InsightImpact impact,
      String priority});
}

/// @nodoc
class _$StrategicInsightCopyWithImpl<$Res, $Val extends StrategicInsight>
    implements $StrategicInsightCopyWith<$Res> {
  _$StrategicInsightCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? observation = null,
    Object? recommendation = null,
    Object? impact = null,
    Object? priority = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      observation: null == observation
          ? _value.observation
          : observation // ignore: cast_nullable_to_non_nullable
              as String,
      recommendation: null == recommendation
          ? _value.recommendation
          : recommendation // ignore: cast_nullable_to_non_nullable
              as String,
      impact: null == impact
          ? _value.impact
          : impact // ignore: cast_nullable_to_non_nullable
              as InsightImpact,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StrategicInsightImplCopyWith<$Res>
    implements $StrategicInsightCopyWith<$Res> {
  factory _$$StrategicInsightImplCopyWith(_$StrategicInsightImpl value,
          $Res Function(_$StrategicInsightImpl) then) =
      __$$StrategicInsightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String observation,
      String recommendation,
      InsightImpact impact,
      String priority});
}

/// @nodoc
class __$$StrategicInsightImplCopyWithImpl<$Res>
    extends _$StrategicInsightCopyWithImpl<$Res, _$StrategicInsightImpl>
    implements _$$StrategicInsightImplCopyWith<$Res> {
  __$$StrategicInsightImplCopyWithImpl(_$StrategicInsightImpl _value,
      $Res Function(_$StrategicInsightImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? observation = null,
    Object? recommendation = null,
    Object? impact = null,
    Object? priority = null,
  }) {
    return _then(_$StrategicInsightImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      observation: null == observation
          ? _value.observation
          : observation // ignore: cast_nullable_to_non_nullable
              as String,
      recommendation: null == recommendation
          ? _value.recommendation
          : recommendation // ignore: cast_nullable_to_non_nullable
              as String,
      impact: null == impact
          ? _value.impact
          : impact // ignore: cast_nullable_to_non_nullable
              as InsightImpact,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StrategicInsightImpl implements _StrategicInsight {
  const _$StrategicInsightImpl(
      {required this.title,
      required this.observation,
      required this.recommendation,
      required this.impact,
      required this.priority});

  factory _$StrategicInsightImpl.fromJson(Map<String, dynamic> json) =>
      _$$StrategicInsightImplFromJson(json);

  /// Short title of the insight.
  @override
  final String title;

  /// Detailed observation based on data trends.
  @override
  final String observation;

  /// Actionable recommendation for the user.
  @override
  final String recommendation;

  /// Impact level (positive, negative, neutral).
  @override
  final InsightImpact impact;

  /// Priority level ('high', 'medium', 'low').
  @override
  final String priority;

  @override
  String toString() {
    return 'StrategicInsight(title: $title, observation: $observation, recommendation: $recommendation, impact: $impact, priority: $priority)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StrategicInsightImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.observation, observation) ||
                other.observation == observation) &&
            (identical(other.recommendation, recommendation) ||
                other.recommendation == recommendation) &&
            (identical(other.impact, impact) || other.impact == impact) &&
            (identical(other.priority, priority) ||
                other.priority == priority));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, title, observation, recommendation, impact, priority);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StrategicInsightImplCopyWith<_$StrategicInsightImpl> get copyWith =>
      __$$StrategicInsightImplCopyWithImpl<_$StrategicInsightImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StrategicInsightImplToJson(
      this,
    );
  }
}

abstract class _StrategicInsight implements StrategicInsight {
  const factory _StrategicInsight(
      {required final String title,
      required final String observation,
      required final String recommendation,
      required final InsightImpact impact,
      required final String priority}) = _$StrategicInsightImpl;

  factory _StrategicInsight.fromJson(Map<String, dynamic> json) =
      _$StrategicInsightImpl.fromJson;

  @override

  /// Short title of the insight.
  String get title;
  @override

  /// Detailed observation based on data trends.
  String get observation;
  @override

  /// Actionable recommendation for the user.
  String get recommendation;
  @override

  /// Impact level (positive, negative, neutral).
  InsightImpact get impact;
  @override

  /// Priority level ('high', 'medium', 'low').
  String get priority;
  @override
  @JsonKey(ignore: true)
  _$$StrategicInsightImplCopyWith<_$StrategicInsightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
