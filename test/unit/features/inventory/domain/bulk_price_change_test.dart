import 'package:flutter_test/flutter_test.dart';

import 'package:basir_accounting_system/core/domain/contracts/audit_entry.dart';
import 'package:basir_accounting_system/features/inventory/data/models/bulk_price_change_execution_model.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/bulk_price_change.dart';

AuditEntry _auditEntry({
  AuditEventType type = AuditEventType.administrative,
  String reason = 'approved bulk price change',
}) => AuditEntry(
      type: type,
      operatorName: 'operator-1',
      occurredAt: DateTime.utc(2026, 8, 27, 12),
      reason: reason,
      referenceId: 'bulk-change-1',
    );

BulkPriceChangePreviewEntry _preview({
  double? newSalePrice = 15.0,
  double? newPurchasePrice = 9.0,
  bool? isBlocked,
  String? blockReason,
}) => BulkPriceChangePreviewEntry(
      itemId: 'item-1',
      itemName: 'Test item',
      target: BulkPriceTarget.both,
      previousSalePrice: 12.0,
      newSalePrice: newSalePrice,
      previousPurchasePrice: 8.0,
      newPurchasePrice: newPurchasePrice,
      isBlocked: isBlocked,
      blockReason: blockReason,
    );

BulkChangeExecutionRecord _record({AuditEntry? cancellation}) {
  final executedAt = DateTime.utc(2026, 8, 27, 12);
  return BulkChangeExecutionRecord(
    id: 'bulk-change-1',
    operatorName: 'operator-1',
    executedAt: executedAt,
    reason: 'approved bulk price change',
    rule: BulkPriceChangeRule(
      type: BulkPriceChangeRuleType.percentage,
      value: 12.5,
      effectiveAt: DateTime.utc(2026, 9, 1),
      sourcePrice: BulkPriceSource.sale,
    ),
    scopeItemIds: const ['item-1', 'item-2'],
    affectedItemIds: const ['item-1'],
    previousValues: [_preview()],
    auditTrail: [_auditEntry()],
    effectiveAt: DateTime.utc(2026, 9, 1),
    cancellation: cancellation,
  );
}

void main() {
  group('BulkPriceChangeScope', () {
    test('supports all and selected scopes with JSON round trips', () {
      const all = BulkPriceChangeScope.all();
      const selected = BulkPriceChangeScope.items(['item-1', 'item-2']);

      expect(all.isSpecific, isFalse);
      expect(all.count, 0);
      expect(all.toString(), 'BulkPriceChangeScope.all()');
      expect(BulkPriceChangeScope.fromJson(all.toJson()), all);
      expect(selected.isSpecific, isTrue);
      expect(selected.count, 2);
      expect(selected.toString(), 'BulkPriceChangeScope.items(2)');
      expect(BulkPriceChangeScope.fromJson(selected.toJson()), selected);
    });
  });

  group('BulkPriceChangeRule', () {
    test('round trips every rule type and optional fields', () {
      final effectiveAt = DateTime.utc(2026, 9, 1);
      final rules = [
        const BulkPriceChangeRule(
          type: BulkPriceChangeRuleType.percentage,
          value: 10,
        ),
        const BulkPriceChangeRule(
          type: BulkPriceChangeRuleType.fixedAmount,
          value: -2.5,
        ),
        BulkPriceChangeRule(
          type: BulkPriceChangeRuleType.setTo,
          value: 25,
          effectiveAt: effectiveAt,
        ),
        const BulkPriceChangeRule(
          type: BulkPriceChangeRuleType.copyFromPurchase,
          value: 0,
          sourcePrice: BulkPriceSource.purchase,
        ),
      ];

      for (final rule in rules) {
        expect(BulkPriceChangeRule.fromJson(rule.toJson()), rule);
        expect(rule.toString(), contains(rule.type.name));
      }
    });
  });

  group('BulkPriceChangePreviewEntry', () {
    test('detects negative results and round trips optional values', () {
      final positive = _preview();
      final negative = _preview(newSalePrice: -1, newPurchasePrice: null);
      final blocked = _preview(
        isBlocked: true,
        blockReason: 'price policy',
      );

      expect(positive.hasNegativeResult, isFalse);
      expect(negative.hasNegativeResult, isTrue);
      expect(BulkPriceChangePreviewEntry.fromJson(positive.toJson()), positive);
      expect(BulkPriceChangePreviewEntry.fromJson(blocked.toJson()), blocked);
      expect(positive.toString(), contains('item-1'));
    });
  });

  group('BulkChangeExecutionRecord', () {
    test('round trips JSON and exposes cancellation state', () {
      final record = _record();
      final restored = BulkChangeExecutionRecord.fromJson(record.toJson());
      final beforeDeadline = record.cancellationDeadline.subtract(
        const Duration(minutes: 1),
      );
      final afterDeadline = record.cancellationDeadline.add(
        const Duration(minutes: 1),
      );

      expect(restored, record);
      expect(record.isCancelled, isFalse);
      expect(record.isCancellableAt(beforeDeadline), isTrue);
      expect(record.isCancellableAt(afterDeadline), isFalse);
      expect(record.toString(), contains('bulk-change-1'));
      expect(record.cancellationDeadline, record.executedAt.add(const Duration(hours: 24)));
    });

    test('preserves a cancellation audit entry in JSON', () {
      final cancelled = _record(
        cancellation: _auditEntry(
          type: AuditEventType.cancelled,
          reason: 'operator requested rollback',
        ),
      );
      final restored = BulkChangeExecutionRecord.fromJson(cancelled.toJson());

      expect(cancelled.isCancelled, isTrue);
      expect(restored.isCancelled, isTrue);
      expect(restored.cancellation, cancelled.cancellation);
    });
  });

  test('maps an execution record through the Isar model', () {
    final record = _record();
    final model = BulkPriceChangeExecutionModel.fromRecord(record);
    final restored = model.toRecord();

    expect(model.id, record.id);
    expect(model.operatorName, record.operatorName);
    expect(model.executedAt, record.executedAt);
    expect(model.reason, record.reason);
    expect(model.effectiveAt, record.effectiveAt);
    expect(model.cancellationDeadline, record.cancellationDeadline);
    expect(model.cancelledAt, isNull);
    expect(model.createdAt, isNotNull);
    expect(restored, record);
  });
}
