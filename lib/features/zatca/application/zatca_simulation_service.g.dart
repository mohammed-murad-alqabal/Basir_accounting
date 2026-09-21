// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zatca_simulation_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$zatcaSimulationServiceHash() =>
    r'60982e545ce30adff99c44c93bfda82204445400';

/// Simulates the ZATCA Phase 2 "Live Reporting" experience.
///
/// This service provides mock endpoints for onboarding and invoice reporting,
/// allow the UI to reflect the compliance flow without a live Sandbox
/// connection.
///
/// Copied from [ZatcaSimulationService].
@ProviderFor(ZatcaSimulationService)
final zatcaSimulationServiceProvider =
    AutoDisposeNotifierProvider<ZatcaSimulationService, void>.internal(
  ZatcaSimulationService.new,
  name: r'zatcaSimulationServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$zatcaSimulationServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ZatcaSimulationService = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
