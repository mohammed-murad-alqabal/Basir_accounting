import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/application/financial_statement_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/ifrs18_ontology.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_accounting_repository.dart';

Account _account({
  required String id,
  required String code,
  required String name,
  required AccountType type,
  required AccountNature nature,
  Decimal? balance,
  Ifrs18Category ifrs18Category = Ifrs18Category.operating,
  bool isParent = false,
  String? parentId,
}) =>
    Account(
      id: id,
      code: code,
      nameAr: name,
      nameEn: name,
      type: type,
      nature: nature,
      balance: balance ?? Decimal.zero,
      ifrs18Category: ifrs18Category,
      isParent: isParent,
      parentId: parentId,
    );

void main() {
  group('FinancialStatementService', () {
    late MockAccountingRepository repository;
    late ProviderContainer container;

    setUp(() {
      repository = MockAccountingRepository();
      container = ProviderContainer(
        overrides: [
          accountingRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
    });

    FinancialStatementService service() =>
        container.read(financialStatementServiceProvider.notifier);

    void stubBalances(Map<String, Decimal> balances) {
      when(() => repository.getAccountBalance(any())).thenAnswer(
        (invocation) async => balances[invocation.positionalArguments.first]!,
      );
    }

    test(
        'generates a trial balance from non-parent accounts with non-zero balances',
        () async {
      final cash = _account(
        id: 'cash',
        code: '1101',
        name: 'Cash',
        type: AccountType.asset,
        nature: AccountNature.debit,
      );
      final payable = _account(
        id: 'payable',
        code: '2100',
        name: 'Payable',
        type: AccountType.liability,
        nature: AccountNature.credit,
      );
      final parent = _account(
        id: 'assets',
        code: '1000',
        name: 'Assets',
        type: AccountType.asset,
        nature: AccountNature.debit,
        isParent: true,
      );
      final pettyCash = _account(
        id: 'petty-cash',
        code: '1102',
        name: 'Petty cash',
        type: AccountType.asset,
        nature: AccountNature.debit,
        parentId: 'assets',
      );
      when(() => repository.getAccounts()).thenAnswer(
        (_) async => [cash, payable, parent, pettyCash],
      );
      stubBalances({
        'cash': Decimal.fromInt(100),
        'payable': Decimal.fromInt(100),
        'assets': Decimal.fromInt(999),
        'petty-cash': Decimal.zero,
      });

      final report =
          await service().generateTrialBalance(DateTime(2026, 1, 31));

      expect(report.date, DateTime(2026, 1, 31));
      expect(report.lines, hasLength(2));
      expect(report.lines.first.accountCode, '1101');
      expect(report.lines.first.debitBalance, Decimal.fromInt(100));
      expect(report.lines.last.creditBalance, Decimal.fromInt(100));
      expect(report.totalDebit, Decimal.fromInt(100));
      expect(report.totalCredit, Decimal.fromInt(100));
      verifyNever(() => repository.getAccountBalance('assets'));
    });

    test(
        'builds IFRS 18 activity sections and carries revenue and expenses into net profit',
        () async {
      final accounts = [
        _account(
          id: 'sales',
          code: '4100',
          name: 'Sales',
          type: AccountType.revenue,
          nature: AccountNature.credit,
        ),
        _account(
          id: 'rent',
          code: '6100',
          name: 'Rent',
          type: AccountType.expense,
          nature: AccountNature.debit,
        ),
        _account(
          id: 'investment-income',
          code: '4400',
          name: 'Investment income',
          type: AccountType.revenue,
          nature: AccountNature.credit,
          ifrs18Category: Ifrs18Category.investing,
        ),
        _account(
          id: 'finance-cost',
          code: '5600',
          name: 'Finance cost',
          type: AccountType.expense,
          nature: AccountNature.debit,
          ifrs18Category: Ifrs18Category.financing,
        ),
        _account(
          id: 'revenue-parent',
          code: '4000',
          name: 'Revenue',
          type: AccountType.revenue,
          nature: AccountNature.credit,
          isParent: true,
        ),
        _account(
          id: 'zero-income',
          code: '4199',
          name: 'Zero income',
          type: AccountType.revenue,
          nature: AccountNature.credit,
        ),
      ];
      when(() => repository.getAccounts()).thenAnswer((_) async => accounts);
      stubBalances({
        'sales': Decimal.fromInt(150),
        'rent': Decimal.fromInt(60),
        'investment-income': Decimal.fromInt(30),
        'finance-cost': Decimal.fromInt(5),
        'revenue-parent': Decimal.fromInt(999),
        'zero-income': Decimal.zero,
      });

      final report = await service().generateIncomeStatement(
        DateTime(2026),
        DateTime(2026, 1, 31),
      );

      expect(report.title, contains('Income Statement'));
      expect(report.lines.where((line) => line.isTitle), hasLength(4));
      expect(
        report.lines
            .singleWhere((line) => line.label == 'Total Operating Activities')
            .amount,
        Decimal.fromInt(90),
      );
      expect(
        report.lines
            .singleWhere((line) => line.label == 'Total Investing Activities')
            .amount,
        Decimal.fromInt(30),
      );
      expect(
        report.lines
            .singleWhere((line) => line.label == 'Total Financing Activities')
            .amount,
        -Decimal.fromInt(5),
      );
      expect(
        report.lines
            .singleWhere((line) => line.label == 'Net Profit / (Loss)')
            .amount,
        Decimal.fromInt(115),
      );
      verifyNever(() => repository.getAccountBalance('revenue-parent'));
    });

    test(
        'builds assets and liabilities plus equity totals from leaf accounts only',
        () async {
      final accounts = [
        _account(
          id: 'cash',
          code: '1101',
          name: 'Cash',
          type: AccountType.asset,
          nature: AccountNature.debit,
        ),
        _account(
          id: 'equipment',
          code: '1501',
          name: 'Equipment',
          type: AccountType.asset,
          nature: AccountNature.debit,
        ),
        _account(
          id: 'payable',
          code: '2100',
          name: 'Payable',
          type: AccountType.liability,
          nature: AccountNature.credit,
        ),
        _account(
          id: 'capital',
          code: '3100',
          name: 'Capital',
          type: AccountType.equity,
          nature: AccountNature.credit,
        ),
        _account(
          id: 'asset-parent',
          code: '1000',
          name: 'Assets',
          type: AccountType.asset,
          nature: AccountNature.debit,
          isParent: true,
          parentId: 'root',
        ),
      ];
      when(() => repository.getAccounts()).thenAnswer((_) async => accounts);
      stubBalances({
        'cash': Decimal.fromInt(100),
        'equipment': Decimal.fromInt(80),
        'payable': Decimal.fromInt(100),
        'capital': Decimal.fromInt(80),
        'asset-parent': Decimal.fromInt(999),
      });

      final report =
          await service().generateBalanceSheet(DateTime(2026, 1, 31));

      expect(report.title, contains('Balance Sheet'));
      expect(report.fromDate, report.toDate);
      expect(
        report.lines.singleWhere((line) => line.label == 'Total Assets').amount,
        Decimal.fromInt(180),
      );
      expect(
        report.lines
            .singleWhere((line) => line.label == 'Total Liabilities and Equity')
            .amount,
        Decimal.fromInt(180),
      );
      expect(report.lines.where((line) => line.isTitle), hasLength(2));
      verifyNever(() => repository.getAccountBalance('asset-parent'));
    });
  });
}
