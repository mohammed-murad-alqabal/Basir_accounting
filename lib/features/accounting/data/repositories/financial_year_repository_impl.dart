import 'package:basir_accounting_system/features/accounting/data/models/financial_year_model.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_year.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/financial_year_repository.dart';
import 'package:isar/isar.dart';

/// تنفيذ مستودع بيانات السنوات المالية باستخدام Isar.
class FinancialYearRepositoryImpl implements FinancialYearRepository {
  /// إنشاء نسخة جديدة مع تمرير مثيل Isar.
  FinancialYearRepositoryImpl({required this.isar, required this.userId});

  /// مثيل قاعدة بيانات Isar.
  final Isar isar;

  /// معرف المستخدم لعزل البيانات.
  final String? userId;

  @override
  Future<FinancialYear?> getCurrentFinancialYear() async {
    final model = await isar.financialYearModels
        .filter()
        .userIdEqualTo(userId)
        .and()
        .isClosedEqualTo(false)
        .sortByStartDateDesc()
        .findFirst();
    return model?.toEntity();
  }

  @override
  Future<FinancialYear?> getFinancialYearByDate(DateTime date) async {
    final model = await isar.financialYearModels
        .filter()
        .userIdEqualTo(userId)
        .and()
        .startDateLessThan(date, include: true)
        .and()
        .endDateGreaterThan(date, include: true)
        .findFirst();
    return model?.toEntity();
  }

  @override
  Future<List<FinancialYear>> getAllFinancialYears() async {
    final models =
        await isar.financialYearModels.filter().userIdEqualTo(userId).findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> saveFinancialYear(FinancialYear year) async {
    final model = FinancialYearModel.fromEntity(year.copyWith(userId: userId));
    // البحث عن السجل الحالي إذا وجد لتحديثه
    final existing = await isar.financialYearModels
        .filter()
        .idEqualTo(year.id)
        .and()
        .userIdEqualTo(userId)
        .findFirst();
    if (existing != null) {
      model.isarId = existing.isarId;
    }
    await isar.writeTxn(() async {
      await isar.financialYearModels.put(model);
    });
  }

  @override
  Future<void> closeFinancialYear(String id, String userId) async {
    await isar.writeTxn(() async {
      final model = await isar.financialYearModels
          .filter()
          .idEqualTo(id)
          .and()
          .userIdEqualTo(userId)
          .findFirst();
      if (model != null) {
        model.isClosed = true;
        model.closedAt = DateTime.now();
        model.closedBy = userId;
        await isar.financialYearModels.put(model);
      }
    });
  }

  @override
  Future<bool> isPeriodOpen(DateTime date) async {
    final year = await getFinancialYearByDate(date);
    if (year == null) return false;
    if (year.isClosed) return false;

    final periodId = '${date.year}-${date.month.toString().padLeft(2, '0')}';
    return !year.lockedPeriodIds.contains(periodId);
  }
}
