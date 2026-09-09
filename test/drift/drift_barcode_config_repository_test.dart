import 'package:basir_accounting_system/features/settings/data/repositories/drift_barcode_config_repository.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/barcode_config.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _FakeBarcodeConfigStorage storage;
  late DriftBarcodeConfigRepository repository;

  setUp(() {
    storage = _FakeBarcodeConfigStorage();
    repository = DriftBarcodeConfigRepository.withStorage(storage);
  });

  test('returns the same default configuration exposed by the Isar contract',
      () async {
    expect(await repository.getConfig(), const BarcodeConfig());
  });

  test('maps every BarcodeConfig field to the storage record and back',
      () async {
    const expected = BarcodeConfig(
      printerType: PrinterType.a4,
      columnsPerRow: 3,
      height: 42.5,
      width: 70.0,
      margin: 1.5,
      showItemName: false,
      showPrice: false,
    );

    await repository.saveConfig(expected);

    expect(await repository.getConfig(), expected);
    expect(storage.lastSaved?.printerType, 'a4');
  });

  test('replaces the default configuration through the storage contract',
      () async {
    await repository.saveConfig(const BarcodeConfig(columnsPerRow: 2));
    await repository.saveConfig(
      const BarcodeConfig(printerType: PrinterType.a4, columnsPerRow: 4),
    );

    expect(await repository.getConfig(),
        const BarcodeConfig(printerType: PrinterType.a4, columnsPerRow: 4));
  });

  test('rejects invalid dimensions before a storage write', () async {
    await expectLater(
      repository.saveConfig(const BarcodeConfig(width: 0)),
      throwsArgumentError,
    );
    expect(storage.lastSaved, isNull);
  });
}

class _FakeBarcodeConfigStorage implements BarcodeConfigStorage {
  BarcodeConfigRecord? lastSaved;

  @override
  Future<BarcodeConfigRecord?> read(String id) async {
    if (lastSaved?.id == id) return lastSaved;
    return null;
  }

  @override
  Future<void> save(BarcodeConfigRecord record) async {
    lastSaved = record;
  }
}
