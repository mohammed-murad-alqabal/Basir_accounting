import 'package:basir_accounting_system/features/accounting/data/models/financial_voucher_model.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_voucher.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/financial_voucher_repository.dart';
import 'package:isar/isar.dart';

/// تطبيق مستودع السندات المالية باستخدام Isar.
class FinancialVoucherRepositoryImpl implements FinancialVoucherRepository {
  /// إنشاء تطبيق مستودع السندات المالية.
  FinancialVoucherRepositoryImpl({required this.isar, required this.userId});

  /// محرك قاعدة البيانات Isar.
  final Isar isar;

  /// معرف المستخدم لعزل البيانات.
  final String? userId;

  @override
  Future<List<FinancialVoucher>> getAllVouchers() async {
    final models = await isar.financialVoucherModels
        .filter()
        .userIdEqualTo(userId)
        .findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<FinancialVoucher?> getVoucherById(String id) async {
    final model = await isar.financialVoucherModels
        .filter()
        .idEqualTo(id)
        .and()
        .userIdEqualTo(userId)
        .findFirst();
    return model?.toEntity();
  }

  @override
  Future<void> addVoucher(FinancialVoucher voucher) async {
    final model = FinancialVoucherModel.fromEntity(
      voucher.copyWith(userId: userId),
    );
    await isar.writeTxn(() async {
      await isar.financialVoucherModels.put(model);
    });
  }

  @override
  Future<void> updateVoucher(FinancialVoucher voucher) async {
    final existingModel = await isar.financialVoucherModels
        .filter()
        .idEqualTo(voucher.id)
        .and()
        .userIdEqualTo(userId)
        .findFirst();
    if (existingModel != null) {
      final newModel = FinancialVoucherModel.fromEntity(
        voucher.copyWith(userId: userId),
      )..isarId = existingModel.isarId;
      await isar.writeTxn(() async {
        await isar.financialVoucherModels.put(newModel);
      });
    }
  }

  @override
  Future<void> deleteVoucher(String id) async {
    await isar.writeTxn(() async {
      await isar.financialVoucherModels
          .filter()
          .idEqualTo(id)
          .and()
          .userIdEqualTo(userId)
          .deleteFirst();
    });
  }
}
