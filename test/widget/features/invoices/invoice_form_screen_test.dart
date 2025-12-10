import 'package:basser_app/core/providers.dart';
import 'package:basser_app/features/invoices/domain/entities/invoice.dart';
import 'package:basser_app/features/invoices/presentation/screens/invoice_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/invoice_fixtures.dart';
import '../../../mocks/mock_customer_repository.dart';
import '../../../mocks/mock_invoice_repository.dart';

void main() {
  late MockCustomerRepository mockCustomerRepository;
  late MockInvoiceRepository mockInvoiceRepository;

  setUp(() {
    mockCustomerRepository = MockCustomerRepository();
    mockInvoiceRepository = MockInvoiceRepository();
  });

  Widget createTestWidget({Invoice? invoice}) => ProviderScope(
        overrides: [
          customerRepositoryProvider.overrideWithValue(mockCustomerRepository),
          invoiceRepositoryProvider.overrideWithValue(mockInvoiceRepository),
        ],
        child: MaterialApp(home: InvoiceFormScreen(invoice: invoice)),
      );

  group('InvoiceFormScreen - Basic Display', () {
    testWidgets('should build without error', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(InvoiceFormScreen), findsOneWidget);
    });

    testWidgets('should display scaffold', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should display app bar', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display form', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Form), findsOneWidget);
    });
  });

  group('InvoiceFormScreen - With Invoice', () {
    testWidgets('should build with invoice', (tester) async {
      await tester.pumpWidget(
        createTestWidget(invoice: InvoiceFixtures.invoice1),
      );
      await tester.pumpAndSettle();

      expect(find.byType(InvoiceFormScreen), findsOneWidget);
    });
  });
}
