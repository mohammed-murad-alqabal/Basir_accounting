// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_year_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$financialYearServiceHash() =>
    r'f22e1daf7c8021d8e71df7603eeed85eb14705ee';

/// Financial Year Service managing fiscal periods and posting permissions.
///
/// Implements period-end closing procedures, monthly lockdowns, and
/// validation logic to ensure temporal integrity of financial data.
///
/// Copied from [FinancialYearService].
@ProviderFor(FinancialYearService)
final financialYearServiceProvider =
    AsyncNotifierProvider<FinancialYearService, void>.internal(
  FinancialYearService.new,
  name: r'financialYearServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$financialYearServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FinancialYearService = AsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
