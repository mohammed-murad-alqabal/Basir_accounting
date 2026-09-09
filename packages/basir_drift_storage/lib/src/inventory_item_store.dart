import 'package:basir_drift_storage/src/basir_database.dart';
import 'package:basir_drift_storage/src/user_scope.dart';
import 'package:drift/drift.dart';

/// DTO محايد لصنف المخزون؛ يحافظ على الحقول المحاسبية والتقييمية والمزامنة.
class InventoryItemRecord {
  const InventoryItemRecord({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.sku,
    required this.description,
    required this.purchasePrice,
    required this.salePrice,
    required this.currentQuantity,
    required this.unit,
    required this.categoryId,
    required this.valuationMethod,
    required this.assetAccountId,
    required this.cogsAccountId,
    required this.revenueAccountId,
    required this.primaryAccountId,
    required this.syncStatus,
    required this.serverUpdatedAt,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.warehouseId,
    required this.barcode,
    required this.taxCategory,
  });

  final String id;
  final String nameAr;
  final String nameEn;
  final String? sku;
  final String? description;
  final double? purchasePrice;
  final double? salePrice;
  final double currentQuantity;
  final String? unit;
  final String? categoryId;
  final String valuationMethod;
  final String? assetAccountId;
  final String? cogsAccountId;
  final String? revenueAccountId;
  final String? primaryAccountId;
  final String syncStatus;
  final DateTime? serverUpdatedAt;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userId;
  final String? warehouseId;
  final String? barcode;
  final String taxCategory;
}

/// عقد تخزين InventoryItem مستقل عن domain وProviders التطبيق.
abstract interface class InventoryItemStorage {
  Future<List<InventoryItemRecord>> readAllForUser(
    String? userId, {
    String? warehouseId,
  });

  Future<List<InventoryItemRecord>> readAll();

  Future<InventoryItemRecord?> readById(
    String id,
    String? userId, {
    String? warehouseId,
  });

  Future<List<InventoryItemRecord>> searchForUser(
    String query,
    String? userId, {
    String? warehouseId,
  });

  Future<InventoryItemRecord?> readBySku(
    String sku,
    String? userId, {
    String? warehouseId,
  });

  Future<void> save(InventoryItemRecord record);

  Future<void> softDeleteById(
    String id,
    String? userId, {
    String? warehouseId,
  });
}

/// DAO تجريبي لـInventoryItem. لا يغير Isar أو sync أو Providers النشطة.
class InventoryItemStore implements InventoryItemStorage {
  InventoryItemStore(this._database);

  final BasirDatabase _database;

  @override
  Future<List<InventoryItemRecord>> readAllForUser(
    String? userId, {
    String? warehouseId,
  }) async {
    final rows = await (_database.select(_database.inventoryItems)
          ..where(
            (table) =>
                table.scopeKey.equals(userScopeKey(userId)) &
                _warehouseScope(table, warehouseId) &
                table.isDeleted.equals(false),
          )
          ..orderBy([
            (table) => OrderingTerm.asc(table.uuid),
          ]))
        .get();
    return rows.map(_toRecord).toList(growable: false);
  }

  @override
  Future<List<InventoryItemRecord>> readAll() async {
    final rows = await (_database.select(_database.inventoryItems)
          ..orderBy([
            (table) => OrderingTerm.asc(table.scopeKey),
            (table) => OrderingTerm.asc(table.uuid),
          ]))
        .get();
    return rows.map(_toRecord).toList(growable: false);
  }

  @override
  Future<InventoryItemRecord?> readById(
    String id,
    String? userId, {
    String? warehouseId,
  }) async {
    final row = await (_database.select(_database.inventoryItems)
          ..where(
            (table) =>
                table.scopeKey.equals(userScopeKey(userId)) &
                table.uuid.equals(id) &
                _warehouseScope(table, warehouseId),
          ))
        .getSingleOrNull();
    return row == null ? null : _toRecord(row);
  }

  @override
  Future<List<InventoryItemRecord>> searchForUser(
    String query,
    String? userId, {
    String? warehouseId,
  }) async {
    final normalized = query.toLowerCase();
    final records = await readAllForUser(
      userId,
      warehouseId: warehouseId,
    );
    return records
        .where(
          (record) =>
              record.nameAr.toLowerCase().contains(normalized) ||
              record.nameEn.toLowerCase().contains(normalized) ||
              (record.sku?.toLowerCase().contains(normalized) ?? false),
        )
        .toList(growable: false);
  }

