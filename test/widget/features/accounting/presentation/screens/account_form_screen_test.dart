/// اختبارات سلوكية لنموذج إنشاء وتعديل الحسابات.
library;

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/account_form_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/app_enhanced_button.dart';
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
  bool isParent = false,
  String? parentId,
}) =>
    Account(
      id: id,
      code: code,
      nameAr: nameAr,
      nameEn: nameAr,
      type: AccountType.asset,
      nature: AccountNature.debit,
      balance: Decimal.zero,
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
          home: AccountFormScreen(),
        ),
      );

  testWidgets('يعرض نموذج الحساب وخيارات الأب المتاحة من دليل الحسابات', (
    tester,
  ) async {
    final parent = _account(
      id: 'assets',
      code: '1000',
      nameAr: 'الأصول',
      isParent: true,
    );
    when(() => repository.getAccounts()).thenAnswer((_) async => [parent]);

    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    expect(find.byType(AccountFormScreen), findsOneWidget);
    expect(find.text('إضافة حساب جديد'), findsOneWidget);
    expect(find.text('الاسم (بالعربية)'), findsOneWidget);
    expect(find.text('Name (English)'), findsOneWidget);
    expect(find.text('رمز الحساب (Code)'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is DropdownButtonFormField<String?> &&
            widget.decoration.labelText == 'الحساب الأب',
      ),
      findsOneWidget,
    );
  });

  testWidgets(
    'يقترح رمزاً تابعاً عند اختيار حساب أب ويحتفظ بالحقل قابلاً للتحرير',
    (tester) async {
      final parent = _account(
        id: 'assets',
        code: '1000',
        nameAr: 'الأصول',
        isParent: true,
      );
      when(() => repository.getAccounts()).thenAnswer((_) async => [parent]);

      await tester.pumpWidget(testApp());
      await tester.pumpAndSettle();

      final parentSelector = find.byWidgetPredicate(
        (widget) =>
            widget is DropdownButtonFormField<String?> &&
            widget.decoration.labelText == 'الحساب الأب',
      );
      await tester.tap(parentSelector);
      await tester.pumpAndSettle();
      await tester.tap(find.text('1000 - الأصول').last);
      await tester.pumpAndSettle();

      final codeField = tester.widget<TextFormField>(
        find.byType(TextFormField).at(2),
      );
      expect(codeField.controller!.text, '100001');

      await tester.enterText(find.byType(TextFormField).at(2), '100099');
      expect(
        tester
            .widget<TextFormField>(find.byType(TextFormField).at(2))
            .controller!
            .text,
        '100099',
      );
    },
  );

  testWidgets('يعرض أخطاء التحقق قبل إنشاء حساب ناقص البيانات الإلزامية', (
    tester,
  ) async {
    when(() => repository.getAccounts()).thenAnswer((_) async => []);

    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    final submit = find.descendant(
      of: find.byType(AppEnhancedButton),
      matching: find.byType(InkWell),
    );
    final formScrollable = find
        .descendant(
          of: find.byType(SingleChildScrollView),
          matching: find.byType(Scrollable),
        )
        .first;
    await tester.scrollUntilVisible(
      submit,
      120,
      scrollable: formScrollable,
    );
    await tester.tap(submit);
    await tester.pumpAndSettle();

    expect(find.text('يرجى إدخال الاسم بالعربية'), findsOneWidget);
    expect(find.text('Please enter name in English'), findsOneWidget);
    expect(find.text('يرجى إدخال رمز الحساب'), findsOneWidget);
  });
}
