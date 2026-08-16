// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts_receivable_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountsReceivableServiceHash() =>
    r'af283e227bee2794c6dcb5ce7b38cb6a898b6924';

/// Accounts Receivable (AR) Service for managing customer billing and debt.
///
/// Implements logic for credit management, collection tracking, and
/// detailed aging analysis for accounts receivable.
///
/// Copied from [AccountsReceivableService].
@ProviderFor(AccountsReceivableService)
final accountsReceivableServiceProvider =
    AutoDisposeAsyncNotifierProvider<AccountsReceivableService, void>.internal(
  AccountsReceivableService.new,
  name: r'accountsReceivableServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountsReceivableServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AccountsReceivableService = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
