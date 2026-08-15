library;

import 'package:basir_accounting_system/core/domain/contracts/audit_entry.dart';
import 'package:basir_accounting_system/core/domain/contracts/operation_result.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/bulk_price_change.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/inventory_item.dart';
import 'package:basir_accounting_system/features/inventory/domain/repositories/inventory_repository.dart';

/// عقد تخزين سجلات تنفيذ تغيير الأسعار الجماعي.
///
/// تُحفظ سجلات التنفيذ لإتاحة الإلغاء الزماني الموثق: يُسترجع كل سجل
/// لمعرفة القيم السابقة، ثم يُوثق حدث الإلغاء في مستودع التخزين.
abstract class BulkChangeExecutionStorage {
  /// يحفظ سجل التنفيذ ويعيده مع المعرف المولد عند الحاجة.
  Future<BulkChangeExecutionRecord> save(BulkChangeExecutionRecord record);

  /// يجلب سجل التنفيذ بواسطة معرّفه.
  Future<BulkChangeExecutionRecord?> fetch(String id);

  /// يوثق حدث الإلغاء المرافق لسجل التنفيذ.
  Future<void> markCancelled(String id, AuditEntry cancellation);
}

/// خدمة تغيير الأسعار الجماعي.
///
/// تفصل المعاينة عن التنفيذ: تُبنى قائمة [BulkPriceChangePreviewEntry]
/// أولًا لعرض الأثر قبل أي تغيير، ولا يسري السعر الجديد إلا عبر
/// [execute] بسبب موثق، ويبقى لكل صنف أثره التدقيقي الأصلي.
class BulkPriceChangeService {
  /// يبني الخدمة بمستودع أصناف ومستودع تنفيذ وساعة قابلة للحقن.
  BulkPriceChangeService({
    required InventoryRepository repository,
    required BulkChangeExecutionStorage storage,
    DateTime Function()? now,
  })  : _repository = repository,
        _storage = storage,
        _now = now ?? DateTime.now;

  /// رمز فشل عند نطاق بلا أصناف مشمولة.
  static const emptyScopeCode = 'bulk_price_change_empty_scope';

  /// رمز فشل عند قاعدة غير صالحة.
  static const invalidRuleCode = 'bulk_price_change_invalid_rule';

  /// رمز فشل عند سعر سالب ناتج عن القاعدة.
  static const negativeResultCode = 'bulk_price_change_negative_result';

  /// رمز فشل عند غياب سبب الاعتماد.
  static const emptyReasonCode = 'bulk_price_change_reason_required';

  /// رمز فشل عند غياب هوية منفذ العملية.
  static const operatorRequiredCode =
      'bulk_price_change_operator_required';

  /// رمز فشل عند غياب سجل التنفيذ.
  static const executionNotFoundCode = 'bulk_price_change_execution_not_found';

  /// رمز فشل عند انقضاء نافذة الإلغاء.
  static const cancellationExpiredCode =
      'bulk_price_change_cancellation_expired';

  /// رمز فشل ثابت عند تعذر الحفظ.
  static const commitFailedCode = 'bulk_price_change_commit_failed';

  final InventoryRepository _repository;
  final BulkChangeExecutionStorage _storage;
  final DateTime Function() _now;

  /// يبني معاينة أثر القاعدة على نطاق الأصناف دون أي تغيير.
  Future<OperationResult<List<BulkPriceChangePreviewEntry>>> preview({
    required BulkPriceChangeScope scope,
    required BulkPriceChangeRule rule,
    required BulkPriceTarget target,
  }) async {
    final ruleFailure = _validateRule(rule);
    if (ruleFailure != null) {
      return OperationResult.failure(message: ruleFailure);
    }

    final items = await _allActiveItems();
    final selected = _selectItems(items, scope);
    if (selected.isEmpty) {
      return const OperationResult.failure(message: emptyScopeCode);
    }

    final entries = <BulkPriceChangePreviewEntry>[];
    for (final item in selected) {
      entries.add(_previewForItem(item, rule, target));
    }
    return OperationResult.success(value: entries);
  }

