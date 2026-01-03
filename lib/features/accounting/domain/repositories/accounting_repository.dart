import 'package:basir_app/features/accounting/domain/entities/account.dart';
import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
import 'package:decimal/decimal.dart';

/// واجهة مستودع النظام المحاسبي
/// (FR-ACC-008: مسار التدقيق الشامل)
abstract class AccountingRepository {
  /// جلب جميع الحسابات
  Future<List<Account>> getAccounts();

  /// جلب حساب بواسطة المعرف
  Future<Account?> getAccountById(String id);

  /// إضافة حساب جديد
  Future<void> addAccount(Account account);

  /// تحديث حساب موجود
  Future<void> updateAccount(Account account);

  /// جلب جميع القيود
  Future<List<JournalEntry>> getJournalEntries();

  /// إضافة قيد جديد (يجب أن يكون متزناً)
  Future<void> addJournalEntry(JournalEntry entry);

  /// جلب رصيد حساب معين
  Future<Decimal> getAccountBalance(String accountId);
}
