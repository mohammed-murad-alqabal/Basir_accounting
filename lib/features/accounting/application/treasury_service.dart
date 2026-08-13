import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/application/financial_year_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_voucher.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'treasury_service.g.dart';

/// Treasury Service managing cash, banking, and financial voucher operations.
///
/// Responsible for issuing receipt and payment vouchers, and ensuring they
/// are correctly reflected in the general ledger via automatic journal posting.
///
/// ## Features
/// - **Voucher Management**: Lifecycle management for Receipt and Payment
///   vouchers.
/// - **Ledger Integration**: Automatic double-entry posting to Treasury
///   accounts.
/// - **Account Validation**: Enforces Cash/Bank account constraints for treasury transactions.
/// - **Financial Year Checks**: Prevents posting to closed or locked periods.
@riverpod
class TreasuryService extends _$TreasuryService {
  @override
  FutureOr<void> build() {}

  /// Retrieves the complete list of financial vouchers.
  Future<List<FinancialVoucher>> getAllVouchers() async {
    final voucherRepo = ref.read(financialVoucherRepositoryProvider);
    return voucherRepo.getAllVouchers();
  }

  /// Issues and posts a Receipt Voucher to the ledger.
  ///
  /// ## Impact
  /// - **Debit**: Treasury Account (Cash/Bank)
  /// - **Credit**: Target Account (Person/Entity)
  ///
  /// ## Parameters
  /// - [voucher]: The [FinancialVoucher] to process.
  ///
  /// ## Returns
  /// The ID of the generated [JournalEntry].
  ///
  /// ## Throws
  /// - [Exception] if the voucher is not a receipt or period is closed.
  Future<String> issueReceipt(FinancialVoucher voucher) async {
    final financialYearService =
        ref.read(financialYearServiceProvider.notifier);
    final voucherRepo = ref.read(financialVoucherRepositoryProvider);
    if (voucher.type != VoucherType.receipt) {
      throw Exception('Voucher must be a receipt');
    }

    final isPeriodOpen = await financialYearService.canPostToDate(voucher.date);
    if (!isPeriodOpen) throw Exception('Financial period is closed');

    await _validateTreasuryAccount(voucher.treasuryAccountId);

    final isForeignCurrency =
        voucher.originalCurrency?.trim().isNotEmpty ?? false;
    final lines = [
      JournalEntryLine(
        accountId: voucher.treasuryAccountId,
        accountName: 'Treasury/Bank',
        debit: voucher.amount,
        credit: Decimal.zero,
        description: 'Receipt: ${voucher.description}',
        originalCurrency: isForeignCurrency ? voucher.originalCurrency : null,
        exchangeRate: isForeignCurrency ? voucher.exchangeRate : null,
        originalAmount: isForeignCurrency ? voucher.originalAmount : null,
      ),
      JournalEntryLine(
        accountId: voucher.accountId,
        accountName: voucher.personName ?? 'Credit Account',
        credit: voucher.amount,
        debit: Decimal.zero,
        description: 'Receipt Voucher #${voucher.referenceNumber}',
        originalCurrency: isForeignCurrency ? voucher.originalCurrency : null,
        exchangeRate: isForeignCurrency ? voucher.exchangeRate : null,
        originalAmount: isForeignCurrency ? voucher.originalAmount : null,
      ),
    ];

    final now = DateTime.now();
    final user = ref.read(basirUserProvider);

    final entry = JournalEntry(
      id: 'je-vouch-${voucher.id}',
      referenceNumber: 'JE-RE-${voucher.referenceNumber}',
      date: voucher.date,
      temporal: TemporalJustification(
        transactionDate: voucher.date,
        effectiveDate: voucher.date,
        recordingDate: now,
      ),
      standards: const StandardsJustification(
        standardReference: 'IFRS 9',
        recognitionBasis: 'Fair Value',
        measurementBasis: 'Amortized Cost',
      ),
      description: voucher.description,
      status: JournalEntryStatus.posted,
      lines: lines,
      sourceDocument: 'receipt_voucher',
      sourceId: voucher.id,
      createdAt: now,
      createdBy: user?.id ?? 'system',
      updatedAt: now,
      postedAt: now,
    );

    final accountingService = ref.read(accountingServiceProvider.notifier);
    await accountingService.postJournalEntry(entry);

    final postedVoucher =
        voucher.copyWith(isPosted: true, journalEntryId: entry.id);
    await voucherRepo.addVoucher(postedVoucher);
    return entry.id;
  }

