import 'dart:async';

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/application/financial_year_service.dart';
import 'package:basir_accounting_system/features/accounting/application/treasury_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_voucher.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_financial_voucher_repository.dart';

class _FakeFinancialYearService extends FinancialYearService {
  bool isOpen = true;
  final checkedDates = <DateTime>[];

  @override
  FutureOr<void> build() {}

  @override
  Future<bool> canPostToDate(DateTime date) async {
    checkedDates.add(date);
    return isOpen;
  }
}

class _FakeAccountingService extends AccountingService {
  _FakeAccountingService(this.accounts);

  final Map<String, Account> accounts;
  final postedEntries = <JournalEntry>[];

  @override
  FutureOr<List<JournalEntry>> build() => const [];

  @override
  Future<Account?> getAccountById(String accountId) async =>
      accounts[accountId];

  @override
  Future<void> postJournalEntry(
    JournalEntry entry, {
    bool bypassCognitive = false,
  }) async {
    postedEntries.add(entry);
  }
}

class _FinancialVoucherFake extends Fake implements FinancialVoucher {}

Account _account({
  required String id,
  required String code,
  String? subType,
}) =>
    Account(
      id: id,
      code: code,
      nameAr: id,
      nameEn: id,
      type: AccountType.asset,
      nature: AccountNature.debit,
      balance: Decimal.zero,
      subType: subType ?? '',
    );

FinancialVoucher _voucher({
  required String id,
  required VoucherType type,
  String treasuryAccountId = 'cash',
  String? originalCurrency,
  Decimal? exchangeRate,
  Decimal? originalAmount,
}) {
  final now = DateTime(2025, 2, 15);
  return FinancialVoucher(
    id: id,
    referenceNumber: 'V-$id',
    date: now,
    type: type,
    paymentMethod: PaymentMethod.bank,
    amount: Decimal.parse('37.50'),
    accountId: 'counterparty',
    treasuryAccountId: treasuryAccountId,
    description: 'Treasury test $id',
    personName: 'Counterparty',
    createdAt: now,
    originalCurrency: originalCurrency,
    exchangeRate: exchangeRate,
    originalAmount: originalAmount,
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(_FinancialVoucherFake());
  });

  group('TreasuryService', () {
    late MockFinancialVoucherRepository voucherRepository;
    late _FakeFinancialYearService financialYearService;
    late _FakeAccountingService accountingService;
    late ProviderContainer container;

    setUp(() {
      voucherRepository = MockFinancialVoucherRepository();
      financialYearService = _FakeFinancialYearService();
      accountingService = _FakeAccountingService({
        'cash': _account(id: 'cash', code: '110101', subType: 'cash'),
        'bank': _account(id: 'bank', code: '110201', subType: 'bank'),
        'expense': _account(id: 'expense', code: '610001'),
      });
      container = ProviderContainer(
        overrides: [
          financialVoucherRepositoryProvider.overrideWithValue(
            voucherRepository,
          ),
          financialYearServiceProvider.overrideWith(() => financialYearService),
          accountingServiceProvider.overrideWith(() => accountingService),
          basirUserProvider.overrideWithValue(null),
        ],
      );
      addTearDown(container.dispose);
    });

    TreasuryService service() =>
        container.read(treasuryServiceProvider.notifier);

    test('issues a balanced foreign-currency receipt and persists it as posted',
        () async {
      final voucher = _voucher(
        id: 'receipt-foreign',
        type: VoucherType.receipt,
        originalCurrency: 'USD',
        exchangeRate: Decimal.parse('3.75'),
        originalAmount: Decimal.fromInt(10),
      );
      when(() => voucherRepository.addVoucher(any())).thenAnswer((_) async {});

      final journalEntryId = await service().issueReceipt(voucher);

      expect(journalEntryId, 'je-vouch-receipt-foreign');
      expect(financialYearService.checkedDates, [voucher.date]);
      expect(accountingService.postedEntries, hasLength(1));
      final entry = accountingService.postedEntries.single;
      expect(entry.isBalanced, isTrue);
      expect(entry.referenceNumber, 'JE-RE-V-receipt-foreign');
      expect(entry.sourceDocument, 'receipt_voucher');
      expect(entry.lines.first.debit, Decimal.parse('37.50'));
      expect(entry.lines.first.originalCurrency, 'USD');
      expect(entry.lines.last.credit, Decimal.parse('37.50'));
      expect(entry.lines.last.originalAmount, Decimal.fromInt(10));

      final saved = verify(
        () => voucherRepository.addVoucher(captureAny()),
      ).captured.single as FinancialVoucher;
      expect(saved.isPosted, isTrue);
      expect(saved.journalEntryId, journalEntryId);
    });

    test('issues a payment with debit and credit directions reversed',
        () async {
      final voucher = _voucher(
        id: 'payment-bank',
        type: VoucherType.payment,
        treasuryAccountId: 'bank',
      );
      when(() => voucherRepository.addVoucher(any())).thenAnswer((_) async {});

      final journalEntryId = await service().issuePayment(voucher);

      expect(journalEntryId, 'je-vouch-payment-bank');
      final entry = accountingService.postedEntries.single;
      expect(entry.isBalanced, isTrue);
      expect(entry.referenceNumber, 'JE-PY-V-payment-bank');
      expect(entry.sourceDocument, 'payment_voucher');
      expect(entry.lines.first.accountId, 'counterparty');
      expect(entry.lines.first.debit, Decimal.parse('37.50'));
      expect(entry.lines.last.accountId, 'bank');
      expect(entry.lines.last.credit, Decimal.parse('37.50'));
    });

    test('rejects a payment passed to receipt issuance before posting',
        () async {
      final voucher =
          _voucher(id: 'wrong-direction', type: VoucherType.payment);

      await expectLater(
        service().issueReceipt(voucher),
        throwsA(isA<Exception>()),
      );

      expect(financialYearService.checkedDates, isEmpty);
      expect(accountingService.postedEntries, isEmpty);
      verifyNever(() => voucherRepository.addVoucher(any()));
    });

    test('rejects a receipt when its financial period is closed', () async {
      financialYearService.isOpen = false;
      final voucher = _voucher(id: 'closed-period', type: VoucherType.receipt);

      await expectLater(
        service().issueReceipt(voucher),
        throwsA(isA<Exception>()),
      );

      expect(financialYearService.checkedDates, [voucher.date]);
      expect(accountingService.postedEntries, isEmpty);
      verifyNever(() => voucherRepository.addVoucher(any()));
    });

    test('rejects a non-cash, non-bank treasury account before posting',
        () async {
      final voucher = _voucher(
        id: 'invalid-treasury',
        type: VoucherType.payment,
        treasuryAccountId: 'expense',
      );

      await expectLater(
        service().issuePayment(voucher),
        throwsA(isA<Exception>()),
      );

      expect(accountingService.postedEntries, isEmpty);
      verifyNever(() => voucherRepository.addVoucher(any()));
    });

    test('delegates voucher listing to its repository', () async {
      final vouchers = [
        _voucher(id: 'listed-receipt', type: VoucherType.receipt),
        _voucher(id: 'listed-payment', type: VoucherType.payment),
      ];
      when(
        () => voucherRepository.getAllVouchers(),
      ).thenAnswer((_) async => vouchers);

      final result = await service().getAllVouchers();

      expect(result, vouchers);
      verify(() => voucherRepository.getAllVouchers()).called(1);
    });
  });
}
