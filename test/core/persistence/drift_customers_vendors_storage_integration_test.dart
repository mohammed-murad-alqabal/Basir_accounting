import 'dart:io';

import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:basir_accounting_system/features/customers/data/models/customer_model.dart';
import 'package:basir_accounting_system/features/vendors/data/models/vendor_model.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

void main() {
  late Directory temporaryDirectory;
  late Isar isar;
  late BasirDatabase driftDatabase;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'basir-drift-customers-vendors-',
    );
    isar = await Isar.open(
      [CustomerModelSchema, VendorModelSchema],
      directory: temporaryDirectory.path,
      name: 'customers-vendors-source',
    );
    driftDatabase = BasirDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await driftDatabase.close();
    await isar.close(deleteFromDisk: true);
    if (temporaryDirectory.existsSync()) {
      await temporaryDirectory.delete(recursive: true);
    }
  });

  test('copies Customers and Vendors to Drift without changing Isar', () async {
    await isar.writeTxn(() async {
      await isar.customerModels.putAll([
        _customerModel(id: 'customer-a', userId: 'user-a'),
        _customerModel(id: 'customer-b', userId: 'user-b'),
      ]);
      await isar.vendorModels.putAll([
        _vendorModel(id: 'vendor-a', userId: 'user-a'),
        _vendorModel(id: 'vendor-b', userId: 'user-b'),
      ]);
    });

    final customerStore = CustomerStore(driftDatabase);
    final vendorStore = VendorStore(driftDatabase);
    final sourceCustomers = await isar.customerModels.where().findAll();
    final sourceVendors = await isar.vendorModels.where().findAll();

    for (final model in sourceCustomers) {
      await customerStore.save(_customerRecord(model));
    }
    for (final model in sourceVendors) {
      await vendorStore.save(_vendorRecord(model));
    }

    expect(await customerStore.readAll(), hasLength(2));
    expect(await vendorStore.readAll(), hasLength(2));
    expect(await customerStore.readAllForUser('user-a'), hasLength(1));
    expect(await vendorStore.readAllForUser('user-a'), hasLength(1));
    expect(
      (await customerStore.readById('customer-a', 'user-a'))
          ?.receivableAccountId,
      'acc-1201-a',
    );
    expect(
      (await vendorStore.readById('vendor-a', 'user-a'))?.payableAccountId,
      'acc-2101-a',
    );
    expect(await isar.customerModels.count(), 2);
    expect(await isar.vendorModels.count(), 2);
  });
}

CustomerModel _customerModel({
  required String id,
  required String userId,
}) =>
    CustomerModel()
      ..customerId = id
      ..nameAr = 'عميل $id'
      ..nameEn = 'Customer $id'
      ..taxNumber = 'TAX-$id'
      ..phone = '0500000000'
      ..email = '$id@example.com'
      ..address = 'Riyadh'
      ..notes = 'fixture'
      ..createdAt = DateTime.utc(2026)
      ..updatedAt = DateTime.utc(2026, 8)
      ..creditLimit = 1000.50
      ..balance = 10.25
      ..receivableAccountId = 'acc-1201-a'
      ..userId = userId
      ..syncStatus = SyncStatus.pendingPush
      ..serverUpdatedAt = DateTime.utc(2026, 8)
      ..isDeleted = false;

VendorModel _vendorModel({
  required String id,
  required String userId,
}) =>
    VendorModel()
      ..vendorId = id
      ..nameAr = 'مورد $id'
      ..nameEn = 'Vendor $id'
      ..phone = '0510000000'
      ..email = '$id@example.com'
      ..address = 'Jeddah'
      ..notes = 'fixture'
      ..createdAt = DateTime.utc(2026)
      ..updatedAt = DateTime.utc(2026, 8)
      ..payableAccountId = 'acc-2101-a'
      ..vatNumber = 'VAT-$id'
      ..registrationNumber = 'CR-$id'
      ..balance = 42.5
      ..userId = userId
      ..syncStatus = SyncStatus.conflict
      ..serverUpdatedAt = DateTime.utc(2026, 8)
      ..isDeleted = true;

CustomerRecord _customerRecord(CustomerModel model) => CustomerRecord(
      id: model.customerId,
      nameAr: model.nameAr,
      nameEn: model.nameEn,
      taxNumber: model.taxNumber,
      phone: model.phone,
      email: model.email,
      address: model.address,
      notes: model.notes,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      creditLimit: model.creditLimit,
      balance: model.balance,
      receivableAccountId: model.receivableAccountId,
      userId: model.userId,
      syncStatus: model.syncStatus.name,
      serverUpdatedAt: model.serverUpdatedAt,
      isDeleted: model.isDeleted,
    );

VendorRecord _vendorRecord(VendorModel model) => VendorRecord(
      id: model.vendorId,
      nameAr: model.nameAr,
      nameEn: model.nameEn,
      phone: model.phone,
      email: model.email,
      address: model.address,
      notes: model.notes,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      payableAccountId: model.payableAccountId,
      vatNumber: model.vatNumber,
      registrationNumber: model.registrationNumber,
      balance: model.balance,
      userId: model.userId,
      syncStatus: model.syncStatus.name,
      serverUpdatedAt: model.serverUpdatedAt,
      isDeleted: model.isDeleted,
    );
