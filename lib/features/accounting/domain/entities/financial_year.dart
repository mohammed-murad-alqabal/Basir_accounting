import 'package:basir_app/core/models/sync_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'financial_year.freezed.dart';
part 'financial_year.g.dart';

/// Represents a Fiscal Year cycle and its constituent accounting periods.
///
/// Encapsulates the start, end, and closing state of the primary financial\n/// reporting cycle.
@freezed
class FinancialYear with _$FinancialYear {
  /// Creates a financial year record.
  const factory FinancialYear({
    /// Unique internal identifier for the fiscal year.
    required String id,

    /// Narrative name (e.g., "Fiscal Year 2024 - Saudi Operations").
    required String name,

    /// First day of the fiscal cycle (Inclusive).
    required DateTime startDate,

    /// Last day of the fiscal cycle (Inclusive).
    required DateTime endDate,

    /// Immutable flag indicating the year has been finalized and audited.
    @Default(false) bool isClosed,

    /// Timestamp of the final year-end closing procedure.
    DateTime? closedAt,

    /// User ID of the authorized personnel who executed the closing.
    String? closedBy,

    /// Collection of specific sub-period IDs (e.g., Quarters/Months) that are locked.
    @Default([]) List<String> lockedPeriodIds,

    /// Tenant identifier for data isolation.
    String? userId,

    /// Local-to-Remote synchronization state.
    @Default(SyncStatus.synced) SyncStatus syncStatus,

    /// Most recent synchronization timestamp from the server.
    DateTime? serverUpdatedAt,

    /// Soft-deletion flag.
    @Default(false) bool isDeleted,
  }) = _FinancialYear;

  /// deserialization from JSON format.
  factory FinancialYear.fromJson(Map<String, dynamic> json) => _$FinancialYearFromJson(json);

  const FinancialYear._();

  /// Verifies if a given timestamp falls within this year's temporal range.
  bool containsDate(DateTime date) =>
      (date.isAfter(startDate) || date.isAtSameMomentAs(startDate)) &&
      (date.isBefore(endDate) || date.isAtSameMomentAs(endDate));

  /// Logical validation of the cycle (Start must precede End).
  bool get isValid => endDate.isAfter(startDate);
}
