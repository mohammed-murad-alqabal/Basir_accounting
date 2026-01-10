import 'package:basir_app/core/providers.dart';
import 'package:basir_app/features/accounting/domain/entities/financial_year.dart';
import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_app/features/accounting/domain/repositories/financial_year_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
  Future<void> lockMonthlyPeriod(String yearId, int month, int year) async {
    final fy = await _repository.getAllFinancialYears();
    final targetYear = fy.firstWhere((y) => y.id == yearId);

    final periodId = '$year-${month.toString().padLeft(2, '0')}';
    if (targetYear.lockedPeriodIds.contains(periodId)) return;

    final updatedYear = targetYear.copyWith(
      lockedPeriodIds: [...targetYear.lockedPeriodIds, periodId],
    );

    await _repository.saveFinancialYear(updatedYear);
  }

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
        'Cannot close year: ${pendingDrafts.length} unposted draft entries detected.',
      );
    }

    await _repository.closeFinancialYear(yearId, userId);
  }
}