  /// Issues and posts a Payment Voucher to the ledger.
  ///
  /// ## Impact
  /// - **Debit**: Target Account (Person/Entity)
  /// - **Credit**: Treasury Account (Cash/Bank)
  ///
  /// ## Parameters
  /// - [voucher]: The [FinancialVoucher] to process.
  ///
  /// ## Throws
  /// - [Exception] if the voucher is not a payment or period is closed.
  Future<String> issuePayment(FinancialVoucher voucher) async {
    final financialYearService =
        ref.read(financialYearServiceProvider.notifier);
    final voucherRepo = ref.read(financialVoucherRepositoryProvider);
    if (voucher.type != VoucherType.payment) {
      throw Exception('Voucher must be a payment');
    }

    final isPeriodOpen = await financialYearService.canPostToDate(voucher.date);
    if (!isPeriodOpen) throw Exception('Financial period is closed');

    await _validateTreasuryAccount(voucher.treasuryAccountId);

    final isForeignCurrency =
        voucher.originalCurrency?.trim().isNotEmpty ?? false;
    final lines = [
      JournalEntryLine(
        accountId: voucher.accountId,
        accountName: voucher.personName ?? 'Debit Account',
        debit: voucher.amount,
        credit: Decimal.zero,
        description: 'Payment: ${voucher.description}',
        originalCurrency: isForeignCurrency ? voucher.originalCurrency : null,
        exchangeRate: isForeignCurrency ? voucher.exchangeRate : null,
        originalAmount: isForeignCurrency ? voucher.originalAmount : null,
      ),
      JournalEntryLine(
        accountId: voucher.treasuryAccountId,
        accountName: 'Treasury/Bank',
        credit: voucher.amount,
        debit: Decimal.zero,
        description: 'Payment Voucher #${voucher.referenceNumber}',
        originalCurrency: isForeignCurrency ? voucher.originalCurrency : null,
        exchangeRate: isForeignCurrency ? voucher.exchangeRate : null,
        originalAmount: isForeignCurrency ? voucher.originalAmount : null,
      ),
    ];

    final now = DateTime.now();
    final user = ref.read(basirUserProvider);

    final entry = JournalEntry(
      id: 'je-vouch-${voucher.id}',
      referenceNumber: 'JE-PY-${voucher.referenceNumber}',
      date: voucher.date,
      temporal: TemporalJustification(
        transactionDate: voucher.date,
        effectiveDate: voucher.date,
        recordingDate: now,
      ),
      standards: const StandardsJustification(
        standardReference: 'IFRS 9',
        recognitionBasis: 'Fair Value',
        measurementBasis: 'Amortized Cost',
      ),
      description: voucher.description,
      status: JournalEntryStatus.posted,
      lines: lines,
      sourceDocument: 'payment_voucher',
      sourceId: voucher.id,
      createdAt: now,
      createdBy: user?.id ?? 'system',
      updatedAt: now,
      postedAt: now,
    );

    final accountingService = ref.read(accountingServiceProvider.notifier);
    await accountingService.postJournalEntry(entry);

    final postedVoucher =
        voucher.copyWith(isPosted: true, journalEntryId: entry.id);
    await voucherRepo.addVoucher(postedVoucher);
    return entry.id;
  }

  /// Validates that the account is a valid treasury account (Cash or Bank).
  ///
  /// Enforces identification by subtype or specific account code prefixes (1101/1102).
  Future<void> _validateTreasuryAccount(String accountId) async {
    final accountingService = ref.read(accountingServiceProvider.notifier);
    final account = await accountingService.getAccountById(accountId);

    if (account == null) {
      throw Exception('Treasury account not found');
    }

    final isCashOrBank = account.subType == 'cash' ||
        account.subType == 'bank' ||
        account.code.startsWith('1101') ||
        account.code.startsWith('1102');

    if (!isCashOrBank) {
      throw Exception(
        'Account must be a Cash or Bank account for treasury operations',
      );
    }
  }
}

/// Provider for retrieving all financial vouchers.
/// (Implementation of FR-ACC-016)
@riverpod
Future<List<FinancialVoucher>> getVouchers(Ref ref) async =>
    ref.watch(treasuryServiceProvider.notifier).getAllVouchers();
