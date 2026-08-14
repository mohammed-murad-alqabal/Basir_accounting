// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Account _$AccountFromJson(Map<String, dynamic> json) {
  return _Account.fromJson(json);
}

/// @nodoc
mixin _$Account {
  /// Unique internal identifier for the account.
  String get id => throw _privateConstructorUsedError;

  /// Unique accounting code for structured reporting (e.g., "1101" for Cash).
  String get code => throw _privateConstructorUsedError;

  /// Primary Arabic display name (e.g., "النقدية").
  String get nameAr => throw _privateConstructorUsedError;

  /// Primary English display name (e.g., "Cash").
  String get nameEn => throw _privateConstructorUsedError;

  /// High-level categorization (Asset, Liability, etc.).
  AccountType get type => throw _privateConstructorUsedError;

  /// Normal balance nature of the account (Debit/Credit).
  AccountNature get nature => throw _privateConstructorUsedError;

  /// Current net balance persisted as a high-precision [Decimal].
  Decimal get balance => throw _privateConstructorUsedError;

  /// Functional sub-type for automated processing (e.g., "cash", "bank",
  /// "ar").
  String get subType => throw _privateConstructorUsedError;

  /// IFRS 18 specific category mapping for optimized P&L presentation.
  Ifrs18Category? get ifrs18Category => throw _privateConstructorUsedError;

  /// Indicates if this is a grouping (Parent) account that aggregates child
  /// balances.
  bool get isParent => throw _privateConstructorUsedError;

  /// Reference to the immediate parent account for tree traversal.
  String? get parentId => throw _privateConstructorUsedError;

  /// Operational status: if false, the account is hidden from active posting.
  bool get isActive => throw _privateConstructorUsedError;

  /// If true, the account is a core system-defined account and cannot be
  /// deleted.
  bool get isSystem => throw _privateConstructorUsedError;

  /// Multi-tenant identifier isolating data per user.
  String? get userId => throw _privateConstructorUsedError;

  /// Local-to-Remote synchronization state.
  SyncStatus get syncStatus => throw _privateConstructorUsedError;

  /// Most recent synchronization timestamp from the server.
  DateTime? get serverUpdatedAt => throw _privateConstructorUsedError;

  /// Soft-deletion flag for audit trail preservation.
  bool get isDeleted => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AccountCopyWith<Account> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountCopyWith<$Res> {
  factory $AccountCopyWith(Account value, $Res Function(Account) then) =
      _$AccountCopyWithImpl<$Res, Account>;
  @useResult
  $Res call(
      {String id,
      String code,
      String nameAr,
      String nameEn,
      AccountType type,
      AccountNature nature,
      Decimal balance,
      String subType,
      Ifrs18Category? ifrs18Category,
      bool isParent,
      String? parentId,
      bool isActive,
      bool isSystem,
      String? userId,
      SyncStatus syncStatus,
      DateTime? serverUpdatedAt,
      bool isDeleted});
}

/// @nodoc
class _$AccountCopyWithImpl<$Res, $Val extends Account>
    implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? type = null,
    Object? nature = null,
    Object? balance = null,
    Object? subType = null,
    Object? ifrs18Category = freezed,
    Object? isParent = null,
    Object? parentId = freezed,
    Object? isActive = null,
    Object? isSystem = null,
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
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AccountType,
      nature: null == nature
          ? _value.nature
          : nature // ignore: cast_nullable_to_non_nullable
              as AccountNature,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as Decimal,
      subType: null == subType
          ? _value.subType
          : subType // ignore: cast_nullable_to_non_nullable
              as String,
      ifrs18Category: freezed == ifrs18Category
          ? _value.ifrs18Category
          : ifrs18Category // ignore: cast_nullable_to_non_nullable
              as Ifrs18Category?,
      isParent: null == isParent
          ? _value.isParent
          : isParent // ignore: cast_nullable_to_non_nullable
              as bool,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isSystem: null == isSystem
          ? _value.isSystem
          : isSystem // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$AccountImplCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$$AccountImplCopyWith(
          _$AccountImpl value, $Res Function(_$AccountImpl) then) =
      __$$AccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String code,
      String nameAr,
      String nameEn,
      AccountType type,
      AccountNature nature,
      Decimal balance,
      String subType,
      Ifrs18Category? ifrs18Category,
      bool isParent,
      String? parentId,
      bool isActive,
      bool isSystem,
      String? userId,
      SyncStatus syncStatus,
      DateTime? serverUpdatedAt,
      bool isDeleted});
}

