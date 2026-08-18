import 'package:basir_accounting_system/core/storage/drift/inventory/inventory_database.dart';
import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

InventoryDatabase constructInventoryDatabase() {
  final connection = DatabaseConnection.delayed(
    Future(() async {
      final result = await WasmDatabase.open(
        databaseName: 'basir_inventory_items',
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        driftWorkerUri: Uri.parse('drift_worker.dart.js'),
      );
      return result.resolvedExecutor;
    }),
  );
  return InventoryDatabase(connection);
}
