import 'dart:async';

import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/presentation/providers/journal_entry_providers.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/entity_transactions_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final customerEntry = _entry(
    id: 'customer-entry',
    description: 'فاتورة مبيعات للعميل',
    entityAccountId: 'acc-1201',
    entityAccountName: 'ذمم العميل-1',
    debit: Decimal.parse('250'),
    credit: Decimal.zero,
  );
  final supplierEntry = _entry(
    id: 'supplier-entry',
    description: 'فاتورة شراء للمورد',
    entityAccountId: 'acc-2101',
    entityAccountName: 'ذمم المورد-1',
    debit: Decimal.zero,
    credit: Decimal.parse('175'),
  );

  Widget subject({
    required String entityId,
    required String entityName,
    required bool isCustomer,
    required Future<List<JournalEntry>> Function() loadEntries,
    Key? scopeKey,
    ValueChanged<JournalEntry>? onDetails,
  }) =>
      ProviderScope(
        key: scopeKey,
        overrides: [
          subLedgerJournalEntriesProvider(
            entityId: entityId,
            isCustomer: isCustomer,
          ).overrideWith((ref) => loadEntries()),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ar'),
          onGenerateRoute: (settings) {
            if (settings.name == '/journal-entry-detail') {
              onDetails?.call(settings.arguments! as JournalEntry);
              return MaterialPageRoute<void>(
                builder: (_) => const Scaffold(body: Text('تفاصيل القيد')),
              );
            }
            return null;
          },
          home: EntityTransactionsScreen(
            entityId: entityId,
            entityName: entityName,
            isCustomer: isCustomer,
          ),
        ),
      );

  setUpAll(() {
    // التحقق في شاشة هاتف عمودية يعطي مساحة كافية للرأس وأول معاملة.
  });

  group('EntityTransactionsScreen', () {
    testWidgets('يعرض حالة التحميل والسجل الفارغ والخطأ بوضوح', (tester) async {
      final pendingEntries = Completer<List<JournalEntry>>();
      await tester.pumpWidget(
        subject(
          entityId: 'customer-1',
          entityName: 'شركة البصير',
          isCustomer: true,
          loadEntries: () => pendingEntries.future,
          scopeKey: const ValueKey('loading'),
        ),
      );
      await tester.pump();
      expect(find.byType(AppLoadingIndicator), findsOneWidget);

      await tester.pumpWidget(
        subject(
          entityId: 'customer-1',
          entityName: 'شركة البصير',
          isCustomer: true,
          loadEntries: () async => const [],
          scopeKey: const ValueKey('empty'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AppEmptyState), findsOneWidget);
      expect(find.byIcon(Icons.receipt_long), findsOneWidget);

      await tester.pumpWidget(
        subject(
          entityId: 'customer-1',
          entityName: 'شركة البصير',
          isCustomer: true,
          loadEntries: () => Future<List<JournalEntry>>.error(
            StateError('ledger offline'),
          ),
          scopeKey: const ValueKey('error'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AppErrorWidget), findsOneWidget);
      expect(find.textContaining('ledger offline'), findsOneWidget);
    });

    testWidgets('يعرض أثر العميل المدين وينتقل إلى تفاصيل القيد',
        (tester) async {
      JournalEntry? openedEntry;
      await tester.pumpWidget(
        subject(
          entityId: 'customer-1',
          entityName: 'شركة البصير',
          isCustomer: true,
          loadEntries: () async => [customerEntry],
          onDetails: (entry) => openedEntry = entry,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('العميل'), findsOneWidget);
      expect(find.text('شركة البصير'), findsNWidgets(2));
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.text('فاتورة مبيعات للعميل'), findsOneWidget);
      expect(find.text('250.00'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(find.text('فاتورة مبيعات للعميل'));
      await tester.pumpAndSettle();

      expect(openedEntry, same(customerEntry));
      expect(find.text('تفاصيل القيد'), findsOneWidget);
    });

    testWidgets('يعرض أثر المورد الدائن كزيادة موجبة في ذمم الموردين',
        (tester) async {
      await tester.pumpWidget(
        subject(
          entityId: 'supplier-1',
          entityName: 'مورد البصير',
          isCustomer: false,
          loadEntries: () async => [supplierEntry],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('الموردون'), findsOneWidget);
      expect(find.byIcon(Icons.business_outlined), findsOneWidget);
      expect(find.text('فاتورة شراء للمورد'), findsOneWidget);
      expect(find.text('175.00'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });
}

JournalEntry _entry({
  required String id,
  required String description,
  required String entityAccountId,
  required String entityAccountName,
  required Decimal debit,
  required Decimal credit,
}) {
  final now = DateTime(2026, 8, 15);
  return JournalEntry(
    id: id,
    referenceNumber: 'JE-$id',
    date: now,
    temporal: TemporalJustification(
      transactionDate: now,
      effectiveDate: now,
      recordingDate: now,
    ),
    standards: const StandardsJustification(standardReference: 'IFRS'),
    description: description,
    status: JournalEntryStatus.posted,
    lines: [
      JournalEntryLine(
        accountId: entityAccountId,
        accountName: entityAccountName,
        debit: debit,
        credit: credit,
      ),
      JournalEntryLine(
        accountId: 'counterpart-account',
        accountName: 'الحساب المقابل',
        debit: credit,
        credit: debit,
      ),
    ],
    sourceDocument: 'test',
    sourceId: id,
    createdBy: 'test',
    createdAt: now,
    updatedAt: now,
  );
}
