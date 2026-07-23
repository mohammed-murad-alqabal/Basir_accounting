import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/payment_receipt.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/payment_voucher.dart';
import 'package:decimal/decimal.dart';
import 'package:isar/isar.dart';

part 'payment_voucher_model.g.dart';

/// Isar data model for Payment Voucher storage.
///
/// This model provides persistent storage for payment vouchers using
/// the Isar database. It maps between the domain entity and the
/// storage format.
///
/// ## Standards Compliance:
/// - **IAS 1**: Presentation of Financial Statements
/// - **IFRS 9**: Financial Instruments
/// - **ZATCA Phase 2**: Payment documentation
@collection
class PaymentVoucherModel {
  /// Default constructor for Isar.
  PaymentVoucherModel();

  /// Creates a model from a domain entity.
  factory PaymentVoucherModel.fromEntity(PaymentVoucher entity) =>
      PaymentVoucherModel()
        ..paymentVoucherId = entity.id
        ..voucherNumber = entity.voucherNumber
        ..vendorId = entity.vendorId
        ..vendorName = entity.vendorName
        ..amount = entity.amount.toDouble()
        ..paymentDate = entity.paymentDate
        ..paymentMethod = entity.paymentMethod.index
        ..accountId = entity.accountId
        ..reference = entity.reference
        ..notes = entity.notes
        ..bankAccountNumber = entity.bankAccountNumber
        ..checkNumber = entity.checkNumber
        ..checkDueDate = entity.checkDueDate
        ..status = entity.status.index
        ..journalEntryId = entity.journalEntryId
        ..createdBy = entity.createdBy
        ..createdAt = entity.createdAt
        ..userId = entity.userId
        ..warehouseId = entity.warehouseId
        ..syncStatus = entity.syncStatus.index
        ..serverUpdatedAt = entity.serverUpdatedAt
        ..isDeleted = entity.isDeleted;

  /// Isar internal ID (auto-increment).
  Id id = Isar.autoIncrement;

  /// Unique identifier (UUID).
  @Index(unique: true, replace: true)
  late String paymentVoucherId;

  /// Human-readable voucher number.
  @Index(unique: true)
  late String voucherNumber;

  /// Vendor ID reference.
  @Index()
  late String vendorId;

  /// Vendor name (denormalized).
  late String vendorName;

  /// Payment amount in SAR.
  late double amount;

  /// Date and time of payment.
  @Index()
  late DateTime paymentDate;

  /// Payment method (stored as int index).
  late int paymentMethod;

  /// Cash/Bank account ID.
  @Index()
  late String accountId;

  /// External reference number.
  String? reference;

  /// Optional notes.
  String? notes;

  /// Bank account number.
  String? bankAccountNumber;

  /// Check number (for check payments).
  String? checkNumber;

  /// Check due date.
  DateTime? checkDueDate;

  /// Payment status (stored as int index).
  @Index()
  late int status;

  /// Related journal entry ID.
  String? journalEntryId;

  /// User who created this voucher.
  late String createdBy;

  /// Creation timestamp.
  late DateTime createdAt;

  /// User ID for multi-tenant isolation.
  @Index()
  String? userId;

  /// Warehouse scope identifier.
  @Index()
  String? warehouseId;

  /// Synchronization status (stored as int index).
  late int syncStatus;

  /// Last server update timestamp.
  DateTime? serverUpdatedAt;

  /// Soft deletion flag.
  late bool isDeleted;

  /// Converts the model to a domain entity.
  PaymentVoucher toEntity() => PaymentVoucher(
        id: paymentVoucherId,
        voucherNumber: voucherNumber,
        vendorId: vendorId,
        vendorName: vendorName,
        amount: Decimal.parse(amount.toString()),
        paymentDate: paymentDate,
        paymentMethod: PaymentMethod.values[paymentMethod],
        accountId: accountId,
        reference: reference,
        notes: notes,
        bankAccountNumber: bankAccountNumber,
        checkNumber: checkNumber,
        checkDueDate: checkDueDate,
        status: PaymentStatus.values[status],
        journalEntryId: journalEntryId,
        createdBy: createdBy,
        createdAt: createdAt,
        userId: userId,
        warehouseId: warehouseId,
        syncStatus: SyncStatus.values[syncStatus],
        serverUpdatedAt: serverUpdatedAt,
        isDeleted: isDeleted,
      );
}
