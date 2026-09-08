// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forensic_audit_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$forensicAuditServiceHash() =>
    r'c067df664429e3f81a64f142385b13d8b94ed0f8';

/// [ForensicAuditService]
///
/// Specialized service for deep transactional analysis and corruption detection.
/// Leverages the Rust-based `self_healing` auditor for performance-critical tasks.
///
/// Copied from [ForensicAuditService].
@ProviderFor(ForensicAuditService)
final forensicAuditServiceProvider =
    NotifierProvider<ForensicAuditService, void>.internal(
  ForensicAuditService.new,
  name: r'forensicAuditServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$forensicAuditServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ForensicAuditService = Notifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
