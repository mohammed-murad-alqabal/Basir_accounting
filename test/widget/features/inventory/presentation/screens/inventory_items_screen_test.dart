import 'package:basir_accounting_system/core/assets/app_illustrations.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/inventory_item.dart';
import 'package:basir_accounting_system/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:basir_accounting_system/features/inventory/presentation/screens/inventory_item_form_screen.dart';
import 'package:basir_accounting_system/features/inventory/presentation/screens/inventory_items_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 1;
  });

  tearDown(() {
    TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
      ..resetPhysicalSize()
      ..resetDevicePixelRatio();
  });

  Widget buildSubject(InventoryRepository repository) => ProviderScope(
        overrides: [
          inventoryRepositoryProvider.overrideWithValue(repository),
          appIconsProvider.overrideWithValue(const MaterialAppIcons()),
        ],
        child: const MaterialApp(
          locale: Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: InventoryItemsScreen(),
        ),
      );

  group('InventoryItemsScreen', () {
    testWidgets('يعرض التحميل ثم الأصناف ويطبق البحث على الاسم وSKU', (
      tester,
    ) async {
      final officePaper = inventoryItem(
        id: 'item-1',
        nameAr: 'ورق مكتبي',
        nameEn: 'Office paper',
        sku: 'PAPER-01',
        quantity: 12,
        unit: 'علبة',
      );
      final ink = inventoryItem(
        id: 'item-2',
        nameAr: 'حبر طابعة',
        nameEn: 'Printer ink',
        sku: 'INK-02',
        quantity: 4,
        unit: 'قطعة',
      );

      await tester.pumpWidget(
        buildSubject(
          _MemoryInventoryRepository(
            [officePaper, ink],
            delay: const Duration(milliseconds: 50),
          ),
        ),
      );
      expect(find.byType(AppLoadingIndicator), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 60));
      await tester.pump();

      expect(find.text('ورق مكتبي'), findsOneWidget);
      expect(find.text('حبر طابعة'), findsOneWidget);
      expect(find.text('PAPER-01'), findsOneWidget);
      expect(
        find.bySemanticsLabel('ورق مكتبي, PAPER-01, 12.0 علبة'),
        findsOneWidget,
      );

      await tester.enterText(find.byType(AppSearchField), 'ink-02');
      await tester.pump();

      expect(find.text('ورق مكتبي'), findsNothing);
      expect(find.text('حبر طابعة'), findsOneWidget);
    });

    testWidgets('يعرض الحالة الفارغة عند عدم وجود أصناف', (tester) async {
      await tester
          .pumpWidget(buildSubject(_MemoryInventoryRepository(const [])));
      await tester.pump();
      await tester.pump();

      expect(find.byType(EmptyStateIllustration), findsOneWidget);
    });

    testWidgets('يعرض حالة الخطأ عند تعذر تحميل الأصناف', (tester) async {
      await tester.pumpWidget(buildSubject(_FailingInventoryRepository()));
      await tester.pump();
      await tester.pump();

      expect(find.byType(AppErrorWidget), findsOneWidget);
      expect(find.textContaining('تعذر تحميل الأصناف'), findsOneWidget);
    });

    testWidgets('ينتقل إلى نموذج تعديل الصنف وإضافة صنف جديد', (tester) async {
      final item = inventoryItem(
        id: 'item-3',
        nameAr: 'مستندات أرشيف',
        nameEn: 'Archive files',
        sku: 'ARCH-03',
        quantity: 8,
        unit: 'ملف',
      );
      await tester.pumpWidget(buildSubject(_MemoryInventoryRepository([item])));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(AppListCard));
      await tester.pumpAndSettle();
      expect(find.byType(InventoryItemFormScreen), findsOneWidget);

      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add_outlined));
      await tester.pumpAndSettle();
      expect(find.byType(InventoryItemFormScreen), findsOneWidget);
    });
  });
}

InventoryItem inventoryItem({
  required String id,
  required String nameAr,
  required String nameEn,
  required String sku,
  required double quantity,
  required String unit,
}) =>
    InventoryItem(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      sku: sku,
      currentQuantity: quantity,
      unit: unit,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );

class _MemoryInventoryRepository implements InventoryRepository {
  _MemoryInventoryRepository(this.items, {this.delay = Duration.zero});

  final List<InventoryItem> items;
  final Duration delay;

  @override
  Future<void> addItem(InventoryItem item) async => items.add(item);

  @override
  Future<void> deleteItem(String id) async =>
      items.removeWhere((item) => item.id == id);

  @override
  Future<List<InventoryItem>> getAllItems() async {
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    return List.unmodifiable(items);
  }

  @override
  Future<InventoryItem?> getItemById(String id) async =>
      items.where((item) => item.id == id).cast<InventoryItem?>().firstOrNull;

  @override
  Future<InventoryItem?> getItemBySku(String sku) async => items
      .where((item) => item.sku == sku || item.barcode == sku)
      .cast<InventoryItem?>()
      .firstOrNull;

  @override
  Future<List<InventoryItem>> searchItems(String query) async => items
      .where(
        (item) =>
            item.nameAr.contains(query) ||
            item.nameEn.contains(query) ||
            (item.sku ?? '').contains(query),
      )
      .toList();

  @override
  Future<void> updateItem(InventoryItem item) async {
    final index = items.indexWhere((existing) => existing.id == item.id);
    if (index >= 0) items[index] = item;
  }
}

class _FailingInventoryRepository extends _MemoryInventoryRepository {
  _FailingInventoryRepository() : super(const []);

  @override
  Future<List<InventoryItem>> getAllItems() =>
      Future.error(StateError('تعذر تحميل الأصناف'));
}
