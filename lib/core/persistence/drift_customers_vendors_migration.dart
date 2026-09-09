import 'package:basir_accounting_system/features/customers/data/models/customer_model.dart';
import 'package:basir_accounting_system/features/vendors/data/models/vendor_model.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:isar/isar.dart';

/// شرائح مستقلة لمهاجر Customers وVendors.
abstract final class DriftCustomersVendorsMigrationSlice {
  static const customers = 'customers-v1';
  static const vendors = 'vendors-v1';
}

typedef CustomerMigrationReader = Future<List<CustomerRecord>> Function();
typedef VendorMigrationReader = Future<List<VendorRecord>> Function();

/// قارئ Customers من Isar فقط، مع تحويل محايد وترتيب deterministic.
class IsarCustomerMigrationSource {
  IsarCustomerMigrationSource(this._isar);

  final Isar _isar;

  Future<List<CustomerRecord>> readAll() async {
    final records = (await _isar.customerModels.where().findAll())
        .map(_toRecord)
        .toList(growable: false)
      ..sort(_compareCustomers);
    return records;
  }

  static CustomerRecord _toRecord(CustomerModel model) => CustomerRecord(
        id: model.customerId,
        nameAr: model.nameAr,
        nameEn: model.nameEn,
        taxNumber: model.taxNumber,
        phone: model.phone,
        email: model.email,
        address: model.address,
        notes: model.notes,
        createdAt: model.createdAt.toUtc(),
        updatedAt: model.updatedAt.toUtc(),
        creditLimit: model.creditLimit,
        balance: model.balance,
        receivableAccountId: model.receivableAccountId,
        userId: model.userId,
        syncStatus: model.syncStatus.name,
        serverUpdatedAt: model.serverUpdatedAt?.toUtc(),
        isDeleted: model.isDeleted,
      );
}

/// قارئ Vendors من Isar فقط، مع تحويل محايد وترتيب deterministic.
class IsarVendorMigrationSource {
  IsarVendorMigrationSource(this._isar);

  final Isar _isar;

  Future<List<VendorRecord>> readAll() async {
    final records = (await _isar.vendorModels.where().findAll())
        .map(_toRecord)
        .toList(growable: false)
      ..sort(_compareVendors);
    return records;
  }

  static VendorRecord _toRecord(VendorModel model) => VendorRecord(
        id: model.vendorId,
        nameAr: model.nameAr,
        nameEn: model.nameEn,
        phone: model.phone,
        email: model.email,
        address: model.address,
        notes: model.notes,
        createdAt: model.createdAt.toUtc(),
        updatedAt: model.updatedAt.toUtc(),
        payableAccountId: model.payableAccountId,
        vatNumber: model.vatNumber,
        registrationNumber: model.registrationNumber,
        balance: model.balance,
        userId: model.userId,
        syncStatus: model.syncStatus.name,
        serverUpdatedAt: model.serverUpdatedAt?.toUtc(),
        isDeleted: model.isDeleted,
      );
}

class DriftCustomersVendorsMigrationReport {
  const DriftCustomersVendorsMigrationReport({
    required this.customers,
    required this.vendors,
  });

  final MigrationCheckpoint customers;
  final MigrationCheckpoint vendors;

  bool get isComplete => customers.isComplete && vendors.isComplete;
}

/// يستورد Customers وVendors إلى Drift؛ لا يسجل Providers ولا يكتب Isar.
class DriftCustomersVendorsMigrator {
  DriftCustomersVendorsMigrator({
    required CustomerMigrationReader customerSource,
    required VendorMigrationReader vendorSource,
    required CustomerStorage customerStorage,
    required VendorStorage vendorStorage,
    required MigrationCheckpointStorage checkpoints,
  })  : _customerSource = customerSource,
        _vendorSource = vendorSource,
        _customerStorage = customerStorage,
        _vendorStorage = vendorStorage,
        _checkpoints = checkpoints;

  final CustomerMigrationReader _customerSource;
  final VendorMigrationReader _vendorSource;
  final CustomerStorage _customerStorage;
  final VendorStorage _vendorStorage;
  final MigrationCheckpointStorage _checkpoints;

  Future<DriftCustomersVendorsMigrationReport> migrate({
    int batchSize = 250,
  }) async {
    if (batchSize <= 0) {
      throw ArgumentError.value(batchSize, 'batchSize', 'Must be positive.');
    }

    final customers = await _migrateCustomers(batchSize: batchSize);
    final vendors = await _migrateVendors(batchSize: batchSize);
    return DriftCustomersVendorsMigrationReport(
      customers: customers,
      vendors: vendors,
    );
  }

  Future<MigrationCheckpoint> _migrateCustomers({
    required int batchSize,
  }) async {
    final records = await _customerSource();
    return _writeBatches<CustomerRecord>(
      slice: DriftCustomersVendorsMigrationSlice.customers,
      records: records,
      batchSize: batchSize,
      write: _customerStorage.save,
    );
  }

  Future<MigrationCheckpoint> _migrateVendors({required int batchSize}) async {
    final records = await _vendorSource();
    return _writeBatches<VendorRecord>(
      slice: DriftCustomersVendorsMigrationSlice.vendors,
      records: records,
      batchSize: batchSize,
      write: _vendorStorage.save,
    );
  }

  Future<MigrationCheckpoint> _writeBatches<T>({
    required String slice,
    required List<T> records,
    required int batchSize,
    required Future<void> Function(T record) write,
  }) async {
    var migratedCount = 0;
    for (var start = 0; start < records.length; start += batchSize) {
      final end = start + batchSize < records.length
          ? start + batchSize
          : records.length;
      for (final record in records.sublist(start, end)) {
        await write(record);
        migratedCount += 1;
      }
      await _checkpoints.save(
        MigrationCheckpoint(
          slice: slice,
          sourceCount: records.length,
          migratedCount: migratedCount,
          completedAt: null,
        ),
      );
    }

    final checkpoint = MigrationCheckpoint(
      slice: slice,
      sourceCount: records.length,
      migratedCount: migratedCount,
      completedAt: DateTime.now().toUtc(),
    );
    await _checkpoints.save(checkpoint);
    return checkpoint;
  }
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
