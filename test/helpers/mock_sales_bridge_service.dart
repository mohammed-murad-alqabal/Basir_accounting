// Mock SalesBridgeService for Testing
// This provides a mock implementation of SalesBridgeService
// to eliminate RustLib dependency in tests

import 'package:basir_accounting_system/features/invoices/application/sales_bridge_service.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:mocktail/mocktail.dart';

/// Mock implementation of SalesBridgeService for testing
class MockSalesBridgeService extends Mock implements SalesBridgeService {
  @override
  Future<Invoice> finalizeInvoiceWithZatca(Invoice invoice) async =>
      // Mock implementation - return the invoice unchanged
      // In real tests, you can configure this mock to return specific values
      invoice.copyWith(
        qrCode: 'mock-qr-code-data', // Mock QR code for testing
      );
}
