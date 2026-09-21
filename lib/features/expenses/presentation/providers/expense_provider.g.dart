// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$expenseCategoriesHash() => r'959a2dc51df7cf9aced91ced243de852871a551a';

/// Provider for expense categories.
///
/// Copied from [expenseCategories].
@ProviderFor(expenseCategories)
final expenseCategoriesProvider =
    AutoDisposeFutureProvider<List<ExpenseCategory>>.internal(
  expenseCategories,
  name: r'expenseCategoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expenseCategoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ExpenseCategoriesRef
    = AutoDisposeFutureProviderRef<List<ExpenseCategory>>;
String _$expenseSummaryHash() => r'704521ced19cc295886149b2de7e8800429c0404';

/// Provider for expense summary.
///
/// Copied from [expenseSummary].
@ProviderFor(expenseSummary)
final expenseSummaryProvider =
    AutoDisposeFutureProvider<ExpenseSummary>.internal(
  expenseSummary,
  name: r'expenseSummaryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expenseSummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ExpenseSummaryRef = AutoDisposeFutureProviderRef<ExpenseSummary>;
String _$expensesNotifierHash() => r'511997ee5136684f3799d7937c156fea1219c97c';

/// Provider for expenses list with filtering
///
/// Copied from [ExpensesNotifier].
@ProviderFor(ExpensesNotifier)
final expensesNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ExpensesNotifier, List<Expense>>.internal(
  ExpensesNotifier.new,
  name: r'expensesNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expensesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExpensesNotifier = AutoDisposeAsyncNotifier<List<Expense>>;
String _$selectedExpenseHash() => r'2d809966ce871f5b6ebdcd67282c356be44d15f1';

/// Provider for selected expense (for detail view).
///
/// Copied from [SelectedExpense].
@ProviderFor(SelectedExpense)
final selectedExpenseProvider =
    AutoDisposeNotifierProvider<SelectedExpense, Expense?>.internal(
  SelectedExpense.new,
  name: r'selectedExpenseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedExpenseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedExpense = AutoDisposeNotifier<Expense?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
