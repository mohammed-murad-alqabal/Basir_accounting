import 'dart:convert';

import 'package:basir_accounting_system/core/persistence/drift_pilot_migration.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';

/// نتيجة مقارنة دون إعادة نشر سجلات الأعمال نفسها في السجلات التشخيصية.
class DriftParityComparison {
  const DriftParityComparison({
    required this.scope,
    required this.expectedCount,
    required this.actualCount,
    required this.expectedFingerprint,
    required this.actualFingerprint,
  });

  final String scope;
  final int expectedCount;
  final int actualCount;
  final String expectedFingerprint;
  final String actualFingerprint;

  bool get matches =>
      expectedCount == actualCount && expectedFingerprint == actualFingerprint;
}

/// تقرير تكافؤ الشريحتين التجريبيتين. تمنع [ambiguousMarketPriceKeys] الانتقال
/// إلى canary عندما لا يعرّف تنفيذ Isar التاريخي ترتيبًا حتميًا للأسعار المتعادلة.
class DriftPilotParityReport {
  const DriftPilotParityReport({
    required this.barcodeConfig,
    required this.marketPriceHistory,
    required this.marketPriceLatestQueries,
    required this.marketPriceValuationQueries,
    required this.ambiguousMarketPriceKeys,
  });

  final DriftParityComparison barcodeConfig;
  final DriftParityComparison marketPriceHistory;
  final List<DriftParityComparison> marketPriceLatestQueries;
  final List<DriftParityComparison> marketPriceValuationQueries;
  final List<String> ambiguousMarketPriceKeys;

  bool get isClean =>
      barcodeConfig.matches &&
      marketPriceHistory.matches &&
      marketPriceLatestQueries.every((comparison) => comparison.matches) &&
      marketPriceValuationQueries.every((comparison) => comparison.matches) &&
      ambiguousMarketPriceKeys.isEmpty;
}

/// يقارن Drift مع لقطة Isar مستوردة. هذه الأداة قراءة فقط؛ لا تغيّر providers،
/// ولا تعالج mismatch تلقائيًا، ولا تسجل payload تجاريًا في تقريرها.
class DriftPilotParityVerifier {
  DriftPilotParityVerifier({
    required BarcodeConfigMigrationReader barcodeSource,
    required MarketPriceMigrationReader marketPriceSource,
    required BarcodeConfigStorage barcodeStorage,
    required MarketPriceStorage marketPriceStorage,
  })  : _barcodeSource = barcodeSource,
        _marketPriceSource = marketPriceSource,
        _barcodeStorage = barcodeStorage,
        _marketPriceStorage = marketPriceStorage;

  final BarcodeConfigMigrationReader _barcodeSource;
  final MarketPriceMigrationReader _marketPriceSource;
  final BarcodeConfigStorage _barcodeStorage;
  final MarketPriceStorage _marketPriceStorage;

  Future<DriftPilotParityReport> verify() async {
    final barcodeConfig = await _verifyBarcodeConfig();
    final sourcePrices = await _marketPriceSource();
    final histories = await _verifyMarketPriceHistory(sourcePrices);
    final ambiguousKeys = <credential-fixture>(sourcePrices);
    final latestQueries = await _verifyLatestQueries(sourcePrices);
    final valuationQueries = await _verifyValuationQueries(sourcePrices);

    return DriftPilotParityReport(
      barcodeConfig: barcodeConfig,
      marketPriceHistory: histories,
      marketPriceLatestQueries: latestQueries,
      marketPriceValuationQueries: valuationQueries,
      ambiguousMarketPriceKeys: <credential-fixture>,
    );
  }

  Future<DriftParityComparison> _verifyBarcodeConfig() async {
    final expected = await _barcodeSource();
    final actual = await _barcodeStorage.read('default');
    return _comparison(
      scope: 'barcode-config/default',
      expected: expected == null ? const [] : [_canonicalBarcode(expected)],
      actual: actual == null ? const [] : [_canonicalBarcode(actual)],
    );
  }

  Future<DriftParityComparison> _verifyMarketPriceHistory(
    List<MarketPriceRecord> sourcePrices,
  ) async {
    final expected = [...sourcePrices]..sort(_compareHistoryRecords);
    final itemIds = expected.map((record) => record.itemId).toSet().toList()
      ..sort();
    final actual = <MarketPriceRecord>[];
    for (final itemId in itemIds) {
      actual.addAll(await _marketPriceStorage.historyForItem(itemId));
    }
    actual.sort(_compareHistoryRecords);

    return _comparison(
      scope: 'market-prices/history',
      expected: expected.map(_canonicalMarketPrice).toList(growable: false),
      actual: actual.map(_canonicalMarketPrice).toList(growable: false),
    );
  }

  Future<List<DriftParityComparison>> _verifyLatestQueries(
    List<MarketPriceRecord> sourcePrices,
  ) async {
    final itemIds = sourcePrices.map((record) => record.itemId).toSet().toList()
      ..sort();
    final dates = sourcePrices
        .map((record) => record.asOfDate.toUtc())
        .toSet()
        .toList()
      ..sort();
    final comparisons = <DriftParityComparison>[];

    for (final itemId in itemIds) {
      for (final date in dates) {
        final expected = _latestForItem(sourcePrices, itemId, date);
        final actual = await _marketPriceStorage.latestForItem(itemId, date);
        comparisons.add(
          _comparison(
            scope: 'market-prices/latest/$itemId/${date.toIso8601String()}',
            expected:
                expected == null ? const [] : [_canonicalMarketPrice(expected)],
            actual: actual == null ? const [] : [_canonicalMarketPrice(actual)],
          ),
        );
      }
    }
    return comparisons;
  }

