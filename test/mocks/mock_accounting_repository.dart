import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:decimal/decimal.dart';

/// Mock Accounting Repository - محاكاة لمستودع المحاسبة
class MockAccountingRepository implements AccountingRepository {
  final List<Account> _accounts = [];
  final List<JournalEntry> _journalEntries = [];

  /// للوصول المباشر للحسابات في الاختبارات
  List<Account> get accounts => List.from(_accounts);

  /// للوصول المباشر للقيود في الاختبارات
  List<JournalEntry> get journalEntries => List.from(_journalEntries);

  /// تعيين قائمة الحسابات للاختبارات
  void setAccounts(List<Account> accounts) {
    _accounts.clear();
    _accounts.addAll(accounts);
  }

  /// تعيين قائمة القيود للاختبارات
  void setJournalEntries(List<JournalEntry> entries) {
    _journalEntries.clear();
    _journalEntries.addAll(entries);
  }

  /// تفعيل/تعطيل رمي الأخطاء للاختبارات
  bool shouldThrowError = false;

  @override
  Future<List<Account>> getAccounts() async {
    if (shouldThrowError) throw Exception('Test error');
    return List.from(_accounts);
  }

  @override
  Future<Account?> getAccountById(String id) async {
    try {
      return _accounts.firstWhere((a) => a.id == id);
    } on Object {
      return null;
    }
  }

  @override
  Future<void> addAccount(Account account) async {
    if (shouldThrowError) throw Exception('Test error');
    _accounts.add(account);
  }

  @override
  Future<void> updateAccount(Account account) async {
    if (shouldThrowError) throw Exception('Test error');
    final index = _accounts.indexWhere((a) => a.id == account.id);
    if (index != -1) {
      _accounts[index] = account;
    }
  }

  @override
  Future<List<JournalEntry>> getJournalEntries() async {
    if (shouldThrowError) throw Exception('Test error');
    return List.from(_journalEntries);
  }

  @override
  Future<void> addJournalEntry(JournalEntry entry) async {
    if (shouldThrowError) throw Exception('Test error');
    _journalEntries.add(entry);
  }

  @override
  Future<void> cacheAuthoritativeJournalEntry(JournalEntry entry) async {
    if (shouldThrowError) throw Exception('Test error');
    _journalEntries.removeWhere((current) => current.id == entry.id);
    _journalEntries.add(entry);
  }

  @override
  Future<Decimal> getAccountBalance(String accountId) async {
    if (shouldThrowError) throw Exception('Test error');
    final account = await getAccountById(accountId);
    return account?.balance ?? Decimal.zero;
  }
}
