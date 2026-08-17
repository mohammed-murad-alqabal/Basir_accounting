import 'package:basir_accounting_system/core/persistence/drift_customers_vendors_migration.dart';
import 'package:basir_accounting_system/core/persistence/drift_customers_vendors_parity.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BasirDatabase database;
  late CustomerStore customers;
  late VendorStore vendors;
  late LocalMetadataMigrationCheckpointStore checkpoints;

  setUp(() {
    database = BasirDatabase(NativeDatabase.memory());
    customers = CustomerStore(database);
    vendors = VendorStore(database);
    checkpoints = LocalMetadataMigrationCheckpointStore(database);
  });

  tearDown(() => database.close());

  test('imports both slices with deterministic checkpoints and clean parity',
      () async {
    final customerSource = [
      _customer(id: 'customer-b', userId: 'user-b'),
      _customer(id: 'customer-a', userId: 'user-a'),
    ];
    final vendorSource = [
      _vendor(id: 'vendor-b', userId: 'user-b'),
      _vendor(id: 'vendor-a', userId: 'user-a'),
    ];

    final migration = await DriftCustomersVendorsMigrator(
      customerSource: () async => customerSource,
      vendorSource: () async => vendorSource,
      customerStorage: customers,
      vendorStorage: vendors,
      checkpoints: checkpoints,
    ).migrate(batchSize: 1);
    final parity = await DriftCustomersVendorsParityVerifier(
      customerSource: () async => customerSource,
      vendorSource: () async => vendorSource,
      customerStorage: customers,
      vendorStorage: vendors,
    ).verify();

    expect(migration.isComplete, isTrue);
    expect(parity.isClean, isTrue);
    expect(
      (await checkpoints.read(DriftCustomersVendorsMigrationSlice.customers))
          ?.isComplete,
      isTrue,
    );
    expect(
      (await checkpoints.read(DriftCustomersVendorsMigrationSlice.vendors))
          ?.isComplete,
      isTrue,
    );
    expect((await customers.readAll()).map((record) => record.id), [
      'customer-a',
      'customer-b',
    ]);
    expect((await vendors.readAll()).map((record) => record.id), [
      'vendor-a',
      'vendor-b',
    ]);
  });

  test('parity blocks critical account-link mismatch', () async {
    final sourceCustomer = _customer(
      id: 'customer-a',
      userId: 'user-a',
      receivableAccountId: 'acc-1201-new',
    );
    await customers.save(
      _customer(
        id: 'customer-a',
        userId: 'user-a',
        receivableAccountId: 'acc-1201-old',
      ),
    );

    final parity = await DriftCustomersVendorsParityVerifier(
      customerSource: () async => [sourceCustomer],
      vendorSource: () async => const [],
      customerStorage: customers,
      vendorStorage: vendors,
    ).verify();

    expect(parity.customers.matches, isFalse);
    expect(parity.isClean, isFalse);
    expect(parity.duplicateCustomerKeys, isEmpty);
  });

  test('parity reports duplicate UUIDs inside one user scope', () async {
    final first = _customer(id: 'customer-a', userId: 'user-a');
    final duplicate = _customer(
      id: 'customer-a',
      userId: 'user-a',
      nameAr: 'Different source value',
    );
    await customers.save(first);

    final parity = await DriftCustomersVendorsParityVerifier(
      customerSource: () async => [first, duplicate],
      vendorSource: () async => const [],
      customerStorage: customers,
      vendorStorage: vendors,
    ).verify();

    expect(parity.duplicateCustomerKeys, hasLength(1));
    expect(parity.customers.matches, isFalse);
    expect(parity.isClean, isFalse);
  });

  test('migrator rejects non-positive batch size', () async {
    expect(
      () => DriftCustomersVendorsMigrator(
        customerSource: () async => const [],
        vendorSource: () async => const [],
        customerStorage: customers,
        vendorStorage: vendors,
        checkpoints: checkpoints,
      ).migrate(batchSize: 0),
      throwsArgumentError,
    );
  });
}

CustomerRecord _customer({
  required String id,
  required String userId,
  String? nameAr,
  String receivableAccountId = 'acc-1201',
}) =>
    CustomerRecord(
      id: id,
      nameAr: nameAr ?? 'عميل $id',
      nameEn: 'Customer $id',
      taxNumber: 'TAX-$id',
      phone: '0500000000',
      email: '$id@example.com',
      address: 'Riyadh',
      notes: null,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026, 8),
      creditLimit: 1000.5,
      balance: 10.25,
      receivableAccountId: receivableAccountId,
      userId: userId,
      syncStatus: 'pendingPush',
      serverUpdatedAt: DateTime.utc(2026, 8),
      isDeleted: false,
    );

VendorRecord _vendor({required String id, required String userId}) =>
    VendorRecord(
      id: id,
      nameAr: 'مورد $id',
      nameEn: 'Vendor $id',
      phone: '0510000000',
      email: '$id@example.com',
      address: 'Jeddah',
      notes: null,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026, 8),
      payableAccountId: 'acc-2101',
      vatNumber: 'VAT-$id',
      registrationNumber: 'CR-$id',
      balance: 42.5,
      userId: userId,
      syncStatus: 'conflict',
      serverUpdatedAt: DateTime.utc(2026, 8),
      isDeleted: true,
    );
