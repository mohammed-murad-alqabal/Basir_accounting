// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forensic_portal_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ledgerBlocksHash() => r'df7008dd4f78f027709cdd554d30b6869d6c339c';

/// Provider for the historical ledger blocks.
///
/// Copied from [ledgerBlocks].
@ProviderFor(ledgerBlocks)
final ledgerBlocksProvider =
    AutoDisposeFutureProvider<List<LedgerBlock>>.internal(
  ledgerBlocks,
  name: r'ledgerBlocksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$ledgerBlocksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LedgerBlocksRef = AutoDisposeFutureProviderRef<List<LedgerBlock>>;
String _$forensicPortalNotifierHash() =>
    r'4996c196c6bbd125eaa11752f646c759784e2e40';

/// Notifier for the forensic integrity pulse.
///
/// Copied from [ForensicPortalNotifier].
@ProviderFor(ForensicPortalNotifier)
final forensicPortalNotifierProvider = AutoDisposeAsyncNotifierProvider<
    ForensicPortalNotifier, IntegrityPulse>.internal(
  ForensicPortalNotifier.new,
  name: r'forensicPortalNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$forensicPortalNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ForensicPortalNotifier = AutoDisposeAsyncNotifier<IntegrityPulse>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
