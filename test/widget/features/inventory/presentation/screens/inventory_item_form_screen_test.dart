/// اختبارات سلوكية لنموذج صنف المخزون.
library;

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/inventory_item.dart';
import 'package:basir_accounting_system/features/inventory/presentation/screens/inventory_item_form_screen.dart';
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
  required String name,
  required AccountType type,
}) =>
    Account(
      id: id,
      code: code,
      nameAr: name,
      nameEn: name,
      type: type,
      nature: type == AccountType.revenue
          ? AccountNature.credit
          : AccountNature.debit,
      balance: Decimal.zero,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockAccountingRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = _MockAccountingRepository();
    when(() => repository.getAccounts()).thenAnswer(
      (_) async => [
        _account(
          id: 'inventory',
          code: '1200',
          name: 'أصل المخزون',
          type: AccountType.asset,
        ),
        _account(
          id: 'cogs',
          code: '5100',
          name: 'تكلفة المبيعات',
          type: AccountType.expense,
        ),
        _account(
          id: 'sales',
          code: '4100',
          name: 'إيرادات المبيعات',
          type: AccountType.revenue,
        ),
      ],
    );
    container = ProviderContainer(
      overrides: [
        accountingRepositoryProvider.overrideWithValue(repository),
        appIconsProvider.overrideWithValue(const MaterialAppIcons()),
      ],
    );
  });

  tearDown(() => container.dispose());

  Widget testApp({InventoryItem? item}) => UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: InventoryItemFormScreen(item: item),
        ),
      );

  testWidgets('يهيئ حقول تعديل الصنف وطريقة التقييم وحسابات IAS 2', (
    tester,
  ) async {
    final updatedAt = DateTime.utc(2026, 3);
    final item = InventoryItem(
      id: 'item-1',
      nameAr: 'قلم حبر',
      nameEn: 'Ink Pen',
      sku: 'PEN-01',
      purchasePrice: 2.5,
      salePrice: 5,
      unit: 'قطعة',
      currentQuantity: 40,
      description: 'قلم أزرق',
      valuationMethod: ValuationMethod.fifo,
      assetAccountId: 'inventory',
      cogsAccountId: 'cogs',
      revenueAccountId: 'sales',
      createdAt: updatedAt,
      updatedAt: updatedAt,
    );

    await tester.pumpWidget(testApp(item: item));
    await tester.pumpAndSettle();

    expect(find.byType(InventoryItemFormScreen), findsOneWidget);
    final fields = find.byType(TextFormField);
    expect(
      tester.widget<TextFormField>(fields.at(0)).controller!.text,
      'قلم حبر',
    );
    expect(
      tester.widget<TextFormField>(fields.at(1)).controller!.text,
      'Ink Pen',
    );
    expect(
      tester.widget<TextFormField>(fields.at(2)).controller!.text,
      'PEN-01',
    );
    expect(tester.widget<TextFormField>(fields.at(3)).controller!.text, '2.5');
    expect(tester.widget<TextFormField>(fields.at(6)).controller!.text, '40.0');
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -700),
    );
    await tester.pumpAndSettle();
    final valuationSelector =
        tester.widget<DropdownButtonFormField<ValuationMethod>>(
      find.byWidgetPredicate(
        (widget) =>
            widget is DropdownButtonFormField<ValuationMethod> &&
            widget.initialValue == ValuationMethod.fifo,
      ),
    );
    expect(valuationSelector.initialValue, ValuationMethod.fifo);
    expect(find.text('1200 - أصل المخزون'), findsOneWidget);
    expect(find.text('5100 - تكلفة المبيعات'), findsOneWidget);
    expect(find.text('4100 - إيرادات المبيعات'), findsOneWidget);
  });

  testWidgets('يرفض الحفظ قبل إدخال اسمي الصنف الإلزاميين', (tester) async {
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(
      tester.element(find.byType(InventoryItemFormScreen)),
    );

    final saveAction = find.descendant(
      of: find.byType(AppEnhancedButton),
      matching: find.byType(InkWell),
    );
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -900),
    );
    await tester.pumpAndSettle();
    await tester.tap(saveAction);
    await tester.pumpAndSettle();

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, 900),
    );
    await tester.pumpAndSettle();
    expect(find.text(l10n.errEmptyField), findsNWidgets(2));
    verifyNever(() => repository.getJournalEntries());
  });
}
