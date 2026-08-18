import 'package:basir_accounting_system/core/storage/drift/inventory/inventory_database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

InventoryDatabase constructInventoryDatabase() =>
    InventoryDatabase(DatabaseConnection(NativeDatabase.memory()));
