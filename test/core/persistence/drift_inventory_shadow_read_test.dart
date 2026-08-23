import 'package:basir_accounting_system/core/persistence/drift_inventory_shadow_read.dart';
import 'package:basir_accounting_system/core/persistence/drift_settings_shadow_read.dart';
import 'package:basir_accounting_system/core/persistence/drift_providers.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/inventory_item.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/warehouse.dart';
import 'package:basir_accounting_system/features/inventory/domain/repositories/warehouse_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('inventory shadow-read defaults', () {
    test('all inventory slice flags are closed by default', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        container.read(driftWarehousesShadowReadEnabledProvider),
        isFalse,
      );
      expect(
        container.read(driftInventoryItemsShadowReadEnabledProvider),
        isFalse,
      );
      expect(
        container.read(driftStockMovementsShadowReadEnabledProvider),
        isFalse,
      );
    });
  });

  group('DriftInventoryShadowReadComparator', () {
    test('records mismatch without payload or user identity', () async {
      final events = <DriftShadowReadEvent>[];
      final comparator = DriftInventoryShadowReadComparator(
        recorder: (event) async => events.add(event),
        clock: () => DateTime.utc(2026, 8, 23, 12),
      );

      final result = await comparator.compareInventoryItems(
        operation: 'getAllItems',
        sourceRead: () async => [_inventoryItem(nameAr: 'المصدر')],
        candidateRead: () async => [_inventoryItem(nameAr: 'المرشح')],
      );

      expect(result.outcome, DriftShadowReadOutcome.mismatch);
      expect(events, hasLength(1));
      expect(events.single.slice, 'inventory-items');
      expect(events.single.operation, 'getAllItems');
      expect(events.single.recordedAt, DateTime.utc(2026, 8, 23, 12));
      expect(events.single.toString(), isNot(contains('المصدر')));
      expect(events.single.toString(), isNot(contains('user-1')));
    });
  });

  group('ShadowReadWarehouseRepository', () {
    test('disabled mode returns source and never reads candidate', () async {
      final source = _FakeWarehouseRepository([_warehouse('source')]);
      final candidate = _FakeWarehouseRepository([_warehouse('candidate')]);
      final sink = InMemoryDriftShadowReadSink();
      final repository = ShadowReadWarehouseRepository(
        source: source,
        candidate: candidate,
        comparator: DriftInventoryShadowReadComparator(recorder: sink.record),
        enabled: false,
      );

      final result = await repository.getAllWarehouses();

      expect(result.single.nameAr, 'source');
      expect(candidate.readCount, 0);
      expect(sink.events, isEmpty);
    });

    test('enabled mode still returns source and delegates writes to source',
        () async {
      final source = _FakeWarehouseRepository([_warehouse('source')]);
      final candidate = _FakeWarehouseRepository([_warehouse('candidate')]);
      final sink = InMemoryDriftShadowReadSink();
      final repository = ShadowReadWarehouseRepository(
        source: source,
        candidate: candidate,
        comparator: DriftInventoryShadowReadComparator(recorder: sink.record),
        enabled: true,
      );

      final result = await repository.getAllWarehouses();
      await repository.addWarehouse(_warehouse('new'));

      expect(result.single.nameAr, 'source');
      expect(candidate.readCount, 1);
      expect(sink.events.single.outcome, DriftShadowReadOutcome.mismatch);
      expect(source.writeCount, 1);
      expect(candidate.writeCount, 0);
    });
  });
}

Warehouse _warehouse(String name) => Warehouse(
      id: name,
      nameAr: name,
      nameEn: name,
      createdAt: DateTime.utc(2026, 8, 23),
      updatedAt: DateTime.utc(2026, 8, 23),
      userId: 'user-1',
    );

InventoryItem _inventoryItem({required String nameAr}) => InventoryItem(
      id: 'item-1',
      nameAr: nameAr,
      nameEn: 'Item',
      createdAt: DateTime.utc(2026, 8, 23),
      updatedAt: DateTime.utc(2026, 8, 23),
      userId: 'user-1',
    );

class _FakeWarehouseRepository implements WarehouseRepository {
  _FakeWarehouseRepository(this.values);

  final List<Warehouse> values;
  int readCount = 0;
  int writeCount = 0;

  @override
  Future<List<Warehouse>> getAllWarehouses() async {
    readCount += 1;
    return values;
  }

  @override
  Future<Warehouse?> getWarehouseById(String id) async {
    readCount += 1;
    return values.where((value) => value.id == id).firstOrNull;
  }

  @override
  Future<void> addWarehouse(Warehouse warehouse) async {
    writeCount += 1;
  }

  @override
  Future<void> updateWarehouse(Warehouse warehouse) async {
    writeCount += 1;
  }

  @override
  Future<void> deleteWarehouse(String id) async {
    writeCount += 1;
  }
}
