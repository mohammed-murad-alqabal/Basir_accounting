/// اختبارات CustomerRepository
///
/// يختبر جميع عمليات CRUD على مستودع العملاء
library;

import 'package:basser_app/features/customers/data/repositories/customer_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import '../../../helpers/mock_data.dart';
import '../../../helpers/test_helpers.dart';

void main() {
  group('CustomerRepository', () {
    late Isar isar;
    late CustomerRepositoryImpl repository;

    setUp(() async {
      // إعداد قاعدة بيانات Isar في الذاكرة
      isar = await TestHelpers.createTestIsar();
      repository = CustomerRepositoryImpl(isar: isar);
    });

    tearDown(() async {
      // تنظيف قاعدة البيانات بعد كل اختبار
      await TestHelpers.cleanupTestIsar(isar);
    });

    group('addCustomer', () {
      test('should add customer successfully', () async {
        // Arrange
        final customer = MockData.createTestCustomer(
          name: 'أحمد محمد',
          phone: '0501234567',
        );

        // Act
        await repository.addCustomer(customer);
        final customers = await repository.getAllCustomers();

        // Assert
        expect(customers.length, 1);
        expect(customers.first.name, 'أحمد محمد');
        expect(customers.first.phone, '0501234567');
      });

      test('should add multiple customers successfully', () async {
        // Arrange
        final customers = MockData.createTestCustomers();

        // Act
        for (final customer in customers) {
          await repository.addCustomer(customer);
        }
        final allCustomers = await repository.getAllCustomers();

        // Assert
        expect(allCustomers.length, 3);
      });

      test('should preserve all customer data', () async {
        // Arrange
        final customer = MockData.createTestCustomer(
          name: 'فاطمة علي',
          phone: '0507654321',
          email: 'fatima@example.com',
          address: 'جدة، السعودية',
        );

        // Act
        await repository.addCustomer(customer);
        final customers = await repository.getAllCustomers();
        final savedCustomer = customers.first;

        // Assert
        expect(savedCustomer.name, customer.name);
        expect(savedCustomer.phone, customer.phone);
        expect(savedCustomer.email, customer.email);
        expect(savedCustomer.address, customer.address);
      });
    });

    group('getAllCustomers', () {
      test('should return empty list when no customers exist', () async {
        // Act
        final customers = await repository.getAllCustomers();

        // Assert
        expect(customers, isEmpty);
      });

      test('should return all customers', () async {
        // Arrange
        final testCustomers = MockData.createTestCustomers(count: 5);
        for (final customer in testCustomers) {
          await repository.addCustomer(customer);
        }

        // Act
        final customers = await repository.getAllCustomers();

        // Assert
        expect(customers.length, 5);
      });

      test('should return customers in correct order', () async {
        // Arrange
        final customer1 = MockData.createTestCustomer(name: 'أحمد');
        final customer2 = MockData.createTestCustomer(name: 'بدر');
        final customer3 = MockData.createTestCustomer(name: 'خالد');

        await repository.addCustomer(customer1);
        await repository.addCustomer(customer2);
        await repository.addCustomer(customer3);

        // Act
        final customers = await repository.getAllCustomers();

        // Assert
        expect(customers.length, 3);
        // التحقق من أن جميع العملاء موجودون
        expect(customers.any((c) => c.name == 'أحمد'), isTrue);
        expect(customers.any((c) => c.name == 'بدر'), isTrue);
        expect(customers.any((c) => c.name == 'خالد'), isTrue);
      });
    });

    group('getCustomerById', () {
      test('should return customer when exists', () async {
        // Arrange
        final customer = MockData.createTestCustomer(
          id: 'test-customer-123',
          name: 'عميل محدد',
        );
        await repository.addCustomer(customer);

        // Act
        final foundCustomer =
            await repository.getCustomerById('test-customer-123');

        // Assert
        expect(foundCustomer, isNotNull);
        expect(foundCustomer?.name, 'عميل محدد');
      });

      test('should return null when customer does not exist', () async {
        // Act
        final foundCustomer =
            await repository.getCustomerById('non-existent-id');

        // Assert
        expect(foundCustomer, isNull);
      });

      test('should return correct customer among multiple', () async {
        // Arrange
        final customers = MockData.createTestCustomers(count: 5);
        for (final customer in customers) {
          await repository.addCustomer(customer);
        }
        final targetCustomer = customers[2];

        // Act
        final foundCustomer =
            await repository.getCustomerById(targetCustomer.id);

        // Assert
        expect(foundCustomer, isNotNull);
        expect(foundCustomer?.id, targetCustomer.id);
        expect(foundCustomer?.name, targetCustomer.name);
      });
    });

    group('updateCustomer', () {
      test('should update customer successfully', () async {
        // Arrange
        final customer = MockData.createTestCustomer(
          id: 'test-customer-update',
          name: 'اسم قديم',
          phone: '0501111111',
        );
        await repository.addCustomer(customer);

        // Act
        final updatedCustomer = customer.copyWith(
          name: 'اسم جديد',
          phone: '0502222222',
        );
        await repository.updateCustomer(updatedCustomer);

        // Assert
        final foundCustomer =
            await repository.getCustomerById('test-customer-update');
        expect(foundCustomer?.name, 'اسم جديد');
        expect(foundCustomer?.phone, '0502222222');
      });

      test('should update only specified fields', () async {
        // Arrange
        final customer = MockData.createTestCustomer(
          id: 'test-customer-partial',
          name: 'اسم أصلي',
          phone: '0501111111',
          email: 'original@example.com',
        );
        await repository.addCustomer(customer);

        // Act - تحديث الاسم فقط
        final updatedCustomer = customer.copyWith(name: 'اسم محدث');
        await repository.updateCustomer(updatedCustomer);

        // Assert
        final foundCustomer =
            await repository.getCustomerById('test-customer-partial');
        expect(foundCustomer?.name, 'اسم محدث');
        expect(foundCustomer?.phone, '0501111111'); // لم يتغير
        expect(foundCustomer?.email, 'original@example.com'); // لم يتغير
      });

      test('should not affect other customers', () async {
        // Arrange
        final customer1 =
            MockData.createTestCustomer(id: 'customer-1', name: 'عميل 1');
        final customer2 =
            MockData.createTestCustomer(id: 'customer-2', name: 'عميل 2');
        await repository.addCustomer(customer1);
        await repository.addCustomer(customer2);

        // Act - تحديث العميل الأول فقط
        final updatedCustomer1 = customer1.copyWith(name: 'عميل 1 محدث');
        await repository.updateCustomer(updatedCustomer1);

        // Assert
        final foundCustomer1 = await repository.getCustomerById('customer-1');
        final foundCustomer2 = await repository.getCustomerById('customer-2');
        expect(foundCustomer1?.name, 'عميل 1 محدث');
        expect(foundCustomer2?.name, 'عميل 2'); // لم يتغير
      });
    });

    group('deleteCustomer', () {
      test('should delete customer successfully', () async {
        // Arrange
        final customer =
            MockData.createTestCustomer(id: 'test-customer-delete');
        await repository.addCustomer(customer);

        // Act
        await repository.deleteCustomer('test-customer-delete');

        // Assert
        final foundCustomer =
            await repository.getCustomerById('test-customer-delete');
        expect(foundCustomer, isNull);
      });

      test('should not affect other customers when deleting', () async {
        // Arrange
        final customer1 = MockData.createTestCustomer(id: 'customer-1');
        final customer2 = MockData.createTestCustomer(id: 'customer-2');
        final customer3 = MockData.createTestCustomer(id: 'customer-3');
        await repository.addCustomer(customer1);
        await repository.addCustomer(customer2);
        await repository.addCustomer(customer3);

        // Act - حذف العميل الثاني فقط
        await repository.deleteCustomer('customer-2');

        // Assert
        final allCustomers = await repository.getAllCustomers();
        expect(allCustomers.length, 2);
        expect(allCustomers.any((c) => c.id == 'customer-1'), isTrue);
        expect(allCustomers.any((c) => c.id == 'customer-2'), isFalse);
        expect(allCustomers.any((c) => c.id == 'customer-3'), isTrue);
      });

      test('should handle deleting non-existent customer gracefully', () async {
        // Act & Assert - لا يجب أن يرمي خطأ
        await repository.deleteCustomer('non-existent-id');

        // التحقق من أن القائمة لا تزال فارغة
        final customers = await repository.getAllCustomers();
        expect(customers, isEmpty);
      });

      test('should delete all customers when called multiple times', () async {
        // Arrange
        final customers = MockData.createTestCustomers();
        for (final customer in customers) {
          await repository.addCustomer(customer);
        }

        // Act - حذف جميع العملاء
        for (final customer in customers) {
          await repository.deleteCustomer(customer.id);
        }

        // Assert
        final allCustomers = await repository.getAllCustomers();
        expect(allCustomers, isEmpty);
      });
    });

    group('searchCustomers', () {
      test('should find customers by name', () async {
        // Arrange
        await repository
            .addCustomer(MockData.createTestCustomer(name: 'أحمد محمد'));
        await repository
            .addCustomer(MockData.createTestCustomer(name: 'محمد علي'));
        await repository
            .addCustomer(MockData.createTestCustomer(name: 'فاطمة أحمد'));

        // Act
        final results = await repository.searchCustomers('محمد');

        // Assert
        expect(results.length, 2);
        expect(results.every((c) => c.name.contains('محمد')), isTrue);
      });

      test('should return empty list when no matches', () async {
        // Arrange
        await repository.addCustomer(MockData.createTestCustomer(name: 'أحمد'));
        await repository.addCustomer(MockData.createTestCustomer(name: 'علي'));

        // Act
        final results = await repository.searchCustomers('خالد');

        // Assert
        expect(results, isEmpty);
      });

      test('should be case insensitive', () async {
        // Arrange
        await repository
            .addCustomer(MockData.createTestCustomer(name: 'أحمد محمد'));

        // Act
        final results = await repository.searchCustomers('أحمد');

        // Assert
        expect(results.length, 1);
      });
    });
  });
}
