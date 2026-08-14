/// اختبارات سلوكية لشاشة تحويل المخزون بين المستودعات.
library;

import 'dart:async';

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/inventory_item.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/warehouse.dart';
import 'package:basir_accounting_system/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:basir_accounting_system/features/inventory/presentation/providers/warehouse_provider.dart';
import 'package:basir_accounting_system/features/inventory/presentation/screens/warehouse_transfer_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/app_enhanced_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime.utc(2026, 8, 14);

Warehouse _warehouse({required String id, required String name}) => Warehouse(
      id: id,
      nameAr: name,
      nameEn: name,
      createdAt: _now,
      updatedAt: _now,
    );

InventoryItem _item() => InventoryItem(
      id: 'item-1',
      nameAr: 'حاسوب محمول',
      nameEn: 'Laptop',
      currentQuantity: 8,
      createdAt: _now,
      updatedAt: _now,
    );

Widget _app(List<Override> overrides) => UncontrolledProviderScope(
      container: ProviderContainer(
        overrides: [
          appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          ...overrides,
        ],
      ),
      child: MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const WarehouseTransferScreen(),
      ),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final warehouses = [
    _warehouse(id: 'main', name: 'المستودع الرئيسي'),
    _warehouse(id: 'branch', name: 'مستودع الفرع'),
  ];

  testWidgets('يعرض مؤشّر تحميل المستودعات مع حالة المخزون الفارغة', (
    tester,
  ) async {
    final completer = Completer<List<Warehouse>>();
    await tester.pumpWidget(
      _app([
        warehousesProvider.overrideWith((ref) => completer.future),
        inventoryItemsProvider.overrideWith((ref) async => [_item()]),
      ]),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('يعرض رسالة الخطأ عند تعذر تحميل المستودعات', (tester) async {
    await tester.pumpWidget(
      _app([
        warehousesProvider.overrideWith(
          (ref) => Future<List<Warehouse>>.error('تعذر تحميل المستودعات'),
        ),
        inventoryItemsProvider.overrideWith((ref) async => [_item()]),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('تعذر تحميل المستودعات'), findsOneWidget);
  });

  testWidgets('يختار صنفاً ويضيفه إلى قائمة التحويل', (tester) async {
    await tester.pumpWidget(
      _app([
        warehousesProvider.overrideWith((ref) async => warehouses),
        inventoryItemsProvider.overrideWith((ref) async => [_item()]),
      ]),
    );
    final container = ProviderScope.containerOf(
      tester.element(find.byType(WarehouseTransferScreen)),
    );
    await container.read(inventoryItemsProvider.future);
    await tester.pumpAndSettle();

    expect(find.byType(DropdownButtonFormField<Warehouse>), findsNWidgets(2));
    final addItemAction = find.byWidgetPredicate(
      (widget) =>
          widget is IconButton && widget.constraints == const BoxConstraints(),
    );
    final l10n = AppLocalizations.of(
      tester.element(find.byType(WarehouseTransferScreen)),
    );
    expect(addItemAction, findsOneWidget);

    await tester.tap(addItemAction);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text(l10n.dialogAddItemTitle), findsOneWidget);

    await tester.tap(find.byType(DropdownButtonFormField<InventoryItem>));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('حاسوب محمول').last);
    await tester.pump();
    await tester.tap(find.text(l10n.btnAdd));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('حاسوب محمول'), findsWidgets);
    expect(find.text('${l10n.labelQuantity}: 1.0'), findsOneWidget);
  });

  testWidgets('يمنع حفظ التحويل قبل اختيار المستودعات وإضافة الأصناف', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app([
        warehousesProvider.overrideWith((ref) async => warehouses),
        inventoryItemsProvider.overrideWith((ref) async => [_item()]),
      ]),
    );
    await tester.pumpAndSettle();

    final saveAction = find.descendant(
      of: find.byType(AppEnhancedButton),
      matching: find.byType(InkWell),
    );
    final l10n = AppLocalizations.of(
      tester.element(find.byType(WarehouseTransferScreen)),
    );
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();
    await tester.tap(saveAction);
    await tester.pumpAndSettle();

    expect(find.text(l10n.errFormFill), findsOneWidget);
  });
}
