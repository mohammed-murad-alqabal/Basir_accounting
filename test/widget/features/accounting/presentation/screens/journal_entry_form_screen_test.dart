/// اختبارات السلوك المرئي لنموذج القيد اليدوي.
library;

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/journal_entry_form_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAccountingRepository extends Mock implements AccountingRepository {}

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

  late _MockAccountingRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = _MockAccountingRepository();
    when(() => repository.getJournalEntries()).thenAnswer((_) async => []);
    when(() => repository.getAccounts()).thenAnswer(
      (_) async => [
        _leafAccount(id: 'cash', code: '1100', nameAr: 'النقدية'),
        _leafAccount(id: 'sales', code: '4100', nameAr: 'المبيعات'),
      ],
    );
    container = ProviderContainer(
      overrides: [
        accountingRepositoryProvider.overrideWithValue(repository),
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
}
