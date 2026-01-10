import 'package:basir_app/features/accounting/domain/entities/financial_year.dart';

/// Repository interface for fiscal year lifecycle and period management.
///
/// Responsible for coordinating fiscal start/end boundaries and locking
/// finalized accounting periods.
abstract class FinancialYearRepository {
  /// Retrieves the currently active and open fiscal year.
  Future<FinancialYear?> getCurrentFinancialYear();

  /// Identifies the fiscal year associated with a specific transaction date.
  Future<FinancialYear?> getFinancialYearByDate(DateTime date);

  /// Retrieves a collection of all historical and future fiscal years.
  Future<List<FinancialYear>> getAllFinancialYears();

  /// Commits a financial year configuration to persistent storage.
  Future<void> saveFinancialYear(FinancialYear year);

  /// Executes the regulatory closing procedure for a fiscal year.
  Future<void> closeFinancialYear(String id, String userId);

  /// Diagnostic check to verify if a specific date allows for data posting.
  ///
  /// Returns `true` if the date falls within an open year and an unlocked period.
  Future<bool> isPeriodOpen(DateTime date);
}
