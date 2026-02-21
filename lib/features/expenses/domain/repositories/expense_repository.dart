import 'package:basir_accounting_system/features/expenses/domain/entities/expense.dart';

/// Repository interface for expense operations.
///
/// Follows FORENSIC_ATLAS specifications for data access patterns.
abstract class ExpenseRepository {
  /// Get all expenses with optional filtering.
  Future<List<Expense>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
    String? status,
  });

  /// Get expense by ID.
  Future<Expense?> getExpenseById(String id);

  /// Create a new expense.
  Future<Expense> createExpense(Expense expense);

  /// Update an existing expense.
  Future<Expense> updateExpense(Expense expense);

  /// Delete an expense by ID (only if not posted).
  Future<bool> deleteExpense(String id);

  /// Get all expense categories.
  Future<List<ExpenseCategory>> getCategories();

  /// Get expenses filtered by category ID.
  Future<List<Expense>> getExpensesByCategory(String categoryId);

  /// Get expenses summary for a specific period.
  Future<ExpenseSummary> getExpenseSummary({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get total expenses grouped by category for reporting.
  Future<Map<String, double>> getExpensesByCategories({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Post an approved expense to the General Ledger.
  Future<Expense> postToLedger(String expenseId);
}

/// Summary of expenses for dashboard display
class ExpenseSummary {
  /// Creates an [ExpenseSummary].
  const ExpenseSummary({
    required this.totalAmount,
    required this.count,
    required this.averageAmount,
    required this.byCategory,
    required this.byMonth,
  });

  /// Creates an empty [ExpenseSummary].
  factory ExpenseSummary.empty() => const ExpenseSummary(
        totalAmount: 0,
        count: 0,
        averageAmount: 0,
        byCategory: {},
        byMonth: {},
      );

  /// Total amount of expenses.
  final double totalAmount;

  /// Total count of expenses.
  final int count;

  /// Average amount per expense.
  final double averageAmount;

  /// Expenses broken down by category ID.
  final Map<String, double> byCategory;

  /// Expenses broken down by month (YYYY-MM).
  final Map<String, double> byMonth;
}
