import 'package:basir_accounting_system/core/storage/drift/barcode/database.dart';
import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

BarcodeDatabase constructBarcodeDatabase() {
  final connection = DatabaseConnection.delayed(
    Future(() async {
      final result = await WasmDatabase.open(
        databaseName: 'basir_barcode_config',
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        driftWorkerUri: Uri.parse('drift_worker.dart.js'),
      );
      return result.resolvedExecutor;
    }),
  );
  return BarcodeDatabase(connection);
}
