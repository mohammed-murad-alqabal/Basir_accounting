// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_ledger_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$customerLedgerServiceHash() =>
    r'36d8313f95aacc548bd4489a7672bfcf2a929464';

/// Customer Ledger Service - Manages customer account transactions.
///
/// This service provides comprehensive customer ledger functionality:
/// - Complete transaction history
/// - Balance calculations at any point in time
/// - Statement generation
/// - Transaction search and filtering
///
/// ## Standards Compliance:
/// - **IAS 1**: Presentation of Financial Statements
/// - **IFRS 15**: Revenue from Contracts with Customers
///
/// Copied from [CustomerLedgerService].
@ProviderFor(CustomerLedgerService)
final customerLedgerServiceProvider =
    AutoDisposeAsyncNotifierProvider<CustomerLedgerService, void>.internal(
  CustomerLedgerService.new,
  name: r'customerLedgerServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$customerLedgerServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CustomerLedgerService = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
