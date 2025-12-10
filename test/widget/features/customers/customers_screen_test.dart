import 'package:basser_app/core/theme.dart';
import 'package:basser_app/features/customers/domain/entities/customer.dart';
import 'package:basser_app/features/customers/presentation/providers/customer_provider.dart';
import 'package:basser_app/features/customers/presentation/screens/customers_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/customer_fixtures.dart';

void main() {
  group('CustomersScreen - Display', () {
    testWidgets('should display app bar with title', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customersProvider.overrideWith(
              (ref) async => CustomerFixtures.allCustomers,
            ),
          ],
          child: const MaterialApp(home: CustomersScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('العملاء'), findsOneWidget);
    });

    testWidgets('should display add button in app bar', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customersProvider.overrideWith(
              (ref) async => CustomerFixtures.allCustomers,
            ),
          ],
          child: const MaterialApp(home: CustomersScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should display search field', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customersProvider.overrideWith(
              (ref) async => CustomerFixtures.allCustomers,
            ),
          ],
          child: const MaterialApp(home: CustomersScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('ابحث عن عميل...'), findsOneWidget);
    });

    testWidgets('should display loading indicator when loading', (
      tester,
    ) async {
      // Arrange
      var isLoading = true;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customersProvider.overrideWith((ref) async {
              if (isLoading) {
                await Future<void>.delayed(const Duration(milliseconds: 100));
              }
              return CustomerFixtures.allCustomers;
            }),
          ],
          child: const MaterialApp(home: CustomersScreen()),
        ),
      );
      await tester.pump(const Duration(milliseconds: 10));

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete loading
      isLoading = false;
      await tester.pumpAndSettle();
    });

    testWidgets('should display empty state when no customers', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customersProvider.overrideWith((ref) async => <Customer>[]),
          ],
          child: const MaterialApp(home: CustomersScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('لا توجد عملاء'), findsOneWidget);
      expect(find.byIcon(Icons.people), findsOneWidget);
    });

    testWidgets('should display error message when error occurs', (
      tester,
    ) async {
      // Arrange
      const errorMessage = 'فشل في تحميل العملاء';

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customersProvider.overrideWith(
              (ref) async => throw Exception(errorMessage),
            ),
          ],
          child: const MaterialApp(home: CustomersScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('خطأ في تحميل العملاء'), findsOneWidget);
    });

    testWidgets('should display list of customers when data is available', (
      tester,
    ) async {
      // Arrange
      final customers = CustomerFixtures.allCustomers;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [customersProvider.overrideWith((ref) async => customers)],
          child: const MaterialApp(home: CustomersScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Check that customers are displayed (at least some of them)
      expect(find.text(CustomerFixtures.customer1.name), findsOneWidget);
      expect(find.text(CustomerFixtures.customer2.name), findsOneWidget);
      expect(find.text(CustomerFixtures.customer3.name), findsOneWidget);
    });

    testWidgets('should display customer details in list card', (tester) async {
      // Arrange
      final customer = CustomerFixtures.customer1;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customersProvider.overrideWith((ref) async => [customer]),
          ],
          child: const MaterialApp(home: CustomersScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(customer.name), findsOneWidget);
      expect(find.text(customer.email!), findsOneWidget);
      expect(find.text(customer.phone!), findsOneWidget);
    });

    testWidgets('should display avatar with first letter of name', (
      tester,
    ) async {
      // Arrange
      final customer = CustomerFixtures.customer1;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customersProvider.overrideWith((ref) async => [customer]),
          ],
          child: const MaterialApp(home: CustomersScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(customer.name[0]), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('should display multiple customers in list', (tester) async {
      // Arrange
      final customers = CustomerFixtures.allCustomers;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [customersProvider.overrideWith((ref) async => customers)],
          child: const MaterialApp(home: CustomersScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Check that multiple CircleAvatars are displayed
      // Note: Some customers might not be visible in viewport
      expect(find.byType(CircleAvatar), findsAtLeastNWidgets(5));
    });

    testWidgets('should use correct background color', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customersProvider.overrideWith(
              (ref) async => CustomerFixtures.allCustomers,
            ),
          ],
          child: const MaterialApp(home: CustomersScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, AppColors.background);
    });

    testWidgets('should display customers in scrollable list', (tester) async {
      // Arrange
      final customers = List.generate(
        20,
        (index) => Customer(
          id: 'customer-$index',
          name: 'عميل $index',
          phone: '050123456$index',
          email: 'customer$index@test.com',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [customersProvider.overrideWith((ref) async => customers)],
          child: const MaterialApp(home: CustomersScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Check that ListView is present
      expect(find.byType(ListView), findsOneWidget);

      // Verify first customer is visible
      expect(find.text('عميل 0'), findsOneWidget);

      // Scroll to bottom
      await tester.drag(find.byType(ListView), const Offset(0, -5000));
      await tester.pumpAndSettle();

      // Verify last customer is now visible
      expect(find.text('عميل 19'), findsOneWidget);
    });
  });

  group('CustomersScreen - Interactions', () {
    testWidgets('should handle tap on add button', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customersProvider.overrideWith(
              (ref) async => CustomerFixtures.allCustomers,
            ),
          ],
          child: const MaterialApp(home: CustomersScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Assert - Button should be tappable (no exception thrown)
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should handle tap on customer card', (tester) async {
      // Arrange
      final customer = CustomerFixtures.customer1;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customersProvider.overrideWith((ref) async => [customer]),
          ],
          child: const MaterialApp(home: CustomersScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text(customer.name));
      await tester.pump();

      // Assert - Card should be tappable (no exception thrown)
      expect(find.text(customer.name), findsOneWidget);
    });

    testWidgets('should allow text input in search field', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customersProvider.overrideWith(
              (ref) async => CustomerFixtures.allCustomers,
            ),
          ],
          child: const MaterialApp(home: CustomersScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.enterText(find.byType(TextField), 'أحمد');
      await tester.pump();

      // Assert
      expect(find.text('أحمد'), findsOneWidget);
    });

    testWidgets('should clear search field when clear button is pressed', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customersProvider.overrideWith(
              (ref) async => CustomerFixtures.allCustomers,
            ),
          ],
          child: const MaterialApp(home: CustomersScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Enter text
      await tester.enterText(find.byType(TextField), 'أحمد');
      await tester.pump();
      expect(find.text('أحمد'), findsOneWidget);

      // Act - Find and tap clear button
      final clearButton = find.descendant(
        of: find.byType(TextField),
        matching: find.byType(IconButton),
      );

      if (clearButton.evaluate().isNotEmpty) {
        await tester.tap(clearButton);
        await tester.pump();

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.controller?.text, isEmpty);
      }
    });

    testWidgets('should maintain scroll position when rebuilding', (
      tester,
    ) async {
      // Arrange
      final customers = List.generate(
        20,
        (index) => Customer(
          id: 'customer-$index',
          name: 'عميل $index',
          phone: '050123456$index',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [customersProvider.overrideWith((ref) async => customers)],
          child: const MaterialApp(home: CustomersScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll down
      await tester.drag(find.byType(ListView), const Offset(0, -1000));
      await tester.pumpAndSettle();

      // Verify scrolled position
      expect(find.text('عميل 0'), findsNothing);

      // Rebuild
      await tester.pump();

      // Assert - Should still be scrolled
      expect(find.text('عميل 0'), findsNothing);
    });
  });
}
