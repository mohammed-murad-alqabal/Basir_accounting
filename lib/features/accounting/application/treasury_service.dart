import 'package:basir_app/core/providers.dart';
import 'package:basir_app/features/accounting/application/accounting_service.dart';
import 'package:basir_app/features/accounting/application/financial_year_service.dart';
import 'package:basir_app/features/accounting/domain/entities/financial_voucher.dart';
import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'treasury_service.g.dart';

/// خدمة الخزينة (Treasury Service)
/// مسؤولة عن عمليات النقد والبنوك وإصدار السندات المالية.
@riverpod
class TreasuryService extends _$TreasuryService {
  @override
  FutureOr<void> build() {}

  /// الحصول على كافة السندات المسجلة
  Future<List<FinancialVoucher>> getAllVouchers() async {
    final voucherRepo = ref.read(financialVoucherRepositoryProvider);
    return voucherRepo.getAllVouchers();
  }

  /// إصدار سند قبض (Receipt Voucher)
  Future<String> issueReceipt(FinancialVoucher voucher) async {
    final financialYearService = ref.read(
      financialYearServiceProvider.notifier,
    );
    final voucherRepo = ref.read(financialVoucherRepositoryProvider);
    if (voucher.type != VoucherType.receipt) {
      throw Exception('Voucher must be a receipt');
    }

    final isPeriodOpen = await financialYearService.canPostToDate(voucher.date);
    if (!isPeriodOpen) throw Exception('Financial period is closed');

    await _validateTreasuryAccount(voucher.treasuryAccountId);

    final repository = ref.read(accountingRepositoryProvider);

    final lines = [
      JournalEntryLine(
        accountId: voucher.treasuryAccountId,
        accountName: 'الخزينة/البنك',
        debit: voucher.amount,
        credit: Decimal.zero,
        description: 'قبض: ${voucher.description}',
        originalCurrency: voucher.originalCurrency,
        exchangeRate: voucher.exchangeRate,
        originalAmount: voucher.originalAmount,
      ),
      JournalEntryLine(
        accountId: voucher.accountId,
        accountName: voucher.personName ?? 'حساب الدائن',
        credit: voucher.amount,
        debit: Decimal.zero,
        description: 'سند قبض رقم ${voucher.referenceNumber}',
        originalCurrency: voucher.originalCurrency,
        exchangeRate: voucher.exchangeRate,
        originalAmount: voucher.originalAmount,
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
        standardReference: 'IFRS 9', // GAAP: Financial Instruments
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

    await repository.addJournalEntry(entry);

    // حفظ السند نفسه في المستودع
    final postedVoucher = voucher.copyWith(
      isPosted: true,
      journalEntryId: entry.id,
    );
    await voucherRepo.addVoucher(postedVoucher);
    return entry.id;
  }

  /// إصدار سند صرف (Payment Voucher)
  Future<String> issuePayment(FinancialVoucher voucher) async {
    final financialYearService = ref.read(
      financialYearServiceProvider.notifier,
    );
    final voucherRepo = ref.read(financialVoucherRepositoryProvider);
    if (voucher.type != VoucherType.payment) {
      throw Exception('Voucher must be a payment');
    }

    final isPeriodOpen = await financialYearService.canPostToDate(voucher.date);
    if (!isPeriodOpen) throw Exception('Financial period is closed');

    await _validateTreasuryAccount(voucher.treasuryAccountId);

    final repository = ref.read(accountingRepositoryProvider);

    final lines = [
      JournalEntryLine(
        accountId: voucher.accountId,
        accountName: voucher.personName ?? 'حساب المدين',
        debit: voucher.amount,
        credit: Decimal.zero,
        description: 'صرف: ${voucher.description}',
        originalCurrency: voucher.originalCurrency,
        exchangeRate: voucher.exchangeRate,
        originalAmount: voucher.originalAmount,
      ),
      JournalEntryLine(
        accountId: voucher.treasuryAccountId,
        accountName: 'الخزينة/البنك',
        credit: voucher.amount,
        debit: Decimal.zero,
        description: 'سند صرف رقم ${voucher.referenceNumber}',
        originalCurrency: voucher.originalCurrency,
        exchangeRate: voucher.exchangeRate,
        originalAmount: voucher.originalAmount,
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
        standardReference: 'IFRS 9', // GAAP: Financial Instruments
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

    await repository.addJournalEntry(entry);

    // حفظ السند نفسه في المستودع
    final postedVoucher = voucher.copyWith(
      isPosted: true,
      journalEntryId: entry.id,
    );
    await voucherRepo.addVoucher(postedVoucher);
    return entry.id;
  }

  /// التحقق من أن الحساب هو حساب خزينة (نقد أو بنك)
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

/// موفر قائمة السندات (FR-ACC-016)
@riverpod
Future<List<FinancialVoucher>> getVouchers(Ref ref) async =>
    ref.watch(treasuryServiceProvider.notifier).getAllVouchers();
