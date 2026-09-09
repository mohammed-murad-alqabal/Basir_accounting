import 'package:basir_accounting_system/core/storage/drift/barcode/database.dart';
import 'package:drift/native.dart';

BarcodeDatabase constructBarcodeDatabase() =>
    BarcodeDatabase(NativeDatabase.memory());
