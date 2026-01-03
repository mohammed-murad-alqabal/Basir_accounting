import 'package:basir_app/core/providers.dart';
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
    final financialYearService =
        ref.read(financialYearServiceProvider.notifier);
    final voucherRepo = ref.read(financialVoucherRepositoryProvider);
    if (voucher.type != VoucherType.receipt) {
      throw Exception('Voucher must be a receipt');
    }

    final isPeriodOpen = await financialYearService.canPostToDate(voucher.date);
    if (!isPeriodOpen) throw Exception('Financial period is closed');

    final repository = ref.read(accountingRepositoryProvider);

    final lines = [
      JournalEntryLine(
        accountId: voucher.treasuryAccountId,
        accountName: 'الخزينة/البنك',
        debit: voucher.amount,
        credit: Decimal.zero,
        description: 'قبض: ${voucher.description}',
      ),
      JournalEntryLine(
        accountId: voucher.accountId,
        accountName: voucher.personName ?? 'حساب الدائن',
        credit: voucher.amount,
        debit: Decimal.zero,
        description: 'سند قبض رقم ${voucher.referenceNumber}',
      ),
    ];

    final entry = JournalEntry(
      id: 'je-vouch-${voucher.id}',
      referenceNumber: 'JE-RE-${voucher.referenceNumber}',
      date: voucher.date,
      description: voucher.description,
      status: JournalEntryStatus.posted,
      lines: lines,
      sourceDocument: 'receipt_voucher',
      sourceId: voucher.id,
      createdAt: DateTime.now(),
      createdBy: 'system',
      updatedAt: DateTime.now(),
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
    final financialYearService =
        ref.read(financialYearServiceProvider.notifier);
    final voucherRepo = ref.read(financialVoucherRepositoryProvider);
    if (voucher.type != VoucherType.payment) {
      throw Exception('Voucher must be a payment');
    }

    final isPeriodOpen = await financialYearService.canPostToDate(voucher.date);
    if (!isPeriodOpen) throw Exception('Financial period is closed');

    final repository = ref.read(accountingRepositoryProvider);

    final lines = [
      JournalEntryLine(
        accountId: voucher.accountId,
        accountName: voucher.personName ?? 'حساب المدين',
        debit: voucher.amount,
        credit: Decimal.zero,
        description: 'صرف: ${voucher.description}',
      ),
      JournalEntryLine(
        accountId: voucher.treasuryAccountId,
        accountName: 'الخزينة/البنك',
        credit: voucher.amount,
        debit: Decimal.zero,
        description: 'سند صرف رقم ${voucher.referenceNumber}',
      ),
    ];

    final entry = JournalEntry(
      id: 'je-vouch-${voucher.id}',
      referenceNumber: 'JE-PY-${voucher.referenceNumber}',
      date: voucher.date,
      description: voucher.description,
      status: JournalEntryStatus.posted,
      lines: lines,
      sourceDocument: 'payment_voucher',
      sourceId: voucher.id,
      createdAt: DateTime.now(),
      createdBy: 'system',
      updatedAt: DateTime.now(),
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
}

/// موفر قائمة السندات (FR-ACC-016)
@riverpod
Future<List<FinancialVoucher>> getVouchers(Ref ref) async =>
    ref.watch(treasuryServiceProvider.notifier).getAllVouchers();
