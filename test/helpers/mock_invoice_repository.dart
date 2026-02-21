import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/repositories/invoice_repository.dart';
import 'package:mocktail/mocktail.dart';

/// Mock implementation of InvoiceRepository for testing.
class MockInvoiceRepository extends Mock implements InvoiceRepository {}

/// Fake Invoice for registerFallbackValue.
class FakeInvoice extends Fake implements Invoice {}

/// Setup function to register fallback values.
void setUpInvoiceMocks() {
  registerFallbackValue(FakeInvoice());
}
