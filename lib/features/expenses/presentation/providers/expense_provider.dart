import 'package:basir_accounting_system/features/expenses/application/expense_service.dart';
import 'package:basir_accounting_system/features/expenses/domain/entities/expense.dart';
import 'package:basir_accounting_system/features/expenses/domain/repositories/expense_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'expense_provider.g.dart';

/// Provider for expenses list with filtering
@riverpod
class ExpensesNotifier extends _$ExpensesNotifier {
  /// Builds the initial state by loading current month's expenses.
  @override
  Future<List<Expense>> build() async {
    final service = ref.watch(expenseServiceProvider);
    return service.getCurrentMonthExpenses();
  }

  /// Refreshes the list of expenses.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(expenseServiceProvider);
      return service.getCurrentMonthExpenses();
    });
  }

  /// Loads expenses with optional filters.
  Future<void> loadExpenses({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
    String? status,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(expenseServiceProvider);
      return service.getExpenses(
        startDate: startDate,
        endDate: endDate,
        categoryId: categoryId,
        status: status,
      );
    });
  }

  /// Adds a new expense to the system.
  Future<void> addExpense({
    required String description,
    required Decimal amount,
    required String currencyCode,
    required DateTime expenseDate,
    required String categoryId,
    String? vendorName,
    String? notes,
  }) async {
    final service = ref.read(expenseServiceProvider);
    await service.createExpense(
      description: description,
      amount: amount,
      currencyCode: currencyCode,
      expenseDate: expenseDate,
      categoryId: categoryId,
      vendorName: vendorName,
      notes: notes,
    );
    await refresh();
  }

  /// Deletes an expense by its ID.
  Future<void> deleteExpense(String id) async {
    final service = ref.read(expenseServiceProvider);
    await service.deleteExpense(id);
    await refresh();
  }
}

/// Provider for expense categories.
@riverpod
Future<List<ExpenseCategory>> expenseCategories(
  ExpenseCategoriesRef ref,
) async {
  final service = ref.watch(expenseServiceProvider);
  return service.getCategories();
}

/// Provider for expense summary.
@riverpod
Future<ExpenseSummary> expenseSummary(ExpenseSummaryRef ref) async {
  final service = ref.watch(expenseServiceProvider);
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month);
  final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

  return service.getExpenseSummary(
    startDate: startOfMonth,
    endDate: endOfMonth,
  );
}

/// Provider for selected expense (for detail view).
@riverpod
class SelectedExpense extends _$SelectedExpense {
  @override
  Expense? build() => null;

  /// Selects an expense to view details.
  // ignore: use_setters_to_change_properties
  void select(Expense expense) {
    state = expense;
  }

  /// Clears the currently selected expense.
  void clear() {
    state = null;
  }
}
