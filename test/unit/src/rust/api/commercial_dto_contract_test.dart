import 'package:basir_accounting_system/src/rust/api/inventory.dart'
    as inventory;
import 'package:basir_accounting_system/src/rust/api/purchasing.dart'
    as purchasing;
import 'package:basir_accounting_system/src/rust/api/sales.dart' as sales;
import 'package:flutter_test/flutter_test.dart';

inventory.InventoryItemDto _inventoryItem({String code = 'ITEM-001'}) =>
    inventory.InventoryItemDto(
      id: 'item-1',
      code: code,
      nameAr: 'صنف تجريبي',
      nameEn: 'Test item',
      description: 'Inventory contract fixture',
      unit: 'piece',
      minStockLevel: '5.00',
      valuationMethod: 'weighted_average',
      purchasePrice: '10.00',
      salePrice: '15.00',
      assetAccountId: 'inventory-asset',
      cogsAccountId: 'cogs',
      revenueAccountId: 'revenue',
      createdAt: '2025-01-01T00:00:00Z',
      updatedAt: '2025-01-02T00:00:00Z',
    );

inventory.StockMovementDto _movement({String quantity = '3.00'}) =>
    inventory.StockMovementDto(
      id: 'movement-1',
      itemId: 'item-1',
      movementType: 'purchase',
      quantity: quantity,
      unitCost: '10.00',
      referenceId: 'purchase-1',
      date: '2025-01-10',
      description: 'Initial purchase',
    );

sales.CustomerDto _customer({String code = 'CUST-001'}) => sales.CustomerDto(
      id: 'customer-1',
      code: code,
      nameAr: 'عميل بصير',
      nameEn: 'Basir customer',
      taxId: '310000000000003',
    );

sales.SalesInvoiceLineDto _salesLine({String quantity = '2.00'}) =>
    sales.SalesInvoiceLineDto(
      productId: 'item-1',
      description: 'Consulting service',
      quantity: quantity,
      unitPrice: '100.00',
      taxAmount: '30.00',
      taxCategory: 'standard',
    );

purchasing.VendorDto _vendor({String code = 'VEND-001'}) =>
    purchasing.VendorDto(
      id: 'vendor-1',
      code: code,
      nameAr: 'مورد بصير',
      nameEn: 'Basir vendor',
      taxId: '310000000000003',
    );

