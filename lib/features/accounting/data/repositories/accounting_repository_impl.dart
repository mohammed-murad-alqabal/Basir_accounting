import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/services/ledger_authority_policy.dart';
import 'package:basir_accounting_system/features/accounting/data/models/account_model.dart';
import 'package:basir_accounting_system/features/accounting/data/models/journal_entry_model.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accounting_repository_impl.g.dart';

/// Isar-backed local cache for accounts and journal-entry drafts.
///
/// Postgres is the sole authority for `Posted` ledger facts and balances. Isar
/// may cache a posted entry only after the authoritative receipt has been
/// attached by [cacheAuthoritativeJournalEntry].
class IsarAccountingRepository implements AccountingRepository {
  IsarAccountingRepository({
    required this.isar,
    required this.userId,
    this.warehouseId,
  });

  final Isar isar;
  final String? userId;
  final String? warehouseId;

  @override
  Future<List<Account>> getAccounts() async {
    final query = isar.accountModels.filter().userIdEqualTo(userId);
    final models = await query.findAll();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Account?> getAccountById(String id) async {
    final model = await isar.accountModels
        .filter()
        .idEqualTo(id)
        .and()
        .userIdEqualTo(userId)
        .findFirst();
    return model?.toEntity();
  }

  @override
  Future<void> addAccount(Account account) async {
    final model = AccountModel.fromEntity(account.copyWith(userId: userId));
    await isar.writeTxn(() => isar.accountModels.put(model));
  }

  @override
  Future<void> updateAccount(Account account) async {
    final model = AccountModel.fromEntity(account.copyWith(userId: userId));
    final existing = await isar.accountModels
        .filter()
        .idEqualTo(account.id)
        .and()
        .userIdEqualTo(userId)
        .findFirst();
    if (existing != null) model.isarId = existing.isarId;
    await isar.writeTxn(() => isar.accountModels.put(model));
  }

  @override
  Future<List<JournalEntry>> getJournalEntries() async {
    final models = await isar.journalEntryModels
        .filter()
        .userIdEqualTo(userId)
        .and()
        .group(
          (query) =>
              query.warehouseIdIsNull().or().warehouseIdEqualTo(warehouseId),
        )
        .sortByDateDesc()
        .findAll();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addJournalEntry(JournalEntry entry) async {
    LedgerAuthorityPolicy.assertLocalWriteAllowed(entry);
    await _upsertLocal(
      entry.copyWith(
        userId: userId,
        warehouseId: entry.warehouseId ?? warehouseId,
      ),
    );
  }

  @override
  Future<void> cacheAuthoritativeJournalEntry(JournalEntry entry) async {
    LedgerAuthorityPolicy.assertAuthoritativeCache(entry);
    await _upsertLocal(
      entry.copyWith(
        userId: userId,
        warehouseId: entry.warehouseId ?? warehouseId,
      ),
    );
  }

  Future<void> _upsertLocal(JournalEntry entry) async {
    final model = JournalEntryModel.fromEntity(entry);
    final existing = await isar.journalEntryModels
        .filter()
        .idEqualTo(entry.id)
        .and()
        .userIdEqualTo(userId)
        .findFirst();
    if (existing != null) model.isarId = existing.isarId;
    await isar.writeTxn(() => isar.journalEntryModels.put(model));
  }

  @override
  Future<Decimal> getAccountBalance(String accountId) async {
    final model = await isar.accountModels
        .filter()
        .idEqualTo(accountId)
        .and()
        .userIdEqualTo(userId)
        .findFirst();
    if (model == null) return Decimal.zero;
    return Decimal.parse(model.balance);
  }
}

@Riverpod(keepAlive: true)
AccountingRepository accountingRepository(AccountingRepositoryRef ref) {
  final isar = ref.watch(isarProvider).value;
  if (isar == null) throw Exception('Isar is not initialized');
  final user = ref.watch(basirUserProvider);
  return IsarAccountingRepository(
    isar: isar,
    userId: user?.id,
    warehouseId: user?.warehouseId,
  );
}
