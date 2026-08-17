import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_accounting_system/features/zatca/domain/zatca_types.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

Invoice _invoiceFixture({
  InvoiceStatus status = InvoiceStatus.sent,
  DateTime? dueDate,
  Decimal? subtotalAmount,
  Decimal? taxAmount,
  Decimal? totalAmount,
}) {
  final issuedAt = DateTime.utc(2026, 1, 1, 9);
  return Invoice(
    id: 'invoice-001',
    invoiceNumber: 'INV-2026-001',
    customerId: 'customer-001',
    customerName: 'شركة بصير',
    items: [
      InvoiceItem(
        id: 'item-001',
        name: 'خدمة محاسبية',
        quantity: Decimal.fromInt(2),
        price: Decimal.fromInt(50),
        total: Decimal.fromInt(100),
        taxAmount: Decimal.fromInt(15),
        taxRate: Decimal.parse('0.15'),
        description: 'اشتراك شهري',
      ),
      InvoiceItem(
        id: 'item-002',
        name: 'استشارة',
        quantity: Decimal.one,
        price: Decimal.fromInt(20),
        total: Decimal.fromInt(20),
        taxAmount: Decimal.fromInt(3),
        taxRate: Decimal.parse('0.15'),
      ),
    ],
    issuedDate: issuedAt,
    dueDate: dueDate ?? issuedAt.add(const Duration(days: 30)),
    createdAt: issuedAt,
    updatedAt: issuedAt,
    status: status,
    subtotalAmount: subtotalAmount ?? Decimal.fromInt(120),
    taxAmount: taxAmount ?? Decimal.fromInt(18),
    discountAmount: Decimal.fromInt(8),
    totalAmount: totalAmount ?? Decimal.fromInt(130),
    paidAmount: Decimal.fromInt(30),
    taxRate: Decimal.parse('0.15'),
    discountRate: Decimal.parse('0.05'),
    exchangeRate: Decimal.parse('3.75'),
    paidDate: issuedAt.add(const Duration(days: 3)),
    currency: 'USD',
    notes: 'يتطلب مراجعة',
    terms: 'السداد خلال 30 يوماً',
    zatcaUuid: 'zatca-uuid-001',
    zatcaHash: 'hash-001',
    qrCode: 'qr-payload',
    xmlContent: '<Invoice/>',
    zatcaDeviceId: 'device-001',
    zatcaStatus: ZatcaSubmissionStatus.reportedWithWarnings,
    zatcaCounter: 42,
    userId: 'user-001',
    warehouseId: 'warehouse-001',
    syncStatus: SyncStatus.pendingPush,
    serverUpdatedAt: issuedAt.add(const Duration(hours: 1)),
  );
}

