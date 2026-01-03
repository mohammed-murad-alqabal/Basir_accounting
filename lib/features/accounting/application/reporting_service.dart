import 'package:basir_app/features/accounting/application/accounting_service.dart';
import 'package:basir_app/features/accounting/domain/entities/account.dart';
import 'package:basir_app/features/accounting/domain/entities/ifrs18_ontology.dart';
import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reporting_service.g.dart';

/// صف يمثل بيانات حساب في ميزان المراجعة
class TrialBalanceRow {
  /// إنشاء صف ميزان مراجعة جديد.
  const TrialBalanceRow({
    required this.accountId,
    required this.accountCode,
    required this.accountName,
    required this.debit,
    required this.credit,
  });

  /// معرف الحساب الفريد.
  final String accountId;

  /// كود الحساب.
  final String accountCode;

  /// اسم الحساب.
  final String accountName;

  /// الرصيد المدين.
  final Decimal debit;

  /// الرصيد الدائن.
  final Decimal credit;
}

/// خدمة التقارير المالية (Reporting Service)
@riverpod
class ReportingService extends _$ReportingService {
  @override
  void build() {}

  /// توليد ميزان المراجعة (Trial Balance)
  Future<List<TrialBalanceRow>> getTrialBalance() async {
    final accountingService = ref.read(accountingServiceProvider.notifier);
    final accounts = await accountingService.getAccounts();

    final rows = <TrialBalanceRow>[];

    for (final account in accounts) {
      // نحسب الرصيد الهيكلي (يشمل الحسابات الفرعية)
      final balance =
          await accountingService.getHierarchicalBalance(account.id);

      if (balance != Decimal.zero) {
        // إذا كان الحساب مدين بطبيعته
        if (account.nature == AccountNature.debit) {
          rows.add(
            TrialBalanceRow(
              accountId: account.id,
              accountCode: account.code,
              accountName: account.nameAr,
              debit: balance > Decimal.zero ? balance : Decimal.zero,
              credit: balance < Decimal.zero ? -balance : Decimal.zero,
            ),
          );
        } else {
          // إذا كان دائن
          rows.add(
            TrialBalanceRow(
              accountId: account.id,
              accountCode: account.code,
              accountName: account.nameAr,
              debit: balance < Decimal.zero ? -balance : Decimal.zero,
              credit: balance > Decimal.zero ? balance : Decimal.zero,
            ),
          );
        }
      }
    }

    return rows;
  }

  /// توليد قائمة الدخل (Income Statement / P&L) - متوافقة مع IFRS 18
  Future<Map<Ifrs18Category, Decimal>> getIncomeStatement() async {
    final accountingService = ref.read(accountingServiceProvider.notifier);
    final accounts = await accountingService.getAccounts();

    final result = <Ifrs18Category, Decimal>{
      Ifrs18Category.operating: Decimal.zero,
      Ifrs18Category.investing: Decimal.zero,
      Ifrs18Category.financing: Decimal.zero,
      Ifrs18Category.incomeTax: Decimal.zero,
    };

    for (final account in accounts) {
      // فقط حسابات الإيرادات والمصروفات
      if (account.type == AccountType.revenue ||
          account.type == AccountType.expense) {
        // الحصول على الفئة من الحساب (مستقبلاً نحتاج إضافة هذا الحقل للحساب)
        // حالياً سنفترض Operating كافتراضي إلا إذا كان هناك منطق آخر
        final category = _detectIfrs18Category(account);

        final balance =
            await accountingService.getHierarchicalBalance(account.id);

        // في قائمة الدخل: الإيرادات (دائنة) موجبة، والمصروفات (مدينة) سالبة
        if (account.type == AccountType.revenue) {
          result[category] = (result[category] ?? Decimal.zero) + balance;
        } else {
          result[category] = (result[category] ?? Decimal.zero) - balance;
        }
      }
    }

    return result;
  }

  /// توليد الميزانية العمومية (Balance Sheet)
  Future<Map<String, Decimal>> getBalanceSheet() async {
    final accountingService = ref.read(accountingServiceProvider.notifier);
    final accounts = await accountingService.getAccounts();

    var assets = Decimal.zero;
    var liabilities = Decimal.zero;
    var equity = Decimal.zero;

    for (final account in accounts) {
      // فقط الحسابات الرئيسية (المستوى 0)
      // لتجنب التكرار عند جمع الأرصدة الهيكلية
      if (account.parentId == null) {
        final balance =
            await accountingService.getHierarchicalBalance(account.id);

        switch (account.type) {
          case AccountType.asset:
            assets += balance;
          case AccountType.liability:
            liabilities += balance;
          case AccountType.equity:
            equity += balance;
          case AccountType.revenue:
          case AccountType.expense:
            // لا تدرج في الميزانية مباشرة
            break;
        }
      }
    }

    return {
      'assets': assets,
      'liabilities': liabilities,
      'equity': equity,
    };
  }

