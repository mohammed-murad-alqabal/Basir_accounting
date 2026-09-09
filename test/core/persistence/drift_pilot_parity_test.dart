import 'package:basir_accounting_system/core/persistence/drift_pilot_parity.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DriftPilotParityVerifier', () {
    test('reports a clean result for equivalent pilot data', () async {
      final verifier = _verifier(
        barcode: _barcode(),
        prices: _prices(),
      );

      final report = await verifier.verify();

      expect(report.isClean, isTrue);
      expect(report.marketPriceHistory.matches, isTrue);
      expect(report.marketPriceLatestQueries, isNotEmpty);
      expect(report.marketPriceValuationQueries, isNotEmpty);
    });

    test('reports a fingerprint mismatch when Drift is missing a source price',
        () async {
      final storage = _SemanticMarketPriceStorage(_prices()..removeLast());
      final verifier = _verifier(
        barcode: _barcode(),
        prices: _prices(),
        marketPriceStorage: storage,
      );

      final report = await verifier.verify();

      expect(report.isClean, isFalse);
      expect(report.marketPriceHistory.matches, isFalse);
      expect(
        report.marketPriceHistory.expectedCount,
        greaterThan(report.marketPriceHistory.actualCount),
      );
    });

    test('blocks a clean result for legacy equal-date market-price ties',
        () async {
      final prices = [
        _price(id: 'tie-a', itemId: 'item-a', day: 2, hour: 8),
        _price(id: 'tie-b', itemId: 'item-a', day: 2, hour: 9),
      ];
      final verifier = _verifier(barcode: _barcode(), prices: prices);

      final report = await verifier.verify();

      expect(report.marketPriceHistory.matches, isTrue);
      expect(report.ambiguousMarketPriceKeys, isNotEmpty);
      expect(report.isClean, isFalse);
    });

    test(
        'reports a barcode mismatch without including its payload in the scope',
        () async {
      final changedBarcode = _barcode(columns: 3);
      final verifier = _verifier(
        barcode: _barcode(),
        prices: _prices(),
        barcodeStorage: _BarcodeStorage(changedBarcode),
      );

      final report = await verifier.verify();

      expect(report.barcodeConfig.matches, isFalse);
      expect(report.barcodeConfig.scope, 'barcode-config/default');
      expect(report.barcodeConfig.scope, isNot(contains('thermal')));
    });
  });
}

DriftPilotParityVerifier _verifier({
  required BarcodeConfigRecord barcode,
  required List<MarketPriceRecord> prices,
  BarcodeConfigStorage? barcodeStorage,
  MarketPriceStorage? marketPriceStorage,
}) =>
    DriftPilotParityVerifier(
      barcodeSource: _BarcodeSource(barcode).readDefault,
      marketPriceSource: _MarketPriceSource(prices).readAll,
      barcodeStorage: barcodeStorage ?? _BarcodeStorage(barcode),
      marketPriceStorage:
          marketPriceStorage ?? _SemanticMarketPriceStorage(prices),
    );

class _BarcodeSource {
  const _BarcodeSource(this.record);

  final BarcodeConfigRecord record;

  Future<BarcodeConfigRecord?> readDefault() async => record;
}

class _MarketPriceSource {
  const _MarketPriceSource(this.records);

  final List<MarketPriceRecord> records;

  Future<List<MarketPriceRecord>> readAll() async => List.of(records);
}

class _BarcodeStorage implements BarcodeConfigStorage {
  const _BarcodeStorage(this.record);

  final BarcodeConfigRecord? record;

  @override
  Future<BarcodeConfigRecord?> read(String id) async => record;

  @override
  Future<void> save(BarcodeConfigRecord record) async {}
}

class _SemanticMarketPriceStorage implements MarketPriceStorage {
  _SemanticMarketPriceStorage(List<MarketPriceRecord> records)
      : _records = List.of(records);

  final List<MarketPriceRecord> _records;

  @override
  Future<List<MarketPriceRecord>> historyForItem(String itemId) async {
    final records = _records.where((record) => record.itemId == itemId).toList()
      ..sort(_compareLatest);
    return records;
  }

  @override
  Future<MarketPriceRecord?> latestForItem(
    String itemId,
    DateTime asOfDate,
  ) async {
    final records = _records
        .where(
          (record) =>
              record.itemId == itemId &&
              !record.asOfDate.isAfter(asOfDate.toUtc()),
        )
        .toList()
      ..sort(_compareLatest);
    return records.isEmpty ? null : records.first;
  }

  @override
  Future<List<MarketPriceRecord>> latestForAllItems(DateTime asOfDate) async {
    final result = <MarketPriceRecord>[];
    for (final itemId in _records.map((record) => record.itemId).toSet()) {
      final record = await latestForItem(itemId, asOfDate);
      if (record != null) result.add(record);
    }
    return result;
  }

  @override
  Future<void> upsert(MarketPriceRecord record) async {
    _records.removeWhere((current) => current.id == record.id);
    _records.add(record);
  }
}

int _compareLatest(MarketPriceRecord left, MarketPriceRecord right) {
  final asOf = right.asOfDate.compareTo(left.asOfDate);
  if (asOf != 0) return asOf;
  final created = right.createdAt.compareTo(left.createdAt);
  if (created != 0) return created;
  return right.id.compareTo(left.id);
}

BarcodeConfigRecord _barcode({int columns = 2}) => BarcodeConfigRecord(
      id: 'default',
      printerType: 'thermal',
      columnsPerRow: columns,
      heightMm: 30,
      widthMm: 50,
      marginMm: 2,
      showItemName: true,
      showPrice: true,
    );

List<MarketPriceRecord> _prices() => [
      _price(id: 'p-1', itemId: 'item-a', day: 1, hour: 8),
      _price(id: 'p-2', itemId: 'item-a', day: 2, hour: 8),
      _price(id: 'p-3', itemId: 'item-b', day: 1, hour: 8),
    ];

MarketPriceRecord _price({
  required String id,
  required String itemId,
  required int day,
  required int hour,
}) =>
    MarketPriceRecord(
      id: id,
      itemId: itemId,
      price: day.toDouble(),
      asOfDate: DateTime.utc(2026, 1, day),
      createdAt: DateTime.utc(2026, 1, day, hour),
    );