void main() {
  group('InvoiceItem Tests', () {
    test('should create InvoiceItem with all properties', () {
      // Arrange & Act
      final item = InvoiceItem(
        taxRate: Decimal.parse('0.15'),
        id: 'item-1',
        name: 'خدمة استشارية',
        quantity: Decimal.fromInt(2),
        price: Decimal.fromInt(500),
        total: Decimal.fromInt(1000),
        taxAmount: Decimal.fromInt(150),
      );

      // Assert
      expect(item.id, 'item-1');
      expect(item.name, 'خدمة استشارية');
      expect(item.quantity, Decimal.fromInt(2));
      expect(item.price, Decimal.fromInt(500));
      expect(item.total, Decimal.fromInt(1000));
      expect(item.taxAmount, Decimal.fromInt(150));
    });

    test('should hold correct total', () {
      // Arrange
      final item = InvoiceItem(
        taxRate: Decimal.parse('0.15'),
        id: 'item-1',
        name: 'خدمة',
        quantity: Decimal.fromInt(3),
        price: Decimal.fromInt(250),
        total: Decimal.fromInt(750),
        taxAmount: Decimal.parse('112.5'),
      );

      // Assert
      expect(item.total, Decimal.fromInt(750));
    });
  });

  group('Invoice Tests', () {
    late DateTime now;
    late DateTime dueDate;

    setUp(() {
      now = DateTime.now();
      dueDate = now.add(const Duration(days: 30));
    });

    test('should create Invoice with all properties', () {
      // Arrange & Act
      final invoice = Invoice(
        id: 'inv-001',
        invoiceNumber: 'INV-001',
        customerId: 'customer-1',
        customerName: 'أحمد محمد',
        items: [
          InvoiceItem(
            taxRate: Decimal.parse('0.15'),
            id: 'item-1',
            name: 'خدمة',
            quantity: Decimal.fromInt(2),
            price: Decimal.fromInt(500),
            total: Decimal.fromInt(1000),
            taxAmount: Decimal.fromInt(150),
          ),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: Decimal.parse('0.15'),
        status: InvoiceStatus.sent,
        createdAt: now,
        updatedAt: now,
        subtotalAmount: Decimal.fromInt(1000),
        taxAmount: Decimal.fromInt(150),
        totalAmount: Decimal.fromInt(1150),
        paidAmount: Decimal.zero,
        discountAmount: Decimal.zero,
        discountRate: Decimal.zero,
        exchangeRate: Decimal.one,
      );

      // Assert
      expect(invoice.id, 'inv-001');
      expect(invoice.customerId, 'customer-1');
      expect(invoice.customerName, 'أحمد محمد');
      expect(invoice.items.length, 1);
      expect(invoice.taxRate, Decimal.parse('0.15'));
      expect(invoice.status, InvoiceStatus.sent);
      expect(invoice.totalAmount, Decimal.fromInt(1150));
    });

    test('should hold correct subtotal with single item', () {
      // Arrange
      final invoice = Invoice(
        id: 'inv-001',
        invoiceNumber: 'INV-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: [
          InvoiceItem(
            taxRate: Decimal.parse('0.15'),
            id: 'item-1',
            name: 'خدمة',
            quantity: Decimal.fromInt(2),
            price: Decimal.fromInt(500),
            total: Decimal.fromInt(1000),
            taxAmount: Decimal.fromInt(150),
          ),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: Decimal.parse('0.15'),
        status: InvoiceStatus.sent,
        createdAt: now,
        updatedAt: now,
        subtotalAmount: Decimal.fromInt(1000),
        taxAmount: Decimal.fromInt(150),
        totalAmount: Decimal.fromInt(1150),
        paidAmount: Decimal.zero,
        discountAmount: Decimal.zero,
        discountRate: Decimal.zero,
        exchangeRate: Decimal.one,
      );

      // Assert
      expect(invoice.subtotalAmount, Decimal.fromInt(1000));
    });

    test('should hold correct tax total', () {
      // Arrange
      final invoice = Invoice(
        id: 'inv-001',
        invoiceNumber: 'INV-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: [
          InvoiceItem(
            taxRate: Decimal.parse('0.15'),
            id: 'item-1',
            name: 'خدمة',
            quantity: Decimal.fromInt(2),
            price: Decimal.fromInt(500),
            total: Decimal.fromInt(1000),
            taxAmount: Decimal.fromInt(150),
          ),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: Decimal.parse('0.15'),
        status: InvoiceStatus.sent,
        createdAt: now,
        updatedAt: now,
        subtotalAmount: Decimal.fromInt(1000),
        taxAmount: Decimal.fromInt(150),
        totalAmount: Decimal.fromInt(1150),
        paidAmount: Decimal.zero,
        discountAmount: Decimal.zero,
        discountRate: Decimal.zero,
        exchangeRate: Decimal.one,
      );

      // Assert
      expect(invoice.taxAmount, Decimal.fromInt(150)); // 1000 * 0.15
    });

    test('should hold correct grand total', () {
      // Arrange
      final invoice = Invoice(
        id: 'inv-001',
        invoiceNumber: 'INV-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: [
          InvoiceItem(
            taxRate: Decimal.parse('0.15'),
            id: 'item-1',
            name: 'خدمة',
            quantity: Decimal.fromInt(2),
            price: Decimal.fromInt(500),
            total: Decimal.fromInt(1000),
            taxAmount: Decimal.fromInt(150),
          ),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: Decimal.parse('0.15'),
        status: InvoiceStatus.sent,
        createdAt: now,
        updatedAt: now,
        subtotalAmount: Decimal.fromInt(1000),
        taxAmount: Decimal.fromInt(150),
        totalAmount: Decimal.fromInt(1150),
        paidAmount: Decimal.zero,
        discountAmount: Decimal.zero,
        discountRate: Decimal.zero,
        exchangeRate: Decimal.one,
      );

      // Assert
      expect(invoice.totalAmount, Decimal.fromInt(1150)); // 1000 + 150
    });

    test('should support optional notes', () {
      // Arrange
      final invoice = Invoice(
        id: 'inv-001',
        invoiceNumber: 'INV-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: [
          InvoiceItem(
            taxRate: Decimal.parse('0.15'),
            id: 'item-1',
            name: 'خدمة',
            quantity: Decimal.one,
            price: Decimal.fromInt(100),
            total: Decimal.fromInt(100),
            taxAmount: Decimal.fromInt(15),
          ),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: Decimal.parse('0.15'),
        status: InvoiceStatus.sent,
        createdAt: now,
        updatedAt: now,
        subtotalAmount: Decimal.fromInt(100),
        taxAmount: Decimal.fromInt(15),
        totalAmount: Decimal.fromInt(115),
        paidAmount: Decimal.zero,
        discountAmount: Decimal.zero,
        discountRate: Decimal.zero,
        exchangeRate: Decimal.one,
        notes: 'شروط الدفع: 30 يوم',
      );

      // Assert
      expect(invoice.notes, 'شروط الدفع: 30 يوم');
    });

    test('should support copyWith for status change', () {
      // Arrange
      final invoice = Invoice(
        id: 'inv-001',
        invoiceNumber: 'INV-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: [
          InvoiceItem(
            taxRate: Decimal.parse('0.15'),
            id: 'item-1',
            name: 'خدمة',
            quantity: Decimal.one,
            price: Decimal.fromInt(100),
            total: Decimal.fromInt(100),
            taxAmount: Decimal.fromInt(15),
          ),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: Decimal.parse('0.15'),
        status: InvoiceStatus.draft,
        createdAt: now,
        updatedAt: now,
        subtotalAmount: Decimal.fromInt(100),
        taxAmount: Decimal.fromInt(15),
        totalAmount: Decimal.fromInt(115),
        paidAmount: Decimal.zero,
        discountAmount: Decimal.zero,
        discountRate: Decimal.zero,
        exchangeRate: Decimal.one,
      );

      // Act
      final updated = invoice.copyWith(status: InvoiceStatus.paid);

      // Assert
      expect(updated.status, InvoiceStatus.paid);
      expect(updated.id, invoice.id);
      expect(updated.customerId, invoice.customerId);
    });
  });

  group('Invoice fiscal integrity contract', () {
    test('round-trips fiscal, ZATCA, and synchronization fields through JSON',
        () {
      final invoice = _invoiceFixture();

      final json = invoice.toJson();
      final restored = Invoice.fromJson(json);

      expect(json['invoiceNumber'], 'INV-2026-001');
      expect(json['status'], 'sent');
      expect(json['zatcaStatus'], 'reportedWithWarnings');
      expect(json['syncStatus'], 'pendingPush');
      expect(restored, invoice);
      expect(restored.items, hasLength(2));
      expect(restored.items.first.taxRate, Decimal.parse('0.15'));
      expect(restored.paidDate, DateTime.utc(2026, 1, 4, 9));
      expect(restored.serverUpdatedAt, DateTime.utc(2026, 1, 1, 10));
    });

    test('calculates outstanding, base-currency, and item-derived totals', () {
      final invoice = _invoiceFixture();

      expect(invoice.remainingAmount, Decimal.fromInt(100));
      expect(
        invoice.totalAmountBaseCurrency,
        Decimal.fromInt(130) * Decimal.parse('3.75'),
      );
      expect(invoice.subtotalAmountBaseCurrency, Decimal.fromInt(450));
      expect(invoice.taxAmountBaseCurrency, Decimal.parse('67.50'));
      expect(invoice.discountAmountBaseCurrency, Decimal.fromInt(30));
      expect(invoice.calculatedSubtotal, Decimal.fromInt(120));
      expect(invoice.calculatedTax, Decimal.fromInt(18));
      expect(invoice.calculatedTotal, Decimal.fromInt(130));
      expect(invoice.hasTotalDiscrepancy, isFalse);
    });

    test('detects a material discrepancy and returns a corrected audit copy',
        () {
      final inconsistent = _invoiceFixture(
        subtotalAmount: Decimal.fromInt(100),
        taxAmount: Decimal.fromInt(15),
        totalAmount: Decimal.fromInt(107),
      );

      final healed = inconsistent.healedCopy;

      expect(inconsistent.hasTotalDiscrepancy, isTrue);
      expect(healed.subtotalAmount, Decimal.fromInt(120));
      expect(healed.taxAmount, Decimal.fromInt(18));
      expect(healed.totalAmount, Decimal.fromInt(130));
      expect(healed.updatedAt.isAfter(inconsistent.updatedAt), isTrue);
    });

    test('marks only unsettled invoices with a past due date as overdue', () {
      final pastDue = DateTime.now().subtract(const Duration(days: 1));

      expect(_invoiceFixture(dueDate: pastDue).isOverdue, isTrue);
      expect(
        _invoiceFixture(status: InvoiceStatus.paid, dueDate: pastDue).isOverdue,
        isFalse,
      );
      expect(
        _invoiceFixture(
          status: InvoiceStatus.cancelled,
          dueDate: pastDue,
        ).isOverdue,
        isFalse,
      );
    });
  });
}
