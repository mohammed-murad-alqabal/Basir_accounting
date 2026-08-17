// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_voucher.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentVoucher _$PaymentVoucherFromJson(Map<String, dynamic> json) {
  return _PaymentVoucher.fromJson(json);
}

/// @nodoc
mixin _$PaymentVoucher {
  /// Unique internal UUID for the voucher.
  String get id => throw _privateConstructorUsedError;

  /// Human-readable unique serial number (e.g., "VCHR-2024-001").
  String get voucherNumber => throw _privateConstructorUsedError;

  /// Reference to the vendor receiving the payment.
  String get vendorId => throw _privateConstructorUsedError;

  /// Denormalized vendor name for display and audit purposes.
  String get vendorName => throw _privateConstructorUsedError;

  /// Payment amount in base currency (SAR).
  Decimal get amount => throw _privateConstructorUsedError;

  /// Date and time of payment.
  DateTime get paymentDate => throw _privateConstructorUsedError;

  /// Method of payment (cash, bank transfer, check, etc.).
  PaymentMethod get paymentMethod => throw _privateConstructorUsedError;

  /// Cash or Bank account ID from which payment is made.
  String get accountId => throw _privateConstructorUsedError;

  /// User ID of the person recording the voucher.
  String get createdBy => throw _privateConstructorUsedError;

  /// System-generated creation timestamp in UTC.
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// External reference number (bank reference, check number, etc.).
  String? get reference => throw _privateConstructorUsedError;

  /// Optional notes or description.
  String? get notes => throw _privateConstructorUsedError;

  /// Bank account number for bank transfers.
  String? get bankAccountNumber => throw _privateConstructorUsedError;

  /// Check number for check payments.
  String? get checkNumber => throw _privateConstructorUsedError;

  /// Due date for check payment (if applicable).
  DateTime? get checkDueDate => throw _privateConstructorUsedError;

  /// Current status of the payment.
  PaymentStatus get status => throw _privateConstructorUsedError;

  /// ID of the journal entry created for this voucher.
  String? get journalEntryId => throw _privateConstructorUsedError;

  /// User ID for multi-tenant data isolation.
  String? get userId => throw _privateConstructorUsedError;

  /// Warehouse scope identifier for multi-branch operations.
  String? get warehouseId => throw _privateConstructorUsedError;

  /// Local-to-remote synchronization state.
  SyncStatus get syncStatus => throw _privateConstructorUsedError;

  /// Most recent synchronization timestamp from the server.
  DateTime? get serverUpdatedAt => throw _privateConstructorUsedError;

  /// Soft-deletion flag for audit trail preservation.
  bool get isDeleted => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaymentVoucherCopyWith<PaymentVoucher> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentVoucherCopyWith<$Res> {
  factory $PaymentVoucherCopyWith(
          PaymentVoucher value, $Res Function(PaymentVoucher) then) =
      _$PaymentVoucherCopyWithImpl<$Res, PaymentVoucher>;
  @useResult
  $Res call(
      {String id,
      String voucherNumber,
      String vendorId,
      String vendorName,
      Decimal amount,
      DateTime paymentDate,
      PaymentMethod paymentMethod,
      String accountId,
      String createdBy,
      DateTime createdAt,
      String? reference,
      String? notes,
      String? bankAccountNumber,
      String? checkNumber,
      DateTime? checkDueDate,
      PaymentStatus status,
      String? journalEntryId,
      String? userId,
      String? warehouseId,
      SyncStatus syncStatus,
      DateTime? serverUpdatedAt,
      bool isDeleted});
}

/// @nodoc
class _$PaymentVoucherCopyWithImpl<$Res, $Val extends PaymentVoucher>
    implements $PaymentVoucherCopyWith<$Res> {
  _$PaymentVoucherCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? voucherNumber = null,
    Object? vendorId = null,
    Object? vendorName = null,
    Object? amount = null,
    Object? paymentDate = null,
    Object? paymentMethod = null,
    Object? accountId = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? reference = freezed,
    Object? notes = freezed,
    Object? bankAccountNumber = freezed,
    Object? checkNumber = freezed,
    Object? checkDueDate = freezed,
    Object? status = null,
    Object? journalEntryId = freezed,
    Object? userId = freezed,
    Object? warehouseId = freezed,
    Object? syncStatus = null,
    Object? serverUpdatedAt = freezed,
    Object? isDeleted = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      voucherNumber: null == voucherNumber
          ? _value.voucherNumber
          : voucherNumber // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      vendorName: null == vendorName
          ? _value.vendorName
          : vendorName // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      paymentDate: null == paymentDate
          ? _value.paymentDate
          : paymentDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAccountNumber: freezed == bankAccountNumber
          ? _value.bankAccountNumber
          : bankAccountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      checkNumber: freezed == checkNumber
          ? _value.checkNumber
          : checkNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      checkDueDate: freezed == checkDueDate
          ? _value.checkDueDate
          : checkDueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      journalEntryId: freezed == journalEntryId
          ? _value.journalEntryId
          : journalEntryId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      warehouseId: freezed == warehouseId
          ? _value.warehouseId
          : warehouseId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$PaymentVoucherImplCopyWith<$Res>
    implements $PaymentVoucherCopyWith<$Res> {
  factory _$$PaymentVoucherImplCopyWith(_$PaymentVoucherImpl value,
          $Res Function(_$PaymentVoucherImpl) then) =
      __$$PaymentVoucherImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String voucherNumber,
      String vendorId,
      String vendorName,
      Decimal amount,
      DateTime paymentDate,
      PaymentMethod paymentMethod,
      String accountId,
      String createdBy,
      DateTime createdAt,
      String? reference,
      String? notes,
      String? bankAccountNumber,
      String? checkNumber,
      DateTime? checkDueDate,
      PaymentStatus status,
      String? journalEntryId,
      String? userId,
      String? warehouseId,
      SyncStatus syncStatus,
      DateTime? serverUpdatedAt,
      bool isDeleted});
}

