import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BasirDatabase database;
  late WarehouseStore warehouses;

  setUp(() {
    database = BasirDatabase(NativeDatabase.memory());
    warehouses = WarehouseStore(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('WarehouseStore isolates same UUID by user scope', () async {
    await warehouses.save(_warehouse());
    await warehouses.save(
      _warehouse(
        userId: 'user-b',
        nameAr: 'مستودع ب',
        nameEn: 'Warehouse B',
      ),
    );

    final userA = await warehouses.readById('warehouse-a', 'user-a');
    final userB = await warehouses.readById('warehouse-a', 'user-b');
    final missing = await warehouses.readById('warehouse-a', 'user-c');

    expect(userA, isNotNull);
    expect(userA!.nameAr, 'مستودع أ');
    expect(userA.location, 'الرياض');
    expect(userB!.nameEn, 'Warehouse B');
    expect(missing, isNull);
    expect(await warehouses.readAllForUser('user-a'), hasLength(1));
    expect(await warehouses.readAllForUser('user-b'), hasLength(1));
    expect(await warehouses.readAll(), hasLength(2));
  });

  test('WarehouseStore orders scoped reads and replaces same scoped row',
      () async {
    await warehouses.save(
      _warehouse(id: 'warehouse-z', nameAr: 'زاي'),
    );
    await warehouses.save(
      _warehouse(nameAr: 'ألف'),
    );
    await warehouses.save(
      _warehouse(
        nameAr: 'مستودع محدث',
        location: 'جدة',
        updatedAt: DateTime.utc(2026, 8, 17),
      ),
    );

    final records = await warehouses.readAllForUser('user-a');

    expect(records.map((record) => record.id), ['warehouse-a', 'warehouse-z']);
    final updated = await warehouses.readById('warehouse-a', 'user-a');
    expect(updated!.nameAr, 'مستودع محدث');
    expect(updated.location, 'جدة');
    expect(updated.createdAt.toUtc(), DateTime.utc(2026));
    expect(updated.updatedAt.toUtc(), DateTime.utc(2026, 8, 17));
  });

  test('WarehouseStore delete is scoped and physically removes the row',
      () async {
    await warehouses.save(_warehouse());
    await warehouses.save(
      _warehouse(userId: 'user-b', nameAr: 'مستودع ب'),
    );

    await warehouses.deleteById('warehouse-a', 'user-a');

    expect(await warehouses.readById('warehouse-a', 'user-a'), isNull);
    expect(await warehouses.readById('warehouse-a', 'user-b'), isNotNull);
    expect(await warehouses.readAllForUser('user-a'), isEmpty);
    expect(await warehouses.readAllForUser('user-b'), hasLength(1));
  });

  test('WarehouseStore rejects empty identity or names before writing',
      () async {
    expect(
      () => warehouses.save(_warehouse(id: '')),
      throwsArgumentError,
    );
    expect(
      () => warehouses.save(_warehouse(nameAr: '')),
      throwsArgumentError,
    );
    expect(
      () => warehouses.save(_warehouse(nameEn: '')),
      throwsArgumentError,
    );
    expect(await warehouses.readAll(), isEmpty);
  });
}

WarehouseRecord _warehouse({
  String id = 'warehouse-a',
  String nameAr = 'مستودع أ',
  String nameEn = 'Warehouse A',
  String? location = 'الرياض',
  String userId = 'user-a',
  DateTime? createdAt,
  DateTime? updatedAt,
}) =>
    WarehouseRecord(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      location: location,
      userId: userId,
      createdAt: createdAt ?? DateTime.utc(2026),
      updatedAt: updatedAt ?? DateTime.utc(2026, 8),
    );
