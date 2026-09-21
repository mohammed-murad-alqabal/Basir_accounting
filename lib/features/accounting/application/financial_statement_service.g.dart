// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_statement_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$financialStatementServiceHash() =>
    r'68ef13f5c662d41d7f659be74f3fbf0654deff16';

/// Financial Statement Service for generating core balance
/// and performance reports.
///
/// Implements logic for Trial Balance, IFRS 18 Income Statements,
/// and Balance Sheets, incorporating hierarchical account
/// groupings and net income calculations.
///
/// Copied from [FinancialStatementService].
@ProviderFor(FinancialStatementService)
final financialStatementServiceProvider =
    AutoDisposeNotifierProvider<FinancialStatementService, void>.internal(
  FinancialStatementService.new,
  name: r'financialStatementServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$financialStatementServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FinancialStatementService = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