  /// ينفذ قاعدة المعتمدة على المعاينة المعروضة مع سبب موثق.
  ///
  /// يعيد سجل التنفيذ الموثق مع سجل تدقيق شامل، أو فشلًا دون أثر جانبي
  /// عند تعذر الحفظ.
  Future<OperationResult<BulkChangeExecutionRecord>> execute({
    required List<BulkPriceChangePreviewEntry> preview,
    required BulkPriceChangeRule rule,
    required BulkPriceChangeScope scope,
    required BulkPriceTarget target,
    required String operatorName,
    required String reason,
  }) async {
    if (operatorName.trim().isEmpty) {
      return const OperationResult.failure(message: operatorRequiredCode);
    }
    if (reason.trim().isEmpty) {
      return const OperationResult.failure(message: emptyReasonCode);
    }

    final current = await _allActiveItems();
    final currentById = {for (final item in current) item.id: item};
    final selectedIds = scope.isSpecific ? scope.specificItemIds! :
        current.map((e) => e.id).toList(growable: false);
    final previousByItemId = <String, BulkPriceChangePreviewEntry>{};
    for (final entry in preview) {
      previousByItemId[entry.itemId] = entry;
    }

    final committed = <InventoryItem>[];
    final affected = <String>[];
    for (final itemId in selectedIds) {
      final existing = currentById[itemId];
      if (existing == null || existing.isDeleted) continue;

      final updated = _applyRule(existing, rule, target);
      if (updated == null) continue;
      committed.add(updated);
      affected.add(itemId);
    }

    try {
      for (final updated in committed) {
        await _repository.updateItem(updated);
      }

      final recordedAt = _now();
      final recordId = _recordId();
      final record = BulkChangeExecutionRecord(
        id: recordId,
        operatorName: operatorName.trim(),
        executedAt: recordedAt,
        reason: reason.trim(),
        rule: rule,
        scopeItemIds: List.unmodifiable(selectedIds),
        affectedItemIds: List.unmodifiable(affected),
        previousValues: List.unmodifiable(
            previousByItemId.values.toList(growable: false)),
        auditTrail: [
          AuditEntry(
            type: AuditEventType.administrative,
            operatorName: operatorName.trim(),
            occurredAt: recordedAt,
            reason: reason.trim(),
            referenceId: recordId,
          ),
        ],
        effectiveAt: rule.effectiveAt,
      );
      await _storage.save(record);

      return OperationResult.success(value: record);
    } on Object catch (error) {
      return OperationResult.failure(message: commitFailedCode, cause: error);
    }
  }

  /// يعيد الأسعار السابقة لسجل التنفيذ مع حدث إلغاء موثق.
  ///
  /// مسموح به فقط داخل نافذة الإلغاء الافتراضية (24 ساعة من التنفيذ).
  Future<OperationResult<List<InventoryItem>>> cancel({
    required String recordId,
    required String operatorName,
    required String reason,
  }) async {
    if (operatorName.trim().isEmpty) {
      return const OperationResult.failure(message: operatorRequiredCode);
    }

    final record = await _storage.fetch(recordId);
    if (record == null) {
      return const OperationResult.failure(message: executionNotFoundCode);
    }
    if (!record.isCancellableAt(_now())) {
      return const OperationResult.failure(message: cancellationExpiredCode);
    }

    final previousByItemId = <String, BulkPriceChangePreviewEntry>{};
    for (final previous in record.previousValues) {
      previousByItemId[previous.itemId] = previous;
    }

    final restored = <InventoryItem>[];
    for (final itemId in record.affectedItemIds) {
      final existing = await _repository.getItemById(itemId);
      final previous = previousByItemId[itemId];
      if (existing == null || existing.isDeleted || previous == null) continue;

      restored.add(existing.copyWith(
        salePrice: previous.previousSalePrice,
        purchasePrice: previous.previousPurchasePrice,
        updatedAt: _now(),
      ));
    }

    try {
      for (final restoredItem in restored) {
        await _repository.updateItem(restoredItem);
      }

      final cancelledAt = _now();
      await _storage.markCancelled(
        recordId,
        AuditEntry(
          type: AuditEventType.cancelled,
          operatorName: operatorName.trim(),
          occurredAt: cancelledAt,
          reason: reason.trim(),
          referenceId: recordId,
        ),
      );
      return OperationResult.success(
        value: restored,
        auditTrail: [
          AuditEntry(
            type: AuditEventType.cancelled,
            operatorName: operatorName.trim(),
            occurredAt: cancelledAt,
            reason: reason.trim(),
            referenceId: recordId,
          ),
        ],
      );
    } on Object catch (error) {
      return OperationResult.failure(message: commitFailedCode, cause: error);
    }
  }

