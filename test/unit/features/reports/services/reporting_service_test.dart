import 'package:basir_app/features/reports/services/reporting_service.dart';
import 'package:basir_app/src/rust/api/reports.dart' as rust;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNativeReportingApi extends Mock implements NativeReportingApi {}

void main() {
  group('ReportingService', () {
    late ReportingService reportingService;
    late MockNativeReportingApi mockApi;

    setUp(() {
      mockApi = <credential-fixture>();
      reportingService = ReportingService(api: mockApi);
    });

    test('generateTrialBalance calls native API', () async {
      const mockData = rust.TrialBalanceDto(
        asOfDate: '2025-01-01',
        periodEnd: '2025-01-01',
        lines: [],
        totalDebits: '0',
        totalCredits: '0',
        isBalanced: true,
      );

      when(
        () => mockApi.generateTrialBalance(
          asOfDate: any(named: 'asOfDate'),
          periodStart: any(named: 'periodStart'),
        ),
      ).thenAnswer((_) async => mockData);

      final result = await reportingService.generateTrialBalance(
        asOfDate: '2025-01-01',
      );

      expect(result, mockData);
      verify(
        () => mockApi.generateTrialBalance(
          asOfDate: '2025-01-01',
        ),
      ).called(1);
    });

    test('generateIncomeStatement calls native API', () async {
      const mockData = rust.FinancialReportDto(
        title: 'Income Statement',
        lines: [],
        fromDate: '2025-01-01',
        toDate: '2025-12-31',
        generatedAt: '2025-01-01',
      );

      when(
        () => mockApi.generateIncomeStatement(
          fromDate: any(named: 'fromDate'),
          toDate: any(named: 'toDate'),
        ),
      ).thenAnswer((_) async => mockData);

      final result = await reportingService.generateIncomeStatement(
        fromDate: '2025-01-01',
        toDate: '2025-12-31',
      );

      expect(result, mockData);
      verify(
        () => mockApi.generateIncomeStatement(
          fromDate: '2025-01-01',
          toDate: '2025-12-31',
        ),
      ).called(1);
    });

    test('getReceivablesAging calls native API', () async {
      const mockData = <rust.AgingReportLineDto>[];

      when(
        () => mockApi.getReceivablesAging(
          asOfDate: any(named: 'asOfDate'),
        ),
      ).thenAnswer((_) async => mockData);

      final result = await reportingService.getReceivablesAging(
        asOfDate: '2025-01-01',
      );

      expect(result, mockData);
      verify(
        () => mockApi.getReceivablesAging(
          asOfDate: '2025-01-01',
        ),
      ).called(1);
    });

    test('getPayablesAging calls native API', () async {
      const mockData = <rust.AgingReportLineDto>[];

      when(
        () => mockApi.getPayablesAging(
          asOfDate: any(named: 'asOfDate'),
        ),
      ).thenAnswer((_) async => mockData);

      final result = await reportingService.getPayablesAging(
        asOfDate: '2025-01-01',
      );

      expect(result, mockData);
      verify(
        () => mockApi.getPayablesAging(
          asOfDate: '2025-01-01',
        ),
      ).called(1);
    });
  });
}
