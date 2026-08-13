// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredJournalEntriesHash() =>
    r'1029a032444a6ad0396dbee08c74fe6e80938d31';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provides a list of journal entries filtered by a specific account ID.
///
/// This supports the "Drill-Down" feature where users can click on a line
/// in the Balance Sheet or Income Statement to see the underlying transactions.
///
/// Copied from [filteredJournalEntries].
@ProviderFor(filteredJournalEntries)
const filteredJournalEntriesProvider = FilteredJournalEntriesFamily();

/// Provides a list of journal entries filtered by a specific account ID.
///
/// This supports the "Drill-Down" feature where users can click on a line
/// in the Balance Sheet or Income Statement to see the underlying transactions.
///
/// Copied from [filteredJournalEntries].
class FilteredJournalEntriesFamily
    extends Family<AsyncValue<List<JournalEntry>>> {
  /// Provides a list of journal entries filtered by a specific account ID.
  ///
  /// This supports the "Drill-Down" feature where users can click on a line
  /// in the Balance Sheet or Income Statement to see the underlying transactions.
  ///
  /// Copied from [filteredJournalEntries].
  const FilteredJournalEntriesFamily();

  /// Provides a list of journal entries filtered by a specific account ID.
  ///
  /// This supports the "Drill-Down" feature where users can click on a line
  /// in the Balance Sheet or Income Statement to see the underlying transactions.
  ///
  /// Copied from [filteredJournalEntries].
  FilteredJournalEntriesProvider call({
    String? accountId,
  }) {
    return FilteredJournalEntriesProvider(
      accountId: accountId,
    );
  }

  @override
  FilteredJournalEntriesProvider getProviderOverride(
    covariant FilteredJournalEntriesProvider provider,
  ) {
    return call(
      accountId: provider.accountId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'filteredJournalEntriesProvider';
}

/// Provides a list of journal entries filtered by a specific account ID.
///
/// This supports the "Drill-Down" feature where users can click on a line
/// in the Balance Sheet or Income Statement to see the underlying transactions.
///
/// Copied from [filteredJournalEntries].
class FilteredJournalEntriesProvider
    extends AutoDisposeFutureProvider<List<JournalEntry>> {
  /// Provides a list of journal entries filtered by a specific account ID.
  ///
  /// This supports the "Drill-Down" feature where users can click on a line
  /// in the Balance Sheet or Income Statement to see the underlying transactions.
  ///
  /// Copied from [filteredJournalEntries].
  FilteredJournalEntriesProvider({
    String? accountId,
  }) : this._internal(
          (ref) => filteredJournalEntries(
            ref as FilteredJournalEntriesRef,
            accountId: accountId,
          ),
          from: filteredJournalEntriesProvider,
          name: r'filteredJournalEntriesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filteredJournalEntriesHash,
          dependencies: FilteredJournalEntriesFamily._dependencies,
          allTransitiveDependencies:
              FilteredJournalEntriesFamily._allTransitiveDependencies,
          accountId: accountId,
        );

  FilteredJournalEntriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountId,
  }) : super.internal();

  final String? accountId;

  @override
  Override overrideWith(
    FutureOr<List<JournalEntry>> Function(FilteredJournalEntriesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredJournalEntriesProvider._internal(
        (ref) => create(ref as FilteredJournalEntriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountId: accountId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<JournalEntry>> createElement() {
    return _FilteredJournalEntriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredJournalEntriesProvider &&
        other.accountId == accountId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FilteredJournalEntriesRef
    on AutoDisposeFutureProviderRef<List<JournalEntry>> {
  /// The parameter `accountId` of this provider.
  String? get accountId;
}

class _FilteredJournalEntriesProviderElement
    extends AutoDisposeFutureProviderElement<List<JournalEntry>>
    with FilteredJournalEntriesRef {
  _FilteredJournalEntriesProviderElement(super.provider);

  @override
  String? get accountId => (origin as FilteredJournalEntriesProvider).accountId;
}

String _$subLedgerJournalEntriesHash() =>
    r'c9331fe6e1a5ab30405a6476b31d4d673a7be46c';

/// Provides journal entries filtered by a sub-ledger entity (Customer/Supplier).
///
/// Copied from [subLedgerJournalEntries].
@ProviderFor(subLedgerJournalEntries)
const subLedgerJournalEntriesProvider = SubLedgerJournalEntriesFamily();

/// Provides journal entries filtered by a sub-ledger entity (Customer/Supplier).
///
/// Copied from [subLedgerJournalEntries].
class SubLedgerJournalEntriesFamily
    extends Family<AsyncValue<List<JournalEntry>>> {
  /// Provides journal entries filtered by a sub-ledger entity (Customer/Supplier).
  ///
  /// Copied from [subLedgerJournalEntries].
  const SubLedgerJournalEntriesFamily();

  /// Provides journal entries filtered by a sub-ledger entity (Customer/Supplier).
  ///
  /// Copied from [subLedgerJournalEntries].
  SubLedgerJournalEntriesProvider call({
    required String entityId,
    required bool isCustomer,
  }) {
    return SubLedgerJournalEntriesProvider(
      entityId: entityId,
      isCustomer: isCustomer,
    );
  }

  @override
  SubLedgerJournalEntriesProvider getProviderOverride(
    covariant SubLedgerJournalEntriesProvider provider,
  ) {
    return call(
      entityId: provider.entityId,
      isCustomer: provider.isCustomer,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'subLedgerJournalEntriesProvider';
}

/// Provides journal entries filtered by a sub-ledger entity (Customer/Supplier).
///
/// Copied from [subLedgerJournalEntries].
class SubLedgerJournalEntriesProvider
    extends AutoDisposeFutureProvider<List<JournalEntry>> {
  /// Provides journal entries filtered by a sub-ledger entity (Customer/Supplier).
  ///
  /// Copied from [subLedgerJournalEntries].
  SubLedgerJournalEntriesProvider({
    required String entityId,
    required bool isCustomer,
  }) : this._internal(
          (ref) => subLedgerJournalEntries(
            ref as SubLedgerJournalEntriesRef,
            entityId: entityId,
            isCustomer: isCustomer,
          ),
          from: subLedgerJournalEntriesProvider,
          name: r'subLedgerJournalEntriesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$subLedgerJournalEntriesHash,
          dependencies: SubLedgerJournalEntriesFamily._dependencies,
          allTransitiveDependencies:
              SubLedgerJournalEntriesFamily._allTransitiveDependencies,
          entityId: entityId,
          isCustomer: isCustomer,
        );

  SubLedgerJournalEntriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.entityId,
    required this.isCustomer,
  }) : super.internal();

  final String entityId;
  final bool isCustomer;

  @override
  Override overrideWith(
    FutureOr<List<JournalEntry>> Function(SubLedgerJournalEntriesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SubLedgerJournalEntriesProvider._internal(
        (ref) => create(ref as SubLedgerJournalEntriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        entityId: entityId,
        isCustomer: isCustomer,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<JournalEntry>> createElement() {
    return _SubLedgerJournalEntriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SubLedgerJournalEntriesProvider &&
        other.entityId == entityId &&
        other.isCustomer == isCustomer;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, entityId.hashCode);
    hash = _SystemHash.combine(hash, isCustomer.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SubLedgerJournalEntriesRef
    on AutoDisposeFutureProviderRef<List<JournalEntry>> {
  /// The parameter `entityId` of this provider.
  String get entityId;

  /// The parameter `isCustomer` of this provider.
  bool get isCustomer;
}

class _SubLedgerJournalEntriesProviderElement
    extends AutoDisposeFutureProviderElement<List<JournalEntry>>
    with SubLedgerJournalEntriesRef {
  _SubLedgerJournalEntriesProviderElement(super.provider);

  @override
  String get entityId => (origin as SubLedgerJournalEntriesProvider).entityId;
  @override
  bool get isCustomer => (origin as SubLedgerJournalEntriesProvider).isCustomer;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
