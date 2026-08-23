import 'package:basir_accounting_system/core/persistence/drift_settings_shadow_read.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/inventory_item.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/stock_movement.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/warehouse.dart';
import 'package:basir_accounting_system/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:basir_accounting_system/features/inventory/domain/repositories/stock_movement_repository.dart';
import 'package:basir_accounting_system/features/inventory/domain/repositories/warehouse_repository.dart';

/// Comparator تشخيصي لشريحة المخزون.
///
/// لا يسجل payload أو userId، ولا يغير القيمة التي تعيدها قراءة المصدر.
/// أي خطأ في المصدر أو المرشح يتحول إلى outcome آمن فقط.
class DriftInventoryShadowReadComparator {
  DriftInventoryShadowReadComparator({
    required DriftShadowReadRecorder recorder,
    DateTime Function()? clock,
  })  : _recorder = recorder,
        _clock = clock ?? DateTime.now;

  final DriftShadowReadRecorder _recorder;
  final DateTime Function() _clock;

  Future<DriftShadowReadResult> compareWarehouses({
    required String operation,
    required Future<List<Warehouse>> Function() sourceRead,
    required Future<List<Warehouse>> Function() candidateRead,
  }) =>
      _compareLists(
        slice: 'warehouses',
        operation: operation,
        sourceRead: sourceRead,
        candidateRead: candidateRead,
        equals: _warehouseListsEqual,
      );

  Future<DriftShadowReadResult> compareWarehouse({
    required String operation,
    required Future<Warehouse?> Function() sourceRead,
    required Future<Warehouse?> Function() candidateRead,
  }) =>
      _compareNullable(
        slice: 'warehouses',
        operation: operation,
        sourceRead: sourceRead,
        candidateRead: candidateRead,
        equals: _warehouseEqual,
      );

  Future<DriftShadowReadResult> compareInventoryItems({
    required String operation,
    required Future<List<InventoryItem>> Function() sourceRead,
    required Future<List<InventoryItem>> Function() candidateRead,
  }) =>
      _compareLists(
        slice: 'inventory-items',
        operation: operation,
        sourceRead: sourceRead,
        candidateRead: candidateRead,
        equals: _inventoryItemListsEqual,
      );

  Future<DriftShadowReadResult> compareInventoryItem({
    required String operation,
    required Future<InventoryItem?> Function() sourceRead,
    required Future<InventoryItem?> Function() candidateRead,
  }) =>
      _compareNullable(
        slice: 'inventory-items',
        operation: operation,
        sourceRead: sourceRead,
        candidateRead: candidateRead,
        equals: _inventoryItemEqual,
      );

  Future<DriftShadowReadResult> compareStockMovements({
    required String operation,
    required Future<List<StockMovement>> Function() sourceRead,
    required Future<List<StockMovement>> Function() candidateRead,
  }) =>
      _compareLists(
        slice: 'stock-movements',
        operation: operation,
        sourceRead: sourceRead,
        candidateRead: candidateRead,
        equals: _stockMovementListsEqual,
      );

  Future<DriftShadowReadResult> compareStockLevel({
    required String operation,
    required Future<double> Function() sourceRead,
    required Future<double> Function() candidateRead,
  }) =>
      _compareValues(
        slice: 'stock-movements',
        operation: operation,
        sourceRead: sourceRead,
        candidateRead: candidateRead,
        equals: _sameDouble,
      );

  Future<DriftShadowReadResult> _compareLists<T>({
    required String slice,
    required String operation,
    required Future<List<T>> Function() sourceRead,
    required Future<List<T>> Function() candidateRead,
    required bool Function(List<T>, List<T>) equals,
  }) async {
    late final List<T> source;
    try {
      source = await sourceRead();
    } on Object {
      return _record(
        slice: slice,
        operation: operation,
        outcome: DriftShadowReadOutcome.sourceError,
      );
    }

    late final List<T> candidate;
    try {
      candidate = await candidateRead();
    } on Object {
      return _record(
        slice: slice,
        operation: operation,
        outcome: DriftShadowReadOutcome.candidateError,
      );
    }

    return _record(
      slice: slice,
      operation: operation,
      outcome: equals(source, candidate)
          ? DriftShadowReadOutcome.match
          : DriftShadowReadOutcome.mismatch,
    );
  }

