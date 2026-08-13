// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$vendorsHash() => r'd34ea97e74d2f7556a120ce08fb8253e7292be8b';

/// موفر قائمة الموردين (Vendors Provider)
///
/// يوفر الوصول إلى جميع الموردين المسجلين في النظام
/// مع دعم عمليات CRUD الكاملة.
///
/// Copied from [Vendors].
@ProviderFor(Vendors)
final vendorsProvider =
    AutoDisposeAsyncNotifierProvider<Vendors, List<Vendor>>.internal(
  Vendors.new,
  name: r'vendorsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$vendorsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Vendors = AutoDisposeAsyncNotifier<List<Vendor>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
