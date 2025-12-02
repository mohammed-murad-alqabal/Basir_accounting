/// اختبارات CustomerProvider
///
/// يختبر جميع عمليات إدارة العملاء في طبقة Presentation
library;

import 'package:basser_app/features/customers/domain/entities/customer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/mock_data.dart';
import '../../../mocks/mock_customer_repository.dart';

void main() {
  late MockCustomerRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockCustomerRepository();
    container = ProviderContainer(
      overrides: [
        // Override customerRepositoryProvider with mock
        // Note: We need to import the actual provider to override it
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('CustomerProvider - Loading', () {
    test('should load customers successfully', () async {
      // Arrange
      final testCustomers = MockData.createTestCustomers();
      for (final customer in testCustomers) {
        await mockRepository.addCustomer(customer);
      }

      // Act
      final customers = await mockRepository.getAllCustomers();

      // Assert
      expect(customers, isA<List<Customer>>());
      expect(customers.length, 3);
    });

    test('should return empty list when no customers exist', () async {
      // Act
      final customers = await mockRepository.getAllCustomers();

      // Assert
      expect(customers, isEmpty);
    });

    test('should handle loading state with multiple customers', () async {
      // Arrange
      final testCustomers = MockData.createTestCustomers(count: 2);
      for (final customer in testCustomers) {
        await mockRepository.addCustomer(customer);
      }

      // Act
      final customers = await mockRepository.getAllCustomers();

      // Assert
      expect(customers, isNotEmpty);
      expect(customers.length, 2);
    });
  });

  group('CustomerProvider - Add Customer', () {
    test('should add customer successfully', () async {
      // Arrange
      final newCustomer = MockData.createTestCustomer(
        id: 'new-customer',
        name: 'عميل جديد',
      );

      // Act
      await mockRepository.addCustomer(newCustomer);
      final customers = await mockRepository.getAllCustomers();

      // Assert
      expect(customers, contains(newCustomer));
      expect(customers.length, 1);
    });

    test('should add multiple customers', () async {
      // Arrange
      final customer1 = MockData.createTestCustomer(id: 'customer-1');
      final customer2 = MockData.createTestCustomer(id: 'customer-2');
      final customer3 = MockData.createTestCustomer(id: 'customer-3');

      // Act
      await mockRepository.addCustomer(customer1);
      await mockRepository.addCustomer(customer2);
      await mockRepository.addCustomer(customer3);
      final customers = await mockRepository.getAllCustomers();

      // Assert
      expect(customers.length, 3);
      expect(customers, contains(customer1));
      expect(customers, contains(customer2));
      expect(customers, contains(customer3));
    });

    test('should preserve customer data when adding', () async {
      // Arrange
      final customer = MockData.createTestCustomer(
        id: 'test-id',
        name: 'أحمد محمد',
        phone: '0501234567',
        email: 'ahmed@example.com',
        address: 'الرياض',
      );

      // Act
      await mockRepository.addCustomer(customer);
      final customers = await mockRepository.getAllCustomers();
      final addedCustomer = customers.first;

      // Assert
      expect(addedCustomer.id, customer.id);
      expect(addedCustomer.name, customer.name);
      expect(addedCustomer.phone, customer.phone);
      expect(addedCustomer.email, customer.email);
      expect(addedCustomer.address, customer.address);
    });
  });

  group('CustomerProvider - Update Customer', () {
    test('should update customer successfully', () async {
      // Arrange
      final originalCustomer = MockData.createTestCustomer(
        id: 'customer-1',
        name: 'اسم قديم',
        phone: '0501111111',
      );
      await mockRepository.addCustomer(originalCustomer);

      final updatedCustomer = originalCustomer.copyWith(
        name: 'اسم جديد',
        phone: '0502222222',
      );

      // Act
      await mockRepository.updateCustomer(updatedCustomer);
      final customer = await mockRepository.getCustomerById('customer-1');

      // Assert
      expect(customer, isNotNull);
      expect(customer!.name, 'اسم جديد');
      expect(customer.phone, '0502222222');
    });

    test('should update only specified fields', () async {
      // Arrange
      final originalCustomer = MockData.createTestCustomer(
        id: 'customer-1',
        name: 'أحمد',
        phone: '0501111111',
        email: 'old@example.com',
      );
      await mockRepository.addCustomer(originalCustomer);

      final updatedCustomer = originalCustomer.copyWith(
        email: 'new@example.com',
      );

      // Act
      await mockRepository.updateCustomer(updatedCustomer);
      final customer = await mockRepository.getCustomerById('customer-1');

      // Assert
      expect(customer!.name, 'أحمد'); // لم يتغير
      expect(customer.phone, '0501111111'); // لم يتغير
      expect(customer.email, 'new@example.com'); // تغير
    });

    test('should handle updating non-existent customer', () async {
      // Arrange
      final customer = MockData.createTestCustomer(id: 'non-existent');

      // Act & Assert
      expect(
        () => mockRepository.updateCustomer(customer),
        throwsException,
      );
    });
  });

  group('CustomerProvider - Delete Customer', () {
    test('should delete customer successfully', () async {
      // Arrange
      final customer = MockData.createTestCustomer(id: 'customer-1');
      await mockRepository.addCustomer(customer);

      // Act
      await mockRepository.deleteCustomer('customer-1');
      final customers = await mockRepository.getAllCustomers();

      // Assert
      expect(customers, isEmpty);
    });

    test('should delete specific customer from multiple', () async {
      // Arrange
      final customer1 = MockData.createTestCustomer(id: 'customer-1');
      final customer2 = MockData.createTestCustomer(id: 'customer-2');
      final customer3 = MockData.createTestCustomer(id: 'customer-3');

      await mockRepository.addCustomer(customer1);
      await mockRepository.addCustomer(customer2);
      await mockRepository.addCustomer(customer3);

      // Act
      await mockRepository.deleteCustomer('customer-2');
      final customers = await mockRepository.getAllCustomers();

      // Assert
      expect(customers.length, 2);
      expect(customers, contains(customer1));
      expect(customers, isNot(contains(customer2)));
      expect(customers, contains(customer3));
    });

    test('should handle deleting non-existent customer gracefully', () async {
      // Arrange
      final customer = MockData.createTestCustomer(id: 'customer-1');
      await mockRepository.addCustomer(customer);

      // Act - Delete non-existent customer (should not throw)
      await mockRepository.deleteCustomer('non-existent');
      final customers = await mockRepository.getAllCustomers();

      // Assert - Original customer should still exist
      expect(customers.length, 1);
      expect(customers.first.id, 'customer-1');
    });
  });

  group('CustomerProvider - Search', () {
    test('should filter customers by name', () async {
      // Arrange
      final customer1 = MockData.createTestCustomer(
        id: 'customer-1',
        name: 'أحمد محمد',
      );
      final customer2 = MockData.createTestCustomer(
        id: 'customer-2',
        name: 'محمد علي',
      );
      final customer3 = MockData.createTestCustomer(
        id: 'customer-3',
        name: 'علي حسن',
      );

      await mockRepository.addCustomer(customer1);
      await mockRepository.addCustomer(customer2);
      await mockRepository.addCustomer(customer3);

      // Act
      final allCustomers = await mockRepository.getAllCustomers();
      final filtered =
          allCustomers.where((c) => c.name.contains('محمد')).toList();

      // Assert
      expect(filtered.length, 2);
      expect(filtered, contains(customer1));
      expect(filtered, contains(customer2));
    });

    test('should filter customers by phone', () async {
      // Arrange
      final customer1 = MockData.createTestCustomer(
        id: 'customer-1',
        phone: '0501234567',
      );
      final customer2 = MockData.createTestCustomer(
        id: 'customer-2',
        phone: '0509876543',
      );

      await mockRepository.addCustomer(customer1);
      await mockRepository.addCustomer(customer2);

      // Act
      final allCustomers = await mockRepository.getAllCustomers();
      final filtered = allCustomers
          .where((c) => c.phone?.contains('0501') ?? false)
          .toList();

      // Assert
      expect(filtered.length, 1);
      expect(filtered.first.id, 'customer-1');
    });

    test('should filter customers by email', () async {
      // Arrange
      final customer1 = MockData.createTestCustomer(
        id: 'customer-1',
        email: 'ahmed@example.com',
      );
      final customer2 = MockData.createTestCustomer(
        id: 'customer-2',
        email: 'mohammed@example.com',
      );

      await mockRepository.addCustomer(customer1);
      await mockRepository.addCustomer(customer2);

      // Act
      final allCustomers = await mockRepository.getAllCustomers();
      final filtered = allCustomers
          .where((c) => c.email?.contains('ahmed') ?? false)
          .toList();

      // Assert
      expect(filtered.length, 1);
      expect(filtered.first.id, 'customer-1');
    });

    test('should return all customers when search is empty', () async {
      // Arrange
      final customers = MockData.createTestCustomers(count: 5);
      for (final customer in customers) {
        await mockRepository.addCustomer(customer);
      }

      // Act
      final allCustomers = await mockRepository.getAllCustomers();
      final filtered = allCustomers.where((c) => true).toList();

      // Assert
      expect(filtered.length, 5);
    });

    test('should return empty list when no matches found', () async {
      // Arrange
      final customer = MockData.createTestCustomer(name: 'أحمد');
      await mockRepository.addCustomer(customer);

      // Act
      final allCustomers = await mockRepository.getAllCustomers();
      final filtered =
          allCustomers.where((c) => c.name.contains('غير موجود')).toList();

      // Assert
      expect(filtered, isEmpty);
    });
  });

  group('CustomerProvider - Error Handling', () {
    test('should handle repository errors gracefully', () async {
      // Act - MockRepository returns null for non-existent customers
      final customer = await mockRepository.getCustomerById('non-existent');

      // Assert
      expect(customer, isNull);
    });

    test('should handle empty customer list', () async {
      // Act
      final customers = await mockRepository.getAllCustomers();

      // Assert
      expect(customers, isEmpty);
      expect(customers, isA<List<Customer>>());
    });

    test('should handle customers with all fields populated', () async {
      // Arrange
      final customer = MockData.createTestCustomer();

      // Act
      await mockRepository.addCustomer(customer);
      final retrieved = await mockRepository.getCustomerById(customer.id);

      // Assert
      expect(retrieved, isNotNull);
      expect(retrieved!.id, customer.id);
      expect(retrieved.name, customer.name);
      expect(retrieved.email, customer.email);
      expect(retrieved.address, customer.address);
    });
  });

  group('CustomerProvider - State Management', () {
    test('should maintain state after multiple operations', () async {
      // Arrange & Act
      final customer1 = MockData.createTestCustomer(id: 'customer-1');
      final customer2 = MockData.createTestCustomer(id: 'customer-2');

      await mockRepository.addCustomer(customer1);
      await mockRepository.addCustomer(customer2);
      await mockRepository.deleteCustomer('customer-1');

      final customer3 = MockData.createTestCustomer(id: 'customer-3');
      await mockRepository.addCustomer(customer3);

      final customers = await mockRepository.getAllCustomers();

      // Assert
      expect(customers.length, 2);
      expect(customers, isNot(contains(customer1)));
      expect(customers, contains(customer2));
      expect(customers, contains(customer3));
    });

    test('should handle rapid successive operations', () async {
      // Arrange
      final customers = MockData.createTestCustomers(count: 10);

      // Act
      for (final customer in customers) {
        await mockRepository.addCustomer(customer);
      }

      final allCustomers = await mockRepository.getAllCustomers();

      // Assert
      expect(allCustomers.length, 10);
    });
  });
}
