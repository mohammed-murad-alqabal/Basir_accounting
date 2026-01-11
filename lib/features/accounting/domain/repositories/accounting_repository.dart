import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:decimal/decimal.dart';

/// Central repository interface for the general ledger and chart of accounts.
/// (Standard Reference: FR-ACC-008: Comprehensive Audit Trail)
abstract class AccountingRepository {
  /// Retrieves the complete list of accounts in the COA.
  Future<List<Account>> getAccounts();

  /// Retrieves a specific account entity by its unique ID.
  Future<Account?> getAccountById(String id);

  /// Persists a new account entity into the system.
  Future<void> addAccount(Account account);

  /// Updates an existing account's metadata or status.
  Future<void> updateAccount(Account account);

  /// Retrieves the chronological history of all journal entries.
  Future<List<JournalEntry>> getJournalEntries();

  /// Persists a new, balanced journal entry into the ledger.
  /// Implementations must enforce mathematical balance before commitment.
  Future<void> addJournalEntry(JournalEntry entry);

  /// Computes the net balance for a specific account.
  /// Usually aggregates debit minus credit totals (or vice versa based on\n  /// nature).
  Future<Decimal> getAccountBalance(String accountId);
}
