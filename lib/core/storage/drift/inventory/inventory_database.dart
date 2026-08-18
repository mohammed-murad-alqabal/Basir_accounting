import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/inventory_item.dart'
    as domain;
import 'package:drift/drift.dart';

part 'inventory_database_drift_generated.dart';

class InventoryItems extends Table {
  TextColumn get id => text()();
  TextColumn get nameAr => text()();
  TextColumn get nameEn => text()();
  TextColumn get sku => text().nullable()();
  TextColumn get barcode => text().nullable()();
  TextColumn get description => text().nullable()();
  RealColumn get purchasePrice => real().nullable()();
  RealColumn get salePrice => real().nullable()();
  RealColumn get currentQuantity => real().withDefault(const Constant(0))();
  TextColumn get unit => text().nullable()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get valuationMethod =>
      text().withDefault(const Constant('weightedAverage'))();
  TextColumn get assetAccountId => text().nullable()();
  TextColumn get cogsAccountId => text().nullable()();
  TextColumn get revenueAccountId => text().nullable()();
  TextColumn get primaryAccountId => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('synced'))();
  DateTimeColumn get serverUpdatedAt => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get userId => text().nullable()();
  TextColumn get warehouseId => text().nullable()();
  TextColumn get taxCategory => text().withDefault(const Constant('S'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [InventoryItems])
class InventoryDatabase extends _$InventoryDatabase {
  InventoryDatabase(super.e);

  @override
  int get schemaVersion => 1;

  Future<List<domain.InventoryItem>> getAllItems({
    required String? userId,
    required String? warehouseId,
  }) async {
    final query = select(inventoryItems)
      ..where(
        (row) =>
            row.userId.equalsNullable(userId) &
            row.isDeleted.equals(false) &
            (row.warehouseId.isNull() |
                row.warehouseId.equalsNullable(warehouseId)),
      )
      ..orderBy([(row) => OrderingTerm(expression: row.nameAr)]);
    final rows = await query.get();
    return rows.map(_toEntity).toList(growable: false);
  }

  Future<domain.InventoryItem?> getItemById({
    required String id,
    required String? userId,
    required String? warehouseId,
  }) async {
    final query = select(inventoryItems)
      ..where(
        (row) =>
            row.id.equals(id) &
            row.userId.equalsNullable(userId) &
            (row.warehouseId.isNull() |
                row.warehouseId.equalsNullable(warehouseId)),
      )
      ..limit(1);
    final row = await query.getSingleOrNull();
    return row == null ? null : _toEntity(row);
  }

  Future<List<domain.InventoryItem>> searchItems({
    required String query,
    required String? userId,
    required String? warehouseId,
  }) async {
    final normalized = '%${query.toLowerCase()}%';
    final statement = select(inventoryItems)
      ..where(
        (row) =>
            row.userId.equalsNullable(userId) &
            row.isDeleted.equals(false) &
            (row.warehouseId.isNull() |
                row.warehouseId.equalsNullable(warehouseId)) &
            (row.nameAr.lower().like(normalized) |
                row.nameEn.lower().like(normalized) |
                row.sku.lower().like(normalized)),
      )
      ..orderBy([(row) => OrderingTerm(expression: row.nameAr)]);
    final rows = await statement.get();
    return rows.map(_toEntity).toList(growable: false);
  }

  Future<domain.InventoryItem?> getItemBySku({
    required String sku,
    required String? userId,
    required String? warehouseId,
  }) async {
    final statement = select(inventoryItems)
      ..where(
        (row) =>
            row.sku.lower().equals(sku.toLowerCase()) &
            row.userId.equalsNullable(userId) &
            row.isDeleted.equals(false) &
            (row.warehouseId.isNull() |
                row.warehouseId.equalsNullable(warehouseId)),
      )
      ..limit(1);
    final row = await statement.getSingleOrNull();
    return row == null ? null : _toEntity(row);
  }

  domain.InventoryItem _toEntity(InventoryItem row) => domain.InventoryItem(
        id: row.id,
        nameAr: row.nameAr,
        nameEn: row.nameEn,
        sku: row.sku,
        barcode: row.barcode,
        description: row.description,
        purchasePrice: row.purchasePrice,
        salePrice: row.salePrice,
        currentQuantity: row.currentQuantity,
        unit: row.unit,
        categoryId: row.categoryId,
        valuationMethod:
            domain.ValuationMethod.values.byName(row.valuationMethod),
        assetAccountId: row.assetAccountId,
        cogsAccountId: row.cogsAccountId,
        revenueAccountId: row.revenueAccountId,
        primaryAccountId: row.primaryAccountId,
        syncStatus: SyncStatus.values.byName(row.syncStatus),
        serverUpdatedAt: row.serverUpdatedAt,
        isDeleted: row.isDeleted,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        userId: row.userId,
        warehouseId: row.warehouseId,
        taxCategory: row.taxCategory,
      );
}

class InventoryReadRepository {
  const InventoryReadRepository({
    required this.database,
    required this.userId,
    required this.warehouseId,
  });

  final InventoryDatabase database;
  final String? userId;
  final String? warehouseId;

  Future<List<domain.InventoryItem>> getAllItems() => database.getAllItems(
        userId: userId,
        warehouseId: warehouseId,
      );

  Future<domain.InventoryItem?> getItemById(String id) => database.getItemById(
        id: id,
        userId: userId,
        warehouseId: warehouseId,
      );

  Future<List<domain.InventoryItem>> searchItems(String query) =>
      database.searchItems(
        query: query,
        userId: userId,
        warehouseId: warehouseId,
      );

  Future<domain.InventoryItem?> getItemBySku(String sku) =>
      database.getItemBySku(
        sku: sku,
        userId: userId,
        warehouseId: warehouseId,
      );
}
