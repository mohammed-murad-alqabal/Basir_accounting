import 'dart:async';

import 'package:basir_accounting_system/features/accounting/application/tax_engine_service.dart';
import 'package:basir_accounting_system/features/reports/application/report_pdf_service.dart';
import 'package:basir_accounting_system/features/reports/presentation/screens/smart_tax_report_screen.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeTaxEngineService extends TaxEngineService {
  _FakeTaxEngineService(this._calculate);

  final Future<VatReturnStatement> Function() _calculate;

  @override
  FutureOr<void> build() {}

  @override
  Future<VatReturnStatement> calculateVatReturn() => _calculate();
}

class _FakeReportPdfService extends ReportPdfService {
  _FakeReportPdfService({this.failure});

  final Exception? failure;
  VatReturnStatement? sharedStatement;

  @override
  void build() {}

  @override
  Future<void> shareVatReturnPdf(VatReturnStatement data) async {
    if (failure != null) throw failure!;
    sharedStatement = data;
  }
}

void main() {
  final statement = VatReturnStatement(
    periodStart: DateTime(2026),
    periodEnd: DateTime(2026, 3, 31),
    standardSalesBase: Decimal.parse('150000'),
    standardSalesTax: Decimal.parse('22500'),
    zeroRatedSales: Decimal.parse('5000'),
    exemptSales: Decimal.zero,
    standardPurchasesBase: Decimal.parse('80000'),
    standardPurchasesTax: Decimal.parse('12000'),
    netVatDue: Decimal.parse('10500'),
  );

  Widget buildApp({
    required Future<VatReturnStatement> Function() calculate,
    required _FakeReportPdfService pdfService,
  }) =>
      ProviderScope(
        overrides: [
          taxEngineServiceProvider.overrideWith(
            () => _FakeTaxEngineService(calculate),
          ),
          reportPdfServiceProvider.overrideWith(() => pdfService),
        ],
        child: const MaterialApp(home: SmartTaxReportScreen()),
      );

  group('SmartTaxReportScreen', () {
    testWidgets('يعرض مؤشر التحميل حتى يتوفر بيان VAT', (tester) async {
      final completer = Completer<VatReturnStatement>();
      await tester.pumpWidget(
        buildApp(
          calculate: () => completer.future,
          pdfService: _FakeReportPdfService(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      completer.complete(statement);
      await tester.pumpAndSettle();
      expect(find.text('صافي الضريبة المستحقة'), findsOneWidget);
    });

    testWidgets('يعرض بيان VAT ومكونات المبيعات والمشتريات ويصدره',
        (tester) async {
      final pdfService = _FakeReportPdfService();
      await tester.pumpWidget(
        buildApp(calculate: () async => statement, pdfService: pdfService),
      );
      await tester.pumpAndSettle();

      expect(find.text('الفترة الضريبية'), findsOneWidget);
      expect(find.text('10500.00 SAR'), findsOneWidget);
      expect(find.text('المبيعات (Output Tax)'), findsOneWidget);
      expect(find.text('المشتريات (Input Tax)'), findsOneWidget);
      expect(find.text('150000.00'), findsOneWidget);
      expect(find.text('12000.00'), findsOneWidget);

      final export = find.text('تصدير التقرير (PDF Export)');
      await tester.ensureVisible(export);
      await tester.tap(export);
      await tester.pump();
      expect(pdfService.sharedStatement, same(statement));
    });

    testWidgets('يعرض رسالة خطأ عند تعذر احتساب الإقرار', (tester) async {
      await tester.pumpWidget(
        buildApp(
          calculate: () => Future.error(Exception('tax engine offline')),
          pdfService: _FakeReportPdfService(),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Error: Exception: tax engine offline'),
        findsOneWidget,
      );
    });

    testWidgets('يعرض رسالة تعافٍ عند فشل تصدير PDF', (tester) async {
      await tester.pumpWidget(
        buildApp(
          calculate: () async => statement,
          pdfService: _FakeReportPdfService(
            failure: Exception('printing unavailable'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final export = find.text('تصدير التقرير (PDF Export)');
      await tester.ensureVisible(export);
      await tester.tap(export);
      await tester.pumpAndSettle();
      expect(find.textContaining('Error exporting PDF:'), findsOneWidget);
    });
  });
}
