// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_year.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/financial_year_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'financial_year_service.g.dart';

/// Financial Year Service managing fiscal periods and posting permissions.
///
/// Implements period-end closing procedures, monthly lockdowns, and
/// validation logic to ensure temporal integrity of financial data.
@Riverpod(keepAlive: true)
class FinancialYearService extends _$FinancialYearService {
  @override
  FutureOr<void> build() {}

  FinancialYearRepository get _repository => ref.read(financialYearRepositoryProvider);

  /// Initializes the default financial year if none exists in the system.
  /// (Implementation of FR-ACC-015)
  ///
  /// Creates a standard Jan-Dec fiscal year for the current Gregorian year.
  Future<void> initializeDefaultYear() async {
    final existingYears = await _repository.getAllFinancialYears();
    if (existingYears.isNotEmpty) return;

    final now = DateTime.now();
    final startDate = DateTime(now.year);
    final endDate = DateTime(now.year, 12, 31);

    final defaultYear = FinancialYear(
      id: 'fy-${now.year}',
      name: 'Fiscal Year ${now.year}',
      startDate: startDate,
      endDate: endDate,
    );

    await _repository.saveFinancialYear(defaultYear);
  }

  /// Verifies if a transaction can be posted to a specific date.
  ///
  /// ## Checks performed:
  /// 1. **Existence**: Date must fall within an defined [FinancialYear].
  /// 2. **Year Status**: The target year must not be marked as Closed.
  /// 3. **Period Lockdown**: The specific month must not be locked centrally.
  Future<bool> canPostToDate(DateTime date) async {
    final year = await _repository.getFinancialYearByDate(date);
    if (year == null) return false;
    if (year.isClosed) return false;

    // Check for monthly period lockdowns
    final periodId = '${date.year}-${date.month.toString().padLeft(2, '0')}';
    if (year.lockedPeriodIds.contains(periodId)) return false;

    return true;
  }

  /// Locks a specific monthly period within a financial year.
  ///
  /// Prevents any further modifications or postings to the specified month.
  Future<void> lockMonthlyPeriod(String yearId, DateTime date) async {
    final fy = await _repository.getAllFinancialYears();
    final targetYear = fy.firstWhere((y) => y.id == yearId);

    final periodId = _getPeriodId(date);
    if (targetYear.lockedPeriodIds.contains(periodId)) return;

    final updatedYear = targetYear.copyWith(
      lockedPeriodIds: [...targetYear.lockedPeriodIds, periodId],
    );

    await _repository.saveFinancialYear(updatedYear);
  }

  /// Unlocks a specific monthly period within a financial year.
  Future<void> unlockMonthlyPeriod(String yearId, DateTime date) async {
    final fy = await _repository.getAllFinancialYears();
    final targetYear = fy.firstWhere((y) => y.id == yearId);

    final periodId = _getPeriodId(date);
    if (!targetYear.lockedPeriodIds.contains(periodId)) return;

    final updatedYear = targetYear.copyWith(
      lockedPeriodIds: targetYear.lockedPeriodIds.where((id) => id != periodId).toList(),
    );

    await _repository.saveFinancialYear(updatedYear);
  }

  /// Retrieves the list of locked periods for a given year.
  Future<List<String>> getLockedPeriods(String yearId) async {
    final fy = await _repository.getAllFinancialYears();
    final targetYear = fy.firstWhere((y) => y.id == yearId);
    return targetYear.lockedPeriodIds;
  }

