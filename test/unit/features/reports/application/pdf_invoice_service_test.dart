import 'dart:typed_data';

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_accounting_system/features/reports/application/pdf_invoice_service.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/pdf.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final timestamp = DateTime.utc(2025, 8, 15, 10);
  final customer = Customer(
    id: 'customer-pdf-1',
    nameAr: 'شركة المدار للتقنية',
    nameEn: 'Al مدار Technology',
    address: 'الرياض، المملكة العربية السعودية',
    phone: '0501234567',
    createdAt: timestamp,
    updatedAt: timestamp,
  );

  Invoice invoiceWithItems({required bool includeNotes}) => Invoice(
        id: 'invoice-pdf-1',
        invoiceNumber: 'INV-2025-0081',
        customerId: customer.id,
        customerName: customer.nameAr,
        items: [
          InvoiceItem(
            id: 'line-1',
            name: 'اشتراك المحاسبة الذكية',
            quantity: Decimal.fromInt(2),
            price: Decimal.parse('150.00'),
            total: Decimal.parse('300.00'),
            taxAmount: Decimal.parse('45.00'),
            taxRate: Decimal.parse('0.15'),
          ),
          InvoiceItem(
            id: 'line-2',
            name: 'تدريب فريق الحسابات',
            quantity: Decimal.one,
            price: Decimal.parse('200.00'),
            total: Decimal.parse('200.00'),
            taxAmount: Decimal.parse('30.00'),
            taxRate: Decimal.parse('0.15'),
          ),
        ],
        issuedDate: timestamp,
        dueDate: timestamp.add(const Duration(days: 30)),
        createdAt: timestamp,
        updatedAt: timestamp,
        status: InvoiceStatus.sent,
        subtotalAmount: Decimal.parse('500.00'),
        taxAmount: Decimal.parse('75.00'),
        discountAmount: Decimal.zero,
        totalAmount: Decimal.parse('575.00'),
        paidAmount: Decimal.zero,
        taxRate: Decimal.parse('0.15'),
        discountRate: Decimal.zero,
        exchangeRate: Decimal.one,
        notes:
            includeNotes ? 'شكراً لاختياركم نظام بصير المحاسبي الذكي.' : null,
      );

  ProviderContainer containerFor(Map<String, String?> settings) =>
      ProviderContainer(
        overrides: [
          companySettingsProvider.overrideWith((ref) async => settings),
        ],
      );

  void expectPdf(Uint8List bytes) {
    expect(bytes, hasLength(greaterThan(1000)));
    expect(bytes.take(4).toList(), equals(<int>[0x25, 0x50, 0x44, 0x46]));
  }

  group('PdfInvoiceService', () {
    test('ينشئ فاتورة ضريبية متعددة البنود بإعدادات شركة مخصصة', () async {
      final container = containerFor(const {
        'companyName': 'شركة بصير للاختبارات المالية',
        'currencySymbol': 'ر.س',
        'taxNumber': '310000000000003',
      });
      addTearDown(container.dispose);

      final bytes = await container
          .read(pdfInvoiceServiceProvider.notifier)
          .generateInvoice(
            invoiceWithItems(includeNotes: true),
            customer,
            primaryColor: const PdfColor.fromInt(0xFF00695C),
          );

      expectPdf(bytes);
    });

    test('يستخدم القيم الافتراضية عند غياب اسم الشركة والضريبة والعملة',
        () async {
      final container = containerFor(const {});
      addTearDown(container.dispose);

      final bytes = await container
          .read(pdfInvoiceServiceProvider.notifier)
          .generateInvoice(invoiceWithItems(includeNotes: false), customer);

      expectPdf(bytes);
    });
  });
}
