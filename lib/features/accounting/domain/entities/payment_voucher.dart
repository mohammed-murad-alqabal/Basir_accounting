// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/payment_receipt.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_voucher.freezed.dart';
part 'payment_voucher.g.dart';

/// Payment Voucher Entity - Records payments to vendors/suppliers.
///
/// Represents a formal document recording payment made to a vendor or
/// supplier against outstanding payables. This entity integrates with the
/// double-entry accounting system to automatically generate journal entries.
///
/// ## Accounting Impact:
/// - **Debit**: Accounts Payable (Liability Decrease)
/// - **Credit**: Cash/Bank Account (Asset Decrease)
///
/// ## Standards Compliance:
/// - **IAS 1**: Presentation of Financial Statements
/// - **IFRS 9**: Financial Instruments - recognition and measurement
/// - **ZATCA Phase 2**: E-invoicing compliance for payment documentation
///
/// ## Usage Example:
/// ```dart
/// final voucher = PaymentVoucher(
///   id: 'vchr-001',
///   voucherNumber: 'VCHR-2024-001',
///   vendorId: 'vend-123',
///   vendorName: 'ABC Suppliers',
///   amount: Decimal.fromInt(3000),
///   paymentDate: DateTime.now(),
///   paymentMethod: PaymentMethod.bankTransfer,
///   accountId: 'acc-1101',
///   createdBy: 'user-001',
///   createdAt: DateTime.now(),
/// );
/// ```
@freezed
class PaymentVoucher with _$PaymentVoucher {
  /// Creates a payment voucher record.
  const factory PaymentVoucher({
    /// Unique internal UUID for the voucher.
    required String id,

    /// Human-readable unique serial number (e.g., "VCHR-2024-001").
    required String voucherNumber,

    /// Reference to the vendor receiving the payment.
    required String vendorId,

    /// Denormalized vendor name for display and audit purposes.
    required String vendorName,

    /// Payment amount in base currency (SAR).
    required Decimal amount,

    /// Date and time of payment.
    required DateTime paymentDate,

    /// Method of payment (cash, bank transfer, check, etc.).
    required PaymentMethod paymentMethod,

    /// Cash or Bank account ID from which payment is made.
    required String accountId,

    /// User ID of the person recording the voucher.
    required String createdBy,

    /// System-generated creation timestamp in UTC.
    required DateTime createdAt,

    /// External reference number (bank reference, check number, etc.).
    String? reference,

    /// Optional notes or description.
    String? notes,

    /// Bank account number for bank transfers.
    String? bankAccountNumber,

    /// Check number for check payments.
    String? checkNumber,

    /// Due date for check payment (if applicable).
    DateTime? checkDueDate,

    /// Current status of the payment.
    @Default(PaymentStatus.cleared) PaymentStatus status,

    /// ID of the journal entry created for this voucher.
    String? journalEntryId,

    /// User ID for multi-tenant data isolation.
    String? userId,

    /// Warehouse scope identifier for multi-branch operations.
    String? warehouseId,

    /// Local-to-remote synchronization state.
    @Default(SyncStatus.synced) SyncStatus syncStatus,

    /// Most recent synchronization timestamp from the server.
    DateTime? serverUpdatedAt,

    /// Soft-deletion flag for audit trail preservation.
    @Default(false) bool isDeleted,
  }) = _PaymentVoucher;

  /// Deserialization from JSON format.
  factory PaymentVoucher.fromJson(Map<String, dynamic> json) =>
      _$PaymentVoucherFromJson(json);

  const PaymentVoucher._();

  /// Returns true if payment is cleared and completed.
  bool get isCleared => status == PaymentStatus.cleared;

  /// Returns true if payment is pending clearance.
  bool get isPending => status == PaymentStatus.pending;

  /// Returns true if payment failed or was cancelled.
  bool get isFailed =>
      status == PaymentStatus.bounced || status == PaymentStatus.cancelled;

  /// Returns true if payment was made by check.
  bool get isCheckPayment => paymentMethod == PaymentMethod.check;

  /// Returns true if payment was made from a bank account.
  bool get isBankPayment =>
      paymentMethod == PaymentMethod.bankTransfer ||
      paymentMethod == PaymentMethod.online;
}