void main() {
  group('Commercial Rust DTO contract', () {
    test('keeps inventory records and nested valuation reports intact', () {
      final valuationItems = [
        const inventory.ValuationItemDto(
          itemId: 'item-1',
          itemNameAr: 'صنف تجريبي',
          itemNameEn: 'Test item',
          quantity: '3.00',
          unitCost: '10.00',
          totalValue: '30.00',
        ),
      ];
      final report = inventory.InventoryValuationReportDto(
        asOf: '2025-01-31',
        items: valuationItems,
        totalValue: '30.00',
      );
      final equivalentReport = inventory.InventoryValuationReportDto(
        asOf: '2025-01-31',
        items: valuationItems,
        totalValue: '30.00',
      );

      expect(_inventoryItem(), _inventoryItem());
      expect(_inventoryItem().hashCode, _inventoryItem().hashCode);
      expect(_inventoryItem(), isNot(_inventoryItem(code: 'ITEM-002')));
      expect(_movement(), _movement());
      expect(_movement().hashCode, _movement().hashCode);
      expect(_movement(), isNot(_movement(quantity: '4.00')));
      expect(
        valuationItems.single,
        const inventory.ValuationItemDto(
          itemId: 'item-1',
          itemNameAr: 'صنف تجريبي',
          itemNameEn: 'Test item',
          quantity: '3.00',
          unitCost: '10.00',
          totalValue: '30.00',
        ),
      );
      expect(report, equivalentReport);
      expect(report.hashCode, equivalentReport.hashCode);
    });

    test('keeps customer, sales invoice, line, and payment details distinct',
        () {
      const invoice = sales.SalesInvoiceDto(
        id: 'sales-1',
        invoiceNumber: 'INV-001',
        customerId: 'customer-1',
        invoiceDate: '2025-01-15',
        dueDate: '2025-02-14',
        status: 'posted',
        totalAmount: '230.00',
        balanceDue: '230.00',
        description: 'Tax invoice',
        incomeAccountId: 'sales-revenue',
        arAccountId: 'accounts-receivable',
        qrCodeData: 'qr-fixture',
      );
      const equivalentInvoice = sales.SalesInvoiceDto(
        id: 'sales-1',
        invoiceNumber: 'INV-001',
        customerId: 'customer-1',
        invoiceDate: '2025-01-15',
        dueDate: '2025-02-14',
        status: 'posted',
        totalAmount: '230.00',
        balanceDue: '230.00',
        description: 'Tax invoice',
        incomeAccountId: 'sales-revenue',
        arAccountId: 'accounts-receivable',
        qrCodeData: 'qr-fixture',
      );
      const payment = sales.CustomerPaymentDto(
        id: 'payment-1',
        invoiceId: 'sales-1',
        amount: '230.00',
        paymentDate: '2025-01-16',
        bankAccountId: 'bank-1',
        paymentMethod: 'transfer',
        reference: 'TRX-001',
      );

      expect(_customer(), _customer());
      expect(_customer().hashCode, _customer().hashCode);
      expect(_customer(), isNot(_customer(code: 'CUST-002')));
      expect(_salesLine(), _salesLine());
      expect(_salesLine().hashCode, _salesLine().hashCode);
      expect(_salesLine(), isNot(_salesLine(quantity: '3.00')));
      expect(invoice, equivalentInvoice);
      expect(invoice.hashCode, equivalentInvoice.hashCode);
      expect(
        payment,
        const sales.CustomerPaymentDto(
          id: 'payment-1',
          invoiceId: 'sales-1',
          amount: '230.00',
          paymentDate: '2025-01-16',
          bankAccountId: 'bank-1',
          paymentMethod: 'transfer',
          reference: 'TRX-001',
        ),
      );
    });

    test('keeps vendor, purchase bill, and bill payment values intact', () {
      const bill = purchasing.PurchaseBillDto(
        id: 'bill-1',
        billNumber: 'PB-001',
        vendorId: 'vendor-1',
        billDate: '2025-01-15',
        dueDate: '2025-02-14',
        totalAmount: '115.00',
        balanceDue: '115.00',
        status: 'open',
        expenseAccountId: 'office-expense',
        apAccountId: 'accounts-payable',
        description: 'Office supply purchase',
      );
      const equivalentBill = purchasing.PurchaseBillDto(
        id: 'bill-1',
        billNumber: 'PB-001',
        vendorId: 'vendor-1',
        billDate: '2025-01-15',
        dueDate: '2025-02-14',
        totalAmount: '115.00',
        balanceDue: '115.00',
        status: 'open',
        expenseAccountId: 'office-expense',
        apAccountId: 'accounts-payable',
        description: 'Office supply purchase',
      );
      const payment = purchasing.BillPaymentDto(
        id: 'bill-payment-1',
        billId: 'bill-1',
        amount: '115.00',
        paymentDate: '2025-01-16',
        paymentMethod: 'bank_transfer',
        bankAccountId: 'bank-1',
        reference: 'PAY-001',
      );

      expect(_vendor(), _vendor());
      expect(_vendor().hashCode, _vendor().hashCode);
      expect(_vendor(), isNot(_vendor(code: 'VEND-002')));
      expect(bill, equivalentBill);
      expect(bill.hashCode, equivalentBill.hashCode);
      expect(
        payment,
        const purchasing.BillPaymentDto(
          id: 'bill-payment-1',
          billId: 'bill-1',
          amount: '115.00',
          paymentDate: '2025-01-16',
          paymentMethod: 'bank_transfer',
          bankAccountId: 'bank-1',
          reference: 'PAY-001',
        ),
      );
    });
  });
}
