/// اختبارات مخرجات خدمة مستندات PDF المحاسبية.
library;

import 'dart:convert';

import 'package:basir_accounting_system/features/accounting/application/tax_engine_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_type.dart';
import 'package:basir_accounting_system/features/reports/application/pdf_generation_service.dart';
import 'package:basir_accounting_system/features/reports/application/report_pdf_service.dart';
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

JournalEntry _journalEntry() => JournalEntry(
      id: 'journal-1',
      referenceNumber: 'JE-2025-001',
      date: DateTime(2025, 5, 20),
      temporal: TemporalJustification(
        transactionDate: DateTime(2025, 5, 20),
        effectiveDate: DateTime(2025, 5, 20),
        recordingDate: DateTime(2025, 5, 20),
      ),
      standards: const StandardsJustification(
        standardReference: 'IFRS 15',
        recognitionBasis: 'Accrual',
      ),
      description: 'إثبات إيراد خدمة استشارية',
      status: JournalEntryStatus.posted,
      sourceDocument: 'sales_invoice',
      sourceId: 'invoice-sales',
      createdBy: 'accountant-1',
      createdAt: DateTime(2025, 5, 20),
      updatedAt: DateTime(2025, 5, 20),
      lines: [
        JournalEntryLine(
          accountId: '1100',
          accountName: 'الذمم المدينة',
          debit: Decimal.parse('115.00'),
          credit: Decimal.zero,
          description: 'رصيد العميل',
        ),
        JournalEntryLine(
          accountId: '4100',
          accountName: 'إيراد الخدمات',
          debit: Decimal.zero,
          credit: Decimal.parse('115.00'),
          description: 'إثبات الإيراد',
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

    test('ينشئ PDF قيد محاسبي متوازن بالمرجع وإجماليات الطرفين', () async {
      final entry = _journalEntry();
      final bytes = await PdfGenerationService().generateJournalEntryPdf(
        entry,
        companySettings: const {
          'companyName': 'بصير للاستشارات',
          'taxNumber': '310000000000003',
        },
      );

      expect(entry.isBalanced, isTrue);
      expect(bytes, isNotEmpty);
      expect(utf8.decode(bytes.take(4).toList()), '%PDF');
      expect(bytes.length, greaterThan(1000));
    });

    test('ينشئ PDF بيان ضريبة قيمة مضافة متكاملاً بأقسام الاستحقاق', () async {
      final vatReturn = VatReturnStatement(
        periodStart: DateTime(2025, 4),
        periodEnd: DateTime(2025, 6, 30),
        standardSalesBase: Decimal.parse('150000.00'),
        standardSalesTax: Decimal.parse('22500.00'),
        zeroRatedSales: Decimal.parse('5000.00'),
        exemptSales: Decimal.zero,
        standardPurchasesBase: Decimal.parse('80000.00'),
        standardPurchasesTax: Decimal.parse('12000.00'),
        netVatDue: Decimal.parse('10500.00'),
      );

      final bytes = await ReportPdfService().generateVatReturnPdf(vatReturn);

      expect(bytes, isNotEmpty);
      expect(utf8.decode(bytes.take(4).toList()), '%PDF');
      expect(bytes.length, greaterThan(1000));
    });
  });
}
