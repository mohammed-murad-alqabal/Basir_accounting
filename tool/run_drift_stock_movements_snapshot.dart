import 'dart:convert';
import 'dart:io';

import 'package:basir_accounting_system/core/persistence/drift_stock_movements_golden.dart';
import 'package:basir_accounting_system/core/persistence/drift_stock_movements_snapshot.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:drift/native.dart';

Future<void> main(List<String> args) async {
  if (args.length > 1) {
    stderr.writeln(
      'Usage: dart run tool/run_drift_stock_movements_snapshot.dart [path]',
    );
    exitCode = 64;
    return;
  }

  final path = args.isEmpty
      ? 'test/fixtures/stock_movements_golden_fixtures.json'
      : args.single;
  try {
    final catalog = StockMovementGoldenCatalog.fromJsonString(
      File(path).readAsStringSync(),
    );
    final reports = await DriftStockMovementsSnapshotRunner().runAllClean(
      catalog,
      databaseFactory: () => BasirDatabase(NativeDatabase.memory()),
      batchSize: 2,
    );
    final clean = reports.every((report) => report.isClean);
    stdout.writeln(
      jsonEncode({
        'clean': clean,
        'fixtureCount': reports.length,
        'reports': reports.map((report) => report.toSafeJson()).toList(),
        'blockedFixtureCount': catalog.blockedFixtures.length,
      }),
    );
    if (!clean) exitCode = 1;
  } on Object catch (error) {
    stderr.writeln('snapshot failed: ${error.runtimeType}');
    exitCode = 1;
  }
}
