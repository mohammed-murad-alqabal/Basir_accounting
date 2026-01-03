import 'package:basir_app/core/providers.dart';
import 'package:basir_app/features/vendors/domain/entities/vendor.dart';
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
