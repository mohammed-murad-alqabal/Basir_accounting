/// اختبارات السلوك الحتمي لخدمة السنوات المالية.
library;

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/application/financial_year_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_year.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_financial_year_repository.dart';

FinancialYear financialYear({
  String id = 'fy-2025',
  bool isClosed = false,
  List<String> lockedPeriodIds = const [],
}) =>
    FinancialYear(
      id: id,
      name: 'Fiscal Year 2025',
      startDate: DateTime(2025),
      endDate: DateTime(2025, 12, 31),
      isClosed: isClosed,
      lockedPeriodIds: lockedPeriodIds,
    );

void main() {
  setUpAll(() {
    registerFallbackValue(financialYear());
  });

  group('FinancialYearService', () {
    late MockFinancialYearRepository repository;
    late ProviderContainer container;

    setUp(() {
      repository = MockFinancialYearRepository();
      container = ProviderContainer(
        overrides: [
          financialYearRepositoryProvider.overrideWithValue(repository),
        ],
      );
    });

    tearDown(() => container.dispose());

    FinancialYearService service() =>
        container.read(financialYearServiceProvider.notifier);

    test('ينشئ سنة افتراضية عندما لا توجد سنوات مالية', () async {
      when(() => repository.getAllFinancialYears()).thenAnswer((_) async => []);
      when(() => repository.saveFinancialYear(any())).thenAnswer((_) async {});

      await service().initializeDefaultYear();

      final saved = verify(
        () => repository.saveFinancialYear(captureAny()),
      ).captured.single as FinancialYear;
      expect(saved.id, 'fy-${DateTime.now().year}');
      expect(saved.startDate, DateTime(DateTime.now().year));
      expect(saved.endDate, DateTime(DateTime.now().year, 12, 31));
    });

    test('لا ينشئ سنة افتراضية مكررة عند وجود سنة محفوظة', () async {
      when(
        () => repository.getAllFinancialYears(),
      ).thenAnswer((_) async => [financialYear()]);

      await service().initializeDefaultYear();

      verifyNever(() => repository.saveFinancialYear(any()));
    });

    test('canPostToDate يرفض التاريخ غير المنتمي لسنة مالية', () async {
      when(
        () => repository.getFinancialYearByDate(any()),
      ).thenAnswer((_) async => null);

      expect(await service().canPostToDate(DateTime(2025, 5, 1)), isFalse);
    });

    test('canPostToDate يرفض سنة مقفلة حتى إن احتوت التاريخ', () async {
      when(
        () => repository.getFinancialYearByDate(any()),
      ).thenAnswer((_) async => financialYear(isClosed: true));

      expect(await service().canPostToDate(DateTime(2025, 5, 1)), isFalse);
    });

    test('canPostToDate يرفض الشهر المقفل ويقبل الشهر المفتوح', () async {
      when(() => repository.getFinancialYearByDate(any())).thenAnswer(
        (_) async => financialYear(lockedPeriodIds: const ['2025-05']),
      );

      expect(await service().canPostToDate(DateTime(2025, 5, 1)), isFalse);
      expect(await service().canPostToDate(DateTime(2025, 6, 1)), isTrue);
    });

    test('يقفل الشهر مرة واحدة ويحفظ معرف الفترة المنسق', () async {
      when(
        () => repository.getAllFinancialYears(),
      ).thenAnswer((_) async => [financialYear()]);
      when(() => repository.saveFinancialYear(any())).thenAnswer((_) async {});

      await service().lockMonthlyPeriod('fy-2025', DateTime(2025, 5, 15));
      await service().lockMonthlyPeriod('fy-2025', DateTime(2025, 5, 15));

      final saved = verify(
        () => repository.saveFinancialYear(captureAny()),
      ).captured.single as FinancialYear;
      expect(saved.lockedPeriodIds, ['2025-05']);
    });

    test('يلغي قفل الشهر ويحذف معرف الفترة فقط', () async {
      when(() => repository.getAllFinancialYears()).thenAnswer(
        (_) async => [
          financialYear(lockedPeriodIds: const ['2025-05', '2025-06']),
        ],
      );
      when(() => repository.saveFinancialYear(any())).thenAnswer((_) async {});

      await service().unlockMonthlyPeriod('fy-2025', DateTime(2025, 5, 15));

      final saved = verify(
        () => repository.saveFinancialYear(captureAny()),
      ).captured.single as FinancialYear;
      expect(saved.lockedPeriodIds, ['2025-06']);
    });

    test('لا يحفظ تعديلاً عندما تكون الفترة مطلقة أصلاً', () async {
      when(
        () => repository.getAllFinancialYears(),
      ).thenAnswer((_) async => [financialYear()]);

      await service().unlockMonthlyPeriod('fy-2025', DateTime(2025, 5, 15));

      verifyNever(() => repository.saveFinancialYear(any()));
    });

    test('يعيد قائمة الفترات المقفلة للسنة المطلوبة', () async {
      when(() => repository.getAllFinancialYears()).thenAnswer(
        (_) async => [
          financialYear(lockedPeriodIds: const ['2025-01', '2025-03']),
        ],
      );

      expect(
        await service().getLockedPeriods('fy-2025'),
        ['2025-01', '2025-03'],
      );
    });
  });
}
