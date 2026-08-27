import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/application/financial_year_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_year.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_accounting_repository.dart';
import '../../../../helpers/mock_financial_year_repository.dart';

class _FinancialYearFake extends Fake implements FinancialYear {}

void main() {
  setUpAll(() => registerFallbackValue(_FinancialYearFake()));
  late MockAccountingRepository accountingRepository;
  late MockFinancialYearRepository financialYearRepository;
  late ProviderContainer container;

  FinancialYear makeYear({
    bool isClosed = false,
    List<String> lockedPeriodIds = const [],
  }) {
    final now = DateTime.now();
    return FinancialYear(
      id: 'fy-${now.year}',
      name: 'Fiscal Year ${now.year}',
      startDate: DateTime(now.year),
      endDate: DateTime(now.year, 12, 31),
      isClosed: isClosed,
      lockedPeriodIds: lockedPeriodIds,
    );
  }

  JournalEntry makeEntry({
    required DateTime date,
    JournalEntryStatus status = JournalEntryStatus.posted,
  }) =>
      JournalEntry(
        id: 'je-${date.millisecondsSinceEpoch}-$status',
        referenceNumber: 'JE-${date.millisecondsSinceEpoch}',
        date: date,
        temporal: TemporalJustification(
          transactionDate: date,
          effectiveDate: date,
          recordingDate: date,
        ),
        standards: const StandardsJustification(
          standardReference: 'IFRS',
          recognitionBasis: 'Accrual',
        ),
        description: 'قيد اختبار',
        status: status,
        sourceDocument: 'test',
        sourceId: 'source',
        createdBy: 'tester',
        createdAt: date,
        updatedAt: date,
        lines: [
          JournalEntryLine(
            accountId: 'cash',
            accountName: 'النقدية',
            debit: Decimal.one,
            credit: Decimal.zero,
          ),
          JournalEntryLine(
            accountId: 'revenue',
            accountName: 'الإيراد',
            debit: Decimal.zero,
            credit: Decimal.one,
          ),
        ],
      );

  setUp(() {
    accountingRepository = MockAccountingRepository();
    financialYearRepository = MockFinancialYearRepository();
    container = ProviderContainer(
      overrides: [
        accountingRepositoryProvider.overrideWithValue(accountingRepository),
        financialYearRepositoryProvider
            .overrideWithValue(financialYearRepository),
      ],
    );
  });

  tearDown(() => container.dispose());

  FinancialYearService service() =>
      container.read(financialYearServiceProvider.notifier);

  group('FinancialYearService', () {
    test('يهيئ السنة الافتراضية مرة واحدة فقط عند غياب السنوات', () async {
      when(() => financialYearRepository.getAllFinancialYears())
          .thenAnswer((_) async => []);
      when(() => financialYearRepository.saveFinancialYear(any()))
          .thenAnswer((_) async {});

      await service().initializeDefaultYear();

      final saved = verify(
        () => financialYearRepository.saveFinancialYear(captureAny()),
      ).captured.single as FinancialYear;
      expect(saved.id, 'fy-${DateTime.now().year}');
      expect(saved.startDate, DateTime(DateTime.now().year));
      expect(saved.endDate, DateTime(DateTime.now().year, 12, 31));

      reset(financialYearRepository);
      when(() => financialYearRepository.getAllFinancialYears())
          .thenAnswer((_) async => [saved]);
      await service().initializeDefaultYear();
      verifyNever(() => financialYearRepository.saveFinancialYear(any()));
    });

    test(
        'يرفض الترحيل خارج السنة والمقفلة والفترة المقفلة ويقبل الفترة المفتوحة',
        () async {
      final date = DateTime(DateTime.now().year, 5, 15);
      when(() => financialYearRepository.getFinancialYearByDate(date))
          .thenAnswer((_) async => null);
      expect(await service().canPostToDate(date), isFalse);

      when(() => financialYearRepository.getFinancialYearByDate(date))
          .thenAnswer((_) async => makeYear(isClosed: true));
      expect(await service().canPostToDate(date), isFalse);

      when(() => financialYearRepository.getFinancialYearByDate(date))
          .thenAnswer(
        (_) async => makeYear(lockedPeriodIds: ['${date.year}-05']),
      );
      expect(await service().canPostToDate(date), isFalse);

      when(() => financialYearRepository.getFinancialYearByDate(date))
          .thenAnswer((_) async => makeYear());
      expect(await service().canPostToDate(date), isTrue);
    });

    test('يقفل ويفتح شهراً ويحمي العملية المتكررة', () async {
      final date = DateTime(DateTime.now().year, 7);
      final year = makeYear();
      when(() => financialYearRepository.getAllFinancialYears())
          .thenAnswer((_) async => [year]);
      when(() => financialYearRepository.saveFinancialYear(any()))
          .thenAnswer((_) async {});

      await service().lockMonthlyPeriod(year.id, date);
      final locked = verify(
        () => financialYearRepository.saveFinancialYear(captureAny()),
      ).captured.single as FinancialYear;
      expect(locked.lockedPeriodIds, contains('${date.year}-07'));

      reset(financialYearRepository);
      when(() => financialYearRepository.getAllFinancialYears())
          .thenAnswer((_) async => [locked]);
      await service().lockMonthlyPeriod(year.id, date);
      verifyNever(() => financialYearRepository.saveFinancialYear(any()));

      when(() => financialYearRepository.saveFinancialYear(any()))
          .thenAnswer((_) async {});
      await service().unlockMonthlyPeriod(year.id, date);
      final unlocked = verify(
        () => financialYearRepository.saveFinancialYear(captureAny()),
      ).captured.single as FinancialYear;
      expect(unlocked.lockedPeriodIds, isEmpty);
      expect(await service().getLockedPeriods(year.id), ['${date.year}-07']);
    });

    test('يمنع إغلاق السنة مع مسودة ويسمح به بعد ترحيل القيود', () async {
      final year = makeYear();
      final draft = makeEntry(
        date: DateTime(DateTime.now().year, 8),
        status: JournalEntryStatus.draft,
      );
      when(() => financialYearRepository.getAllFinancialYears())
          .thenAnswer((_) async => [year]);
      when(() => accountingRepository.getJournalEntries())
          .thenAnswer((_) async => [draft]);

      await expectLater(
        service().closeYear(year.id, 'auditor-1'),
        throwsA(isA<Exception>()),
      );
      verifyNever(
        () => financialYearRepository.closeFinancialYear(any(), any()),
      );

      when(() => accountingRepository.getJournalEntries()).thenAnswer(
        (_) async => [makeEntry(date: draft.date)],
      );
      when(
        () => financialYearRepository.closeFinancialYear(year.id, 'auditor-1'),
      ).thenAnswer((_) async {});

      await service().closeYear(year.id, 'auditor-1');
      verify(
        () => financialYearRepository.closeFinancialYear(year.id, 'auditor-1'),
      ).called(1);
    });
  });
}
