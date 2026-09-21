// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_voucher.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FinancialVoucher _$FinancialVoucherFromJson(Map<String, dynamic> json) {
  return _FinancialVoucher.fromJson(json);
}

/// @nodoc
mixin _$FinancialVoucher {
  /// Unique internal identifier.
  String get id => throw _privateConstructorUsedError;

  /// External reference number (e.g., "PV-2024-001").
  String get referenceNumber => throw _privateConstructorUsedError;

  /// Date the payment or receipt was executed.
  DateTime get date => throw _privateConstructorUsedError;

  /// Direction of fund flow (Receipt/Payment).
  VoucherType get type => throw _privateConstructorUsedError;

  /// Settlement instrument (Cash/Bank/Check).
  PaymentMethod get paymentMethod => throw _privateConstructorUsedError;

  /// Face value of the transaction as [Decimal].
  Decimal get amount => throw _privateConstructorUsedError;

  /// The offset account ID (e.g., Customer AR or Vendor AP).
  String get accountId => throw _privateConstructorUsedError;

  /// The liquid asset account ID (e.g., Cash Office or Bank Account).
  String get treasuryAccountId => throw _privateConstructorUsedError;

  /// Detailed description or memo of the transaction purpose.
  String get description => throw _privateConstructorUsedError;

  /// Initial system recording timestamp.
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Name of the paying person or receiving entity (Manual/Denormalized).
  String? get personName => throw _privateConstructorUsedError;

  /// Migration status: if true, the voucher has been posted to the General
  /// Ledger.
  bool get isPosted => throw _privateConstructorUsedError;

  /// Link to the resulting [JournalEntry] ID after posting.
  String? get journalEntryId => throw _privateConstructorUsedError;

  /// Tenant/Owner identifier.
  String? get userId => throw _privateConstructorUsedError;

  /// Original transaction currency (ISO code).
  String? get originalCurrency => throw _privateConstructorUsedError;

  /// Conversion rate used for local currency recording.
  Decimal? get exchangeRate => throw _privateConstructorUsedError;

  /// Face value in [originalCurrency].
  Decimal? get originalAmount => throw _privateConstructorUsedError;

  /// Local-to-Remote synchronization state.
  SyncStatus get syncStatus => throw _privateConstructorUsedError;

  /// Most recent synchronization timestamp from the server.
  DateTime? get serverUpdatedAt => throw _privateConstructorUsedError;

  /// Soft-deletion flag.
  bool get isDeleted => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FinancialVoucherCopyWith<FinancialVoucher> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialVoucherCopyWith<$Res> {
  factory $FinancialVoucherCopyWith(
          FinancialVoucher value, $Res Function(FinancialVoucher) then) =
      _$FinancialVoucherCopyWithImpl<$Res, FinancialVoucher>;
  @useResult
  $Res call(
      {String id,
      String referenceNumber,
      DateTime date,
      VoucherType type,
      PaymentMethod paymentMethod,
      Decimal amount,
      String accountId,
      String treasuryAccountId,
      String description,
      DateTime createdAt,
      String? personName,
      bool isPosted,
      String? journalEntryId,
      String? userId,
      String? originalCurrency,
      Decimal? exchangeRate,
      Decimal? originalAmount,
      SyncStatus syncStatus,
      DateTime? serverUpdatedAt,
      bool isDeleted});
}

/// @nodoc
class _$FinancialVoucherCopyWithImpl<$Res, $Val extends FinancialVoucher>
    implements $FinancialVoucherCopyWith<$Res> {
  _$FinancialVoucherCopyWithImpl(this._value, this._then);

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
    Object? type = null,
    Object? paymentMethod = null,
    Object? amount = null,
    Object? accountId = null,
    Object? treasuryAccountId = null,
    Object? description = null,
    Object? createdAt = null,
    Object? personName = freezed,
    Object? isPosted = null,
    Object? journalEntryId = freezed,
    Object? userId = freezed,
    Object? originalCurrency = freezed,
    Object? exchangeRate = freezed,
    Object? originalAmount = freezed,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as VoucherType,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      treasuryAccountId: null == treasuryAccountId
          ? _value.treasuryAccountId
          : treasuryAccountId // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      personName: freezed == personName
          ? _value.personName
          : personName // ignore: cast_nullable_to_non_nullable
              as String?,
      isPosted: null == isPosted
          ? _value.isPosted
          : isPosted // ignore: cast_nullable_to_non_nullable
              as bool,
      journalEntryId: freezed == journalEntryId
          ? _value.journalEntryId
          : journalEntryId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$FinancialVoucherImplCopyWith<$Res>
    implements $FinancialVoucherCopyWith<$Res> {
  factory _$$FinancialVoucherImplCopyWith(_$FinancialVoucherImpl value,
          $Res Function(_$FinancialVoucherImpl) then) =
      __$$FinancialVoucherImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String referenceNumber,
      DateTime date,
      VoucherType type,
      PaymentMethod paymentMethod,
      Decimal amount,
      String accountId,
      String treasuryAccountId,
      String description,
      DateTime createdAt,
      String? personName,
      bool isPosted,
      String? journalEntryId,
      String? userId,
      String? originalCurrency,
      Decimal? exchangeRate,
      Decimal? originalAmount,
      SyncStatus syncStatus,
      DateTime? serverUpdatedAt,
      bool isDeleted});
}

