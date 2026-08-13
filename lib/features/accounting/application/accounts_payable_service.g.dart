// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts_payable_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountsPayableServiceHash() =>
    r'8ee279b7010af943531cc328b9f7c51fb4ea2532';

/// Accounts Payable (AP) Service for managing supplier liabilities and
/// obligations.
///
/// Implements logic for debt tracking, supplier ledger analysis, and
/// detailed aging for financial obligations.
///
/// Copied from [AccountsPayableService].
@ProviderFor(AccountsPayableService)
final accountsPayableServiceProvider =
    AutoDisposeAsyncNotifierProvider<AccountsPayableService, void>.internal(
  AccountsPayableService.new,
  name: r'accountsPayableServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountsPayableServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AccountsPayableService = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
