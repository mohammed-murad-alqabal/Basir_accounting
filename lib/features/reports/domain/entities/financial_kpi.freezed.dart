// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_kpi.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AgentInsight _$AgentInsightFromJson(Map<String, dynamic> json) {
  return _AgentInsight.fromJson(json);
}

/// @nodoc
mixin _$AgentInsight {
  String get id => throw _privateConstructorUsedError;
  AgentSource get source => throw _privateConstructorUsedError;
  InsightRiskLevel get riskLevel => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  String? get actionLabel => throw _privateConstructorUsedError;
  String? get actionRoute => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AgentInsightCopyWith<AgentInsight> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AgentInsightCopyWith<$Res> {
  factory $AgentInsightCopyWith(
          AgentInsight value, $Res Function(AgentInsight) then) =
      _$AgentInsightCopyWithImpl<$Res, AgentInsight>;
  @useResult
  $Res call(
      {String id,
      AgentSource source,
      InsightRiskLevel riskLevel,
      String title,
      String description,
      DateTime timestamp,
      Map<String, dynamic>? metadata,
      String? actionLabel,
      String? actionRoute});
}

/// @nodoc
class _$AgentInsightCopyWithImpl<$Res, $Val extends AgentInsight>
    implements $AgentInsightCopyWith<$Res> {
  _$AgentInsightCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? source = null,
    Object? riskLevel = null,
    Object? title = null,
    Object? description = null,
    Object? timestamp = null,
    Object? metadata = freezed,
    Object? actionLabel = freezed,
    Object? actionRoute = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as AgentSource,
      riskLevel: null == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as InsightRiskLevel,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      actionLabel: freezed == actionLabel
          ? _value.actionLabel
          : actionLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      actionRoute: freezed == actionRoute
          ? _value.actionRoute
          : actionRoute // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AgentInsightImplCopyWith<$Res>
    implements $AgentInsightCopyWith<$Res> {
  factory _$$AgentInsightImplCopyWith(
          _$AgentInsightImpl value, $Res Function(_$AgentInsightImpl) then) =
      __$$AgentInsightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      AgentSource source,
      InsightRiskLevel riskLevel,
      String title,
      String description,
      DateTime timestamp,
      Map<String, dynamic>? metadata,
      String? actionLabel,
      String? actionRoute});
}

/// @nodoc
class __$$AgentInsightImplCopyWithImpl<$Res>
    extends _$AgentInsightCopyWithImpl<$Res, _$AgentInsightImpl>
    implements _$$AgentInsightImplCopyWith<$Res> {
  __$$AgentInsightImplCopyWithImpl(
      _$AgentInsightImpl _value, $Res Function(_$AgentInsightImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? source = null,
    Object? riskLevel = null,
    Object? title = null,
    Object? description = null,
    Object? timestamp = null,
    Object? metadata = freezed,
    Object? actionLabel = freezed,
    Object? actionRoute = freezed,
  }) {
    return _then(_$AgentInsightImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as AgentSource,
      riskLevel: null == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as InsightRiskLevel,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      actionLabel: freezed == actionLabel
          ? _value.actionLabel
          : actionLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      actionRoute: freezed == actionRoute
          ? _value.actionRoute
          : actionRoute // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AgentInsightImpl implements _AgentInsight {
  const _$AgentInsightImpl(
      {required this.id,
      required this.source,
      required this.riskLevel,
      required this.title,
      required this.description,
      required this.timestamp,
      final Map<String, dynamic>? metadata,
      this.actionLabel,
      this.actionRoute})
      : _metadata = metadata;

  factory _$AgentInsightImpl.fromJson(Map<String, dynamic> json) =>
      _$$AgentInsightImplFromJson(json);

  @override
  final String id;
  @override
  final AgentSource source;
  @override
  final InsightRiskLevel riskLevel;
  @override
  final String title;
  @override
  final String description;
  @override
  final DateTime timestamp;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? actionLabel;
  @override
  final String? actionRoute;

  @override
  String toString() {
    return 'AgentInsight(id: $id, source: $source, riskLevel: $riskLevel, title: $title, description: $description, timestamp: $timestamp, metadata: $metadata, actionLabel: $actionLabel, actionRoute: $actionRoute)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AgentInsightImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.riskLevel, riskLevel) ||
                other.riskLevel == riskLevel) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.actionLabel, actionLabel) ||
                other.actionLabel == actionLabel) &&
            (identical(other.actionRoute, actionRoute) ||
                other.actionRoute == actionRoute));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      source,
      riskLevel,
      title,
      description,
      timestamp,
      const DeepCollectionEquality().hash(_metadata),
      actionLabel,
      actionRoute);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AgentInsightImplCopyWith<_$AgentInsightImpl> get copyWith =>
      __$$AgentInsightImplCopyWithImpl<_$AgentInsightImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AgentInsightImplToJson(
      this,
    );
  }
}

abstract class _AgentInsight implements AgentInsight {
  const factory _AgentInsight(
      {required final String id,
      required final AgentSource source,
      required final InsightRiskLevel riskLevel,
      required final String title,
      required final String description,
      required final DateTime timestamp,
      final Map<String, dynamic>? metadata,
      final String? actionLabel,
      final String? actionRoute}) = _$AgentInsightImpl;

  factory _AgentInsight.fromJson(Map<String, dynamic> json) =
      _$AgentInsightImpl.fromJson;

