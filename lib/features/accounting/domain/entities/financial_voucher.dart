import 'package:basir_app/core/models/sync_status.dart';
import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'financial_voucher.freezed.dart';
part 'financial_voucher.g.dart';

/// Fundamental financial voucher types for cash flow direction.
enum VoucherType {
  /// Incoming funds from a payer.
  receipt,

  /// Outgoing funds to a beneficiary.
  payment,
}

/// Supported payment instruments for financial settlements.
enum PaymentMethod {
  /// Physical currency settlement.
  cash,

  /// Wire transfer or digital bank settlement.
  bank,

  /// Negotiable instrument / Cheque.
  check,
}

/// Primary financial document representing a cash or bank transaction.
///
/// Serves as the pre-posting source for cash-driven [JournalEntry] records.
@freezed
class FinancialVoucher with _$FinancialVoucher {
  /// Creates a financial voucher entity.
  const factory FinancialVoucher({
    /// Unique internal identifier.
    required String id,

    /// External reference number (e.g., "PV-2024-001").
    required String referenceNumber,

    /// Date the payment or receipt was executed.
    required DateTime date,

    /// Direction of fund flow (Receipt/Payment).
    required VoucherType type,

    /// Settlement instrument (Cash/Bank/Check).
    required PaymentMethod paymentMethod,

    /// Face value of the transaction as [Decimal].
    required Decimal amount,

    /// The offset account ID (e.g., Customer AR or Vendor AP).
    required String accountId,

    /// The liquid asset account ID (e.g., Cash Office or Bank Account).
    required String treasuryAccountId,

    /// Detailed description or memo of the transaction purpose.
    required String description,

    /// Initial system recording timestamp.
    required DateTime createdAt,

    /// Name of the paying person or receiving entity (Manual/Denormalized).
    String? personName,

    /// Migration status: if true, the voucher has been posted to the General
    /// Ledger.
    @Default(false) bool isPosted,

    /// Link to the resulting [JournalEntry] ID after posting.
    String? journalEntryId,

    /// Tenant/Owner identifier.
    String? userId,

    /// Original transaction currency (ISO code).
    String? originalCurrency,

    /// Conversion rate used for local currency recording.
    Decimal? exchangeRate,

    /// Face value in [originalCurrency].
    Decimal? originalAmount,

    /// Local-to-Remote synchronization state.
    @Default(SyncStatus.synced) SyncStatus syncStatus,

    /// Most recent synchronization timestamp from the server.
    DateTime? serverUpdatedAt,

    /// Soft-deletion flag.
    @Default(false) bool isDeleted,
  }) = _FinancialVoucher;

  /// deserialization from JSON format.
  factory FinancialVoucher.fromJson(Map<String, dynamic> json) => _$FinancialVoucherFromJson(json);
}
