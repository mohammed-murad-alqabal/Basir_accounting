// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zakat_intelligence_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$zakatIntelligenceServiceHash() =>
    r'063d3435fe2d8aedd9a42360e9fd045a02b79f00';

/// Service responsible for Zakat Intelligence and Compliance.
///
/// Handles the automated calculation of Zakat Al-Maal according to
/// simplified KSA standards (Net Assets / Equity Method approximation).
///
/// Copied from [ZakatIntelligenceService].
@ProviderFor(ZakatIntelligenceService)
final zakatIntelligenceServiceProvider =
    AutoDisposeAsyncNotifierProvider<ZakatIntelligenceService, void>.internal(
  ZakatIntelligenceService.new,
  name: r'zakatIntelligenceServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$zakatIntelligenceServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ZakatIntelligenceService = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
