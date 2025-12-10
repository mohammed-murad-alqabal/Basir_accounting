/// اختبارات Customer Model
///
/// يختبر تحويل البيانات والتحقق من الصحة لنموذج العميل
library;

import 'package:basser_app/features/customers/domain/entities/customer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Customer Model', () {
    group('copyWith', () {
      test('should create copy with updated name', () {
        // Arrange
        final original = Customer(
          id: 'test-1',
          name: 'أحمد محمد',
          phone: '0501234567',
          email: 'ahmed@example.com',
          address: 'الرياض',
          createdAt: DateTime.utc(2025),
          updatedAt: DateTime.utc(2025),
        );

        // Act
        final updated = original.copyWith(name: 'اسم جديد');

        // Assert
        expect(updated.id, original.id);
        expect(updated.name, 'اسم جديد');
        expect(updated.phone, original.phone);
        expect(updated.email, original.email);
        expect(updated.address, original.address);
      });

      test('should create copy with updated phone', () {
        // Arrange
        final original = Customer(
          id: 'test-1',
          name: 'أحمد محمد',
          phone: '0501234567',
          createdAt: DateTime.utc(2025),
          updatedAt: DateTime.utc(2025),
        );

        // Act
        final updated = original.copyWith(phone: '0509999999');

        // Assert
        expect(updated.phone, '0509999999');
        expect(updated.name, original.name);
      });

      test('should create copy with updated email', () {
        // Arrange
        final original = Customer(
          id: 'test-1',
          name: 'أحمد محمد',
          phone: '0501234567',
          email: 'old@example.com',
          createdAt: DateTime.utc(2025),
          updatedAt: DateTime.utc(2025),
        );

        // Act
        final updated = original.copyWith(email: 'newemail@example.com');

        // Assert
        expect(updated.email, 'newemail@example.com');
      });

      test('should create copy with updated address', () {
        // Arrange
        final original = Customer(
          id: 'test-1',
          name: 'أحمد محمد',
          phone: '0501234567',
          address: 'عنوان قديم',
          createdAt: DateTime.utc(2025),
          updatedAt: DateTime.utc(2025),
        );

        // Act
        final updated = original.copyWith(address: 'عنوان جديد');

        // Assert
        expect(updated.address, 'عنوان جديد');
      });

      test('should create copy with multiple updated fields', () {
        // Arrange
        final original = Customer(
          id: 'test-1',
          name: 'أحمد محمد',
          phone: '0501234567',
          email: 'old@example.com',
          address: 'عنوان قديم',
          createdAt: DateTime.utc(2025),
          updatedAt: DateTime.utc(2025),
        );

        // Act
        final updated = original.copyWith(
          name: 'اسم محدث',
          phone: '0508888888',
          email: 'updated@example.com',
        );

        // Assert
        expect(updated.name, 'اسم محدث');
        expect(updated.phone, '0508888888');
        expect(updated.email, 'updated@example.com');
        expect(updated.address, original.address); // لم يتغير
      });

      test('should not modify original when creating copy', () {
        // Arrange
        final original = Customer(
          id: 'test-1',
          name: 'أحمد محمد',
          phone: '0501234567',
          createdAt: DateTime.utc(2025),
          updatedAt: DateTime.utc(2025),
        );
        final originalName = original.name;

        // Act
        final updated = original.copyWith(name: 'اسم جديد');

        // Assert
        expect(original.name, originalName); // الأصل لم يتغير
        expect(updated.name, 'اسم جديد');
      });
    });

    group('equality', () {
      test('should be equal when all fields match', () {
        // Arrange
        final customer1 = Customer(
          id: 'test-1',
          name: 'أحمد',
          phone: '0501234567',
          email: 'ahmed@example.com',
          address: 'الرياض',
          createdAt: DateTime.utc(2025),
          updatedAt: DateTime.utc(2025),
        );

        final customer2 = Customer(
          id: 'test-1',
          name: 'أحمد',
          phone: '0501234567',
          email: 'ahmed@example.com',
          address: 'الرياض',
          createdAt: DateTime.utc(2025),
          updatedAt: DateTime.utc(2025),
        );

        // Assert
        expect(customer1, equals(customer2));
      });

      test('should not be equal when IDs differ', () {
        // Arrange
        final customer1 = Customer(
          id: 'test-1',
          name: 'أحمد',
          phone: '0501234567',
          createdAt: DateTime.utc(2025),
          updatedAt: DateTime.utc(2025),
        );

        final customer2 = Customer(
          id: 'test-2',
          name: 'أحمد',
          phone: '0501234567',
          createdAt: DateTime.utc(2025),
          updatedAt: DateTime.utc(2025),
        );

        // Assert
        expect(customer1, isNot(equals(customer2)));
      });

      test('should not be equal when names differ', () {
        // Arrange
        final customer1 = Customer(
          id: 'test-1',
          name: 'أحمد',
          phone: '0501234567',
          createdAt: DateTime.utc(2025),
          updatedAt: DateTime.utc(2025),
        );

        final customer2 = Customer(
          id: 'test-1',
          name: 'محمد',
          phone: '0501234567',
          createdAt: DateTime.utc(2025),
          updatedAt: DateTime.utc(2025),
        );

        // Assert
        expect(customer1, isNot(equals(customer2)));
      });
    });

    group('validation', () {
      test('should create customer with required fields', () {
        // Arrange & Act
        final customer = Customer(
          id: 'test-1',
          name: 'أحمد محمد',
          phone: '0501234567',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Assert
        expect(customer.id, 'test-1');
        expect(customer.name, 'أحمد محمد');
        expect(customer.phone, '0501234567');
        expect(customer.email, isNull);
        expect(customer.address, isNull);
      });

      test('should create customer with all fields', () {
        // Arrange & Act
        final customer = Customer(
          id: 'test-2',
          name: 'فاطمة علي',
          phone: '0507654321',
          email: 'fatima@example.com',
          address: 'جدة، السعودية',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Assert
        expect(customer.id, 'test-2');
        expect(customer.name, 'فاطمة علي');
        expect(customer.phone, '0507654321');
        expect(customer.email, 'fatima@example.com');
        expect(customer.address, 'جدة، السعودية');
      });

      test('should handle null optional fields', () {
        // Arrange & Act
        final customer = Customer(
          id: 'test-3',
          name: 'خالد عبدالله',
          phone: '0509876543',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Assert
        expect(customer.email, isNull);
        expect(customer.address, isNull);
      });
    });
  });
}
