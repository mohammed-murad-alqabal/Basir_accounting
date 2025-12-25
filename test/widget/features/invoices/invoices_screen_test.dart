import 'package:basser_app/core/assets/app_illustrations.dart';
import 'package:basser_app/features/invoices/presentation/providers/invoice_provider.dart';
import 'package:basser_app/features/invoices/presentation/screens/invoices_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/mock_data.dart';

void main() {
  group('InvoicesScreen Tests', () {
    testWidgets('should display app bar with title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredInvoicesProvider
                .overrideWithValue(const AsyncValue.data([])),
            invoiceStatisticsProvider.overrideWithValue(
              AsyncValue.data(
                InvoiceStatistics(
                  totalInvoices: 0,
                  paidInvoices: 0,
                  overdueInvoices: 0,
                  totalAmount: 0,
                ),
              ),
            ),
          ],
          child: const MaterialApp(home: InvoicesScreen()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('الفواتير'), findsOneWidget);
    });

    testWidgets('should display empty state when no invoices', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredInvoicesProvider
                .overrideWithValue(const AsyncValue.data([])),
            invoiceStatisticsProvider.overrideWithValue(
              AsyncValue.data(
                InvoiceStatistics(
                  totalInvoices: 0,
                  paidInvoices: 0,
                  overdueInvoices: 0,
                  totalAmount: 0,
                ),
              ),
            ),
          ],
          child: const MaterialApp(home: InvoicesScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert Mastery Strings
      expect(find.text('سجل الفواتير الذكي منظم'), findsOneWidget);
      expect(find.text('فاتورتك الأولى بانتظارك'), findsOneWidget);
      expect(find.byType(EmptyStateIllustration), findsOneWidget);
    });

    testWidgets('should display invoice list when data is available',
        (tester) async {
      final invoice = MockData.createTestInvoice(id: 'inv-1');
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredInvoicesProvider
                .overrideWithValue(AsyncValue.data([invoice])),
            invoiceStatisticsProvider.overrideWithValue(
              AsyncValue.data(
                InvoiceStatistics(
                  totalInvoices: 1,
                  paidInvoices: 0,
                  overdueInvoices: 0,
                  totalAmount: 1000,
                ),
              ),
            ),
          ],
          child: const MaterialApp(home: InvoicesScreen()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('فاتورة inv-1'), findsOneWidget);
    });
  });
}
