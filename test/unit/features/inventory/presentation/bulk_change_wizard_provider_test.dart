/// اختبارات وحدة لمزود معالج تغيير الأسعار الجماعي.
///
/// تتحقق هذه الاختبارات من سلوك حالة المعالج متعدد الخطوات:
/// الانتقال بين الخطوات، تحديث القاعدة والنطاق، تحديث المعاينة،
/// التنفيذ الموثق، والانتقال إلى خطوة النجاح مع نافذة الإلغاء.
@TestOn('vm')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:basir_accounting_system/core/domain/contracts/audit_entry.dart';
import 'package:basir_accounting_system/core/domain/contracts/operation_result.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/inventory/application/bulk_price_change_service.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/bulk_price_change.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/inventory_item.dart';
import 'package:basir_accounting_system/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:basir_accounting_system/features/inventory/presentation/providers/bulk_price_change_provider.dart';

/// خدمة وهمية تحاكي المعاينة والتنفيذ والإلغاء.
class _FakeBulkService implements BulkPriceChangeService {
  List<BulkPriceChangePreviewEntry> previewResult = const [];
  OperationResult<BulkChangeExecutionRecord> executeResult =
      const OperationResult<BulkChangeExecutionRecord>.failure(
    message: 'فشل',
  );
  OperationResult<List<InventoryItem>> cancelResult =
      const OperationResult<List<InventoryItem>>.failure(message: 'فشل');

  final List<String> previewCalls = [];
  final List<String> executeCalls = [];
  final List<String> cancelCalls = [];

  @override
  Future<OperationResult<List<BulkPriceChangePreviewEntry>>> preview({
    required BulkPriceChangeScope scope,
    required BulkPriceChangeRule rule,
    required BulkPriceTarget target,
  }) async {
    previewCalls.add('${scope.count}:$target:${rule.type}:${rule.value}');
    if (previewResult.isEmpty) {
      return const OperationResult<List<BulkPriceChangePreviewEntry>>.failure(
        message: 'فشل',
      );
    }
    return OperationResult.success(value: previewResult);
  }

  @override
  Future<OperationResult<BulkChangeExecutionRecord>> execute({
    required List<BulkPriceChangePreviewEntry> preview,
    required BulkPriceChangeRule rule,
    required BulkPriceChangeScope scope,
    required BulkPriceTarget target,
    required String operatorName,
    required String reason,
  }) async {
    executeCalls.add('$operatorName:$reason');
    return executeResult;
  }

  @override
  Future<OperationResult<List<InventoryItem>>> cancel({
    required String recordId,
    required String operatorName,
    required String reason,
  }) async {
    cancelCalls.add('$recordId:$operatorName:$reason');
    return cancelResult;
  }
}

/// مستودع وهمي للمخزون للاختبار.
class _FakeInventoryRepository implements InventoryRepository {
  _FakeInventoryRepository([Iterable<InventoryItem> initialItems = const []])
      : _items = {for (final item in initialItems) item.id: item};
  final Map<String, InventoryItem> _items;

  @override
  Future<void> addItem(InventoryItem item) async => _items[item.id] = item;

  @override
  Future<void> deleteItem(String id) async => _items.remove(id);

  @override
  Future<List<InventoryItem>> getAllItems() async => _items.values.toList();

  @override
  Future<InventoryItem?> getItemById(String id) async => _items[id];

  @override
  Future<InventoryItem?> getItemBySku(String sku) async {
    final normalized = sku.toUpperCase();
    for (final item in _items.values) {
      if (item.sku?.toUpperCase() == normalized) return item;
    }
    return null;
  }

  @override
  Future<List<InventoryItem>> searchItems(String query) async {
    final normalized = query.toUpperCase();
    return _items.values.where((item) {
      return (item.nameAr + item.nameEn).toUpperCase().contains(normalized) ||
          (item.sku ?? '').toUpperCase().contains(normalized) ||
          (item.barcode ?? '').toUpperCase().contains(normalized);
    }).toList();
  }

