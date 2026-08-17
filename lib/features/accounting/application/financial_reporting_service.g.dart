// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_reporting_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$financialReportingServiceHash() =>
    r'2c4adaad5efb585a65a2dee057bcb41f18dc80af';

/// Financial Reporting Service for generating regulatory and management
/// statements.
///
/// Provides orchestration for trial balances, income statements (IFRS 18
/// compliant), and high-level financial trend analysis.
///
/// Copied from [FinancialReportingService].
@ProviderFor(FinancialReportingService)
final financialReportingServiceProvider =
    AutoDisposeAsyncNotifierProvider<FinancialReportingService, void>.internal(
  FinancialReportingService.new,
  name: r'financialReportingServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$financialReportingServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FinancialReportingService = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
