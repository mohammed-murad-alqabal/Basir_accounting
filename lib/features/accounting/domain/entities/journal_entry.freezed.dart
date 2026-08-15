// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TemporalJustification _$TemporalJustificationFromJson(
    Map<String, dynamic> json) {
  return _TemporalJustification.fromJson(json);
}

/// @nodoc
mixin _$TemporalJustification {
  /// The actual date the business transaction occurred.
  DateTime get transactionDate => throw _privateConstructorUsedError;

  /// The date the entry influences the financial statements (Posting Date).
  DateTime get effectiveDate => throw _privateConstructorUsedError;

  /// The system-generated timestamp of the entry creation.
  DateTime get recordingDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TemporalJustificationCopyWith<TemporalJustification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemporalJustificationCopyWith<$Res> {
  factory $TemporalJustificationCopyWith(TemporalJustification value,
          $Res Function(TemporalJustification) then) =
      _$TemporalJustificationCopyWithImpl<$Res, TemporalJustification>;
  @useResult
  $Res call(
      {DateTime transactionDate,
      DateTime effectiveDate,
      DateTime recordingDate});
}

/// @nodoc
class _$TemporalJustificationCopyWithImpl<$Res,
        $Val extends TemporalJustification>
    implements $TemporalJustificationCopyWith<$Res> {
  _$TemporalJustificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactionDate = null,
    Object? effectiveDate = null,
    Object? recordingDate = null,
  }) {
    return _then(_value.copyWith(
      transactionDate: null == transactionDate
          ? _value.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      effectiveDate: null == effectiveDate
          ? _value.effectiveDate
          : effectiveDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      recordingDate: null == recordingDate
          ? _value.recordingDate
          : recordingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TemporalJustificationImplCopyWith<$Res>
    implements $TemporalJustificationCopyWith<$Res> {
  factory _$$TemporalJustificationImplCopyWith(
          _$TemporalJustificationImpl value,
          $Res Function(_$TemporalJustificationImpl) then) =
      __$$TemporalJustificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime transactionDate,
      DateTime effectiveDate,
      DateTime recordingDate});
}

/// @nodoc
class __$$TemporalJustificationImplCopyWithImpl<$Res>
    extends _$TemporalJustificationCopyWithImpl<$Res,
        _$TemporalJustificationImpl>
    implements _$$TemporalJustificationImplCopyWith<$Res> {
  __$$TemporalJustificationImplCopyWithImpl(_$TemporalJustificationImpl _value,
      $Res Function(_$TemporalJustificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactionDate = null,
    Object? effectiveDate = null,
    Object? recordingDate = null,
  }) {
    return _then(_$TemporalJustificationImpl(
      transactionDate: null == transactionDate
          ? _value.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      effectiveDate: null == effectiveDate
          ? _value.effectiveDate
          : effectiveDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      recordingDate: null == recordingDate
          ? _value.recordingDate
          : recordingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TemporalJustificationImpl implements _TemporalJustification {
  const _$TemporalJustificationImpl(
      {required this.transactionDate,
      required this.effectiveDate,
      required this.recordingDate});

  factory _$TemporalJustificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemporalJustificationImplFromJson(json);

  /// The actual date the business transaction occurred.
  @override
  final DateTime transactionDate;

  /// The date the entry influences the financial statements (Posting Date).
  @override
  final DateTime effectiveDate;

  /// The system-generated timestamp of the entry creation.
  @override
  final DateTime recordingDate;

  @override
  String toString() {
    return 'TemporalJustification(transactionDate: $transactionDate, effectiveDate: $effectiveDate, recordingDate: $recordingDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemporalJustificationImpl &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.effectiveDate, effectiveDate) ||
                other.effectiveDate == effectiveDate) &&
            (identical(other.recordingDate, recordingDate) ||
                other.recordingDate == recordingDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, transactionDate, effectiveDate, recordingDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TemporalJustificationImplCopyWith<_$TemporalJustificationImpl>
      get copyWith => __$$TemporalJustificationImplCopyWithImpl<
          _$TemporalJustificationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TemporalJustificationImplToJson(
      this,
    );
  }
}

abstract class _TemporalJustification implements TemporalJustification {
  const factory _TemporalJustification(
      {required final DateTime transactionDate,
      required final DateTime effectiveDate,
      required final DateTime recordingDate}) = _$TemporalJustificationImpl;

  factory _TemporalJustification.fromJson(Map<String, dynamic> json) =
      _$TemporalJustificationImpl.fromJson;

  @override

  /// The actual date the business transaction occurred.
  DateTime get transactionDate;
  @override

  /// The date the entry influences the financial statements (Posting Date).
  DateTime get effectiveDate;
  @override

  /// The system-generated timestamp of the entry creation.
  DateTime get recordingDate;
  @override
  @JsonKey(ignore: true)
  _$$TemporalJustificationImplCopyWith<_$TemporalJustificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

StandardsJustification _$StandardsJustificationFromJson(
    Map<String, dynamic> json) {
  return _StandardsJustification.fromJson(json);
}

/// @nodoc
mixin _$StandardsJustification {
  /// Specific standard clause reference (e.g., "IFRS 15.35").
  String get standardReference => throw _privateConstructorUsedError;

  /// Logic for recognizing the transaction (e.g., "Cash Receipt", "Accrual").
  String? get recognitionBasis => throw _privateConstructorUsedError;

  /// Value determination method (e.g., "Amortized Cost", "Fair Value").
  String? get measurementBasis => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StandardsJustificationCopyWith<StandardsJustification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StandardsJustificationCopyWith<$Res> {
  factory $StandardsJustificationCopyWith(StandardsJustification value,
          $Res Function(StandardsJustification) then) =
      _$StandardsJustificationCopyWithImpl<$Res, StandardsJustification>;
  @useResult
  $Res call(
      {String standardReference,
      String? recognitionBasis,
      String? measurementBasis});
}

/// @nodoc
class _$StandardsJustificationCopyWithImpl<$Res,
        $Val extends StandardsJustification>
    implements $StandardsJustificationCopyWith<$Res> {
  _$StandardsJustificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? standardReference = null,
    Object? recognitionBasis = freezed,
    Object? measurementBasis = freezed,
  }) {
    return _then(_value.copyWith(
      standardReference: null == standardReference
          ? _value.standardReference
          : standardReference // ignore: cast_nullable_to_non_nullable
              as String,
      recognitionBasis: freezed == recognitionBasis
          ? _value.recognitionBasis
          : recognitionBasis // ignore: cast_nullable_to_non_nullable
              as String?,
      measurementBasis: freezed == measurementBasis
          ? _value.measurementBasis
          : measurementBasis // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StandardsJustificationImplCopyWith<$Res>
    implements $StandardsJustificationCopyWith<$Res> {
  factory _$$StandardsJustificationImplCopyWith(
          _$StandardsJustificationImpl value,
          $Res Function(_$StandardsJustificationImpl) then) =
      __$$StandardsJustificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String standardReference,
      String? recognitionBasis,
      String? measurementBasis});
}

/// @nodoc
class __$$StandardsJustificationImplCopyWithImpl<$Res>
    extends _$StandardsJustificationCopyWithImpl<$Res,
        _$StandardsJustificationImpl>
    implements _$$StandardsJustificationImplCopyWith<$Res> {
  __$$StandardsJustificationImplCopyWithImpl(
      _$StandardsJustificationImpl _value,
      $Res Function(_$StandardsJustificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? standardReference = null,
    Object? recognitionBasis = freezed,
    Object? measurementBasis = freezed,
  }) {
    return _then(_$StandardsJustificationImpl(
      standardReference: null == standardReference
          ? _value.standardReference
          : standardReference // ignore: cast_nullable_to_non_nullable
              as String,
      recognitionBasis: freezed == recognitionBasis
          ? _value.recognitionBasis
          : recognitionBasis // ignore: cast_nullable_to_non_nullable
              as String?,
      measurementBasis: freezed == measurementBasis
          ? _value.measurementBasis
          : measurementBasis // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StandardsJustificationImpl implements _StandardsJustification {
  const _$StandardsJustificationImpl(
      {required this.standardReference,
      this.recognitionBasis,
      this.measurementBasis});

  factory _$StandardsJustificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$StandardsJustificationImplFromJson(json);

  /// Specific standard clause reference (e.g., "IFRS 15.35").
  @override
  final String standardReference;

  /// Logic for recognizing the transaction (e.g., "Cash Receipt", "Accrual").
  @override
  final String? recognitionBasis;

  /// Value determination method (e.g., "Amortized Cost", "Fair Value").
  @override
  final String? measurementBasis;

  @override
  String toString() {
    return 'StandardsJustification(standardReference: $standardReference, recognitionBasis: $recognitionBasis, measurementBasis: $measurementBasis)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StandardsJustificationImpl &&
            (identical(other.standardReference, standardReference) ||
                other.standardReference == standardReference) &&
            (identical(other.recognitionBasis, recognitionBasis) ||
                other.recognitionBasis == recognitionBasis) &&
            (identical(other.measurementBasis, measurementBasis) ||
                other.measurementBasis == measurementBasis));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, standardReference, recognitionBasis, measurementBasis);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StandardsJustificationImplCopyWith<_$StandardsJustificationImpl>
      get copyWith => __$$StandardsJustificationImplCopyWithImpl<
          _$StandardsJustificationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StandardsJustificationImplToJson(
      this,
    );
  }
}

abstract class _StandardsJustification implements StandardsJustification {
  const factory _StandardsJustification(
      {required final String standardReference,
      final String? recognitionBasis,
      final String? measurementBasis}) = _$StandardsJustificationImpl;

  factory _StandardsJustification.fromJson(Map<String, dynamic> json) =
      _$StandardsJustificationImpl.fromJson;

  @override

  /// Specific standard clause reference (e.g., "IFRS 15.35").
  String get standardReference;
  @override

  /// Logic for recognizing the transaction (e.g., "Cash Receipt", "Accrual").
  String? get recognitionBasis;
  @override

  /// Value determination method (e.g., "Amortized Cost", "Fair Value").
  String? get measurementBasis;
  @override
  @JsonKey(ignore: true)
  _$$StandardsJustificationImplCopyWith<_$StandardsJustificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AuditLogEntry _$AuditLogEntryFromJson(Map<String, dynamic> json) {
  return _AuditLogEntry.fromJson(json);
}

/// @nodoc
mixin _$AuditLogEntry {
  /// Systematic timestamp of the event.
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Descriptive name of the action performed.
  String get action => throw _privateConstructorUsedError;

  /// Contextual explanation or justification for the recorded action.
  String get rationale => throw _privateConstructorUsedError;

  /// Entity responsible for the action (e.g., 'system', 'agent-ID', 'user-ID').
  String get actor => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuditLogEntryCopyWith<AuditLogEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuditLogEntryCopyWith<$Res> {
  factory $AuditLogEntryCopyWith(
          AuditLogEntry value, $Res Function(AuditLogEntry) then) =
      _$AuditLogEntryCopyWithImpl<$Res, AuditLogEntry>;
  @useResult
  $Res call(
      {DateTime timestamp, String action, String rationale, String actor});
}

/// @nodoc
class _$AuditLogEntryCopyWithImpl<$Res, $Val extends AuditLogEntry>
    implements $AuditLogEntryCopyWith<$Res> {
  _$AuditLogEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? action = null,
    Object? rationale = null,
    Object? actor = null,
  }) {
    return _then(_value.copyWith(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      rationale: null == rationale
          ? _value.rationale
          : rationale // ignore: cast_nullable_to_non_nullable
              as String,
      actor: null == actor
          ? _value.actor
          : actor // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuditLogEntryImplCopyWith<$Res>
    implements $AuditLogEntryCopyWith<$Res> {
  factory _$$AuditLogEntryImplCopyWith(
          _$AuditLogEntryImpl value, $Res Function(_$AuditLogEntryImpl) then) =
      __$$AuditLogEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime timestamp, String action, String rationale, String actor});
}

/// @nodoc
class __$$AuditLogEntryImplCopyWithImpl<$Res>
    extends _$AuditLogEntryCopyWithImpl<$Res, _$AuditLogEntryImpl>
    implements _$$AuditLogEntryImplCopyWith<$Res> {
  __$$AuditLogEntryImplCopyWithImpl(
      _$AuditLogEntryImpl _value, $Res Function(_$AuditLogEntryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? action = null,
    Object? rationale = null,
    Object? actor = null,
  }) {
    return _then(_$AuditLogEntryImpl(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      rationale: null == rationale
          ? _value.rationale
          : rationale // ignore: cast_nullable_to_non_nullable
              as String,
      actor: null == actor
          ? _value.actor
          : actor // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuditLogEntryImpl implements _AuditLogEntry {
  const _$AuditLogEntryImpl(
      {required this.timestamp,
      required this.action,
      required this.rationale,
      required this.actor});

  factory _$AuditLogEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuditLogEntryImplFromJson(json);

  /// Systematic timestamp of the event.
  @override
  final DateTime timestamp;

  /// Descriptive name of the action performed.
  @override
  final String action;

  /// Contextual explanation or justification for the recorded action.
  @override
  final String rationale;

  /// Entity responsible for the action (e.g., 'system', 'agent-ID', 'user-ID').
  @override
  final String actor;

  @override
  String toString() {
    return 'AuditLogEntry(timestamp: $timestamp, action: $action, rationale: $rationale, actor: $actor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuditLogEntryImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.rationale, rationale) ||
                other.rationale == rationale) &&
            (identical(other.actor, actor) || other.actor == actor));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, timestamp, action, rationale, actor);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuditLogEntryImplCopyWith<_$AuditLogEntryImpl> get copyWith =>
      __$$AuditLogEntryImplCopyWithImpl<_$AuditLogEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuditLogEntryImplToJson(
      this,
    );
  }
}

abstract class _AuditLogEntry implements AuditLogEntry {
  const factory _AuditLogEntry(
      {required final DateTime timestamp,
      required final String action,
      required final String rationale,
      required final String actor}) = _$AuditLogEntryImpl;

  factory _AuditLogEntry.fromJson(Map<String, dynamic> json) =
      _$AuditLogEntryImpl.fromJson;

  @override

  /// Systematic timestamp of the event.
  DateTime get timestamp;
  @override

  /// Descriptive name of the action performed.
  String get action;
  @override

  /// Contextual explanation or justification for the recorded action.
  String get rationale;
  @override

  /// Entity responsible for the action (e.g., 'system', 'agent-ID', 'user-ID').
  String get actor;
  @override
  @JsonKey(ignore: true)
  _$$AuditLogEntryImplCopyWith<_$AuditLogEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

JournalEntryLine _$JournalEntryLineFromJson(Map<String, dynamic> json) {
  return _JournalEntryLine.fromJson(json);
}

/// @nodoc
mixin _$JournalEntryLine {
  /// Reference to the target [Account] ID.
  String get accountId => throw _privateConstructorUsedError;

  /// Denormalized account name for high-performance listing and audit.
  String get accountName => throw _privateConstructorUsedError;

  /// Positive increase for Debit-nature accounts.
  Decimal get debit => throw _privateConstructorUsedError;

  /// Positive increase for Credit-nature accounts.
  Decimal get credit => throw _privateConstructorUsedError;

  /// Line-specific memo or explanation.
  String? get description => throw _privateConstructorUsedError;

  /// Direct link to source documentation (e.g., Invoice #, Receipt ID).
  /// (Standard Reference: CP-009: Traceability)
  String? get sourceDocumentRef => throw _privateConstructorUsedError;

  /// Cost center identifier for management accounting attribution.
  String? get costCenterId => throw _privateConstructorUsedError;

  /// ISO currency code for multi-currency transactions.
  String? get originalCurrency => throw _privateConstructorUsedError;

  /// Spot exchange rate at the time of recording.
  Decimal? get exchangeRate => throw _privateConstructorUsedError;

  /// Original amount in the source currency before conversion.
  Decimal? get originalAmount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $JournalEntryLineCopyWith<JournalEntryLine> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JournalEntryLineCopyWith<$Res> {
  factory $JournalEntryLineCopyWith(
          JournalEntryLine value, $Res Function(JournalEntryLine) then) =
      _$JournalEntryLineCopyWithImpl<$Res, JournalEntryLine>;
  @useResult
  $Res call(
      {String accountId,
      String accountName,
      Decimal debit,
      Decimal credit,
      String? description,
      String? sourceDocumentRef,
      String? costCenterId,
      String? originalCurrency,
      Decimal? exchangeRate,
      Decimal? originalAmount});
}

/// @nodoc
class _$JournalEntryLineCopyWithImpl<$Res, $Val extends JournalEntryLine>
    implements $JournalEntryLineCopyWith<$Res> {
  _$JournalEntryLineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? accountName = null,
    Object? debit = null,
    Object? credit = null,
    Object? description = freezed,
    Object? sourceDocumentRef = freezed,
    Object? costCenterId = freezed,
    Object? originalCurrency = freezed,
    Object? exchangeRate = freezed,
    Object? originalAmount = freezed,
  }) {
    return _then(_value.copyWith(
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      debit: null == debit
          ? _value.debit
          : debit // ignore: cast_nullable_to_non_nullable
              as Decimal,
      credit: null == credit
          ? _value.credit
          : credit // ignore: cast_nullable_to_non_nullable
              as Decimal,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      sourceDocumentRef: freezed == sourceDocumentRef
          ? _value.sourceDocumentRef
          : sourceDocumentRef // ignore: cast_nullable_to_non_nullable
              as String?,
      costCenterId: freezed == costCenterId
          ? _value.costCenterId
          : costCenterId // ignore: cast_nullable_to_non_nullable
              as String?,
      originalCurrency: freezed == originalCurrency
          ? _value.originalCurrency
          : originalCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      exchangeRate: freezed == exchangeRate
          ? _value.exchangeRate
          : exchangeRate // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      originalAmount: freezed == originalAmount
          ? _value.originalAmount
          : originalAmount // ignore: cast_nullable_to_non_nullable
              as Decimal?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JournalEntryLineImplCopyWith<$Res>
    implements $JournalEntryLineCopyWith<$Res> {
  factory _$$JournalEntryLineImplCopyWith(_$JournalEntryLineImpl value,
          $Res Function(_$JournalEntryLineImpl) then) =
      __$$JournalEntryLineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String accountId,
      String accountName,
      Decimal debit,
      Decimal credit,
      String? description,
      String? sourceDocumentRef,
      String? costCenterId,
      String? originalCurrency,
      Decimal? exchangeRate,
      Decimal? originalAmount});
}

/// @nodoc
class __$$JournalEntryLineImplCopyWithImpl<$Res>
    extends _$JournalEntryLineCopyWithImpl<$Res, _$JournalEntryLineImpl>
    implements _$$JournalEntryLineImplCopyWith<$Res> {
  __$$JournalEntryLineImplCopyWithImpl(_$JournalEntryLineImpl _value,
      $Res Function(_$JournalEntryLineImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? accountName = null,
    Object? debit = null,
    Object? credit = null,
    Object? description = freezed,
    Object? sourceDocumentRef = freezed,
    Object? costCenterId = freezed,
    Object? originalCurrency = freezed,
    Object? exchangeRate = freezed,
    Object? originalAmount = freezed,
  }) {
    return _then(_$JournalEntryLineImpl(
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      debit: null == debit
          ? _value.debit
          : debit // ignore: cast_nullable_to_non_nullable
              as Decimal,
      credit: null == credit
          ? _value.credit
          : credit // ignore: cast_nullable_to_non_nullable
              as Decimal,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      sourceDocumentRef: freezed == sourceDocumentRef
          ? _value.sourceDocumentRef
          : sourceDocumentRef // ignore: cast_nullable_to_non_nullable
              as String?,
      costCenterId: freezed == costCenterId
          ? _value.costCenterId
          : costCenterId // ignore: cast_nullable_to_non_nullable
              as String?,
      originalCurrency: freezed == originalCurrency
          ? _value.originalCurrency
          : originalCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      exchangeRate: freezed == exchangeRate
          ? _value.exchangeRate
          : exchangeRate // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      originalAmount: freezed == originalAmount
          ? _value.originalAmount
          : originalAmount // ignore: cast_nullable_to_non_nullable
              as Decimal?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JournalEntryLineImpl implements _JournalEntryLine {
  const _$JournalEntryLineImpl(
      {required this.accountId,
      required this.accountName,
      required this.debit,
      required this.credit,
      this.description,
      this.sourceDocumentRef,
      this.costCenterId,
      this.originalCurrency,
      this.exchangeRate,
      this.originalAmount});

  factory _$JournalEntryLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$JournalEntryLineImplFromJson(json);

  /// Reference to the target [Account] ID.
  @override
  final String accountId;

  /// Denormalized account name for high-performance listing and audit.
  @override
  final String accountName;

  /// Positive increase for Debit-nature accounts.
  @override
  final Decimal debit;

  /// Positive increase for Credit-nature accounts.
  @override
  final Decimal credit;

  /// Line-specific memo or explanation.
  @override
  final String? description;

  /// Direct link to source documentation (e.g., Invoice #, Receipt ID).
  /// (Standard Reference: CP-009: Traceability)
  @override
  final String? sourceDocumentRef;

  /// Cost center identifier for management accounting attribution.
  @override
  final String? costCenterId;

  /// ISO currency code for multi-currency transactions.
  @override
  final String? originalCurrency;

  /// Spot exchange rate at the time of recording.
  @override
  final Decimal? exchangeRate;

  /// Original amount in the source currency before conversion.
  @override
  final Decimal? originalAmount;

  @override
  String toString() {
    return 'JournalEntryLine(accountId: $accountId, accountName: $accountName, debit: $debit, credit: $credit, description: $description, sourceDocumentRef: $sourceDocumentRef, costCenterId: $costCenterId, originalCurrency: $originalCurrency, exchangeRate: $exchangeRate, originalAmount: $originalAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JournalEntryLineImpl &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.debit, debit) || other.debit == debit) &&
            (identical(other.credit, credit) || other.credit == credit) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sourceDocumentRef, sourceDocumentRef) ||
                other.sourceDocumentRef == sourceDocumentRef) &&
            (identical(other.costCenterId, costCenterId) ||
                other.costCenterId == costCenterId) &&
            (identical(other.originalCurrency, originalCurrency) ||
                other.originalCurrency == originalCurrency) &&
            (identical(other.exchangeRate, exchangeRate) ||
                other.exchangeRate == exchangeRate) &&
            (identical(other.originalAmount, originalAmount) ||
                other.originalAmount == originalAmount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      accountId,
      accountName,
      debit,
      credit,
      description,
      sourceDocumentRef,
      costCenterId,
      originalCurrency,
      exchangeRate,
      originalAmount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$JournalEntryLineImplCopyWith<_$JournalEntryLineImpl> get copyWith =>
      __$$JournalEntryLineImplCopyWithImpl<_$JournalEntryLineImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JournalEntryLineImplToJson(
      this,
    );
  }
}

abstract class _JournalEntryLine implements JournalEntryLine {
  const factory _JournalEntryLine(
      {required final String accountId,
      required final String accountName,
      required final Decimal debit,
      required final Decimal credit,
      final String? description,
      final String? sourceDocumentRef,
      final String? costCenterId,
      final String? originalCurrency,
      final Decimal? exchangeRate,
      final Decimal? originalAmount}) = _$JournalEntryLineImpl;

  factory _JournalEntryLine.fromJson(Map<String, dynamic> json) =
      _$JournalEntryLineImpl.fromJson;

  @override

  /// Reference to the target [Account] ID.
  String get accountId;
  @override

  /// Denormalized account name for high-performance listing and audit.
  String get accountName;
  @override

  /// Positive increase for Debit-nature accounts.
  Decimal get debit;
  @override

  /// Positive increase for Credit-nature accounts.
  Decimal get credit;
  @override

  /// Line-specific memo or explanation.
  String? get description;
  @override

  /// Direct link to source documentation (e.g., Invoice #, Receipt ID).
  /// (Standard Reference: CP-009: Traceability)
  String? get sourceDocumentRef;
  @override

  /// Cost center identifier for management accounting attribution.
  String? get costCenterId;
  @override

  /// ISO currency code for multi-currency transactions.
  String? get originalCurrency;
  @override

  /// Spot exchange rate at the time of recording.
  Decimal? get exchangeRate;
  @override

  /// Original amount in the source currency before conversion.
  Decimal? get originalAmount;
  @override
  @JsonKey(ignore: true)
  _$$JournalEntryLineImplCopyWith<_$JournalEntryLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

JournalEntry _$JournalEntryFromJson(Map<String, dynamic> json) {
  return _JournalEntry.fromJson(json);
}

/// @nodoc
mixin _$JournalEntry {
  /// Unique internal UUID for the entry.
  String get id => throw _privateConstructorUsedError;

  /// Human-readable unique serial number (e.g., "JE-2024-001").
  String get referenceNumber => throw _privateConstructorUsedError;

  /// Primary chronological date for the entry report.
  DateTime get date => throw _privateConstructorUsedError;

  /// Multi-dimensional temporal audit metadata.
  TemporalJustification get temporal => throw _privateConstructorUsedError;

  /// Explicit regulatory compliance references and justifications.
  StandardsJustification get standards => throw _privateConstructorUsedError;

  /// Concise summary of the transaction purpose.
  String get description => throw _privateConstructorUsedError;

  /// Active state of the entry (Draft/Posted/Voided).
  JournalEntryStatus get status => throw _privateConstructorUsedError;

  /// Immutable list of balanced [JournalEntryLine]s.
  List<JournalEntryLine> get lines => throw _privateConstructorUsedError;

  /// Categorization of the spawning source (e.g., "sales_invoice", "pos").
  String get sourceDocument => throw _privateConstructorUsedError;

  /// Unique identifier within the source module.
  String get sourceId => throw _privateConstructorUsedError;

  /// User ID of the originator.
  String get createdBy => throw _privateConstructorUsedError;

  /// Creation timestamp in UTC.
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Last modification timestamp in UTC.
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Integrity verification fingerprint (Merkle-style link).
  /// (Standard Reference: CP-003: Immutability)
  String? get hash => throw _privateConstructorUsedError;

  /// Fingerprint of the chronologically preceding entry in the ledger.
  String? get previousHash => throw _privateConstructorUsedError;

  /// Final posting timestamp marking the end of the draft lifecycle.
  DateTime? get postedAt => throw _privateConstructorUsedError;

  /// Tenant isolation identifier.
  String? get userId => throw _privateConstructorUsedError;

  /// Warehouse scope identifier.
  String? get warehouseId => throw _privateConstructorUsedError;

  /// Internal audit path for system and security tracking.
  List<AuditLogEntry> get auditLogs => throw _privateConstructorUsedError;

  /// Local-to-Remote synchronization state.
  SyncStatus get syncStatus => throw _privateConstructorUsedError;

  /// Most recent synchronization timestamp from the server.
  DateTime? get serverUpdatedAt => throw _privateConstructorUsedError;

  /// Soft-deletion flag.
  bool get isDeleted => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $JournalEntryCopyWith<JournalEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JournalEntryCopyWith<$Res> {
  factory $JournalEntryCopyWith(
          JournalEntry value, $Res Function(JournalEntry) then) =
      _$JournalEntryCopyWithImpl<$Res, JournalEntry>;
  @useResult
  $Res call(
      {String id,
      String referenceNumber,
      DateTime date,
      TemporalJustification temporal,
      StandardsJustification standards,
      String description,
      JournalEntryStatus status,
      List<JournalEntryLine> lines,
      String sourceDocument,
      String sourceId,
      String createdBy,
      DateTime createdAt,
      DateTime updatedAt,
      String? hash,
      String? previousHash,
      DateTime? postedAt,
      String? userId,
      String? warehouseId,
      List<AuditLogEntry> auditLogs,
      SyncStatus syncStatus,
      DateTime? serverUpdatedAt,
      bool isDeleted});

  $TemporalJustificationCopyWith<$Res> get temporal;
  $StandardsJustificationCopyWith<$Res> get standards;
}

/// @nodoc
class _$JournalEntryCopyWithImpl<$Res, $Val extends JournalEntry>
    implements $JournalEntryCopyWith<$Res> {
  _$JournalEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? referenceNumber = null,
    Object? date = null,
    Object? temporal = null,
    Object? standards = null,
    Object? description = null,
    Object? status = null,
    Object? lines = null,
    Object? sourceDocument = null,
    Object? sourceId = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? hash = freezed,
    Object? previousHash = freezed,
    Object? postedAt = freezed,
    Object? userId = freezed,
    Object? warehouseId = freezed,
    Object? auditLogs = null,
    Object? syncStatus = null,
    Object? serverUpdatedAt = freezed,
    Object? isDeleted = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      referenceNumber: null == referenceNumber
          ? _value.referenceNumber
          : referenceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      temporal: null == temporal
          ? _value.temporal
          : temporal // ignore: cast_nullable_to_non_nullable
              as TemporalJustification,
      standards: null == standards
          ? _value.standards
          : standards // ignore: cast_nullable_to_non_nullable
              as StandardsJustification,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as JournalEntryStatus,
      lines: null == lines
          ? _value.lines
          : lines // ignore: cast_nullable_to_non_nullable
              as List<JournalEntryLine>,
      sourceDocument: null == sourceDocument
          ? _value.sourceDocument
          : sourceDocument // ignore: cast_nullable_to_non_nullable
              as String,
      sourceId: null == sourceId
          ? _value.sourceId
          : sourceId // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      hash: freezed == hash
          ? _value.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as String?,
      previousHash: freezed == previousHash
          ? _value.previousHash
          : previousHash // ignore: cast_nullable_to_non_nullable
              as String?,
      postedAt: freezed == postedAt
          ? _value.postedAt
          : postedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      warehouseId: freezed == warehouseId
          ? _value.warehouseId
          : warehouseId // ignore: cast_nullable_to_non_nullable
              as String?,
      auditLogs: null == auditLogs
          ? _value.auditLogs
          : auditLogs // ignore: cast_nullable_to_non_nullable
              as List<AuditLogEntry>,
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

  @override
  @pragma('vm:prefer-inline')
  $TemporalJustificationCopyWith<$Res> get temporal {
    return $TemporalJustificationCopyWith<$Res>(_value.temporal, (value) {
      return _then(_value.copyWith(temporal: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $StandardsJustificationCopyWith<$Res> get standards {
    return $StandardsJustificationCopyWith<$Res>(_value.standards, (value) {
      return _then(_value.copyWith(standards: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$JournalEntryImplCopyWith<$Res>
    implements $JournalEntryCopyWith<$Res> {
  factory _$$JournalEntryImplCopyWith(
          _$JournalEntryImpl value, $Res Function(_$JournalEntryImpl) then) =
      __$$JournalEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String referenceNumber,
      DateTime date,
      TemporalJustification temporal,
      StandardsJustification standards,
      String description,
      JournalEntryStatus status,
      List<JournalEntryLine> lines,
      String sourceDocument,
      String sourceId,
      String createdBy,
      DateTime createdAt,
      DateTime updatedAt,
      String? hash,
      String? previousHash,
      DateTime? postedAt,
      String? userId,
      String? warehouseId,
      List<AuditLogEntry> auditLogs,
      SyncStatus syncStatus,
      DateTime? serverUpdatedAt,
      bool isDeleted});

  @override
  $TemporalJustificationCopyWith<$Res> get temporal;
  @override
  $StandardsJustificationCopyWith<$Res> get standards;
}

/// @nodoc
class __$$JournalEntryImplCopyWithImpl<$Res>
    extends _$JournalEntryCopyWithImpl<$Res, _$JournalEntryImpl>
    implements _$$JournalEntryImplCopyWith<$Res> {
  __$$JournalEntryImplCopyWithImpl(
      _$JournalEntryImpl _value, $Res Function(_$JournalEntryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? referenceNumber = null,
    Object? date = null,
    Object? temporal = null,
    Object? standards = null,
    Object? description = null,
    Object? status = null,
    Object? lines = null,
    Object? sourceDocument = null,
    Object? sourceId = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? hash = freezed,
    Object? previousHash = freezed,
    Object? postedAt = freezed,
    Object? userId = freezed,
    Object? warehouseId = freezed,
    Object? auditLogs = null,
    Object? syncStatus = null,
    Object? serverUpdatedAt = freezed,
    Object? isDeleted = null,
  }) {
    return _then(_$JournalEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      referenceNumber: null == referenceNumber
          ? _value.referenceNumber
          : referenceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      temporal: null == temporal
          ? _value.temporal
          : temporal // ignore: cast_nullable_to_non_nullable
              as TemporalJustification,
      standards: null == standards
          ? _value.standards
          : standards // ignore: cast_nullable_to_non_nullable
              as StandardsJustification,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as JournalEntryStatus,
      lines: null == lines
          ? _value._lines
          : lines // ignore: cast_nullable_to_non_nullable
              as List<JournalEntryLine>,
      sourceDocument: null == sourceDocument
          ? _value.sourceDocument
          : sourceDocument // ignore: cast_nullable_to_non_nullable
              as String,
      sourceId: null == sourceId
          ? _value.sourceId
          : sourceId // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      hash: freezed == hash
          ? _value.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as String?,
      previousHash: freezed == previousHash
          ? _value.previousHash
          : previousHash // ignore: cast_nullable_to_non_nullable
              as String?,
      postedAt: freezed == postedAt
          ? _value.postedAt
          : postedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      warehouseId: freezed == warehouseId
          ? _value.warehouseId
          : warehouseId // ignore: cast_nullable_to_non_nullable
              as String?,
      auditLogs: null == auditLogs
          ? _value._auditLogs
          : auditLogs // ignore: cast_nullable_to_non_nullable
              as List<AuditLogEntry>,
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
class _$JournalEntryImpl extends _JournalEntry {
  const _$JournalEntryImpl(
      {required this.id,
      required this.referenceNumber,
      required this.date,
      required this.temporal,
      required this.standards,
      required this.description,
      required this.status,
      required final List<JournalEntryLine> lines,
      required this.sourceDocument,
      required this.sourceId,
      required this.createdBy,
      required this.createdAt,
      required this.updatedAt,
      this.hash,
      this.previousHash,
      this.postedAt,
      this.userId,
      this.warehouseId,
      final List<AuditLogEntry> auditLogs = const [],
      this.syncStatus = SyncStatus.synced,
      this.serverUpdatedAt,
      this.isDeleted = false})
      : _lines = lines,
        _auditLogs = auditLogs,
        super._();

  factory _$JournalEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$JournalEntryImplFromJson(json);

  /// Unique internal UUID for the entry.
  @override
  final String id;

  /// Human-readable unique serial number (e.g., "JE-2024-001").
  @override
  final String referenceNumber;

  /// Primary chronological date for the entry report.
  @override
  final DateTime date;

  /// Multi-dimensional temporal audit metadata.
  @override
  final TemporalJustification temporal;

  /// Explicit regulatory compliance references and justifications.
  @override
  final StandardsJustification standards;

  /// Concise summary of the transaction purpose.
  @override
  final String description;

  /// Active state of the entry (Draft/Posted/Voided).
  @override
  final JournalEntryStatus status;

  /// Immutable list of balanced [JournalEntryLine]s.
  final List<JournalEntryLine> _lines;

  /// Immutable list of balanced [JournalEntryLine]s.
  @override
  List<JournalEntryLine> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  /// Categorization of the spawning source (e.g., "sales_invoice", "pos").
  @override
  final String sourceDocument;

  /// Unique identifier within the source module.
  @override
  final String sourceId;

  /// User ID of the originator.
  @override
  final String createdBy;

  /// Creation timestamp in UTC.
  @override
  final DateTime createdAt;

  /// Last modification timestamp in UTC.
  @override
  final DateTime updatedAt;

  /// Integrity verification fingerprint (Merkle-style link).
  /// (Standard Reference: CP-003: Immutability)
  @override
  final String? hash;

  /// Fingerprint of the chronologically preceding entry in the ledger.
  @override
  final String? previousHash;

  /// Final posting timestamp marking the end of the draft lifecycle.
  @override
  final DateTime? postedAt;

  /// Tenant isolation identifier.
  @override
  final String? userId;

  /// Warehouse scope identifier.
  @override
  final String? warehouseId;

  /// Internal audit path for system and security tracking.
  final List<AuditLogEntry> _auditLogs;

  /// Internal audit path for system and security tracking.
  @override
  @JsonKey()
  List<AuditLogEntry> get auditLogs {
    if (_auditLogs is EqualUnmodifiableListView) return _auditLogs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_auditLogs);
  }

  /// Local-to-Remote synchronization state.
  @override
  @JsonKey()
  final SyncStatus syncStatus;

  /// Most recent synchronization timestamp from the server.
  @override
  final DateTime? serverUpdatedAt;

  /// Soft-deletion flag.
  @override
  @JsonKey()
  final bool isDeleted;

  @override
  String toString() {
    return 'JournalEntry(id: $id, referenceNumber: $referenceNumber, date: $date, temporal: $temporal, standards: $standards, description: $description, status: $status, lines: $lines, sourceDocument: $sourceDocument, sourceId: $sourceId, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, hash: $hash, previousHash: $previousHash, postedAt: $postedAt, userId: $userId, warehouseId: $warehouseId, auditLogs: $auditLogs, syncStatus: $syncStatus, serverUpdatedAt: $serverUpdatedAt, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JournalEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.referenceNumber, referenceNumber) ||
                other.referenceNumber == referenceNumber) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.temporal, temporal) ||
                other.temporal == temporal) &&
            (identical(other.standards, standards) ||
                other.standards == standards) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._lines, _lines) &&
            (identical(other.sourceDocument, sourceDocument) ||
                other.sourceDocument == sourceDocument) &&
            (identical(other.sourceId, sourceId) ||
                other.sourceId == sourceId) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.hash, hash) || other.hash == hash) &&
            (identical(other.previousHash, previousHash) ||
                other.previousHash == previousHash) &&
            (identical(other.postedAt, postedAt) ||
                other.postedAt == postedAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.warehouseId, warehouseId) ||
                other.warehouseId == warehouseId) &&
            const DeepCollectionEquality()
                .equals(other._auditLogs, _auditLogs) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.serverUpdatedAt, serverUpdatedAt) ||
                other.serverUpdatedAt == serverUpdatedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        referenceNumber,
        date,
        temporal,
        standards,
        description,
        status,
        const DeepCollectionEquality().hash(_lines),
        sourceDocument,
        sourceId,
        createdBy,
        createdAt,
        updatedAt,
        hash,
        previousHash,
        postedAt,
        userId,
        warehouseId,
        const DeepCollectionEquality().hash(_auditLogs),
        syncStatus,
        serverUpdatedAt,
        isDeleted
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$JournalEntryImplCopyWith<_$JournalEntryImpl> get copyWith =>
      __$$JournalEntryImplCopyWithImpl<_$JournalEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JournalEntryImplToJson(
      this,
    );
  }
}

abstract class _JournalEntry extends JournalEntry {
  const factory _JournalEntry(
      {required final String id,
      required final String referenceNumber,
      required final DateTime date,
      required final TemporalJustification temporal,
      required final StandardsJustification standards,
      required final String description,
      required final JournalEntryStatus status,
      required final List<JournalEntryLine> lines,
      required final String sourceDocument,
      required final String sourceId,
      required final String createdBy,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String? hash,
      final String? previousHash,
      final DateTime? postedAt,
      final String? userId,
      final String? warehouseId,
      final List<AuditLogEntry> auditLogs,
      final SyncStatus syncStatus,
      final DateTime? serverUpdatedAt,
      final bool isDeleted}) = _$JournalEntryImpl;
  const _JournalEntry._() : super._();

  factory _JournalEntry.fromJson(Map<String, dynamic> json) =
      _$JournalEntryImpl.fromJson;

  @override

  /// Unique internal UUID for the entry.
  String get id;
  @override

  /// Human-readable unique serial number (e.g., "JE-2024-001").
  String get referenceNumber;
  @override

  /// Primary chronological date for the entry report.
  DateTime get date;
  @override

  /// Multi-dimensional temporal audit metadata.
  TemporalJustification get temporal;
  @override

  /// Explicit regulatory compliance references and justifications.
  StandardsJustification get standards;
  @override

  /// Concise summary of the transaction purpose.
  String get description;
  @override

  /// Active state of the entry (Draft/Posted/Voided).
  JournalEntryStatus get status;
  @override

  /// Immutable list of balanced [JournalEntryLine]s.
  List<JournalEntryLine> get lines;
  @override

  /// Categorization of the spawning source (e.g., "sales_invoice", "pos").
  String get sourceDocument;
  @override

  /// Unique identifier within the source module.
  String get sourceId;
  @override

  /// User ID of the originator.
  String get createdBy;
  @override

  /// Creation timestamp in UTC.
  DateTime get createdAt;
  @override

  /// Last modification timestamp in UTC.
  DateTime get updatedAt;
  @override

  /// Integrity verification fingerprint (Merkle-style link).
  /// (Standard Reference: CP-003: Immutability)
  String? get hash;
  @override

  /// Fingerprint of the chronologically preceding entry in the ledger.
  String? get previousHash;
  @override

  /// Final posting timestamp marking the end of the draft lifecycle.
  DateTime? get postedAt;
  @override

  /// Tenant isolation identifier.
  String? get userId;
  @override

  /// Warehouse scope identifier.
  String? get warehouseId;
  @override

  /// Internal audit path for system and security tracking.
  List<AuditLogEntry> get auditLogs;
  @override

  /// Local-to-Remote synchronization state.
  SyncStatus get syncStatus;
  @override

  /// Most recent synchronization timestamp from the server.
  DateTime? get serverUpdatedAt;
  @override

  /// Soft-deletion flag.
  bool get isDeleted;
  @override
  @JsonKey(ignore: true)
  _$$JournalEntryImplCopyWith<_$JournalEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