  Future<List<DriftParityComparison>> _verifyValuationQueries(
    List<MarketPriceRecord> sourcePrices,
  ) async {
    final dates = sourcePrices
        .map((record) => record.asOfDate.toUtc())
        .toSet()
        .toList()
      ..sort();
    final comparisons = <DriftParityComparison>[];

    for (final date in dates) {
      final expected = _latestForAllItems(sourcePrices, date)
        ..sort(_compareMarketPriceRecords);
      final actual = await _marketPriceStorage.latestForAllItems(date)
        ..sort(_compareMarketPriceRecords);
      comparisons.add(
        _comparison(
          scope: 'market-prices/valuation/${date.toIso8601String()}',
          expected: expected.map(_canonicalMarketPrice).toList(growable: false),
          actual: actual.map(_canonicalMarketPrice).toList(growable: false),
        ),
      );
    }
    return comparisons;
  }

  static List<String> _findAmbiguousMarketPriceKeys(
    List<MarketPriceRecord> records,
  ) {
    final counts = <String, int>{};
    for (final record in records) {
      final key =
          '${record.itemId}\u0000${record.asOfDate.toUtc().toIso8601String()}';
      counts.update(key, (count) => count + 1, ifAbsent: () => 1);
    }
    return counts.entries
        .where((entry) => entry.value > 1)
        .map((entry) => _fingerprint([entry.key]))
        .toList(growable: false)
      ..sort();
  }

  static MarketPriceRecord? _latestForItem(
    List<MarketPriceRecord> records,
    String itemId,
    DateTime date,
  ) {
    final matches = records
        .where(
          (record) =>
              record.itemId == itemId &&
              !record.asOfDate.toUtc().isAfter(date.toUtc()),
        )
        .toList()
      ..sort(_compareLatestRecords);
    return matches.isEmpty ? null : matches.first;
  }

  static List<MarketPriceRecord> _latestForAllItems(
    List<MarketPriceRecord> records,
    DateTime date,
  ) {
    final result = <MarketPriceRecord>[];
    for (final itemId in records.map((record) => record.itemId).toSet()) {
      final latest = _latestForItem(records, itemId, date);
      if (latest != null) result.add(latest);
    }
    return result;
  }

  static DriftParityComparison _comparison({
    required String scope,
    required List<String> expected,
    required List<String> actual,
  }) =>
      DriftParityComparison(
        scope: scope,
        expectedCount: expected.length,
        actualCount: actual.length,
        expectedFingerprint: _fingerprint(expected),
        actualFingerprint: _fingerprint(actual),
      );
}

String _canonicalBarcode(BarcodeConfigRecord record) => [
      record.id,
      record.printerType,
      record.columnsPerRow.toString(),
      record.heightMm.toStringAsPrecision(17),
      record.widthMm.toStringAsPrecision(17),
      record.marginMm.toStringAsPrecision(17),
      record.showItemName.toString(),
      record.showPrice.toString(),
    ].join('\u0000');

String _canonicalMarketPrice(MarketPriceRecord record) => [
      record.id,
      record.itemId,
      record.price.toStringAsPrecision(17),
      record.asOfDate.toUtc().toIso8601String(),
      record.createdAt.toUtc().toIso8601String(),
    ].join('\u0000');

/// بصمة تشخيصية 32-bit ثابتة على Web ولا تصلح لأغراض أمنية أو مصادقة.
String _fingerprint(List<String> values) {
  var hash = 0x811c9dc5;
  for (final value in values) {
    for (final byte in utf8.encode(value)) {
      hash = ((hash * 31) + byte).toUnsigned(32);
    }
    hash = ((hash * 31) + 0xff).toUnsigned(32);
  }
  return hash.toRadixString(16).padLeft(8, '0');
}

int _compareMarketPriceRecords(
  MarketPriceRecord left,
  MarketPriceRecord right,
) {
  final item = left.itemId.compareTo(right.itemId);
  if (item != 0) return item;
  final asOf = left.asOfDate.compareTo(right.asOfDate);
  if (asOf != 0) return asOf;
  final created = left.createdAt.compareTo(right.createdAt);
  if (created != 0) return created;
  return left.id.compareTo(right.id);
}

int _compareHistoryRecords(MarketPriceRecord left, MarketPriceRecord right) {
  final item = left.itemId.compareTo(right.itemId);
  if (item != 0) return item;
  return _compareLatestRecords(left, right);
}

int _compareLatestRecords(MarketPriceRecord left, MarketPriceRecord right) {
  final asOf = right.asOfDate.compareTo(left.asOfDate);
  if (asOf != 0) return asOf;
  final created = right.createdAt.compareTo(left.createdAt);
  if (created != 0) return created;
  return right.id.compareTo(left.id);
}
