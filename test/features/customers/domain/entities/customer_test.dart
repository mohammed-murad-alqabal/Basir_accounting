import 'package:basir_app/features/customers/domain/entities/customer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Customer Entity', () {
    test('Customer creation with valid data', () {
      final now = DateTime.now();
      final customer = Customer(
        id: '1',
        name: 'أحمد محمد',
        phone: '+966501234567',
        email: 'ahmed@example.com',
        address: 'الرياض',
        createdAt: now,
        updatedAt: now,
      );

      expect(customer.id, equals('1'));
      expect(customer.name, equals('أحمد محمد'));
      expect(customer.phone, equals('+966501234567'));
      expect(customer.email, equals('ahmed@example.com'));
      expect(customer.address, equals('الرياض'));
    });

    test('Customer equality', () {
      final now = DateTime.now();
      final customer1 = Customer(
        id: '1',
        name: 'أحمد',
        phone: '+966501234567',
        email: 'ahmed@example.com',
        address: 'الرياض',
        createdAt: now,
        updatedAt: now,
      );
      final customer2 = Customer(
        id: '1',
        name: 'أحمد',
        phone: '+966501234567',
        email: 'ahmed@example.com',
        address: 'الرياض',
        createdAt: now,
        updatedAt: now,
      );

      expect(customer1, equals(customer2));
    });

    test('Customer copyWith', () {
      final now = DateTime.now();
      final customer = Customer(
        id: '1',
        name: 'أحمد',
        phone: '+966501234567',
        email: 'ahmed@example.com',
        address: 'الرياض',
        createdAt: now,
        updatedAt: now,
      );

      final updatedCustomer = customer.copyWith(
        name: 'محمد أحمد',
        updatedAt: now.add(const Duration(hours: 1)),
      );

      expect(updatedCustomer.name, equals('محمد أحمد'));
      expect(updatedCustomer.id, equals(customer.id));
      expect(updatedCustomer.phone, equals(customer.phone));
    });

    test('Customer with minimal data', () {
      final now = DateTime.now();
      final customer = Customer(
        id: '1',
        name: 'أحمد',
        createdAt: now,
        updatedAt: now,
      );

      expect(customer.id, equals('1'));
      expect(customer.name, equals('أحمد'));
      expect(customer.phone, isNull);
      expect(customer.email, isNull);
      expect(customer.address, isNull);
    });
  });
}
