import 'dart:async';

import 'package:basir_accounting_system/features/accounting/application/financial_statement_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_report.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/income_statement_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/app_error_widget.dart';
import 'package:basir_accounting_system/shared/widgets/app_loading_indicator.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeFinancialStatementService extends FinancialStatementService {
  _FakeFinancialStatementService(this.incomeStatementFuture);

  final Future<FinancialReport> incomeStatementFuture;

  @override
  void build() {}

  @override
  Future<FinancialReport> generateIncomeStatement(DateTime from, DateTime to) =>
      incomeStatementFuture;
}

FinancialReport _incomeStatement() => FinancialReport(
      title: 'Income Statement — Test Period',
      fromDate: DateTime(2026),
      toDate: DateTime(2026, 8, 14),
      generatedAt: DateTime(2026, 8, 14, 10),
      lines: [
        FinancialReportLine(
          label: 'Operating Activities',
          amount: Decimal.zero,
          isTitle: true,
        ),
        FinancialReportLine(
          label: 'Service Revenue',
          amount: Decimal.parse('12500.00'),
          indentLevel: 1,
          accountId: 'revenue-1',
        ),
        FinancialReportLine(
          label: 'Operating Loss',
          amount: Decimal.parse('-4500.00'),
          isTotal: true,
        ),
      ],
    );

Widget _testApp(Future<FinancialReport> incomeStatementFuture) => ProviderScope(
      overrides: [
        financialStatementServiceProvider.overrideWith(
          () => _FakeFinancialStatementService(incomeStatementFuture),
        ),
      ],
      child: MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const IncomeStatementScreen(),
      ),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('يعرض مؤشر التحميل حتى وصول قائمة الدخل', (tester) async {
    final completer = Completer<FinancialReport>();

    await tester.pumpWidget(_testApp(completer.future));
    await tester.pump();

    expect(find.byType(AppLoadingIndicator), findsOneWidget);

    completer.complete(_incomeStatement());
    await tester.pumpAndSettle();
    expect(find.text('Service Revenue'), findsOneWidget);
  });

  testWidgets('يعرض أقسام قائمة الدخل وبنودها والمقارنة التشغيلية', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(Future.value(_incomeStatement())));
    await tester.pumpAndSettle();

    expect(
        find.text('Operating Performance (Current vs Prior)'), findsOneWidget);
    expect(find.text('Current'), findsOneWidget);
    expect(find.text('Prior'), findsOneWidget);
    expect(find.text('Operating Activities'), findsOneWidget);
    expect(find.text('Service Revenue'), findsOneWidget);
    expect(find.text('Operating Loss'), findsOneWidget);
    expect(find.byType(InkWell), findsWidgets);
  });

  testWidgets('يعرض خطأ خدمة قائمة الدخل دون انهيار الشاشة', (tester) async {
    await tester.pumpWidget(
      _testApp(
        Future<FinancialReport>.delayed(
          Duration.zero,
          () => throw StateError('Income statement service unavailable'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppErrorWidget), findsOneWidget);
    expect(find.textContaining('Income statement service unavailable'),
        findsOneWidget);
  });
}