  @override
  String get id;
  @override
  AgentSource get source;
  @override
  InsightRiskLevel get riskLevel;
  @override
  String get title;
  @override
  String get description;
  @override
  DateTime get timestamp;
  @override
  Map<String, dynamic>? get metadata;
  @override
  String? get actionLabel;
  @override
  String? get actionRoute;
  @override
  @JsonKey(ignore: true)
  _$$AgentInsightImplCopyWith<_$AgentInsightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FinancialKpi _$FinancialKpiFromJson(Map<String, dynamic> json) {
  return _FinancialKpi.fromJson(json);
}

/// @nodoc
mixin _$FinancialKpi {
  /// اسم المؤشر
  String get name => throw _privateConstructorUsedError;

  /// قيمة المؤشر
  double get value => throw _privateConstructorUsedError;

  /// وحدة القياس (مثل % أو SAR)
  String get unit => throw _privateConstructorUsedError;

  /// الاتجاه (التغير المئوي عن الفترة السابقة)
  double get trend => throw _privateConstructorUsedError;

  /// الحالة الصحية للمؤشر
  KpiHealth get health => throw _privateConstructorUsedError;

  /// وصف أو تحليل للمؤشر
  String get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FinancialKpiCopyWith<FinancialKpi> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialKpiCopyWith<$Res> {
  factory $FinancialKpiCopyWith(
          FinancialKpi value, $Res Function(FinancialKpi) then) =
      _$FinancialKpiCopyWithImpl<$Res, FinancialKpi>;
  @useResult
  $Res call(
      {String name,
      double value,
      String unit,
      double trend,
      KpiHealth health,
      String description});
}

/// @nodoc
class _$FinancialKpiCopyWithImpl<$Res, $Val extends FinancialKpi>
    implements $FinancialKpiCopyWith<$Res> {
  _$FinancialKpiCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
    Object? unit = null,
    Object? trend = null,
    Object? health = null,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      trend: null == trend
          ? _value.trend
          : trend // ignore: cast_nullable_to_non_nullable
              as double,
      health: null == health
          ? _value.health
          : health // ignore: cast_nullable_to_non_nullable
              as KpiHealth,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FinancialKpiImplCopyWith<$Res>
    implements $FinancialKpiCopyWith<$Res> {
  factory _$$FinancialKpiImplCopyWith(
          _$FinancialKpiImpl value, $Res Function(_$FinancialKpiImpl) then) =
      __$$FinancialKpiImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      double value,
      String unit,
      double trend,
      KpiHealth health,
      String description});
}

/// @nodoc
class __$$FinancialKpiImplCopyWithImpl<$Res>
    extends _$FinancialKpiCopyWithImpl<$Res, _$FinancialKpiImpl>
    implements _$$FinancialKpiImplCopyWith<$Res> {
  __$$FinancialKpiImplCopyWithImpl(
      _$FinancialKpiImpl _value, $Res Function(_$FinancialKpiImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
    Object? unit = null,
    Object? trend = null,
    Object? health = null,
    Object? description = null,
  }) {
    return _then(_$FinancialKpiImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      trend: null == trend
          ? _value.trend
          : trend // ignore: cast_nullable_to_non_nullable
              as double,
      health: null == health
          ? _value.health
          : health // ignore: cast_nullable_to_non_nullable
              as KpiHealth,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancialKpiImpl implements _FinancialKpi {
  const _$FinancialKpiImpl(
      {required this.name,
      required this.value,
      required this.unit,
      required this.trend,
      required this.health,
      required this.description});

  factory _$FinancialKpiImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialKpiImplFromJson(json);

  /// اسم المؤشر
  @override
  final String name;

  /// قيمة المؤشر
  @override
  final double value;

  /// وحدة القياس (مثل % أو SAR)
  @override
  final String unit;

  /// الاتجاه (التغير المئوي عن الفترة السابقة)
  @override
  final double trend;

  /// الحالة الصحية للمؤشر
  @override
  final KpiHealth health;

  /// وصف أو تحليل للمؤشر
  @override
  final String description;

  @override
  String toString() {
    return 'FinancialKpi(name: $name, value: $value, unit: $unit, trend: $trend, health: $health, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialKpiImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.trend, trend) || other.trend == trend) &&
            (identical(other.health, health) || other.health == health) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, value, unit, trend, health, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialKpiImplCopyWith<_$FinancialKpiImpl> get copyWith =>
      __$$FinancialKpiImplCopyWithImpl<_$FinancialKpiImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialKpiImplToJson(
      this,
    );
  }
}

abstract class _FinancialKpi implements FinancialKpi {
  const factory _FinancialKpi(
      {required final String name,
      required final double value,
      required final String unit,
      required final double trend,
      required final KpiHealth health,
      required final String description}) = _$FinancialKpiImpl;

  factory _FinancialKpi.fromJson(Map<String, dynamic> json) =
      _$FinancialKpiImpl.fromJson;

  @override

  /// اسم المؤشر
  String get name;
  @override

  /// قيمة المؤشر
  double get value;
  @override

  /// وحدة القياس (مثل % أو SAR)
  String get unit;
  @override

  /// الاتجاه (التغير المئوي عن الفترة السابقة)
  double get trend;
  @override

  /// الحالة الصحية للمؤشر
  KpiHealth get health;
  @override

  /// وصف أو تحليل للمؤشر
  String get description;
  @override
  @JsonKey(ignore: true)
  _$$FinancialKpiImplCopyWith<_$FinancialKpiImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
