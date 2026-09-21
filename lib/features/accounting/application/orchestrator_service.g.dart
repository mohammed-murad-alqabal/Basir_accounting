// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orchestrator_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$orchestratorServiceHash() =>
    r'1c68f45e5dcfef0265c26654a8672d8e39fb5846';

/// Central Orchestrator Service managing the multi-agent consensus workflow.
///
/// Implements "The Cognitive Hexagon" architecture, where six specialized
/// AI agents must reach a consensus on the validity and impact of
/// every financial transaction.
///
/// Copied from [OrchestratorService].
@ProviderFor(OrchestratorService)
final orchestratorServiceProvider =
    AsyncNotifierProvider<OrchestratorService, void>.internal(
  OrchestratorService.new,
  name: r'orchestratorServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$orchestratorServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OrchestratorService = AsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
