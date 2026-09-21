// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auditor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AnomalyDto {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String expected, String found) sequenceGap,
    required TResult Function(
            String accountId, String bookBalance, String physicalCount)
        reconciliationMismatch,
    required TResult Function(String entryId, String date) orphanedDraft,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String expected, String found)? sequenceGap,
    TResult? Function(
            String accountId, String bookBalance, String physicalCount)?
        reconciliationMismatch,
    TResult? Function(String entryId, String date)? orphanedDraft,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String expected, String found)? sequenceGap,
    TResult Function(
            String accountId, String bookBalance, String physicalCount)?
        reconciliationMismatch,
    TResult Function(String entryId, String date)? orphanedDraft,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AnomalyDto_SequenceGap value) sequenceGap,
    required TResult Function(AnomalyDto_ReconciliationMismatch value)
        reconciliationMismatch,
    required TResult Function(AnomalyDto_OrphanedDraft value) orphanedDraft,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AnomalyDto_SequenceGap value)? sequenceGap,
    TResult? Function(AnomalyDto_ReconciliationMismatch value)?
        reconciliationMismatch,
    TResult? Function(AnomalyDto_OrphanedDraft value)? orphanedDraft,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AnomalyDto_SequenceGap value)? sequenceGap,
    TResult Function(AnomalyDto_ReconciliationMismatch value)?
        reconciliationMismatch,
    TResult Function(AnomalyDto_OrphanedDraft value)? orphanedDraft,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnomalyDtoCopyWith<$Res> {
  factory $AnomalyDtoCopyWith(
          AnomalyDto value, $Res Function(AnomalyDto) then) =
      _$AnomalyDtoCopyWithImpl<$Res, AnomalyDto>;
}

/// @nodoc
class _$AnomalyDtoCopyWithImpl<$Res, $Val extends AnomalyDto>
    implements $AnomalyDtoCopyWith<$Res> {
  _$AnomalyDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$AnomalyDto_SequenceGapImplCopyWith<$Res> {
  factory _$$AnomalyDto_SequenceGapImplCopyWith(
          _$AnomalyDto_SequenceGapImpl value,
          $Res Function(_$AnomalyDto_SequenceGapImpl) then) =
      __$$AnomalyDto_SequenceGapImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String expected, String found});
}

