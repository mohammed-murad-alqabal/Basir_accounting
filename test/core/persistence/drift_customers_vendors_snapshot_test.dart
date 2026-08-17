import 'package:basir_accounting_system/core/persistence/drift_customers_vendors_snapshot.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('runs a clean Customers and Vendors snapshot in SQLite memory',
      () async {
    final snapshot = DriftCustomersVendorsSnapshot.fromJson(_snapshotJson());

    final report = await DriftCustomersVendorsSnapshotRunner().run(
      snapshot,
      batchSize: 1,
      databaseFactory: () => BasirDatabase(NativeDatabase.memory()),
    );

    expect(report.isClean, isTrue);
    expect(report.migration.customers.sourceCount, 1);
    expect(report.migration.vendors.sourceCount, 1);
    expect(report.migration.customers.migratedCount, 1);
    expect(report.migration.vendors.migratedCount, 1);
    expect(report.parity.customers.matches, isTrue);
    expect(report.parity.vendors.matches, isTrue);
    expect(report.parity.duplicateCustomerKeys, isEmpty);
    expect(report.parity.duplicateVendorKeys, isEmpty);
  });

  test('rejects snapshots that are not explicitly sanitized', () {
    final json = _snapshotJson()..['sanitized'] = false;

    expect(
      () => DriftCustomersVendorsSnapshot.fromJson(json),
      throwsFormatException,
    );
  });

  test('rejects malformed sync status before opening SQLite', () {
    final json = _snapshotJson();
    final customers = json['customers']! as List<Object?>;
    final firstCustomer = customers.first! as Map<String, Object?>;
    customers[0] = {
      ...firstCustomer,
      'syncStatus': 'unknown',
    };

    expect(
      () => DriftCustomersVendorsSnapshot.fromJson(json),
      throwsFormatException,
    );
  });

  test('blocks clean acceptance when a scoped customer key is duplicated',
      () async {
    final json = _snapshotJson();
    final customers = json['customers']! as List<Object?>;
    final firstCustomer = customers.first! as Map<String, Object?>;
    customers.add({...firstCustomer});
    final snapshot = DriftCustomersVendorsSnapshot.fromJson(json);

    final report = await DriftCustomersVendorsSnapshotRunner().run(
      snapshot,
      databaseFactory: () => BasirDatabase(NativeDatabase.memory()),
    );

    expect(report.parity.customers.matches, isFalse);
    expect(report.parity.duplicateCustomerKeys, hasLength(1));
    expect(report.isClean, isFalse);
  });
}

Map<String, Object?> _snapshotJson() => {
      'sanitized': true,
      'schemaVersion': 1,
      'customers': <Object?>[
        <String, Object?>{
          'id': 'customer-a',
          'nameAr': 'عميل تجريبي',
          'nameEn': 'Sanitized Customer',
          'taxNumber': 'TAX-001',
          'phone': '+000000000',
          'email': 'customer@example.invalid',
          'address': 'Sanitized address',
          'notes': 'sanitized fixture',
          'createdAt': '2026-01-01T00:00:00Z',
          'updatedAt': '2026-01-02T00:00:00Z',
          'creditLimit': 1000.0,
          'balance': 125.5,
          'receivableAccountId': 'ar-account-a',
          'userId': 'user-a',
          'syncStatus': 'synced',
          'serverUpdatedAt': '2026-01-03T00:00:00Z',
          'isDeleted': false,
        },
      ],
      'vendors': <Object?>[
        <String, Object?>{
          'id': 'vendor-a',
          'nameAr': 'مورد تجريبي',
          'nameEn': 'Sanitized Vendor',
          'phone': '+000000001',
          'email': 'vendor@example.invalid',
          'address': 'Sanitized address',
          'notes': 'sanitized fixture',
          'createdAt': '2026-01-01T00:00:00Z',
          'updatedAt': '2026-01-02T00:00:00Z',
          'payableAccountId': 'ap-account-a',
          'vatNumber': 'VAT-001',
          'registrationNumber': 'REG-001',
          'balance': 75.25,
          'userId': 'user-a',
          'syncStatus': 'synced',
          'serverUpdatedAt': '2026-01-03T00:00:00Z',
          'isDeleted': false,
        },
      ],
    };
