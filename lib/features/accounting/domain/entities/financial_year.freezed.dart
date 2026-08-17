// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_year.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FinancialYear _$FinancialYearFromJson(Map<String, dynamic> json) {
  return _FinancialYear.fromJson(json);
}

/// @nodoc
mixin _$FinancialYear {
  /// Unique internal identifier for the fiscal year.
  String get id => throw _privateConstructorUsedError;

  /// Narrative name (e.g., "Fiscal Year 2024 - Saudi Operations").
  String get name => throw _privateConstructorUsedError;

  /// First day of the fiscal cycle (Inclusive).
  DateTime get startDate => throw _privateConstructorUsedError;

  /// Last day of the fiscal cycle (Inclusive).
  DateTime get endDate => throw _privateConstructorUsedError;

  /// Immutable flag indicating the year has been finalized and audited.
  bool get isClosed => throw _privateConstructorUsedError;

  /// Timestamp of the final year-end closing procedure.
  DateTime? get closedAt => throw _privateConstructorUsedError;

  /// User ID of the authorized personnel who executed the closing.
  String? get closedBy => throw _privateConstructorUsedError;

  /// Collection of specific sub-period IDs (e.g., Quarters/Months) that are locked.
  List<String> get lockedPeriodIds => throw _privateConstructorUsedError;

  /// Tenant identifier for data isolation.
  String? get userId => throw _privateConstructorUsedError;

  /// Local-to-Remote synchronization state.
  SyncStatus get syncStatus => throw _privateConstructorUsedError;

  /// Most recent synchronization timestamp from the server.
  DateTime? get serverUpdatedAt => throw _privateConstructorUsedError;

  /// Soft-deletion flag.
  bool get isDeleted => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FinancialYearCopyWith<FinancialYear> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialYearCopyWith<$Res> {
  factory $FinancialYearCopyWith(
          FinancialYear value, $Res Function(FinancialYear) then) =
      _$FinancialYearCopyWithImpl<$Res, FinancialYear>;
  @useResult
  $Res call(
      {String id,
      String name,
      DateTime startDate,
      DateTime endDate,
      bool isClosed,
      DateTime? closedAt,
      String? closedBy,
      List<String> lockedPeriodIds,
      String? userId,
      SyncStatus syncStatus,
      DateTime? serverUpdatedAt,
      bool isDeleted});
}

/// @nodoc
class _$FinancialYearCopyWithImpl<$Res, $Val extends FinancialYear>
    implements $FinancialYearCopyWith<$Res> {
  _$FinancialYearCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? isClosed = null,
    Object? closedAt = freezed,
    Object? closedBy = freezed,
    Object? lockedPeriodIds = null,
    Object? userId = freezed,
    Object? syncStatus = null,
    Object? serverUpdatedAt = freezed,
    Object? isDeleted = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isClosed: null == isClosed
          ? _value.isClosed
          : isClosed // ignore: cast_nullable_to_non_nullable
              as bool,
      closedAt: freezed == closedAt
          ? _value.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      closedBy: freezed == closedBy
          ? _value.closedBy
          : closedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      lockedPeriodIds: null == lockedPeriodIds
          ? _value.lockedPeriodIds
          : lockedPeriodIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
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
}

/// @nodoc
abstract class _$$FinancialYearImplCopyWith<$Res>
    implements $FinancialYearCopyWith<$Res> {
  factory _$$FinancialYearImplCopyWith(
          _$FinancialYearImpl value, $Res Function(_$FinancialYearImpl) then) =
      __$$FinancialYearImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      DateTime startDate,
      DateTime endDate,
      bool isClosed,
      DateTime? closedAt,
      String? closedBy,
      List<String> lockedPeriodIds,
      String? userId,
      SyncStatus syncStatus,
      DateTime? serverUpdatedAt,
      bool isDeleted});
}