/// @nodoc
class __$$AnomalyDto_SequenceGapImplCopyWithImpl<$Res>
    extends _$AnomalyDtoCopyWithImpl<$Res, _$AnomalyDto_SequenceGapImpl>
    implements _$$AnomalyDto_SequenceGapImplCopyWith<$Res> {
  __$$AnomalyDto_SequenceGapImplCopyWithImpl(
      _$AnomalyDto_SequenceGapImpl _value,
      $Res Function(_$AnomalyDto_SequenceGapImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expected = null,
    Object? found = null,
  }) {
    return _then(_$AnomalyDto_SequenceGapImpl(
      expected: null == expected
          ? _value.expected
          : expected // ignore: cast_nullable_to_non_nullable
              as String,
      found: null == found
          ? _value.found
          : found // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AnomalyDto_SequenceGapImpl extends AnomalyDto_SequenceGap {
  const _$AnomalyDto_SequenceGapImpl(
      {required this.expected, required this.found})
      : super._();

  @override
  final String expected;
  @override
  final String found;

  @override
  String toString() {
    return 'AnomalyDto.sequenceGap(expected: $expected, found: $found)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnomalyDto_SequenceGapImpl &&
            (identical(other.expected, expected) ||
                other.expected == expected) &&
            (identical(other.found, found) || other.found == found));
  }

  @override
  int get hashCode => Object.hash(runtimeType, expected, found);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AnomalyDto_SequenceGapImplCopyWith<_$AnomalyDto_SequenceGapImpl>
      get copyWith => __$$AnomalyDto_SequenceGapImplCopyWithImpl<
          _$AnomalyDto_SequenceGapImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String expected, String found) sequenceGap,
    required TResult Function(
            String accountId, String bookBalance, String physicalCount)
        reconciliationMismatch,
    required TResult Function(String entryId, String date) orphanedDraft,
  }) {
    return sequenceGap(expected, found);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String expected, String found)? sequenceGap,
    TResult? Function(
            String accountId, String bookBalance, String physicalCount)?
        reconciliationMismatch,
    TResult? Function(String entryId, String date)? orphanedDraft,
  }) {
    return sequenceGap?.call(expected, found);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String expected, String found)? sequenceGap,
    TResult Function(
            String accountId, String bookBalance, String physicalCount)?
        reconciliationMismatch,
    TResult Function(String entryId, String date)? orphanedDraft,
    required TResult orElse(),
  }) {
    if (sequenceGap != null) {
      return sequenceGap(expected, found);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AnomalyDto_SequenceGap value) sequenceGap,
    required TResult Function(AnomalyDto_ReconciliationMismatch value)
        reconciliationMismatch,
    required TResult Function(AnomalyDto_OrphanedDraft value) orphanedDraft,
  }) {
    return sequenceGap(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AnomalyDto_SequenceGap value)? sequenceGap,
    TResult? Function(AnomalyDto_ReconciliationMismatch value)?
        reconciliationMismatch,
    TResult? Function(AnomalyDto_OrphanedDraft value)? orphanedDraft,
  }) {
    return sequenceGap?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AnomalyDto_SequenceGap value)? sequenceGap,
    TResult Function(AnomalyDto_ReconciliationMismatch value)?
        reconciliationMismatch,
    TResult Function(AnomalyDto_OrphanedDraft value)? orphanedDraft,
    required TResult orElse(),
  }) {
    if (sequenceGap != null) {
      return sequenceGap(this);
    }
    return orElse();
  }
}

abstract class AnomalyDto_SequenceGap extends AnomalyDto {
  const factory AnomalyDto_SequenceGap(
      {required final String expected,
      required final String found}) = _$AnomalyDto_SequenceGapImpl;
  const AnomalyDto_SequenceGap._() : super._();

  String get expected;
  String get found;
  @JsonKey(ignore: true)
  _$$AnomalyDto_SequenceGapImplCopyWith<_$AnomalyDto_SequenceGapImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AnomalyDto_ReconciliationMismatchImplCopyWith<$Res> {
  factory _$$AnomalyDto_ReconciliationMismatchImplCopyWith(
          _$AnomalyDto_ReconciliationMismatchImpl value,
          $Res Function(_$AnomalyDto_ReconciliationMismatchImpl) then) =
      __$$AnomalyDto_ReconciliationMismatchImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String accountId, String bookBalance, String physicalCount});
}

