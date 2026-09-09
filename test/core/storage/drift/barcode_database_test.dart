import 'package:basir_accounting_system/core/storage/drift/barcode/connection.dart';
import 'package:basir_accounting_system/core/storage/drift/barcode/database.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/barcode_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('barcode settings round-trip through Drift', () async {
    final database = constructBarcodeDatabase();
    addTearDown(database.close);
    final repository = DriftBarcodeConfigRepository(database);

    final initial = await repository.getConfig();
    expect(initial.columnsPerRow, 1);

    final expected = initial.copyWith(
      columnsPerRow: 4,
      printerType: PrinterType.a4,
      showPrice: false,
    );
    await repository.saveConfig(expected);

    final actual = await repository.getConfig();
    expect(actual.id, 'default');
    expect(actual.columnsPerRow, 4);
    expect(actual.printerType, PrinterType.a4);
    expect(actual.showPrice, isFalse);
  });
}
