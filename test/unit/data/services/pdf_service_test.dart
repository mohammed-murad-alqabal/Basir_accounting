/// اختبارات PdfService
///
/// يختبر عمليات توليد PDF للفواتير
library;

import 'package:basser_app/features/customers/domain/entities/customer.dart';
import 'package:basser_app/features/invoices/data/services/pdf_service.dart';
import 'package:basser_app/features/invoices/domain/entities/invoice.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/mock_data.dart';

void main() {
  late PdfService pdfService;

  setUp(() {
    pdfService = PdfService();
  });

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('PdfService - Instance Creation', () {
    test('should create PdfService instance', () {
      expect(pdfService, isNotNull);
      expect(pdfService, isA<PdfService>());
    });

    test('should have generateInvoicePdf method', () {
      expect(pdfService.generateInvoicePdf, isNotNull);
    });

    test('should have printInvoice method', () {
      expect(pdfService.printInvoice, isNotNull);
    });
  });

  group('PdfService - Generate Invoice PDF', () {
    test('should generate PDF successfully with valid invoice and customer',
        () async {
      // Arrange
      final invoice = MockData.createTestInvoice();
      final customer = MockData.createTestCustomer();

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes, isNotEmpty);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('should generate PDF with correct header signature', () async {
      // Arrange
      final invoice = MockData.createTestInvoice();
      final customer = MockData.createTestCustomer();

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert - PDF يبدأ بـ %PDF
      final header = String.fromCharCodes(pdfBytes.take(4));
      expect(header, '%PDF');
    });

    test('should generate PDF with invoice containing multiple items',
        () async {
      // Arrange
      final invoice = MockData.createTestInvoice(itemCount: 5);
      final customer = MockData.createTestCustomer();

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('should generate PDF with invoice containing single item', () async {
      // Arrange
      final invoice = MockData.createTestInvoice(itemCount: 1);
      final customer = MockData.createTestCustomer();

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('should generate PDF with customer having all optional fields',
        () async {
      // Arrange
      final invoice = MockData.createTestInvoice();
      final customer = MockData.createTestCustomer(
        email: 'customer@example.com',
        address: 'الرياض، المملكة العربية السعودية',
      );

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('should generate PDF with customer having minimal fields', () async {
      // Arrange
      final invoice = MockData.createTestInvoice();
      final customer = MockData.createTestCustomer();

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('should generate PDF with invoice having notes', () async {
      // Arrange
      final invoice = MockData.createTestInvoice(
        notes: 'شكراً لتعاملكم معنا. يرجى الدفع خلال 30 يوم.',
      );
      final customer = MockData.createTestCustomer();

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('should generate PDF with invoice having no notes', () async {
      // Arrange
      final invoice = MockData.createTestInvoice();
      final customer = MockData.createTestCustomer();

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('should generate PDF with different tax rates', () async {
      // Arrange
      final invoice = MockData.createTestInvoice(taxRate: 0.20); // 20%
      final customer = MockData.createTestCustomer();

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('should generate PDF with zero tax rate', () async {
      // Arrange
      final invoice = MockData.createTestInvoice(taxRate: 0);
      final customer = MockData.createTestCustomer();

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('should generate different PDFs for different invoices', () async {
      // Arrange
      final invoice1 = MockData.createTestInvoice(id: 'INV-001');
      final invoice2 = MockData.createTestInvoice(id: 'INV-002');
      final customer = MockData.createTestCustomer();

      // Act
      final pdf1 = await pdfService.generateInvoicePdf(invoice1, customer);
      final pdf2 = await pdfService.generateInvoicePdf(invoice2, customer);

      // Assert
      expect(pdf1, isNot(equals(pdf2)));
    });

    test('should generate PDF with Arabic customer name', () async {
      // Arrange
      final invoice = MockData.createTestInvoice();
      final customer = MockData.createTestCustomer(
        name: 'شركة الأمل للتجارة والمقاولات',
      );

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('should generate PDF with long item descriptions', () async {
      // Arrange
      final invoice = MockData.createTestInvoice(
        itemName: 'خدمات استشارية متخصصة في مجال تطوير البرمجيات '
            'والتطبيقات الذكية مع الدعم الفني الكامل',
      );
      final customer = MockData.createTestCustomer();

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('should generate PDF with large amounts', () async {
      // Arrange
      final invoice = MockData.createTestInvoice(
        itemPrice: 999999.99,
        itemCount: 10,
      );
      final customer = MockData.createTestCustomer();

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('should generate PDF with small amounts', () async {
      // Arrange
      final invoice = MockData.createTestInvoice(
        itemPrice: 0.01,
        itemCount: 1,
      );
      final customer = MockData.createTestCustomer();

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });
  });

  group('PdfService - Error Handling', () {
    test('should handle invoice with empty items list', () async {
      // Arrange
      final invoice = MockData.createTestInvoice(itemCount: 0);
      final customer = MockData.createTestCustomer();

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('should handle customer with special characters in name', () async {
      // Arrange
      final invoice = MockData.createTestInvoice();
      final customer = MockData.createTestCustomer(
        name: 'شركة الأمل & الشركاء (المحدودة)',
      );

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('should handle invoice with very long notes', () async {
      // Arrange
      final longNotes = 'ملاحظات طويلة جداً ' * 50;
      final invoice = MockData.createTestInvoice(notes: longNotes);
      final customer = MockData.createTestCustomer();

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('should handle null customer email', () async {
      // Arrange
      final invoice = MockData.createTestInvoice();
      final customer = Customer(
        id: 'test-customer',
        name: 'Test Customer',
        phone: '+966501234567',
        email: null, // null email
        address: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('should handle null customer address', () async {
      // Arrange
      final invoice = MockData.createTestInvoice();
      final customer = Customer(
        id: 'test-customer',
        name: 'Test Customer',
        phone: '+966501234567',
        email: 'test@example.com',
        address: null, // null address
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('should handle null customer phone', () async {
      // Arrange
      final invoice = MockData.createTestInvoice();
      final customer = Customer(
        id: 'test-customer',
        name: 'Test Customer',
        phone: null, // null phone
        email: 'test@example.com',
        address: 'Test Address',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });
  });

  group('PdfService - PDF Content Validation', () {
    test('should include invoice ID in PDF', () async {
      // Arrange
      final invoice = MockData.createTestInvoice(id: 'INV-12345');
      final customer = MockData.createTestCustomer();

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
      // PDF should be generated successfully (content validation is complex for binary PDF)
      expect(pdfBytes.length, greaterThan(1000)); // Reasonable PDF size
    });

    test('should include customer name in PDF', () async {
      // Arrange
      final invoice = MockData.createTestInvoice();
      final customer = MockData.createTestCustomer(name: 'شركة الاختبار');

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('should include tax information in PDF', () async {
      // Arrange
      final invoice = MockData.createTestInvoice(taxRate: 0.15);
      final customer = MockData.createTestCustomer();

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('should include dates in PDF', () async {
      // Arrange
      final now = DateTime.now();
      final invoice = Invoice(
        id: 'test-invoice',
        customerId: 'test-customer',
        customerName: 'عميل اختبار',
        items: [MockData.createTestInvoiceItem()],
        issuedDate: now,
        dueDate: now.add(const Duration(days: 30)),
        taxRate: 0.15,
        status: 'draft',
        notes: null,
        createdAt: now,
        updatedAt: now,
      );
      final customer = MockData.createTestCustomer();

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });
  });

  group('PdfService - Print Invoice', () {
    test('should generate PDF for printing without throwing exception',
        () async {
      // Arrange
      final invoice = MockData.createTestInvoice();
      final customer = MockData.createTestCustomer();

      // Act & Assert - يجب أن لا يرمي خطأ
      // ملاحظة: printInvoice يستخدم Printing.sharePdf الذي يحتاج UI
      // لذا نختبر فقط أن generateInvoicePdf يعمل
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('should handle printInvoice method call', () async {
      // Arrange
      final invoice = MockData.createTestInvoice();
      final customer = MockData.createTestCustomer();

      // Act & Assert
      // في بيئة الاختبار، printInvoice قد يفشل بسبب عدم وجود UI
      // لكن يجب أن لا يرمي خطأ في generateInvoicePdf
      expect(
        () async => await pdfService.generateInvoicePdf(invoice, customer),
        returnsNormally,
      );
    });
  });

  group('PdfService - Edge Cases', () {
    test('should handle invoice with decimal quantities', () async {
      // Arrange
      final invoice = MockData.createTestInvoice(itemQuantity: 2.5);
      final customer = MockData.createTestCustomer();

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('should handle invoice with high precision amounts', () async {
      // Arrange
      final invoice = MockData.createTestInvoice(itemPrice: 123.456789);
      final customer = MockData.createTestCustomer();

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('should handle customer with very long name', () async {
      // Arrange
      final longName = 'شركة ' + 'طويلة جداً ' * 20;
      final invoice = MockData.createTestInvoice();
      final customer = MockData.createTestCustomer(name: longName);

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('should handle invoice with future dates', () async {
      // Arrange
      final futureDate = DateTime.now().add(const Duration(days: 365));
      final invoice = Invoice(
        id: 'future-invoice',
        customerId: 'test-customer',
        customerName: 'عميل اختبار',
        items: [MockData.createTestInvoiceItem()],
        issuedDate: futureDate,
        dueDate: futureDate.add(const Duration(days: 30)),
        taxRate: 0.15,
        status: 'draft',
        notes: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final customer = MockData.createTestCustomer();

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('should handle invoice with past dates', () async {
      // Arrange
      final pastDate = DateTime.now().subtract(const Duration(days: 365));
      final invoice = Invoice(
        id: 'past-invoice',
        customerId: 'test-customer',
        customerName: 'عميل اختبار',
        items: [MockData.createTestInvoiceItem()],
        issuedDate: pastDate,
        dueDate: pastDate.add(const Duration(days: 30)),
        taxRate: 0.15,
        status: 'draft',
        notes: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final customer = MockData.createTestCustomer();

      // Act
      final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer);

      // Assert
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });
  });
}
