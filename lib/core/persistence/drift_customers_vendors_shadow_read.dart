import 'package:basir_accounting_system/core/persistence/drift_settings_shadow_read.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:basir_accounting_system/features/customers/domain/repositories/customer_repository.dart';
import 'package:basir_accounting_system/features/vendors/domain/entities/vendor.dart';
import 'package:basir_accounting_system/features/vendors/domain/repositories/vendor_repository.dart';

/// مشغل shadow-read مستقل لـCustomers وVendors.
///
/// لا يحمل telemetry أي userId أو payload، ولا يغير نتيجة القراءة التي يراها
/// المستخدم. عند إغلاق flag لا يستدعي المرشح إطلاقًا.
class DriftCustomersVendorsShadowReadComparator {
  DriftCustomersVendorsShadowReadComparator({
    required DriftShadowReadRecorder recorder,
    DateTime Function()? clock,
  })  : _recorder = recorder,
        _clock = clock ?? DateTime.now;

  final DriftShadowReadRecorder _recorder;
  final DateTime Function() _clock;

  Future<DriftShadowReadResult> compareCustomers({
    required String operation,
    required Future<List<Customer>> Function() sourceRead,
    required Future<List<Customer>> Function() candidateRead,
  }) =>
      _compare(
        slice: 'customers',
        operation: operation,
        sourceRead: sourceRead,
        candidateRead: candidateRead,
        equals: _customerListsEqual,
      );

  Future<DriftShadowReadResult> compareCustomer({
    required String operation,
    required Future<Customer?> Function() sourceRead,
    required Future<Customer?> Function() candidateRead,
  }) =>
      _compare(
        slice: 'customers',
        operation: operation,
        sourceRead: sourceRead,
        candidateRead: candidateRead,
        equals: _customerEqual,
      );

  Future<DriftShadowReadResult> compareVendors({
    required String operation,
    required Future<List<Vendor>> Function() sourceRead,
    required Future<List<Vendor>> Function() candidateRead,
  }) =>
      _compare(
        slice: 'vendors',
        operation: operation,
        sourceRead: sourceRead,
        candidateRead: candidateRead,
        equals: _vendorListsEqual,
      );

  Future<DriftShadowReadResult> compareVendor({
    required String operation,
    required Future<Vendor?> Function() sourceRead,
    required Future<Vendor?> Function() candidateRead,
  }) =>
      _compare(
        slice: 'vendors',
        operation: operation,
        sourceRead: sourceRead,
        candidateRead: candidateRead,
        equals: _vendorEqual,
      );

  Future<DriftShadowReadResult> _compare<T>({
    required String slice,
    required String operation,
    required Future<T?> Function() sourceRead,
    required Future<T?> Function() candidateRead,
    required bool Function(T source, T candidate) equals,
  }) async {
    late final T? source;
    try {
      source = await sourceRead();
    } on Object {
      return _record(
        slice: slice,
        operation: operation,
        outcome: DriftShadowReadOutcome.sourceError,
      );
    }

    late final T? candidate;
    try {
      candidate = await candidateRead();
    } on Object {
      return _record(
        slice: slice,
        operation: operation,
        outcome: DriftShadowReadOutcome.candidateError,
      );
    }

    final matches = source == null || candidate == null
        ? source == null && candidate == null
        : equals(source, candidate);
    return _record(
      slice: slice,
      operation: operation,
      outcome: matches
          ? DriftShadowReadOutcome.match
          : DriftShadowReadOutcome.mismatch,
    );
  }

  Future<DriftShadowReadResult> _record({
    required String slice,
    required String operation,
    required DriftShadowReadOutcome outcome,
  }) async {
    final recordedAt = _clock().toUtc();
    await _recorder(
      DriftShadowReadEvent(
        slice: slice,
        operation: operation,
        outcome: outcome,
        recordedAt: recordedAt,
      ),
    );
    return DriftShadowReadResult(outcome: outcome, recordedAt: recordedAt);
  }
}

class ShadowReadCustomerRepository implements CustomerRepository {
  ShadowReadCustomerRepository({
    required CustomerRepository source,
    required CustomerRepository candidate,
    required DriftCustomersVendorsShadowReadComparator comparator,
    required bool enabled,
  })  : _source = source,
        _candidate = candidate,
        _comparator = comparator,
        _enabled = enabled;

  final CustomerRepository _source;
  final CustomerRepository _candidate;
  final DriftCustomersVendorsShadowReadComparator _comparator;
  final bool _enabled;

  @override
  Future<List<Customer>> getAllCustomers() async {
    if (!_enabled) return _source.getAllCustomers();
    final sourceValue = await _source.getAllCustomers();
    await _comparator.compareCustomers(
      operation: 'getAllCustomers',
      sourceRead: () async => sourceValue,
      candidateRead: _candidate.getAllCustomers,
    );
    return sourceValue;
  }

  @override
  Future<Customer?> getCustomerById(String id) async {
    if (!_enabled) return _source.getCustomerById(id);
    final sourceValue = await _source.getCustomerById(id);
    await _comparator.compareCustomer(
      operation: 'getCustomerById',
      sourceRead: () async => sourceValue,
      candidateRead: () => _candidate.getCustomerById(id),
    );
    return sourceValue;
  }

  @override
  Future<List<Customer>> searchCustomers(String query) async {
    if (!_enabled) return _source.searchCustomers(query);
    final sourceValue = await _source.searchCustomers(query);
    await _comparator.compareCustomers(
      operation: 'searchCustomers',
      sourceRead: () async => sourceValue,
      candidateRead: () => _candidate.searchCustomers(query),
    );
    return sourceValue;
  }

