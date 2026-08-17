import 'dart:convert';

import 'package:basir_accounting_system/core/persistence/drift_customers_vendors_migration.dart';
import 'package:basir_accounting_system/core/persistence/drift_customers_vendors_parity.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';

/// لقطة معقمة لا ترتبط بقاعدة Isar التشغيلية أو بأي payload إنتاجي.
class DriftCustomersVendorsSnapshot {
  const DriftCustomersVendorsSnapshot({
    required this.schemaVersion,
    required this.customers,
    required this.vendors,
  });

  factory DriftCustomersVendorsSnapshot.fromJsonString(String source) =>
      DriftCustomersVendorsSnapshot.fromJson(
        jsonDecode(source) as Map<String, Object?>,
      );

  factory DriftCustomersVendorsSnapshot.fromJson(Map<String, Object?> json) {
    if (json['sanitized'] != true) {
      throw const FormatException('Snapshot must explicitly be sanitized.');
    }
    if (json['schemaVersion'] != 1) {
      throw FormatException(
        'Unsupported snapshot schema: ${json['schemaVersion']}.',
      );
    }

    return DriftCustomersVendorsSnapshot(
      schemaVersion: 1,
      customers: _readList(json['customers'], _customerFromJson),
      vendors: _readList(json['vendors'], _vendorFromJson),
    );
  }

  final int schemaVersion;
  final List<CustomerRecord> customers;
  final List<VendorRecord> vendors;

  static List<T> _readList<T>(
    Object? value,
    T Function(Map<String, Object?> json) decode,
  ) {
    if (value is! List<Object?>) {
      throw const FormatException('Snapshot collection is missing.');
    }
    return value.map((item) {
      if (item is! Map<String, Object?>) {
        throw const FormatException('Snapshot record must be an object.');
      }
      return decode(item);
    }).toList(growable: false);
  }
}

/// نتيجة تشغيل offline؛ لا تحتفظ بقاعدة البيانات أو payload بعد الإغلاق.
class DriftCustomersVendorsSnapshotRunReport {
  const DriftCustomersVendorsSnapshotRunReport({
    required this.migration,
    required this.parity,
  });

  final DriftCustomersVendorsMigrationReport migration;
  final DriftCustomersVendorsParityReport parity;

  bool get isClean => migration.isComplete && parity.isClean;
}

/// يشغل snapshot معقمة داخل SQLite في الذاكرة فقط.
class DriftCustomersVendorsSnapshotRunner {
  Future<DriftCustomersVendorsSnapshotRunReport> run(
    DriftCustomersVendorsSnapshot snapshot, {
    required BasirDatabase Function() databaseFactory,
    int batchSize = 250,
  }) async {
    final database = databaseFactory();
    try {
      final customerStorage = CustomerStore(database);
      final vendorStorage = VendorStore(database);
      final checkpoints = LocalMetadataMigrationCheckpointStore(database);
      Future<List<CustomerRecord>> customerSource() async => snapshot.customers;
      Future<List<VendorRecord>> vendorSource() async => snapshot.vendors;

      final migration = await DriftCustomersVendorsMigrator(
        customerSource: customerSource,
        vendorSource: vendorSource,
        customerStorage: customerStorage,
        vendorStorage: vendorStorage,
        checkpoints: checkpoints,
      ).migrate(batchSize: batchSize);
      final parity = await DriftCustomersVendorsParityVerifier(
        customerSource: customerSource,
        vendorSource: vendorSource,
        customerStorage: customerStorage,
        vendorStorage: vendorStorage,
      ).verify();

      return DriftCustomersVendorsSnapshotRunReport(
        migration: migration,
        parity: parity,
      );
    } finally {
      await database.close();
    }
  }
}

CustomerRecord _customerFromJson(Map<String, Object?> json) => CustomerRecord(
      id: _requiredString(json, 'id'),
      nameAr: _requiredString(json, 'nameAr'),
      nameEn: _requiredString(json, 'nameEn'),
      taxNumber: _optionalString(json, 'taxNumber'),
      phone: _optionalString(json, 'phone'),
      email: _optionalString(json, 'email'),
      address: _optionalString(json, 'address'),
      notes: _optionalString(json, 'notes'),
      createdAt: _requiredDate(json, 'createdAt'),
      updatedAt: _requiredDate(json, 'updatedAt'),
      creditLimit: _requiredFiniteNumber(json, 'creditLimit'),
      balance: _requiredFiniteNumber(json, 'balance'),
      receivableAccountId: _optionalString(json, 'receivableAccountId'),
      userId: _optionalString(json, 'userId'),
      syncStatus: _requiredSyncStatus(json, 'syncStatus'),
      serverUpdatedAt: _optionalDate(json, 'serverUpdatedAt'),
      isDeleted: _requiredBool(json, 'isDeleted'),
    );

VendorRecord _vendorFromJson(Map<String, Object?> json) => VendorRecord(
      id: _requiredString(json, 'id'),
      nameAr: _requiredString(json, 'nameAr'),
      nameEn: _requiredString(json, 'nameEn'),
      phone: _optionalString(json, 'phone'),
      email: _optionalString(json, 'email'),
      address: _optionalString(json, 'address'),
      notes: _optionalString(json, 'notes'),
      createdAt: _requiredDate(json, 'createdAt'),
      updatedAt: _requiredDate(json, 'updatedAt'),
      payableAccountId: _optionalString(json, 'payableAccountId'),
      vatNumber: _optionalString(json, 'vatNumber'),
      registrationNumber: _optionalString(json, 'registrationNumber'),
      balance: _requiredFiniteNumber(json, 'balance'),
      userId: _optionalString(json, 'userId'),
      syncStatus: _requiredSyncStatus(json, 'syncStatus'),
      serverUpdatedAt: _optionalDate(json, 'serverUpdatedAt'),
      isDeleted: _requiredBool(json, 'isDeleted'),
    );

String _requiredString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! String || value.isEmpty) {
    throw FormatException('Snapshot field $key must be a non-empty string.');
  }
  return value;
}

String? _optionalString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is! String) {
    throw FormatException('Snapshot field $key must be a string or null.');
  }
  return value;
}

DateTime _requiredDate(Map<String, Object?> json, String key) {
  final value = _requiredString(json, key);
  final parsed = DateTime.tryParse(value);
  if (parsed == null) throw FormatException('Snapshot field $key is invalid.');
  return parsed.toUtc();
}

DateTime? _optionalDate(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is! String || value.isEmpty) {
    throw FormatException('Snapshot field $key must be an ISO date or null.');
  }
  final parsed = DateTime.tryParse(value);
  if (parsed == null) throw FormatException('Snapshot field $key is invalid.');
  return parsed.toUtc();
}

bool _requiredBool(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! bool) {
    throw FormatException('Snapshot field $key must be boolean.');
  }
  return value;
}

double _requiredFiniteNumber(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is num && value.toDouble().isFinite) return value.toDouble();
  throw FormatException('Snapshot field $key must be a finite number.');
}

String _requiredSyncStatus(Map<String, Object?> json, String key) {
  final value = _requiredString(json, key);
  if (!const {'synced', 'pendingPush', 'pendingPull', 'conflict'}
      .contains(value)) {
    throw FormatException('Snapshot field $key has an unsupported value.');
  }
  return value;
}
