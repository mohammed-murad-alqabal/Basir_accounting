import 'package:basir_app/core/providers.dart';
import 'package:basir_app/features/accounting/data/repositories/accounting_repository_impl.dart';
import 'package:basir_app/features/accounting/domain/entities/account.dart';
import 'package:basir_app/features/accounting/domain/entities/ifrs18_ontology.dart';
import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'financial_reporting_service.g.dart';

/// نموذج تقرير ميزان المراجعة لحساب معين
class AccountBalanceReport {
  /// إنشاء تقرير رصيد الحساب
  AccountBalanceReport({
    required this.account,
    required this.debit,
    required this.credit,
    required this.balance,
  });

  /// الحساب المتأثر
  final Account account;

  /// إجمالي الحركات المدينة
  final double debit;

  /// إجمالي الحركات الدائنة
  final double credit;

  /// الرصيد النهائي للمرحلة
  final double balance;
}

/// خدمة التقارير المالية (Financial Reporting Service)
/// توفر وظائف لتوليد القوائم المالية الأساسية.
@riverpod
class FinancialReportingService extends _$FinancialReportingService {
  @override
  FutureOr<void> build() {}

  /// توليد ميزان المراجعة (Trial Balance)
  Future<List<AccountBalanceReport>> getTrialBalance() async {
    final repository = ref.watch(accountingRepositoryProvider);
    final accounts = await repository.getAccounts();
    final entries = await repository.getJournalEntries();

    final report = <AccountBalanceReport>[];

    for (final account in accounts) {
      double totalDebit = 0;
      double totalCredit = 0;

      for (final entry in entries) {
        if (entry.status == JournalEntryStatus.posted) {
          for (final line in entry.lines) {
            if (line.accountId == account.id) {
              totalDebit += line.debit.toDouble();
              totalCredit += line.credit.toDouble();
            }
          }
        }
      }

      report.add(
        AccountBalanceReport(
          account: account,
          debit: totalDebit,
          credit: totalCredit,
          balance: account.balance.toDouble(),
        ),
      );
    }

    return report;
  }

  /// توليد قائمة الدخل المتوافقة مع IFRS 18
  /// (تصنيف العمليات إلى: Operating, Investing, Financing)
  Future<Map<Ifrs18Category, double>> getIfrs18IncomeStatement() async {
    final repository = ref.watch(accountingRepositoryProvider);
    final accounts = await repository.getAccounts();

    final categoryBalances = <Ifrs18Category, double>{};

    // تهيئة التصنيفات
    for (final category in Ifrs18Category.values) {
      categoryBalances[category] = 0.0;
    }

    for (final account in accounts) {
      if (account.ifrs18Category != null) {
        final balance = account.balance.toDouble();
        // في قائمة الدخل: الإيرادات (دائن) موجبة، المصروفات (مدين) سالبة
        final sign = account.nature == AccountNature.credit ? 1 : -1;
        categoryBalances[account.ifrs18Category!] =
            (categoryBalances[account.ifrs18Category!] ?? 0.0) +
                (balance * sign);
      }
    }

    return categoryBalances;
  }

  /// توليد قائمة الدخل التقليدية (Income Statement / P&L)
  Future<Map<String, dynamic>> getIncomeStatement({
    DateTime? from,
    DateTime? to,
  }) async {
    final repository = ref.watch(accountingRepositoryProvider);
    final accounts = await repository.getAccounts();

    double totalRevenue = 0;
    double totalExpenses = 0;

    final revenueDetails = <String, double>{};
    final expenseDetails = <String, double>{};

    for (final account in accounts) {
      final balance = account.balance.toDouble();
      if (account.type == AccountType.revenue) {
        totalRevenue += balance;
        revenueDetails[account.nameAr] = balance;
      } else if (account.type == AccountType.expense) {
        totalExpenses += balance;
        expenseDetails[account.nameAr] = balance;
      }
    }

    return {
      'totalRevenue': totalRevenue,
      'totalExpenses': totalExpenses,
      'netIncome': totalRevenue - totalExpenses,
      'revenueDetails': revenueDetails,
      'expenseDetails': expenseDetails,
    };
  }

  /// الحصول على اتجاه الإيرادات الشهري لآخر 12 شهرًا (Revenue Trend)
  Future<Map<DateTime, double>> getRevenueTrend() async {
    final repository = ref.read(accountingRepositoryProvider);
    final entries = await repository.getJournalEntries();
    final accounts = await repository.getAccounts();

    // خريطة لتحديد نوع الحساب بسرعة
    final accountMap = {for (final a in accounts) a.id: a.type};

    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month - 11);

    final monthlyRevenue = <DateTime, double>{};

    // تهيئة الأشهر الـ 12 الماضية بقيمة صفر
    for (var i = 0; i < 12; i++) {
      // نستخدم 0 كبداية اليوم لتوحيد المفاتيح
      final date = DateTime(now.year, now.month - i);
      monthlyRevenue[date] = 0.0;
    }

    for (final entry in entries) {
      if (entry.status == JournalEntryStatus.posted &&
          entry.date.isAfter(startDate.subtract(const Duration(days: 1)))) {
        // توحيد التاريخ إلى بداية الشهر
        final entryMonth = DateTime(entry.date.year, entry.date.month);

        // إذا كان الشهر ضمن النطاق
        // ملاحظة: نستخدم loops للمفاتيح لضمان التطابق
        // إذا كان هناك اختلاف في التوقيت
        // لكن DateTime() بالمصنع الافتراضي يستخدم Local time
        final matchingKey = <credential-fixture>(
          (k) => k.year == entryMonth.year && k.month == entryMonth.month,
          orElse: () => DateTime(0),
        );

        if (matchingKey.year != 0) {
          for (final line in entry.lines) {
            if (accountMap[line.accountId] == AccountType.revenue) {
              // الإيرادات دائنة (Credit)
              // الزيادة في الدائن تعني زيادة في الإيراد
              // الرصيد = الدائن - المدين
              final amount = line.credit.toDouble() - line.debit.toDouble();
              monthlyRevenue[matchingKey] =
                  (monthlyRevenue[matchingKey] ?? 0.0) + amount;
            }
          }
        }
      }
    }

    return monthlyRevenue;
  }

  /// الحصول على توزيع المصروفات حسب التصنيف الفرعي (Expense Composition)
  Future<Map<String, double>> getExpenseComposition() async {
    final repository = ref.read(accountingRepositoryProvider);
    final accounts = await repository.getAccounts();

    final composition = <String, double>{};

    for (final account in accounts) {
      if (account.type == AccountType.expense) {
        // نستخدم subType إذا وجد، وإلا "مصروفات أخرى"
        final category = account.subType;
        // المصروفات مدينة (Debit)، الرصيد عادة موجب
        composition[category] =
            (composition[category] ?? 0.0) + account.balance.toDouble();
      }
    }

    return composition;
  }
}
