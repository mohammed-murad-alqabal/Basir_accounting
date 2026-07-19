/// اختبارات Customer Providers
library;

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:basir_accounting_system/features/customers/presentation/providers/customer_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../mocks/mock_customer_repository.dart';

void main() {
  group('customersProvider', () {
    test('should return list of customers', () async {
      // Arrange
      final mockRepo = MockCustomerRepository();
      final container = ProviderContainer(
        overrides: [customerRepositoryProvider.overrideWithValue(mockRepo)],
      );

      // Act
      final result = await container.read(customersProvider.future);

      // Assert
      expect(result, isA<List<Customer>>());
      expect(result.length, 2);
    });

    test('should return empty list when no customers', () async {
      // Arrange
      final mockRepo = MockCustomerRepository(customers: []);
      final container = ProviderContainer(
        overrides: [customerRepositoryProvider.overrideWithValue(mockRepo)],
      );

      // Act
      final result = await container.read(customersProvider.future);

      // Assert
      expect(result, isEmpty);
    });
  });

  group('addCustomerProvider', () {
    test('should add customer successfully', () async {
      // Arrange
      final mockRepo = MockCustomerRepository();
      final container = ProviderContainer(
        overrides: [customerRepositoryProvider.overrideWithValue(mockRepo)],
      );

      final newCustomer = Customer(
        id: 'test-3',
        nameEn: 'Test Customer',
        nameAr: 'Test Customer',
        phone: '0501234567',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Act
      final result = await container.read(
        addCustomerProvider(newCustomer).future,
      );

      // Assert
      expect(result, isTrue);
    });

    test('should return false on error', () async {
      // Arrange
      final mockRepo = MockCustomerRepository(shouldThrow: true);
      final container = ProviderContainer(
        overrides: [customerRepositoryProvider.overrideWithValue(mockRepo)],
      );

      final newCustomer = Customer(
        id: 'test-3',
        nameEn: 'Test Customer',
        nameAr: 'Test Customer',
        phone: '0501234567',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Act
      final result = await container.read(
        addCustomerProvider(newCustomer).future,
      );

      // Assert
      expect(result, isFalse);
    });
  });

  group('updateCustomerProvider', () {
    test('should update customer successfully', () async {
      // Arrange
      final mockRepo = MockCustomerRepository();
      final container = ProviderContainer(
        overrides: [customerRepositoryProvider.overrideWithValue(mockRepo)],
      );

      final updatedCustomer = Customer(
        id: 'test-1',
        nameEn: 'Updated Name',
        nameAr: 'Updated Name',
        phone: '0509876543',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Act
      final result = await container.read(
        updateCustomerProvider(updatedCustomer).future,
      );

      // Assert
      expect(result, isTrue);
    });

    test('should return false on error', () async {
      // Arrange
      final mockRepo = MockCustomerRepository(shouldThrow: true);
      final container = ProviderContainer(
        overrides: [customerRepositoryProvider.overrideWithValue(mockRepo)],
      );

      final updatedCustomer = Customer(
        id: 'test-1',
        nameEn: 'Updated Name',
        nameAr: 'Updated Name',
        phone: '0509876543',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Act
      final result = await container.read(
        updateCustomerProvider(updatedCustomer).future,
      );

      // Assert
      expect(result, isFalse);
    });
  });

  group('deleteCustomerProvider', () {
    test('should delete customer successfully', () async {
      // Arrange
      final mockRepo = MockCustomerRepository();
      final container = ProviderContainer(
        overrides: [customerRepositoryProvider.overrideWithValue(mockRepo)],
      );

      // Act
      final result = await container.read(
        deleteCustomerProvider('test-1').future,
      );

      // Assert
      expect(result, isTrue);
    });

    test('should return false on error', () async {
      // Arrange
      final mockRepo = MockCustomerRepository(shouldThrow: true);
      final container = ProviderContainer(
        overrides: [customerRepositoryProvider.overrideWithValue(mockRepo)],
      );

      // Act
      final result = await container.read(
        deleteCustomerProvider('test-1').future,
      );

      // Assert
      expect(result, isFalse);
    });
  });

  group('customerSearchProvider', () {
    test('should have empty string as default', () {
      // Arrange
      final container = ProviderContainer();

      // Act
      final result = container.read(customerSearchProvider);

      // Assert
      expect(result, isEmpty);
    });

    test('should update search query', () {
      // Arrange
      final container = ProviderContainer();

      // Act
      container.read(customerSearchProvider.notifier).state = 'أحمد';
      final result = container.read(customerSearchProvider);

      // Assert
      expect(result, 'أحمد');
    });
  });

  group('filteredCustomersProvider', () {
    test('should return all customers when search is empty', () async {
      // Arrange
      final mockRepo = MockCustomerRepository();
      final container = ProviderContainer(
        overrides: [customerRepositoryProvider.overrideWithValue(mockRepo)],
      );

      // Wait for customersProvider to load
      await container.read(customersProvider.future);

      // Act
      final result = container.read(filteredCustomersProvider);

      // Assert
      result.when(
        data: (customers) {
          expect(customers.length, 2);
        },
        loading: () => fail('Should not be loading'),
        error: (error, stack) => fail('Should not have error: $error'),
      );
    });

    test('should filter customers by name', () async {
      // Arrange
      final mockRepo = MockCustomerRepository();
      final container = ProviderContainer(
        overrides: [customerRepositoryProvider.overrideWithValue(mockRepo)],
      );

      // Wait for customersProvider to load
      await container.read(customersProvider.future);

      // Set search query
      container.read(customerSearchProvider.notifier).state = 'أحمد';

      // Act
      final result = container.read(filteredCustomersProvider);

      // Assert
      result.when(
        data: (customers) {
          expect(customers.length, 1);
          expect(customers.first.name(isArabic: true), contains('أحمد'));
        },
        loading: () => fail('Should not be loading'),
        error: (error, stack) => fail('Should not have error: $error'),
      );
    });

    test('should filter customers by phone', () async {
      // Arrange
      final mockRepo = MockCustomerRepository();
      final container = ProviderContainer(
        overrides: [customerRepositoryProvider.overrideWithValue(mockRepo)],
      );

      // Wait for customersProvider to load
      await container.read(customersProvider.future);

      // Set search query
      container.read(customerSearchProvider.notifier).state = '0501234567';

      // Act
      final result = container.read(filteredCustomersProvider);

      // Assert
      result.when(
        data: (customers) {
          expect(customers.length, 1);
        },
        loading: () => fail('Should not be loading'),
        error: (error, stack) => fail('Should not have error: $error'),
      );
    });

    test('should return empty list when no match', () async {
      // Arrange
      final mockRepo = MockCustomerRepository();
      final container = ProviderContainer(
        overrides: [customerRepositoryProvider.overrideWithValue(mockRepo)],
      );

      // Wait for customersProvider to load
      await container.read(customersProvider.future);

      // Set search query
      container.read(customerSearchProvider.notifier).state = 'xyz123';

      // Act
      final result = container.read(filteredCustomersProvider);

      // Assert
      result.when(
        data: (customers) {
          expect(customers, isEmpty);
        },
        loading: () => fail('Should not be loading'),
        error: (error, stack) => fail('Should not have error: $error'),
      );
    });
  });
}
