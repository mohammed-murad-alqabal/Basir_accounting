// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_receipt.freezed.dart';
part 'payment_receipt.g.dart';

/// Payment method for customer collections.
///
/// Defines the various channels through which customers can settle their
/// outstanding balances.
enum PaymentMethod {
  /// Cash payment received directly.
  cash,

  /// Bank transfer to company account.
  bankTransfer,

  /// Check payment (may have clearing period).
  check,

  /// Credit card payment via POS or online.
  creditCard,

  /// Online payment gateway (Apple Pay, STC Pay, etc.).
  online,
}

/// Lifecycle status of a payment receipt.
///
/// Tracks the payment from creation through clearing to potential reversal.
enum PaymentStatus {
  /// Payment received but not yet cleared (e.g., check pending).
  pending,

  /// Payment confirmed and available.
  cleared,

  /// Payment failed or check bounced.
  bounced,

  /// Payment reversed due to error or dispute.
  cancelled,
}

/// Payment Receipt Entity - Records customer payment collections.
///
/// Represents a formal document acknowledging receipt of payment from a
/// customer against their outstanding balance. This entity integrates with
/// the double-entry accounting system to automatically generate journal entries.
///
/// ## Accounting Impact:
/// - **Debit**: Cash/Bank Account (Asset Increase)
/// - **Credit**: Accounts Receivable (Asset Decrease)
///
/// ## Standards Compliance:
/// - **IAS 1**: Presentation of Financial Statements
/// - **IFRS 9**: Financial Instruments - recognition and measurement
/// - **ZATCA Phase 2**: E-invoicing compliance for payment documentation
///
/// ## Usage Example:
/// ```dart
/// final receipt = PaymentReceipt(
///   id: 'rcpt-001',
///   receiptNumber: 'RCPT-2024-001',
///   customerId: 'cust-123',
///   customerName: 'Ahmed Trading Co.',
///   amount: Decimal.fromInt(5000),
///   receiptDate: DateTime.now(),
///   paymentMethod: PaymentMethod.bankTransfer,
///   accountId: 'acc-1101',
///   createdBy: 'user-001',
///   createdAt: DateTime.now(),
/// );
/// ```
@freezed
class PaymentReceipt with _$PaymentReceipt {
  /// Creates a payment receipt record.
  const factory PaymentReceipt({
    /// Unique internal UUID for the receipt.
    required String id,

    /// Human-readable unique serial number (e.g., "RCPT-2024-001").
    required String receiptNumber,

    /// Reference to the customer making the payment.
    required String customerId,

    /// Denormalized customer name for display and audit purposes.
    required String customerName,

    /// Payment amount in base currency (SAR).
    required Decimal amount,

    /// Date and time of payment receipt.
    required DateTime receiptDate,

    /// Method of payment (cash, bank transfer, check, etc.).
    required PaymentMethod paymentMethod,

    /// Cash or Bank account ID receiving the payment.
    required String accountId,

    /// User ID of the person recording the receipt.
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

    /// Due date for check clearing (if applicable).
    DateTime? checkDueDate,

    /// Current status of the payment.
    @Default(PaymentStatus.cleared) PaymentStatus status,

    /// ID of the journal entry created for this receipt.
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
  }) = _PaymentReceipt;

  /// Deserialization from JSON format.
  factory PaymentReceipt.fromJson(Map<String, dynamic> json) =>
      _$PaymentReceiptFromJson(json);

  const PaymentReceipt._();

  /// Returns true if payment is cleared and available.
  bool get isCleared => status == PaymentStatus.cleared;

  /// Returns true if payment is pending clearance.
  bool get isPending => status == PaymentStatus.pending;

  /// Returns true if payment failed or was cancelled.
  bool get isFailed =>
      status == PaymentStatus.bounced || status == PaymentStatus.cancelled;

  /// Returns true if payment was made by check.
  bool get isCheckPayment => paymentMethod == PaymentMethod.check;

  /// Returns true if payment was made to a bank account.
  bool get isBankPayment =>
      paymentMethod == PaymentMethod.bankTransfer ||
      paymentMethod == PaymentMethod.online;
}
