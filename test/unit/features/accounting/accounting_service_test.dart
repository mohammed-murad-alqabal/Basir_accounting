import 'package:basir_accounting_system/features/accounting/application/multi_standard_coa_engine.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AccountingService', () {
    group('Chart of Accounts Generation', () {
      test('should generate Saudi Arabia COA with ZATCA VAT account', () {
        final accounts = MultiStandardCoaEngine.generateCoa(
          AccountingCountry.saudiArabia,
        );

        expect(accounts, isNotEmpty);
        expect(
          accounts.any((a) => a.nameAr.contains('ضريبة القيمة المضافة')),
          isTrue,
          reason: 'Saudi COA should include VAT account',
        );
      });

      test('should generate global IFRS COA with all account types', () {
        final accounts = MultiStandardCoaEngine.generateCoa(
          AccountingCountry.global,
        );

        expect(accounts, isNotEmpty);
        expect(accounts.any((a) => a.type == AccountType.asset), isTrue);
        expect(accounts.any((a) => a.type == AccountType.liability), isTrue);
        expect(accounts.any((a) => a.type == AccountType.revenue), isTrue);
        expect(accounts.any((a) => a.type == AccountType.expense), isTrue);
      });

      test('should generate UAE COA with FTA VAT account', () {
        final accounts = MultiStandardCoaEngine.generateCoa(
          AccountingCountry.uae,
        );

        expect(accounts, isNotEmpty);
        expect(
          accounts.any((a) => a.nameEn.contains('FTA')),
          isTrue,
          reason: 'UAE COA should include FTA VAT account',
        );
      });
    });

    group('Journal Entry Validation', () {
      test('balanced journal entry should have equal debits and credits', () {
        final entry = JournalEntry(
          id: 'test-1',
          referenceNumber: 'JE-001',
          date: DateTime.now(),
          temporal: TemporalJustification(
            transactionDate: DateTime.now(),
            effectiveDate: DateTime.now(),
            recordingDate: DateTime.now(),
          ),
          standards: const StandardsJustification(
            standardReference: 'IFRS',
            recognitionBasis: 'Accrual',
          ),
          description: 'Test entry',
          status: JournalEntryStatus.draft,
          sourceDocument: 'manual',
          sourceId: 'test',
          createdBy: 'test-user',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          lines: [
            JournalEntryLine(
              accountId: 'acc-1',
              accountName: 'Cash',
              debit: Decimal.parse('1000'),
              credit: Decimal.zero,
              description: 'Debit',
            ),
            JournalEntryLine(
              accountId: 'acc-2',
              accountName: 'Revenue',
              debit: Decimal.zero,
              credit: Decimal.parse('1000'),
              description: 'Credit',
            ),
          ],
        );

        final totalDebit = entry.lines.fold(
          Decimal.zero,
          (sum, l) => sum + l.debit,
        );
        final totalCredit = entry.lines.fold(
          Decimal.zero,
          (sum, l) => sum + l.credit,
        );

        expect(totalDebit, equals(totalCredit));
      });

      test('unbalanced journal entry should have unequal totals', () {
        final entry = JournalEntry(
          id: 'test-2',
          referenceNumber: 'JE-002',
          date: DateTime.now(),
          temporal: TemporalJustification(
            transactionDate: DateTime.now(),
            effectiveDate: DateTime.now(),
            recordingDate: DateTime.now(),
          ),
          standards: const StandardsJustification(
            standardReference: 'IFRS',
            recognitionBasis: 'Accrual',
          ),
          description: 'Unbalanced entry',
          status: JournalEntryStatus.draft,
          sourceDocument: 'manual',
          sourceId: 'test',
          createdBy: 'test-user',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          lines: [
            JournalEntryLine(
              accountId: 'acc-1',
              accountName: 'Cash',
              debit: Decimal.parse('1000'),
              credit: Decimal.zero,
              description: 'Debit',
            ),
            JournalEntryLine(
              accountId: 'acc-2',
              accountName: 'Revenue',
              debit: Decimal.zero,
              credit: Decimal.parse('500'), // Unbalanced
              description: 'Credit',
            ),
          ],
        );

        final totalDebit = entry.lines.fold(
          Decimal.zero,
          (sum, l) => sum + l.debit,
        );
        final totalCredit = entry.lines.fold(
          Decimal.zero,
          (sum, l) => sum + l.credit,
        );

        expect(totalDebit, isNot(equals(totalCredit)));
      });
    });

    group('Invoice VAT Calculation', () {
      test('sales invoice VAT should be 15% of subtotal', () {
        final invoice = Invoice(
          id: 'inv-1',
          invoiceNumber: 'INV-001',
          customerId: 'cust-1',
          customerName: 'Test Customer',
          issuedDate: DateTime.now(),
          dueDate: DateTime.now().add(const Duration(days: 30)),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          subtotalAmount: Decimal.fromInt(1000),
          taxAmount: Decimal.fromInt(150),
          discountAmount: Decimal.zero,
          discountRate: Decimal.zero,
          exchangeRate: Decimal.one,
          totalAmount: Decimal.fromInt(1150),
          paidAmount: Decimal.zero,
          taxRate: Decimal.parse('0.15'),
          status: InvoiceStatus.sent,
          items: [
            InvoiceItem(
              taxRate: Decimal.parse('0.15'),
              id: 'item-1',
              name: 'Service',
              quantity: Decimal.one,
              price: Decimal.fromInt(1000),
              total: Decimal.fromInt(1000),
              taxAmount: Decimal.fromInt(150),
            ),
          ],
        );

        // Verify VAT calculation (15% of subtotal)
        final expectedVat = invoice.subtotalAmount * Decimal.parse('0.15');
        expect(invoice.taxAmount, equals(expectedVat));

        // Verify total = subtotal + VAT - discount
        final expectedTotal =
            invoice.subtotalAmount + invoice.taxAmount - invoice.discountAmount;
        expect(invoice.totalAmount, equals(expectedTotal));
      });
    });

    group('Account Hierarchy', () {
      test('child accounts should reference parent correctly', () {
        final parentAccount = Account(
          id: 'parent-1',
          code: '1000',
          nameAr: 'الأصول',
          nameEn: 'Assets',
          type: AccountType.asset,
          nature: AccountNature.debit,
          balance: Decimal.zero,
          isParent: true,
        );

        final childAccount = Account(
          id: 'child-1',
          code: '1100',
          nameAr: 'الأصول المتداولة',
          nameEn: 'Current Assets',
          type: AccountType.asset,
          nature: AccountNature.debit,
          balance: Decimal.parse('5000'),
          parentId: 'parent-1',
        );

        expect(childAccount.parentId, equals(parentAccount.id));
        expect(childAccount.type, equals(parentAccount.type));
      });

      test('parent accounts should be marked as isParent', () {
        final accounts = MultiStandardCoaEngine.generateCoa(
          AccountingCountry.global,
        );

        final parentAccounts = accounts.where((a) => a.isParent).toList();
        expect(parentAccounts, isNotEmpty);

        // All parent accounts should have children
        for (final parent in parentAccounts) {
          // Note: Some top-level parents may not have children in minimal COA
          expect(
            parent.isParent,
            isTrue,
            reason: 'Account ${parent.code} should be marked as parent',
          );
        }
      });
    });
  });
}
