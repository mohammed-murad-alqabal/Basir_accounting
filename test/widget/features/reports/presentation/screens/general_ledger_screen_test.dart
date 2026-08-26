import 'dart:async';

import 'package:basir_accounting_system/core/theme/app_theme.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/reports/presentation/screens/general_ledger_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildSubject(_LedgerAccountingService service) => ProviderScope(
        overrides: [
          accountingServiceProvider.overrideWith(() => service),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ar'),
          onGenerateRoute: (settings) => MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('تفاصيل القيد')),
          ),
          home: GeneralLedgerScreen(
            accountId: 'cash',
            accountName: 'النقدية',
            fromDate: DateTime.utc(2026),
            toDate: DateTime.utc(2026, 1, 31, 23, 59),
          ),
        ),
      );

  group('GeneralLedgerScreen', () {
    testWidgets('يعرض التحميل قبل وصول القيود', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          _LedgerAccountingService(
            entries: [_debitEntry],
            delay: const Duration(milliseconds: 40),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets('يعرض واجهة الخطأ عند فشل جلب القيود', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          _LedgerAccountingService(error: StateError('تعذر تحميل القيود')),
        ),
      );
      await tester.pump();
      expect(find.textContaining('تعذر تحميل القيود'), findsOneWidget);
    });

    testWidgets('يعرض الحالة الفارغة عند عدم وجود قيود للحساب والفترة',
        (tester) async {
      await tester.pumpWidget(
        buildSubject(_LedgerAccountingService(entries: [_outOfPeriodEntry])),
      );
      await tester.pump();

      expect(find.byIcon(Icons.receipt_long), findsOneWidget);
      expect(find.text('قيد خارج الفترة'), findsNothing);
    });

    testWidgets('يفلتر ويفرز ويعرض المدين والدائن ثم ينتقل لتفاصيل القيد',
        (tester) async {
      await tester.pumpWidget(
        buildSubject(
          _LedgerAccountingService(
            entries: [
              _creditEntry,
              _outOfPeriodEntry,
              _wrongAccountEntry,
              _debitEntry,
            ],
          ),
        ),
      );
      await tester.pump();

      expect(find.text('قيد مدين حديث'), findsOneWidget);
      expect(find.text('قيد دائن أقدم'), findsOneWidget);
      expect(find.text('قيد خارج الفترة'), findsNothing);
      expect(find.text('قيد لحساب آخر'), findsNothing);
      expect(find.text('200.00'), findsOneWidget);
      expect(find.text('75.00'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('قيد مدين حديث')).dy,
        lessThan(tester.getTopLeft(find.text('قيد دائن أقدم')).dy),
      );

      await tester.tap(find.text('قيد مدين حديث'));
      await tester.pumpAndSettle();
      expect(find.text('تفاصيل القيد'), findsOneWidget);
    });
  });
}

class _LedgerAccountingService extends AccountingService {
  _LedgerAccountingService({this.entries = const [], this.delay, this.error});

  final List<JournalEntry> entries;
  final Duration? delay;
  final Error? error;

  @override
  FutureOr<List<JournalEntry>> build() async {
    if (delay != null) await Future<void>.delayed(delay!);
    if (error != null) throw error!;
    return entries;
  }
}

final _debitEntry = _entry(
  id: 'debit',
  reference: 'JE-LEDGER-2',
  date: DateTime.utc(2026, 1, 20),
  description: 'قيد مدين حديث',
  debit: Decimal.fromInt(200),
  credit: Decimal.zero,
);

final _creditEntry = _entry(
  id: 'credit',
  reference: 'JE-LEDGER-1',
  date: DateTime.utc(2026, 1, 5),
  description: 'قيد دائن أقدم',
  debit: Decimal.zero,
  credit: Decimal.fromInt(75),
);

final _outOfPeriodEntry = _entry(
  id: 'outside',
  reference: 'JE-OUTSIDE',
  date: DateTime.utc(2025, 12, 31),
  description: 'قيد خارج الفترة',
  debit: Decimal.fromInt(10),
  credit: Decimal.zero,
);

final _wrongAccountEntry = _entry(
  id: 'other',
  reference: 'JE-OTHER',
  date: DateTime.utc(2026, 1, 15),
  description: 'قيد لحساب آخر',
  debit: Decimal.fromInt(10),
  credit: Decimal.zero,
  accountId: 'sales',
);

JournalEntry _entry({
  required String id,
  required String reference,
  required DateTime date,
  required String description,
  required Decimal debit,
  required Decimal credit,
  String accountId = 'cash',
}) =>
    JournalEntry(
      id: id,
      referenceNumber: reference,
      date: date,
      temporal: TemporalJustification(
        transactionDate: date,
        effectiveDate: date,
        recordingDate: date,
      ),
      standards: const StandardsJustification(standardReference: 'IFRS 15.35'),
      description: description,
      status: JournalEntryStatus.posted,
      lines: [
        JournalEntryLine(
          accountId: accountId,
          accountName: accountId == 'cash' ? 'النقدية' : 'المبيعات',
          debit: debit,
          credit: credit,
        ),
      ],
      sourceDocument: 'manual',
      sourceId: id,
      createdBy: 'tester',
      createdAt: date,
      updatedAt: date,
    );
