/// اختبارات سلوكية لقائمة قيود اليومية.
library;

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/presentation/providers/journal_entry_providers.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/journal_entries_screen.dart';
import 'package:basir_accounting_system/features/invoices/data/services/sharing_service.dart';
import 'package:basir_accounting_system/features/reports/application/report_export_service.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

JournalEntry _entry({
  required String id,
  required String reference,
  required JournalEntryStatus status,
}) {
  final timestamp = DateTime.utc(2026, 1, 15);
  return JournalEntry(
    id: id,
    referenceNumber: reference,
    date: timestamp,
    temporal: TemporalJustification(
      transactionDate: timestamp,
      effectiveDate: timestamp,
      recordingDate: timestamp,
    ),
    standards: const StandardsJustification(
      standardReference: 'IFRS 15',
      recognitionBasis: 'Accrual',
      measurementBasis: 'Transaction price',
    ),
    description: 'قيد مبيعات شهري',
    status: status,
    lines: [
      JournalEntryLine(
        accountId: 'cash',
        accountName: 'النقدية',
        description: 'استلام نقدي',
        debit: Decimal.fromInt(250),
        credit: Decimal.zero,
      ),
      JournalEntryLine(
        accountId: 'revenue',
        accountName: 'إيرادات المبيعات',
        debit: Decimal.zero,
        credit: Decimal.fromInt(250),
      ),
    ],
    sourceDocument: 'sales_invoice',
    sourceId: 'INV-15',
    createdBy: 'tester',
    createdAt: timestamp,
    updatedAt: timestamp,
    postedAt: status == JournalEntryStatus.posted ? timestamp : null,
  );
}

class _AccountingServiceFake extends AccountingService {
  static List<JournalEntry> entries = [];
  static JournalEntry? postedEntry;

  @override
  Future<List<JournalEntry>> build() async => entries;

  @override
  Future<void> postJournalEntry(
    JournalEntry entry, {
    bool bypassCognitive = false,
  }) async {
    postedEntry = entry;
  }

  @override
  Future<void> reverseJournalEntry(String entryId) async {}
}

class _ReportExportServiceFake extends ReportExportService {
  static String? pdfFilename;
  static String? pdfTitle;
  static List<String>? headers;
  static List<List<String>>? rows;

  @override
  Future<void> shareTablePdf({
    required String title,
    required List<String> headers,
    required List<List<String>> data,
    String? subtitle,
    String filename = 'report.pdf',
  }) async {
    pdfFilename = filename;
    pdfTitle = title;
    _ReportExportServiceFake.headers = headers;
    rows = data;
  }

  @override
  String generateTableCsv({
    required List<String> headers,
    required List<List<String>> data,
  }) {
    _ReportExportServiceFake.headers = headers;
    rows = data;
    return 'date,reference,description,status,total';
  }
}

class _SharingServiceFake extends SharingService {
  List<int>? sharedBytes;
  String? sharedFileName;

  @override
  Future<void> shareFile({
    required List<int> bytes,
    required String fileName,
    String? subject,
    String? text,
  }) async {
    sharedBytes = bytes;
    sharedFileName = fileName;
  }
}

