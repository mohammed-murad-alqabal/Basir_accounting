import 'package:basir_app/core/providers.dart';
import 'package:basir_app/features/accounting/application/financial_year_service.dart';
import 'package:basir_app/features/accounting/application/multi_standard_coa_engine.dart';
import 'package:basir_app/features/accounting/domain/entities/account.dart';
import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_app/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:basir_app/features/customers/domain/repositories/customer_repository.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice_status.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'accounting_service.g.dart';

/// الخدمة المحاسبية المركزية (Accounting Service)
/// تدير دليل الحسابات (Chart of Accounts) والعمليات المحاسبية الأساسية.
@Riverpod(keepAlive: true)
class AccountingService extends _$AccountingService {
  // TEST_MARKER
  AccountingRepository get _repository =>
      ref.read(accountingRepositoryProvider);

  FinancialYearService get _financialYearService =>
      ref.read(financialYearServiceProvider.notifier);
  CustomerRepository get _customerRepository =>
      ref.read(customerRepositoryProvider);

  @override
  FutureOr<List<JournalEntry>> build() => _repository.getJournalEntries();

  /// اختيار دليل الحسابات المناسب وبذره في النظام (FR-ACC-009)
  /// يدعم معايير دول متعددة (IFRS, Saudi Arabia, UAE, Egypt)
  Future<void> seedDefaultAccounts({
    AccountingCountry country = AccountingCountry.global,
  }) async {
    // التحقق من وجود حسابات مسبقاً لتجنب التكرار
    final existingAccounts = await _repository.getAccounts();
    if (existingAccounts.isNotEmpty) return;

    final accounts = MultiStandardCoaEngine.generateCoa(country);

    // استخدام إضافة جماعية إذا كان المستودع يدعمها (مستقبلاً)
    // حالياً نقوم بإضافتها بشكل متكرر ولكن في عملية واحدة إذا لزم الأمر
    for (final account in accounts) {
      await addAccount(account);
    }
  }

  /// إضافة حساب جديد مع التحقق من الهيكلية (FR-ACC-014)
  Future<void> addAccount(Account account) async {
    // 1. التحقق من وجود الحساب الأب
    if (account.parentId != null) {
      final parent = await _repository.getAccountById(account.parentId!);
      if (parent == null) {
        throw Exception('Parent account not found: ${account.parentId}');
      }

      // 2. التحقق من تطابق النوع والطبيعة
      if (parent.type != account.type) {
        throw Exception(
          'Account type (${account.type}) must match '
          'parent type (${parent.type})',
        );
      }
      if (parent.nature != account.nature) {
        throw Exception(
          'Account nature (${account.nature}) must match '
          'parent nature (${parent.nature})',
        );
      }
    }

    await _repository.addAccount(account);
  }

