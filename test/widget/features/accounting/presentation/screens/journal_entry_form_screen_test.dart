/// اختبارات السلوك المرئي لنموذج القيد اليدوي.
library;

import 'dart:async';

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/journal_entry_form_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/app_enhanced_button.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAccountingService extends AccountingService {
  _FakeAccountingService(this.accounts);

  final List<Account> accounts;
  final List<JournalEntry> postedEntries = [];

  @override
  FutureOr<List<JournalEntry>> build() => const [];

  @override
  Future<List<Account>> getAccounts() async => accounts;

  @override
  Future<void> postJournalEntry(
    JournalEntry entry, {
    bool bypassCognitive = false,
  }) async {
    postedEntries.add(entry);
  }
}

Account _leafAccount({
  required String id,
  required String code,
  required String nameAr,
}) =>
    Account(
      id: id,
      code: code,
      nameAr: nameAr,
      nameEn: nameAr,
      type: AccountType.asset,
      nature: AccountNature.debit,
      balance: Decimal.zero,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeAccountingService accountingService;
  late ProviderContainer container;

  setUp(() {
    accountingService = _FakeAccountingService(
      [
        _leafAccount(id: 'cash', code: '1100', nameAr: 'النقدية'),
        _leafAccount(id: 'sales', code: '4100', nameAr: 'المبيعات'),
      ],
    );
    container = ProviderContainer(
      overrides: [
        accountingServiceProvider.overrideWith(() => accountingService),
        appIconsProvider.overrideWithValue(const MaterialAppIcons()),
        basirUserProvider.overrideWith((ref) => null),
      ],
    );
  });

  tearDown(() => container.dispose());

  Widget testApp() => UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          locale: Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: JournalEntryFormScreen(),
        ),
      );

  testWidgets('يعرض سطرين ابتدائيين وحالة عدم توازن قبل الإدخال',
      (tester) async {
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    expect(find.byType(DropdownButtonFormField<String>), findsNWidgets(2));
    expect(find.text('غير متزن'), findsOneWidget);
    expect(find.text('مدين'), findsNWidgets(3));
    expect(find.text('دائن'), findsNWidgets(3));
  });

  testWidgets('يضيف سطر قيد جديد عند الضغط على زر الإضافة', (tester) async {
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(IconButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(DropdownButtonFormField<String>), findsNWidgets(3));
  });

  testWidgets('يحدّث ملخص التوازن عند إدخال مدين ودائن متساويين',
      (tester) async {
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    final amountFields = find.byType(TextFormField);
    await tester.enterText(amountFields.at(4), '125');
    await tester.pump();
    expect(find.text('غير متزن'), findsOneWidget);
    expect(find.text('الفرق: 125'), findsOneWidget);

    await tester.enterText(amountFields.at(7), '125');
    await tester.pump();

    expect(find.text('متزن'), findsOneWidget);
    expect(find.text('الفرق: 125'), findsNothing);
  });

  testWidgets('يعرض حقول المبلغ وسعر الصرف بعد اختيار عملة أجنبية',
      (tester) async {
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    final addCurrency = find.text('إضافة عملة').first;
    await tester.ensureVisible(addCurrency);
    await tester.tap(addCurrency);
    await tester.pumpAndSettle();
    await tester.tap(find.text('USD'));
    await tester.pumpAndSettle();

    expect(find.text('المبلغ (USD)'), findsOneWidget);
    expect(find.text('سعر الصرف'), findsOneWidget);
  });

  testWidgets('يعيد حقول السطر إلى الريال عند إلغاء العملة الأجنبية',
      (tester) async {
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    final addCurrency = find.text('إضافة عملة').first;
    await tester.ensureVisible(addCurrency);
    await tester.tap(addCurrency);
    await tester.pumpAndSettle();
    final usd = find.text('USD');
    await tester.ensureVisible(usd);
    await tester.tap(usd);
    await tester.pumpAndSettle();
    expect(find.text('المبلغ (USD)'), findsOneWidget);

    final selectedCurrency = find.text('العملة: USD');
    await tester.ensureVisible(selectedCurrency);
    await tester.tap(selectedCurrency);
    await tester.pumpAndSettle();
    final sar = find.text('SAR');
    await tester.ensureVisible(sar);
    await tester.tap(sar);
    await tester.pumpAndSettle();

    expect(find.text('المبلغ (USD)'), findsNothing);
    expect(find.text('سعر الصرف'), findsNothing);
    expect(find.text('إضافة عملة').first, findsOneWidget);
  });

  testWidgets('يرفض حفظ قيد غير متزن بعد اختيار حسابات الدليل', (tester) async {
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).first,
      'قيد اختبار غير متزن',
    );
    final accountSelectors = find.byType(DropdownButtonFormField<String>);
    final debitAccountSelector = accountSelectors.at(0);
    await tester.ensureVisible(debitAccountSelector);
    await tester.tap(debitAccountSelector);
    await tester.pumpAndSettle();
    final cashAccount = find.text('1100 - النقدية').last;
    await tester.ensureVisible(cashAccount);
    await tester.tap(cashAccount);
    await tester.pumpAndSettle();

    final creditAccountSelector = accountSelectors.at(1);
    await tester.ensureVisible(creditAccountSelector);
    await tester.tap(creditAccountSelector);
    await tester.pumpAndSettle();
    final salesAccount = find.text('4100 - المبيعات').last;
    await tester.ensureVisible(salesAccount);
    await tester.tap(salesAccount);
    await tester.pumpAndSettle();

    final amountFields = find.byType(TextFormField);
    await tester.enterText(amountFields.at(4), '125');
    await tester.enterText(amountFields.at(7), '100');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    final saveButton = find.byWidgetPredicate(
      (widget) => widget is AppEnhancedButton && widget.label == 'حفظ كمسودة',
    );
    final saveAction = find.descendant(
      of: saveButton,
      matching: find.byType(InkWell),
    );
    final formScrollView = find
        .descendant(
          of: find.byType(Form),
          matching: find.byType(Scrollable),
        )
        .first;
    await tester.scrollUntilVisible(
      saveAction,
      120,
      scrollable: formScrollView,
    );
    await tester.pumpAndSettle();
    expect(saveAction, findsOneWidget);
    await tester.tap(saveAction);
    await tester.pumpAndSettle();

    expect(
      find.text('القيد غير متزن! يجب أن يتساوى المدين والدائن'),
      findsOneWidget,
    );
  });

  testWidgets('يحفظ مسودة متزنة بقيد ذي طرفين متساويين', (tester) async {
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).first,
      'قيد مسودة متزن',
    );
    final accountSelectors = find.byType(DropdownButtonFormField<String>);
    final formScrollView = find
        .descendant(
          of: find.byType(Form),
          matching: find.byType(Scrollable),
        )
        .first;
    await tester.tap(accountSelectors.at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('1100 - النقدية').last);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      accountSelectors.at(1),
      120,
      scrollable: formScrollView,
    );
    await tester.tap(accountSelectors.at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('4100 - المبيعات').last);
    await tester.pumpAndSettle();

    final amountFields = find.byType(TextFormField);
    await tester.enterText(amountFields.at(4), '125');
    await tester.enterText(amountFields.at(7), '125');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text('متزن'), findsOneWidget);

    final saveButton = find.byWidgetPredicate(
      (widget) => widget is AppEnhancedButton && widget.label == 'حفظ كمسودة',
    );
    final saveAction = find.descendant(
      of: saveButton,
      matching: find.byType(InkWell),
    );
    await tester.scrollUntilVisible(
      saveAction,
      120,
      scrollable: formScrollView,
    );
    await tester.pumpAndSettle();
    await tester.tap(saveAction);
    await tester.pump();

    expect(accountingService.postedEntries, hasLength(1));
    final entry = accountingService.postedEntries.single;
    expect(entry.status, JournalEntryStatus.draft);
    expect(entry.description, 'قيد مسودة متزن');
    expect(entry.isBalanced, isTrue);
    expect(entry.lines.map((line) => line.accountId), ['cash', 'sales']);
  });
}
