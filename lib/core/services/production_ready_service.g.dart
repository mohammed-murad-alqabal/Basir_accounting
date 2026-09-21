// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production_ready_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productionReadyServiceHash() =>
    r'ea2af9921679df029a3f4893eddfe2bb7f81777d';

/// A service responsible for verifying that the application is in a state
/// safe for production deployment.
/// Service responsible for final environmental and data integrity checks
/// before the application is considered "Production Ready".
///
/// Copied from [ProductionReadyService].
@ProviderFor(ProductionReadyService)
final productionReadyServiceProvider =
    AsyncNotifierProvider<ProductionReadyService, void>.internal(
  ProductionReadyService.new,
  name: r'productionReadyServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productionReadyServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProductionReadyService = AsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
