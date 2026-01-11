import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/vendors/domain/entities/vendor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_provider.g.dart';

/// موفر قائمة الموردين (Vendors Provider)
///
/// يوفر الوصول إلى جميع الموردين المسجلين في النظام
/// مع دعم عمليات CRUD الكاملة.
@riverpod
class Vendors extends _$Vendors {
  @override
  Future<List<Vendor>> build() {
    final repository = ref.watch(vendorRepositoryProvider);
    return repository.getAllVendors();
  }

  /// إضافة مورد جديد.
  Future<void> addVendor(Vendor vendor) async {
    final repository = ref.watch(vendorRepositoryProvider);
    await repository.addVendor(vendor);
    ref.invalidateSelf();
  }

  /// تحديث بيانات مورد موجود.
  Future<void> updateVendor(Vendor vendor) async {
    final repository = ref.watch(vendorRepositoryProvider);
    await repository.updateVendor(vendor);
    ref.invalidateSelf();
  }

  /// حذف مورد بواسطة المعرف.
  Future<void> deleteVendor(String id) async {
    final repository = ref.watch(vendorRepositoryProvider);
    await repository.deleteVendor(id);
    ref.invalidateSelf();
  }
}

/// State Provider لحالة البحث
final vendorSearchProvider = StateProvider<String>((ref) => '');

/// Provider لقائمة الموردين المفلترة حسب البحث
final filteredVendorsProvider = Provider<AsyncValue<List<Vendor>>>((ref) {
  final searchQuery = ref.watch(vendorSearchProvider).toLowerCase();
  final vendorsAsync = ref.watch(vendorsProvider);

  return vendorsAsync.whenData((vendors) {
    if (searchQuery.isEmpty) return vendors;
    return vendors.where((v) {
      final nameAr = v.nameAr.toLowerCase();
      final nameEn = v.nameEn.toLowerCase();
      final email = (v.email ?? '').toLowerCase();
      final phone = (v.phone ?? '').toLowerCase();

      return nameAr.contains(searchQuery) ||
          nameEn.contains(searchQuery) ||
          email.contains(searchQuery) ||
          phone.contains(searchQuery);
    }).toList();
  });
});
