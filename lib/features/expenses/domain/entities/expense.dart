import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

/// Expense entity following FORENSIC_ATLAS Screen 066 specifications.
///
/// Represents a business expense with categorization, receipt tracking,
/// and accounting integration.
@freezed
class Expense with _$Expense {
  /// Creates an [Expense].
  const factory Expense({
    /// The unique identifier of the expense.
    required String id,

    /// A brief description of the expense.
    required String description,

    /// The monetary amount of the expense.
    required Decimal amount,

    /// The currency code (e.g., 'SAR').
    required String currencyCode,

    /// The date the expense was incurred.
    required DateTime expenseDate,

    /// The ID of the category this expense belongs to.
    required String categoryId,

    /// The optional ID of the vendor.
    String? vendorId,

    /// The optional name of the vendor.
    String? vendorName,

    /// The URL or path to the receipt image.
    String? receiptUrl,

    /// Additional notes or remarks.
    String? notes,

    /// Whether this is a recurring expense.
    @Default(false) bool isRecurring,

    /// The date when the recurrence ends, if applicable.
    DateTime? recurringEndDate,

    /// The current status of the expense (e.g., pending, approved).
    @Default('pending') String status, // pending, approved, rejected, posted

    /// The ID of the associated GL journal entry when posted.
    String? journalEntryId, // Link to GL when posted

    /// The ID of the user who created this record.
    String? createdBy,

    /// The timestamp when this record was created.
    DateTime? createdAt,

    /// The timestamp when this record was last updated.
    DateTime? updatedAt,
  }) = _Expense;
  const Expense._();

  /// Creates an [Expense] instance from a JSON map.
  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);

  /// Check if expense is posted to General Ledger
  bool get isPosted => journalEntryId != null;

  /// Check if expense is approved
  bool get isApproved => status == 'approved' || status == 'posted';
}

/// Expense category for classification
@freezed
class ExpenseCategory with _$ExpenseCategory {
  /// Creates an [ExpenseCategory].
  const factory ExpenseCategory({
    /// Unique identifier.
    required String id,

    /// English name.
    required String name,

    /// Arabic name.
    required String nameAr,

    /// Icon code point or name.
    String? icon,

    /// Hex color code.
    String? color,

    /// Linked GL account ID.
    String? accountId, // GL account for posting

    /// Whether category is active.
    @Default(true) bool isActive,
  }) = _ExpenseCategory;

  /// Creates instance from JSON.
  factory ExpenseCategory.fromJson(Map<String, dynamic> json) =>
      _$ExpenseCategoryFromJson(json);
}

/// Default expense categories based on FORENSIC_ATLAS
class DefaultExpenseCategories {
  /// List of default category maps.
  static const List<Map<String, dynamic>> categories = [
    {
      'id': 'cat_utilities',
      'name': 'Utilities',
      'nameAr': 'المرافق',
      'icon': 'electric_bolt',
      'color': '#FFC107',
    },
    {
      'id': 'cat_rent',
      'name': 'Rent',
      'nameAr': 'الإيجار',
      'icon': 'home',
      'color': '#9C27B0',
    },
    {
      'id': 'cat_salaries',
      'name': 'Salaries',
      'nameAr': 'الرواتب',
      'icon': 'people',
      'color': '#2196F3',
    },
    {
      'id': 'cat_supplies',
      'name': 'Office Supplies',
      'nameAr': 'مستلزمات المكتب',
      'icon': 'inventory',
      'color': '#4CAF50',
    },
    {
      'id': 'cat_travel',
      'name': 'Travel',
      'nameAr': 'السفر',
      'icon': 'flight',
      'color': '#00BCD4',
    },
    {
      'id': 'cat_marketing',
      'name': 'Marketing',
      'nameAr': 'التسويق',
      'icon': 'campaign',
      'color': '#E91E63',
    },
    {
      'id': 'cat_maintenance',
      'name': 'Maintenance',
      'nameAr': 'الصيانة',
      'icon': 'build',
      'color': '#795548',
    },
    {
      'id': 'cat_other',
      'name': 'Other',
      'nameAr': 'أخرى',
      'icon': 'more_horiz',
      'color': '#607D8B',
    },
  ];
}
