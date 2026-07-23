import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'credit_control_service.g.dart';

class CreditCheckResult {
  const CreditCheckResult({
    required this.isWithinLimit,
    required this.currentBalance,
    required this.creditLimit,
    required this.availableCredit,
    required this.requestedAmount,
    this.warningMessage,
  });

  final bool isWithinLimit;
  final Decimal currentBalance;
  final Decimal creditLimit;
  final Decimal availableCredit;
  final Decimal requestedAmount;
  final String? warningMessage;

  Decimal get overLimitAmount =>
      isWithinLimit ? Decimal.zero : requestedAmount - availableCredit;

  double get utilizationPercentage => creditLimit > Decimal.zero
      ? (currentBalance.toDouble() / creditLimit.toDouble() * 100)
      : 0.0;

  bool get isHighUtilization => utilizationPercentage > 90;
}

class CreditBreach {
  const CreditBreach({
    required this.customer,
    required this.overLimitAmount,
    required this.daysOverLimit,
    required this.breachDate,
  });

  final Customer customer;
  final Decimal overLimitAmount;
  final int daysOverLimit;
  final DateTime breachDate;

  CreditBreachSeverity get severity {
    if (overLimitAmount > Decimal.parse('50000')) {
      return CreditBreachSeverity.critical;
    } else if (overLimitAmount > Decimal.parse('20000')) {
      return CreditBreachSeverity.high;
    } else if (overLimitAmount > Decimal.parse('5000')) {
      return CreditBreachSeverity.medium;
    }
    return CreditBreachSeverity.low;
  }
}

enum CreditBreachSeverity { low, medium, high, critical }

@riverpod
class CreditControlService extends _$CreditControlService {
  @override
  FutureOr<void> build() {}

  Future<CreditCheckResult> checkCreditLimit({
    required String customerId,
    required Decimal newInvoiceAmount,
  }) async {
    final customerRepo = ref.read(customerRepositoryProvider);
    final accountingRepo = ref.read(accountingRepositoryProvider);

    final customer = await customerRepo.getCustomerById(customerId);
    if (customer == null) {
      throw Exception('Customer not found: $customerId');
    }

    final currentBalance = await _calculateCustomerBalance(
      customer: customer,
      accountingRepo: accountingRepo,
    );

    final creditLimit = Decimal.parse(customer.creditLimit.toString());
    final availableCredit = creditLimit - currentBalance;
    final projectedBalance = currentBalance + newInvoiceAmount;

    final isWithinLimit = projectedBalance <= creditLimit;

    String? warningMessage;
    if (!isWithinLimit) {
      warningMessage =
          'Credit limit exceeded by ${projectedBalance - creditLimit} SAR';
    } else if ((availableCredit - newInvoiceAmount).toDouble() <
        (creditLimit.toDouble() * 0.20)) {
      warningMessage = 'Warning: Credit utilization will exceed 80%';
    }

    return CreditCheckResult(
      isWithinLimit: isWithinLimit,
      currentBalance: currentBalance,
      creditLimit: creditLimit,
      availableCredit: availableCredit,
      requestedAmount: newInvoiceAmount,
      warningMessage: warningMessage,
    );
  }

  Future<double> calculateCreditUtilization(String customerId) async {
    final customerRepo = ref.read(customerRepositoryProvider);
    final accountingRepo = ref.read(accountingRepositoryProvider);

    final customer = await customerRepo.getCustomerById(customerId);
    if (customer == null) {
      throw Exception('Customer not found: $customerId');
    }

    final currentBalance = await _calculateCustomerBalance(
      customer: customer,
      accountingRepo: accountingRepo,
    );

    final creditLimit = Decimal.parse(customer.creditLimit.toString());
    if (creditLimit <= Decimal.zero) {
      return 0.0;
    }

    return currentBalance.toDouble() / creditLimit.toDouble() * 100;
  }

  Future<List<CreditBreach>> getCreditBreaches() async {
    final customerRepo = ref.read(customerRepositoryProvider);
    final accountingRepo = ref.read(accountingRepositoryProvider);

    final customers = await customerRepo.getAllCustomers();
    final breaches = <CreditBreach>[];
    final now = DateTime.now();

    for (final customer in customers) {
      final creditLimit = Decimal.parse(customer.creditLimit.toString());
      if (creditLimit <= Decimal.zero) continue;

      final currentBalance = await _calculateCustomerBalance(
        customer: customer,
        accountingRepo: accountingRepo,
      );

      if (currentBalance > creditLimit) {
        final overLimitAmount = currentBalance - creditLimit;
        const daysOverLimit = 30;

        breaches.add(
          CreditBreach(
            customer: customer,
            overLimitAmount: overLimitAmount,
            daysOverLimit: daysOverLimit,
            breachDate: now.subtract(const Duration(days: daysOverLimit)),
          ),
        );
      }
    }

    breaches.sort((a, b) => b.overLimitAmount.compareTo(a.overLimitAmount));

    return breaches;
  }

  Future<Decimal> suggestCreditLimit(String customerId) async {
    final customerRepo = ref.read(customerRepositoryProvider);
    final accountingRepo = ref.read(accountingRepositoryProvider);

    final customer = await customerRepo.getCustomerById(customerId);
    if (customer == null) {
      throw Exception('Customer not found: $customerId');
    }

    final entries = await accountingRepo.getJournalEntries();
    final arAccountId = customer.receivableAccountId ?? 'acc-1201';

    var totalSales = Decimal.zero;
    var monthsActive = 0;
    final monthlySales = <int, Decimal>{};

    for (final entry in entries) {
      if (entry.status != JournalEntryStatus.posted) continue;
      if (entry.sourceDocument != 'sales_invoice') continue;

      for (final line in entry.lines) {
        if (line.accountId == arAccountId && line.debit > Decimal.zero) {
          totalSales += line.debit;
          final monthKey = <credential-fixture> * 100 + entry.date.month;
          monthlySales[monthKey] =
              (monthlySales[monthKey] ?? Decimal.zero) + line.debit;
        }
      }
    }

    monthsActive = monthlySales.length;

    if (monthsActive == 0) {
      return Decimal.parse('5000');
    }

    final avgMonthlySalesDouble = totalSales.toDouble() / monthsActive;
    final suggestedLimit =
        Decimal.parse((avgMonthlySalesDouble * 1.5).toString());

    final minLimit = Decimal.parse('5000');
    final maxLimit = Decimal.parse('500000');
    if (suggestedLimit < minLimit) {
      return minLimit;
    } else if (suggestedLimit > maxLimit) {
      return maxLimit;
    }
    return suggestedLimit;
  }

  Future<List<Customer>> getCustomersApproachingLimit() async {
    final customerRepo = ref.read(customerRepositoryProvider);

    final customers = await customerRepo.getAllCustomers();
    final approachingLimit = <Customer>[];

    for (final customer in customers) {
      final utilization = await calculateCreditUtilization(customer.id);
      if (utilization >= 80 && utilization < 100) {
        approachingLimit.add(customer);
      }
    }

    return approachingLimit;
  }

  Future<Decimal> _calculateCustomerBalance({
    required Customer customer,
    required AccountingRepository accountingRepo,
  }) async {
    final entries = await accountingRepo.getJournalEntries();
    final arAccountId = customer.receivableAccountId ?? 'acc-1201';

    var balance = Decimal.zero;

    for (final entry in entries) {
      if (entry.status != JournalEntryStatus.posted) continue;

      for (final line in entry.lines) {
        if (line.accountId == arAccountId) {
          balance += line.debit - line.credit;
        }
      }
    }

    return balance;
  }
}
