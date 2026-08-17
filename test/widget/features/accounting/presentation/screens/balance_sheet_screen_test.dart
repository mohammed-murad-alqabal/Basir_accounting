import 'dart:async';

import 'package:basir_accounting_system/features/accounting/application/financial_statement_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_report.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/balance_sheet_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/app_error_widget.dart';
import 'package:basir_accounting_system/shared/widgets/app_loading_indicator.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeFinancialStatementService extends FinancialStatementService {
  _FakeFinancialStatementService(this.balanceSheetFuture);

  final Future<FinancialReport> balanceSheetFuture;

  @override
  void build() {}

  @override
  Future<FinancialReport> generateBalanceSheet(DateTime date) =>
      balanceSheetFuture;
}

FinancialReport _balanceSheet() => FinancialReport(
      title: 'Balance Sheet — Test Date',
      fromDate: DateTime(2026, 8, 14),
      toDate: DateTime(2026, 8, 14),
      generatedAt: DateTime(2026, 8, 14, 10),
      lines: [
        FinancialReportLine(
          label: 'Assets',
          amount: Decimal.zero,
          isTitle: true,
        ),
        FinancialReportLine(
          label: 'Cash at Bank',
          amount: Decimal.parse('72000.00'),
          indentLevel: 1,
          accountId: 'cash-1',
        ),
        FinancialReportLine(
          label: 'Total Assets',
          amount: Decimal.parse('72000.00'),
          isTotal: true,
        ),
        FinancialReportLine(
          label: 'Liabilities and Equity',
          amount: Decimal.zero,
          isTitle: true,
        ),
        FinancialReportLine(
          label: 'Capital',
          amount: Decimal.parse('72000.00'),
          indentLevel: 1,
          accountId: 'equity-1',
        ),
        FinancialReportLine(
          label: 'Total Liabilities and Equity',
          amount: Decimal.parse('72000.00'),
          isTotal: true,
        ),
      ],
    );

Widget _testApp(Future<FinancialReport> balanceSheetFuture) => ProviderScope(
      overrides: [
        financialStatementServiceProvider.overrideWith(
          () => _FakeFinancialStatementService(balanceSheetFuture),
        ),
      ],
      child: const MaterialApp(
        locale: Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BalanceSheetScreen(),
      ),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('يعرض مؤشر التحميل حتى وصول الميزانية العمومية', (tester) async {
    final completer = Completer<FinancialReport>();

    await tester.pumpWidget(_testApp(completer.future));
    await tester.pump();
    expect(find.byType(AppLoadingIndicator), findsOneWidget);

    completer.complete(_balanceSheet());
    await tester.pumpAndSettle();
    expect(find.text('Cash at Bank'), findsOneWidget);
  });

  testWidgets('يعرض أقسام الميزانية وبنودها ومجاميعها', (tester) async {
    await tester.pumpWidget(_testApp(Future.value(_balanceSheet())));
    await tester.pumpAndSettle();

    expect(find.text('Assets'), findsOneWidget);
    expect(find.text('Cash at Bank'), findsOneWidget);
    expect(find.text('Total Assets'), findsOneWidget);
    expect(find.text('Liabilities and Equity'), findsOneWidget);
    expect(find.text('Capital'), findsOneWidget);
    expect(find.text('Total Liabilities and Equity'), findsOneWidget);
    expect(find.byType(Divider), findsNWidgets(2));
  });

  testWidgets('يعرض خطأ خدمة الميزانية دون انهيار الشاشة', (tester) async {
    await tester.pumpWidget(
      _testApp(
        Future<FinancialReport>.delayed(
          Duration.zero,
          () => throw StateError('Balance sheet service unavailable'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppErrorWidget), findsOneWidget);
    expect(
      find.textContaining('Balance sheet service unavailable'),
      findsOneWidget,
    );
  });
}