Widget _testApp({required List<Override> overrides}) => ProviderScope(
      overrides: [
        appIconsProvider.overrideWithValue(const MaterialAppIcons()),
        ...overrides,
      ],
      child: const MaterialApp(
        locale: Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: JournalEntriesScreen(),
      ),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('يعرض حالة الفراغ عند غياب قيود اليومية', (tester) async {
    await tester.pumpWidget(
      _testApp(
        overrides: [
          filteredJournalEntriesProvider().overrideWith((ref) async => []),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(JournalEntriesScreen), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.share), findsOneWidget);
    expect(find.byType(ExpansionTile), findsNothing);
  });

  testWidgets('يعرض رسالة الخطأ مع إعادة المحاولة عند فشل تحميل القيود', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        overrides: [
          filteredJournalEntriesProvider().overrideWith(
            (ref) => Future<List<JournalEntry>>.error(
              StateError('ledger unavailable'),
            ),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.textContaining('ledger unavailable'), findsOneWidget);
  });

  testWidgets('يوسع القيد المتوازن ويعرض سطوره وإجماليه وحالة المسودة', (
    tester,
  ) async {
    final draft = _entry(
      id: 'draft-1',
      reference: 'JE-2026-001',
      status: JournalEntryStatus.draft,
    );
    final posted = _entry(
      id: 'posted-1',
      reference: 'JE-2026-002',
      status: JournalEntryStatus.posted,
    );

    await tester.pumpWidget(
      _testApp(
        overrides: [
          filteredJournalEntriesProvider()
              .overrideWith((ref) async => [draft, posted]),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('JE-2026-001'), findsOneWidget);
    expect(find.text('JE-2026-002'), findsOneWidget);
    expect(find.text('قيد مبيعات شهري'), findsNWidgets(2));
    expect(find.byType(PopupMenuButton<String>), findsNWidgets(2));

    await tester.tap(find.text('JE-2026-001'));
    await tester.pumpAndSettle();

    expect(find.text('النقدية'), findsOneWidget);
    expect(find.text('استلام نقدي'), findsOneWidget);
    expect(find.text('إيرادات المبيعات'), findsOneWidget);
    expect(find.textContaining('250.00'), findsWidgets);
  });

  testWidgets('يرحّل مسودة القيد من قائمة الإجراءات ويعرض نجاح العملية', (
    tester,
  ) async {
    final draft = _entry(
      id: 'draft-post',
      reference: 'JE-2026-POST',
      status: JournalEntryStatus.draft,
    );
    _AccountingServiceFake.entries = [draft];
    _AccountingServiceFake.postedEntry = null;

    await tester.pumpWidget(
      _testApp(
        overrides: [
          filteredJournalEntriesProvider().overrideWith((ref) async => [draft]),
          accountingServiceProvider.overrideWith(_AccountingServiceFake.new),
        ],
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ترحيل الآن'));
    await tester.pumpAndSettle();

    expect(_AccountingServiceFake.postedEntry, isNotNull);
    expect(_AccountingServiceFake.postedEntry!.id, draft.id);
    expect(
      _AccountingServiceFake.postedEntry!.status,
      JournalEntryStatus.posted,
    );
    expect(find.text('تم ترحيل القيد بنجاح'), findsOneWidget);
  });

  testWidgets('يصدر جدول القيود PDF عبر خدمة التصدير المعزولة', (
    tester,
  ) async {
    final posted = _entry(
      id: 'posted-export',
      reference: 'JE-2026-PDF',
      status: JournalEntryStatus.posted,
    );
    _AccountingServiceFake.entries = [posted];
    _ReportExportServiceFake.pdfFilename = null;
    _ReportExportServiceFake.pdfTitle = null;
    _ReportExportServiceFake.headers = null;
    _ReportExportServiceFake.rows = null;

    await tester.pumpWidget(
      _testApp(
        overrides: [
          filteredJournalEntriesProvider().overrideWith(
            (ref) async => [posted],
          ),
          accountingServiceProvider.overrideWith(_AccountingServiceFake.new),
          reportExportServiceProvider
              .overrideWith(_ReportExportServiceFake.new),
        ],
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.share));
    await tester.pumpAndSettle();
    await tester.tap(find.text('تصدير PDF'));
    await tester.pumpAndSettle();

    expect(_ReportExportServiceFake.pdfFilename, 'journal_entries.pdf');
    expect(_ReportExportServiceFake.pdfTitle, 'القيود اليومية');
    expect(_ReportExportServiceFake.headers, hasLength(5));
    expect(_ReportExportServiceFake.rows, hasLength(1));
    expect(_ReportExportServiceFake.rows!.single[1], 'JE-2026-PDF');
    expect(_ReportExportServiceFake.rows!.single[3], 'مرحل');
  });

  testWidgets('يحوّل جدول القيود إلى CSV ثم يمرره لخدمة المشاركة المعزولة', (
    tester,
  ) async {
    final draft = _entry(
      id: 'draft-export',
      reference: 'JE-2026-CSV',
      status: JournalEntryStatus.draft,
    );
    final sharingService = _SharingServiceFake();
    _AccountingServiceFake.entries = [draft];
    _ReportExportServiceFake.headers = null;
    _ReportExportServiceFake.rows = null;

    await tester.pumpWidget(
      _testApp(
        overrides: [
          filteredJournalEntriesProvider().overrideWith((ref) async => [draft]),
          accountingServiceProvider.overrideWith(_AccountingServiceFake.new),
          reportExportServiceProvider
              .overrideWith(_ReportExportServiceFake.new),
          sharingServiceProvider.overrideWithValue(sharingService),
        ],
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.share));
    await tester.pumpAndSettle();
    await tester.tap(find.text('تصدير CSV (Excel)'));
    await tester.pumpAndSettle();

    expect(sharingService.sharedFileName, 'journal_entries.csv');
    expect(
      String.fromCharCodes(sharingService.sharedBytes!),
      'date,reference,description,status,total',
    );
    expect(_ReportExportServiceFake.rows!.single[1], 'JE-2026-CSV');
    expect(_ReportExportServiceFake.rows!.single[3], 'مسودة');
  });
}