  Future<List<InventoryItem>> _allActiveItems() async =>
      (await _repository.getAllItems())
          .where((item) => !item.isDeleted)
          .toList(growable: false);

  List<InventoryItem> _selectItems(
          List<InventoryItem> items, BulkPriceChangeScope scope) =>
      scope.isSpecific
          ? items
              .where((item) => scope.specificItemIds!.contains(item.id))
              .toList(growable: false)
          : items;

  String? _validateRule(BulkPriceChangeRule rule) {
    switch (rule.type) {
      case BulkPriceChangeRuleType.copyFromPurchase:
        if (rule.sourcePrice == null) return invalidRuleCode;
        break;
      case BulkPriceChangeRuleType.percentage:
      case BulkPriceChangeRuleType.fixedAmount:
        if (!rule.value.isFinite) return invalidRuleCode;
        break;
      case BulkPriceChangeRuleType.setTo:
        if (!rule.value.isFinite || rule.value < 0) return negativeResultCode;
        break;
    }
    return null;
  }

  BulkPriceChangePreviewEntry _previewForItem(
    InventoryItem item,
    BulkPriceChangeRule rule,
    BulkPriceTarget target,
  ) {
    switch (rule.type) {
      case BulkPriceChangeRuleType.percentage:
        return _applyPercentage(item, rule, target);
      case BulkPriceChangeRuleType.fixedAmount:
        return _applyFixed(item, rule, target);
      case BulkPriceChangeRuleType.setTo:
        return _applySetTo(item, rule, target);
      case BulkPriceChangeRuleType.copyFromPurchase:
        return _applyCopy(item, rule, target);
    }
  }

  BulkPriceChangePreviewEntry _applyPercentage(
    InventoryItem item,
    BulkPriceChangeRule rule,
    BulkPriceTarget target,
  ) {
    final factor = 1 + rule.value / 100;
    final sale = _scaled(item.salePrice, factor, target);
    final purchase = _scaled(item.purchasePrice, factor, target);
    return _buildEntry(item, target, sale, purchase);
  }

  BulkPriceChangePreviewEntry _applyFixed(
    InventoryItem item,
    BulkPriceChangeRule rule,
    BulkPriceTarget target,
  ) {
    final sale = _shifted(item.salePrice, rule.value, target);
    final purchase = _shifted(item.purchasePrice, rule.value, target);
    return _buildEntry(item, target, sale, purchase);
  }

  BulkPriceChangePreviewEntry _applySetTo(
    InventoryItem item,
    BulkPriceChangeRule rule,
    BulkPriceTarget target,
  ) {
    double? sale = item.salePrice;
    double? purchase = item.purchasePrice;
    if (target == BulkPriceTarget.sale || target == BulkPriceTarget.both) {
      sale = rule.value;
    }
    if (target == BulkPriceTarget.purchase || target == BulkPriceTarget.both) {
      purchase = rule.value;
    }
    return _buildEntry(item, target, sale, purchase);
  }

  BulkPriceChangePreviewEntry _applyCopy(
    InventoryItem item,
    BulkPriceChangeRule rule,
    BulkPriceTarget target,
  ) {
    final source = rule.sourcePrice == BulkPriceSource.sale
        ? item.salePrice
        : item.purchasePrice;
    double? sale = item.salePrice;
    double? purchase = item.purchasePrice;
    if (target == BulkPriceTarget.sale || target == BulkPriceTarget.both) {
      sale = source;
    }
    if (target == BulkPriceTarget.purchase || target == BulkPriceTarget.both) {
      purchase = source;
    }
    return _buildEntry(item, target, sale, purchase);
  }

  double? _scaled(double? base, double factor, BulkPriceTarget target) {
    if (!_appliesTo(base, target)) return base;
    return _roundCents(base! * factor);
  }

  double? _shifted(double? base, double delta, BulkPriceTarget target) {
    if (!_appliesTo(base, target)) return base;
    return _roundCents(base! + delta);
  }

