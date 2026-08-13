import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/application/authoritative_ledger_gateway.dart';
import 'package:basir_accounting_system/features/accounting/application/treasury_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_voucher.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_year.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_accounting_repository.dart';
import '../../../helpers/mock_financial_voucher_repository.dart';
import '../../../helpers/mock_financial_year_repository.dart';

void main() {
  group('TreasuryService (Integration Style)', () {
    late ProviderContainer container;
    late MockFinancialVoucherRepository mockVoucherRepo;
    late MockAccountingRepository mockAccountingRepo;
    late MockFinancialYearRepository mockFyRepo;

    setUp(() {
      mockVoucherRepo = MockFinancialVoucherRepository();
      mockAccountingRepo = MockAccountingRepository();
      mockFyRepo = MockFinancialYearRepository();

      setUpAccountingMocks();
      registerFallbackValue(
        FinancialVoucher(
          id: 'test',
          type: VoucherType.receipt,
          date: DateTime.fromMicrosecondsSinceEpoch(0),
          accountId: 'acc',
          treasuryAccountId: 'treasury',
          amount: Decimal.zero,
          referenceNumber: 'ref',
          paymentMethod: PaymentMethod.cash,
          createdAt: DateTime.now(),
          description: 'fallback',
        ),
      );

      container = ProviderContainer(
        overrides: [
          financialVoucherRepositoryProvider.overrideWithValue(mockVoucherRepo),
          accountingRepositoryProvider.overrideWithValue(mockAccountingRepo),
          authoritativeLedgerGatewayProvider.overrideWithValue(
            const TestAuthoritativeLedgerGateway(),
          ),
          financialYearRepositoryProvider.overrideWithValue(mockFyRepo),
          basirUserProvider.overrideWith((ref) => null),
        ],
      );

      // Default mock behaviors
      // 1. Financial Year mock (Open period)
      when(() => mockFyRepo.getFinancialYearByDate(any())).thenAnswer(
        (_) async => FinancialYear(
          id: 'fy-2025',
          name: '2025',
          startDate: DateTime(2025),
          endDate: DateTime(2025, 12, 31),
        ),
      );

      // 2. Accounting Repo mocks
      when(
        () => mockAccountingRepo.cacheAuthoritativeJournalEntry(any()),
      ).thenAnswer((_) async {});

      // 3. Voucher Repo mocks
      when(() => mockVoucherRepo.addVoucher(any())).thenAnswer((_) async {});
    });

    tearDown(() {
      container.dispose();
    });

    final testAccount = Account(
      id: 'acc-1',
      code: '1101',
      nameAr: 'تست',
      nameEn: 'Test',
      type: AccountType.asset,
      nature: AccountNature.debit,
      balance: Decimal.zero,
      subType: 'cash',
    );

    test(
      'issueReceipt should succeed when period is open and account is valid',
      () async {
        // Setup: Return valid treasury account
        when(
          () => mockAccountingRepo.getAccountById('acc-1'),
        ).thenAnswer((_) async => testAccount);

        final voucher = FinancialVoucher(
          id: 'v-1',
          type: VoucherType.receipt,
          referenceNumber: 'REC-001',
          date: DateTime.now(),
          accountId: 'cust-1',
          treasuryAccountId: 'acc-1',
          amount: Decimal.parse('500'),
          originalAmount: Decimal.parse('500'),
          personName: 'Customer A',
          description: 'Payment for INV-001',
          paymentMethod: PaymentMethod.bank,
          createdAt: DateTime.now(),
        );

        final service = container.read(treasuryServiceProvider.notifier);
        await service.issueReceipt(voucher);

        verify(
          () => mockAccountingRepo.cacheAuthoritativeJournalEntry(any()),
        ).called(1);
        verifyNever(() => mockAccountingRepo.addJournalEntry(any()));
        verify(() => mockVoucherRepo.addVoucher(any())).called(1);
      },
    );

    test('issueReceipt should fail if period is closed', () async {
      // Setup: Return CLOSED financial year
      when(() => mockFyRepo.getFinancialYearByDate(any())).thenAnswer(
        (_) async => FinancialYear(
          id: 'fy-2024',
          name: '2024',
          startDate: DateTime(2024),
          endDate: DateTime(2024, 12, 31),
          isClosed: true,
        ),
      );

      final voucher = FinancialVoucher(
        id: 'v-2',
        type: VoucherType.receipt,
        referenceNumber: 'REC-002',
        date: DateTime.now(),
        accountId: 'cust-1',
        treasuryAccountId: 'acc-1',
        amount: Decimal.parse('500'),
        paymentMethod: PaymentMethod.cash,
        createdAt: DateTime.now(),
        description: 'Closed period test',
      );

      expect(
        () => container
            .read(treasuryServiceProvider.notifier)
            .issueReceipt(voucher),
        throwsException,
      );
    });

    test(
      'issuePayment should succeed when period is open and account is valid',
      () async {
        when(
          () => mockAccountingRepo.getAccountById('acc-1'),
        ).thenAnswer((_) async => testAccount);

        final voucher = FinancialVoucher(
          id: 'v-3',
          type: VoucherType.payment,
          referenceNumber: 'PAY-001',
          date: DateTime.now(),
          accountId: 'vend-1',
          treasuryAccountId: 'acc-1',
          amount: Decimal.parse('200'),
          originalAmount: Decimal.parse('200'),
          personName: 'Vendor B',
          description: 'Payment for Bill-123',
          paymentMethod: PaymentMethod.check,
          createdAt: DateTime.now(),
        );

        await container
            .read(treasuryServiceProvider.notifier)
            .issuePayment(voucher);

        verify(
          () => mockAccountingRepo.cacheAuthoritativeJournalEntry(any()),
        ).called(1);
        verifyNever(() => mockAccountingRepo.addJournalEntry(any()));
        verify(() => mockVoucherRepo.addVoucher(any())).called(1);
      },
    );

    test('should fail if treasury account is not cash or bank', () async {
      final invalidAccount = Account(
        id: 'acc-bad',
        code: '5000',
        nameAr: 'مصروف',
        nameEn: 'Expense',
        type: AccountType.expense,
        nature: AccountNature.debit,
        balance: Decimal.zero,
      );

      when(
        () => mockAccountingRepo.getAccountById('acc-bad'),
      ).thenAnswer((_) async => invalidAccount);

      final voucher = FinancialVoucher(
        id: 'v-4',
        type: VoucherType.payment,
        referenceNumber: 'PAY-002',
        date: DateTime.now(),
        accountId: 'vend-1',
        treasuryAccountId: 'acc-bad',
        amount: Decimal.parse('100'),
        paymentMethod: PaymentMethod.cash,
        createdAt: DateTime.now(),
        description: 'Invalid account test',
      );

      expect(
        () => container
            .read(treasuryServiceProvider.notifier)
            .issuePayment(voucher),
        throwsException,
      );
    });
  });
}