/// @nodoc
class __$$AnomalyDto_ReconciliationMismatchImplCopyWithImpl<$Res>
    extends _$AnomalyDtoCopyWithImpl<$Res,
        _$AnomalyDto_ReconciliationMismatchImpl>
    implements _$$AnomalyDto_ReconciliationMismatchImplCopyWith<$Res> {
  __$$AnomalyDto_ReconciliationMismatchImplCopyWithImpl(
      _$AnomalyDto_ReconciliationMismatchImpl _value,
      $Res Function(_$AnomalyDto_ReconciliationMismatchImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? bookBalance = null,
    Object? physicalCount = null,
  }) {
    return _then(_$AnomalyDto_ReconciliationMismatchImpl(
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      bookBalance: null == bookBalance
          ? _value.bookBalance
          : bookBalance // ignore: cast_nullable_to_non_nullable
              as String,
      physicalCount: null == physicalCount
          ? _value.physicalCount
          : physicalCount // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AnomalyDto_ReconciliationMismatchImpl
    extends AnomalyDto_ReconciliationMismatch {
  const _$AnomalyDto_ReconciliationMismatchImpl(
      {required this.accountId,
      required this.bookBalance,
      required this.physicalCount})
      : super._();

  @override
  final String accountId;
  @override
  final String bookBalance;
  @override
  final String physicalCount;

  @override
  String toString() {
    return 'AnomalyDto.reconciliationMismatch(accountId: $accountId, bookBalance: $bookBalance, physicalCount: $physicalCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnomalyDto_ReconciliationMismatchImpl &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.bookBalance, bookBalance) ||
                other.bookBalance == bookBalance) &&
            (identical(other.physicalCount, physicalCount) ||
                other.physicalCount == physicalCount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, accountId, bookBalance, physicalCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AnomalyDto_ReconciliationMismatchImplCopyWith<
          _$AnomalyDto_ReconciliationMismatchImpl>
      get copyWith => __$$AnomalyDto_ReconciliationMismatchImplCopyWithImpl<
          _$AnomalyDto_ReconciliationMismatchImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String expected, String found) sequenceGap,
    required TResult Function(
            String accountId, String bookBalance, String physicalCount)
        reconciliationMismatch,
    required TResult Function(String entryId, String date) orphanedDraft,
  }) {
    return reconciliationMismatch(accountId, bookBalance, physicalCount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String expected, String found)? sequenceGap,
    TResult? Function(
            String accountId, String bookBalance, String physicalCount)?
        reconciliationMismatch,
    TResult? Function(String entryId, String date)? orphanedDraft,
  }) {
    return reconciliationMismatch?.call(accountId, bookBalance, physicalCount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String expected, String found)? sequenceGap,
    TResult Function(
            String accountId, String bookBalance, String physicalCount)?
        reconciliationMismatch,
    TResult Function(String entryId, String date)? orphanedDraft,
    required TResult orElse(),
  }) {
    if (reconciliationMismatch != null) {
      return reconciliationMismatch(accountId, bookBalance, physicalCount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AnomalyDto_SequenceGap value) sequenceGap,
    required TResult Function(AnomalyDto_ReconciliationMismatch value)
        reconciliationMismatch,
    required TResult Function(AnomalyDto_OrphanedDraft value) orphanedDraft,
  }) {
    return reconciliationMismatch(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AnomalyDto_SequenceGap value)? sequenceGap,
    TResult? Function(AnomalyDto_ReconciliationMismatch value)?
        reconciliationMismatch,
    TResult? Function(AnomalyDto_OrphanedDraft value)? orphanedDraft,
  }) {
    return reconciliationMismatch?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AnomalyDto_SequenceGap value)? sequenceGap,
    TResult Function(AnomalyDto_ReconciliationMismatch value)?
        reconciliationMismatch,
    TResult Function(AnomalyDto_OrphanedDraft value)? orphanedDraft,
    required TResult orElse(),
  }) {
    if (reconciliationMismatch != null) {
      return reconciliationMismatch(this);
    }
    return orElse();
  }
}

abstract class AnomalyDto_ReconciliationMismatch extends AnomalyDto {
  const factory AnomalyDto_ReconciliationMismatch(
          {required final String accountId,
          required final String bookBalance,
          required final String physicalCount}) =
      _$AnomalyDto_ReconciliationMismatchImpl;
  const AnomalyDto_ReconciliationMismatch._() : super._();

  String get accountId;
  String get bookBalance;
  String get physicalCount;
  @JsonKey(ignore: true)
  _$$AnomalyDto_ReconciliationMismatchImplCopyWith<
          _$AnomalyDto_ReconciliationMismatchImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AnomalyDto_OrphanedDraftImplCopyWith<$Res> {
  factory _$$AnomalyDto_OrphanedDraftImplCopyWith(
          _$AnomalyDto_OrphanedDraftImpl value,
          $Res Function(_$AnomalyDto_OrphanedDraftImpl) then) =
      __$$AnomalyDto_OrphanedDraftImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String entryId, String date});
}

