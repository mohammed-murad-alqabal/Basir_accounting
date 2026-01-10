import 'package:basir_app/features/vendors/data/models/vendor_model.dart';
import 'package:basir_app/features/vendors/domain/entities/vendor.dart';
import 'package:basir_app/features/vendors/domain/repositories/vendor_repository.dart';
import 'package:isar/isar.dart';

/// تنفيذ مستودع الموردين باستخدام Isar (Vendor Repository Implementation)
class VendorRepositoryImpl implements VendorRepository {
  /// إنشاء تنفيذ مستودع الموردين.
  VendorRepositoryImpl({required this.isar, required this.userId});

  /// قاعدة بيانات Isar.
  final Isar isar;

  /// معرف المستخدم لعزل البيانات.
  final String? userId;

  @override
  Future<List<Vendor>> getAllVendors() async {
    final models =
        await isar.vendorModels.filter().userIdEqualTo(userId).findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Vendor?> getVendorById(String id) async {
    final model = await isar.vendorModels
        .filter()
        .vendorIdEqualTo(id)
        .and()
        .userIdEqualTo(userId)
        .findFirst();
    return model?.toEntity();
  }

  @override
  Future<void> addVendor(Vendor vendor) async {
    await isar.writeTxn(() async {
      await isar.vendorModels.put(
        VendorModel.fromEntity(vendor.copyWith(userId: userId)),
      );
    });
  }

  @override
  Future<void> updateVendor(Vendor vendor) async {
    await isar.writeTxn(() async {
      final existing = await isar.vendorModels
          .filter()
          .vendorIdEqualTo(vendor.id)
          .and()
          .userIdEqualTo(userId)
          .findFirst();
      if (existing != null) {
        final model = VendorModel.fromEntity(vendor.copyWith(userId: userId));
        model.id = existing.id;
        await isar.vendorModels.put(model);
      }
    });
  }

  @override
  Future<void> deleteVendor(String id) async {
    await isar.writeTxn(() async {
      await isar.vendorModels
          .filter()
          .vendorIdEqualTo(id)
          .and()
          .userIdEqualTo(userId)
          .deleteFirst();
    });
  }

  @override
  Future<List<Vendor>> searchVendors(String query) async {
    final models = await isar.vendorModels
        .filter()
        .userIdEqualTo(userId)
        .and()
        .group(
          (q) => q
              .nameArContains(query, caseSensitive: false)
              .or()
              .nameEnContains(query, caseSensitive: false),
        )
        .findAll();
    return models.map((m) => m.toEntity()).toList();
  }
}
