import 'package:basser_app/core/theme.dart';
import 'package:basser_app/features/invoices/domain/entities/invoice.dart';
import 'package:basser_app/features/invoices/presentation/providers/invoice_provider.dart';
import 'package:basser_app/features/invoices/presentation/screens/invoices_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/invoice_fixtures.dart';

void main() {
  group('InvoicesScreen - Display', () {
    testWidgets('should display app bar with title', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredInvoicesProvider.overrideWith(
              (ref) => AsyncValue.data(InvoiceFixtures.allInvoices),
            ),
          ],
          child: const MaterialApp(
            home: InvoicesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('الفواتير'), findsOneWidget);
    });

    testWidgets('should display add button in app bar', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredInvoicesProvider.overrideWith(
              (ref) => AsyncValue.data(InvoiceFixtures.allInvoices),
            ),
          ],
          child: const MaterialApp(
            home: InvoicesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should display PDF export button in app bar', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredInvoicesProvider.overrideWith(
              (ref) => AsyncValue.data(InvoiceFixtures.allInvoices),
            ),
          ],
          child: const MaterialApp(
            home: InvoicesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.picture_as_pdf), findsOneWidget);
    });

    testWidgets('should display search field', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredInvoicesProvider.overrideWith(
              (ref) => AsyncValue.data(InvoiceFixtures.allInvoices),
            ),
          ],
          child: const MaterialApp(
            home: InvoicesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('ابحث عن فاتورة...'), findsOneWidget);
    });

    testWidgets('should display filter chips', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredInvoicesProvider.overrideWith(
              (ref) => AsyncValue.data(InvoiceFixtures.allInvoices),
            ),
          ],
          child: const MaterialApp(
            home: InvoicesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('الكل'), findsOneWidget);
      expect(find.text('paid'), findsOneWidget);
      expect(find.text('issued'), findsOneWidget);
      expect(find.text('overdue'), findsOneWidget);
    });

    testWidgets('should display loading indicator when loading',
        (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredInvoicesProvider.overrideWith(
              (ref) => const AsyncValue.loading(),
            ),
          ],
          child: const MaterialApp(
            home: InvoicesScreen(),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display empty state when no invoices', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredInvoicesProvider.overrideWith(
              (ref) => const AsyncValue.data(<Invoice>[]),
            ),
          ],
          child: const MaterialApp(
            home: InvoicesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('لا توجد فواتير'), findsOneWidget);
      expect(find.byIcon(Icons.receipt_long), findsOneWidget);
    });

    testWidgets('should display error message when error occurs',
        (tester) async {
      // Arrange
      const errorMessage = 'فشل في تحميل الفواتير';

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredInvoicesProvider.overrideWith(
              (ref) => AsyncValue.error(
                Exception(errorMessage),
                StackTrace.current,
              ),
            ),
          ],
          child: const MaterialApp(
            home: InvoicesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('خطأ في تحميل الفواتير'), findsOneWidget);
    });

    testWidgets('should display list of invoices when data is available',
        (tester) async {
      // Arrange
      final invoices = InvoiceFixtures.allInvoices;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredInvoicesProvider.overrideWith(
              (ref) => AsyncValue.data(invoices),
            ),
          ],
          child: const MaterialApp(
            home: InvoicesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Check that invoices are displayed (at least some of them)
      expect(
        find.text('فاتورة ${InvoiceFixtures.invoice1.id}'),
        findsOneWidget,
      );
      expect(
        find.text('فاتورة ${InvoiceFixtures.invoice2.id}'),
        findsOneWidget,
      );
      expect(
        find.text('فاتورة ${InvoiceFixtures.invoice3.id}'),
        findsOneWidget,
      );
    });

    testWidgets('should display invoice details in list card', (tester) async {
      // Arrange
      final invoice = InvoiceFixtures.invoice1;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredInvoicesProvider.overrideWith(
              (ref) => AsyncValue.data([invoice]),
            ),
          ],
          child: const MaterialApp(
            home: InvoicesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('فاتورة ${invoice.id}'), findsOneWidget);
      expect(find.textContaining(invoice.customerName), findsOneWidget);
      expect(
        find.textContaining(invoice.grandTotal.toStringAsFixed(2)),
        findsOneWidget,
      );
    });

    testWidgets('should display invoice status icon', (tester) async {
      // Arrange
      final paidInvoice = InvoiceFixtures.invoice3; // paid status

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredInvoicesProvider.overrideWith(
              (ref) => AsyncValue.data([paidInvoice]),
            ),
          ],
          child: const MaterialApp(
            home: InvoicesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Check for status icon (check_circle for paid)
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should display multiple invoices in list', (tester) async {
      // Arrange
      final invoices = InvoiceFixtures.allInvoices;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredInvoicesProvider.overrideWith(
              (ref) => AsyncValue.data(invoices),
            ),
          ],
          child: const MaterialApp(
            home: InvoicesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Check that multiple invoices are displayed
      expect(find.byType(ListView), findsOneWidget);
      // At least 5 invoices should be visible in viewport
      expect(find.textContaining('فاتورة'), findsAtLeastNWidgets(5));
    });

    testWidgets('should use correct background color', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredInvoicesProvider.overrideWith(
              (ref) => AsyncValue.data(InvoiceFixtures.allInvoices),
            ),
          ],
          child: const MaterialApp(
            home: InvoicesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, AppColors.background);
    });

    testWidgets('should display invoices in scrollable list', (tester) async {
      // Arrange
      final invoices = InvoiceFixtures.createInvoices(20);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredInvoicesProvider.overrideWith(
              (ref) => AsyncValue.data(invoices),
            ),
          ],
          child: const MaterialApp(
            home: InvoicesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Check that ListView is present
      expect(find.byType(ListView), findsOneWidget);

      // Verify first invoice is visible
      expect(find.text('فاتورة invoice-1'), findsOneWidget);

      // Scroll to bottom
      await tester.drag(find.byType(ListView), const Offset(0, -5000));
      await tester.pumpAndSettle();

      // Verify last invoice is now visible
      expect(find.text('فاتورة invoice-20'), findsOneWidget);
    });

    testWidgets('should display invoice date correctly', (tester) async {
      // Arrange
      final invoice = InvoiceFixtures.invoice1;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredInvoicesProvider.overrideWith(
              (ref) => AsyncValue.data([invoice]),
            ),
          ],
          child: const MaterialApp(
            home: InvoicesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Check that date is displayed
      final dateStr = invoice.issuedDate.toLocal().toString().split(' ')[0];
      expect(find.textContaining(dateStr), findsOneWidget);
    });

    testWidgets('should display different status colors', (tester) async {
      // Arrange - Use invoices with different statuses
      final invoices = [
        InvoiceFixtures.invoice3, // paid
        InvoiceFixtures.invoice2, // issued
        InvoiceFixtures.invoice4, // overdue
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredInvoicesProvider.overrideWith(
              (ref) => AsyncValue.data(invoices),
            ),
          ],
          child: const MaterialApp(
            home: InvoicesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Check for different status icons
      expect(find.byIcon(Icons.check_circle), findsOneWidget); // paid
      expect(find.byIcon(Icons.schedule), findsOneWidget); // issued
      expect(find.byIcon(Icons.error), findsOneWidget); // overdue
    });
  });
}
