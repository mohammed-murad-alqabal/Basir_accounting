import 'package:basir_accounting_system/features/reports/data/repositories/drift_market_price_repository.dart';
import 'package:basir_accounting_system/features/reports/domain/entities/market_price.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _FakeMarketPriceStorage storage;
  late DriftMarketPriceRepository repository;

  setUp(() {
    storage = _FakeMarketPriceStorage();
    repository = DriftMarketPriceRepository.withStorage(storage);
  });

  test('maps addPrice to an immutable storage record', () async {
    final price = _price(id: 'price-1', itemId: 'item-a', value: 12.5);

    await repository.addPrice(price);

    expect(storage.upserted?.id, price.id);
    expect(storage.upserted?.itemId, price.itemId);
    expect(storage.upserted?.price, price.price);
    expect(storage.upserted?.asOfDate, price.asOfDate);
    expect(storage.upserted?.createdAt, price.createdAt);
  });

  test('maps latest storage record back to the domain entity', () async {
    storage.latest = _record(id: 'latest', itemId: 'item-a', value: 20);

    final result = await repository.getLatestPrice(
      'item-a',
      DateTime.utc(2026, 1, 10),
    );

    expect(result, _price(id: 'latest', itemId: 'item-a', value: 20));
  });

  test('maps price history in storage order without alteration', () async {
    storage.history = [
      _record(id: 'newer', itemId: 'item-a', value: 20),
      _record(id: 'older', itemId: 'item-a', value: 10),
    ];

    final result = await repository.getPriceHistory('item-a');

    expect(result.map((price) => price.id), ['newer', 'older']);
  });

  test('maps one selected price per item for a valuation date', () async {
    storage.allLatest = [
      _record(id: 'a', itemId: 'item-a', value: 10),
      _record(id: 'b', itemId: 'item-b', value: 30),
    ];

    final result = await repository.getPricesForDate(DateTime.utc(2026, 1, 10));

    expect(result.map((price) => price.itemId), ['item-a', 'item-b']);
  });
}

class _FakeMarketPriceStorage implements MarketPriceStorage {
  MarketPriceRecord? upserted;
  MarketPriceRecord? latest;
  List<MarketPriceRecord> history = const [];
  List<MarketPriceRecord> allLatest = const [];

  @override
  Future<List<MarketPriceRecord>> historyForItem(String itemId) async =>
      history;

  @override
  Future<MarketPriceRecord?> latestForItem(
    String itemId,
    DateTime asOfDate,
  ) async =>
      latest;

  @override
  Future<List<MarketPriceRecord>> latestForAllItems(DateTime asOfDate) async =>
      allLatest;

  @override
  Future<void> upsert(MarketPriceRecord record) async {
    upserted = record;
  }
}

MarketPrice _price({
  required String id,
  required String itemId,
  required double value,
}) =>
    MarketPrice(
      id: id,
      itemId: itemId,
      price: value,
      asOfDate: DateTime.utc(2026, 1, 10),
      createdAt: DateTime.utc(2026, 1, 9),
    );

MarketPriceRecord _record({
  required String id,
  required String itemId,
  required double value,
}) =>
    MarketPriceRecord(
      id: id,
      itemId: itemId,
      price: value,
      asOfDate: DateTime.utc(2026, 1, 10),
      createdAt: DateTime.utc(2026, 1, 9),
    );
