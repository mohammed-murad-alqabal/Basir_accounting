// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_ledger_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CustomerLedgerEntry _$CustomerLedgerEntryFromJson(Map<String, dynamic> json) {
  return _CustomerLedgerEntry.fromJson(json);
}

/// @nodoc
mixin _$CustomerLedgerEntry {
  /// Unique internal UUID for the entry.
  String get id => throw _privateConstructorUsedError;

  /// Reference to the customer account.
  String get customerId => throw _privateConstructorUsedError;

  /// Journal entry or document reference number.
  String get entryNumber => throw _privateConstructorUsedError;

  /// Date of the transaction.
  DateTime get entryDate => throw _privateConstructorUsedError;

  /// Description of the transaction.
  String get description => throw _privateConstructorUsedError;

  /// Debit amount (increases customer receivable).
  Decimal get debit => throw _privateConstructorUsedError;

  /// Credit amount (decreases customer receivable).
  Decimal get credit => throw _privateConstructorUsedError;

  /// Running balance after this entry.
  Decimal get balance => throw _privateConstructorUsedError;

  /// Source document type (sales_invoice, payment_receipt, etc.).
  String get sourceDocument => throw _privateConstructorUsedError;

  /// Unique identifier of the source document.
  String get sourceId => throw _privateConstructorUsedError;

  /// System-generated creation timestamp.
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// External reference number if applicable.
  String? get reference => throw _privateConstructorUsedError;

  /// User ID who created this entry.
  String? get createdBy => throw _privateConstructorUsedError;

  /// User ID for multi-tenant data isolation.
  String? get userId => throw _privateConstructorUsedError;

  /// Local-to-remote synchronization state.
  SyncStatus get syncStatus => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CustomerLedgerEntryCopyWith<CustomerLedgerEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerLedgerEntryCopyWith<$Res> {
  factory $CustomerLedgerEntryCopyWith(
          CustomerLedgerEntry value, $Res Function(CustomerLedgerEntry) then) =
      _$CustomerLedgerEntryCopyWithImpl<$Res, CustomerLedgerEntry>;
  @useResult
  $Res call(
      {String id,
      String customerId,
      String entryNumber,
      DateTime entryDate,
      String description,
      Decimal debit,
      Decimal credit,
      Decimal balance,
      String sourceDocument,
      String sourceId,
      DateTime createdAt,
      String? reference,
      String? createdBy,
      String? userId,
      SyncStatus syncStatus});
}

/// @nodoc
class _$CustomerLedgerEntryCopyWithImpl<$Res, $Val extends CustomerLedgerEntry>
    implements $CustomerLedgerEntryCopyWith<$Res> {
  _$CustomerLedgerEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerId = null,
    Object? entryNumber = null,
    Object? entryDate = null,
    Object? description = null,
    Object? debit = null,
    Object? credit = null,
    Object? balance = null,
    Object? sourceDocument = null,
    Object? sourceId = null,
    Object? createdAt = null,
    Object? reference = freezed,
    Object? createdBy = freezed,
    Object? userId = freezed,
    Object? syncStatus = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      entryNumber: null == entryNumber
          ? _value.entryNumber
          : entryNumber // ignore: cast_nullable_to_non_nullable
              as String,
      entryDate: null == entryDate
          ? _value.entryDate
          : entryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      debit: null == debit
          ? _value.debit
          : debit // ignore: cast_nullable_to_non_nullable
              as Decimal,
      credit: null == credit
          ? _value.credit
          : credit // ignore: cast_nullable_to_non_nullable
              as Decimal,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as Decimal,
      sourceDocument: null == sourceDocument
          ? _value.sourceDocument
          : sourceDocument // ignore: cast_nullable_to_non_nullable
              as String,
      sourceId: null == sourceId
          ? _value.sourceId
          : sourceId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CustomerLedgerEntryImplCopyWith<$Res>
    implements $CustomerLedgerEntryCopyWith<$Res> {
  factory _$$CustomerLedgerEntryImplCopyWith(_$CustomerLedgerEntryImpl value,
          $Res Function(_$CustomerLedgerEntryImpl) then) =
      __$$CustomerLedgerEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String customerId,
      String entryNumber,
      DateTime entryDate,
      String description,
      Decimal debit,
      Decimal credit,
      Decimal balance,
      String sourceDocument,
      String sourceId,
      DateTime createdAt,
      String? reference,
      String? createdBy,
      String? userId,
      SyncStatus syncStatus});
}

