// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$syncServiceHash() => r'ab2e1851e201e4280dc6ca5f6f815e6e3df5e141';

/// Bidirectional data synchronization service.
///
/// Manages offline-first data synchronization between local Isar database
/// and remote Supabase backend. Implements Last-Write-Wins (LWW) conflict
/// resolution strategy.
///
/// ## Features
/// - Offline-first architecture with local persistence
/// - Bidirectional sync (push local changes, pull remote updates)
/// - Last-Write-Wins conflict resolution
/// - Supports 9 entity types across all business domains
///
/// ## Sync Process
/// 1. **Push Phase**: Upload pending local changes to server
/// 2. **Pull Phase**: Download server changes since last sync
/// 3. **Conflict Resolution**: LWW based on `updatedAt` timestamps
///
/// ## Usage
/// ```dart
/// final syncService = ref.read(syncServiceProvider.notifier);
/// syncService.init(isar, supabaseClient);
/// await syncService.syncAll();
/// ```
///
/// Copied from [SyncService].
@ProviderFor(SyncService)
final syncServiceProvider =
    AutoDisposeAsyncNotifierProvider<SyncService, void>.internal(
  SyncService.new,
  name: r'syncServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$syncServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SyncService = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
