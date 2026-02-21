import 'package:basir_accounting_system/features/expenses/domain/entities/expense.dart';
import 'package:basir_accounting_system/features/expenses/domain/repositories/expense_repository.dart';
import 'package:uuid/uuid.dart';

/// Implementation of ExpenseRepository using Isar local database.
///
/// Follows FORENSIC_ATLAS Screen 066 data access patterns.
class ExpenseRepositoryImpl implements ExpenseRepository {
  /// Creates the [ExpenseRepositoryImpl].
  ExpenseRepositoryImpl() {
    _initializeDefaultCategories();
  }
  // In-memory storage for now - will be replaced with Isar
  final List<Expense> _expenses = [];
  final List<ExpenseCategory> _categories = [];
  final _uuid = const Uuid();

  void _initializeDefaultCategories() {
    for (final cat in DefaultExpenseCategories.categories) {
      _categories.add(
        ExpenseCategory(
          id: cat['id'] as String,
          name: cat['name'] as String,
          nameAr: cat['nameAr'] as String,
          icon: cat['icon'] as String?,
          color: cat['color'] as String?,
        ),
      );
    }
  }

  @override
  Future<List<Expense>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
    String? status,
  }) async {
    var result = _expenses.toList();

    if (startDate != null) {
      result = result
          .where(
            (e) =>
                e.expenseDate.isAfter(startDate) ||
                e.expenseDate.isAtSameMomentAs(startDate),
          )
          .toList();
    }

    if (endDate != null) {
      result = result
          .where(
            (e) =>
                e.expenseDate.isBefore(endDate) ||
                e.expenseDate.isAtSameMomentAs(endDate),
          )
          .toList();
    }

    if (categoryId != null) {
      result = result.where((e) => e.categoryId == categoryId).toList();
    }

    if (status != null) {
      result = result.where((e) => e.status == status).toList();
    }

    result.sort((a, b) => b.expenseDate.compareTo(a.expenseDate));
    return result;
  }

  @override
  Future<Expense?> getExpenseById(String id) async {
    final results = _expenses.where((e) => e.id == id).toList();
    return results.isEmpty ? null : results.first;
  }

  @override
  Future<Expense> createExpense(Expense expense) async {
    final now = DateTime.now();
    final newExpense = expense.copyWith(
      id: expense.id.isEmpty ? _uuid.v4() : expense.id,
      createdAt: now,
      updatedAt: now,
    );
    _expenses.add(newExpense);
    return newExpense;
  }

  @override
  Future<Expense> updateExpense(Expense expense) async {
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index == -1) {
      throw Exception('Expense not found: ${expense.id}');
    }

    final updated = expense.copyWith(updatedAt: DateTime.now());
    _expenses[index] = updated;
    return updated;
  }

  @override
  Future<bool> deleteExpense(String id) async {
    final expense = await getExpenseById(id);
    if (expense == null) return false;

    if (expense.isPosted) {
      throw Exception('Cannot delete posted expense');
    }

    _expenses.removeWhere((e) => e.id == id);
    return true;
  }

  @override
  Future<List<ExpenseCategory>> getCategories() async =>
      _categories.where((c) => c.isActive).toList();

  @override
  Future<List<Expense>> getExpensesByCategory(String categoryId) async =>
      _expenses.where((e) => e.categoryId == categoryId).toList();

  @override
  Future<ExpenseSummary> getExpenseSummary({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final expenses = await getExpenses(startDate: startDate, endDate: endDate);

    if (expenses.isEmpty) {
      return ExpenseSummary.empty();
    }

    final totalAmount = expenses.fold<double>(
      0,
      (sum, e) => sum + e.amount.toDouble(),
    );

    final byCategory = <String, double>{};
    final byMonth = <String, double>{};

    for (final expense in expenses) {
      // By category
      byCategory[expense.categoryId] =
          (byCategory[expense.categoryId] ?? 0) + expense.amount.toDouble();

      // By month
      final monthKey = '${expense.expenseDate.year}-'
          '${expense.expenseDate.month.toString().padLeft(2, '0')}';
      byMonth[monthKey] = (byMonth[monthKey] ?? 0) + expense.amount.toDouble();
    }

    return ExpenseSummary(
      totalAmount: totalAmount,
      count: expenses.length,
      averageAmount: totalAmount / expenses.length,
      byCategory: byCategory,
      byMonth: byMonth,
    );
  }

  @override
  Future<Map<String, double>> getExpensesByCategories({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final summary = await getExpenseSummary(
      startDate: startDate,
      endDate: endDate,
    );
    return summary.byCategory;
  }

  @override
  Future<Expense> postToLedger(String expenseId) async {
    final expense = await getExpenseById(expenseId);
    if (expense == null) {
      throw Exception('Expense not found: $expenseId');
    }

    if (expense.isPosted) {
      throw Exception('Expense already posted');
    }

    // TODO(basir): Implement proper filtering via LedgerService
    final journalEntryId = _uuid.v4();

    final posted = expense.copyWith(
      status: 'posted',
      journalEntryId: journalEntryId,
      updatedAt: DateTime.now(),
    );

    return updateExpense(posted);
  }
}
