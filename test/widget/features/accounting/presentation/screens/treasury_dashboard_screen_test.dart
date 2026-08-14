/// اختبارات سلوكية للوحة الخزينة.
library;

import 'dart:async';

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/treasury_dashboard_screen.dart';
import 'package:basir_accounting_system/features/invoices/domain/repositories/invoice_repository.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAccountingRepository extends Mock implements AccountingRepository {}

class _MockInvoiceRepository extends Mock implements InvoiceRepository {}

Account _account({
  required String id,
  required String code,
  required String nameAr,
  required String nameEn,
  required String? subType,
  required Decimal balance,
}) =>
    Account(
      id: id,
      code: code,
      nameAr: nameAr,
      nameEn: nameEn,
      type: AccountType.asset,
      nature: AccountNature.debit,
      balance: balance,
      subType: subType,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockAccountingRepository accountingRepository;
  late _MockInvoiceRepository invoiceRepository;

  setUp(() {
    accountingRepository = _MockAccountingRepository();
    invoiceRepository = _MockInvoiceRepository();
    when(() => invoiceRepository.getAllInvoices()).thenAnswer((_) async => []);
  });

  Widget testApp() => ProviderScope(
        overrides: [
          accountingRepositoryProvider.overrideWithValue(accountingRepository),
          invoiceRepositoryProvider.overrideWithValue(invoiceRepository),
          appIconsProvider.overrideWithValue(const MaterialAppIcons()),
        ],
        child: const MaterialApp(
          locale: Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: TreasuryDashboardScreen(),
        ),
      );

  testWidgets('يعرض مؤشر التحميل بينما تجهز خدمة المحاسبة بيانات الخزينة', (
    tester,
  ) async {
    final entries = Completer<List<JournalEntry>>();
    when(() => accountingRepository.getJournalEntries())
        .thenAnswer((_) => entries.future);

    await tester.pumpWidget(testApp());
    await tester.pump();

    expect(find.byType(AppLoadingIndicator), findsOneWidget);
    entries.complete([]);
  });

  testWidgets('يعرض حالة الخطأ ويتيح إعادة المحاولة إذا أخفق دفتر القيود', (
    tester,
  ) async {
    when(() => accountingRepository.getJournalEntries()).thenAnswer(
      (_) async => throw StateError('ledger unavailable'),
    );

    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    expect(find.byType(AppErrorWidget), findsOneWidget);
    expect(find.textContaining('ledger unavailable'), findsOneWidget);
  });

  testWidgets('يعرض النقد والبنك فقط ويستبعد الحسابات التشغيلية من السيولة', (
    tester,
  ) async {
    when(() => accountingRepository.getJournalEntries()).thenAnswer((_) async => []);
    when(() => accountingRepository.getAccounts()).thenAnswer(
      (_) async => [
        _account(
          id: 'cash',
          code: '110100',
          nameAr: 'الصندوق الرئيسي',
          nameEn: 'Main Cash',
          subType: 'cash',
          balance: Decimal(750),
        ),
        _account(
          id: 'bank',
          code: '110200',
          nameAr: 'الحساب البنكي',
          nameEn: 'Operating Bank',
          subType: 'bank',
          balance: Decimal(1250),
        ),
        _account(
          id: 'expense',
          code: '510100',
          nameAr: 'مصروفات تشغيلية',
          nameEn: 'Operating Expense',
          subType: 'expense',
          balance: Decimal(999),
        ),
      ],
    );

    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    expect(find.byType(TreasuryDashboardScreen), findsOneWidget);
    expect(find.text('الصندوق الرئيسي'), findsOneWidget);
    expect(find.text('الحساب البنكي'), findsOneWidget);
    expect(find.text('مصروفات تشغيلية'), findsNothing);
    expect(find.byIcon(Icons.attach_money_outlined), findsOneWidget);
    expect(find.byIcon(Icons.account_balance_outlined), findsOneWidget);
    expect(find.byType(AppEnhancedButton), findsNWidgets(5));
  });
}
