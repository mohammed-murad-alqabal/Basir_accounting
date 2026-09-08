// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounting_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountingServiceHash() => r'207e69b7654adc3cd599c94c70c703c98fe3e974';

/// Central Accounting Service managing the Chart of Accounts and core ledger
/// operations.
///
/// This service implements critical financial logic including COA seeding,
/// account validation (IFRS compliance), journal entry posting, and
/// dual-entry orchestration for sales invoices.
///
/// ## Key Capabilities
/// - **COA Management**: Multi-standard Chart of Accounts generation
///   (IFRS, KSA, UAE).
/// - **Ledger Integrity**: Strict validation of account types and nature for
///   hierarchical structures.
/// - **Transaction Orchestration**: Automatic journal entry generation from
/// source documents (Invoices).
/// - **Hierarchical Reporting**: Recursive balance calculation for
///   parent/child accounts.
///
/// Copied from [AccountingService].
@ProviderFor(AccountingService)
final accountingServiceProvider =
    AsyncNotifierProvider<AccountingService, List<JournalEntry>>.internal(
  AccountingService.new,
  name: r'accountingServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountingServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AccountingService = AsyncNotifier<List<JournalEntry>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