/// @nodoc
class __$$FinancialYearImplCopyWithImpl<$Res>
    extends _$FinancialYearCopyWithImpl<$Res, _$FinancialYearImpl>
    implements _$$FinancialYearImplCopyWith<$Res> {
  __$$FinancialYearImplCopyWithImpl(
      _$FinancialYearImpl _value, $Res Function(_$FinancialYearImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? isClosed = null,
    Object? closedAt = freezed,
    Object? closedBy = freezed,
    Object? lockedPeriodIds = null,
    Object? userId = freezed,
    Object? syncStatus = null,
    Object? serverUpdatedAt = freezed,
    Object? isDeleted = null,
  }) {
    return _then(_$FinancialYearImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isClosed: null == isClosed
          ? _value.isClosed
          : isClosed // ignore: cast_nullable_to_non_nullable
              as bool,
      closedAt: freezed == closedAt
          ? _value.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      closedBy: freezed == closedBy
          ? _value.closedBy
          : closedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      lockedPeriodIds: null == lockedPeriodIds
          ? _value._lockedPeriodIds
          : lockedPeriodIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$FinancialYearImpl extends _FinancialYear {
  const _$FinancialYearImpl(
      {required this.id,
      required this.name,
      required this.startDate,
      required this.endDate,
      this.isClosed = false,
      this.closedAt,
      this.closedBy,
      final List<String> lockedPeriodIds = const [],
      this.userId,
      this.syncStatus = SyncStatus.synced,
      this.serverUpdatedAt,
      this.isDeleted = false})
      : _lockedPeriodIds = lockedPeriodIds,
        super._();

  factory _$FinancialYearImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialYearImplFromJson(json);

  /// Unique internal identifier for the fiscal year.
  @override
  final String id;

  /// Narrative name (e.g., "Fiscal Year 2024 - Saudi Operations").
  @override
  final String name;

  /// First day of the fiscal cycle (Inclusive).
  @override
  final DateTime startDate;

  /// Last day of the fiscal cycle (Inclusive).
  @override
  final DateTime endDate;

  /// Immutable flag indicating the year has been finalized and audited.
  @override
  @JsonKey()
  final bool isClosed;

  /// Timestamp of the final year-end closing procedure.
  @override
  final DateTime? closedAt;

  /// User ID of the authorized personnel who executed the closing.
  @override
  final String? closedBy;

  /// Collection of specific sub-period IDs (e.g., Quarters/Months) that are locked.
  final List<String> _lockedPeriodIds;

  /// Collection of specific sub-period IDs (e.g., Quarters/Months) that are locked.
  @override
  @JsonKey()
  List<String> get lockedPeriodIds {
    if (_lockedPeriodIds is EqualUnmodifiableListView) return _lockedPeriodIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lockedPeriodIds);
  }

  /// Tenant identifier for data isolation.
  @override
  final String? userId;

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
    return 'FinancialYear(id: $id, name: $name, startDate: $startDate, endDate: $endDate, isClosed: $isClosed, closedAt: $closedAt, closedBy: $closedBy, lockedPeriodIds: $lockedPeriodIds, userId: $userId, syncStatus: $syncStatus, serverUpdatedAt: $serverUpdatedAt, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialYearImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isClosed, isClosed) ||
                other.isClosed == isClosed) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt) &&
            (identical(other.closedBy, closedBy) ||
                other.closedBy == closedBy) &&
            const DeepCollectionEquality()
                .equals(other._lockedPeriodIds, _lockedPeriodIds) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.serverUpdatedAt, serverUpdatedAt) ||
                other.serverUpdatedAt == serverUpdatedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      startDate,
      endDate,
      isClosed,
      closedAt,
      closedBy,
      const DeepCollectionEquality().hash(_lockedPeriodIds),
      userId,
      syncStatus,
      serverUpdatedAt,
      isDeleted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialYearImplCopyWith<_$FinancialYearImpl> get copyWith =>
      __$$FinancialYearImplCopyWithImpl<_$FinancialYearImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialYearImplToJson(
      this,
    );
  }
}

abstract class _FinancialYear extends FinancialYear {
  const factory _FinancialYear(
      {required final String id,
      required final String name,
      required final DateTime startDate,
      required final DateTime endDate,
      final bool isClosed,
      final DateTime? closedAt,
      final String? closedBy,
      final List<String> lockedPeriodIds,
      final String? userId,
      final SyncStatus syncStatus,
      final DateTime? serverUpdatedAt,
      final bool isDeleted}) = _$FinancialYearImpl;
  const _FinancialYear._() : super._();

  factory _FinancialYear.fromJson(Map<String, dynamic> json) =
      _$FinancialYearImpl.fromJson;

  @override

  /// Unique internal identifier for the fiscal year.
  String get id;
  @override

  /// Narrative name (e.g., "Fiscal Year 2024 - Saudi Operations").
  String get name;
  @override

  /// First day of the fiscal cycle (Inclusive).
  DateTime get startDate;
  @override

  /// Last day of the fiscal cycle (Inclusive).
  DateTime get endDate;
  @override

  /// Immutable flag indicating the year has been finalized and audited.
  bool get isClosed;
  @override

  /// Timestamp of the final year-end closing procedure.
  DateTime? get closedAt;
  @override

  /// User ID of the authorized personnel who executed the closing.
  String? get closedBy;
  @override

  /// Collection of specific sub-period IDs (e.g., Quarters/Months) that are locked.
  List<String> get lockedPeriodIds;
  @override

  /// Tenant identifier for data isolation.
  String? get userId;
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
  _$$FinancialYearImplCopyWith<_$FinancialYearImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
