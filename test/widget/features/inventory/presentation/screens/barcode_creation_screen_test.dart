import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/inventory/application/barcode_service.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/inventory_item.dart';
import 'package:basir_accounting_system/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:basir_accounting_system/features/inventory/presentation/screens/barcode_creation_screen.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/barcode_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _FakeInventoryRepository inventory;

  setUp(() {
    inventory = _FakeInventoryRepository(items: [_item]);
    _FakeBarcodeService.reset();
  });

  Widget buildSubject() => ProviderScope(
        overrides: [
          inventoryRepositoryProvider.overrideWithValue(inventory),
          barcodeServiceProvider.overrideWith(_FakeBarcodeService.new),
        ],
        child: const MaterialApp(home: BarcodeCreationScreen()),
      );

  Future<void> selectItem(WidgetTester tester) async {
    await tester.tap(find.byType(DropdownButtonFormField<InventoryItem>));
    await tester.pumpAndSettle();
    await tester.tap(find.text(_item.nameAr).last);
    await tester.pump();
  }

  group('BarcodeCreationScreen', () {
    testWidgets('يعرض حالة التحميل ثم الأصناف القادمة من المستودع',
        (tester) async {
      final delayed = _FakeInventoryRepository(
        items: [_item],
        delay: const Duration(milliseconds: 50),
      );
      inventory = delayed;

      await tester.pumpWidget(buildSubject());
      expect(find.byType(LinearProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 60));
      expect(find.text('اختر الصنف'), findsOneWidget);
      expect(
        find.byType(DropdownButtonFormField<InventoryItem>),
        findsOneWidget,
      );
    });

    testWidgets('يرفض الحفظ قبل اختيار الصنف وإدخال الباركود', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.tap(find.text('حفظ'));
      await tester.pump();

      expect(find.text('يرجى اختيار صنف وإدخال الباركود'), findsOneWidget);
      expect(inventory.updatedItems, isEmpty);
    });

    testWidgets('يولّد رمزاً ويحدّث الصنف المختار عند الحفظ', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();
      await selectItem(tester);

      await tester.tap(find.byTooltip('توليد عشوائي'));
      await tester.pump();
      expect(_textField(tester, 1), '629123456789');

      await tester.tap(find.text('حفظ'));
      await tester.pump();

      expect(inventory.updatedItems, hasLength(1));
      expect(inventory.updatedItems.single.id, _item.id);
      expect(inventory.updatedItems.single.barcode, '629123456789');
    });

    testWidgets('يرسل الصنف والعدد إلى خدمة الطباعة بعد الاختيار',
        (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();
      await selectItem(tester);
      await tester.enterText(find.byType(TextField).at(2), '4');

      await tester.tap(find.text('طباعة'));
      await tester.pump();

      expect(_FakeBarcodeService.printedItem?.id, _item.id);
      expect(_FakeBarcodeService.printedCount, 4);
    });

    testWidgets('يعرض خطأ حفظ المستودع ولا يخرج من الشاشة', (tester) async {
      inventory =
          _FakeInventoryRepository(items: [_item], throwsOnUpdate: true);
      await tester.pumpWidget(buildSubject());
      await tester.pump();
      await selectItem(tester);

      await tester.enterText(find.byType(TextField).at(1), 'barcode-error');
      await tester.tap(find.text('حفظ'));
      await tester.pump();

      expect(find.textContaining('تعذر حفظ الصنف'), findsOneWidget);
      expect(find.byType(BarcodeCreationScreen), findsOneWidget);
    });
  });
}

String _textField(WidgetTester tester, int index) =>
    tester.widget<TextField>(find.byType(TextField).at(index)).controller!.text;

final _item = InventoryItem(
  id: 'inventory-1',
  nameAr: 'صنف تجريبي',
  nameEn: 'Test item',
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  salePrice: 75,
  barcode: 'old-code',
);

class _FakeBarcodeService extends BarcodeService {
  static InventoryItem? printedItem;
  static int? printedCount;

  static void reset() {
    printedItem = null;
    printedCount = null;
  }

  @override
  void build() {}

  @override
  String generateRandomBarcode() => '629123456789';

  @override
  Future<void> printLabels({
    required InventoryItem item,
    required int count,
    BarcodeConfig? config,
  }) async {
    printedItem = item;
    printedCount = count;
  }
}

class _FakeInventoryRepository implements InventoryRepository {
  _FakeInventoryRepository({
    required this.items,
    this.delay = Duration.zero,
    this.throwsOnUpdate = false,
  });

  final List<InventoryItem> items;
  final Duration delay;
  final bool throwsOnUpdate;
  final List<InventoryItem> updatedItems = [];

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
        (item) => item.nameAr.contains(query) || item.nameEn.contains(query),
      )
      .toList();

  @override
  Future<void> updateItem(InventoryItem item) async {
    if (throwsOnUpdate) throw Exception('تعذر حفظ الصنف');
    updatedItems.add(item);
    final index = items.indexWhere((existing) => existing.id == item.id);
    if (index >= 0) items[index] = item;
  }
}
