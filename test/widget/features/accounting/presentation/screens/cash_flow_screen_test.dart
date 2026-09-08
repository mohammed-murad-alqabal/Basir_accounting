import 'dart:async';

import 'package:basir_accounting_system/core/providers.dart'
    hide ReportingService;
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/accounting/application/reporting_service.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/cash_flow_screen.dart';
import 'package:basir_accounting_system/features/invoices/data/services/sharing_service.dart';
import 'package:basir_accounting_system/features/reports/application/report_export_service.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _ReportingServiceFake extends ReportingService {
  static Future<Map<String, Decimal>> Function() loadStatement =
      _completeStatement;

  @override
  void build() {}

  @override
  Future<Map<String, Decimal>> getCashFlowStatement() => loadStatement();
}

Future<Map<String, Decimal>> _completeStatement() async => _cashFlowData();

Map<String, Decimal> _cashFlowData() => {
      'operatingReceipts': Decimal.fromInt(1500),
      'operatingPayments': Decimal.fromInt(450),
      'netOperating': Decimal.fromInt(1050),
      'investing': Decimal.fromInt(-220),
      'financing': Decimal.fromInt(170),
      'netChange': Decimal.fromInt(1000),
    };

class _ReportExportServiceFake extends ReportExportService {
  String? sharedTitle;
  List<String>? headers;
  List<List<String>>? rows;

  @override
  Future<void> shareTablePdf({
    required String title,
    required List<String> headers,
    required List<List<String>> data,
    String? subtitle,
    String filename = 'report.pdf',
  }) async {
    sharedTitle = title;
    this.headers = headers;
    rows = data;
  }

  @override
  String generateTableCsv({
    required List<String> headers,
    required List<List<String>> data,
  }) {
    this.headers = headers;
    rows = data;
    return 'account,total\noperating,1050';
  }
}

class _SharingServiceFake extends SharingService {
  List<int>? sharedBytes;
  String? sharedFileName;
  String? sharedSubject;

  @override
  Future<void> shareFile({
    required List<int> bytes,
    required String fileName,
    String? subject,
    String? text,
  }) async {
    sharedBytes = bytes;
    sharedFileName = fileName;
    sharedSubject = subject;
  }
}

Widget _testApp({
  required _ReportExportServiceFake exportService,
  required _SharingServiceFake sharingService,
}) =>
    ProviderScope(
      overrides: [
        appIconsProvider.overrideWithValue(const MaterialAppIcons()),
        reportingServiceProvider.overrideWith(_ReportingServiceFake.new),
        reportExportServiceProvider.overrideWith(() => exportService),
        sharingServiceProvider.overrideWithValue(sharingService),
      ],
      child: const MaterialApp(
        locale: Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: CashFlowScreen(),
      ),
    );

Future<void> _pumpReport(
  WidgetTester tester, {
  required _ReportExportServiceFake exportService,
  required _SharingServiceFake sharingService,
}) async {
  await tester.pumpWidget(
    _testApp(exportService: exportService, sharingService: sharingService),
  );
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    _ReportingServiceFake.loadStatement = _completeStatement;
  });

  testWidgets('يعرض حالة التحميل ثم أقسام التدفق النقدي وقيمها الفعلية', (
    tester,
  ) async {
    final result = Completer<Map<String, Decimal>>();
    _ReportingServiceFake.loadStatement = () => result.future;
    final exportService = _ReportExportServiceFake();
    final sharingService = _SharingServiceFake();

    await tester.pumpWidget(
      _testApp(exportService: exportService, sharingService: sharingService),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    result.complete(_cashFlowData());
    await tester.pumpAndSettle();

    expect(find.text('Operating Receipts'), findsOneWidget);
    expect(find.text('Operating Payments'), findsOneWidget);
    expect(find.text('1500'), findsOneWidget);
    expect(find.text('-450'), findsOneWidget);
    expect(find.text('-220'), findsOneWidget);
    expect(find.text('1000'), findsOneWidget);
  });

  testWidgets('يعرض حالة خطأ قابلة لإعادة المحاولة عندما تفشل خدمة التقارير', (
    tester,
  ) async {
    _ReportingServiceFake.loadStatement =
        () => Future<Map<String, Decimal>>.error(
              StateError('cash flow unavailable'),
            );
    final exportService = _ReportExportServiceFake();
    final sharingService = _SharingServiceFake();

    await _pumpReport(
      tester,
      exportService: exportService,
      sharingService: sharingService,
    );

    expect(find.textContaining('cash flow unavailable'), findsOneWidget);
  });

  testWidgets('يصدّر التقرير إلى PDF بالصفوف القانونية المحسوبة',
      (tester) async {
    final exportService = _ReportExportServiceFake();
    final sharingService = _SharingServiceFake();

    await _pumpReport(
      tester,
      exportService: exportService,
      sharingService: sharingService,
    );
    await tester.tap(find.byIcon(Icons.share));
    await tester.pumpAndSettle();
    await tester.tap(
      find
          .ancestor(
            of: find.byIcon(Icons.picture_as_pdf),
            matching: find.byType(ListTile),
          )
          .first,
    );
    await tester.pumpAndSettle();

    expect(exportService.sharedTitle, 'قائمة التدفقات النقدية');
    expect(exportService.headers, ['الحساب', 'الإجمالي']);
    expect(exportService.rows, [
      ['العمليات التشغيلية', '1050'],
      ['العمليات الاستثمارية', '-220'],
      ['العمليات التمويلية', '170'],
      ['صافي التدفق النقدي', '1000'],
    ]);
  });

  testWidgets('ينشئ CSV ويشاركه باسم الملف وموضوعه الصحيحين', (tester) async {
    final exportService = _ReportExportServiceFake();
    final sharingService = _SharingServiceFake();

    await _pumpReport(
      tester,
      exportService: exportService,
      sharingService: sharingService,
    );
    await tester.tap(find.byIcon(Icons.share));
    await tester.pumpAndSettle();
    await tester.tap(
      find
          .ancestor(
            of: find.byIcon(Icons.table_chart),
            matching: find.byType(ListTile),
          )
          .first,
    );
    await tester.pumpAndSettle();

    expect(exportService.rows, hasLength(4));
    expect(sharingService.sharedFileName, 'Cash_Flow.csv');
    expect(sharingService.sharedSubject, 'قائمة التدفقات النقدية');
    expect(
      String.fromCharCodes(sharingService.sharedBytes!),
      contains('operating,1050'),
    );
  });
}
