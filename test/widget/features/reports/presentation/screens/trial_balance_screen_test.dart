import 'dart:async';

import 'package:basir_accounting_system/core/utils/format_helpers.dart';
import 'package:basir_accounting_system/features/reports/presentation/screens/trial_balance_screen.dart';
import 'package:basir_accounting_system/features/reports/services/reporting_service.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/src/rust/api/reports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _ReportingServiceFake extends ReportingService {
  _ReportingServiceFake(this._result);

  final Future<TrialBalanceDto> _result;

  @override
  Future<TrialBalanceDto> generateTrialBalance({
    required String asOfDate,
    String? periodStart,
  }) =>
      _result;
}

TrialBalanceDto report({required bool isBalanced}) => TrialBalanceDto(
      asOfDate: '2025-01-31',
      periodEnd: '2025-01-31',
      lines: const [
        TrialBalanceLineDto(
          accountId: 'cash',
          accountCode: '1010',
          accountName: 'الصندوق',
          debitBalance: '1150.00',
          creditBalance: '0.00',
        ),
        TrialBalanceLineDto(
          accountId: 'revenue',
          accountCode: '4010',
          accountName: 'إيرادات الخدمات',
          debitBalance: '0.00',
          creditBalance: '1150.00',
        ),
      ],
      totalDebits: '1150.00',
      totalCredits: isBalanced ? '1150.00' : '1000.00',
      isBalanced: isBalanced,
    );

Widget testApp(Future<TrialBalanceDto> result) => ProviderScope(
      overrides: [
        nativeReportingServiceProvider.overrideWithValue(
          _ReportingServiceFake(result),
        ),
      ],
      child: const MaterialApp(
        locale: Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: TrialBalanceScreen(),
      ),
    );

void main() {
  group('TrialBalanceScreen', () {
    testWidgets('يعرض مؤشر التحميل ثم جدول ميزان مراجعة متزن وإجمالياته', (
      tester,
    ) async {
      final completer = Completer<TrialBalanceDto>();
      await tester.pumpWidget(testApp(completer.future));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(report(isBalanced: true));
      await tester.pumpAndSettle();

      expect(find.text('الصندوق'), findsOneWidget);
      expect(find.text('إيرادات الخدمات'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(
        find.text(FormatHelpers.formatCurrency(1150)),
        findsNWidgets(4),
      );
    });

    testWidgets('يعرض حالة عدم اتزان الميزان عندما تختلف الإجماليات', (
      tester,
    ) async {
      await tester.pumpWidget(testApp(Future.value(report(isBalanced: false))));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.warning), findsOneWidget);
      expect(find.text(FormatHelpers.formatCurrency(1000)), findsOneWidget);
    });

    testWidgets('يعرض حالة الخطأ عند فشل استدعاء خدمة التقرير', (tester) async {
      await tester.pumpWidget(
        testApp(
          Future<TrialBalanceDto>.delayed(
            const Duration(milliseconds: 1),
            () => throw StateError('تعذر توليد التقرير'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('تعذر توليد التقرير'), findsOneWidget);
    });
  });
}