/// @nodoc
class __$$FinancialVoucherImplCopyWithImpl<$Res>
    extends _$FinancialVoucherCopyWithImpl<$Res, _$FinancialVoucherImpl>
    implements _$$FinancialVoucherImplCopyWith<$Res> {
  __$$FinancialVoucherImplCopyWithImpl(_$FinancialVoucherImpl _value,
      $Res Function(_$FinancialVoucherImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? referenceNumber = null,
    Object? date = null,
    Object? type = null,
    Object? paymentMethod = null,
    Object? amount = null,
    Object? accountId = null,
    Object? treasuryAccountId = null,
    Object? description = null,
    Object? createdAt = null,
    Object? personName = freezed,
    Object? isPosted = null,
    Object? journalEntryId = freezed,
    Object? userId = freezed,
    Object? originalCurrency = freezed,
    Object? exchangeRate = freezed,
    Object? originalAmount = freezed,
    Object? syncStatus = null,
    Object? serverUpdatedAt = freezed,
    Object? isDeleted = null,
  }) {
    return _then(_$FinancialVoucherImpl(
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as VoucherType,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      treasuryAccountId: null == treasuryAccountId
          ? _value.treasuryAccountId
          : treasuryAccountId // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      personName: freezed == personName
          ? _value.personName
          : personName // ignore: cast_nullable_to_non_nullable
              as String?,
      isPosted: null == isPosted
          ? _value.isPosted
          : isPosted // ignore: cast_nullable_to_non_nullable
              as bool,
      journalEntryId: freezed == journalEntryId
          ? _value.journalEntryId
          : journalEntryId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
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
class _$FinancialVoucherImpl implements _FinancialVoucher {
  const _$FinancialVoucherImpl(
      {required this.id,
      required this.referenceNumber,
      required this.date,
      required this.type,
      required this.paymentMethod,
      required this.amount,
      required this.accountId,
      required this.treasuryAccountId,
      required this.description,
      required this.createdAt,
      this.personName,
      this.isPosted = false,
      this.journalEntryId,
      this.userId,
      this.originalCurrency,
      this.exchangeRate,
      this.originalAmount,
      this.syncStatus = SyncStatus.synced,
      this.serverUpdatedAt,
      this.isDeleted = false});

  factory _$FinancialVoucherImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialVoucherImplFromJson(json);

  /// Unique internal identifier.
  @override
  final String id;

  /// External reference number (e.g., "PV-2024-001").
  @override
  final String referenceNumber;

  /// Date the payment or receipt was executed.
  @override
  final DateTime date;

  /// Direction of fund flow (Receipt/Payment).
  @override
  final VoucherType type;

  /// Settlement instrument (Cash/Bank/Check).
  @override
  final PaymentMethod paymentMethod;

  /// Face value of the transaction as [Decimal].
  @override
  final Decimal amount;

  /// The offset account ID (e.g., Customer AR or Vendor AP).
  @override
  final String accountId;

  /// The liquid asset account ID (e.g., Cash Office or Bank Account).
  @override
  final String treasuryAccountId;

  /// Detailed description or memo of the transaction purpose.
  @override
  final String description;

  /// Initial system recording timestamp.
  @override
  final DateTime createdAt;

  /// Name of the paying person or receiving entity (Manual/Denormalized).
  @override
  final String? personName;

  /// Migration status: if true, the voucher has been posted to the General
  /// Ledger.
  @override
  @JsonKey()
  final bool isPosted;

  /// Link to the resulting [JournalEntry] ID after posting.
  @override
  final String? journalEntryId;

  /// Tenant/Owner identifier.
  @override
  final String? userId;

  /// Original transaction currency (ISO code).
  @override
  final String? originalCurrency;

  /// Conversion rate used for local currency recording.
  @override
  final Decimal? exchangeRate;

  /// Face value in [originalCurrency].
  @override
  final Decimal? originalAmount;

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
    return 'FinancialVoucher(id: $id, referenceNumber: $referenceNumber, date: $date, type: $type, paymentMethod: $paymentMethod, amount: $amount, accountId: $accountId, treasuryAccountId: $treasuryAccountId, description: $description, createdAt: $createdAt, personName: $personName, isPosted: $isPosted, journalEntryId: $journalEntryId, userId: $userId, originalCurrency: $originalCurrency, exchangeRate: $exchangeRate, originalAmount: $originalAmount, syncStatus: $syncStatus, serverUpdatedAt: $serverUpdatedAt, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialVoucherImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.referenceNumber, referenceNumber) ||
                other.referenceNumber == referenceNumber) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.treasuryAccountId, treasuryAccountId) ||
                other.treasuryAccountId == treasuryAccountId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.personName, personName) ||
                other.personName == personName) &&
            (identical(other.isPosted, isPosted) ||
                other.isPosted == isPosted) &&
            (identical(other.journalEntryId, journalEntryId) ||
                other.journalEntryId == journalEntryId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.originalCurrency, originalCurrency) ||
                other.originalCurrency == originalCurrency) &&
            (identical(other.exchangeRate, exchangeRate) ||
                other.exchangeRate == exchangeRate) &&
            (identical(other.originalAmount, originalAmount) ||
                other.originalAmount == originalAmount) &&
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
        type,
        paymentMethod,
        amount,
        accountId,
        treasuryAccountId,
        description,
        createdAt,
        personName,
        isPosted,
        journalEntryId,
        userId,
        originalCurrency,
        exchangeRate,
        originalAmount,
        syncStatus,
        serverUpdatedAt,
        isDeleted
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialVoucherImplCopyWith<_$FinancialVoucherImpl> get copyWith =>
      __$$FinancialVoucherImplCopyWithImpl<_$FinancialVoucherImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialVoucherImplToJson(
      this,
    );
  }
}

