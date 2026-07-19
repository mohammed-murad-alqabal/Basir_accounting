import 'package:isar/isar.dart';

part 'expense_model.g.dart';

/// Isar model for expense persistence.
@collection
class ExpenseModel {
  /// The local Isar ID.
  Id isarId = Isar.autoIncrement;

  /// The unique UUID of the expense.
  @Index(unique: true)
  late String id;

  /// A brief description of the expense.
  late String description;

  /// The monetary amount of the expense.
  late double amount;

  /// The currency code (e.g., 'SAR', 'USD').
  late String currencyCode;

  /// The date the expense occurred.
  @Index()
  late DateTime expenseDate;

  /// The ID of the category this expense belongs to.
  @Index()
  late String categoryId;

  /// The optional ID of the vendor.
  String? vendorId;

  /// The optional name of the vendor (denormalized).
  String? vendorName;

  /// The URL or path to the receipt image/document.
  String? receiptUrl;

  /// Additional notes or remarks.
  String? notes;

  /// Whether this is a recurring expense.
  late bool isRecurring;

  /// The date when the recurrence ends, if applicable.
  DateTime? recurringEndDate;

  /// The current status of the expense (e.g., 'paid', 'pending').
  @Index()
  late String status;

  /// The ID of the associated accounting journal entry.
  String? journalEntryId;

  /// The ID of the user who created this record.
  String? createdBy;

  /// The timestamp when this record was created.
  late DateTime createdAt;

  /// The timestamp when this record was last updated.
  late DateTime updatedAt;
}

/// Isar model for expense categories.
@collection
class ExpenseCategoryModel {
  /// The local Isar ID.
  Id isarId = Isar.autoIncrement;

  /// The unique UUID of the category.
  @Index(unique: true)
  late String id;

  /// The English name of the category.
  late String name;

  /// The Arabic name of the category.
  late String nameAr;

  /// The icon identifier for the category.
  String? icon;

  /// The color hex code for the category.
  String? color;

  /// The default General Ledger account ID associated with this category.
  String? accountId;

  /// Whether this category is currently active.
  late bool isActive;
}