/// @nodoc
class __$$AccountImplCopyWithImpl<$Res>
    extends _$AccountCopyWithImpl<$Res, _$AccountImpl>
    implements _$$AccountImplCopyWith<$Res> {
  __$$AccountImplCopyWithImpl(
      _$AccountImpl _value, $Res Function(_$AccountImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? type = null,
    Object? nature = null,
    Object? balance = null,
    Object? subType = null,
    Object? ifrs18Category = freezed,
    Object? isParent = null,
    Object? parentId = freezed,
    Object? isActive = null,
    Object? isSystem = null,
    Object? userId = freezed,
    Object? syncStatus = null,
    Object? serverUpdatedAt = freezed,
    Object? isDeleted = null,
  }) {
    return _then(_$AccountImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AccountType,
      nature: null == nature
          ? _value.nature
          : nature // ignore: cast_nullable_to_non_nullable
              as AccountNature,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as Decimal,
      subType: null == subType
          ? _value.subType
          : subType // ignore: cast_nullable_to_non_nullable
              as String,
      ifrs18Category: freezed == ifrs18Category
          ? _value.ifrs18Category
          : ifrs18Category // ignore: cast_nullable_to_non_nullable
              as Ifrs18Category?,
      isParent: null == isParent
          ? _value.isParent
          : isParent // ignore: cast_nullable_to_non_nullable
              as bool,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isSystem: null == isSystem
          ? _value.isSystem
          : isSystem // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$AccountImpl extends _Account {
  const _$AccountImpl(
      {required this.id,
      required this.code,
      required this.nameAr,
      required this.nameEn,
      required this.type,
      required this.nature,
      required this.balance,
      this.subType = '',
      this.ifrs18Category,
      this.isParent = false,
      this.parentId,
      this.isActive = true,
      this.isSystem = false,
      this.userId,
      this.syncStatus = SyncStatus.synced,
      this.serverUpdatedAt,
      this.isDeleted = false})
      : super._();

  factory _$AccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountImplFromJson(json);

  /// Unique internal identifier for the account.
  @override
  final String id;

  /// Unique accounting code for structured reporting (e.g., "1101" for Cash).
  @override
  final String code;

  /// Primary Arabic display name (e.g., "النقدية").
  @override
  final String nameAr;

  /// Primary English display name (e.g., "Cash").
  @override
  final String nameEn;

  /// High-level categorization (Asset, Liability, etc.).
  @override
  final AccountType type;

  /// Normal balance nature of the account (Debit/Credit).
  @override
  final AccountNature nature;

  /// Current net balance persisted as a high-precision [Decimal].
  @override
  final Decimal balance;

  /// Functional sub-type for automated processing (e.g., "cash", "bank",
  /// "ar").
  @override
  @JsonKey()
  final String subType;

  /// IFRS 18 specific category mapping for optimized P&L presentation.
  @override
  final Ifrs18Category? ifrs18Category;

  /// Indicates if this is a grouping (Parent) account that aggregates child
  /// balances.
  @override
  @JsonKey()
  final bool isParent;

  /// Reference to the immediate parent account for tree traversal.
  @override
  final String? parentId;

  /// Operational status: if false, the account is hidden from active posting.
  @override
  @JsonKey()
  final bool isActive;

  /// If true, the account is a core system-defined account and cannot be
  /// deleted.
  @override
  @JsonKey()
  final bool isSystem;

  /// Multi-tenant identifier isolating data per user.
  @override
  final String? userId;

  /// Local-to-Remote synchronization state.
  @override
  @JsonKey()
  final SyncStatus syncStatus;

  /// Most recent synchronization timestamp from the server.
  @override
  final DateTime? serverUpdatedAt;

  /// Soft-deletion flag for audit trail preservation.
  @override
  @JsonKey()
  final bool isDeleted;

  @override
  String toString() {
    return 'Account(id: $id, code: $code, nameAr: $nameAr, nameEn: $nameEn, type: $type, nature: $nature, balance: $balance, subType: $subType, ifrs18Category: $ifrs18Category, isParent: $isParent, parentId: $parentId, isActive: $isActive, isSystem: $isSystem, userId: $userId, syncStatus: $syncStatus, serverUpdatedAt: $serverUpdatedAt, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.nature, nature) || other.nature == nature) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.subType, subType) || other.subType == subType) &&
            (identical(other.ifrs18Category, ifrs18Category) ||
                other.ifrs18Category == ifrs18Category) &&
            (identical(other.isParent, isParent) ||
                other.isParent == isParent) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isSystem, isSystem) ||
                other.isSystem == isSystem) &&
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
      code,
      nameAr,
      nameEn,
      type,
      nature,
      balance,
      subType,
      ifrs18Category,
      isParent,
      parentId,
      isActive,
      isSystem,
      userId,
      syncStatus,
      serverUpdatedAt,
      isDeleted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountImplCopyWith<_$AccountImpl> get copyWith =>
      __$$AccountImplCopyWithImpl<_$AccountImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountImplToJson(
      this,
    );
  }
}

