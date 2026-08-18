import 'dart:convert';

import 'package:basir_accounting_system/core/persistence/drift_stock_movements_migration.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';

class StockMovementBalanceQuery {
  const StockMovementBalanceQuery({
    required this.fixtureId,
    required this.itemId,
    required this.userId,
    required this.warehouseId,
    required this.asOfDate,
    required this.expectedBalance,
  });

  final String fixtureId;
  final String itemId;
  final String? userId;
  final String warehouseId;
  final DateTime asOfDate;
  final double expectedBalance;
}

class StockMovementParityComparison {
  const StockMovementParityComparison({
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

class StockMovementDerivedBalanceComparison {
  const StockMovementDerivedBalanceComparison({
    required this.fixtureId,
    required this.expected,
    required this.actual,
    required this.blocked,
  });

  final String fixtureId;
  final double expected;
  final double? actual;
  final String? blocked;

  bool get matches =>
      blocked == null &&
      actual != null &&
      (actual! - expected).abs() <= 0.000000001;
}

class DriftStockMovementsParityReport {
  const DriftStockMovementsParityReport({
    required this.rawComparisons,
    required this.referenceComparisons,
    required this.derivedComparisons,
    required this.duplicateScopedKeys,
    required this.blockedReasons,
  });

  final List<StockMovementParityComparison> rawComparisons;
  final List<StockMovementParityComparison> referenceComparisons;
  final List<StockMovementDerivedBalanceComparison> derivedComparisons;
  final List<String> duplicateScopedKeys;
  final List<String> blockedReasons;

  bool get isClean =>
      rawComparisons.every((comparison) => comparison.matches) &&
      referenceComparisons.every((comparison) => comparison.matches) &&
      derivedComparisons.every((comparison) => comparison.matches) &&
      duplicateScopedKeys.isEmpty &&
      blockedReasons.isEmpty;
}

/// يقارن المصدر السابق والتخزين المرشح دون إصلاح تلقائي أو تفعيل rollout.
class DriftStockMovementsParityVerifier {
  DriftStockMovementsParityVerifier({
    required StockMovementMigrationReader source,
    required StockMovementStorage storage,
    required List<StockMovementBalanceQuery> balanceQueries,
  })  : _source = source,
        _storage = storage,
        _balanceQueries = balanceQueries;

  final StockMovementMigrationReader _source;
  final StockMovementStorage _storage;
  final List<StockMovementBalanceQuery> _balanceQueries;

  Future<DriftStockMovementsParityReport> verify() async {
    final expected = await _source();
    final userIds = {
      ...expected.map((record) => record.userId),
      ..._balanceQueries.map((query) => query.userId),
    };
    final actual = <StockMovementRecord>[];
    for (final userId in userIds) {
      actual.addAll(await _storage.readAllForUser(userId));
    }

    final rawComparisons = userIds.map((userId) {
      final expectedRows = expected
          .where((record) => record.userId == userId)
          .toList(growable: false);
      final actualRows = actual
          .where((record) => record.userId == userId)
          .toList(growable: false);
      return _comparison(
        scope: 'stock-movements/${userScopeKey(userId)}',
        expected: expectedRows,
        actual: actualRows,
      );
    }).toList(growable: false);

    final references = <String>{
      ...expected.where((record) => record.referenceId != null).map(
            (record) =>
                '${userScopeKey(record.userId)}\u0000${record.referenceId}',
          ),
    };
    final referenceComparisons = references.map((key) {
      final separator = key.indexOf('\u0000');
      final scope = key.substring(0, separator);
      final referenceId = key.substring(separator + 1);
      final expectedRows = expected
          .where(
            (record) =>
                userScopeKey(record.userId) == scope &&
                record.referenceId == referenceId,
          )
          .toList(growable: false);
      final actualRows = actual
          .where(
            (record) =>
                userScopeKey(record.userId) == scope &&
                record.referenceId == referenceId,
          )
          .toList(growable: false);
      return _comparison(
        scope: 'reference/$scope',
        expected: expectedRows,
        actual: actualRows,
      );
    }).toList(growable: false);

    final derived = <StockMovementDerivedBalanceComparison>[];
    for (final query in _balanceQueries) {
      final expectedRows = expected
          .where(
            (record) =>
                record.itemId == query.itemId &&
                    record.userId == query.userId &&
                    record.warehouseId == null ||
                (record.itemId == query.itemId &&
                    record.userId == query.userId &&
                    record.warehouseId == query.warehouseId),
          )
          .where(
            (record) => !record.date.toUtc().isAfter(query.asOfDate.toUtc()),
          )
          .toList(growable: false);
      try {
        final expectedBalance = _deriveBalance(expectedRows);
        final actualBalance = await _storage.readStockLevel(
          query.itemId,
          query.userId,
          warehouseId: query.warehouseId,
          asOfDate: query.asOfDate,
        );
        derived.add(
          StockMovementDerivedBalanceComparison(
            fixtureId: query.fixtureId,
            expected: query.expectedBalance,
            actual: actualBalance,
            blocked:
                (expectedBalance - query.expectedBalance).abs() > 0.000000001
                    ? 'source-derived-mismatch'
                    : null,
          ),
        );
      } on StockMovementBlockedException catch (error) {
        derived.add(
          StockMovementDerivedBalanceComparison(
            fixtureId: query.fixtureId,
            expected: query.expectedBalance,
            actual: null,
            blocked: error.runtimeType.toString(),
          ),
        );
      }
    }

    return DriftStockMovementsParityReport(
      rawComparisons: rawComparisons,
      referenceComparisons: referenceComparisons,
      derivedComparisons: derived,
      duplicateScopedKeys: _duplicateScopedKeys(expected),
      blockedReasons: _blockedReasons(expected),
    );
  }

  static StockMovementParityComparison _comparison({
    required String scope,
    required List<StockMovementRecord> expected,
    required List<StockMovementRecord> actual,
  }) {
    final expectedCanonical = _sort(expected).map(_canonical).toList();
    final actualCanonical = _sort(actual).map(_canonical).toList();
    return StockMovementParityComparison(
      scope: scope,
      expectedCount: expectedCanonical.length,
      actualCount: actualCanonical.length,
      expectedFingerprint: _fingerprint(expectedCanonical),
      actualFingerprint: _fingerprint(actualCanonical),
    );
  }
}

List<StockMovementRecord> _sort(List<StockMovementRecord> records) =>
    [...records]..sort((left, right) {
        final date = left.date.toUtc().compareTo(right.date.toUtc());
        if (date != 0) return date;
        return left.id.compareTo(right.id);
      });

String _canonical(StockMovementRecord record) => [
      record.id,
      record.itemId,
      _nullable(record.warehouseId),
      record.type,
      record.quantity.toStringAsPrecision(17),
      record.unitCost.toStringAsPrecision(17),
      record.date.toUtc().toIso8601String(),
      _nullable(record.referenceId),
      _nullable(record.description),
      _nullable(record.userId),
      record.syncStatus,
      record.createdAt.toUtc().toIso8601String(),
    ].join('\u0000');

double _deriveBalance(List<StockMovementRecord> records) {
  var total = 0.0;
  for (final record in records) {
    switch (record.type) {
      case 'inbound':
        total += record.quantity;
      case 'outbound':
        total -= record.quantity;
      case 'adjustment':
        if (record.quantity <= 0) {
          throw const StockMovementBlockedException(
            'Signed adjustment is blocked.',
          );
        }
        total += record.quantity;
      case 'transfer':
        throw const StockMovementBlockedException(
          'Standalone transfer is blocked.',
        );
      default:
        throw const StockMovementBlockedException(
          'Unknown movement type is blocked.',
        );
    }
  }
  return total;
}

List<String> _blockedReasons(List<StockMovementRecord> records) => records
    .map((record) {
      if (record.type == 'transfer') return 'standalone-transfer';
      if (record.type == 'adjustment' && record.quantity <= 0) {
        return 'signed-adjustment';
      }
      return null;
    })
    .whereType<String>()
    .toSet()
    .toList()
  ..sort();

List<String> _duplicateScopedKeys(List<StockMovementRecord> records) {
  final counts = <String, int>{};
  for (final record in records) {
    final key = '${userScopeKey(record.userId)}\u0000${record.id}';
    counts.update(key, (value) => value + 1, ifAbsent: () => 1);
  }
  return counts.entries
      .where((entry) => entry.value > 1)
      .map((entry) => entry.key)
      .toList(growable: false)
    ..sort();
}

String _nullable(String? value) => value == null ? '\u0001' : '\u0002$value';

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
