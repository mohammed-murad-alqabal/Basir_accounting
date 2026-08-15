library;

import 'package:basir_accounting_system/core/domain/contracts/audit_entry.dart';
import 'package:basir_accounting_system/core/domain/contracts/operation_result.dart';
import 'package:basir_accounting_system/features/inventory/application/bulk_price_change_service.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/bulk_price_change.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/inventory_item.dart';
import 'package:basir_accounting_system/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// مستودع وهمي يجمع الأصناف ويحمي الرصيد خارج تدفقات التسوية المعتمدة.
class FakeInventoryRepository implements InventoryRepository {
  FakeInventoryRepository(List<InventoryItem> items)
      : _items = {for (final item in items) item.id: item};

  final Map<String, InventoryItem> _items;
  int updateCalls = 0;
  bool shouldFailOnUpdate = false;

  @override
  Future<List<InventoryItem>> getAllItems() async =>
      _items.values.toList(growable: false);

  @override
  Future<InventoryItem?> getItemById(String id) async => _items[id];

  @override
  Future<void> addItem(InventoryItem item) async => _items[item.id] = item;

  @override
  Future<void> updateItem(InventoryItem item) async {
    if (shouldFailOnUpdate) {
      throw Exception('تعذر حفظ بيانات الصنف في المستودع');
    }
    _items[item.id] = item;
    updateCalls++;
  }

  @override
  Future<void> deleteItem(String id) async => _items.remove(id);

  @override
  Future<List<InventoryItem>> searchItems(String query) async =>
      _items.values
          .where((item) => item.nameAr.contains(query) ||
              item.nameEn.contains(query) ||
              (item.sku?.contains(query) ?? false))
          .toList(growable: false);

  @override
  Future<InventoryItem?> getItemBySku(String sku) async => _items.values
      .firstWhere(
          (item) => item.sku?.toUpperCase() == sku.toUpperCase() ||
              item.barcode?.toUpperCase() == sku.toUpperCase(),
          orElse: () => _items.values.firstOrNull ??
              (throw StateError('لا يوجد صنف مطابق')));
}

/// مستودع تنفيذ وهمي يثبت الحفظ والاسترجاع والإلغاء الزماني لسجل التنفيذ.
class FakeExecutionStorage implements BulkChangeExecutionStorage {
  final Map<String, BulkChangeExecutionRecord> _records = {};

  @override
  Future<BulkChangeExecutionRecord> save(
      BulkChangeExecutionRecord record) async {
    _records[record.id] = record;
    return record;
  }

  @override
  Future<BulkChangeExecutionRecord?> fetch(String id) async =>
      _records[id];

  @override
  Future<void> markCancelled(String id, AuditEntry cancellation) async {
    final record = _records[id];
    if (record != null) {
      _records[id] = record;
    }
    _cancellations[id] = cancellation;
  }

  final Map<String, AuditEntry> _cancellations = {};
  List<AuditEntry> cancellationEvents(String id) =>
      [if (_cancellations.containsKey(id)) _cancellations[id]!];
}

/// توليد صنف اختباري بقيم سعرية قابلة للضبط.
InventoryItem item({
  required String id,
  double? salePrice,
  double? purchasePrice,
  bool isDeleted = false,
}) =>
    InventoryItem(
      id: id,
      nameAr: 'صنف $id',
      nameEn: 'Item $id',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
      salePrice: salePrice,
      purchasePrice: purchasePrice,
      isDeleted: isDeleted,
    );

DateTime Function() fixedClock(DateTime fixed) => () => fixed;

