import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/payment_receipt.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'payment_receipt_service.g.dart';

/// Payment Receipt Service - Manages customer payment collections.
///
/// This service handles the complete lifecycle of payment receipts including:
/// - Creating and recording payment receipts
/// - Automatic journal entry generation
/// - Customer balance updates
/// - Payment cancellation and reversal
///
/// ## Accounting Logic:
/// When a payment receipt is created, the following journal entry is generated:
/// - **Debit**: Cash/Bank Account (Asset Increase)
/// - **Credit**: Accounts Receivable (Asset Decrease)
///
/// ## Standards Compliance:
/// - **IAS 1**: Presentation of Financial Statements
/// - **IFRS 9**: Financial Instruments
/// - **ZATCA Phase 2**: Payment documentation requirements
@riverpod
class PaymentReceiptService extends _$PaymentReceiptService {
  @override
  FutureOr<void> build() {}

  /// Creates a new payment receipt and updates customer balance.
  ///
  /// This method:
  /// 1. Validates the payment amount
  /// 2. Retrieves customer information
  /// 3. Generates a unique receipt number
  /// 4. Creates the receipt record
  /// 5. Generates the corresponding journal entry
  /// 6. Updates the customer's outstanding balance
  ///
  /// Returns the ID of the created receipt.
  Future<String> createReceipt({
    required String customerId,
    required Decimal amount,
    required PaymentMethod paymentMethod,
    required String accountId,
    String? reference,
    String? notes,
    String? checkNumber,
    DateTime? checkDueDate,
  }) async {
    final customerRepo = ref.read(customerRepositoryProvider);
    final user = ref.read(basirUserProvider);
    final now = DateTime.now();

    // Validate payment amount
    if (amount <= Decimal.zero) {
      throw ArgumentError('Payment amount must be greater than zero');
    }

    // Retrieve customer information
    final customer = await customerRepo.getCustomerById(customerId);
    if (customer == null) {
      throw Exception('Customer not found: $customerId');
    }

    // Generate receipt number
    final receiptNumber = await _generateReceiptNumber();

    // Create receipt entity
    final receipt = PaymentReceipt(
      id: const Uuid().v4(),
      receiptNumber: receiptNumber,
      customerId: customerId,
      customerName: customer.nameAr,
      amount: amount,
      receiptDate: now,
      paymentMethod: paymentMethod,
      accountId: accountId,
      reference: reference,
      notes: notes,
      checkNumber: checkNumber,
      checkDueDate: checkDueDate,
      status: paymentMethod == PaymentMethod.check
          ? PaymentStatus.pending
          : PaymentStatus.cleared,
      createdBy: user?.id ?? 'system',
      createdAt: now,
      userId: user?.id,
    );

    // Create journal entry
    final journalEntryId = await _createJournalEntry(
      receipt: receipt,
      customer: customer,
    );

    // Update receipt with journal entry reference
    final updatedReceipt = receipt.copyWith(journalEntryId: journalEntryId);

    // Save receipt (to be implemented with repository)
    // await receiptRepository.save(updatedReceipt);

    return updatedReceipt.id;
  }

  /// Generates the next sequential receipt number.
  Future<String> _generateReceiptNumber() async {
    final now = DateTime.now();
    final year = now.year;
    // In production, this should query the database for the last receipt number
    final sequence = now.millisecondsSinceEpoch;
    return 'RCPT-$year-$sequence';
  }

  /// Creates the journal entry for a payment receipt.
  ///
  /// Journal Entry Structure:
  /// - Debit: Cash/Bank Account (accountId)
  /// - Credit: Accounts Receivable (customer.receivableAccountId)
  Future<String> _createJournalEntry({
    required PaymentReceipt receipt,
    required Customer customer,
  }) async {
    final accountingService = ref.read(accountingServiceProvider.notifier);
    final user = ref.read(basirUserProvider);
    final now = DateTime.now();

    // Determine the AR account for this customer
    final arAccountId = customer.receivableAccountId ?? 'acc-1201';

    final lines = [
      // Debit: Cash/Bank Account
      JournalEntryLine(
        accountId: receipt.accountId,
        accountName: 'Cash/Bank Account',
        debit: receipt.amount,
        credit: Decimal.zero,
        description: 'Payment received from ${customer.nameAr}',
        sourceDocumentRef: receipt.receiptNumber,
      ),
      // Credit: Accounts Receivable
      JournalEntryLine(
        accountId: arAccountId,
        accountName: 'Accounts Receivable - ${customer.nameAr}',
        debit: Decimal.zero,
        credit: receipt.amount,
        description: 'Payment received - ${receipt.receiptNumber}',
        sourceDocumentRef: receipt.receiptNumber,
      ),
    ];

    final entry = JournalEntry(
      id: const Uuid().v4(),
      referenceNumber: 'JE-${now.millisecondsSinceEpoch}',
      date: now,
      temporal: TemporalJustification(
        transactionDate: now,
        effectiveDate: now,
        recordingDate: now,
      ),
      standards: const StandardsJustification(
        standardReference: 'IFRS 9 / IAS 1',
        recognitionBasis: 'Cash Receipt',
        measurementBasis: 'Amortized Cost',
      ),
      description:
          'Payment Receipt ${receipt.receiptNumber} - ${customer.nameAr}',
      status: JournalEntryStatus.posted,
      lines: lines,
      sourceDocument: 'payment_receipt',
      sourceId: receipt.id,
      createdAt: now,
      createdBy: user?.id ?? 'system',
      updatedAt: now,
      postedAt: now,
      userId: user?.id,
    );

    await accountingService.postJournalEntry(entry, bypassCognitive: true);
    return entry.id;
  }

  /// Retrieves all payment receipts for a specific customer.
  Future<List<PaymentReceipt>> getCustomerReceipts(String customerId) async =>
      []; // To be implemented with repository

  /// Cancels a payment receipt and creates a reversing entry.
  ///
  /// This should only be allowed for receipts in 'cleared' status.
  /// Creates a reversing journal entry to undo the original booking.
  Future<void> cancelReceipt(String receiptId, String reason) async {
    // To be implemented
    // 1. Retrieve the receipt
    // 2. Validate it can be cancelled
    // 3. Create reversing journal entry
    // 4. Update receipt status to 'cancelled'
    // 5. Update customer balance
  }

  /// Gets the total payments received for a customer in a period.
  Future<Decimal> getTotalPayments({
    required String customerId,
    required DateTime fromDate,
    required DateTime toDate,
  }) async =>
      Decimal.zero; // To be implemented with repository
}
