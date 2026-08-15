import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BasirDatabase database;
  late BarcodeConfigStore store;

  setUp(() {
    database = BasirDatabase(NativeDatabase.memory());
    store = BarcodeConfigStore(database);
  });

  tearDown(() => database.close());

  test('returns null when no config exists', () async {
    expect(await store.read('default'), isNull);
  });

  test('persists and reads a complete config record', () async {
    const expected = BarcodeConfigRecord(
      id: 'default',
      printerType: 'a4',
      columnsPerRow: 3,
      heightMm: 42.5,
      widthMm: 70,
      marginMm: 1.5,
      showItemName: false,
      showPrice: false,
    );

    await store.save(expected);
    final actual = await store.read('default');

    expect(actual?.id, expected.id);
    expect(actual?.printerType, expected.printerType);
    expect(actual?.columnsPerRow, expected.columnsPerRow);
    expect(actual?.heightMm, expected.heightMm);
    expect(actual?.widthMm, expected.widthMm);
    expect(actual?.marginMm, expected.marginMm);
    expect(actual?.showItemName, expected.showItemName);
    expect(actual?.showPrice, expected.showPrice);
  });

  test('upserts the singleton record', () async {
    await store.save(const BarcodeConfigRecord(
      id: 'default',
      printerType: 'thermal',
      columnsPerRow: 1,
      heightMm: 30,
      widthMm: 50,
      marginMm: 2,
      showItemName: true,
      showPrice: true,
    ));
    await store.save(const BarcodeConfigRecord(
      id: 'default',
      printerType: 'a4',
      columnsPerRow: 4,
      heightMm: 30,
      widthMm: 50,
      marginMm: 2,
      showItemName: true,
      showPrice: true,
    ));

    expect(
        (await database.select(database.barcodeConfigs).get()), hasLength(1));
    expect((await store.read('default'))?.columnsPerRow, 4);
  });

  test('rejects an invalid record before writing', () async {
    expect(
      () => store.save(const BarcodeConfigRecord(
        id: 'default',
        printerType: 'unknown',
        columnsPerRow: 1,
        heightMm: 30,
        widthMm: 50,
        marginMm: 2,
        showItemName: true,
        showPrice: true,
      )),
      throwsArgumentError,
    );
  });
}
