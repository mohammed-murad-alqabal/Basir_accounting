import 'package:basir_app/core/providers.dart';
import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accounts_receivable_service.g.dart';

/// بيانات تعمير ديون العميل (Customer Aging Data)
/// تحتوي على تفاصيل الديون المستحقة على العميل مقسمة حسب الفترات الزمنية.
class CustomerAging {
  /// إنشاء بيانات تعمير ديون العميل.
  CustomerAging({
    required this.customerId,
    required this.customerName,
    required this.current,
    required this.period1_30,
    required this.period31_60,
    required this.period61_90,
    required this.periodOver90,
    required this.totalBalance,
  });

  /// معرف العميل.
  final String customerId;

  /// اسم العميل.
  final String customerName;

  /// الديون الحالية (لم تستحق بعد).
  final Decimal current;

  /// الديون المتأخرة من 1 إلى 30 يوم.
  final Decimal period1_30;

  /// الديون المتأخرة من 31 إلى 60 يوم.
  final Decimal period31_60;

  /// الديون المتأخرة من 61 إلى 90 يوم.
  final Decimal period61_90;

  /// الديون المتأخرة لأكثر من 90 يوم.
  final Decimal periodOver90;

  /// إجمالي رصيد الديون المستحقة على العميل.
  final Decimal totalBalance;
}

/// خدمة حسابات العملاء (Accounts Receivable Service)
/// تدير عمليات الفوترة والتحصيل والديون المستحقة.
@riverpod
class AccountsReceivableService extends _$AccountsReceivableService {
  @override
  FutureOr<void> build() {}

  /// الحصول على رصيد عميل محدد
  Future<Decimal> getCustomerBalance(String customerId) async {
    final repository = ref.read(accountingRepositoryProvider);
    final customerRepo = ref.read(customerRepositoryProvider);

    final customer = await customerRepo.getCustomerById(customerId);
    final targetAccountId = customer?.receivableAccountId ?? 'acc-1201';

    final entries = await repository.getJournalEntries();

    var balance = Decimal.zero;
    for (final entry in entries) {
      for (final line in entry.lines) {
        if (line.accountId == targetAccountId ||
            (targetAccountId == 'acc-1201' &&
                line.accountName.contains(customerId))) {
          balance += line.debit - line.credit;
        }
      }
    }
    return balance;
  }

  /// تقرير تعمير الديون بالتفصيل لكل عميل (Detailed Aging Report)
  Future<List<CustomerAging>> getReceivablesAging() async {
    final accountingRepo = ref.read(accountingRepositoryProvider);
    final customerRepo = ref.read(customerRepositoryProvider);

    final customers = await customerRepo.getAllCustomers();
    final entries = await accountingRepo.getJournalEntries();
    final now = DateTime.now();

    final result = <CustomerAging>[];

    for (final customer in customers) {
      final targetAccountId = customer.receivableAccountId ?? 'acc-1201';

      var current = Decimal.zero;
      var p1 = Decimal.zero;
      var p2 = Decimal.zero;
      var p3 = Decimal.zero;
      var pOver = Decimal.zero;

      for (final entry in entries) {
        if (entry.status == JournalEntryStatus.posted) {
          for (final line in entry.lines) {
            if (line.accountId == targetAccountId) {
              final balance = line.debit - line.credit;
              if (balance != Decimal.zero) {
                final diff = now.difference(entry.date).inDays;
                if (diff <= 0) {
                  current += balance;
                } else if (diff <= 30) {
                  p1 += balance;
                } else if (diff <= 60) {
                  p2 += balance;
                } else if (diff <= 90) {
                  p3 += balance;
                } else {
                  pOver += balance;
                }
              }
            }
          }
        }
      }

      final total = current + p1 + p2 + p3 + pOver;
      if (total != Decimal.zero) {
        result.add(
          CustomerAging(
            customerId: customer.id,
            customerName: customer.name,
            current: current,
            period1_30: p1,
            period31_60: p2,
            period61_90: p3,
            periodOver90: pOver,
            totalBalance: total,
          ),
        );
      }
    }

    return result;
  }

  /// كشف حساب عميل (Detailed Ledger)
  Future<List<JournalEntry>> getCustomerLedger(String customerId) async {
    final repository = ref.read(accountingRepositoryProvider);
    final customerRepo = ref.read(customerRepositoryProvider);

    final customer = await customerRepo.getCustomerById(customerId);
    final targetAccountId = customer?.receivableAccountId ?? 'acc-1201';

    final entries = await repository.getJournalEntries();

    return entries
        .where(
          (e) => e.lines.any(
            (l) =>
                l.accountId == targetAccountId ||
                (targetAccountId == 'acc-1201' &&
                    l.accountName.contains(customerId)),
          ),
        )
        .toList();
  }
}