/// @nodoc
class __$$AnomalyDto_OrphanedDraftImplCopyWithImpl<$Res>
    extends _$AnomalyDtoCopyWithImpl<$Res, _$AnomalyDto_OrphanedDraftImpl>
    implements _$$AnomalyDto_OrphanedDraftImplCopyWith<$Res> {
  __$$AnomalyDto_OrphanedDraftImplCopyWithImpl(
      _$AnomalyDto_OrphanedDraftImpl _value,
      $Res Function(_$AnomalyDto_OrphanedDraftImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entryId = null,
    Object? date = null,
  }) {
    return _then(_$AnomalyDto_OrphanedDraftImpl(
      entryId: null == entryId
          ? _value.entryId
          : entryId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AnomalyDto_OrphanedDraftImpl extends AnomalyDto_OrphanedDraft {
  const _$AnomalyDto_OrphanedDraftImpl(
      {required this.entryId, required this.date})
      : super._();

  @override
  final String entryId;
  @override
  final String date;

  @override
  String toString() {
    return 'AnomalyDto.orphanedDraft(entryId: $entryId, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnomalyDto_OrphanedDraftImpl &&
            (identical(other.entryId, entryId) || other.entryId == entryId) &&
            (identical(other.date, date) || other.date == date));
  }

  @override
  int get hashCode => Object.hash(runtimeType, entryId, date);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AnomalyDto_OrphanedDraftImplCopyWith<_$AnomalyDto_OrphanedDraftImpl>
      get copyWith => __$$AnomalyDto_OrphanedDraftImplCopyWithImpl<
          _$AnomalyDto_OrphanedDraftImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String expected, String found) sequenceGap,
    required TResult Function(
            String accountId, String bookBalance, String physicalCount)
        reconciliationMismatch,
    required TResult Function(String entryId, String date) orphanedDraft,
  }) {
    return orphanedDraft(entryId, date);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String expected, String found)? sequenceGap,
    TResult? Function(
            String accountId, String bookBalance, String physicalCount)?
        reconciliationMismatch,
    TResult? Function(String entryId, String date)? orphanedDraft,
  }) {
    return orphanedDraft?.call(entryId, date);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String expected, String found)? sequenceGap,
    TResult Function(
            String accountId, String bookBalance, String physicalCount)?
        reconciliationMismatch,
    TResult Function(String entryId, String date)? orphanedDraft,
    required TResult orElse(),
  }) {
    if (orphanedDraft != null) {
      return orphanedDraft(entryId, date);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AnomalyDto_SequenceGap value) sequenceGap,
    required TResult Function(AnomalyDto_ReconciliationMismatch value)
        reconciliationMismatch,
    required TResult Function(AnomalyDto_OrphanedDraft value) orphanedDraft,
  }) {
    return orphanedDraft(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AnomalyDto_SequenceGap value)? sequenceGap,
    TResult? Function(AnomalyDto_ReconciliationMismatch value)?
        reconciliationMismatch,
    TResult? Function(AnomalyDto_OrphanedDraft value)? orphanedDraft,
  }) {
    return orphanedDraft?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AnomalyDto_SequenceGap value)? sequenceGap,
    TResult Function(AnomalyDto_ReconciliationMismatch value)?
        reconciliationMismatch,
    TResult Function(AnomalyDto_OrphanedDraft value)? orphanedDraft,
    required TResult orElse(),
  }) {
    if (orphanedDraft != null) {
      return orphanedDraft(this);
    }
    return orElse();
  }
}

abstract class AnomalyDto_OrphanedDraft extends AnomalyDto {
  const factory AnomalyDto_OrphanedDraft(
      {required final String entryId,
      required final String date}) = _$AnomalyDto_OrphanedDraftImpl;
  const AnomalyDto_OrphanedDraft._() : super._();

  String get entryId;
  String get date;
  @JsonKey(ignore: true)
  _$$AnomalyDto_OrphanedDraftImplCopyWith<_$AnomalyDto_OrphanedDraftImpl>
      get copyWith => throw _privateConstructorUsedError;
}
