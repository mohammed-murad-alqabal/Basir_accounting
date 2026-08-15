import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BasirDatabase database;
  late MarketPriceStore store;

  setUp(() {
    database = BasirDatabase(NativeDatabase.memory());
    store = MarketPriceStore(database);
  });

  tearDown(() => database.close());

  test('returns no latest price when no matching record exists', () async {
    final result = await store.latestForItem('item-a', DateTime.utc(2026));
    expect(result, isNull);
  });

  test('uses an inclusive date boundary and deterministic tie-breakers',
      () async {
    final asOf = DateTime.utc(2026, 1, 10);
    await store.upsert(_record(
      id: 'older',
      itemId: 'item-a',
      price: 10,
      asOfDate: asOf.subtract(const Duration(days: 1)),
      createdAt: asOf,
    ));
    await store.upsert(_record(
      id: 'equal-earlier',
      itemId: 'item-a',
      price: 12,
      asOfDate: asOf,
      createdAt: asOf,
    ));
    await store.upsert(_record(
      id: 'equal-later',
      itemId: 'item-a',
      price: 15,
      asOfDate: asOf,
      createdAt: asOf.add(const Duration(seconds: 1)),
    ));

    final latest = await store.latestForItem('item-a', asOf);

    expect(latest?.id, 'equal-later');
    expect(latest?.price, 15);
  });

  test('returns history in descending valuation-date order', () async {
    final day = DateTime.utc(2026, 1, 10);
    await store.upsert(_record(
      id: 'one',
      itemId: 'item-a',
      price: 10,
      asOfDate: day.subtract(const Duration(days: 2)),
      createdAt: day,
    ));
    await store.upsert(_record(
      id: 'two',
      itemId: 'item-a',
      price: 20,
      asOfDate: day.subtract(const Duration(days: 1)),
      createdAt: day,
    ));

    final history = await store.historyForItem('item-a');

    expect(history.map((record) => record.id), ['two', 'one']);
  });

  test('selects one latest price per item without including future records',
      () async {
    final day = DateTime.utc(2026, 1, 10);
    await store.upsert(_record(
      id: 'a-old',
      itemId: 'item-a',
      price: 10,
      asOfDate: day.subtract(const Duration(days: 1)),
      createdAt: day,
    ));
    await store.upsert(_record(
      id: 'a-future',
      itemId: 'item-a',
      price: 99,
      asOfDate: day.add(const Duration(days: 1)),
      createdAt: day,
    ));
    await store.upsert(_record(
      id: 'b-current',
      itemId: 'item-b',
      price: 30,
      asOfDate: day,
      createdAt: day,
    ));

    final prices = await store.latestForAllItems(day);

    expect(prices.map((record) => record.id), ['a-old', 'b-current']);
  });

  test('upserts a record by its stable id', () async {
    final initial = _record(
      id: 'price-1',
      itemId: 'item-a',
      price: 10,
      asOfDate: DateTime.utc(2026, 1, 1),
      createdAt: DateTime.utc(2026, 1, 1),
    );
    await store.upsert(initial);
    await store.upsert(_record(
      id: 'price-1',
      itemId: 'item-a',
      price: 11,
      asOfDate: initial.asOfDate,
      createdAt: initial.createdAt,
    ));

    final rows = await database.select(database.marketPrices).get();

    expect(rows, hasLength(1));
    expect(rows.single.price, 11);
  });
}

MarketPriceRecord _record({
  required String id,
  required String itemId,
  required double price,
  required DateTime asOfDate,
  required DateTime createdAt,
}) =>
    MarketPriceRecord(
      id: id,
      itemId: itemId,
      price: price,
      asOfDate: asOfDate,
      createdAt: createdAt,
    );