  /// ترحيل فاتورة مبيعات (نظام القيد المزدوج)
  /// (FR-ACC-001)
  ///
  /// القيد المتولد:
  /// - من ح/ العملاء (إجمالي الفاتورة)
  ///     - إلى ح/ المبيعات (المبلغ قبل الضريبة)
  ///     - إلى ح/ ضريبة القيمة المضافة (مبلغ الضريبة)
  Future<void> postSalesInvoice(Invoice invoice) async {
    // 0. التحقق من السنة المالية (FR-ACC-010)
    final isPeriodOpen = await _financialYearService.canPostToDate(
      invoice.issuedDate,
    );
    if (!isPeriodOpen) {
      throw Exception('Cannot post to a closed or undefined financial period');
    }

    // 1. التحقق من حالة الفاتورة
    if (invoice.status != InvoiceStatus.sent &&
        invoice.status != InvoiceStatus.paid &&
        invoice.status != InvoiceStatus.overdue) {
      throw Exception('Can only post issued, paid, or overdue invoices');
    }

    // 2. إنشاء بنود القيد
    final lines = <JournalEntryLine>[];

    // الطرف المدين: العملاء (Debit)
    // الحصول على حساب العميل المخصص إذا وجد (Sub-ledger)
    var receivableAccountId = 'acc-1201'; // Default AR
    final customer =
        await _customerRepository.getCustomerById(invoice.customerId);
    if (customer != null && customer.receivableAccountId != null) {
      receivableAccountId = customer.receivableAccountId!;
    }

    lines.add(
      JournalEntryLine(
        accountId: receivableAccountId,
        accountName: 'العملاء - ${invoice.customerName}',
        description: 'فاتورة مبيعات رقم ${invoice.invoiceNumber}',
        debit: Decimal.parse(invoice.totalAmount.toString()),
        credit: Decimal.zero,
        originalCurrency: invoice.currency != 'SAR' ? invoice.currency : null,
        originalAmount: invoice.currency != 'SAR'
            ? Decimal.parse(invoice.totalAmount.toString())
            : null,
        exchangeRate: invoice.currency != 'SAR' ? Decimal.one : null,
      ),
    );

    // الطرف الدائن 1: المبيعات (Credit)
    final allAccounts = await _repository.getAccounts();
    final revenueAccount = allAccounts.firstWhere(
      (a) => a.code == '4101' || a.subType == 'revenue',
      orElse: () => allAccounts.firstWhere(
        (a) => a.type == AccountType.revenue,
      ),
    );

    final revenueLine = JournalEntryLine(
      accountId: revenueAccount.id,
      credit: Decimal.parse(invoice.subtotalAmount.toString()),
      debit: Decimal.zero,
      accountName: revenueAccount.nameAr,
      description: 'إيراد فاتورة ${invoice.invoiceNumber}',
      originalCurrency: invoice.currency != 'SAR' ? invoice.currency : null,
      originalAmount: invoice.currency != 'SAR'
          ? Decimal.parse(invoice.subtotalAmount.toString())
          : null,
      exchangeRate: invoice.currency != 'SAR' ? Decimal.one : null,
    );
    lines.add(revenueLine);

    // الطرف الدائن 2: الضريبة (Credit)
    if (invoice.taxAmount > 0) {
      final taxAccount = allAccounts.firstWhere(
        (a) => a.code == '2105' || a.nameEn.contains('VAT'),
        orElse: () => Account(
          id: 'acc-2105',
          code: '2105',
          nameAr: 'الضريبة',
          nameEn: 'Tax',
          type: AccountType.liability,
          nature: AccountNature.credit,
          balance: Decimal.zero,
        ),
      );

      lines.add(
        JournalEntryLine(
          accountId: taxAccount.id,
          accountName: taxAccount.nameAr,
          description: 'ضريبة فاتورة ${invoice.invoiceNumber}',
          credit: Decimal.parse(invoice.taxAmount.toString()),
          debit: Decimal.zero,
          originalCurrency: invoice.currency != 'SAR' ? invoice.currency : null,
          originalAmount: invoice.currency != 'SAR'
              ? Decimal.parse(invoice.taxAmount.toString())
              : null,
          exchangeRate: invoice.currency != 'SAR' ? Decimal.one : null,
        ),
      );
    }

    // 3. إنشاء القيد
    final journalEntryId = 'je-inv-${invoice.id}';
    final now = DateTime.now();
    final user = ref.read(basirUserProvider);

    final existingEntries = await _repository.getJournalEntries();
    if (existingEntries.any((e) => e.id == journalEntryId)) {
      return;
    }

    final entry = JournalEntry(
      id: journalEntryId,
      referenceNumber: 'JE-${invoice.id}',
      date: invoice.issuedDate,
      temporal: TemporalJustification(
        transactionDate: invoice.issuedDate,
        effectiveDate: invoice.issuedDate,
        recordingDate: now,
      ),
      standards: const StandardsJustification(
        standardReference: 'IFRS 15', // GAAP: Revenue from Contracts
        recognitionBasis: 'Accrual',
        measurementBasis: 'Transaction Price',
      ),
      description: 'ترحيل فاتورة مبيعات ${invoice.id}',
      status: JournalEntryStatus.posted,
      lines: lines,
      sourceDocument: 'invoice',
      sourceId: invoice.id,
      createdAt: now,
      createdBy: user?.id ?? 'system',
      updatedAt: now,
      postedAt: now,
    );

    // 4. التحقق والحفظ
    if (!entry.isBalanced) {
      throw Exception(
        'Journal Entry is unbalanced! Diff: '
        '${entry.totalDebit - entry.totalCredit}',
      );
    }

    await _repository.addJournalEntry(entry);
    ref.invalidateSelf();
  }

