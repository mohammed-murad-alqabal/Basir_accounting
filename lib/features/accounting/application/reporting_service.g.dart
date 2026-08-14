// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reporting_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reportingServiceHash() => r'd824a7c76045cc03d255c4b52cefb63b62c814a0';

/// Reporting Service for high-level financial intelligence and dashboarding.
///
/// Orchestrates the generation of Trial Balances, IFRS 18 Income Statements,
/// Balance Sheets, and Direct-Method Cash Flow Statements.
///
/// Copied from [ReportingService].
@ProviderFor(ReportingService)
final reportingServiceProvider =
    AutoDisposeNotifierProvider<ReportingService, void>.internal(
  ReportingService.new,
  name: r'reportingServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reportingServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReportingService = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
