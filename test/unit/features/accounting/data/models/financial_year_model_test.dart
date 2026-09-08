import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:basir_accounting_system/features/accounting/data/models/financial_year_model.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_year.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final start = DateTime.utc(2026);
  final end = DateTime.utc(2026, 12, 31, 23, 59, 59);
  final closedAt = DateTime.utc(2027, 1, 5);
  final syncedAt = DateTime.utc(2027, 1, 6);

  FinancialYear fixture() => FinancialYear(
        id: 'fy-2026',
        name: 'السنة المالية 2026',
        startDate: start,
        endDate: end,
        isClosed: true,
        closedAt: closedAt,
        closedBy: 'controller-1',
        lockedPeriodIds: const ['2026-01', '2026-12'],
        userId: 'tenant-1',
        syncStatus: SyncStatus.pendingPush,
        serverUpdatedAt: syncedAt,
        isDeleted: true,
      );

  group('FinancialYearModel', () {
    test('round-trips all audit and synchronization fields without aliases',
        () {
      final entity = fixture();
      final model = FinancialYearModel.fromEntity(entity);

      expect(model.id, entity.id);
      expect(model.name, entity.name);
      expect(model.startDate, start);
      expect(model.endDate, end);
      expect(model.isClosed, isTrue);
      expect(model.closedAt, closedAt);
      expect(model.closedBy, 'controller-1');
      expect(model.lockedPeriodIds, ['2026-01', '2026-12']);
      expect(model.userId, 'tenant-1');
      expect(model.syncStatus, SyncStatus.pendingPush);
      expect(model.serverUpdatedAt, syncedAt);
      expect(model.isDeleted, isTrue);

      model.lockedPeriodIds.add('2027-01');

      expect(entity.lockedPeriodIds, ['2026-01', '2026-12']);
      expect(model.toEntity(), isNot(same(entity)));
      expect(model.toEntity().lockedPeriodIds, contains('2027-01'));
    });

    test('serializes financial year state and applies temporal boundaries', () {
      final entity = fixture();

      final restored = FinancialYear.fromJson(entity.toJson());

      expect(restored, entity);
      expect(restored.isValid, isTrue);
      expect(restored.containsDate(start), isTrue);
      expect(restored.containsDate(end), isTrue);
      expect(restored.containsDate(DateTime.utc(2025, 12, 31)), isFalse);
      expect(restored.containsDate(DateTime.utc(2027)), isFalse);
    });
  });
}
