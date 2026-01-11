import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/reports/application/analytics_service.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_accounting_repository.dart';

void main() {
  group('AnalyticsService', () {
    late ProviderContainer container;
    late MockAccountingRepository mockRepo;

    setUp(() {
      mockRepo = MockAccountingRepository();
      container = ProviderContainer(
        overrides: [accountingRepositoryProvider.overrideWithValue(mockRepo)],
      );

      // Default empty returns
      when(() => mockRepo.getAccounts()).thenAnswer((_) async => []);
      when(() => mockRepo.getJournalEntries()).thenAnswer((_) async => []);
    });

    tearDown(() {
      container.dispose();
    });

    group('getFinancialKpis', () {
      test('should return empty KPIs when no data exists', () async {
        final service = container.read(analyticsServiceProvider.notifier);
        final kpis = await service.getFinancialKpis();

        expect(kpis.length, 3);
        expect(kpis[0].value, 0.0); // Current Ratio
        expect(kpis[1].value, 0.0); // Burn Rate
        expect(kpis[2].value, 0.0); // Profit Margin
      });

      test('should calculate Current Ratio correctly', () async {
        final accounts = [
          // Current Assets
          Account(
            id: 'a1',
            code: '1101',
            nameAr: 'نقدية',
            nameEn: 'Cash',
            type: AccountType.asset,
            nature: AccountNature.debit,
            balance: Decimal.parse('2000'),
            subType: 'cash',
          ),
          // Current Liabilities
          Account(
            id: 'l1',
            code: '2101',
            nameAr: 'موردون',
            nameEn: 'AP',
            type: AccountType.liability,
            nature: AccountNature.credit,
            balance: Decimal.parse('1000'),
            subType: 'ap',
          ),
        ];

        when(() => mockRepo.getAccounts()).thenAnswer((_) async => accounts);

        final service = container.read(analyticsServiceProvider.notifier);
        final kpis = await service.getFinancialKpis();

        final currentRatio = kpis.firstWhere((k) => k.name == 'Current Ratio');
        expect(currentRatio.value, 2.0); // 2000 / 1000 = 2.0
      });

      test('should calculate Profit Margin correctly', () async {
        final accounts = [
          // Revenue
          Account(
            id: 'r1',
            code: '4101',
            nameAr: 'مبيعات',
            nameEn: 'Sales',
            type: AccountType.revenue,
            nature: AccountNature.credit,
            balance: Decimal.parse('10000'),
          ),
          // Expenses
          Account(
            id: 'e1',
            code: '5101',
            nameAr: 'تكلفة',
            nameEn: 'Cost',
            type: AccountType.expense,
            nature: AccountNature.debit,
            balance: Decimal.parse('6000'),
          ),
        ];

        when(() => mockRepo.getAccounts()).thenAnswer((_) async => accounts);

        final service = container.read(analyticsServiceProvider.notifier);
        final kpis = await service.getFinancialKpis();

        final profitMargin = kpis.firstWhere((k) => k.name == 'Profit Margin');
        // Net Income = 10000 - 6000 = 4000
        // Margin = (4000 / 10000) * 100 = 40%
        expect(profitMargin.value, 40.0);
      });
    });

    group('getCashFlowTrend', () {
      test('should calculate daily net cash flow correctly', () async {
        final accounts = [
          Account(
            id: 'cash-1',
            code: '1101',
            nameAr: 'نقدية',
            nameEn: 'Cash',
            type: AccountType.asset,
            nature: AccountNature.debit,
            balance: Decimal.parse('1000'),
            subType: 'cash',
          ),
        ];

        final today = DateTime.now();
        final entries = [
          JournalEntry(
            id: 'je-1',
            referenceNumber: 'JE-001',
            date: today,
            status: JournalEntryStatus.posted,
            lines: [
              JournalEntryLine(
                accountId: 'cash-1',
                accountName: 'Cash',
                debit: Decimal.parse('500'),
                credit: Decimal.zero,
                description: 'Receipt',
              ),
            ],
            // Required fields
            temporal: TemporalJustification(
              transactionDate: today,
              effectiveDate: today,
              recordingDate: today,
            ),
            standards: const StandardsJustification(
              standardReference: '',
              recognitionBasis: '',
            ),
            description: '',
            sourceDocument: '',
            sourceId: '',
            createdBy: '',
            createdAt: today,
            updatedAt: today,
          ),
          JournalEntry(
            id: 'je-2',
            referenceNumber: 'JE-002',
            date: today,
            status: JournalEntryStatus.posted,
            lines: [
              JournalEntryLine(
                accountId: 'cash-1',
                accountName: 'Cash',
                debit: Decimal.zero,
                credit: Decimal.parse('200'),
                description: 'Payment',
              ),
            ],
            // Required fields
            temporal: TemporalJustification(
              transactionDate: today,
              effectiveDate: today,
              recordingDate: today,
            ),
            standards: const StandardsJustification(
              standardReference: '',
              recognitionBasis: '',
            ),
            description: '',
            sourceDocument: '',
            sourceId: '',
            createdBy: '',
            createdAt: today,
            updatedAt: today,
          ),
        ];

        when(() => mockRepo.getAccounts()).thenAnswer((_) async => accounts);
        when(
          () => mockRepo.getJournalEntries(),
        ).thenAnswer((_) async => entries);

        final service = container.read(analyticsServiceProvider.notifier);
        final trend = await service.getCashFlowTrend();

        expect(trend.length, 30);
        // Last element is today
        expect(trend.last, 300.0); // 500 (debit) - 200 (credit) = 300
      });
    });
  });
}
