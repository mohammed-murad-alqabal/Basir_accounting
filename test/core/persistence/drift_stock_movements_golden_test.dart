// ignore_for_file: unnecessary_lambdas

import 'dart:convert';
import 'dart:io';

import 'package:basir_accounting_system/core/persistence/drift_stock_movements_golden.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late StockMovementGoldenCatalog catalog;

  setUpAll(() {
    final source = File(
      'test/fixtures/stock_movements_golden_fixtures.json',
    ).readAsStringSync();
    catalog = StockMovementGoldenCatalog.fromJsonString(source);
  });

  StockMovementGoldenFixture fixtureById(String id) =>
      catalog.cleanFixtures.singleWhere((fixture) => fixture.id == id);

  test('parses the sanitized catalog with clean and blocked cases', () {
    expect(catalog.fixtureVersion, 1);
    expect(catalog.cleanFixtures, hasLength(6));
    expect(catalog.blockedFixtures, hasLength(4));
    expect(
      catalog.cleanFixtures.map((fixture) => fixture.id),
      containsAll(<String>[
        'basic_lifecycle',
        'general_and_warehouse_scope',
        'transfer_dual_entry',
        'same_date_inclusive_boundary',
        'reference_lookup_cross_warehouse',
        'user_scope_isolation',
      ]),
    );
  });

  test('all clean fixtures match their expected derived balances', () {
    final failures = <String>[];
    for (final fixture in catalog.cleanFixtures) {
      failures.addAll(StockMovementGoldenReplay.verifyFixture(fixture));
    }
    expect(failures, isEmpty);
  });

  test('basic lifecycle replays inbound, outbound, and positive adjustment',
      () {
    final fixture = fixtureById('basic_lifecycle');

    expect(
      StockMovementGoldenReplay.balanceFor(
        fixture,
        userId: 'user-a',
        warehouseId: 'wh-a',
        asOfDate: DateTime.utc(2026),
      ),
      10.0,
    );
    expect(
      StockMovementGoldenReplay.balanceFor(
        fixture,
        userId: 'user-a',
        warehouseId: 'wh-a',
        asOfDate: DateTime.utc(2026, 1, 3),
      ),
      9.0,
    );
  });

  test('general rows are included while another warehouse stays isolated', () {
    final fixture = fixtureById('general_and_warehouse_scope');

    expect(
      StockMovementGoldenReplay.balanceFor(
        fixture,
        userId: 'user-a',
        warehouseId: 'wh-a',
        asOfDate: DateTime.utc(2026, 2, 3),
      ),
      3.0,
    );
    expect(
      StockMovementGoldenReplay.balanceFor(
        fixture,
        userId: 'user-a',
        warehouseId: 'wh-b',
        asOfDate: DateTime.utc(2026, 2, 3),
      ),
      105.0,
    );
  });

  test('asOfDate is inclusive and same-date ordering is deterministic', () {
    final fixture = fixtureById('same_date_inclusive_boundary');

    expect(
      StockMovementGoldenReplay.balanceFor(
        fixture,
        userId: 'user-a',
        warehouseId: 'wh-a',
        asOfDate: DateTime.utc(2026, 4, 10, 11, 59, 59, 999),
      ),
      0.0,
    );
    expect(
      StockMovementGoldenReplay.balanceFor(
        fixture,
        userId: 'user-a',
        warehouseId: 'wh-a',
        asOfDate: DateTime.utc(2026, 4, 10, 12),
      ),
      6.0,
    );
  });

  test('dual-entry transfer preserves source, destination, and reference count',
      () {
    final fixture = fixtureById('transfer_dual_entry');

    expect(
      StockMovementGoldenReplay.balanceFor(
        fixture,
        userId: 'user-a',
        warehouseId: 'wh-a',
        asOfDate: DateTime.utc(2026, 3, 2),
      ),
      13.0,
    );
    expect(
      StockMovementGoldenReplay.balanceFor(
        fixture,
        userId: 'user-a',
        warehouseId: 'wh-b',
        asOfDate: DateTime.utc(2026, 3, 2),
      ),
      7.0,
    );
    expect(
      StockMovementGoldenReplay.referenceCount(
        fixture,
        userId: 'user-a',
        referenceId: 'transfer-001',
      ),
      2,
    );
  });

  test('user scope isolation ignores another user with the same item id', () {
    final fixture = fixtureById('user_scope_isolation');

    expect(
      StockMovementGoldenReplay.balanceFor(
        fixture,
        userId: 'user-a',
        warehouseId: 'wh-a',
        asOfDate: DateTime.utc(2026, 6),
      ),
      10.0,
    );
    expect(
      StockMovementGoldenReplay.balanceFor(
        fixture,
        userId: 'user-b',
        warehouseId: 'wh-a',
        asOfDate: DateTime.utc(2026, 6),
      ),
      50.0,
    );
  });

  test('rejects non-UTC movement dates', () {
    final source = File(
      'test/fixtures/stock_movements_golden_fixtures.json',
    ).readAsStringSync();
    final json = jsonDecode(source) as Map<String, dynamic>;
    final cleanFixtures = json['cleanFixtures'] as List<dynamic>;
    final firstFixture = cleanFixtures.first as Map<String, dynamic>;
    final movements = firstFixture['movements'] as List<dynamic>;
    final firstMovement = movements.first as Map<String, dynamic>;
    firstMovement['date'] = '2026-01-01T00:00:00.000+03:00';

    expect(
      () => StockMovementGoldenCatalog.fromJson(
        json.map<String, Object?>((key, value) => MapEntry(key, value)),
      ),
      throwsFormatException,
    );
  });

  test('rejects standalone transfer inside a clean fixture', () {
    final json = jsonDecode(
      File('test/fixtures/stock_movements_golden_fixtures.json')
          .readAsStringSync(),
    ) as Map<String, dynamic>;
    final cleanFixtures = json['cleanFixtures'] as List<dynamic>;
    final firstFixture = cleanFixtures.first as Map<String, dynamic>;
    final movements = firstFixture['movements'] as List<dynamic>;
    final firstMovement = movements.first as Map<String, dynamic>;
    firstMovement['type'] = 'transfer';

    expect(
      () => StockMovementGoldenCatalog.fromJson(
        json.map<String, Object?>((key, value) => MapEntry(key, value)),
      ),
      throwsFormatException,
    );
  });
}
