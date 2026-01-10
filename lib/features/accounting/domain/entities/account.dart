import 'package:basir_app/core/models/sync_status.dart';
import 'package:basir_app/features/accounting/domain/entities/ifrs18_ontology.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';
part 'account.g.dart';

/// Fundamental accounting account types for structural classification.
/// (Standard Reference: FR-ACC-012)
enum AccountType {
  /// Economic resources owned or controlled (e.g., Cash, Inventory).
  asset,

  /// Future sacrifices of economic benefits (e.g., Accounts Payable, Loans).
  liability,

  /// Residual interest in assets after deducting liabilities (e.g., Capital,
  /// Reserves).
  equity,

  /// Increases in economic benefits from core or periphery activities.
  revenue,

  /// Decreases in economic benefits resulting from business operations.
  expense,
}

/// The inherent accounting nature of an account (Normal Balance).
enum AccountNature {
  /// Increases on the left side (e.g., Assets and Expenses).
  debit,

  /// Increases on the right side (e.g., Liabilities, Revenue, and Equity).
  credit,
}

/// Represents a specific account within the hierarchical Chart of Accounts\n/// (COA).
@freezed
class Account with _$Account {
  /// Creates a business account entity.
  const factory Account({
    /// Unique internal identifier for the account.
    required String id,

    /// Unique accounting code for structured reporting (e.g., "1101" for Cash).
    required String code,

    /// Primary Arabic display name (e.g., "النقدية").
    required String nameAr,

    /// Primary English display name (e.g., "Cash").
    required String nameEn,

    /// High-level categorization (Asset, Liability, etc.).
    required AccountType type,

    /// Normal balance nature of the account (Debit/Credit).
    required AccountNature nature,

    /// Current net balance persisted as a high-precision [Decimal].
    required Decimal balance,

    /// Functional sub-type for automated processing (e.g., "cash", "bank",
    /// "ar").
    @Default('') String subType,

    /// IFRS 18 specific category mapping for optimized P&L presentation.
    Ifrs18Category? ifrs18Category,

    /// Indicates if this is a grouping (Parent) account that aggregates child
    /// balances.
    @Default(false) bool isParent,

    /// Reference to the immediate parent account for tree traversal.
    String? parentId,

    /// Operational status: if false, the account is hidden from active posting.
    @Default(true) bool isActive,

    /// If true, the account is a core system-defined account and cannot be
    /// deleted.
    @Default(false) bool isSystem,

    /// Multi-tenant identifier isolating data per user.
    String? userId,

    /// Local-to-Remote synchronization state.
    @Default(SyncStatus.synced) SyncStatus syncStatus,

    /// Most recent synchronization timestamp from the server.
    DateTime? serverUpdatedAt,

    /// Soft-deletion flag for audit trail preservation.
    @Default(false) bool isDeleted,
  }) = _Account;

  /// deserialization from JSON format.
  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);

  const Account._();

  /// Returns the localized name based on global [isArabic] preference.
  String name({required bool isArabic}) => isArabic ? nameAr : nameEn;
}