/// @nodoc
class __$$PaymentVoucherImplCopyWithImpl<$Res>
    extends _$PaymentVoucherCopyWithImpl<$Res, _$PaymentVoucherImpl>
    implements _$$PaymentVoucherImplCopyWith<$Res> {
  __$$PaymentVoucherImplCopyWithImpl(
      _$PaymentVoucherImpl _value, $Res Function(_$PaymentVoucherImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? voucherNumber = null,
    Object? vendorId = null,
    Object? vendorName = null,
    Object? amount = null,
    Object? paymentDate = null,
    Object? paymentMethod = null,
    Object? accountId = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? reference = freezed,
    Object? notes = freezed,
    Object? bankAccountNumber = freezed,
    Object? checkNumber = freezed,
    Object? checkDueDate = freezed,
    Object? status = null,
    Object? journalEntryId = freezed,
    Object? userId = freezed,
    Object? warehouseId = freezed,
    Object? syncStatus = null,
    Object? serverUpdatedAt = freezed,
    Object? isDeleted = null,
  }) {
    return _then(_$PaymentVoucherImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      voucherNumber: null == voucherNumber
          ? _value.voucherNumber
          : voucherNumber // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      vendorName: null == vendorName
          ? _value.vendorName
          : vendorName // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      paymentDate: null == paymentDate
          ? _value.paymentDate
          : paymentDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAccountNumber: freezed == bankAccountNumber
          ? _value.bankAccountNumber
          : bankAccountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      checkNumber: freezed == checkNumber
          ? _value.checkNumber
          : checkNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      checkDueDate: freezed == checkDueDate
          ? _value.checkDueDate
          : checkDueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      journalEntryId: freezed == journalEntryId
          ? _value.journalEntryId
          : journalEntryId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      warehouseId: freezed == warehouseId
          ? _value.warehouseId
          : warehouseId // ignore: cast_nullable_to_non_nullable
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
class _$PaymentVoucherImpl extends _PaymentVoucher {
  const _$PaymentVoucherImpl(
      {required this.id,
      required this.voucherNumber,
      required this.vendorId,
      required this.vendorName,
      required this.amount,
      required this.paymentDate,
      required this.paymentMethod,
      required this.accountId,
      required this.createdBy,
      required this.createdAt,
      this.reference,
      this.notes,
      this.bankAccountNumber,
      this.checkNumber,
      this.checkDueDate,
      this.status = PaymentStatus.cleared,
      this.journalEntryId,
      this.userId,
      this.warehouseId,
      this.syncStatus = SyncStatus.synced,
      this.serverUpdatedAt,
      this.isDeleted = false})
      : super._();

  factory _$PaymentVoucherImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentVoucherImplFromJson(json);

  /// Unique internal UUID for the voucher.
  @override
  final String id;

  /// Human-readable unique serial number (e.g., "VCHR-2024-001").
  @override
  final String voucherNumber;

  /// Reference to the vendor receiving the payment.
  @override
  final String vendorId;

  /// Denormalized vendor name for display and audit purposes.
  @override
  final String vendorName;

  /// Payment amount in base currency (SAR).
  @override
  final Decimal amount;

  /// Date and time of payment.
  @override
  final DateTime paymentDate;

  /// Method of payment (cash, bank transfer, check, etc.).
  @override
  final PaymentMethod paymentMethod;

  /// Cash or Bank account ID from which payment is made.
  @override
  final String accountId;

  /// User ID of the person recording the voucher.
  @override
  final String createdBy;

  /// System-generated creation timestamp in UTC.
  @override
  final DateTime createdAt;

  /// External reference number (bank reference, check number, etc.).
  @override
  final String? reference;

  /// Optional notes or description.
  @override
  final String? notes;

  /// Bank account number for bank transfers.
  @override
  final String? bankAccountNumber;

  /// Check number for check payments.
  @override
  final String? checkNumber;

  /// Due date for check payment (if applicable).
  @override
  final DateTime? checkDueDate;

  /// Current status of the payment.
  @override
  @JsonKey()
  final PaymentStatus status;

  /// ID of the journal entry created for this voucher.
  @override
  final String? journalEntryId;

  /// User ID for multi-tenant data isolation.
  @override
  final String? userId;

  /// Warehouse scope identifier for multi-branch operations.
  @override
  final String? warehouseId;

  /// Local-to-remote synchronization state.
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
    return 'PaymentVoucher(id: $id, voucherNumber: $voucherNumber, vendorId: $vendorId, vendorName: $vendorName, amount: $amount, paymentDate: $paymentDate, paymentMethod: $paymentMethod, accountId: $accountId, createdBy: $createdBy, createdAt: $createdAt, reference: $reference, notes: $notes, bankAccountNumber: $bankAccountNumber, checkNumber: $checkNumber, checkDueDate: $checkDueDate, status: $status, journalEntryId: $journalEntryId, userId: $userId, warehouseId: $warehouseId, syncStatus: $syncStatus, serverUpdatedAt: $serverUpdatedAt, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentVoucherImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.voucherNumber, voucherNumber) ||
                other.voucherNumber == voucherNumber) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.vendorName, vendorName) ||
                other.vendorName == vendorName) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paymentDate, paymentDate) ||
                other.paymentDate == paymentDate) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.bankAccountNumber, bankAccountNumber) ||
                other.bankAccountNumber == bankAccountNumber) &&
            (identical(other.checkNumber, checkNumber) ||
                other.checkNumber == checkNumber) &&
            (identical(other.checkDueDate, checkDueDate) ||
                other.checkDueDate == checkDueDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.journalEntryId, journalEntryId) ||
                other.journalEntryId == journalEntryId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.warehouseId, warehouseId) ||
                other.warehouseId == warehouseId) &&
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
        voucherNumber,
        vendorId,
        vendorName,
        amount,
        paymentDate,
        paymentMethod,
        accountId,
        createdBy,
        createdAt,
        reference,
        notes,
        bankAccountNumber,
        checkNumber,
        checkDueDate,
        status,
        journalEntryId,
        userId,
        warehouseId,
        syncStatus,
        serverUpdatedAt,
        isDeleted
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentVoucherImplCopyWith<_$PaymentVoucherImpl> get copyWith =>
      __$$PaymentVoucherImplCopyWithImpl<_$PaymentVoucherImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentVoucherImplToJson(
      this,
    );
  }
}

