import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BasirDatabase database;
  late CustomerStore customers;
  late VendorStore vendors;

  setUp(() {
    database = BasirDatabase(NativeDatabase.memory());
    customers = CustomerStore(database);
    vendors = VendorStore(database);
  });

  tearDown(() async {
    await database.close();
  });

  test(
      'CustomerStore isolates same UUID by user scope and preserves critical fields',
      () async {
    await customers.save(_customer());
    await customers.save(
      _customer(
        userId: 'user-b',
        nameAr: 'عميل ب',
        balance: 25.75,
      ),
    );

    final userA = await customers.readById('customer-a', 'user-a');
    final userB = await customers.readById('customer-a', 'user-b');
    final missing = await customers.readById('customer-a', 'user-c');

    expect(userA, isNotNull);
    expect(userA!.nameAr, 'عميل أ');
    expect(userA.receivableAccountId, 'acc-1201-a');
    expect(userA.creditLimit, 1000.50);
    expect(userA.balance, 10.25);
    expect(userA.syncStatus, 'pendingPush');
    expect(userA.serverUpdatedAt?.toUtc(), DateTime.utc(2026, 8));
    expect(userB!.nameAr, 'عميل ب');
    expect(userB.balance, 25.75);
    expect(missing, isNull);
    expect(await customers.readAllForUser('user-a'), hasLength(1));
    expect(await customers.readAll(), hasLength(2));
  });

  test(
      'CustomerStore search matches Arabic and English names case-insensitively',
      () async {
    await customers.save(_customer());
    await customers.save(
      _customer(
        id: 'customer-b',
        nameAr: 'شركة الرياض',
        nameEn: 'Riyadh Trading',
      ),
    );
    await customers.save(
      _customer(id: 'customer-c', userId: 'user-b'),
    );

    expect(
      (await customers.searchForUser('TRADING', 'user-a'))
          .map((record) => record.id),
      ['customer-b'],
    );
    expect(
      (await customers.searchForUser('عميل', 'user-a'))
          .map((record) => record.id),
      ['customer-a'],
    );
    expect(
      (await customers.searchForUser('Customer', 'user-a'))
          .map((record) => record.id),
      ['customer-a'],
    );
  });

  test('CustomerStore delete operations remain scoped', () async {
    await customers.save(_customer());
    await customers.save(
      _customer(id: 'customer-b'),
    );
    await customers.save(
      _customer(userId: 'user-b', nameAr: 'عميل ب'),
    );

    await customers.deleteById('customer-a', 'user-a');
    expect(await customers.readById('customer-a', 'user-a'), isNull);
    expect(await customers.readById('customer-a', 'user-b'), isNotNull);

    await customers.deleteAllForUser('user-a');
    expect(await customers.readAllForUser('user-a'), isEmpty);
    expect(await customers.readAllForUser('user-b'), hasLength(1));
  });

  test(
      'VendorStore preserves payable/account and sync fields with scope isolation',
      () async {
    await vendors.save(_vendor());
    await vendors.save(
      _vendor(
        userId: 'user-b',
        nameAr: 'مورد ب',
        balance: 88.25,
      ),
    );

    final userA = await vendors.readById('vendor-a', 'user-a');
    final userB = await vendors.readById('vendor-a', 'user-b');

    expect(userA, isNotNull);
    expect(userA!.payableAccountId, 'acc-2101-a');
    expect(userA.vatNumber, 'VAT-A');
    expect(userA.registrationNumber, 'CR-A');
    expect(userA.balance, 42.5);
    expect(userA.syncStatus, 'conflict');
    expect(userA.isDeleted, isTrue);
    expect(userB!.nameAr, 'مورد ب');
    expect(userB.balance, 88.25);
  });

  test('VendorStore search and delete are scoped', () async {
    await vendors.save(_vendor());
    await vendors.save(
      _vendor(
        id: 'vendor-b',
        nameAr: 'شركة جدة',
        nameEn: 'Jeddah Supply',
      ),
    );
    await vendors.save(
      _vendor(
        id: 'vendor-c',
        userId: 'user-b',
        nameAr: 'شركة جدة',
        nameEn: 'Jeddah Supply',
      ),
    );

    expect(
      (await vendors.searchForUser('supply', 'user-a'))
          .map((record) => record.id),
      ['vendor-b'],
    );
    await vendors.deleteById('vendor-c', 'user-a');
    expect(await vendors.readById('vendor-c', 'user-b'), isNotNull);
    await vendors.deleteById('vendor-b', 'user-a');
    expect(await vendors.readById('vendor-b', 'user-a'), isNull);
  });

  test('stores reject unsupported sync status before writing', () async {
    expect(
      () => customers.save(_customer(syncStatus: 'unknown')),
      throwsArgumentError,
    );
    expect(
      () => vendors.save(_vendor(syncStatus: 'unknown')),
      throwsArgumentError,
    );
  });
}

CustomerRecord _customer({
  String id = 'customer-a',
  String userId = 'user-a',
  String nameAr = 'عميل أ',
  String nameEn = 'Customer A',
  double balance = 10.25,
  String syncStatus = 'pendingPush',
}) =>
    CustomerRecord(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      taxNumber: 'TAX-A',
      phone: '0500000000',
      email: 'a@example.com',
      address: 'Riyadh',
      notes: 'fixture',
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026, 8),
      creditLimit: 1000.50,
      balance: balance,
      receivableAccountId: 'acc-1201-a',
      userId: userId,
      syncStatus: syncStatus,
      serverUpdatedAt: DateTime.utc(2026, 8),
      isDeleted: false,
    );

VendorRecord _vendor({
  String id = 'vendor-a',
  String userId = 'user-a',
  String nameAr = 'مورد أ',
  String nameEn = 'Vendor A',
  double balance = 42.5,
  String syncStatus = 'conflict',
}) =>
    VendorRecord(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      phone: '0510000000',
      email: 'vendor@example.com',
      address: 'Jeddah',
      notes: 'fixture',
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026, 8),
      payableAccountId: 'acc-2101-a',
      vatNumber: 'VAT-A',
      registrationNumber: 'CR-A',
      balance: balance,
      userId: userId,
      syncStatus: syncStatus,
      serverUpdatedAt: DateTime.utc(2026, 8, 2),
      isDeleted: true,
    );
