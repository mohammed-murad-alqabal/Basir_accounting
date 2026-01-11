import 'package:basir_accounting_system/features/vendors/domain/entities/vendor.dart';

/// واجهة مستودع الموردين (Vendor Repository Interface)
abstract class VendorRepository {
  /// الحصول على كل الموردين.
  Future<List<Vendor>> getAllVendors();

  /// الحصول على مورد بواسطة المعرف.
  Future<Vendor?> getVendorById(String id);

  /// إضافة مورد جديد.
  Future<void> addVendor(Vendor vendor);

  /// تحديث بيانات مورد.
  Future<void> updateVendor(Vendor vendor);

  /// حذف مورد.
  Future<void> deleteVendor(String id);

  /// البحث عن موردين.
  Future<List<Vendor>> searchVendors(String query);
}