abstract class _FinancialVoucher implements FinancialVoucher {
  const factory _FinancialVoucher(
      {required final String id,
      required final String referenceNumber,
      required final DateTime date,
      required final VoucherType type,
      required final PaymentMethod paymentMethod,
      required final Decimal amount,
      required final String accountId,
      required final String treasuryAccountId,
      required final String description,
      required final DateTime createdAt,
      final String? personName,
      final bool isPosted,
      final String? journalEntryId,
      final String? userId,
      final String? originalCurrency,
      final Decimal? exchangeRate,
      final Decimal? originalAmount,
      final SyncStatus syncStatus,
      final DateTime? serverUpdatedAt,
      final bool isDeleted}) = _$FinancialVoucherImpl;

  factory _FinancialVoucher.fromJson(Map<String, dynamic> json) =
      _$FinancialVoucherImpl.fromJson;

  @override

  /// Unique internal identifier.
  String get id;
  @override

  /// External reference number (e.g., "PV-2024-001").
  String get referenceNumber;
  @override

  /// Date the payment or receipt was executed.
  DateTime get date;
  @override

  /// Direction of fund flow (Receipt/Payment).
  VoucherType get type;
  @override

  /// Settlement instrument (Cash/Bank/Check).
  PaymentMethod get paymentMethod;
  @override

  /// Face value of the transaction as [Decimal].
  Decimal get amount;
  @override

  /// The offset account ID (e.g., Customer AR or Vendor AP).
  String get accountId;
  @override

  /// The liquid asset account ID (e.g., Cash Office or Bank Account).
  String get treasuryAccountId;
  @override

  /// Detailed description or memo of the transaction purpose.
  String get description;
  @override

  /// Initial system recording timestamp.
  DateTime get createdAt;
  @override

  /// Name of the paying person or receiving entity (Manual/Denormalized).
  String? get personName;
  @override

  /// Migration status: if true, the voucher has been posted to the General
  /// Ledger.
  bool get isPosted;
  @override

  /// Link to the resulting [JournalEntry] ID after posting.
  String? get journalEntryId;
  @override

  /// Tenant/Owner identifier.
  String? get userId;
  @override

  /// Original transaction currency (ISO code).
  String? get originalCurrency;
  @override

  /// Conversion rate used for local currency recording.
  Decimal? get exchangeRate;
  @override

  /// Face value in [originalCurrency].
  Decimal? get originalAmount;
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
  _$$FinancialVoucherImplCopyWith<_$FinancialVoucherImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