  @override
  Future<InventoryItemRecord?> readBySku(
    String sku,
    String? userId, {
    String? warehouseId,
  }) async {
    final normalized = sku.toLowerCase();
    final records = await readAllForUser(
      userId,
      warehouseId: warehouseId,
    );
    for (final record in records) {
      if (record.sku?.toLowerCase() == normalized) return record;
    }
    return null;
  }

  @override
  Future<void> save(InventoryItemRecord record) {
    _validate(record);
    return _database.into(_database.inventoryItems).insertOnConflictUpdate(
          InventoryItemsCompanion.insert(
            scopeKey: userScopeKey(record.userId),
            uuid: record.id,
            nameAr: record.nameAr,
            nameEn: record.nameEn,
            sku: Value(record.sku),
            description: Value(record.description),
            purchasePrice: Value(record.purchasePrice),
            salePrice: Value(record.salePrice),
            currentQuantity: Value(record.currentQuantity),
            unit: Value(record.unit),
            categoryId: Value(record.categoryId),
            valuationMethod: Value(record.valuationMethod),
            assetAccountId: Value(record.assetAccountId),
            cogsAccountId: Value(record.cogsAccountId),
            revenueAccountId: Value(record.revenueAccountId),
            primaryAccountId: Value(record.primaryAccountId),
            syncStatus: Value(record.syncStatus),
            serverUpdatedAt: Value(record.serverUpdatedAt?.toUtc()),
            isDeleted: Value(record.isDeleted),
            createdAt: record.createdAt.toUtc(),
            updatedAt: record.updatedAt.toUtc(),
            userId: Value(record.userId),
            warehouseId: Value(record.warehouseId),
            barcode: Value(record.barcode),
            taxCategory: Value(record.taxCategory),
          ),
        );
  }

  @override
  Future<void> softDeleteById(
    String id,
    String? userId, {
    String? warehouseId,
  }) async {
    final now = DateTime.now().toUtc();
    await (_database.update(_database.inventoryItems)
          ..where(
            (table) =>
                table.scopeKey.equals(userScopeKey(userId)) &
                table.uuid.equals(id) &
                _warehouseScope(table, warehouseId),
          ))
        .write(
      InventoryItemsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(now),
      ),
    );
  }

  static Expression<bool> _warehouseScope(
    $InventoryItemsTable table,
    String? warehouseId,
  ) {
    if (warehouseId == null) return table.warehouseId.isNull();
    return table.warehouseId.isNull() | table.warehouseId.equals(warehouseId);
  }

  static InventoryItemRecord _toRecord(InventoryItem row) =>
      InventoryItemRecord(
        id: row.uuid,
        nameAr: row.nameAr,
        nameEn: row.nameEn,
        sku: row.sku,
        description: row.description,
        purchasePrice: row.purchasePrice,
        salePrice: row.salePrice,
        currentQuantity: row.currentQuantity,
        unit: row.unit,
        categoryId: row.categoryId,
        valuationMethod: row.valuationMethod,
        assetAccountId: row.assetAccountId,
        cogsAccountId: row.cogsAccountId,
        revenueAccountId: row.revenueAccountId,
        primaryAccountId: row.primaryAccountId,
        syncStatus: row.syncStatus,
        serverUpdatedAt: row.serverUpdatedAt,
        isDeleted: row.isDeleted,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        userId: row.userId,
        warehouseId: row.warehouseId,
        barcode: row.barcode,
        taxCategory: row.taxCategory,
      );

  static void _validate(InventoryItemRecord record) {
    if (record.id.isEmpty || record.nameAr.isEmpty || record.nameEn.isEmpty) {
      throw ArgumentError.value(
        record,
        'record',
        'Inventory item id and names are required.',
      );
    }
    if (!const {'fifo', 'weightedAverage'}.contains(record.valuationMethod)) {
      throw ArgumentError.value(
        record.valuationMethod,
        'valuationMethod',
        'Unsupported valuation method.',
      );
    }
    if (!const {'synced', 'pendingPush', 'pendingPull', 'conflict'}
        .contains(record.syncStatus)) {
      throw ArgumentError.value(
        record.syncStatus,
        'syncStatus',
        'Unsupported sync status.',
      );
    }
    if (record.taxCategory.isEmpty) {
      throw ArgumentError.value(
        record.taxCategory,
        'taxCategory',
        'Tax category is required.',
      );
    }
  }
}
