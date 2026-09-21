// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contra_settlement_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$contraSettlementServiceHash() =>
    r'd29793d3c251afe2b43f06d6a90c554cff989d71';

/// Contra-Settlement Service for balancing mutual AR/AP positions.
///
/// Responsible for automating the netting process between a Customer
/// and a Vendor when they represent the same legal entity, reducing
/// both Receivable and Payable balances simultaneously.
///
/// Copied from [ContraSettlementService].
@ProviderFor(ContraSettlementService)
final contraSettlementServiceProvider =
    AutoDisposeAsyncNotifierProvider<ContraSettlementService, void>.internal(
  ContraSettlementService.new,
  name: r'contraSettlementServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$contraSettlementServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ContraSettlementService = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