  Future<DriftShadowReadResult> _compareNullable<T>({
    required String slice,
    required String operation,
    required Future<T?> Function() sourceRead,
    required Future<T?> Function() candidateRead,
    required bool Function(T, T) equals,
  }) async {
    late final T? source;
    try {
      source = await sourceRead();
    } on Object {
      return _record(
        slice: slice,
        operation: operation,
        outcome: DriftShadowReadOutcome.sourceError,
      );
    }

    late final T? candidate;
    try {
      candidate = await candidateRead();
    } on Object {
      return _record(
        slice: slice,
        operation: operation,
        outcome: DriftShadowReadOutcome.candidateError,
      );
    }

    final matches = source == null || candidate == null
        ? source == null && candidate == null
        : equals(source, candidate);
    return _record(
      slice: slice,
      operation: operation,
      outcome: matches
          ? DriftShadowReadOutcome.match
          : DriftShadowReadOutcome.mismatch,
    );
  }

  Future<DriftShadowReadResult> _compareValues<T>({
    required String slice,
    required String operation,
    required Future<T> Function() sourceRead,
    required Future<T> Function() candidateRead,
    required bool Function(T, T) equals,
  }) async {
    late final T source;
    try {
      source = await sourceRead();
    } on Object {
      return _record(
        slice: slice,
        operation: operation,
        outcome: DriftShadowReadOutcome.sourceError,
      );
    }

    late final T candidate;
    try {
      candidate = await candidateRead();
    } on Object {
      return _record(
        slice: slice,
        operation: operation,
        outcome: DriftShadowReadOutcome.candidateError,
      );
    }

    return _record(
      slice: slice,
      operation: operation,
      outcome: equals(source, candidate)
          ? DriftShadowReadOutcome.match
          : DriftShadowReadOutcome.mismatch,
    );
  }

  Future<DriftShadowReadResult> _record({
    required String slice,
    required String operation,
    required DriftShadowReadOutcome outcome,
  }) async {
    final recordedAt = _clock().toUtc();
    await _recorder(
      DriftShadowReadEvent(
        slice: slice,
        operation: operation,
        outcome: outcome,
        recordedAt: recordedAt,
      ),
    );
    return DriftShadowReadResult(outcome: outcome, recordedAt: recordedAt);
  }
}

/// Decorator اختياري. عند [enabled] = false لا يستدعي المرشح إطلاقًا.
class ShadowReadWarehouseRepository implements WarehouseRepository {
  ShadowReadWarehouseRepository({
    required WarehouseRepository source,
    required WarehouseRepository candidate,
    required DriftInventoryShadowReadComparator comparator,
    required bool enabled,
  })  : _source = source,
        _candidate = candidate,
        _comparator = comparator,
        _enabled = enabled;

  final WarehouseRepository _source;
  final WarehouseRepository _candidate;
  final DriftInventoryShadowReadComparator _comparator;
  final bool _enabled;

  @override
  Future<List<Warehouse>> getAllWarehouses() async {
    final sourceValue = await _source.getAllWarehouses();
    if (_enabled) {
      await _comparator.compareWarehouses(
        operation: 'getAllWarehouses',
        sourceRead: () async => sourceValue,
        candidateRead: _candidate.getAllWarehouses,
      );
    }
    return sourceValue;
  }

  @override
  Future<Warehouse?> getWarehouseById(String id) async {
    final sourceValue = await _source.getWarehouseById(id);
    if (_enabled) {
      await _comparator.compareWarehouse(
        operation: 'getWarehouseById',
        sourceRead: () async => sourceValue,
        candidateRead: () => _candidate.getWarehouseById(id),
      );
    }
    return sourceValue;
  }

  @override
  Future<void> addWarehouse(Warehouse warehouse) =>
      _source.addWarehouse(warehouse);

  @override
  Future<void> updateWarehouse(Warehouse warehouse) =>
      _source.updateWarehouse(warehouse);

  @override
  Future<void> deleteWarehouse(String id) => _source.deleteWarehouse(id);
}

class ShadowReadInventoryRepository implements InventoryRepository {
  ShadowReadInventoryRepository({
    required InventoryRepository source,
    required InventoryRepository candidate,
    required DriftInventoryShadowReadComparator comparator,
    required bool enabled,
  })  : _source = source,
        _candidate = candidate,
        _comparator = comparator,
        _enabled = enabled;

  final InventoryRepository _source;
  final InventoryRepository _candidate;
  final DriftInventoryShadowReadComparator _comparator;
  final bool _enabled;

