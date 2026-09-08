import 'dart:async';

import 'package:basir_accounting_system/core/theme/app_theme.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/reports/presentation/screens/audit_trail_report_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildSubject(_AuditAccountingService service) => ProviderScope(
        overrides: [
          accountingServiceProvider.overrideWith(() => service),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ar'),
          home: const AuditTrailReportScreen(),
        ),
      );

  group('AuditTrailReportScreen', () {
    testWidgets('يعرض حالة التحميل قبل وصول القيود', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          _AuditAccountingService(
            entries: [_entryWithAudit],
            delay: const Duration(milliseconds: 50),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 60));
      expect(find.text('JE-AUDIT-001'), findsOneWidget);
    });

    testWidgets('يعرض خطأ الخدمة بدلاً من قائمة غير صالحة', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          _AuditAccountingService(error: StateError('تعطل المستودع')),
        ),
      );
      await tester.pump();

      expect(
        find.textContaining('Error: Bad state: تعطل المستودع'),
        findsOneWidget,
      );
    });

    testWidgets('يعرض الحالة الفارغة عندما لا يوجد أي سجل تدقيق',
        (tester) async {
      await tester.pumpWidget(
        buildSubject(_AuditAccountingService(entries: [_entryWithoutAudit])),
      );
      await tester.pump();

      expect(find.byIcon(Icons.assignment_turned_in_outlined), findsOneWidget);
      expect(find.text('JE-NO-AUDIT'), findsNothing);
    });

    testWidgets('يعرض القيد وسجل الحدث والفاعل ومبرر القرار الجنائي',
        (tester) async {
      await tester.pumpWidget(
        buildSubject(_AuditAccountingService(entries: [_entryWithAudit])),
      );
      await tester.pump();

      expect(find.text('JE-AUDIT-001'), findsOneWidget);
      expect(find.text('قيد تم تعليقه للمراجعة'), findsOneWidget);
      expect(find.text('tamper_blocked'), findsOneWidget);
      expect(find.text('تم رصد تغير في بصمة القيد'), findsOneWidget);
      expect(find.text('Actor: forensic-agent'), findsOneWidget);
    });
  });
}

class _AuditAccountingService extends AccountingService {
  _AuditAccountingService({this.entries = const [], this.delay, this.error});

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

final _entryWithAudit = _entry(
  id: 'audit-entry',
  reference: 'JE-AUDIT-001',
  description: 'قيد تم تعليقه للمراجعة',
  auditLogs: [
    AuditLogEntry(
      timestamp: DateTime.utc(2026, 6, 15, 9, 45, 10),
      action: 'tamper_blocked',
      rationale: 'تم رصد تغير في بصمة القيد',
      actor: 'forensic-agent',
    ),
  ],
);

final _entryWithoutAudit = _entry(
  id: 'no-audit-entry',
  reference: 'JE-NO-AUDIT',
  description: 'قيد عادي',
);

JournalEntry _entry({
  required String id,
  required String reference,
  required String description,
  List<AuditLogEntry> auditLogs = const [],
}) {
  final timestamp = DateTime.utc(2026, 6, 15, 9, 30);
  return JournalEntry(
    id: id,
    referenceNumber: reference,
    date: timestamp,
    temporal: TemporalJustification(
      transactionDate: timestamp,
      effectiveDate: timestamp,
      recordingDate: timestamp,
    ),
    standards: const StandardsJustification(standardReference: 'IFRS 15.35'),
    description: description,
    status: JournalEntryStatus.posted,
    lines: [
      JournalEntryLine(
        accountId: 'cash',
        accountName: 'النقدية',
        debit: Decimal.fromInt(100),
        credit: Decimal.zero,
      ),
      JournalEntryLine(
        accountId: 'sales',
        accountName: 'المبيعات',
        debit: Decimal.zero,
        credit: Decimal.fromInt(100),
      ),
    ],
    sourceDocument: 'manual',
    sourceId: id,
    createdBy: 'tester',
    createdAt: timestamp,
    updatedAt: timestamp,
    auditLogs: auditLogs,
  );
}
