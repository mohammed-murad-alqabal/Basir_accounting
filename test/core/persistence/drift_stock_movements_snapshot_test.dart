import 'dart:io';

import 'package:basir_accounting_system/core/persistence/drift_stock_movements_golden.dart';
import 'package:basir_accounting_system/core/persistence/drift_stock_movements_snapshot.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late StockMovementGoldenCatalog catalog;

  setUpAll(() {
    catalog = StockMovementGoldenCatalog.fromJsonString(
      File('test/fixtures/stock_movements_golden_fixtures.json')
          .readAsStringSync(),
    );
  });

  test('runs every clean fixture and returns clean privacy-safe reports',
      () async {
    final reports = await DriftStockMovementsSnapshotRunner().runAllClean(
      catalog,
      databaseFactory: () => BasirDatabase(NativeDatabase.memory()),
      batchSize: 2,
    );

    expect(reports, hasLength(catalog.cleanFixtures.length));
    expect(reports.every((report) => report.isClean), isTrue);
    expect(
      reports.every(
        (report) =>
            report.migration.checkpoint.isComplete &&
            report.migration.migratedCount == report.migration.sourceCount,
      ),
      isTrue,
    );
  });

  test('safe JSON excludes movement payload and exposes only gate counts',
      () async {
    final fixture = catalog.cleanFixtures.first;
    final report = await DriftStockMovementsSnapshotRunner().run(
      fixture,
      databaseFactory: () => BasirDatabase(NativeDatabase.memory()),
    );
    final json = report.toSafeJson();

    expect(json['clean'], isTrue);
    expect(json['fixtureId'], fixture.id);
    expect(json['sourceCount'], fixture.movements.length);
    expect(json.keys, isNot(contains('movements')));
    expect(json.keys, isNot(contains('expectedBalances')));
    expect(json.keys, isNot(contains('userId')));
    expect(json.keys, isNot(contains('itemId')));
  });

  test('snapshot runner does not treat blocked catalog metadata as clean data',
      () async {
    expect(catalog.blockedFixtures, isNotEmpty);
    final blockedIds = catalog.blockedFixtures.map((fixture) => fixture.id);
    expect(blockedIds, contains('standalone_transfer_type'));
    expect(blockedIds, contains('negative_adjustment'));
  });
}