  @override
  Future<List<InventoryItem>> getAllItems() async {
    final sourceValue = await _source.getAllItems();
    if (_enabled) {
      await _comparator.compareInventoryItems(
        operation: 'getAllItems',
        sourceRead: () async => sourceValue,
        candidateRead: _candidate.getAllItems,
      );
    }
    return sourceValue;
  }

  @override
  Future<InventoryItem?> getItemById(String id) async {
    final sourceValue = await _source.getItemById(id);
    if (_enabled) {
      await _comparator.compareInventoryItem(
        operation: 'getItemById',
        sourceRead: () async => sourceValue,
        candidateRead: () => _candidate.getItemById(id),
      );
    }
    return sourceValue;
  }

  @override
  Future<void> addItem(InventoryItem item) => _source.addItem(item);

  @override
  Future<void> updateItem(InventoryItem item) => _source.updateItem(item);

  @override
  Future<void> deleteItem(String id) => _source.deleteItem(id);

  @override
  Future<List<InventoryItem>> searchItems(String query) async {
    final sourceValue = await _source.searchItems(query);
    if (_enabled) {
      await _comparator.compareInventoryItems(
        operation: 'searchItems',
        sourceRead: () async => sourceValue,
        candidateRead: () => _candidate.searchItems(query),
      );
    }
    return sourceValue;
  }

  @override
  Future<InventoryItem?> getItemBySku(String sku) async {
    final sourceValue = await _source.getItemBySku(sku);
    if (_enabled) {
      await _comparator.compareInventoryItem(
        operation: 'getItemBySku',
        sourceRead: () async => sourceValue,
        candidateRead: () => _candidate.getItemBySku(sku),
      );
    }
    return sourceValue;
  }
}

class ShadowReadStockMovementRepository
    implements StockMovementRepository {
  ShadowReadStockMovementRepository({
    required StockMovementRepository source,
    required StockMovementRepository candidate,
    required DriftInventoryShadowReadComparator comparator,
    required bool enabled,
  })  : _source = source,
        _candidate = candidate,
        _comparator = comparator,
        _enabled = enabled;

  final StockMovementRepository _source;
  final StockMovementRepository _candidate;
  final DriftInventoryShadowReadComparator _comparator;
  final bool _enabled;

  @override
  Future<List<StockMovement>> getMovementsForItem(
    String itemId, {
    String? warehouseId,
    DateTime? asOfDate,
  }) async {
    final sourceValue = await _source.getMovementsForItem(
      itemId,
      warehouseId: warehouseId,
      asOfDate: asOfDate,
    );
    if (_enabled) {
      await _comparator.compareStockMovements(
        operation: 'getMovementsForItem',
        sourceRead: () async => sourceValue,
        candidateRead: () => _candidate.getMovementsForItem(
          itemId,
          warehouseId: warehouseId,
          asOfDate: asOfDate,
        ),
      );
    }
    return sourceValue;
  }

  @override
  Future<List<StockMovement>> getMovementsByReference(
    String referenceId,
  ) async {
    final sourceValue = await _source.getMovementsByReference(referenceId);
    if (_enabled) {
      await _comparator.compareStockMovements(
        operation: 'getMovementsByReference',
        sourceRead: () async => sourceValue,
        candidateRead: () => _candidate.getMovementsByReference(referenceId),
      );
    }
    return sourceValue;
  }

  @override
  Future<void> addMovement(StockMovement movement) =>
      _source.addMovement(movement);

  @override
  Future<void> addMovements(List<StockMovement> movements) =>
      _source.addMovements(movements);

  @override
  Future<double> getStockLevel(
    String itemId, {
    String? warehouseId,
    DateTime? asOfDate,
  }) async {
    final sourceValue = await _source.getStockLevel(
      itemId,
      warehouseId: warehouseId,
      asOfDate: asOfDate,
    );
    if (_enabled) {
      await _comparator.compareStockLevel(
        operation: 'getStockLevel',
        sourceRead: () async => sourceValue,
        candidateRead: () => _candidate.getStockLevel(
          itemId,
          warehouseId: warehouseId,
          asOfDate: asOfDate,
        ),
      );
    }
    return sourceValue;
  }
}

bool _warehouseListsEqual(List<Warehouse> left, List<Warehouse> right) {
  final sortedLeft = [...left]..sort(_compareWarehouses);
  final sortedRight = [...right]..sort(_compareWarehouses);
  if (sortedLeft.length != sortedRight.length) return false;
  for (var index = 0; index < sortedLeft.length; index += 1) {
    if (!_warehouseEqual(sortedLeft[index], sortedRight[index])) return false;
  }
  return true;
}