abstract class _PaymentVoucher extends PaymentVoucher {
  const factory _PaymentVoucher(
      {required final String id,
      required final String voucherNumber,
      required final String vendorId,
      required final String vendorName,
      required final Decimal amount,
      required final DateTime paymentDate,
      required final PaymentMethod paymentMethod,
      required final String accountId,
      required final String createdBy,
      required final DateTime createdAt,
      final String? reference,
      final String? notes,
      final String? bankAccountNumber,
      final String? checkNumber,
      final DateTime? checkDueDate,
      final PaymentStatus status,
      final String? journalEntryId,
      final String? userId,
      final String? warehouseId,
      final SyncStatus syncStatus,
      final DateTime? serverUpdatedAt,
      final bool isDeleted}) = _$PaymentVoucherImpl;
  const _PaymentVoucher._() : super._();

  factory _PaymentVoucher.fromJson(Map<String, dynamic> json) =
      _$PaymentVoucherImpl.fromJson;

  @override

  /// Unique internal UUID for the voucher.
  String get id;
  @override

  /// Human-readable unique serial number (e.g., "VCHR-2024-001").
  String get voucherNumber;
  @override

  /// Reference to the vendor receiving the payment.
  String get vendorId;
  @override

  /// Denormalized vendor name for display and audit purposes.
  String get vendorName;
  @override

  /// Payment amount in base currency (SAR).
  Decimal get amount;
  @override

  /// Date and time of payment.
  DateTime get paymentDate;
  @override

  /// Method of payment (cash, bank transfer, check, etc.).
  PaymentMethod get paymentMethod;
  @override

  /// Cash or Bank account ID from which payment is made.
  String get accountId;
  @override

  /// User ID of the person recording the voucher.
  String get createdBy;
  @override

  /// System-generated creation timestamp in UTC.
  DateTime get createdAt;
  @override

  /// External reference number (bank reference, check number, etc.).
  String? get reference;
  @override

  /// Optional notes or description.
  String? get notes;
  @override

  /// Bank account number for bank transfers.
  String? get bankAccountNumber;
  @override

  /// Check number for check payments.
  String? get checkNumber;
  @override

  /// Due date for check payment (if applicable).
  DateTime? get checkDueDate;
  @override

  /// Current status of the payment.
  PaymentStatus get status;
  @override

  /// ID of the journal entry created for this voucher.
  String? get journalEntryId;
  @override

  /// User ID for multi-tenant data isolation.
  String? get userId;
  @override

  /// Warehouse scope identifier for multi-branch operations.
  String? get warehouseId;
  @override

  /// Local-to-remote synchronization state.
  SyncStatus get syncStatus;
  @override

  /// Most recent synchronization timestamp from the server.
  DateTime? get serverUpdatedAt;
  @override

  /// Soft-deletion flag for audit trail preservation.
  bool get isDeleted;
  @override
  @JsonKey(ignore: true)
  _$$PaymentVoucherImplCopyWith<_$PaymentVoucherImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
