import 'package:basir_accounting_system/features/budget/domain/entities/budget.dart';
import 'package:basir_accounting_system/features/budget/domain/entities/budget_category.dart';
import 'package:basir_accounting_system/features/budget/domain/repositories/budget_repository.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:decimal/decimal.dart';

/// مكيّف تجريبي لـBudgetRepository باستخدام Drift.
///
/// لا يُسجل في Riverpod؛ يبقى Isar التنفيذ النشط حتى اجتياز موجة parity.
class DriftBudgetRepository implements BudgetRepository {
  DriftBudgetRepository(BasirDatabase database, {this.userId})
      : _storage = BudgetStore(database);

  /// منشئ اختبار/حقن يحافظ على عزل domain عن أنواع Drift.
  DriftBudgetRepository.withStorage(this._storage, {this.userId});

  final BudgetStorage _storage;
  final String? userId;

  @override
  Future<List<Budget>> getBudgets() async {
    final records = await _storage.readAllForUser(userId);
    return records.map(_toEntity).toList(growable: false);
  }

  @override
  Future<Budget?> getBudget(String id) async {
    final record = await _storage.readById(id, userId);
    return record == null ? null : _toEntity(record);
  }

  @override
  Future<void> saveBudget(Budget budget) => _storage.save(
        _toRecord(
          Budget(
            id: budget.id,
            name: budget.name,
            category: budget.category,
            limitAmount: budget.limitAmount,
            startDate: budget.startDate,
            endDate: budget.endDate,
            spentAmount: budget.spentAmount,
            alertThreshold: budget.alertThreshold,
            isRollover: budget.isRollover,
            isActive: budget.isActive,
            userId: userId,
          ),
        ),
      );

  @override
  Future<void> deleteBudget(String id) => _storage.deleteById(id, userId);

  static BudgetRecord _toRecord(Budget budget) => BudgetRecord(
        id: budget.id,
        name: budget.name,
        category: budget.category.name,
        limitAmount: budget.limitAmount.toString(),
        spentAmount: budget.spentAmount.toString(),
        startDate: budget.startDate,
        endDate: budget.endDate,
        alertThreshold: budget.alertThreshold,
        isRollover: budget.isRollover,
        isActive: budget.isActive,
        userId: budget.userId,
      );

  static Budget _toEntity(BudgetRecord record) => Budget(
        id: record.id,
        name: record.name,
        category: _categoryFromStorage(record.category),
        limitAmount: Decimal.parse(record.limitAmount),
        startDate: record.startDate,
        endDate: record.endDate,
        spentAmount: Decimal.parse(record.spentAmount),
        alertThreshold: record.alertThreshold,
        isRollover: record.isRollover,
        isActive: record.isActive,
        userId: record.userId,
      );

  static BudgetCategory _categoryFromStorage(String value) =>
      BudgetCategory.values.firstWhere(
        (category) => category.name == value,
        orElse: () => throw StateError('Unsupported budget category: $value'),
      );
}
