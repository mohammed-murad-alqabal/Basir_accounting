import 'package:drift/drift.dart';

import 'package:basir_drift_storage/src/basir_database.dart';

/// DTO محايد لسجل سعر سوق زمني، مستقل عن Freezed وطبقة reports في التطبيق.
class MarketPriceRecord {
  const MarketPriceRecord({
    required this.id,
    required this.itemId,
    required this.price,
    required this.asOfDate,
    required this.createdAt,
  });

  final String id;
  final String itemId;
  final double price;
  final DateTime asOfDate;
  final DateTime createdAt;
}

/// عقد التخزين الذي يستهلكه مكيّف Domain دون استيراد Drift.
abstract interface class MarketPriceStorage {
  Future<void> upsert(MarketPriceRecord record);

  Future<MarketPriceRecord?> latestForItem(String itemId, DateTime asOfDate);

  Future<List<MarketPriceRecord>> historyForItem(String itemId);

  Future<List<MarketPriceRecord>> latestForAllItems(DateTime asOfDate);
}

/// DAO Drift المعزول لسجل أسعار السوق.
class MarketPriceStore implements MarketPriceStorage {
  MarketPriceStore(this._database);

  final BasirDatabase _database;

  @override
  Future<void> upsert(MarketPriceRecord record) async {
    _validate(record);

    await _database.into(_database.marketPrices).insertOnConflictUpdate(
          MarketPricesCompanion.insert(
            id: record.id,
            itemId: record.itemId,
            price: record.price,
            asOfDate: record.asOfDate.toUtc(),
            createdAt: record.createdAt.toUtc(),
          ),
        );
  }

  @override
  Future<MarketPriceRecord?> latestForItem(
    String itemId,
    DateTime asOfDate,
  ) async {
    final row = await (_database.select(_database.marketPrices)
          ..where(
            (table) =>
                table.itemId.equals(itemId) &
                table.asOfDate.isSmallerOrEqualValue(asOfDate.toUtc()),
          )
          ..orderBy([
            (table) => OrderingTerm.desc(table.asOfDate),
            (table) => OrderingTerm.desc(table.createdAt),
            (table) => OrderingTerm.desc(table.id),
          ])
          ..limit(1))
        .getSingleOrNull();

    return row == null ? null : _toRecord(row);
  }

  @override
  Future<List<MarketPriceRecord>> historyForItem(String itemId) async {
    final rows = await (_database.select(_database.marketPrices)
          ..where((table) => table.itemId.equals(itemId))
          ..orderBy([
            (table) => OrderingTerm.desc(table.asOfDate),
            (table) => OrderingTerm.desc(table.createdAt),
            (table) => OrderingTerm.desc(table.id),
          ]))
        .get();

    return rows.map(_toRecord).toList(growable: false);
  }

  @override
  Future<List<MarketPriceRecord>> latestForAllItems(DateTime asOfDate) async {
    final rows = await (_database.select(_database.marketPrices)
          ..where(
              (table) => table.asOfDate.isSmallerOrEqualValue(asOfDate.toUtc()))
          ..orderBy([
            (table) => OrderingTerm.asc(table.itemId),
            (table) => OrderingTerm.desc(table.asOfDate),
            (table) => OrderingTerm.desc(table.createdAt),
            (table) => OrderingTerm.desc(table.id),
          ]))
        .get();

    final latestByItem = <String, MarketPriceRecord>{};
    for (final row in rows) {
      latestByItem.putIfAbsent(row.itemId, () => _toRecord(row));
    }
    return latestByItem.values.toList(growable: false);
  }

  static MarketPriceRecord _toRecord(MarketPrice row) => MarketPriceRecord(
        id: row.id,
        itemId: row.itemId,
        price: row.price,
        asOfDate: row.asOfDate,
        createdAt: row.createdAt,
      );

  static void _validate(MarketPriceRecord record) {
    if (record.id.isEmpty || record.itemId.isEmpty) {
      throw ArgumentError.value(
          record, 'record', 'Invalid market price record.');
    }
  }
}
