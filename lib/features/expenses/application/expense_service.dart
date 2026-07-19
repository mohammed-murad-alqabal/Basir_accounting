import 'package:basir_accounting_system/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:basir_accounting_system/features/expenses/domain/entities/expense.dart';
import 'package:basir_accounting_system/features/expenses/domain/repositories/expense_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'expense_service.g.dart';

/// Expense service following FORENSIC_ATLAS Screen 066 specifications.
///
/// Handles business logic for expense management including:
/// - CRUD operations
/// - Categorization
/// - GL posting
/// - Reporting
@riverpod
ExpenseService expenseService(ExpenseServiceRef ref) =>
    ExpenseService(ExpenseRepositoryImpl());

/// Service logic class for Expense operations.
class ExpenseService {
  /// Creates the [ExpenseService].
  ExpenseService(this._repository);
  final ExpenseRepository _repository;

  /// Get all expenses with optional filtering
  Future<List<Expense>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
    String? status,
  }) =>
      _repository.getExpenses(
        startDate: startDate,
        endDate: endDate,
        categoryId: categoryId,
        status: status,
      );

  /// Get expense by ID
  Future<Expense?> getExpenseById(String id) => _repository.getExpenseById(id);

  /// Create a new expense
  Future<Expense> createExpense({
    required String description,
    required Decimal amount,
    required String currencyCode,
    required DateTime expenseDate,
    required String categoryId,
    String? vendorId,
    String? vendorName,
    String? receiptUrl,
    String? notes,
    bool isRecurring = false,
    DateTime? recurringEndDate,
    String? createdBy,
  }) {
    final expense = Expense(
      id: '',
      description: description,
      amount: amount,
      currencyCode: currencyCode,
      expenseDate: expenseDate,
      categoryId: categoryId,
      vendorId: vendorId,
      vendorName: vendorName,
      receiptUrl: receiptUrl,
      notes: notes,
      isRecurring: isRecurring,
      recurringEndDate: recurringEndDate,
      createdBy: createdBy,
    );

    return _repository.createExpense(expense);
  }

  /// Update an existing expense
  Future<Expense> updateExpense(Expense expense) {
    if (expense.isPosted) {
      throw Exception('Cannot update posted expense');
    }
    return _repository.updateExpense(expense);
  }

  /// Delete an expense
  Future<bool> deleteExpense(String id) => _repository.deleteExpense(id);

  /// Approve an expense
  Future<Expense> approveExpense(String id) async {
    final expense = await _repository.getExpenseById(id);
    if (expense == null) {
      throw Exception('Expense not found');
    }

    return _repository.updateExpense(
      expense.copyWith(status: 'approved'),
    );
  }

  /// Reject an expense
  Future<Expense> rejectExpense(String id, {String? reason}) async {
    final expense = await _repository.getExpenseById(id);
    if (expense == null) {
      throw Exception('Expense not found');
    }

    return _repository.updateExpense(
      expense.copyWith(
        status: 'rejected',
        notes: reason != null
            ? '${expense.notes ?? ''}\nRejected: $reason'
            : expense.notes,
      ),
    );
  }

  /// Post expense to General Ledger
  Future<Expense> postToLedger(String expenseId) =>
      _repository.postToLedger(expenseId);

  /// Get all expense categories
  Future<List<ExpenseCategory>> getCategories() => _repository.getCategories();

  /// Get expense summary for dashboard
  Future<ExpenseSummary> getExpenseSummary({
    required DateTime startDate,
    required DateTime endDate,
  }) =>
      _repository.getExpenseSummary(
        startDate: startDate,
        endDate: endDate,
      );

  /// Get expenses by category for pie chart
  Future<Map<String, double>> getExpensesByCategories({
    required DateTime startDate,
    required DateTime endDate,
  }) =>
      _repository.getExpensesByCategories(
        startDate: startDate,
        endDate: endDate,
      );

  /// Get current month expenses
  Future<List<Expense>> getCurrentMonthExpenses() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    return getExpenses(startDate: startOfMonth, endDate: endOfMonth);
  }

  /// Get current year expenses
  Future<List<Expense>> getCurrentYearExpenses() {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year);
    final endOfYear = DateTime(now.year, 12, 31, 23, 59, 59);

    return getExpenses(startDate: startOfYear, endDate: endOfYear);
  }
}
