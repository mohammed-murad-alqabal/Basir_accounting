// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$expenseServiceHash() => r'51cf4e3b73581dc635e8632b87da3333a437075d';

/// Expense service following FORENSIC_ATLAS Screen 066 specifications.
///
/// Handles business logic for expense management including:
/// - CRUD operations
/// - Categorization
/// - GL posting
/// - Reporting
///
/// Copied from [expenseService].
@ProviderFor(expenseService)
final expenseServiceProvider = AutoDisposeProvider<ExpenseService>.internal(
  expenseService,
  name: r'expenseServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expenseServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ExpenseServiceRef = AutoDisposeProviderRef<ExpenseService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