/// @nodoc
class __$$CustomerLedgerEntryImplCopyWithImpl<$Res>
    extends _$CustomerLedgerEntryCopyWithImpl<$Res, _$CustomerLedgerEntryImpl>
    implements _$$CustomerLedgerEntryImplCopyWith<$Res> {
  __$$CustomerLedgerEntryImplCopyWithImpl(_$CustomerLedgerEntryImpl _value,
      $Res Function(_$CustomerLedgerEntryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerId = null,
    Object? entryNumber = null,
    Object? entryDate = null,
    Object? description = null,
    Object? debit = null,
    Object? credit = null,
    Object? balance = null,
    Object? sourceDocument = null,
    Object? sourceId = null,
    Object? createdAt = null,
    Object? reference = freezed,
    Object? createdBy = freezed,
    Object? userId = freezed,
    Object? syncStatus = null,
  }) {
    return _then(_$CustomerLedgerEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      entryNumber: null == entryNumber
          ? _value.entryNumber
          : entryNumber // ignore: cast_nullable_to_non_nullable
              as String,
      entryDate: null == entryDate
          ? _value.entryDate
          : entryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      debit: null == debit
          ? _value.debit
          : debit // ignore: cast_nullable_to_non_nullable
              as Decimal,
      credit: null == credit
          ? _value.credit
          : credit // ignore: cast_nullable_to_non_nullable
              as Decimal,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as Decimal,
      sourceDocument: null == sourceDocument
          ? _value.sourceDocument
          : sourceDocument // ignore: cast_nullable_to_non_nullable
              as String,
      sourceId: null == sourceId
          ? _value.sourceId
          : sourceId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerLedgerEntryImpl extends _CustomerLedgerEntry {
  const _$CustomerLedgerEntryImpl(
      {required this.id,
      required this.customerId,
      required this.entryNumber,
      required this.entryDate,
      required this.description,
      required this.debit,
      required this.credit,
      required this.balance,
      required this.sourceDocument,
      required this.sourceId,
      required this.createdAt,
      this.reference,
      this.createdBy,
      this.userId,
      this.syncStatus = SyncStatus.synced})
      : super._();

  factory _$CustomerLedgerEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerLedgerEntryImplFromJson(json);

  /// Unique internal UUID for the entry.
  @override
  final String id;

  /// Reference to the customer account.
  @override
  final String customerId;

  /// Journal entry or document reference number.
  @override
  final String entryNumber;

  /// Date of the transaction.
  @override
  final DateTime entryDate;

  /// Description of the transaction.
  @override
  final String description;

  /// Debit amount (increases customer receivable).
  @override
  final Decimal debit;

  /// Credit amount (decreases customer receivable).
  @override
  final Decimal credit;

  /// Running balance after this entry.
  @override
  final Decimal balance;

  /// Source document type (sales_invoice, payment_receipt, etc.).
  @override
  final String sourceDocument;

  /// Unique identifier of the source document.
  @override
  final String sourceId;

  /// System-generated creation timestamp.
  @override
  final DateTime createdAt;

  /// External reference number if applicable.
  @override
  final String? reference;

  /// User ID who created this entry.
  @override
  final String? createdBy;

  /// User ID for multi-tenant data isolation.
  @override
  final String? userId;

  /// Local-to-remote synchronization state.
  @override
  @JsonKey()
  final SyncStatus syncStatus;

  @override
  String toString() {
    return 'CustomerLedgerEntry(id: $id, customerId: $customerId, entryNumber: $entryNumber, entryDate: $entryDate, description: $description, debit: $debit, credit: $credit, balance: $balance, sourceDocument: $sourceDocument, sourceId: $sourceId, createdAt: $createdAt, reference: $reference, createdBy: $createdBy, userId: $userId, syncStatus: $syncStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerLedgerEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.entryNumber, entryNumber) ||
                other.entryNumber == entryNumber) &&
            (identical(other.entryDate, entryDate) ||
                other.entryDate == entryDate) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.debit, debit) || other.debit == debit) &&
            (identical(other.credit, credit) || other.credit == credit) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.sourceDocument, sourceDocument) ||
                other.sourceDocument == sourceDocument) &&
            (identical(other.sourceId, sourceId) ||
                other.sourceId == sourceId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      customerId,
      entryNumber,
      entryDate,
      description,
      debit,
      credit,
      balance,
      sourceDocument,
      sourceId,
      createdAt,
      reference,
      createdBy,
      userId,
      syncStatus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerLedgerEntryImplCopyWith<_$CustomerLedgerEntryImpl> get copyWith =>
      __$$CustomerLedgerEntryImplCopyWithImpl<_$CustomerLedgerEntryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerLedgerEntryImplToJson(
      this,
    );
  }
}

abstract class _CustomerLedgerEntry extends CustomerLedgerEntry {
  const factory _CustomerLedgerEntry(
      {required final String id,
      required final String customerId,
      required final String entryNumber,
      required final DateTime entryDate,
      required final String description,
      required final Decimal debit,
      required final Decimal credit,
      required final Decimal balance,
      required final String sourceDocument,
      required final String sourceId,
      required final DateTime createdAt,
      final String? reference,
      final String? createdBy,
      final String? userId,
      final SyncStatus syncStatus}) = _$CustomerLedgerEntryImpl;
  const _CustomerLedgerEntry._() : super._();

  factory _CustomerLedgerEntry.fromJson(Map<String, dynamic> json) =
      _$CustomerLedgerEntryImpl.fromJson;

  @override

  /// Unique internal UUID for the entry.
  String get id;
  @override

  /// Reference to the customer account.
  String get customerId;
  @override

  /// Journal entry or document reference number.
  String get entryNumber;
  @override

  /// Date of the transaction.
  DateTime get entryDate;
  @override

  /// Description of the transaction.
  String get description;
  @override

  /// Debit amount (increases customer receivable).
  Decimal get debit;
  @override

  /// Credit amount (decreases customer receivable).
  Decimal get credit;
  @override

  /// Running balance after this entry.
  Decimal get balance;
  @override

  /// Source document type (sales_invoice, payment_receipt, etc.).
  String get sourceDocument;
  @override

  /// Unique identifier of the source document.
  String get sourceId;
  @override

  /// System-generated creation timestamp.
  DateTime get createdAt;
  @override

  /// External reference number if applicable.
  String? get reference;
  @override

  /// User ID who created this entry.
  String? get createdBy;
  @override

  /// User ID for multi-tenant data isolation.
  String? get userId;
  @override

  /// Local-to-remote synchronization state.
  SyncStatus get syncStatus;
  @override
  @JsonKey(ignore: true)
  _$$CustomerLedgerEntryImplCopyWith<_$CustomerLedgerEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
