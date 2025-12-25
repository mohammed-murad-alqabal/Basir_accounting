import 'package:basser_app/features/customers/presentation/screens/customer_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/customer_fixtures.dart';

void main() {
  group('CustomerFormScreen Tests', () {
    testWidgets('should display add customer title when customer is null',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: CustomerFormScreen()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('إضافة عميل جديد'), findsOneWidget);
    });

    testWidgets('should display edit customer title when customer is provided',
        (tester) async {
      final customer = CustomerFixtures.customer1;
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: CustomerFormScreen(customer: customer)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('تعديل العميل'), findsOneWidget);
    });
  });
}
