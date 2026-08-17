// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_engine_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$taxEngineServiceHash() => r'a5e6dc8da6902c13381c51092e5d925184628700';

/// Tax Engine Expert Service (Agent 2) responsible for local tax compliance.
///
/// This agent monitors transactions for regulatory adherence, specifically
/// ZATCA (Saudi Arabia) and FTA (UAE) VAT requirements. It validates VAT rates,
/// tax identification IDs, and E-Invoicing standards.
///
/// Copied from [TaxEngineService].
@ProviderFor(TaxEngineService)
final taxEngineServiceProvider =
    AsyncNotifierProvider<TaxEngineService, void>.internal(
  TaxEngineService.new,
  name: r'taxEngineServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$taxEngineServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TaxEngineService = AsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
