// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountsHash() => r'2bed557249e96cc1c01dd29314ad0b9b97f0dc82';

/// Global provider for the consolidated local Chart of Accounts (COA).
///
/// Serves as the reactive source of truth for all ledger accounts,
/// enabling real-time UI updates when balances or metadata change.
///
/// Copied from [accounts].
@ProviderFor(accounts)
final accountsProvider = AutoDisposeFutureProvider<List<Account>>.internal(
  accounts,
  name: r'accountsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$accountsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AccountsRef = AutoDisposeFutureProviderRef<List<Account>>;
String _$accountsByTypeHash() => r'da7e04a85c13d337c4c14f10369b2983eaaa9f7e';

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

/// Dynamic filtered provider for accounts of a specific [AccountType].
///
/// Optimizes UI performance by providing slice-based access to the COA,
/// useful for account selection in forms (e.g., filtering for Assets only).
///
/// Copied from [accountsByType].
@ProviderFor(accountsByType)
const accountsByTypeProvider = AccountsByTypeFamily();

/// Dynamic filtered provider for accounts of a specific [AccountType].
///
/// Optimizes UI performance by providing slice-based access to the COA,
/// useful for account selection in forms (e.g., filtering for Assets only).
///
/// Copied from [accountsByType].
class AccountsByTypeFamily extends Family<AsyncValue<List<Account>>> {
  /// Dynamic filtered provider for accounts of a specific [AccountType].
  ///
  /// Optimizes UI performance by providing slice-based access to the COA,
  /// useful for account selection in forms (e.g., filtering for Assets only).
  ///
  /// Copied from [accountsByType].
  const AccountsByTypeFamily();

  /// Dynamic filtered provider for accounts of a specific [AccountType].
  ///
  /// Optimizes UI performance by providing slice-based access to the COA,
  /// useful for account selection in forms (e.g., filtering for Assets only).
  ///
  /// Copied from [accountsByType].
  AccountsByTypeProvider call(
    AccountType type,
  ) {
    return AccountsByTypeProvider(
      type,
    );
  }

  @override
  AccountsByTypeProvider getProviderOverride(
    covariant AccountsByTypeProvider provider,
  ) {
    return call(
      provider.type,
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
  String? get name => r'accountsByTypeProvider';
}

/// Dynamic filtered provider for accounts of a specific [AccountType].
///
/// Optimizes UI performance by providing slice-based access to the COA,
/// useful for account selection in forms (e.g., filtering for Assets only).
///
/// Copied from [accountsByType].
class AccountsByTypeProvider extends AutoDisposeFutureProvider<List<Account>> {
  /// Dynamic filtered provider for accounts of a specific [AccountType].
  ///
  /// Optimizes UI performance by providing slice-based access to the COA,
  /// useful for account selection in forms (e.g., filtering for Assets only).
  ///
  /// Copied from [accountsByType].
  AccountsByTypeProvider(
    AccountType type,
  ) : this._internal(
          (ref) => accountsByType(
            ref as AccountsByTypeRef,
            type,
          ),
          from: accountsByTypeProvider,
          name: r'accountsByTypeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountsByTypeHash,
          dependencies: AccountsByTypeFamily._dependencies,
          allTransitiveDependencies:
              AccountsByTypeFamily._allTransitiveDependencies,
          type: type,
        );

  AccountsByTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final AccountType type;

  @override
  Override overrideWith(
    FutureOr<List<Account>> Function(AccountsByTypeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountsByTypeProvider._internal(
        (ref) => create(ref as AccountsByTypeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Account>> createElement() {
    return _AccountsByTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountsByTypeProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AccountsByTypeRef on AutoDisposeFutureProviderRef<List<Account>> {
  /// The parameter `type` of this provider.
  AccountType get type;
}

class _AccountsByTypeProviderElement
    extends AutoDisposeFutureProviderElement<List<Account>>
    with AccountsByTypeRef {
  _AccountsByTypeProviderElement(super.provider);

  @override
  AccountType get type => (origin as AccountsByTypeProvider).type;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