bool _inventoryItemListsEqual(
  List<InventoryItem> left,
  List<InventoryItem> right,
) {
  final sortedLeft = [...left]..sort(_compareInventoryItems);
  final sortedRight = [...right]..sort(_compareInventoryItems);
  if (sortedLeft.length != sortedRight.length) return false;
  for (var index = 0; index < sortedLeft.length; index += 1) {
    if (!_inventoryItemEqual(sortedLeft[index], sortedRight[index])) return false;
  }
  return true;
}

bool _stockMovementListsEqual(
  List<StockMovement> left,
  List<StockMovement> right,
) {
  final sortedLeft = [...left]..sort(_compareStockMovements);
  final sortedRight = [...right]..sort(_compareStockMovements);
  if (sortedLeft.length != sortedRight.length) return false;
  for (var index = 0; index < sortedLeft.length; index += 1) {
    if (!_stockMovementEqual(sortedLeft[index], sortedRight[index])) return false;
  }
  return true;
}

bool _warehouseEqual(Warehouse left, Warehouse right) =>
    left.id == right.id &&
    left.nameAr == right.nameAr &&
    left.nameEn == right.nameEn &&
    left.location == right.location &&
    left.userId == right.userId &&
    left.createdAt.toUtc() == right.createdAt.toUtc() &&
    left.updatedAt.toUtc() == right.updatedAt.toUtc();

bool _inventoryItemEqual(InventoryItem left, InventoryItem right) =>
    left.id == right.id &&
    left.nameAr == right.nameAr &&
    left.nameEn == right.nameEn &&
    left.sku == right.sku &&
    left.description == right.description &&
    _sameNullableDouble(left.purchasePrice, right.purchasePrice) &&
    _sameNullableDouble(left.salePrice, right.salePrice) &&
    _sameDouble(left.currentQuantity, right.currentQuantity) &&
    left.unit == right.unit &&
    left.categoryId == right.categoryId &&
    left.valuationMethod == right.valuationMethod &&
    left.assetAccountId == right.assetAccountId &&
    left.cogsAccountId == right.cogsAccountId &&
    left.revenueAccountId == right.revenueAccountId &&
    left.primaryAccountId == right.primaryAccountId &&
    left.syncStatus == right.syncStatus &&
    left.serverUpdatedAt?.toUtc() == right.serverUpdatedAt?.toUtc() &&
    left.isDeleted == right.isDeleted &&
    left.userId == right.userId &&
    left.warehouseId == right.warehouseId &&
    left.barcode == right.barcode &&
    left.taxCategory == right.taxCategory &&
    left.createdAt.toUtc() == right.createdAt.toUtc() &&
    left.updatedAt.toUtc() == right.updatedAt.toUtc();

bool _stockMovementEqual(StockMovement left, StockMovement right) =>
    left.id == right.id &&
    left.itemId == right.itemId &&
    left.warehouseId == right.warehouseId &&
    left.type == right.type &&
    _sameDouble(left.quantity, right.quantity) &&
    _sameDouble(left.unitCost, right.unitCost) &&
    left.date.toUtc() == right.date.toUtc() &&
    left.createdAt.toUtc() == right.createdAt.toUtc() &&
    left.referenceId == right.referenceId &&
    left.description == right.description &&
    left.userId == right.userId &&
    left.syncStatus == right.syncStatus;

int _compareWarehouses(Warehouse left, Warehouse right) {
  final user = (left.userId ?? '').compareTo(right.userId ?? '');
  if (user != 0) return user;
  return left.id.compareTo(right.id);
}

int _compareInventoryItems(InventoryItem left, InventoryItem right) {
  final user = (left.userId ?? '').compareTo(right.userId ?? '');
  if (user != 0) return user;
  return left.id.compareTo(right.id);
}

int _compareStockMovements(StockMovement left, StockMovement right) {
  final date = left.date.toUtc().compareTo(right.date.toUtc());
  if (date != 0) return date;
  return left.id.compareTo(right.id);
}

bool _sameNullableDouble(double? left, double? right) {
  if (left == null || right == null) return left == right;
  return _sameDouble(left, right);
}

bool _sameDouble(double left, double right) {
  if (left == right) return true;
  final scale = left.abs() > right.abs() ? left.abs() : right.abs();
  return (left - right).abs() <= 1e-9 * (scale > 1 ? scale : 1);
}