  /// توليد قائمة التدفقات النقدية (Cash Flow Statement) - الطريقة المباشرة
  Future<Map<String, Decimal>> getCashFlowStatement() async {
    final accountingService = ref.read(accountingServiceProvider.notifier);
    final entries = await accountingService.getJournalEntries();

    var operatingReceipts = Decimal.zero;
    var operatingPayments = Decimal.zero;
    var investingFlow = Decimal.zero;
    var financingFlow = Decimal.zero;

    for (final entry in entries) {
      if (entry.status == JournalEntryStatus.posted) {
        for (final line in entry.lines) {
          // إذا كان السطر يمس حساب "نقدية" أو "بنك"
          if (await _isCashAccount(line.accountId)) {
            final amount = line.debit - line.credit;

            // نحدد نوع التدفق بناءً على الحسابات المقابلة في نفس القيد
            // للتبسيط: نأخذ الحساب المقابل الأول
            final otherLines = entry.lines
                .where((l) => l.accountId != line.accountId)
                .toList();

            if (otherLines.isNotEmpty) {
              final category =
                  await _detectCashFlowCategory(otherLines.first.accountId);
              switch (category) {
                case 'operating':
                  if (amount > Decimal.zero) {
                    operatingReceipts += amount;
                  } else {
                    operatingPayments += -amount;
                  }
                case 'investing':
                  investingFlow += amount;
                case 'financing':
                  financingFlow += amount;
              }
            }
          }
        }
      }
    }

    return {
      'operatingReceipts': operatingReceipts,
      'operatingPayments': operatingPayments,
      'netOperating': operatingReceipts - operatingPayments,
      'investing': investingFlow,
      'financing': financingFlow,
      'netChange':
          operatingReceipts - operatingPayments + investingFlow + financingFlow,
    };
  }

  /// الحصول على مؤشرات الأداء المالي (FR-ACC-015)
  Future<Map<String, double>> getFinancialHealthIndicators() async {
    final balanceSheet = await getBalanceSheet();
    final incomeStatement = await getIncomeStatement();

    final assets = balanceSheet['assets'] ?? Decimal.zero;
    final liabilities = balanceSheet['liabilities'] ?? Decimal.zero;

    // 1. نسبة السيولة (Liquidity Ratio)
    // حالياً نستخدم إجمالي الأصول/الالتزامات كتقريب حتى نفصل التداول
    final liquidity =
        liabilities != Decimal.zero ? (assets / liabilities).toDouble() : 0.0;

    // 2. الربحية (Profitability / Net Margin)
    final revenue = incomeStatement.entries
        .where((e) => e.key == Ifrs18Category.operating)
        .fold(Decimal.zero, (prev, curr) => prev + curr.value);

    final netIncome =
        incomeStatement.values.fold(Decimal.zero, (prev, curr) => prev + curr);

    final profitability =
        revenue != Decimal.zero ? (netIncome / revenue).toDouble() : 0.0;

    return {
      'liquidity': liquidity,
      'profitability': profitability,
      'operating_margin': profitability, // تقريب حالياً
    };
  }

  Ifrs18Category _detectIfrs18Category(Account account) {
    // منطق تقريبي لتحديد الفئة بناءً على الاسم أو الكود
    if (account.nameEn.toLowerCase().contains('tax')) {
      return Ifrs18Category.incomeTax;
    }
    if (account.code.startsWith('44')) {
      return Ifrs18Category.investing; // أملاك/استثمارات
    }
    if (account.code.startsWith('55')) {
      return Ifrs18Category.financing; // فوائد تمويلية
    }

    return Ifrs18Category.operating;
  }

  Future<bool> _isCashAccount(String accountId) async {
    final accountingService = ref.read(accountingServiceProvider.notifier);
    final account = await accountingService.getAccountById(accountId);
    if (account == null) return false;

    // حسابات النقدية والبنك عادة تبدأ بـ 11 في نظامنا
    return account.code.startsWith('11') ||
        account.nameEn.toLowerCase().contains('cash') ||
        account.nameEn.toLowerCase().contains('bank');
  }

  Future<String> _detectCashFlowCategory(String accountId) async {
    final accountingService = ref.read(accountingServiceProvider.notifier);
    final account = await accountingService.getAccountById(accountId);
    if (account == null) return 'operating';

    // الأصول الثابتة -> استثماري
    if (account.code.startsWith('12') && account.type == AccountType.asset) {
      return 'investing';
    }
    // القروض وحقوق الملكية -> تمويلي
    if (account.type == AccountType.equity || account.code.startsWith('22')) {
      return 'financing';
    }

    return 'operating';
  }
}
