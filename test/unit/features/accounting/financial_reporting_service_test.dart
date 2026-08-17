/// اختبارات تجميعات خدمة التقارير المالية.
library;

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/application/financial_reporting_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAccountingRepository extends Mock implements AccountingRepository {}

Account _account({
  required String id,
  required String name,
  required AccountType type,
  required Decimal balance,
  String subType = '',
}) =>
    Account(
      id: id,
      code: id,
      nameAr: name,
      nameEn: name,
      type: type,
      nature: type == AccountType.revenue
          ? AccountNature.credit
          : AccountNature.debit,
      balance: balance,
      subType: subType,
    );

void main() {
  group('FinancialReportingService', () {
    late _MockAccountingRepository repository;
    late ProviderContainer container;

    setUp(() {
      repository = _MockAccountingRepository();
      container = ProviderContainer(
        overrides: [accountingRepositoryProvider.overrideWithValue(repository)],
      );
    });

    tearDown(() => container.dispose());

    test('يجمع قائمة الدخل ويستبعد الحسابات غير الربحية', () async {
      when(() => repository.getAccounts()).thenAnswer(
        (_) async => [
          _account(
            id: 'revenue',
            name: 'Service revenue',
            type: AccountType.revenue,
            balance: Decimal.parse('1000'),
          ),
          _account(
            id: 'rent',
            name: 'Rent expense',
            type: AccountType.expense,
            balance: Decimal.parse('250'),
          ),
          _account(
            id: 'cash',
            name: 'Cash',
            type: AccountType.asset,
            balance: Decimal.parse('750'),
          ),
        ],
      );
      final service =
          container.read(financialReportingServiceProvider.notifier);
      await container.read(financialReportingServiceProvider.future);

      final statement = await service.getIncomeStatement();

      expect(statement['totalRevenue'], Decimal.parse('1000'));
      expect(statement['totalExpenses'], Decimal.parse('250'));
      expect(statement['netIncome'], Decimal.parse('750'));
      expect(
        statement['revenueDetails'],
        {'Service revenue': Decimal.parse('1000')},
      );
      expect(
        statement['expenseDetails'],
        {'Rent expense': Decimal.parse('250')},
      );
    });

    test('يجمع المصروفات تحت الفئة الفرعية أو فئة أخرى', () async {
      when(() => repository.getAccounts()).thenAnswer(
        (_) async => [
          _account(
            id: 'rent',
            name: 'Rent',
            type: AccountType.expense,
            balance: Decimal.parse('125'),
            subType: 'Occupancy',
          ),
          _account(
            id: 'utilities',
            name: 'Utilities',
            type: AccountType.expense,
            balance: Decimal.parse('75'),
            subType: 'Occupancy',
          ),
          _account(
            id: 'misc',
            name: 'Misc',
            type: AccountType.expense,
            balance: Decimal.parse('20'),
          ),
          _account(
            id: 'revenue',
            name: 'Revenue',
            type: AccountType.revenue,
            balance: Decimal.parse('300'),
          ),
        ],
      );
      final service =
          container.read(financialReportingServiceProvider.notifier);
      await container.read(financialReportingServiceProvider.future);

      final composition = await service.getExpenseComposition();

      expect(composition, {
        'Occupancy': Decimal.parse('200'),
        'Other': Decimal.parse('20'),
      });
    });
  });
}