  @override
  Future<void> updateItem(InventoryItem item) async => _items[item.id] = item;
}

/// تخزين وهمي لسجلات تنفيذ تغيير الأسعار الجماعي.
class _FakeBulkChangeExecutionStorage implements BulkChangeExecutionStorage {
  final List<BulkChangeExecutionRecord> records = [];

  @override
  Future<BulkChangeExecutionRecord> save(
      BulkChangeExecutionRecord record) async {
    records.removeWhere((existing) => existing.id == record.id);
    records.add(record);
    return record;
  }

  @override
  Future<BulkChangeExecutionRecord?> fetch(String id) async {
    for (final record in records) {
      if (record.id == id) return record;
    }
    return null;
  }

  @override
  Future<void> markCancelled(String id, AuditEntry cancellation) async {
    for (final record in records) {
      if (record.id == id) {
        records.remove(record);
        records.add(record.copyWithCancellation(cancellation));
        break;
      }
    }
  }
}

final _fixedNowProvider = Provider<DateTime Function()>(
  (ref) => () => DateTime.utc(2026, 8, 15, 12),
);

Future<ProviderContainer> buildContainer({
  required InventoryRepository repository,
}) async {
  final fakeService = _FakeBulkService();
  final container = ProviderContainer(
    overrides: [
      inventoryRepositoryProvider.overrideWithValue(repository),
      bulkChangeExecutionStorageProvider
          .overrideWithValue(_FakeBulkChangeExecutionStorage()),
      bulkPriceChangeServiceProvider.overrideWithValue(fakeService),
      bulkChangeNowProvider.overrideWithProvider(_fixedNowProvider),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

InventoryItem buildItem({
  required String id,
  required String nameAr,
  required String nameEn,
  double salePrice = 100,
  double purchasePrice = 80,
}) {
  return InventoryItem(
    id: id,
    nameAr: nameAr,
    nameEn: nameEn,
    barcode: '',
    sku: '',
    unit: 'حبة',
    salePrice: salePrice,
    purchasePrice: purchasePrice,
    currentQuantity: 10,
    isDeleted: false,
    createdAt: DateTime.utc(2026, 1, 1),
    updatedAt: DateTime.utc(2026, 1, 1),
  );
}

/// سجل تنفيذ وهمي مفتوح نافذة الإلغاء.
BulkChangeExecutionRecord buildRecord({
  bool cancelled = false,
  Duration? elapsed = const Duration(hours: 2),
}) {
  final executedAt = DateTime.utc(2026, 8, 15, 10);
  return BulkChangeExecutionRecord(
    id: 'exec-1',
    operatorName: 'المدير',
    executedAt: executedAt,
    reason: 'تحديث أسعار الصيف',
    rule: const BulkPriceChangeRule(
      type: BulkPriceChangeRuleType.percentage,
      value: 10,
    ),
    scopeItemIds: const ['item-1', 'item-2'],
    affectedItemIds: const ['item-1'],
    previousValues: const [
      BulkPriceChangePreviewEntry(
        itemId: 'item-1',
        itemName: 'صنف 1',
        target: BulkPriceTarget.sale,
        previousSalePrice: 100,
        previousPurchasePrice: 80,
        newSalePrice: 110,
        newPurchasePrice: 80,
        isBlocked: false,
        blockReason: null,
      ),
    ],
    auditTrail: const [],
    effectiveAt: executedAt,
    cancellationDeadline: executedAt.add(const Duration(hours: 24)),
    cancellation: cancelled
        ? AuditEntry(
            type: AuditEventType.cancelled,
            operatorName: 'المدير',
            occurredAt: DateTime.utc(2026, 8, 15, 12),
            reason: 'إلغاء',
            referenceId: 'exec-1',
          )
        : null,
  );
}

void main() {
  group('مزود معالج تغيير الأسعار الجماعي', () {
    test('يبدأ من خطوة النطاق بنطاق شامل', () async {
      final repository = _FakeInventoryRepository([
        buildItem(id: 'item-1', nameAr: 'صنف 1', nameEn: 'Item 1'),
      ]);
      final container = await buildContainer(repository: repository);
      final wizard = container.read(bulkChangeWizardProvider);

      expect(wizard.step, BulkChangeWizardStep.scope);
      expect(wizard.scope.isSpecific, isFalse);
    });

    test('ينتقل بين الخطوات بالترتيب scope → rule → preview → approval',
        () async {
      final repository = _FakeInventoryRepository([
        buildItem(id: 'item-1', nameAr: 'صنف 1', nameEn: 'Item 1'),
      ]);
      final container = await buildContainer(repository: repository);
      final notifier = container.read(bulkChangeWizardProvider.notifier);

      await notifier.nextStep();
      expect(container.read(bulkChangeWizardProvider).step,
          BulkChangeWizardStep.rule);

      await notifier.nextStep();
      expect(container.read(bulkChangeWizardProvider).step,
          BulkChangeWizardStep.preview);

      await notifier.nextStep();
      expect(container.read(bulkChangeWizardProvider).step,
          BulkChangeWizardStep.approval);
    });

    test('يعيد بناء المعاينة عند الدخول إلى خطوة المعاينة', () async {
      final repository = _FakeInventoryRepository([
        buildItem(id: 'item-1', nameAr: 'صنف 1', nameEn: 'Item 1'),
      ]);
      final container = await buildContainer(repository: repository);
      final notifier = container.read(bulkChangeWizardProvider.notifier);
      final service =
          container.read(bulkPriceChangeServiceProvider) as _FakeBulkService;
      service.previewResult = [
        BulkPriceChangePreviewEntry(
          itemId: 'item-1',
          itemName: 'صنف 1',
          target: BulkPriceTarget.sale,
          previousSalePrice: 100,
          previousPurchasePrice: 80,
          newSalePrice: 110,
          newPurchasePrice: 80,
          isBlocked: false,
          blockReason: null,
        ),
      ];

      notifier.updateRuleValue(10);
      await notifier.nextStep(); // rule
      await notifier.nextStep(); // preview (trigger)

      expect(service.previewCalls.last, contains('10.0'));
      expect(service.previewCalls.last, contains('BulkPriceTarget.sale'));
      expect(service.previewCalls.last, contains('0:'));
      final wizard = container.read(bulkChangeWizardProvider);
      expect(wizard.previewEntries, hasLength(1));
      expect(wizard.previewLoaded, isTrue);
    });

    test('يحفظ النطاق والقاعدة والهدف في الحالة', () async {
      final repository = _FakeInventoryRepository([
        buildItem(id: 'item-1', nameAr: 'صنف 1', nameEn: 'Item 1'),
      ]);
      final container = await buildContainer(repository: repository);
      final notifier = container.read(bulkChangeWizardProvider.notifier);

      notifier.updateScope(const BulkPriceChangeScope.items(['item-1']));
      notifier.updateTarget(BulkPriceTarget.both);
      notifier.updateRuleType(BulkPriceChangeRuleType.fixedAmount);
      notifier.updateRuleValue(5);

      final wizard = container.read(bulkChangeWizardProvider);
      expect(wizard.scope.isSpecific, isTrue);
      expect(wizard.scope.count, 1);
      expect(wizard.target, BulkPriceTarget.both);
      expect(wizard.ruleType, BulkPriceChangeRuleType.fixedAmount);
      expect(wizard.ruleValue, 5);
    });

    test('ينفذ التغيير وينتقل إلى خطوة النجاح عند النجاح', () async {
      final repository = _FakeInventoryRepository([
        buildItem(id: 'item-1', nameAr: 'صنف 1', nameEn: 'Item 1'),
      ]);
      final container = await buildContainer(repository: repository);
      final notifier = container.read(bulkChangeWizardProvider.notifier);
      final service =
          container.read(bulkPriceChangeServiceProvider) as _FakeBulkService;
      service.executeResult =
          OperationResult.success(value: buildRecord(cancelled: false));

      await notifier.execute(operatorName: 'المدير', reason: 'السبب');

      final wizard = container.read(bulkChangeWizardProvider);
      expect(wizard.lastRecord, isNotNull);
      expect(wizard.error, isNull);
      expect(service.executeCalls.last, 'المدير:السبب');
    });

    test('يظهر خطأ التنفيذ دون الانتقال إلى خطوة النجاح عند الفشل', () async {
      final repository = _FakeInventoryRepository([
        buildItem(id: 'item-1', nameAr: 'صنف 1', nameEn: 'Item 1'),
      ]);
      final container = await buildContainer(repository: repository);
      final notifier = container.read(bulkChangeWizardProvider.notifier);
      final service =
          container.read(bulkPriceChangeServiceProvider) as _FakeBulkService;
      service.executeResult =
          const OperationResult<BulkChangeExecutionRecord>.failure(
        message: 'فشل',
      );

      await notifier.execute(operatorName: 'المدير', reason: 'السبب');

      final wizard = container.read(bulkChangeWizardProvider);
      expect(wizard.lastRecord, isNull);
      expect(wizard.error, isNotNull);
    });

    test('يحفظ حالة الإقرار قبل التنفيذ', () async {
      final repository = _FakeInventoryRepository([]);
      final container = await buildContainer(repository: repository);
      final notifier = container.read(bulkChangeWizardProvider.notifier);

      notifier.updateConfirmation(confirmed: true, text: 'أوافق على التحديث');

      final wizard = container.read(bulkChangeWizardProvider);
      expect(wizard.confirmed, isTrue);
      expect(wizard.confirmationText, 'أوافق على التحديث');
    });

    test('يعيد تهيئة المعالج إلى البداية', () async {
      final repository = _FakeInventoryRepository([]);
      final container = await buildContainer(repository: repository);
      final notifier = container.read(bulkChangeWizardProvider.notifier);

      notifier.updateRuleValue(20);
      await notifier.nextStep();
      notifier.reset();

      final wizard = container.read(bulkChangeWizardProvider);
      expect(wizard.step, BulkChangeWizardStep.scope);
      expect(wizard.ruleValue, 0);
    });

    test('يرجع خطوة إلى الوراء عند الحاجة', () async {
      final repository = _FakeInventoryRepository([]);
      final container = await buildContainer(repository: repository);
      final notifier = container.read(bulkChangeWizardProvider.notifier);

      await notifier.nextStep();
      await notifier.nextStep();
      notifier.previousStep();

      expect(
        container.read(bulkChangeWizardProvider).step,
        BulkChangeWizardStep.rule,
      );
    });
  });

  group('نافذة الإلغاء الزمنية', () {
    test('يسمح بالإلغاء داخل نافذة الـ 24 ساعة', () async {
      final repository = _FakeInventoryRepository([
        buildItem(id: 'item-1', nameAr: 'صنف 1', nameEn: 'Item 1'),
      ]);
      final container = await buildContainer(repository: repository);
      final notifier = container.read(bulkChangeWizardProvider.notifier);
      final service =
          container.read(bulkPriceChangeServiceProvider) as _FakeBulkService;

      // تنفيذ ناجح أولًا.
      service.executeResult =
          OperationResult.success(value: buildRecord(cancelled: false));
      await notifier.execute(operatorName: 'المدير', reason: 'السبب');
      expect(
        container.read(bulkChangeWizardProvider).step,
        BulkChangeWizardStep.success,
      );

      final cancellable = await notifier.isExecutionCancellable();
      expect(cancellable, isTrue);

      // إلغاء ناجح: الخدمة تعيد الأصناف المستعادة مع أثر تدقيقي.
      final restoredItem = buildItem(
        id: 'item-1',
        nameAr: 'صنف 1',
        nameEn: 'Item 1',
        salePrice: 100,
        purchasePrice: 80,
      );
      service.cancelResult =
          OperationResult<List<InventoryItem>>.success(value: [restoredItem]);
      await notifier.cancelLastExecution(
        operatorName: 'المدير',
        reason: 'إلغاء',
      );

      final wizard = container.read(bulkChangeWizardProvider);
      expect(wizard.lastRecord?.isCancelled, isTrue);
      expect(service.cancelCalls.last, 'exec-1:المدير:إلغاء');
    });

    test('يرفض الإلغاء بعد انتهاء نافذة الـ 24 ساعة', () async {
      final repository = _FakeInventoryRepository([]);

      // ترحيل الزمن إلى ما بعد نافذة الـ 24 ساعة عبر ProviderScope كامل.
      final lateNowProvider = Provider<DateTime Function()>(
        (ref) => () => DateTime.utc(2026, 8, 16, 12),
      );
      final container = ProviderContainer(
        overrides: [
          inventoryRepositoryProvider.overrideWithValue(repository),
          bulkChangeExecutionStorageProvider
              .overrideWithValue(_FakeBulkChangeExecutionStorage()),
          bulkPriceChangeServiceProvider.overrideWithValue(_FakeBulkService()
            ..executeResult = OperationResult.success(value: buildRecord())),
          bulkChangeNowProvider.overrideWithProvider(lateNowProvider),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(bulkChangeWizardProvider.notifier);
      await notifier.execute(operatorName: 'المدير', reason: 'السبب');

      final cancellable = await notifier.isExecutionCancellable();
      expect(cancellable, isFalse);
    });

    test('يسجل حدث الإلغاء في أثر التدقيق عند إلغاء سجل', () async {
      final repository = _FakeInventoryRepository([
        buildItem(id: 'item-1', nameAr: 'صنف 1', nameEn: 'Item 1'),
      ]);
      final container = await buildContainer(repository: repository);
      final notifier = container.read(bulkChangeWizardProvider.notifier);
      final service =
          container.read(bulkPriceChangeServiceProvider) as _FakeBulkService;

      service.executeResult = OperationResult.success(value: buildRecord());
      await notifier.execute(operatorName: 'المدير', reason: 'السبب');

      final restoredItem = buildItem(
        id: 'item-1',
        nameAr: 'صنف 1',
        nameEn: 'Item 1',
      );
      service.cancelResult = OperationResult<List<InventoryItem>>.success(
        value: [restoredItem],
      );
      await notifier.cancelLastExecution(
        operatorName: 'المدير',
        reason: 'إلغاء',
      );

      final wizard = container.read(bulkChangeWizardProvider);
      expect(wizard.lastRecord?.cancellation, isNotNull);
      expect(
        wizard.lastRecord?.cancellation?.type,
        AuditEventType.cancelled,
      );
    });

    test('يحدث المخزون بعد إلغاء ناجح عبر إبطال مزود الأصناف', () async {
      final repository = _FakeInventoryRepository([
        buildItem(id: 'item-1', nameAr: 'صنف 1', nameEn: 'Item 1'),
      ]);
      final container = await buildContainer(repository: repository);
      final notifier = container.read(bulkChangeWizardProvider.notifier);
      final service =
          container.read(bulkPriceChangeServiceProvider) as _FakeBulkService;

      service.executeResult = OperationResult.success(value: buildRecord());
      await notifier.execute(operatorName: 'المدير', reason: 'السبب');

      final restoredItem = buildItem(
        id: 'item-1',
        nameAr: 'صنف 1',
        nameEn: 'Item 1',
      );
      service.cancelResult =
          OperationResult<List<InventoryItem>>.success(value: [restoredItem]);
      await notifier.cancelLastExecution(
        operatorName: 'المدير',
        reason: 'إلغاء',
      );

      final wizard = container.read(bulkChangeWizardProvider);
      expect(wizard.lastRecord?.isCancelled, isTrue);
      expect(wizard.error, isNull);
    });
  });
}
