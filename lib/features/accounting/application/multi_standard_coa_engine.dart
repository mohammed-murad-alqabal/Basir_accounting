import 'package:basir_app/features/accounting/domain/entities/account.dart';
import 'package:basir_app/features/accounting/domain/entities/ifrs18_ontology.dart';
import 'package:decimal/decimal.dart';

/// الدول المدعومة في دليل الحسابات.
enum AccountingCountry {
  /// المعايير العالمية (IFRS)
  global,

  /// المملكة العربية السعودية (ZATCA compliant)
  saudiArabia,

  /// دولة الإمارات العربية المتحدة (FTA compliant)
  uae,

  /// جمهورية مصر العربية (نظام محاسبي موحد)
  egypt,
}

/// محرك توليد دليل الحسابات متعدد المعايير.
class MultiStandardCoaEngine {
  /// توليد شجرة الحسابات بناءً على الدولة المحددة
  static List<Account> generateCoa(AccountingCountry country) {
    switch (country) {
      case AccountingCountry.saudiArabia:
        return _generateSaudiCoa();
      case AccountingCountry.uae:
        return _generateUaeCoa();
      case AccountingCountry.egypt:
        return _generateEgyptCoa();
      case AccountingCountry.global:
        return _generateGlobalIfrsCoa();
    }
  }

  /// توليد شجرة الحسابات الافتراضية للمعايير العالمية (IFRS).
  static List<Account> _generateGlobalIfrsCoa() => [
        _createAccount(
          id: 'acc-1',
          code: '1',
          nameAr: 'الأصول',
          nameEn: 'Assets',
          type: AccountType.asset,
          nature: AccountNature.debit,
          isParent: true,
        ),
        _createAccount(
          id: 'acc-11',
          code: '11',
          nameAr: 'الأصول المتداولة',
          nameEn: 'Current Assets',
          type: AccountType.asset,
          nature: AccountNature.debit,
          parentId: 'acc-1',
          isParent: true,
        ),
        _createAccount(
          id: 'acc-1101',
          code: '1101',
          nameAr: 'النقد وما يماثله',
          nameEn: 'Cash and Cash Equivalents',
          type: AccountType.asset,
          nature: AccountNature.debit,
          parentId: 'acc-11',
          subType: 'cash',
        ),
        _createAccount(
          id: 'acc-1201',
          code: '1201',
          nameAr: 'العملاء',
          nameEn: 'Accounts Receivable',
          type: AccountType.asset,
          nature: AccountNature.debit,
          parentId: 'acc-11',
          subType: 'ar',
        ),
        _createAccount(
          id: 'acc-2',
          code: '2',
          nameAr: 'الالتزامات',
          nameEn: 'Liabilities',
          type: AccountType.liability,
          nature: AccountNature.credit,
          isParent: true,
        ),
        _createAccount(
          id: 'acc-2101',
          code: '2101',
          nameAr: 'الموردون / الحسابات الدائنة',
          nameEn: 'Accounts Payable',
          type: AccountType.liability,
          nature: AccountNature.credit,
          parentId: 'acc-2',
          subType: 'ap',
        ),
        _createAccount(
          id: 'acc-2105',
          code: '2105',
          nameAr: 'ضريبة القيمة المضافة المستحقة',
          nameEn: 'VAT Payable',
          type: AccountType.liability,
          nature: AccountNature.credit,
          parentId: 'acc-2',
        ),
        _createAccount(
          id: 'acc-3',
          code: '3',
          nameAr: 'حقوق الملكية',
          nameEn: 'Equity',
          type: AccountType.equity,
          nature: AccountNature.credit,
          isParent: true,
        ),
        _createAccount(
          id: 'acc-4',
          code: '4',
          nameAr: 'الإيرادات',
          nameEn: 'Revenue',
          type: AccountType.revenue,
          nature: AccountNature.credit,
          isParent: true,
          ifrs18Category: Ifrs18Category.operating,
        ),
        _createAccount(
          id: 'acc-4101',
          code: '4101',
          nameAr: 'إيرادات المبيعات',
          nameEn: 'Sales Revenue',
          type: AccountType.revenue,
          nature: AccountNature.credit,
          parentId: 'acc-4',
          subType: 'revenue',
          ifrs18Category: Ifrs18Category.operating,
        ),
        _createAccount(
          id: 'acc-5',
          code: '5',
          nameAr: 'المصروفات',
          nameEn: 'Expenses',
          type: AccountType.expense,
          nature: AccountNature.debit,
          isParent: true,
          ifrs18Category: Ifrs18Category.operating,
        ),
      ];

  /// توليد شجرة الحسابات وفقاً للمعايير السعودية (ZATCA compliant).
  static List<Account> _generateSaudiCoa() {
    final base = _generateGlobalIfrsCoa();
    return [
      ...base,
      _createAccount(
        id: 'acc-2105-sa',
        code: '2105',
        nameAr: 'ضريبة القيمة المضافة المستحقة (ZATCA)',
        nameEn: 'ZATCA VAT Payable',
        type: AccountType.liability,
        nature: AccountNature.credit,
        parentId: 'acc-2',
      ),
    ];
  }

  /// توليد شجرة الحسابات وفقاً لمعايير دولة الإمارات (FTA compliant).
  static List<Account> _generateUaeCoa() {
    final base = _generateGlobalIfrsCoa();
    return [
      ...base,
      _createAccount(
        id: 'acc-2105-uae',
        code: '2105',
        nameAr: 'ضريبة القيمة المضافة (FTA)',
        nameEn: 'FTA VAT Payable',
        type: AccountType.liability,
        nature: AccountNature.credit,
        parentId: 'acc-2',
      ),
    ];
  }

  /// توليد شجرة الحسابات وفقاً للنظام المحاسبي المصري الموحد.
  static List<Account> _generateEgyptCoa() => [
        _createAccount(
          id: 'eg-1',
          code: '1',
          nameAr: 'الأصول الطويلة الأجل',
          nameEn: 'Long-term Assets',
          type: AccountType.asset,
          nature: AccountNature.debit,
          isParent: true,
        ),
        _createAccount(
          id: 'eg-2',
          code: '2',
          nameAr: 'الأصول المتداولة',
          nameEn: 'Current Assets',
          type: AccountType.asset,
          nature: AccountNature.debit,
          isParent: true,
        ),
        // المزيد من التفاصيل حسب النظام المحاسبي المصري الموحد
      ];

  /// دالة مساعدة لإنشاء كائن حساب جديد.
  static Account _createAccount({
    required String id,
    required String code,
    required String nameAr,
    required String nameEn,
    required AccountType type,
    required AccountNature nature,
    bool isParent = false,
    String? parentId,
    String subType = '',
    Ifrs18Category? ifrs18Category,
  }) =>
      Account(
        id: id,
        code: code,
        nameAr: nameAr,
        nameEn: nameEn,
        type: type,
        nature: nature,
        balance: Decimal.zero,
        isParent: isParent,
        parentId: parentId,
        subType: subType,
        isSystem: true,
        ifrs18Category: ifrs18Category,
      );
}
