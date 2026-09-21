// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounting_agent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AgentResult {
  /// Unique identifier of the processing agent (e.g., "agent-3-forensic").
  String get agentId => throw _privateConstructorUsedError;

  /// Final accounting verdict: true if compliant, false if rejected.
  bool get isAllowed => throw _privateConstructorUsedError;

  /// Deep scientific or regulatory rationale explaining the decision.
  String get rationale => throw _privateConstructorUsedError;

  /// Statistical confidence in the outcome (0.0 to 1.0).
  double get confidenceScore => throw _privateConstructorUsedError;

  /// Optional AI-driven modifications to improve entry accuracy or
  /// compliance.
  Map<String, dynamic>? get suggestedAdjustments =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AgentResultCopyWith<AgentResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AgentResultCopyWith<$Res> {
  factory $AgentResultCopyWith(
          AgentResult value, $Res Function(AgentResult) then) =
      _$AgentResultCopyWithImpl<$Res, AgentResult>;
  @useResult
  $Res call(
      {String agentId,
      bool isAllowed,
      String rationale,
      double confidenceScore,
      Map<String, dynamic>? suggestedAdjustments});
}

/// @nodoc
class _$AgentResultCopyWithImpl<$Res, $Val extends AgentResult>
    implements $AgentResultCopyWith<$Res> {
  _$AgentResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? agentId = null,
    Object? isAllowed = null,
    Object? rationale = null,
    Object? confidenceScore = null,
    Object? suggestedAdjustments = freezed,
  }) {
    return _then(_value.copyWith(
      agentId: null == agentId
          ? _value.agentId
          : agentId // ignore: cast_nullable_to_non_nullable
              as String,
      isAllowed: null == isAllowed
          ? _value.isAllowed
          : isAllowed // ignore: cast_nullable_to_non_nullable
              as bool,
      rationale: null == rationale
          ? _value.rationale
          : rationale // ignore: cast_nullable_to_non_nullable
              as String,
      confidenceScore: null == confidenceScore
          ? _value.confidenceScore
          : confidenceScore // ignore: cast_nullable_to_non_nullable
              as double,
      suggestedAdjustments: freezed == suggestedAdjustments
          ? _value.suggestedAdjustments
          : suggestedAdjustments // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AgentResultImplCopyWith<$Res>
    implements $AgentResultCopyWith<$Res> {
  factory _$$AgentResultImplCopyWith(
          _$AgentResultImpl value, $Res Function(_$AgentResultImpl) then) =
      __$$AgentResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String agentId,
      bool isAllowed,
      String rationale,
      double confidenceScore,
      Map<String, dynamic>? suggestedAdjustments});
}

/// @nodoc
class __$$AgentResultImplCopyWithImpl<$Res>
    extends _$AgentResultCopyWithImpl<$Res, _$AgentResultImpl>
    implements _$$AgentResultImplCopyWith<$Res> {
  __$$AgentResultImplCopyWithImpl(
      _$AgentResultImpl _value, $Res Function(_$AgentResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? agentId = null,
    Object? isAllowed = null,
    Object? rationale = null,
    Object? confidenceScore = null,
    Object? suggestedAdjustments = freezed,
  }) {
    return _then(_$AgentResultImpl(
      agentId: null == agentId
          ? _value.agentId
          : agentId // ignore: cast_nullable_to_non_nullable
              as String,
      isAllowed: null == isAllowed
          ? _value.isAllowed
          : isAllowed // ignore: cast_nullable_to_non_nullable
              as bool,
      rationale: null == rationale
          ? _value.rationale
          : rationale // ignore: cast_nullable_to_non_nullable
              as String,
      confidenceScore: null == confidenceScore
          ? _value.confidenceScore
          : confidenceScore // ignore: cast_nullable_to_non_nullable
              as double,
      suggestedAdjustments: freezed == suggestedAdjustments
          ? _value._suggestedAdjustments
          : suggestedAdjustments // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$AgentResultImpl implements _AgentResult {
  const _$AgentResultImpl(
      {required this.agentId,
      required this.isAllowed,
      required this.rationale,
      required this.confidenceScore,
      final Map<String, dynamic>? suggestedAdjustments})
      : _suggestedAdjustments = suggestedAdjustments;

  /// Unique identifier of the processing agent (e.g., "agent-3-forensic").
  @override
  final String agentId;

  /// Final accounting verdict: true if compliant, false if rejected.
  @override
  final bool isAllowed;

  /// Deep scientific or regulatory rationale explaining the decision.
  @override
  final String rationale;

  /// Statistical confidence in the outcome (0.0 to 1.0).
  @override
  final double confidenceScore;

  /// Optional AI-driven modifications to improve entry accuracy or
  /// compliance.
  final Map<String, dynamic>? _suggestedAdjustments;

  /// Optional AI-driven modifications to improve entry accuracy or
  /// compliance.
  @override
  Map<String, dynamic>? get suggestedAdjustments {
    final value = _suggestedAdjustments;
    if (value == null) return null;
    if (_suggestedAdjustments is EqualUnmodifiableMapView)
      return _suggestedAdjustments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'AgentResult(agentId: $agentId, isAllowed: $isAllowed, rationale: $rationale, confidenceScore: $confidenceScore, suggestedAdjustments: $suggestedAdjustments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AgentResultImpl &&
            (identical(other.agentId, agentId) || other.agentId == agentId) &&
            (identical(other.isAllowed, isAllowed) ||
                other.isAllowed == isAllowed) &&
            (identical(other.rationale, rationale) ||
                other.rationale == rationale) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore) &&
            const DeepCollectionEquality()
                .equals(other._suggestedAdjustments, _suggestedAdjustments));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      agentId,
      isAllowed,
      rationale,
      confidenceScore,
      const DeepCollectionEquality().hash(_suggestedAdjustments));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AgentResultImplCopyWith<_$AgentResultImpl> get copyWith =>
      __$$AgentResultImplCopyWithImpl<_$AgentResultImpl>(this, _$identity);
}

abstract class _AgentResult implements AgentResult {
  const factory _AgentResult(
      {required final String agentId,
      required final bool isAllowed,
      required final String rationale,
      required final double confidenceScore,
      final Map<String, dynamic>? suggestedAdjustments}) = _$AgentResultImpl;

  @override

  /// Unique identifier of the processing agent (e.g., "agent-3-forensic").
  String get agentId;
  @override

  /// Final accounting verdict: true if compliant, false if rejected.
  bool get isAllowed;
  @override

  /// Deep scientific or regulatory rationale explaining the decision.
  String get rationale;
  @override

  /// Statistical confidence in the outcome (0.0 to 1.0).
  double get confidenceScore;
  @override

  /// Optional AI-driven modifications to improve entry accuracy or
  /// compliance.
  Map<String, dynamic>? get suggestedAdjustments;
  @override
  @JsonKey(ignore: true)
  _$$AgentResultImplCopyWith<_$AgentResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AccountingContext {
  /// The unposted journal entry currently under review.
  JournalEntry get proposedJournalEntry => throw _privateConstructorUsedError;

  /// Abstract nature of the transaction (e.g., "sales", "payroll").
  String get transactionType => throw _privateConstructorUsedError;

  /// The user's current locale for providing localized reasoning.
  String get locale => throw _privateConstructorUsedError;

  /// If true, the agent must verify climate/social disclosure compliance.
  bool get isSustainabilityRequired => throw _privateConstructorUsedError;

  /// Collection of attached ISSB quantitative measures.
  List<SustainabilityMetric>? get sustainabilityMetrics =>
      throw _privateConstructorUsedError;

  /// Extended operational or regulatory metadata.
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AccountingContextCopyWith<AccountingContext> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountingContextCopyWith<$Res> {
  factory $AccountingContextCopyWith(
          AccountingContext value, $Res Function(AccountingContext) then) =
      _$AccountingContextCopyWithImpl<$Res, AccountingContext>;
  @useResult
  $Res call(
      {JournalEntry proposedJournalEntry,
      String transactionType,
      String locale,
      bool isSustainabilityRequired,
      List<SustainabilityMetric>? sustainabilityMetrics,
      Map<String, dynamic> metadata});

  $JournalEntryCopyWith<$Res> get proposedJournalEntry;
}

/// @nodoc
class _$AccountingContextCopyWithImpl<$Res, $Val extends AccountingContext>
    implements $AccountingContextCopyWith<$Res> {
  _$AccountingContextCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? proposedJournalEntry = null,
    Object? transactionType = null,
    Object? locale = null,
    Object? isSustainabilityRequired = null,
    Object? sustainabilityMetrics = freezed,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      proposedJournalEntry: null == proposedJournalEntry
          ? _value.proposedJournalEntry
          : proposedJournalEntry // ignore: cast_nullable_to_non_nullable
              as JournalEntry,
      transactionType: null == transactionType
          ? _value.transactionType
          : transactionType // ignore: cast_nullable_to_non_nullable
              as String,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      isSustainabilityRequired: null == isSustainabilityRequired
          ? _value.isSustainabilityRequired
          : isSustainabilityRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      sustainabilityMetrics: freezed == sustainabilityMetrics
          ? _value.sustainabilityMetrics
          : sustainabilityMetrics // ignore: cast_nullable_to_non_nullable
              as List<SustainabilityMetric>?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $JournalEntryCopyWith<$Res> get proposedJournalEntry {
    return $JournalEntryCopyWith<$Res>(_value.proposedJournalEntry, (value) {
      return _then(_value.copyWith(proposedJournalEntry: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AccountingContextImplCopyWith<$Res>
    implements $AccountingContextCopyWith<$Res> {
  factory _$$AccountingContextImplCopyWith(_$AccountingContextImpl value,
          $Res Function(_$AccountingContextImpl) then) =
      __$$AccountingContextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {JournalEntry proposedJournalEntry,
      String transactionType,
      String locale,
      bool isSustainabilityRequired,
      List<SustainabilityMetric>? sustainabilityMetrics,
      Map<String, dynamic> metadata});

  @override
  $JournalEntryCopyWith<$Res> get proposedJournalEntry;
}

/// @nodoc
class __$$AccountingContextImplCopyWithImpl<$Res>
    extends _$AccountingContextCopyWithImpl<$Res, _$AccountingContextImpl>
    implements _$$AccountingContextImplCopyWith<$Res> {
  __$$AccountingContextImplCopyWithImpl(_$AccountingContextImpl _value,
      $Res Function(_$AccountingContextImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? proposedJournalEntry = null,
    Object? transactionType = null,
    Object? locale = null,
    Object? isSustainabilityRequired = null,
    Object? sustainabilityMetrics = freezed,
    Object? metadata = null,
  }) {
    return _then(_$AccountingContextImpl(
      proposedJournalEntry: null == proposedJournalEntry
          ? _value.proposedJournalEntry
          : proposedJournalEntry // ignore: cast_nullable_to_non_nullable
              as JournalEntry,
      transactionType: null == transactionType
          ? _value.transactionType
          : transactionType // ignore: cast_nullable_to_non_nullable
              as String,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      isSustainabilityRequired: null == isSustainabilityRequired
          ? _value.isSustainabilityRequired
          : isSustainabilityRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      sustainabilityMetrics: freezed == sustainabilityMetrics
          ? _value._sustainabilityMetrics
          : sustainabilityMetrics // ignore: cast_nullable_to_non_nullable
              as List<SustainabilityMetric>?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class _$AccountingContextImpl implements _AccountingContext {
  const _$AccountingContextImpl(
      {required this.proposedJournalEntry,
      required this.transactionType,
      this.locale = 'ar',
      this.isSustainabilityRequired = false,
      final List<SustainabilityMetric>? sustainabilityMetrics,
      final Map<String, dynamic> metadata = const {}})
      : _sustainabilityMetrics = sustainabilityMetrics,
        _metadata = metadata;

  /// The unposted journal entry currently under review.
  @override
  final JournalEntry proposedJournalEntry;

  /// Abstract nature of the transaction (e.g., "sales", "payroll").
  @override
  final String transactionType;

  /// The user's current locale for providing localized reasoning.
  @override
  @JsonKey()
  final String locale;

  /// If true, the agent must verify climate/social disclosure compliance.
  @override
  @JsonKey()
  final bool isSustainabilityRequired;

  /// Collection of attached ISSB quantitative measures.
  final List<SustainabilityMetric>? _sustainabilityMetrics;

  /// Collection of attached ISSB quantitative measures.
  @override
  List<SustainabilityMetric>? get sustainabilityMetrics {
    final value = _sustainabilityMetrics;
    if (value == null) return null;
    if (_sustainabilityMetrics is EqualUnmodifiableListView)
      return _sustainabilityMetrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Extended operational or regulatory metadata.
  final Map<String, dynamic> _metadata;

  /// Extended operational or regulatory metadata.
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'AccountingContext(proposedJournalEntry: $proposedJournalEntry, transactionType: $transactionType, locale: $locale, isSustainabilityRequired: $isSustainabilityRequired, sustainabilityMetrics: $sustainabilityMetrics, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountingContextImpl &&
            (identical(other.proposedJournalEntry, proposedJournalEntry) ||
                other.proposedJournalEntry == proposedJournalEntry) &&
            (identical(other.transactionType, transactionType) ||
                other.transactionType == transactionType) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(
                    other.isSustainabilityRequired, isSustainabilityRequired) ||
                other.isSustainabilityRequired == isSustainabilityRequired) &&
            const DeepCollectionEquality()
                .equals(other._sustainabilityMetrics, _sustainabilityMetrics) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      proposedJournalEntry,
      transactionType,
      locale,
      isSustainabilityRequired,
      const DeepCollectionEquality().hash(_sustainabilityMetrics),
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountingContextImplCopyWith<_$AccountingContextImpl> get copyWith =>
      __$$AccountingContextImplCopyWithImpl<_$AccountingContextImpl>(
          this, _$identity);
}

abstract class _AccountingContext implements AccountingContext {
  const factory _AccountingContext(
      {required final JournalEntry proposedJournalEntry,
      required final String transactionType,
      final String locale,
      final bool isSustainabilityRequired,
      final List<SustainabilityMetric>? sustainabilityMetrics,
      final Map<String, dynamic> metadata}) = _$AccountingContextImpl;

  @override

  /// The unposted journal entry currently under review.
  JournalEntry get proposedJournalEntry;
  @override

  /// Abstract nature of the transaction (e.g., "sales", "payroll").
  String get transactionType;
  @override

  /// The user's current locale for providing localized reasoning.
  String get locale;
  @override

  /// If true, the agent must verify climate/social disclosure compliance.
  bool get isSustainabilityRequired;
  @override

  /// Collection of attached ISSB quantitative measures.
  List<SustainabilityMetric>? get sustainabilityMetrics;
  @override

  /// Extended operational or regulatory metadata.
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$AccountingContextImplCopyWith<_$AccountingContextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
