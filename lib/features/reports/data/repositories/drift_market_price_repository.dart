import 'package:basir_accounting_system/features/reports/domain/entities/market_price.dart';
import 'package:basir_accounting_system/features/reports/domain/repositories/market_price_repository.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';

/// مكيّف تجريبي لعقد أسعار السوق باستخدام حزمة Drift الداخلية.
///
/// لا يُسجّل هذا التنفيذ في providers؛ يظل `MarketPriceRepositoryImpl` المعتمد
/// على Isar هو المسار النشط حتى تثبت اختبارات التكافؤ وخطة cutover مستقلة.
class DriftMarketPriceRepository implements MarketPriceRepository {
  DriftMarketPriceRepository(BasirDatabase database)
      : _storage = MarketPriceStore(database);

  /// منشئ اختبار/حقن؛ يبقي طبقة reports مستقلة عن أنواع Drift.
  DriftMarketPriceRepository.withStorage(this._storage);

  final MarketPriceStorage _storage;

  @override
  Future<void> addPrice(MarketPrice price) => _storage.upsert(_toRecord(price));

  @override
  Future<MarketPrice?> getLatestPrice(String itemId, DateTime asOfDate) async {
    final record = await _storage.latestForItem(itemId, asOfDate);
    return record == null ? null : _toEntity(record);
  }

  @override
  Future<List<MarketPrice>> getPriceHistory(String itemId) async {
    final records = await _storage.historyForItem(itemId);
    return records.map(_toEntity).toList(growable: false);
  }

  @override
  Future<List<MarketPrice>> getPricesForDate(DateTime asOfDate) async {
    final records = await _storage.latestForAllItems(asOfDate);
    return records.map(_toEntity).toList(growable: false);
  }

  static MarketPriceRecord _toRecord(MarketPrice price) => MarketPriceRecord(
        id: price.id,
        itemId: price.itemId,
        price: price.price,
        asOfDate: price.asOfDate,
        createdAt: price.createdAt,
      );

  static MarketPrice _toEntity(MarketPriceRecord record) => MarketPrice(
        id: record.id,
        itemId: record.itemId,
        price: record.price,
        asOfDate: record.asOfDate,
        createdAt: record.createdAt,
      );
}
