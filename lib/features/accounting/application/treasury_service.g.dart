// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treasury_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getVouchersHash() => r'f58e90bbba0bcbcfbe9935e1ba49e8fa73dc8084';

/// Provider for retrieving all financial vouchers.
/// (Implementation of FR-ACC-016)
///
/// Copied from [getVouchers].
@ProviderFor(getVouchers)
final getVouchersProvider =
    AutoDisposeFutureProvider<List<FinancialVoucher>>.internal(
  getVouchers,
  name: r'getVouchersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getVouchersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetVouchersRef = AutoDisposeFutureProviderRef<List<FinancialVoucher>>;
String _$treasuryServiceHash() => r'22b18280679201ef8ca9eb241006ad5d1998a1e4';

/// Treasury Service managing cash, banking, and financial voucher operations.
///
/// Responsible for issuing receipt and payment vouchers, and ensuring they
/// are correctly reflected in the general ledger via automatic journal posting.
///
/// ## Features
/// - **Voucher Management**: Lifecycle management for Receipt and Payment
///   vouchers.
/// - **Ledger Integration**: Automatic double-entry posting to Treasury
///   accounts.
/// - **Account Validation**: Enforces Cash/Bank account constraints for treasury transactions.
/// - **Financial Year Checks**: Prevents posting to closed or locked periods.
///
/// Copied from [TreasuryService].
@ProviderFor(TreasuryService)
final treasuryServiceProvider =
    AutoDisposeAsyncNotifierProvider<TreasuryService, void>.internal(
  TreasuryService.new,
  name: r'treasuryServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$treasuryServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TreasuryService = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
