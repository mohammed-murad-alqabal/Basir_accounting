import 'dart:convert';

import 'package:basir_accounting_system/core/persistence/drift_customers_vendors_migration.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';

class DriftCustomersVendorsParityComparison {
  const DriftCustomersVendorsParityComparison({
    required this.scope,
    required this.expectedCount,
    required this.actualCount,
    required this.expectedFingerprint,
    required this.actualFingerprint,
  });

  final String scope;
  final int expectedCount;
  final int actualCount;
  final String expectedFingerprint;
  final String actualFingerprint;

  bool get matches =>
      expectedCount == actualCount && expectedFingerprint == actualFingerprint;
}

class DriftCustomersVendorsParityReport {
  const DriftCustomersVendorsParityReport({
    required this.customers,
    required this.vendors,
    required this.duplicateCustomerKeys,
    required this.duplicateVendorKeys,
  });

  final DriftCustomersVendorsParityComparison customers;
  final DriftCustomersVendorsParityComparison vendors;
  final List<String> duplicateCustomerKeys;
  final List<String> duplicateVendorKeys;

  bool get isClean =>
      customers.matches &&
      vendors.matches &&
      duplicateCustomerKeys.isEmpty &&
      duplicateVendorKeys.isEmpty;
}

/// يقارن Isar وDrift بعد import Customers وVendors دون حذف أو إصلاح تلقائي.
class DriftCustomersVendorsParityVerifier {
  DriftCustomersVendorsParityVerifier({
    required CustomerMigrationReader customerSource,
    required VendorMigrationReader vendorSource,
    required CustomerStorage customerStorage,
    required VendorStorage vendorStorage,
  })  : _customerSource = customerSource,
        _vendorSource = vendorSource,
        _customerStorage = customerStorage,
        _vendorStorage = vendorStorage;

  final CustomerMigrationReader _customerSource;
  final VendorMigrationReader _vendorSource;
  final CustomerStorage _customerStorage;
  final VendorStorage _vendorStorage;

  Future<DriftCustomersVendorsParityReport> verify() async {
    final sourceCustomers = await _customerSource();
    final sourceVendors = await _vendorSource();
    final actualCustomers = await _customerStorage.readAll();
    final actualVendors = await _vendorStorage.readAll();

    return DriftCustomersVendorsParityReport(
      customers: _comparison(
        scope: 'customers/all',
        expected: _sortCustomers(sourceCustomers)
            .map(_canonicalCustomer)
            .toList(growable: false),
        actual: _sortCustomers(actualCustomers)
            .map(_canonicalCustomer)
            .toList(growable: false),
      ),
      vendors: _comparison(
        scope: 'vendors/all',
        expected: _sortVendors(sourceVendors)
            .map(_canonicalVendor)
            .toList(growable: false),
        actual: _sortVendors(actualVendors)
            .map(_canonicalVendor)
            .toList(growable: false),
      ),
      duplicateCustomerKeys: _duplicateKeys(
        sourceCustomers.map((record) => _scopedKey(record.userId, record.id)),
      ),
      duplicateVendorKeys: _duplicateKeys(
        sourceVendors.map((record) => _scopedKey(record.userId, record.id)),
      ),
    );
  }

  static DriftCustomersVendorsParityComparison _comparison({
    required String scope,
    required List<String> expected,
    required List<String> actual,
  }) =>
      DriftCustomersVendorsParityComparison(
        scope: scope,
        expectedCount: expected.length,
        actualCount: actual.length,
        expectedFingerprint: _fingerprint(expected),
        actualFingerprint: _fingerprint(actual),
      );

  static List<CustomerRecord> _sortCustomers(List<CustomerRecord> records) =>
      [...records]..sort(_compareCustomers);

  static List<VendorRecord> _sortVendors(List<VendorRecord> records) =>
      [...records]..sort(_compareVendors);
}

String _canonicalCustomer(CustomerRecord record) => [
      record.id,
      record.nameAr,
      record.nameEn,
      _nullable(record.taxNumber),
      _nullable(record.phone),
      _nullable(record.email),
      _nullable(record.address),
      _nullable(record.notes),
      record.createdAt.toUtc().toIso8601String(),
      record.updatedAt.toUtc().toIso8601String(),
      record.creditLimit.toStringAsPrecision(17),
      record.balance.toStringAsPrecision(17),
      _nullable(record.receivableAccountId),
      _nullable(record.userId),
      record.syncStatus,
      _nullable(record.serverUpdatedAt?.toUtc().toIso8601String()),
      record.isDeleted.toString(),
    ].join('\u0000');

String _canonicalVendor(VendorRecord record) => [
      record.id,
      record.nameAr,
      record.nameEn,
      _nullable(record.phone),
      _nullable(record.email),
      _nullable(record.address),
      _nullable(record.notes),
      record.createdAt.toUtc().toIso8601String(),
      record.updatedAt.toUtc().toIso8601String(),
      _nullable(record.payableAccountId),
      _nullable(record.vatNumber),
      _nullable(record.registrationNumber),
      record.balance.toStringAsPrecision(17),
      _nullable(record.userId),
      record.syncStatus,
      _nullable(record.serverUpdatedAt?.toUtc().toIso8601String()),
      record.isDeleted.toString(),
    ].join('\u0000');

String _nullable(String? value) => value == null ? '\u0001' : '\u0002$value';

String _scopedKey(String? userId, String id) =>
    '${userScopeKey(userId)}\u0000$id';

List<String> _duplicateKeys(Iterable<String> keys) {
  final counts = <String, int>{};
  for (final key in keys) {
    counts.update(key, (count) => count + 1, ifAbsent: () => 1);
  }
  return counts.entries
      .where((entry) => entry.value > 1)
      .map((entry) => _fingerprint([entry.key]))
      .toList(growable: false)
    ..sort();
}

String _fingerprint(List<String> values) {
  var hash = 0x811c9dc5;
  for (final value in values) {
    for (final byte in utf8.encode(value)) {
      hash = ((hash * 31) + byte).toUnsigned(32);
    }
    hash = ((hash * 31) + 0xff).toUnsigned(32);
  }
  return hash.toRadixString(16).padLeft(8, '0');
}

int _compareCustomers(CustomerRecord left, CustomerRecord right) {
  final scope = userScopeKey(left.userId).compareTo(userScopeKey(right.userId));
  if (scope != 0) return scope;
  return left.id.compareTo(right.id);
}

int _compareVendors(VendorRecord left, VendorRecord right) {
  final scope = userScopeKey(left.userId).compareTo(userScopeKey(right.userId));
  if (scope != 0) return scope;
  return left.id.compareTo(right.id);
}
