/// اختبارات CustomerProvider الفعلية
///
/// يختبر جميع Providers في customer_provider.dart
/// لتحسين التغطية من 3% إلى 70%+
library;

import 'package:basser_app/core/providers.dart' as core_providers;
import 'package:basser_app/features/customers/domain/entities/customer.dart';
import 'package:basser_app/features/customers/presentation/providers/customer_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/mock_data.dart';
import '../../../mocks/mock_customer_repository.dart';

void main() {
  late MockCustomerRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockCustomerRepository();
    // تنظيف البيانات الافتراضية
    mockRepository.setCustomers([]);
    container = ProviderContainer(
      overrides: [
        core_providers.customerRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('customersProvider', () {
    test('should load all customers successfully', () async {
      // Arrange
      final testCustomers = MockData.createTestCustomers();
      mockRepository.setCustomers(testCustomers);

      // Act
      final result = await container.read(customersProvider.future);

      // Assert
      expect(result, isA<List<Customer>>());
      expect(result.length, 3);
      expect(result.first.name, testCustomers.first.name);
    });

    test('should return empty list when no customers exist', () async {
      // Arrange
      mockRepository.setCustomers([]);

      // Act
      final result = await container.read(customersProvider.future);

      // Assert
      expect(result, isEmpty);
    });

    test('should handle repository errors', () async {
      // Arrange
      mockRepository.shouldThrowError = true;

      // Act & Assert
      expect(() => container.read(customersProvider.future), throwsException);
    });
  });

  group('addCustomerProvider', () {
    test('should add customer successfully', () async {
      // Arrange
      mockRepository.setCustomers([]);
      final customer = MockData.createTestCustomer();

      // Act
      final result = await container.read(addCustomerProvider(customer).future);

      // Assert
      expect(result, true);
      final customers = await mockRepository.getAllCustomers();
      expect(customers.length, 1);
      expect(customers.first.id, customer.id);
    });

    test('should return false when add fails', () async {
      // Arrange
      final customer = MockData.createTestCustomer();
      mockRepository.shouldThrowError = true;

      // Act
      final result = await container.read(addCustomerProvider(customer).future);

      // Assert
      expect(result, false);
    });

    test('should invalidate customersProvider after add', () async {
      // Arrange
      mockRepository.setCustomers([]);
      final customer = MockData.createTestCustomer();

      // Act
      await container.read(addCustomerProvider(customer).future);

      // Assert - customersProvider should be invalidated
      final customers = await container.read(customersProvider.future);
      expect(customers.length, 1);
    });
  });

  group('updateCustomerProvider', () {
    test('should update customer successfully', () async {
      // Arrange
      final customer = MockData.createTestCustomer();
      await mockRepository.addCustomer(customer);

      final updatedCustomer = customer.copyWith(name: 'اسم محدث');

      // Act
      final result = await container.read(
        updateCustomerProvider(updatedCustomer).future,
      );

      // Assert
      expect(result, true);
      final customers = await mockRepository.getAllCustomers();
      expect(customers.first.name, 'اسم محدث');
    });

    test('should return false when update fails', () async {
      // Arrange
      final customer = MockData.createTestCustomer();
      mockRepository.shouldThrowError = true;

      // Act
      final result = await container.read(
        updateCustomerProvider(customer).future,
      );

      // Assert
      expect(result, false);
    });

    test('should invalidate customersProvider after update', () async {
      // Arrange
      final customer = MockData.createTestCustomer();
      await mockRepository.addCustomer(customer);

      final updatedCustomer = customer.copyWith(name: 'اسم جديد');

      // Act
      await container.read(updateCustomerProvider(updatedCustomer).future);

      // Assert - customersProvider should be invalidated
      final customers = await container.read(customersProvider.future);
      expect(customers.first.name, 'اسم جديد');
    });
  });

  group('deleteCustomerProvider', () {
    test('should delete customer successfully', () async {
      // Arrange
      final customer = MockData.createTestCustomer();
      await mockRepository.addCustomer(customer);

      // Act
      final result = await container.read(
        deleteCustomerProvider(customer.id).future,
      );

      // Assert
      expect(result, true);
      final customers = await mockRepository.getAllCustomers();
      expect(customers, isEmpty);
    });

    test('should return false when delete fails', () async {
      // Arrange
      mockRepository.shouldThrowError = true;

      // Act
      final result = await container.read(
        deleteCustomerProvider('test-id').future,
      );

      // Assert
      expect(result, false);
    });

    test('should invalidate customersProvider after delete', () async {
      // Arrange
      final customer = MockData.createTestCustomer();
      await mockRepository.addCustomer(customer);

      // Act
      await container.read(deleteCustomerProvider(customer.id).future);

      // Assert - customersProvider should be invalidated
      final customers = await container.read(customersProvider.future);
      expect(customers, isEmpty);
    });
  });

  group('customerSearchProvider', () {
    test('should have empty string as default value', () {
      // Act
      final searchQuery = container.read(customerSearchProvider);

      // Assert
      expect(searchQuery, '');
    });

    test('should update search query', () {
      // Act
      container.read(customerSearchProvider.notifier).state = 'أحمد';
      final searchQuery = container.read(customerSearchProvider);

      // Assert
      expect(searchQuery, 'أحمد');
    });

    test('should allow clearing search query', () {
      // Arrange
      container.read(customerSearchProvider.notifier).state = 'أحمد';

      // Act
      container.read(customerSearchProvider.notifier).state = '';
      final searchQuery = container.read(customerSearchProvider);

      // Assert
      expect(searchQuery, '');
    });
  });

  group('filteredCustomersProvider', () {
    setUp(() async {
      // Add test customers
      final customers = [
        MockData.createTestCustomer(
          id: '1',
          name: 'أحمد محمد',
          phone: '0501234567',
          email: 'ahmed@example.com',
        ),
        MockData.createTestCustomer(
          id: '2',
          name: 'فاطمة علي',
          phone: '0507654321',
          email: 'fatima@example.com',
        ),
        MockData.createTestCustomer(
          id: '3',
          name: 'محمد أحمد',
          phone: '0509876543',
          email: 'mohammed@example.com',
        ),
      ];

      for (final customer in customers) {
        await mockRepository.addCustomer(customer);
      }
    });

    test('should return all customers when search is empty', () async {
      // Arrange
      container.read(customerSearchProvider.notifier).state = '';

      // Wait for customersProvider to load
      await container.read(customersProvider.future);

      // Act
      final result = container.read(filteredCustomersProvider);

      // Assert
      await expectLater(
        result.when(
          data: (customers) => customers.length,
          loading: () => throw StateError('Should not be loading'),
          error: (_, __) => throw StateError('Should not have error'),
        ),
        equals(3),
      );
    });

    test('should filter customers by name', () async {
      // Arrange
      await container.read(customersProvider.future);
      container.read(customerSearchProvider.notifier).state = 'أحمد';

      // Act
      final result = container.read(filteredCustomersProvider);

      // Assert
      final customers = result.when(
        data: (customers) => customers,
        loading: () => throw StateError('Should not be loading'),
        error: (_, __) => throw StateError('Should not have error'),
      );

      expect(customers.length, 2); // أحمد محمد و محمد أحمد
      expect(customers.every((c) => c.name.contains('أحمد')), true);
    });

    test('should filter customers by email', () async {
      // Arrange
      await container.read(customersProvider.future);
      container.read(customerSearchProvider.notifier).state = 'ahmed';

      // Act
      final result = container.read(filteredCustomersProvider);

      // Assert
      final customers = result.when(
        data: (customers) => customers,
        loading: () => throw StateError('Should not be loading'),
        error: (_, __) => throw StateError('Should not have error'),
      );

      expect(customers.length, 1);
      expect(customers.first.email, contains('ahmed'));
    });

    test('should filter customers by phone', () async {
      // Arrange
      await container.read(customersProvider.future);
      container.read(customerSearchProvider.notifier).state = '050123';

      // Act
      final result = container.read(filteredCustomersProvider);

      // Assert
      final customers = result.when(
        data: (customers) => customers,
        loading: () => throw StateError('Should not be loading'),
        error: (_, __) => throw StateError('Should not have error'),
      );

      expect(customers.length, 1);
      expect(customers.first.phone, contains('050123'));
    });

    test('should return empty list when no matches found', () async {
      // Arrange
      await container.read(customersProvider.future);
      container.read(customerSearchProvider.notifier).state = 'xyz123';

      // Act
      final result = container.read(filteredCustomersProvider);

      // Assert
      final customers = result.when(
        data: (customers) => customers,
        loading: () => throw StateError('Should not be loading'),
        error: (_, __) => throw StateError('Should not have error'),
      );

      expect(customers, isEmpty);
    });

    test('should update when search query changes', () async {
      // Arrange
      await container.read(customersProvider.future);
      container.read(customerSearchProvider.notifier).state = 'أحمد';
      final result1 = container.read(filteredCustomersProvider);

      // Act
      container.read(customerSearchProvider.notifier).state = 'فاطمة';
      final result2 = container.read(filteredCustomersProvider);

      // Assert
      final customers1 = result1.when(
        data: (customers) => customers,
        loading: () => throw StateError('Should not be loading'),
        error: (_, __) => throw StateError('Should not have error'),
      );
      expect(customers1.length, 2);

      final customers2 = result2.when(
        data: (customers) => customers,
        loading: () => throw StateError('Should not be loading'),
        error: (_, __) => throw StateError('Should not have error'),
      );
      expect(customers2.length, 1);
      expect(customers2.first.name, 'فاطمة علي');
    });
  });
}
