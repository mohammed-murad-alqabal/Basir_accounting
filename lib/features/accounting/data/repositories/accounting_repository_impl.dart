// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/data/models/account_model.dart';
import 'package:basir_accounting_system/features/accounting/data/models/financial_year_model.dart';
import 'package:basir_accounting_system/features/accounting/data/models/journal_entry_model.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accounting_repository_impl.g.dart';

/// تنفيذ مستودع المحاسبة باستخدام Isar.
/// (FR-ACC-007: تخزين مؤقت للبيانات لسرعة الوصول)
class IsarAccountingRepository implements AccountingRepository {
  /// إنشاء نسخة جديدة مع تمرير مثيل Isar ومعرف المستخدم.
  IsarAccountingRepository({
    required this.isar,
    required this.userId,
    this.warehouseId,
  });

  /// مثيل قاعدة بيانات Isar.
  final Isar isar;

  /// معرف المستخدم الحالي لعزل البيانات.
  final String? userId;

  /// معرف المستودع الحالي (لعزل البيانات).
  final String? warehouseId;

  @override
  Future<List<Account>> getAccounts() async {
    final query = isar.accountModels.filter().userIdEqualTo(userId);
    final models = await query.findAll();
    return models.map((m) => m.toEntity()).toList();
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
    await isar.writeTxn(() async {
      await isar.accountModels.put(model);
    });
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
    if (existing != null) {
      model.isarId = existing.isarId;
    }
    await isar.writeTxn(() async {
      await isar.accountModels.put(model);
    });
  }

  @override
  Future<List<JournalEntry>> getJournalEntries() async {
    final models = await isar.journalEntryModels
        .filter()
        .userIdEqualTo(userId)
        .and()
        .group(
          (q) => q.warehouseIdIsNull().or().warehouseIdEqualTo(warehouseId),
        )
        .sortByDateDesc()
        .findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addJournalEntry(JournalEntry entry) async {
    if (!entry.isBalanced) {
      throw ArgumentError('Journal entry must be balanced before persistence.');
    }
    if (entry.lines.length < 2) {
      throw ArgumentError('Journal entry must contain at least two lines.');
    }

    // A posted entry is immutable. Only an existing draft may be replaced,
    // and it must retain its Isar identifier so account movements cannot be
    // applied a second time.
    final existing = await isar.journalEntryModels
        .filter()
        .idEqualTo(entry.id)
        .and()
        .userIdEqualTo(userId)
        .findFirst();
    if (existing != null) {
      final isDraftTransition = existing.status == JournalEntryStatus.draft &&
          (entry.status == JournalEntryStatus.draft ||
              entry.status == JournalEntryStatus.posted);
      if (!isDraftTransition) {
        throw StateError(
          'Existing journal entries are immutable; create a reversal instead.',
        );
      }
    }

    // 1. التحقق من السنة المالية والفترة المغلقة (FR-ACC-016)
    final fy = await isar.financialYearModels
        .filter()
        .userIdEqualTo(userId)
        .and()
        .startDateLessThan(entry.date, include: true)
        .and()
        .endDateGreaterThan(entry.date, include: true)
        .findFirst();

    if (fy == null) {
      throw Exception('No financial year defined for the date: ${entry.date}');
    }
    if (fy.isClosed) {
      throw Exception('Cannot post to a closed financial year: ${fy.name}');
    }

    final periodId = '${entry.date.year}-'
        '${entry.date.month.toString().padLeft(2, '0')}';
    if (fy.lockedPeriodIds.contains(periodId)) {
      throw Exception('Financial period $periodId is locked');
    }

    final model = JournalEntryModel.fromEntity(
      entry.copyWith(
        userId: userId,
        warehouseId: entry.warehouseId ?? warehouseId,
      ),
    );
    if (existing != null) {
      model.isarId = existing.isarId;
    }

    await isar.writeTxn(() async {
      // 1. حفظ القيد
      await isar.journalEntryModels.put(model);

      // 2. تحديث أرصدة الحسابات المتأثرة
      // (FR-ACC-002: ضمان توازن المعادلة)
      if (entry.status == JournalEntryStatus.posted) {
        for (final line in entry.lines) {
          final accountModel = await isar.accountModels
              .filter()
              .idEqualTo(line.accountId)
              .and()
              .userIdEqualTo(userId)
              .findFirst();

          if (accountModel != null) {
            final account = accountModel.toEntity();
            var movement = Decimal.zero;
            if (account.nature == AccountNature.debit) {
              movement = line.debit - line.credit;
            } else {
              movement = line.credit - line.debit;
            }

            final updatedBalance = account.balance + movement;
            accountModel.balance = updatedBalance.toString();
            await isar.accountModels.put(accountModel);
          }
        }
      }
    });
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

/// مزود مستودع المحاسبة (Accounting Repository Provider).
@Riverpod(keepAlive: true)
AccountingRepository accountingRepository(AccountingRepositoryRef ref) {
  // ملاحظة: يتم تمرير مثيل Isar عبر المزود العالمي
  final isar = ref.watch(isarProvider).value;
  if (isar == null) throw Exception('Isar is not initialized');

  // جلب معرف المستخدم الحالي للعزل
  final user = ref.watch(basirUserProvider);
  final warehouseId = user?.warehouseId;

  return IsarAccountingRepository(
    isar: isar,
    userId: user?.id,
    warehouseId: warehouseId,
  );
}
