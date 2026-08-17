/// اختبارات سلوكية لشاشة تفاصيل قيد اليومية.
library;

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/journal_entry_detail_screen.dart';
import 'package:basir_accounting_system/features/invoices/domain/repositories/invoice_repository.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockInvoiceRepository extends Mock implements InvoiceRepository {}

final _timestamp = DateTime.utc(2026, 8, 14);

JournalEntry _entry({
  JournalEntryStatus status = JournalEntryStatus.posted,
  String sourceDocument = 'sales_invoice',
  String sourceId = 'INV-2026-01',
}) =>
    JournalEntry(
      id: 'entry-1',
      referenceNumber: 'JE-2026-001',
      date: _timestamp,
      temporal: TemporalJustification(
        transactionDate: _timestamp,
        effectiveDate: _timestamp,
        recordingDate: _timestamp,
      ),
      standards: const StandardsJustification(
        standardReference: 'IAS 1',
        recognitionBasis: 'Accrual',
        measurementBasis: 'Historical cost',
      ),
      description: 'إثبات عملية مبيعات',
      status: status,
      lines: [
        JournalEntryLine(
          accountId: 'cash',
          accountName: 'النقدية',
          description: 'تحصيل فاتورة',
          debit: Decimal.fromInt(875),
          credit: Decimal.zero,
        ),
        JournalEntryLine(
          accountId: 'revenue',
          accountName: 'إيرادات المبيعات',
          description: 'إيراد خاضع للضريبة',
          debit: Decimal.zero,
          credit: Decimal.fromInt(875),
        ),
      ],
      sourceDocument: sourceDocument,
      sourceId: sourceId,
      createdBy: 'tester',
      createdAt: _timestamp,
      updatedAt: _timestamp,
      postedAt: status == JournalEntryStatus.posted ? _timestamp : null,
    );

Widget _testApp({
  required JournalEntry entry,
  List<Override> overrides = const [],
}) =>
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: JournalEntryDetailScreen(entry: entry),
      ),
    );

Future<void> _waitForSourceResult(WidgetTester tester) async {
  final scaffoldMessenger = ScaffoldMessenger.of(
    tester.element(find.byType(JournalEntryDetailScreen)),
  );
  scaffoldMessenger.removeCurrentSnackBar();
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 250));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('يعرض القيد المرحل والسطور المتوازنة وأثر التدقيق', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(entry: _entry()));
    await tester.pumpAndSettle();

    expect(find.text('JE-2026-001'), findsOneWidget);
    expect(find.text('إثبات عملية مبيعات'), findsOneWidget);
    expect(find.text('POSTED'), findsOneWidget);
    expect(find.text('Total Balanced Amount'), findsOneWidget);
    expect(find.text('875.00'), findsOneWidget);
    expect(find.text('النقدية'), findsOneWidget);
    expect(find.text('إيرادات المبيعات'), findsOneWidget);
    expect(find.text('DEBIT'), findsOneWidget);
    expect(find.text('CREDIT'), findsOneWidget);
    expect(find.text('Scientific Audit Trail'), findsOneWidget);
    expect(find.text('IAS 1'), findsOneWidget);
  });

  testWidgets('يبلغ أن تنقل نوع المصدر غير المدعوم لم ينفذ بعد', (
    tester,
  ) async {
    const sourceDocument = 'bank_statement';
    const sourceId = 'BST-09';
    await tester.pumpWidget(
      _testApp(
        entry: _entry(sourceDocument: sourceDocument, sourceId: sourceId),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('$sourceDocument: $sourceId'));
    await tester.pump();
    await _waitForSourceResult(tester);

    expect(
      find.text('Source type $sourceDocument navigation not yet implemented'),
      findsOneWidget,
    );
  });

  testWidgets('يعرض رسالة مصدر غير موجود عندما لا تعثر الفاتورة المرجعية', (
    tester,
  ) async {
    final invoices = _MockInvoiceRepository();
    when(() => invoices.getInvoiceById('INV-missing'))
        .thenAnswer((_) async => null);

    await tester.pumpWidget(
      _testApp(
        entry: _entry(sourceId: 'INV-missing'),
        overrides: [invoiceRepositoryProvider.overrideWithValue(invoices)],
      ),
    );
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(
      tester.element(find.byType(JournalEntryDetailScreen)),
    );

    await tester.tap(find.text('sales_invoice: INV-missing'));
    await tester.pump();
    await _waitForSourceResult(tester);

    verify(() => invoices.getInvoiceById('INV-missing')).called(1);
    expect(find.text(l10n.errSourceNotFound), findsOneWidget);
  });
}