void main() {
  late FakeInventoryRepository repository;
  late FakeExecutionStorage storage;
  late BulkPriceChangeService service;
  late DateTime now;

  const operatorName = 'المحاسبي المسؤول';

  setUp(() {
    now = DateTime(2026, 8, 15, 10, 0);
    repository = FakeInventoryRepository([
      item(id: 'a', salePrice: 100, purchasePrice: 60),
      item(id: 'b', salePrice: 200, purchasePrice: 120),
      item(id: 'c', salePrice: 50),
      item(id: 'd', salePrice: 10, purchasePrice: 8, isDeleted: true),
    ]);
    storage = FakeExecutionStorage();
    service = BulkPriceChangeService(
      repository: repository,
      storage: storage,
      now: fixedClock(now),
    );
  });

  group('معاينة قاعدة النسبة المئوية', () {
    test('يحسب السعر الجديد بنسبة موجبة على كل الأصناف', () async {
      final result = await service.preview(
        scope: const BulkPriceChangeScope.all(),
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.percentage, value: 10),
        target: BulkPriceTarget.sale,
      );

      expect(result.success, isTrue);
      final entries = result.getOrThrow();
      expect(entries.map((e) => e.itemId).toSet(), {'a', 'b', 'c'});
      final entryA = entries.firstWhere((e) => e.itemId == 'a');
      expect(entryA.previousSalePrice, 100);
      expect(entryA.newSalePrice, 110);
      expect(entryA.isBlocked, isFalse);
    });

    test('يستبعد الأصناف المحذوفة من النطاق', () async {
      final result = await service.preview(
        scope: const BulkPriceChangeScope.all(),
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.percentage, value: 10),
        target: BulkPriceTarget.sale,
      );

      expect(result.success, isTrue);
      expect(
        result.getOrThrow().any((e) => e.itemId == 'd'),
        isFalse,
        reason: 'الأصناف المحذوفة لا تدخل النطاق العام',
      );
    });

    test('يحصر النطاق المحدد في المعرّفات المطلوبة', () async {
      final result = await service.preview(
        scope: const BulkPriceChangeScope.items(['a', 'c']),
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.percentage, value: 20),
        target: BulkPriceTarget.sale,
      );

      expect(result.success, isTrue);
      final entries = result.getOrThrow();
      expect(entries.map((e) => e.itemId).toSet(), {'a', 'c'});
    });

    test('يعرض معاينة السعرين معًا عند استهداف السعرين', () async {
      final result = await service.preview(
        scope: const BulkPriceChangeScope.items(['a']),
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.percentage, value: 5),
        target: BulkPriceTarget.both,
      );

      expect(result.success, isTrue);
      final entry = result.getOrThrow().single;
      expect(entry.newSalePrice, 105);
      expect(entry.newPurchasePrice, 63);
    });

    test('يحدد نتيجة سالبة عند نسب تخفيض تخفض السعر دون الصفر', () async {
      final result = await service.preview(
        scope: const BulkPriceChangeScope.items(['c']),
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.percentage, value: -200),
        target: BulkPriceTarget.sale,
      );

      expect(result.success, isTrue);
      final entry = result.getOrThrow().single;
      expect(entry.hasNegativeResult, isTrue);
      expect(entry.isBlocked, isTrue);
      expect(entry.blockReason, isNotNull);
    });

    test('لا يتأثر بأصناف دون سعر بيع عند استهداف البيع', () async {
      final withoutSale = FakeInventoryRepository([
        item(id: 'x'),
      ]);
      final previewer = BulkPriceChangeService(
        repository: withoutSale,
        storage: FakeExecutionStorage(),
        now: fixedClock(now),
      );
      final result = await previewer.preview(
        scope: const BulkPriceChangeScope.all(),
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.percentage, value: 10),
        target: BulkPriceTarget.sale,
      );

      expect(result.success, isTrue);
      final entry = result.getOrThrow().single;
      expect(
        entry.isBlocked,
        isTrue,
        reason: 'الأصناف دون سعر بيع لا تُحدّث أسعارها وتُحصر في المعاينة',
      );
      expect(entry.blockReason, isNotNull);
      expect(entry.newSalePrice, isNull);
    });
  });

  group('معاينة قواعد المبلغ الثابت والتعيين والنسخ', () {
    test('قاعدة المبلغ الثابت تجمع القيمة على السعر الحالي', () async {
      final result = await service.preview(
        scope: const BulkPriceChangeScope.items(['b']),
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.fixedAmount, value: 25),
        target: BulkPriceTarget.sale,
      );

      expect(result.getOrThrow().single.newSalePrice, 225);
    });

    test('قاعدة التعيين المباشر تطبق القيمة الجديدة تمامًا', () async {
      final result = await service.preview(
        scope: const BulkPriceChangeScope.items(['a']),
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.setTo, value: 150),
        target: BulkPriceTarget.sale,
      );

      expect(result.getOrThrow().single.newSalePrice, 150);
    });

    test('قاعدة النسخ من الشراء تنتج سعر بيع مساويًا لسعر الشراء', () async {
      final result = await service.preview(
        scope: const BulkPriceChangeScope.items(['a']),
        rule: const BulkPriceChangeRule(
          type: BulkPriceChangeRuleType.copyFromPurchase,
          value: 0,
          sourcePrice: BulkPriceSource.purchase,
        ),
        target: BulkPriceTarget.sale,
      );

      expect(result.getOrThrow().single.newSalePrice, 60);
    });
  });

  group('حراسة القاعدة قبل المعاينة', () {
    test('يرفض قيمة نسب غير منتهية', () async {
      final result = await service.preview(
        scope: const BulkPriceChangeScope.all(),
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.percentage, value: double.infinity),
        target: BulkPriceTarget.sale,
      );

      expect(result.success, isFalse);
      expect(result.message, BulkPriceChangeService.invalidRuleCode);
    });

    test('يرفض قاعدة نسخ بلا مصدر', () async {
      final result = await service.preview(
        scope: const BulkPriceChangeScope.items(['a']),
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.copyFromPurchase, value: 0),
        target: BulkPriceTarget.sale,
      );

      expect(result.success, isFalse);
      expect(result.message, BulkPriceChangeService.invalidRuleCode);
    });

    test('يرفض تعيينًا يسفر عن سعر سالب مباشرة', () async {
      final result = await service.preview(
        scope: const BulkPriceChangeScope.items(['a']),
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.setTo, value: -5),
        target: BulkPriceTarget.sale,
      );

      expect(result.success, isFalse);
      expect(result.message, BulkPriceChangeService.negativeResultCode);
    });

    test('يرفض نطاقًا فارغًا غير محدد', () async {
      final empty = FakeInventoryRepository([]);
      final previewer = BulkPriceChangeService(
        repository: empty,
        storage: FakeExecutionStorage(),
        now: fixedClock(now),
      );
      final result = await previewer.preview(
        scope: const BulkPriceChangeScope.all(),
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.percentage, value: 10),
        target: BulkPriceTarget.sale,
      );

      expect(result.success, isFalse);
      expect(result.message, BulkPriceChangeService.emptyScopeCode);
    });
  });

  group('تنفيذ تغيير معتمد مع أثر تدقيقي', () {
    test('ينفذ القاعدة على النطاق ويسجل سجل تنفيذ وسبب وسجل تدقيق', () async {
      final preview = (await service.preview(
        scope: const BulkPriceChangeScope.items(['a', 'b']),
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.percentage, value: 10),
        target: BulkPriceTarget.sale,
      ))
          .getOrThrow();

      final result = await service.execute(
        preview: preview,
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.percentage, value: 10),
        scope: const BulkPriceChangeScope.items(['a', 'b']),
        target: BulkPriceTarget.sale,
        operatorName: operatorName,
        reason: 'مراجعة أسعار الموسم',
      );

      expect(result.success, isTrue);
      final record = result.getOrThrow();
      expect(record.operatorName, operatorName);
      expect(record.reason, 'مراجعة أسعار الموسم');
      expect(record.affectedItemIds, unorderedEquals(['a', 'b']));
      expect(record.auditTrail, hasLength(1));
      expect(record.auditTrail.single.type, AuditEventType.administrative);
      expect(record.auditTrail.single.referenceId, record.id);

      final updatedA = await repository.getItemById('a');
      expect(updatedA!.salePrice, 110);
      expect(updatedA.purchasePrice, 60, reason: 'سعر الشراء لا يتغير');
      expect(updatedA.currentQuantity, 0, reason: 'الرصيد لا يُمس');
      expect(updatedA.createdAt, DateTime(2026, 1, 1),
          reason: 'تاريخ الإنشاء محفوظ');
    });

    test('يسجل القيمة السابقة لكل صنف متأثر لتمكين الإلغاء', () async {
      final preview = (await service.preview(
        scope: const BulkPriceChangeScope.items(['a']),
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.percentage, value: 10),
        target: BulkPriceTarget.sale,
      ))
          .getOrThrow();

      final result = await service.execute(
        preview: preview,
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.percentage, value: 10),
        scope: const BulkPriceChangeScope.items(['a']),
        target: BulkPriceTarget.sale,
        operatorName: operatorName,
        reason: 'سبب موثق',
      );

      expect(result.success, isTrue);
      final record = result.getOrThrow();
      final previous = record.previousValues.firstWhere((p) => p.itemId == 'a');
      expect(previous.previousSalePrice, 100);
      expect(previous.previousPurchasePrice, 60);
    });

    test('يستبعد الأصناف غير الموجودة والنطاق المنتهي عند التنفيذ', () async {
      final preview = (await service.preview(
        scope: const BulkPriceChangeScope.items(['a', 'gone']),
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.percentage, value: 10),
        target: BulkPriceTarget.sale,
      ))
          .getOrThrow();

      final result = await service.execute(
        preview: preview,
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.percentage, value: 10),
        scope: const BulkPriceChangeScope.items(['a', 'gone']),
        target: BulkPriceTarget.sale,
        operatorName: operatorName,
        reason: 'سبب موثق',
      );

      expect(result.success, isTrue);
      expect(result.getOrThrow().affectedItemIds, ['a']);
    });

    test('يعيد فشلًا عند غياب سبب الاعتماد', () async {
      final preview = (await service.preview(
        scope: const BulkPriceChangeScope.items(['a']),
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.percentage, value: 10),
        target: BulkPriceTarget.sale,
      ))
          .getOrThrow();

      final result = await service.execute(
        preview: preview,
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.percentage, value: 10),
        scope: const BulkPriceChangeScope.items(['a']),
        target: BulkPriceTarget.sale,
        operatorName: operatorName,
        reason: '',
      );

      expect(result.success, isFalse);
      expect(result.message, BulkPriceChangeService.emptyReasonCode);
    });

    test('يفشل تنفيذًا دون أثر جانبي عند تعذر حفظ أحد الأصناف', () async {
      repository.shouldFailOnUpdate = true;
      final preview = (await service.preview(
        scope: const BulkPriceChangeScope.items(['a']),
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.percentage, value: 10),
        target: BulkPriceTarget.sale,
      ))
          .getOrThrow();

      final result = await service.execute(
        preview: preview,
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.percentage, value: 10),
        scope: const BulkPriceChangeScope.items(['a']),
        target: BulkPriceTarget.sale,
        operatorName: operatorName,
        reason: 'سبب موثق',
      );

      expect(result.success, isFalse);
      expect(result.message, BulkPriceChangeService.commitFailedCode);
      final itemA = await repository.getItemById('a');
      expect(itemA!.salePrice, 100, reason: 'لا أثر جانبي عند الفشل');
    });
  });

  group('سياسة الإلغاء الزمنية', () {
    test('يعيد الأسعار السابقة مع حدث إلغاء موثق داخل النافذة', () async {
      final preview = (await service.preview(
        scope: const BulkPriceChangeScope.items(['a']),
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.percentage, value: 10),
        target: BulkPriceTarget.sale,
      ))
          .getOrThrow();

      final execution = (await service.execute(
        preview: preview,
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.percentage, value: 10),
        scope: const BulkPriceChangeScope.items(['a']),
        target: BulkPriceTarget.sale,
        operatorName: operatorName,
        reason: 'سبب موثق',
      ))
          .getOrThrow();

      final result = await service.cancel(
        recordId: execution.id,
        operatorName: operatorName,
        reason: 'خطأ في نسبة الرفع',
      );

      expect(result.success, isTrue);
      final rollbacks = result.getOrThrow();
      expect(rollbacks, hasLength(1));
      final itemA = await repository.getItemById('a');
      expect(itemA!.salePrice, 100);
      expect(itemA.purchasePrice, 60);
      expect(storage.cancellationEvents(execution.id),
          [isA<AuditEntry>()]);
    });

    test('يرفض الإلغاء بعد انقضاء نافذة الأربع وعشرين ساعة', () async {
      final preview = (await service.preview(
        scope: const BulkPriceChangeScope.items(['a']),
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.percentage, value: 10),
        target: BulkPriceTarget.sale,
      ))
          .getOrThrow();

      final execution = (await service.execute(
        preview: preview,
        rule: const BulkPriceChangeRule(type: BulkPriceChangeRuleType.percentage, value: 10),
        scope: const BulkPriceChangeScope.items(['a']),
        target: BulkPriceTarget.sale,
        operatorName: operatorName,
        reason: 'سبب موثق',
      ))
          .getOrThrow();

      now = execution.executedAt.add(const Duration(hours: 24, minutes: 5));
      final canceller = BulkPriceChangeService(
        repository: repository,
        storage: storage,
        now: fixedClock(now),
      );

      final result = await canceller.cancel(
        recordId: execution.id,
        operatorName: operatorName,
        reason: 'محاولة إلغاء متأخرة',
      );

      expect(result.success, isFalse);
      expect(result.message, BulkPriceChangeService.cancellationExpiredCode);
    });

    test('يرفض إلغاء سجل غير موجود', () async {
      final result = await service.cancel(
        recordId: 'non-existent',
        operatorName: operatorName,
        reason: 'لا سجل هنا',
      );

      expect(result.success, isFalse);
      expect(result.message, BulkPriceChangeService.executionNotFoundCode);
    });
  });
}
