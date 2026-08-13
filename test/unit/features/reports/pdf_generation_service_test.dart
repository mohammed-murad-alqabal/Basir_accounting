/// اختبارات مخرجات خدمة مستندات PDF المحاسبية.
library;

import 'dart:convert';

import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_type.dart';
import 'package:basir_accounting_system/features/reports/application/pdf_generation_service.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

Invoice _invoice({required InvoiceType type, String? qrCode}) => Invoice(
      id: 'invoice-${type.name}',
      invoiceNumber: 'INV-2025-001',
      customerId: 'customer-1',
      customerName: 'شركة العميل',
      issuedDate: DateTime(2025, 5, 20),
      dueDate: DateTime(2025, 6, 20),
      createdAt: DateTime(2025, 5, 20),
      updatedAt: DateTime(2025, 5, 20),
      status: InvoiceStatus.sent,
      subtotalAmount: Decimal.parse('100.00'),
      taxAmount: Decimal.parse('15.00'),
      discountAmount: Decimal.zero,
      totalAmount: Decimal.parse('115.00'),
      paidAmount: Decimal.zero,
      taxRate: Decimal.parse('0.15'),
      discountRate: Decimal.zero,
      exchangeRate: Decimal.one,
      type: type,
      currency: 'SAR',
      qrCode: qrCode,
      items: [
        InvoiceItem(
          id: 'line-1',
          name: 'خدمة استشارية',
          quantity: Decimal.one,
          price: Decimal.parse('100.00'),
          total: Decimal.parse('100.00'),
          taxAmount: Decimal.parse('15.00'),
          taxRate: Decimal.parse('0.15'),
          description: 'Consulting service',
        ),
      ],
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PdfGenerationService', () {
    test('ينشئ PDF فاتورة مبيعات صالحاً بالعلامة والضريبة ورمز QR', () async {
      final bytes = await PdfGenerationService().generateInvoicePdf(
        _invoice(type: InvoiceType.sales, qrCode: 'ZATCA-QR-001'),
        companySettings: const {
          'companyName': 'بصير للاستشارات',
          'taxNumber': '310000000000003',
        },
      );

      expect(bytes, isNotEmpty);
      expect(utf8.decode(bytes.take(4).toList()), '%PDF');
      expect(bytes.length, greaterThan(1000));
    });

    test('ينشئ إيصالاً حرارياً صالحاً لإشعار دائن بلا رمز QR', () async {
      final bytes = await PdfGenerationService().generateThermalReceipt(
        _invoice(type: InvoiceType.salesReturn),
        companySettings: const {
          'companyName': 'Basir Accounting',
          'taxNumber': '',
        },
      );

      expect(bytes, isNotEmpty);
      expect(utf8.decode(bytes.take(4).toList()), '%PDF');
      expect(bytes.length, greaterThan(1000));
    });
  });
}