abstract class _Account extends Account {
  const factory _Account(
      {required final String id,
      required final String code,
      required final String nameAr,
      required final String nameEn,
      required final AccountType type,
      required final AccountNature nature,
      required final Decimal balance,
      final String subType,
      final Ifrs18Category? ifrs18Category,
      final bool isParent,
      final String? parentId,
      final bool isActive,
      final bool isSystem,
      final String? userId,
      final SyncStatus syncStatus,
      final DateTime? serverUpdatedAt,
      final bool isDeleted}) = _$AccountImpl;
  const _Account._() : super._();

  factory _Account.fromJson(Map<String, dynamic> json) = _$AccountImpl.fromJson;

  @override

  /// Unique internal identifier for the account.
  String get id;
  @override

  /// Unique accounting code for structured reporting (e.g., "1101" for Cash).
  String get code;
  @override

  /// Primary Arabic display name (e.g., "النقدية").
  String get nameAr;
  @override

  /// Primary English display name (e.g., "Cash").
  String get nameEn;
  @override

  /// High-level categorization (Asset, Liability, etc.).
  AccountType get type;
  @override

  /// Normal balance nature of the account (Debit/Credit).
  AccountNature get nature;
  @override

  /// Current net balance persisted as a high-precision [Decimal].
  Decimal get balance;
  @override

  /// Functional sub-type for automated processing (e.g., "cash", "bank",
  /// "ar").
  String get subType;
  @override

  /// IFRS 18 specific category mapping for optimized P&L presentation.
  Ifrs18Category? get ifrs18Category;
  @override

  /// Indicates if this is a grouping (Parent) account that aggregates child
  /// balances.
  bool get isParent;
  @override

  /// Reference to the immediate parent account for tree traversal.
  String? get parentId;
  @override

  /// Operational status: if false, the account is hidden from active posting.
  bool get isActive;
  @override

  /// If true, the account is a core system-defined account and cannot be
  /// deleted.
  bool get isSystem;
  @override

  /// Multi-tenant identifier isolating data per user.
  String? get userId;
  @override

  /// Local-to-Remote synchronization state.
  SyncStatus get syncStatus;
  @override

  /// Most recent synchronization timestamp from the server.
  DateTime? get serverUpdatedAt;
  @override

  /// Soft-deletion flag for audit trail preservation.
  bool get isDeleted;
  @override
  @JsonKey(ignore: true)
  _$$AccountImplCopyWith<_$AccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
