// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_ledger_entry.freezed.dart';
part 'customer_ledger_entry.g.dart';

/// Customer Ledger Entry Entity - Individual transaction in customer account.
///
/// Represents a single line item in the customer's account ledger, tracking
/// all debit and credit movements. This provides a complete audit trail of
/// all financial transactions affecting a customer's balance.
///
/// ## Accounting Equation Impact:
/// - **Debit Entry**: Increases customer receivable (customer owes more)
/// - **Credit Entry**: Decreases customer receivable (customer paid or returned)
///
/// ## Standards Compliance:
/// - **IAS 1**: Presentation of Financial Statements
/// - **IFRS 15**: Revenue from Contracts with Customers
///
/// ## Source Documents:
/// The entry can originate from various source documents:
/// - Sales Invoice (Debit)
/// - Payment Receipt (Credit)
/// - Sales Return/Credit Note (Credit)
/// - Opening Balance (Debit/Credit)
/// - Contra Settlement (Debit/Credit)
///
/// ## Usage Example:
/// ```dart
/// final entry = CustomerLedgerEntry(
///   id: 'entry-001',
///   customerId: 'cust-123',
///   entryNumber: 'JE-2024-001',
///   entryDate: DateTime.now(),
///   description: 'Sales Invoice INV-2024-001',
///   debit: Decimal.fromInt(5000),
///   credit: Decimal.zero,
///   balance: Decimal.fromInt(5000),
///   sourceDocument: 'sales_invoice',
///   sourceId: 'inv-001',
///   createdAt: DateTime.now(),
/// );
/// ```
@freezed
class CustomerLedgerEntry with _$CustomerLedgerEntry {
  /// Creates a customer ledger entry record.
  const factory CustomerLedgerEntry({
    /// Unique internal UUID for the entry.
    required String id,

    /// Reference to the customer account.
    required String customerId,

    /// Journal entry or document reference number.
    required String entryNumber,

    /// Date of the transaction.
    required DateTime entryDate,

    /// Description of the transaction.
    required String description,

    /// Debit amount (increases customer receivable).
    required Decimal debit,

    /// Credit amount (decreases customer receivable).
    required Decimal credit,

    /// Running balance after this entry.
    required Decimal balance,

    /// Source document type (sales_invoice, payment_receipt, etc.).
    required String sourceDocument,

    /// Unique identifier of the source document.
    required String sourceId,

    /// System-generated creation timestamp.
    required DateTime createdAt,

    /// External reference number if applicable.
    String? reference,

    /// User ID who created this entry.
    String? createdBy,

    /// User ID for multi-tenant data isolation.
    String? userId,

    /// Local-to-remote synchronization state.
    @Default(SyncStatus.synced) SyncStatus syncStatus,
  }) = _CustomerLedgerEntry;

  /// Deserialization from JSON format.
  factory CustomerLedgerEntry.fromJson(Map<String, dynamic> json) =>
      _$CustomerLedgerEntryFromJson(json);

  const CustomerLedgerEntry._();

  /// Returns true if this is a debit entry (customer owes more).
  bool get isDebit => debit > Decimal.zero;

  /// Returns true if this is a credit entry (customer paid or returned).
  bool get isCredit => credit > Decimal.zero;

  /// Returns the net amount of this entry.
  Decimal get netAmount => debit - credit;

  /// Returns true if this entry is from a sales invoice.
  bool get isInvoice => sourceDocument == 'sales_invoice';

  /// Returns true if this entry is from a payment receipt.
  bool get isPayment => sourceDocument == 'payment_receipt';
}
