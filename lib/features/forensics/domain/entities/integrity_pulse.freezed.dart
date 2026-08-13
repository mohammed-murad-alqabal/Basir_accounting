// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'integrity_pulse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$IntegrityPulse {
  /// Whether the system state is healthy.
  bool get isHealthy => throw _privateConstructorUsedError;

  /// Hash of the last verified entry.
  String get lastVerifiedHash => throw _privateConstructorUsedError;

  /// Timestamp of the last successful verification.
  DateTime get lastVerifiedAt => throw _privateConstructorUsedError;

  /// Total number of blocks scanned in the last audit.
  int get totalBlocksScanned => throw _privateConstructorUsedError;

  /// Overall health percentage of the ledger.
  double get healthPercentage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $IntegrityPulseCopyWith<IntegrityPulse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IntegrityPulseCopyWith<$Res> {
  factory $IntegrityPulseCopyWith(
          IntegrityPulse value, $Res Function(IntegrityPulse) then) =
      _$IntegrityPulseCopyWithImpl<$Res, IntegrityPulse>;
  @useResult
  $Res call(
      {bool isHealthy,
      String lastVerifiedHash,
      DateTime lastVerifiedAt,
      int totalBlocksScanned,
      double healthPercentage});
}

/// @nodoc
class _$IntegrityPulseCopyWithImpl<$Res, $Val extends IntegrityPulse>
    implements $IntegrityPulseCopyWith<$Res> {
  _$IntegrityPulseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isHealthy = null,
    Object? lastVerifiedHash = null,
    Object? lastVerifiedAt = null,
    Object? totalBlocksScanned = null,
    Object? healthPercentage = null,
  }) {
    return _then(_value.copyWith(
      isHealthy: null == isHealthy
          ? _value.isHealthy
          : isHealthy // ignore: cast_nullable_to_non_nullable
              as bool,
      lastVerifiedHash: null == lastVerifiedHash
          ? _value.lastVerifiedHash
          : lastVerifiedHash // ignore: cast_nullable_to_non_nullable
              as String,
      lastVerifiedAt: null == lastVerifiedAt
          ? _value.lastVerifiedAt
          : lastVerifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalBlocksScanned: null == totalBlocksScanned
          ? _value.totalBlocksScanned
          : totalBlocksScanned // ignore: cast_nullable_to_non_nullable
              as int,
      healthPercentage: null == healthPercentage
          ? _value.healthPercentage
          : healthPercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IntegrityPulseImplCopyWith<$Res>
    implements $IntegrityPulseCopyWith<$Res> {
  factory _$$IntegrityPulseImplCopyWith(_$IntegrityPulseImpl value,
          $Res Function(_$IntegrityPulseImpl) then) =
      __$$IntegrityPulseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isHealthy,
      String lastVerifiedHash,
      DateTime lastVerifiedAt,
      int totalBlocksScanned,
      double healthPercentage});
}

/// @nodoc
class __$$IntegrityPulseImplCopyWithImpl<$Res>
    extends _$IntegrityPulseCopyWithImpl<$Res, _$IntegrityPulseImpl>
    implements _$$IntegrityPulseImplCopyWith<$Res> {
  __$$IntegrityPulseImplCopyWithImpl(
      _$IntegrityPulseImpl _value, $Res Function(_$IntegrityPulseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isHealthy = null,
    Object? lastVerifiedHash = null,
    Object? lastVerifiedAt = null,
    Object? totalBlocksScanned = null,
    Object? healthPercentage = null,
  }) {
    return _then(_$IntegrityPulseImpl(
      isHealthy: null == isHealthy
          ? _value.isHealthy
          : isHealthy // ignore: cast_nullable_to_non_nullable
              as bool,
      lastVerifiedHash: null == lastVerifiedHash
          ? _value.lastVerifiedHash
          : lastVerifiedHash // ignore: cast_nullable_to_non_nullable
              as String,
      lastVerifiedAt: null == lastVerifiedAt
          ? _value.lastVerifiedAt
          : lastVerifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalBlocksScanned: null == totalBlocksScanned
          ? _value.totalBlocksScanned
          : totalBlocksScanned // ignore: cast_nullable_to_non_nullable
              as int,
      healthPercentage: null == healthPercentage
          ? _value.healthPercentage
          : healthPercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$IntegrityPulseImpl implements _IntegrityPulse {
  const _$IntegrityPulseImpl(
      {required this.isHealthy,
      required this.lastVerifiedHash,
      required this.lastVerifiedAt,
      required this.totalBlocksScanned,
      required this.healthPercentage});

  /// Whether the system state is healthy.
  @override
  final bool isHealthy;

  /// Hash of the last verified entry.
  @override
  final String lastVerifiedHash;

  /// Timestamp of the last successful verification.
  @override
  final DateTime lastVerifiedAt;

  /// Total number of blocks scanned in the last audit.
  @override
  final int totalBlocksScanned;

  /// Overall health percentage of the ledger.
  @override
  final double healthPercentage;

  @override
  String toString() {
    return 'IntegrityPulse(isHealthy: $isHealthy, lastVerifiedHash: $lastVerifiedHash, lastVerifiedAt: $lastVerifiedAt, totalBlocksScanned: $totalBlocksScanned, healthPercentage: $healthPercentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IntegrityPulseImpl &&
            (identical(other.isHealthy, isHealthy) ||
                other.isHealthy == isHealthy) &&
            (identical(other.lastVerifiedHash, lastVerifiedHash) ||
                other.lastVerifiedHash == lastVerifiedHash) &&
            (identical(other.lastVerifiedAt, lastVerifiedAt) ||
                other.lastVerifiedAt == lastVerifiedAt) &&
            (identical(other.totalBlocksScanned, totalBlocksScanned) ||
                other.totalBlocksScanned == totalBlocksScanned) &&
            (identical(other.healthPercentage, healthPercentage) ||
                other.healthPercentage == healthPercentage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isHealthy, lastVerifiedHash,
      lastVerifiedAt, totalBlocksScanned, healthPercentage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IntegrityPulseImplCopyWith<_$IntegrityPulseImpl> get copyWith =>
      __$$IntegrityPulseImplCopyWithImpl<_$IntegrityPulseImpl>(
          this, _$identity);
}

abstract class _IntegrityPulse implements IntegrityPulse {
  const factory _IntegrityPulse(
      {required final bool isHealthy,
      required final String lastVerifiedHash,
      required final DateTime lastVerifiedAt,
      required final int totalBlocksScanned,
      required final double healthPercentage}) = _$IntegrityPulseImpl;

  @override

  /// Whether the system state is healthy.
  bool get isHealthy;
  @override

  /// Hash of the last verified entry.
  String get lastVerifiedHash;
  @override

  /// Timestamp of the last successful verification.
  DateTime get lastVerifiedAt;
  @override

  /// Total number of blocks scanned in the last audit.
  int get totalBlocksScanned;
  @override

  /// Overall health percentage of the ledger.
  double get healthPercentage;
  @override
  @JsonKey(ignore: true)
  _$$IntegrityPulseImplCopyWith<_$IntegrityPulseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LedgerBlock {
  /// Unique identifier of the journal entry.
  String get entryId => throw _privateConstructorUsedError;

  /// Reference number of the transaction.
  String get referenceNumber => throw _privateConstructorUsedError;

  /// Date of the transaction.
  DateTime get date => throw _privateConstructorUsedError;

  /// Hash of the current block.
  String? get hash => throw _privateConstructorUsedError;

  /// Hash of the preceding block.
  String? get previousHash => throw _privateConstructorUsedError;

  /// Whether the block signature is verified.
  bool get isVerified => throw _privateConstructorUsedError;

  /// Signature of the agent that verified the block.
  String get agentSignature => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LedgerBlockCopyWith<LedgerBlock> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LedgerBlockCopyWith<$Res> {
  factory $LedgerBlockCopyWith(
          LedgerBlock value, $Res Function(LedgerBlock) then) =
      _$LedgerBlockCopyWithImpl<$Res, LedgerBlock>;
  @useResult
  $Res call(
      {String entryId,
      String referenceNumber,
      DateTime date,
      String? hash,
      String? previousHash,
      bool isVerified,
      String agentSignature});
}

/// @nodoc
class _$LedgerBlockCopyWithImpl<$Res, $Val extends LedgerBlock>
    implements $LedgerBlockCopyWith<$Res> {
  _$LedgerBlockCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entryId = null,
    Object? referenceNumber = null,
    Object? date = null,
    Object? hash = freezed,
    Object? previousHash = freezed,
    Object? isVerified = null,
    Object? agentSignature = null,
  }) {
    return _then(_value.copyWith(
      entryId: null == entryId
          ? _value.entryId
          : entryId // ignore: cast_nullable_to_non_nullable
              as String,
      referenceNumber: null == referenceNumber
          ? _value.referenceNumber
          : referenceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      hash: freezed == hash
          ? _value.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as String?,
      previousHash: freezed == previousHash
          ? _value.previousHash
          : previousHash // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      agentSignature: null == agentSignature
          ? _value.agentSignature
          : agentSignature // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LedgerBlockImplCopyWith<$Res>
    implements $LedgerBlockCopyWith<$Res> {
  factory _$$LedgerBlockImplCopyWith(
          _$LedgerBlockImpl value, $Res Function(_$LedgerBlockImpl) then) =
      __$$LedgerBlockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String entryId,
      String referenceNumber,
      DateTime date,
      String? hash,
      String? previousHash,
      bool isVerified,
      String agentSignature});
}

/// @nodoc
class __$$LedgerBlockImplCopyWithImpl<$Res>
    extends _$LedgerBlockCopyWithImpl<$Res, _$LedgerBlockImpl>
    implements _$$LedgerBlockImplCopyWith<$Res> {
  __$$LedgerBlockImplCopyWithImpl(
      _$LedgerBlockImpl _value, $Res Function(_$LedgerBlockImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entryId = null,
    Object? referenceNumber = null,
    Object? date = null,
    Object? hash = freezed,
    Object? previousHash = freezed,
    Object? isVerified = null,
    Object? agentSignature = null,
  }) {
    return _then(_$LedgerBlockImpl(
      entryId: null == entryId
          ? _value.entryId
          : entryId // ignore: cast_nullable_to_non_nullable
              as String,
      referenceNumber: null == referenceNumber
          ? _value.referenceNumber
          : referenceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      hash: freezed == hash
          ? _value.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as String?,
      previousHash: freezed == previousHash
          ? _value.previousHash
          : previousHash // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      agentSignature: null == agentSignature
          ? _value.agentSignature
          : agentSignature // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LedgerBlockImpl implements _LedgerBlock {
  const _$LedgerBlockImpl(
      {required this.entryId,
      required this.referenceNumber,
      required this.date,
      required this.hash,
      required this.previousHash,
      required this.isVerified,
      required this.agentSignature});

  /// Unique identifier of the journal entry.
  @override
  final String entryId;

  /// Reference number of the transaction.
  @override
  final String referenceNumber;

  /// Date of the transaction.
  @override
  final DateTime date;

  /// Hash of the current block.
  @override
  final String? hash;

  /// Hash of the preceding block.
  @override
  final String? previousHash;

  /// Whether the block signature is verified.
  @override
  final bool isVerified;

  /// Signature of the agent that verified the block.
  @override
  final String agentSignature;

  @override
  String toString() {
    return 'LedgerBlock(entryId: $entryId, referenceNumber: $referenceNumber, date: $date, hash: $hash, previousHash: $previousHash, isVerified: $isVerified, agentSignature: $agentSignature)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LedgerBlockImpl &&
            (identical(other.entryId, entryId) || other.entryId == entryId) &&
            (identical(other.referenceNumber, referenceNumber) ||
                other.referenceNumber == referenceNumber) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.hash, hash) || other.hash == hash) &&
            (identical(other.previousHash, previousHash) ||
                other.previousHash == previousHash) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.agentSignature, agentSignature) ||
                other.agentSignature == agentSignature));
  }

  @override
  int get hashCode => Object.hash(runtimeType, entryId, referenceNumber, date,
      hash, previousHash, isVerified, agentSignature);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LedgerBlockImplCopyWith<_$LedgerBlockImpl> get copyWith =>
      __$$LedgerBlockImplCopyWithImpl<_$LedgerBlockImpl>(this, _$identity);
}

abstract class _LedgerBlock implements LedgerBlock {
  const factory _LedgerBlock(
      {required final String entryId,
      required final String referenceNumber,
      required final DateTime date,
      required final String? hash,
      required final String? previousHash,
      required final bool isVerified,
      required final String agentSignature}) = _$LedgerBlockImpl;

  @override

  /// Unique identifier of the journal entry.
  String get entryId;
  @override

  /// Reference number of the transaction.
  String get referenceNumber;
  @override

  /// Date of the transaction.
  DateTime get date;
  @override

  /// Hash of the current block.
  String? get hash;
  @override

  /// Hash of the preceding block.
  String? get previousHash;
  @override

  /// Whether the block signature is verified.
  bool get isVerified;
  @override

  /// Signature of the agent that verified the block.
  String get agentSignature;
  @override
  @JsonKey(ignore: true)
  _$$LedgerBlockImplCopyWith<_$LedgerBlockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
