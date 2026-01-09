import 'dart:math';

import 'package:basir_app/core/providers.dart';
import 'package:basir_app/features/accounting/application/accounting_service.dart';
import 'package:basir_app/features/accounting/application/financial_year_service.dart';
import 'package:basir_app/features/accounting/application/multi_standard_coa_engine.dart';
import 'package:basir_app/features/accounting/domain/entities/account.dart';
import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_app/features/customers/domain/entities/customer.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice_status.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'simulation_service.g.dart';

/// خدمة محاكاة البيانات المالية (Financial Simulation Service)
///
/// تقوم بتوليد بيانات مالية واقعية لأغراض العرض والتجربة.
@riverpod
class FinancialSimulationService extends _$FinancialSimulationService {
  @override
  void build() {}

  /// بذر بيانات عالية الدقة (High-Fidelity) في النظام.
  Future<void> seedRealisticData() async {
    final accountingService = ref.read(accountingServiceProvider.notifier);
    final fyService = ref.read(financialYearServiceProvider.notifier);
    final customerRepo = ref.read(customerRepositoryProvider);
    const uuid = Uuid();

    // 1. تهيئة السنة المالية ودليل الحسابات
    await fyService.initializeDefaultYear();
    await accountingService.seedDefaultAccounts(
      country: AccountingCountry.saudiArabia,
    );

    // 2. إضافة عملاء وهميين
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

    // 3. توليد عمليات مالية عبر الـ 60 يوماً الماضية
    final now = DateTime.now();
    final random = Random();

    for (var i = 60; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));

      // احتمال 40% لوجود فاتورة مبيعات في هذا اليوم
      if (random.nextDouble() < 0.4) {
        final amount = 1000.0 + random.nextInt(5000);
        final tax = amount * 0.15;
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
          discountAmount: 0.0,
          totalAmount: total,
          paidAmount: 0.0,
          taxRate: 15.0,
          status: InvoiceStatus.sent,
          items: [
            InvoiceItem(
              id: uuid.v4(),
              name: 'خدمات استشارية تقنية',
              description: 'خدمات استشارية تقنية',
              quantity: 1,
              price: amount,
              total: amount,
            ),
          ],
        );

        await accountingService.postSalesInvoice(invoice);
      }

      // احتمال 30% لوجود مصروف في هذا اليوم
      if (random.nextDouble() < 0.3) {
        final expenseAmount = 200.0 + random.nextInt(1000);
        await _postDirectExpense(date, expenseAmount, 'مصاريف تشغيلية دورية');
      }
    }
  }

  Future<void> _postDirectExpense(
    DateTime date,
    double amount,
    String description,
  ) async {
    final accountingService = ref.read(accountingServiceProvider.notifier);
    final accounts = await accountingService.getAccounts();

    // البحث عن حساب مصاريف وحساب نقدية
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
          debit: Decimal.parse(amount.toString()),
          credit: Decimal.zero,
          description: description,
        ),
        JournalEntryLine(
          accountId: assetAccount.id,
          accountName: assetAccount.nameAr,
          credit: Decimal.parse(amount.toString()),
          debit: Decimal.zero,
          description: 'صرف من ${assetAccount.nameAr}',
        ),
      ],
    );

    await accountingService.postJournalEntry(entry);
  }
}