  @override
  Future<void> addCustomer(Customer customer) => _source.addCustomer(customer);

  @override
  Future<void> updateCustomer(Customer customer) =>
      _source.updateCustomer(customer);

  @override
  Future<void> deleteCustomer(String id) => _source.deleteCustomer(id);

  @override
  Future<void> deleteAllCustomers() => _source.deleteAllCustomers();
}

class ShadowReadVendorRepository implements VendorRepository {
  ShadowReadVendorRepository({
    required VendorRepository source,
    required VendorRepository candidate,
    required DriftCustomersVendorsShadowReadComparator comparator,
    required bool enabled,
  })  : _source = source,
        _candidate = candidate,
        _comparator = comparator,
        _enabled = enabled;

  final VendorRepository _source;
  final VendorRepository _candidate;
  final DriftCustomersVendorsShadowReadComparator _comparator;
  final bool _enabled;

  @override
  Future<List<Vendor>> getAllVendors() async {
    if (!_enabled) return _source.getAllVendors();
    final sourceValue = await _source.getAllVendors();
    await _comparator.compareVendors(
      operation: 'getAllVendors',
      sourceRead: () async => sourceValue,
      candidateRead: _candidate.getAllVendors,
    );
    return sourceValue;
  }

  @override
  Future<Vendor?> getVendorById(String id) async {
    if (!_enabled) return _source.getVendorById(id);
    final sourceValue = await _source.getVendorById(id);
    await _comparator.compareVendor(
      operation: 'getVendorById',
      sourceRead: () async => sourceValue,
      candidateRead: () => _candidate.getVendorById(id),
    );
    return sourceValue;
  }

  @override
  Future<List<Vendor>> searchVendors(String query) async {
    if (!_enabled) return _source.searchVendors(query);
    final sourceValue = await _source.searchVendors(query);
    await _comparator.compareVendors(
      operation: 'searchVendors',
      sourceRead: () async => sourceValue,
      candidateRead: () => _candidate.searchVendors(query),
    );
    return sourceValue;
  }

  @override
  Future<void> addVendor(Vendor vendor) => _source.addVendor(vendor);

  @override
  Future<void> updateVendor(Vendor vendor) => _source.updateVendor(vendor);

  @override
  Future<void> deleteVendor(String id) => _source.deleteVendor(id);
}

bool _customerListsEqual(List<Customer> left, List<Customer> right) {
  final sortedLeft = [...left]..sort(_compareCustomers);
  final sortedRight = [...right]..sort(_compareCustomers);
  if (sortedLeft.length != sortedRight.length) return false;
  for (var index = 0; index < sortedLeft.length; index += 1) {
    if (!_customerEqual(sortedLeft[index], sortedRight[index])) return false;
  }
  return true;
}

bool _vendorListsEqual(List<Vendor> left, List<Vendor> right) {
  final sortedLeft = [...left]..sort(_compareVendors);
  final sortedRight = [...right]..sort(_compareVendors);
  if (sortedLeft.length != sortedRight.length) return false;
  for (var index = 0; index < sortedLeft.length; index += 1) {
    if (!_vendorEqual(sortedLeft[index], sortedRight[index])) return false;
  }
  return true;
}

bool _customerEqual(Customer left, Customer right) =>
    left.id == right.id &&
    left.nameAr == right.nameAr &&
    left.nameEn == right.nameEn &&
    left.taxNumber == right.taxNumber &&
    left.phone == right.phone &&
    left.email == right.email &&
    left.address == right.address &&
    left.notes == right.notes &&
    left.createdAt.toUtc() == right.createdAt.toUtc() &&
    left.updatedAt.toUtc() == right.updatedAt.toUtc() &&
    left.creditLimit == right.creditLimit &&
    left.balance == right.balance &&
    left.receivableAccountId == right.receivableAccountId &&
    left.userId == right.userId &&
    left.syncStatus == right.syncStatus &&
    left.serverUpdatedAt?.toUtc() == right.serverUpdatedAt?.toUtc() &&
    left.isDeleted == right.isDeleted;

bool _vendorEqual(Vendor left, Vendor right) =>
    left.id == right.id &&
    left.nameAr == right.nameAr &&
    left.nameEn == right.nameEn &&
    left.phone == right.phone &&
    left.email == right.email &&
    left.address == right.address &&
    left.notes == right.notes &&
    left.createdAt.toUtc() == right.createdAt.toUtc() &&
    left.updatedAt.toUtc() == right.updatedAt.toUtc() &&
    left.payableAccountId == right.payableAccountId &&
    left.vatNumber == right.vatNumber &&
    left.registrationNumber == right.registrationNumber &&
    left.balance == right.balance &&
    left.userId == right.userId &&
    left.syncStatus == right.syncStatus &&
    left.serverUpdatedAt?.toUtc() == right.serverUpdatedAt?.toUtc() &&
    left.isDeleted == right.isDeleted;

int _compareCustomers(Customer left, Customer right) {
  final user = (left.userId ?? '').compareTo(right.userId ?? '');
  if (user != 0) return user;
  return left.id.compareTo(right.id);
}

int _compareVendors(Vendor left, Vendor right) {
  final user = (left.userId ?? '').compareTo(right.userId ?? '');
  if (user != 0) return user;
  return left.id.compareTo(right.id);
}
