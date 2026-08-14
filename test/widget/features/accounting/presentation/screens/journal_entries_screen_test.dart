/// اختبارات سلوكية لقائمة قيود اليومية.
library;

import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/presentation/providers/journal_entry_providers.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/journal_entries_screen.dart';
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
        debit: Decimal(250),
        credit: Decimal.zero,
      ),
      JournalEntryLine(
        accountId: 'revenue',
        accountName: 'إيرادات المبيعات',
        debit: Decimal.zero,
        credit: Decimal(250),
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
          filteredJournalEntriesProvider(accountId: null)
              .overrideWith((ref) async => []),
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
          filteredJournalEntriesProvider(accountId: null).overrideWith(
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
          filteredJournalEntriesProvider(accountId: null)
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
}