  /// يقرب النتيجة إلى أقرب فلس ( منزلتين عشريتين) لتفادي أخطاء الحساب
  /// العائمة مثل 110.00000000000001 في الأسعار المئوية.
  double _roundCents(double value) =>
      (value * 100).roundToDouble() / 100;

  bool _appliesTo(double? base, BulkPriceTarget target) {
    if (base == null) return false;
    switch (target) {
      case BulkPriceTarget.sale:
        return true;
      case BulkPriceTarget.purchase:
        return true;
      case BulkPriceTarget.both:
        return true;
    }
  }

  BulkPriceChangePreviewEntry _buildEntry(
    InventoryItem item,
    BulkPriceTarget target,
    double? newSale,
    double? newPurchase,
  ) {
    final blocked = (newSale != null && newSale < 0) ||
        (newPurchase != null && newPurchase < 0) ||
        _missingTargetPrice(item, target, newSale, newPurchase);
    return BulkPriceChangePreviewEntry(
      itemId: item.id,
      itemName: item.name(isArabic: true),
      target: target,
      previousSalePrice: item.salePrice,
      newSalePrice: newSale,
      previousPurchasePrice: item.purchasePrice,
      newPurchasePrice: newPurchase,
      isBlocked: blocked,
      blockReason: blocked ? _blockReason(item, target) : null,
    );
  }

  /// يحدد الأصناف التي لا تحوي سعرًا يستهدفه التغيير.
  ///
  /// الأصناف دون سعر بيع عند استهداف البيع، أو دون سعرين عند الاستهداف
  /// المزدوج، لا يمكن أن يُنتج التغيير سعرًا جديدًا لها.
  bool _missingTargetPrice(
    InventoryItem item,
    BulkPriceTarget target,
    double? newSale,
    double? newPurchase,
  ) {
    switch (target) {
      case BulkPriceTarget.sale:
        return newSale == null;
      case BulkPriceTarget.purchase:
        return newPurchase == null;
      case BulkPriceTarget.both:
        return newSale == null && newPurchase == null;
    }
  }

  String _blockReason(InventoryItem item, BulkPriceTarget target) {
    final missingSale = item.salePrice == null;
    final missingPurchase = item.purchasePrice == null;
    switch (target) {
      case BulkPriceTarget.sale:
        return missingSale
            ? 'الصنف لا يملك سعر بيع قابلًا للتغيير.'
            : 'القاعدة تنتج سعرًا سالبًا لهذا الصنف.';
      case BulkPriceTarget.purchase:
        return missingPurchase
            ? 'الصنف لا يملك سعر شراء قابلًا للتغيير.'
            : 'القاعدة تنتج سعرًا سالبًا لهذا الصنف.';
      case BulkPriceTarget.both:
        if (missingSale && missingPurchase) {
          return 'الصنف لا يملك سعر بيع أو شراء قابلًا للتغيير.';
        }
        return 'القاعدة تنتج سعرًا سالبًا لهذا الصنف.';
    }
  }

  /// يطبق القاعدة على صنف ويرجع نسخة معدلة أو لا شيء عند الإغلاق.
  ///
  /// لا يغيّر الأسعار إلا في المواضع المستهدفة من القاعدة، ويُبقي باقي
  /// الحقول (سعر الشراء أو البيع غير المستهدف، الكمية، تاريخ الإنشاء)
  /// كما هي في النسخة الأصلية.
  InventoryItem? _applyRule(
    InventoryItem item,
    BulkPriceChangeRule rule,
    BulkPriceTarget target,
  ) {
    final preview = _previewForItem(item, rule, target);
    if (preview.isBlocked == true) return null;
    double? sale = item.salePrice;
    double? purchase = item.purchasePrice;
    switch (target) {
      case BulkPriceTarget.sale:
        sale = preview.newSalePrice;
        break;
      case BulkPriceTarget.purchase:
        purchase = preview.newPurchasePrice;
        break;
      case BulkPriceTarget.both:
        sale = preview.newSalePrice;
        purchase = preview.newPurchasePrice;
        break;
    }
    return item.copyWith(
      salePrice: sale,
      purchasePrice: purchase,
      updatedAt: _now(),
    );
  }

  String _recordId() => 'bulk-change-${_now().toUtc().toIso8601String()}';
}
