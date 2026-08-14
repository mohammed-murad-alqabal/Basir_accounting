// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_receipt_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paymentReceiptServiceHash() =>
    r'7dd2cc15c9595911113c645ca8161c54d402ea54';

/// Payment Receipt Service - Manages customer payment collections.
///
/// This service handles the complete lifecycle of payment receipts including:
/// - Creating and recording payment receipts
/// - Automatic journal entry generation
/// - Customer balance updates
/// - Payment cancellation and reversal
///
/// ## Accounting Logic:
/// When a payment receipt is created, the following journal entry is generated:
/// - **Debit**: Cash/Bank Account (Asset Increase)
/// - **Credit**: Accounts Receivable (Asset Decrease)
///
/// ## Standards Compliance:
/// - **IAS 1**: Presentation of Financial Statements
/// - **IFRS 9**: Financial Instruments
/// - **ZATCA Phase 2**: Payment documentation requirements
///
/// Copied from [PaymentReceiptService].
@ProviderFor(PaymentReceiptService)
final paymentReceiptServiceProvider =
    AutoDisposeAsyncNotifierProvider<PaymentReceiptService, void>.internal(
  PaymentReceiptService.new,
  name: r'paymentReceiptServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paymentReceiptServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PaymentReceiptService = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