  /// Executes a year-end rollover procedure.
  ///
  /// 1. Verifies the next year exists.
  /// 2. Calculates closing balances of all leaf accounts.
  /// 3. Closes Nominal accounts (P&L) into Retained Earnings.
  /// 4. Creates a balanced Opening Entry in the next fiscal year.
  Future<void> rolloverBalances(String currentYearId, String nextYearId) async {
    final user = ref.read(basirUserProvider);
    if (user == null) throw Exception('User not authenticated.');

    final fy = await _repository.getAllFinancialYears();
    final currentYear = fy.firstWhere((y) => y.id == currentYearId);
    final nextYear = fy.firstWhere((y) => y.id == nextYearId);

    if (currentYear.isClosed) {
      throw Exception('Current year is already closed.');
    }

    final accountingRepo = ref.read(accountingRepositoryProvider);
    final allAccounts = await accountingRepo.getAccounts();
    final leafAccounts = allAccounts.where((a) => !a.isParent).toList();

    final openingLines = <JournalEntryLine>[];
    var netIncome = Decimal.zero;

    // 1. Process all accounts for balance rollover
    for (final account in leafAccounts) {
      final balance = await accountingRepo.getAccountBalance(account.id);

      if (account.type == AccountType.revenue || account.type == AccountType.expense) {
        // P&L accounts: aggregate into Net Income
        // Revenue (Credit nature) - Expense (Debit nature)
        if (account.type == AccountType.revenue) {
          netIncome += balance;
        } else {
          netIncome -= balance;
        }
      } else {
        // Balance Sheet accounts: carry forward
        if (balance == Decimal.zero) continue;

        openingLines.add(
          JournalEntryLine(
            accountId: account.id,
            accountName: account.nameEn,
            debit: account.nature == AccountNature.debit ? balance : Decimal.zero,
            credit: account.nature == AccountNature.credit ? balance : Decimal.zero,
            description: 'Opening Balance: Fiscal Year ${nextYear.startDate.year}',
          ),
        );
      }
    }

    // 2. Identify Retained Earnings account
    final reAccount = allAccounts.firstWhere(
      (a) => a.subType == 'retained_earnings' || a.id == 'acc-3101',
      orElse: () => throw Exception('Retained Earnings account not found.'),
    );

    // 3. Add Net Income to Retained Earnings in the opening entry
    if (netIncome != Decimal.zero) {
      openingLines.add(
        JournalEntryLine(
          accountId: reAccount.id,
          accountName: reAccount.nameEn,
          debit: netIncome < Decimal.zero ? netIncome.abs() : Decimal.zero,
          credit: netIncome > Decimal.zero ? netIncome : Decimal.zero,
          description: 'Net Income Rollover from ${currentYear.name}',
        ),
      );
    }

    // 4. Create and post the Opening Entry
    final openingEntry = JournalEntry(
      id: const Uuid().v4(),
      referenceNumber: 'OB-${nextYear.startDate.year}-001',
      date: nextYear.startDate,
      temporal: TemporalJustification(
        transactionDate: nextYear.startDate,
        effectiveDate: nextYear.startDate,
        recordingDate: DateTime.now(),
      ),
      standards: const StandardsJustification(
        standardReference: 'IAS 1: Financial Statement Presentation',
        recognitionBasis: 'Opening Balances',
      ),
      description: 'Opening Balance Rollover from Year ${currentYear.startDate.year}',
      status: JournalEntryStatus.posted,
      lines: openingLines,
      sourceDocument: 'YEAR_END_ROLLOVER',
      sourceId: currentYearId,
      createdBy: user.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      postedAt: DateTime.now(),
      userId: user.id,
    );

    if (!openingEntry.isBalanced) {
      throw Exception(
        'Critical Error: Opening entry is unbalanced. Diff: ${openingEntry.totalDebit - openingEntry.totalCredit}',
      );
    }

    await accountingRepo.addJournalEntry(openingEntry);

    // 5. Finally, close the current year
    await closeYear(currentYearId, user.id);
  }

  String _getPeriodId(DateTime date) => '${date.year}-${date.month.toString().padLeft(2, '0')}';

  /// Permanently closes a financial year after performing integrity checks.
  ///
  /// ## Pre-conditions
  /// - All [JournalEntry] items in the year must be either Posted or Deleted.
  /// - No active [JournalEntryStatus.draft] items allowed.
  ///
  /// ## Parameters
  /// - [yearId]: Target fiscal year to close.
  /// - [userId]: Auditor/User performing the closing operation.
  ///
  /// ## Throws
  /// - [Exception] if unposted drafts are detected in the fiscal period.
  Future<void> closeYear(String yearId, String userId) async {
    final fy = await _repository.getAllFinancialYears();
    final targetYear = fy.firstWhere((y) => y.id == yearId);

    // Verify no pending drafts exist for the period
    final accountingRepo = ref.read(accountingRepositoryProvider);
    final entries = await accountingRepo.getJournalEntries();

    final pendingDrafts = entries.where(
      (e) => e.status == JournalEntryStatus.draft && targetYear.containsDate(e.date),
    );

    if (pendingDrafts.isNotEmpty) {
      throw Exception(
        'Cannot close year: ${pendingDrafts.length} unposted draft entries '
        'detected.',
      );
    }

    await _repository.closeFinancialYear(yearId, userId);
  }
}
