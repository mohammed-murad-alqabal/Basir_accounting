import 'package:basir_accounting_system/core/providers.dart'
    hide ReportingService;
import 'package:basir_accounting_system/features/accounting/application/reporting_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart'
    as acct;
import 'package:basir_accounting_system/features/accounting/domain/entities/ifrs18_ontology.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart'
    as journal;
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_accounting_repository.dart';

acct.Account _account({
  required String id,
  required String code,
  required String name,
  required acct.AccountType type,
  required acct.AccountNature nature,
  required Decimal balance,
  String? parentId,
}) =>
    acct.Account(
      id: id,
      code: code,
      nameAr: name,
      nameEn: name,
      type: type,
      nature: nature,
      balance: balance,
      parentId: parentId,
    );

journal.JournalEntryLine _line({
  required String accountId,
  required Decimal debit,
  required Decimal credit,
}) =>
    journal.JournalEntryLine(
      accountId: accountId,
      accountName: accountId,
      debit: debit,
      credit: credit,
    );

journal.JournalEntry _entry({
  required String id,
  required journal.JournalEntryStatus status,
  required List<journal.JournalEntryLine> lines,
}) {
  final now = DateTime(2025);
  return journal.JournalEntry(
    id: id,
    referenceNumber: 'JE-$id',
    date: now,
    temporal: journal.TemporalJustification(
      transactionDate: now,
      effectiveDate: now,
      recordingDate: now,
    ),
    standards: const journal.StandardsJustification(
      standardReference: 'IFRS 18',
    ),
    description: 'Reporting service fixture',
    status: status,
    lines: lines,
    sourceDocument: 'test',
    sourceId: id,
    createdBy: 'tester',
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  group('ReportingService', () {
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

    ReportingService service() =>
        container.read(reportingServiceProvider.notifier);

    test(
        'builds debit and credit trial-balance rows and excludes zero balances',
        () async {
      final cash = _account(
        id: 'cash',
        code: '1101',
        name: 'Cash',
        type: acct.AccountType.asset,
        nature: acct.AccountNature.debit,
        balance: Decimal.fromInt(100),
      );
      final prepaidCredit = _account(
        id: 'prepaid-credit',
        code: '1300',
        name: 'Prepaid credit',
        type: acct.AccountType.asset,
        nature: acct.AccountNature.debit,
        balance: -Decimal.fromInt(20),
      );
      final payable = _account(
        id: 'payable',
        code: '2100',
        name: 'Payable',
        type: acct.AccountType.liability,
        nature: acct.AccountNature.credit,
        balance: Decimal.fromInt(70),
      );
      final dormant = _account(
        id: 'dormant',
        code: '9999',
        name: 'Dormant',
        type: acct.AccountType.asset,
        nature: acct.AccountNature.debit,
        balance: Decimal.zero,
      );
      when(() => repository.getAccounts()).thenAnswer(
        (_) async => [cash, prepaidCredit, payable, dormant],
      );
      when(() => repository.getJournalEntries()).thenAnswer((_) async => []);

      final rows = await service().getTrialBalance();

      expect(rows, hasLength(3));
      expect(rows[0].debit, Decimal.fromInt(100));
      expect(rows[1].credit, Decimal.fromInt(20));
      expect(rows[2].credit, Decimal.fromInt(70));
    });

    test('classifies IFRS 18 income and expense balances into all categories',
        () async {
      final accounts = [
        _account(
          id: 'operating-revenue',
          code: '4100',
          name: 'Sales revenue',
          type: acct.AccountType.revenue,
          nature: acct.AccountNature.credit,
          balance: Decimal.fromInt(100),
        ),
        _account(
          id: 'investment-revenue',
          code: '4400',
          name: 'Investment income',
          type: acct.AccountType.revenue,
          nature: acct.AccountNature.credit,
          balance: Decimal.fromInt(30),
        ),
        _account(
          id: 'finance-revenue',
          code: '5500',
          name: 'Finance income',
          type: acct.AccountType.revenue,
          nature: acct.AccountNature.credit,
          balance: Decimal.fromInt(20),
        ),
        _account(
          id: 'tax-revenue',
          code: '4700',
          name: 'Tax recovery',
          type: acct.AccountType.revenue,
          nature: acct.AccountNature.credit,
          balance: Decimal.fromInt(5),
        ),
        _account(
          id: 'operating-expense',
          code: '6100',
          name: 'Operating expense',
          type: acct.AccountType.expense,
          nature: acct.AccountNature.debit,
          balance: Decimal.fromInt(40),
        ),
        _account(
          id: 'asset',
          code: '1101',
          name: 'Cash',
          type: acct.AccountType.asset,
          nature: acct.AccountNature.debit,
          balance: Decimal.fromInt(500),
        ),
      ];
      when(() => repository.getAccounts()).thenAnswer((_) async => accounts);
      when(() => repository.getJournalEntries()).thenAnswer((_) async => []);

      final statement = await service().getIncomeStatement();

      expect(statement[Ifrs18Category.operating], Decimal.fromInt(60));
      expect(statement[Ifrs18Category.investing], Decimal.fromInt(30));
      expect(statement[Ifrs18Category.financing], Decimal.fromInt(20));
      expect(statement[Ifrs18Category.incomeTax], Decimal.fromInt(5));
    });

    test('aggregates only root asset, liability, and equity account balances',
        () async {
      final accounts = [
        _account(
          id: 'cash',
          code: '1101',
          name: 'Cash',
          type: acct.AccountType.asset,
          nature: acct.AccountNature.debit,
          balance: Decimal.fromInt(100),
        ),
        _account(
          id: 'cash-child',
          code: '1102',
          name: 'Petty cash',
          type: acct.AccountType.asset,
          nature: acct.AccountNature.debit,
          balance: Decimal.fromInt(30),
          parentId: 'cash',
        ),
        _account(
          id: 'payable',
          code: '2100',
          name: 'Payable',
          type: acct.AccountType.liability,
          nature: acct.AccountNature.credit,
          balance: Decimal.fromInt(50),
        ),
        _account(
          id: 'capital',
          code: '3100',
          name: 'Capital',
          type: acct.AccountType.equity,
          nature: acct.AccountNature.credit,
          balance: Decimal.fromInt(20),
        ),
        _account(
          id: 'revenue',
          code: '4100',
          name: 'Sales',
          type: acct.AccountType.revenue,
          nature: acct.AccountNature.credit,
          balance: Decimal.fromInt(90),
        ),
      ];
      when(() => repository.getAccounts()).thenAnswer((_) async => accounts);
      when(() => repository.getJournalEntries()).thenAnswer((_) async => []);

      final balanceSheet = await service().getBalanceSheet();

      expect(balanceSheet['assets'], Decimal.fromInt(130));
      expect(balanceSheet['liabilities'], Decimal.fromInt(50));
      expect(balanceSheet['equity'], Decimal.fromInt(20));
    });

    test('classifies posted cash movements and ignores draft entries',
        () async {
      final cash = _account(
        id: 'cash',
        code: '1101',
        name: 'Main Cash',
        type: acct.AccountType.asset,
        nature: acct.AccountNature.debit,
        balance: Decimal.zero,
      );
      final revenue = _account(
        id: 'revenue',
        code: '4100',
        name: 'Sales',
        type: acct.AccountType.revenue,
        nature: acct.AccountNature.credit,
        balance: Decimal.zero,
      );
      final expense = _account(
        id: 'expense',
        code: '6100',
        name: 'Rent expense',
        type: acct.AccountType.expense,
        nature: acct.AccountNature.debit,
        balance: Decimal.zero,
      );
      final equipment = _account(
        id: 'equipment',
        code: '1201',
        name: 'Equipment',
        type: acct.AccountType.asset,
        nature: acct.AccountNature.debit,
        balance: Decimal.zero,
      );
      final capital = _account(
        id: 'capital',
        code: '3100',
        name: 'Capital',
        type: acct.AccountType.equity,
        nature: acct.AccountNature.credit,
        balance: Decimal.zero,
      );
      final accountsById = {
        for (final account in [cash, revenue, expense, equipment, capital])
          account.id: account,
      };
      when(() => repository.getAccounts()).thenAnswer(
        (_) async => accountsById.values.toList(),
      );
      when(() => repository.getAccountById(any())).thenAnswer(
        (invocation) async =>
            accountsById[invocation.positionalArguments.first],
      );
      when(() => repository.getJournalEntries()).thenAnswer(
        (_) async => [
          _entry(
            id: 'receipt',
            status: journal.JournalEntryStatus.posted,
            lines: [
              _line(
                accountId: 'cash',
                debit: Decimal.fromInt(100),
                credit: Decimal.zero,
              ),
              _line(
                accountId: 'revenue',
                debit: Decimal.zero,
                credit: Decimal.fromInt(100),
              ),
            ],
          ),
          _entry(
            id: 'payment',
            status: journal.JournalEntryStatus.posted,
            lines: [
              _line(
                accountId: 'expense',
                debit: Decimal.fromInt(25),
                credit: Decimal.zero,
              ),
              _line(
                accountId: 'cash',
                debit: Decimal.zero,
                credit: Decimal.fromInt(25),
              ),
            ],
          ),
          _entry(
            id: 'equipment-purchase',
            status: journal.JournalEntryStatus.posted,
            lines: [
              _line(
                accountId: 'equipment',
                debit: Decimal.fromInt(40),
                credit: Decimal.zero,
              ),
              _line(
                accountId: 'cash',
                debit: Decimal.zero,
                credit: Decimal.fromInt(40),
              ),
            ],
          ),
          _entry(
            id: 'capital-injection',
            status: journal.JournalEntryStatus.posted,
            lines: [
              _line(
                accountId: 'cash',
                debit: Decimal.fromInt(60),
                credit: Decimal.zero,
              ),
              _line(
                accountId: 'capital',
                debit: Decimal.zero,
                credit: Decimal.fromInt(60),
              ),
            ],
          ),
          _entry(
            id: 'draft',
            status: journal.JournalEntryStatus.draft,
            lines: [
              _line(
                accountId: 'cash',
                debit: Decimal.fromInt(999),
                credit: Decimal.zero,
              ),
            ],
          ),
        ],
      );

      final cashFlow = await service().getCashFlowStatement();

      expect(cashFlow['operatingReceipts'], Decimal.fromInt(100));
      expect(cashFlow['operatingPayments'], Decimal.fromInt(25));
      expect(cashFlow['netOperating'], Decimal.fromInt(75));
      expect(cashFlow['investing'], -Decimal.fromInt(40));
      expect(cashFlow['financing'], Decimal.fromInt(60));
      expect(cashFlow['netChange'], Decimal.fromInt(95));
    });

    test('derives health indicators from financial position and performance',
        () async {
      final accounts = [
        _account(
          id: 'cash',
          code: '1101',
          name: 'Cash',
          type: acct.AccountType.asset,
          nature: acct.AccountNature.debit,
          balance: Decimal.fromInt(200),
        ),
        _account(
          id: 'payable',
          code: '2100',
          name: 'Payable',
          type: acct.AccountType.liability,
          nature: acct.AccountNature.credit,
          balance: Decimal.fromInt(100),
        ),
        _account(
          id: 'sales',
          code: '4100',
          name: 'Sales',
          type: acct.AccountType.revenue,
          nature: acct.AccountNature.credit,
          balance: Decimal.fromInt(100),
        ),
        _account(
          id: 'costs',
          code: '6100',
          name: 'Costs',
          type: acct.AccountType.expense,
          nature: acct.AccountNature.debit,
          balance: Decimal.fromInt(20),
        ),
      ];
      when(() => repository.getAccounts()).thenAnswer((_) async => accounts);
      when(() => repository.getJournalEntries()).thenAnswer((_) async => []);

      final indicators = await service().getFinancialHealthIndicators();

      expect(indicators['liquidity'], 2.0);
      expect(indicators['profitability'], 0.8);
      expect(indicators['operating_margin'], 0.8);
    });
  });
}