  /// الحصول على الرصيد الهيكلي للحساب (يشمل أرصدة الحسابات الفرعية).
  /// (FR-ACC-013: تجميع الأرصدة في دليل الحسابات الشجري)
  Future<Decimal> getHierarchicalBalance(String accountId) async {
    final allAccounts = await _repository.getAccounts();
    return _calculateRecursiveBalance(accountId, allAccounts);
  }

  Decimal _calculateRecursiveBalance(
    String accountId,
    List<Account> allAccounts,
  ) {
    final account = allAccounts.firstWhere(
      (a) => a.id == accountId,
    );
    var total = account.balance;

    final children = allAccounts.where((a) => a.parentId == accountId);
    for (final child in children) {
      total += _calculateRecursiveBalance(child.id, allAccounts);
    }

    return total;
  }

  /// الحصول على جميع الحسابات
  Future<List<Account>> getAccounts() async => _repository.getAccounts();

  /// الحصول على حساب بمقدار المعرف
  Future<Account?> getAccountById(String id) async =>
      _repository.getAccountById(id);

  /// الحصول على كافة القيود المحاسبية
  Future<List<JournalEntry>> getJournalEntries() async =>
      _repository.getJournalEntries();

  /// ترحيل قيد محاسبي يدوي
  Future<void> postJournalEntry(JournalEntry entry) async {
    // 1. التحقق من التوازن
    if (!entry.isBalanced) {
      throw Exception('Journal entry is unbalanced');
    }

    // 2. التحقق من التاريخ (السنة المالية)
    final isPeriodOpen = await _financialYearService.canPostToDate(entry.date);
    if (!isPeriodOpen) {
      throw Exception('Financial period is closed or locked');
    }

    // 3. الحفظ
    await _repository.addJournalEntry(entry);
    ref.invalidateSelf();
  }

  /// عكس قيد محاسبي (Reversal/Contra-entry)
  /// (FR-ACC-011)
  Future<void> reverseJournalEntry(String entryId) async {
    final entries = await _repository.getJournalEntries();
    final original = entries.firstWhere((e) => e.id == entryId);

    if (original.status != JournalEntryStatus.posted) {
      throw Exception('Can only reverse posted entries');
    }

    final now = DateTime.now();
    final user = ref.read(basirUserProvider);

    final reversal = JournalEntry(
      id: const Uuid().v4(),
      referenceNumber: 'RV-${original.referenceNumber}',
      date: now,
      temporal: TemporalJustification(
        transactionDate: now,
        effectiveDate: now,
        recordingDate: now,
      ),
      standards: StandardsJustification(
        standardReference: original.standards.standardReference,
        recognitionBasis: 'Reversal',
        measurementBasis: original.standards.measurementBasis,
      ),
      description: 'عكس القيد رقم ${original.referenceNumber}',
      status: JournalEntryStatus.posted,
      sourceDocument: original.sourceDocument,
      sourceId: original.sourceId,
      createdBy: user?.id ?? 'user',
      createdAt: now,
      updatedAt: now,
      postedAt: now,
      lines: original.lines
          .map(
            (l) => JournalEntryLine(
              accountId: l.accountId,
              accountName: l.accountName,
              debit: l.credit, // SWAP
              credit: l.debit, // SWAP
              description: 'عكس: ${l.description ?? ""}',
              sourceDocumentRef: l.sourceDocumentRef,
              originalCurrency: l.originalCurrency,
              exchangeRate: l.exchangeRate,
              originalAmount: l.originalAmount,
            ),
          )
          .toList(),
    );

    await postJournalEntry(reversal);
  }
}
