// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'excel_import_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$excelImportServiceHash() =>
    r'4cb5ab75e936319e8cb0c27e13960391784d0140';

/// خدمة استيراد البيانات من ملفات Excel إلى النظام.
///
/// Copied from [ExcelImportService].
@ProviderFor(ExcelImportService)
final excelImportServiceProvider = AutoDisposeAsyncNotifierProvider<
    ExcelImportService, List<ImportRow>>.internal(
  ExcelImportService.new,
  name: r'excelImportServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$excelImportServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExcelImportService = AutoDisposeAsyncNotifier<List<ImportRow>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
