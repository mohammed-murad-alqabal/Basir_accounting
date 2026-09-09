import 'package:basir_accounting_system/core/persistence/drift_customers_vendors_shadow_read.dart';
import 'package:basir_accounting_system/core/persistence/drift_settings_shadow_read.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:basir_accounting_system/features/customers/domain/repositories/customer_repository.dart';
import 'package:basir_accounting_system/features/vendors/domain/entities/vendor.dart';
import 'package:basir_accounting_system/features/vendors/domain/repositories/vendor_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('disabled customer shadow-read does not call candidate', () async {
    final source = _FakeCustomerRepository(
      customers: [_customer('customer-a')],
    );
    final candidate = _FakeCustomerRepository(
      customers: [_customer('customer-drift')],
    );
    final sink = InMemoryDriftShadowReadSink();
    final repository = ShadowReadCustomerRepository(
      source: source,
      candidate: candidate,
      comparator: DriftCustomersVendorsShadowReadComparator(
        recorder: sink.record,
      ),
      enabled: false,
    );

    final result = await repository.getAllCustomers();

    expect(result.single.id, 'customer-a');
    expect(candidate.getAllCalls, 0);
    expect(sink.events, isEmpty);
  });

  test(
      'enabled customer shadow-read returns source on mismatch and records safe event',
      () async {
    final source = _FakeCustomerRepository(
      customers: [_customer('customer-a')],
    );
    final candidate = _FakeCustomerRepository(
      customers: [_customer('customer-drift')],
    );
    final sink = InMemoryDriftShadowReadSink();
    final repository = ShadowReadCustomerRepository(
      source: source,
      candidate: candidate,
      comparator: DriftCustomersVendorsShadowReadComparator(
        recorder: sink.record,
        clock: () => DateTime.utc(2026, 8, 17),
      ),
      enabled: true,
    );

    final result = await repository.getAllCustomers();

    expect(result.single.id, 'customer-a');
    expect(candidate.getAllCalls, 1);
    expect(sink.events, hasLength(1));
    expect(sink.events.single.slice, 'customers');
    expect(sink.events.single.operation, 'getAllCustomers');
    expect(sink.events.single.outcome, DriftShadowReadOutcome.mismatch);
    expect(sink.events.single.recordedAt, DateTime.utc(2026, 8, 17));
  });

  test('customer writes remain delegated to source only', () async {
    final source = _FakeCustomerRepository();
    final candidate = _FakeCustomerRepository();
    final repository = ShadowReadCustomerRepository(
      source: source,
      candidate: candidate,
      comparator: DriftCustomersVendorsShadowReadComparator(
        recorder: (_) async {},
      ),
      enabled: true,
    );

    final customer = _customer('customer-a');
    await repository.addCustomer(customer);
    await repository.updateCustomer(customer);
    await repository.deleteCustomer(customer.id);
    await repository.deleteAllCustomers();

    expect(source.writeCalls, 4);
    expect(candidate.writeCalls, 0);
  });

  test('vendor list and lookup shadow-reads compare while returning source',
      () async {
    final source = _FakeVendorRepository(vendors: [_vendor('vendor-a')]);
    final candidate = _FakeVendorRepository(vendors: [_vendor('vendor-a')]);
    final sink = InMemoryDriftShadowReadSink();
    final repository = ShadowReadVendorRepository(
      source: source,
      candidate: candidate,
      comparator: DriftCustomersVendorsShadowReadComparator(
        recorder: sink.record,
      ),
      enabled: true,
    );

    final all = await repository.getAllVendors();
    final byId = await repository.getVendorById('vendor-a');

    expect(all.single.id, 'vendor-a');
    expect(byId?.id, 'vendor-a');
    expect(candidate.getAllCalls, 1);
    expect(candidate.getByIdCalls, 1);
    expect(sink.events, hasLength(2));
    expect(
      sink.events
          .every((event) => event.outcome == DriftShadowReadOutcome.match),
      isTrue,
    );
  });
}

Customer _customer(String id) => Customer(
      id: id,
      nameAr: 'عميل',
      nameEn: 'Customer',
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026, 1, 2),
      taxNumber: 'TAX',
      creditLimit: 100,
      balance: 10,
      userId: 'user-a',
    );

Vendor _vendor(String id) => Vendor(
      id: id,
      nameAr: 'مورد',
      nameEn: 'Vendor',
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026, 1, 2),
      payableAccountId: 'ap-account',
      balance: 10,
      userId: 'user-a',
    );

class _FakeCustomerRepository implements CustomerRepository {
  _FakeCustomerRepository({List<Customer>? customers})
      : _customers = [...?customers];

  final List<Customer> _customers;
  int getAllCalls = 0;
  int writeCalls = 0;

  @override
  Future<List<Customer>> getAllCustomers() async {
    getAllCalls += 1;
    return [..._customers];
  }

  @override
  Future<Customer?> getCustomerById(String id) async => _customers
      .where((customer) => customer.id == id)
      .cast<Customer?>()
      .firstOrNull;

  @override
  Future<List<Customer>> searchCustomers(String query) async => _customers;

  @override
  Future<void> addCustomer(Customer customer) async {
    writeCalls += 1;
  }

  @override
  Future<void> updateCustomer(Customer customer) async {
    writeCalls += 1;
  }

  @override
  Future<void> deleteCustomer(String id) async {
    writeCalls += 1;
  }

  @override
  Future<void> deleteAllCustomers() async {
    writeCalls += 1;
  }
}

class _FakeVendorRepository implements VendorRepository {
  _FakeVendorRepository({List<Vendor>? vendors}) : _vendors = [...?vendors];

  final List<Vendor> _vendors;
  int getAllCalls = 0;
  int getByIdCalls = 0;
  int writeCalls = 0;

  @override
  Future<List<Vendor>> getAllVendors() async {
    getAllCalls += 1;
    return [..._vendors];
  }

  @override
  Future<Vendor?> getVendorById(String id) async {
    getByIdCalls += 1;
    for (final vendor in _vendors) {
      if (vendor.id == id) return vendor;
    }
    return null;
  }

  @override
  Future<List<Vendor>> searchVendors(String query) async => _vendors;

  @override
  Future<void> addVendor(Vendor vendor) async {
    writeCalls += 1;
  }

  @override
  Future<void> updateVendor(Vendor vendor) async {
    writeCalls += 1;
  }

  @override
  Future<void> deleteVendor(String id) async {
    writeCalls += 1;
  }
}
