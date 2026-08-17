/// اختبارات السلوك المرئي لشاشة دليل الحسابات.
library;

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/chart_of_accounts_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAccountingRepository extends Mock implements AccountingRepository {}

Account _account({
  required String id,
  required String code,
  required String nameAr,
  required String nameEn,
  required Decimal balance,
  bool isParent = false,
  String? parentId,
}) =>
    Account(
      id: id,
      code: code,
      nameAr: nameAr,
      nameEn: nameEn,
      type: AccountType.asset,
      nature: AccountNature.debit,
      balance: balance,
      isParent: isParent,
      parentId: parentId,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockAccountingRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = _MockAccountingRepository();
    container = ProviderContainer(
      overrides: [
        accountingRepositoryProvider.overrideWithValue(repository),
        appIconsProvider.overrideWithValue(const MaterialAppIcons()),
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
          home: ChartOfAccountsScreen(),
        ),
      );

  testWidgets('يعرض الشجرة ويكشف الحساب الابن عند توسيع الجذر', (tester) async {
    final parent = _account(
      id: 'assets',
      code: '1000',
      nameAr: 'الأصول',
      nameEn: 'Assets',
      balance: Decimal.parse('100'),
      isParent: true,
    );
    final child = _account(
      id: 'cash',
      code: '1100',
      nameAr: 'النقدية',
      nameEn: 'Cash',
      balance: Decimal.parse('25'),
      parentId: parent.id,
    );
    when(() => repository.getAccounts())
        .thenAnswer((_) async => [child, parent]);

    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    expect(find.text('1000 - الأصول'), findsOneWidget);
    expect(find.text('1100 - النقدية'), findsNothing);

    await tester.tap(find.text('1000 - الأصول'));
    await tester.pumpAndSettle();
    expect(find.text('1100 - النقدية'), findsOneWidget);
    expect(container.read(expandedAccountsProvider), contains(parent.id));
  });

  testWidgets('يعرض حالة الفراغ عند غياب الحسابات', (tester) async {
    when(() => repository.getAccounts()).thenAnswer((_) async => []);

    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.account_balance_wallet_outlined), findsOneWidget);
  });

  testWidgets('يعرض حالة الخطأ عند فشل جلب دليل الحسابات', (tester) async {
    when(
      () => repository.getAccounts(),
    ).thenAnswer((_) => Future.error(StateError('accounts unavailable')));

    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.error_outline), findsOneWidget);
  });
}
