import 'dart:math';

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/application/financial_year_service.dart';
import 'package:basir_accounting_system/features/accounting/application/multi_standard_coa_engine.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'simulation_service.g.dart';

/// ***
/// Cognitive Foundation: FinancialSimulationService
///
/// High-fidelity financial simulation engine for institutional stress testing
/// and demonstration.
///
/// Uses [Decimal] for all financial calculations to ensure precision during
/// simulated institutional audits.
/// ***
@riverpod
class FinancialSimulationService extends _$FinancialSimulationService {
  @override
  void build() {}

  /// Seeds high-fidelity institutional data into the system.
  Future<void> seedRealisticData() async {
    final accountingService = ref.read(accountingServiceProvider.notifier);
    final fyService = ref.read(financialYearServiceProvider.notifier);
    final customerRepo = ref.read(customerRepositoryProvider);
    const uuid = Uuid();

    // 1. Initialize Financial Year and COA
    await fyService.initializeDefaultYear();
    await accountingService.seedDefaultAccounts(
      country: AccountingCountry.saudiArabia,
    );

    // 2. Add synthetic customers
    final customerIds = <String>[];
    final names = [
      'شركة الأفق للتقنية',
      'مؤسسة النماء التجارية',
      'مجموعة الاستثمار العربية',
    ];
    for (var i = 0; i < names.length; i++) {
      final id = uuid.v4();
      await customerRepo.addCustomer(
        Customer(
          id: id,
          nameAr: names[i],
          nameEn: 'Customer ${i + 1}',
          email: 'info@customer$i.com',
          phone: '96650000000$i',
          address: 'الرياض، المملكة العربية السعودية',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      customerIds.add(id);
    }

    // 3. Generate transactions over the last 60 days
    final now = DateTime.now();
    final random = Random();

    for (var i = 60; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));

      // 40% probability of a sales invoice
      if (random.nextDouble() < 0.4) {
        final rawAmount = 1000 + random.nextInt(5000);
        final amount = Decimal.fromInt(rawAmount);
        final tax = amount * Decimal.parse('0.15');
        final total = amount + tax;

        final invoice = Invoice(
          id: uuid.v4(),
          invoiceNumber: 'SIM-INV-${1000 + i}',
          customerId: customerIds[random.nextInt(customerIds.length)],
          customerName: names[random.nextInt(names.length)],
          issuedDate: date,
          dueDate: date.add(const Duration(days: 30)),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          subtotalAmount: amount,
          taxAmount: tax,
          discountAmount: Decimal.zero,
          discountRate: Decimal.zero,
          totalAmount: total,
          paidAmount: Decimal.zero,
          taxRate: Decimal.parse('0.15'),
          status: InvoiceStatus.sent,
          items: [
            InvoiceItem(
              id: uuid.v4(),
              name: 'خدمات استشارية تقنية',
              description: 'خدمات استشارية تقنية',
              quantity: Decimal.one,
              price: amount,
              total: amount,
              taxAmount: tax,
              taxRate: Decimal.parse('0.15'),
            ),
          ],
          zatcaUuid: uuid.v4(),
          zatcaHash: _generateMockHash(uuid.v4()),
        );

        await accountingService.postSalesInvoice(
          invoice,
          bypassCognitive: true,
        );
      }

      // 30% probability of a direct expense
      if (random.nextDouble() < 0.3) {
        final expenseAmount = 200 + random.nextInt(1000);
        await _postDirectExpense(
          date,
          Decimal.fromInt(expenseAmount),
          'مصاريف تشغيلية دورية',
        );
      }
    }
  }

  Future<void> _postDirectExpense(
    DateTime date,
    Decimal amount,
    String description,
  ) async {
    final accountingService = ref.read(accountingServiceProvider.notifier);
    final accounts = await accountingService.getAccounts();

    // Identify expense and cash accounts
    final expenseAccount = accounts.firstWhere(
      (a) => a.type == AccountType.expense,
    );
    final assetAccount = accounts.firstWhere((a) => a.subType == 'cash');

    final entry = JournalEntry(
      id: const Uuid().v4(),
      referenceNumber: 'EXP-${date.millisecondsSinceEpoch}',
      date: date,
      temporal: TemporalJustification(
        transactionDate: date,
        effectiveDate: date,
        recordingDate: DateTime.now(),
      ),
      standards: const StandardsJustification(
        standardReference: 'IFRS',
        recognitionBasis: 'Accrual',
      ),
      description: description,
      status: JournalEntryStatus.posted,
      sourceDocument: 'manual_expense',
      sourceId: 'sim-${date.toIso8601String()}',
      createdBy: 'simulation-engine',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      lines: [
        JournalEntryLine(
          accountId: expenseAccount.id,
          accountName: expenseAccount.nameAr,
          debit: amount,
          credit: Decimal.zero,
          description: description,
        ),
        JournalEntryLine(
          accountId: assetAccount.id,
          accountName: assetAccount.nameAr,
          credit: amount,
          debit: Decimal.zero,
          description: 'صرف من ${assetAccount.nameAr}',
        ),
      ],
    );

    await accountingService.postJournalEntry(entry, bypassCognitive: true);
  }

  String _generateMockHash(String input) =>
      'Base64Hash==${input.substring(0, 8)}';
}
