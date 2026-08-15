import 'package:basir_accounting_system/features/goals/domain/entities/goal.dart';
import 'package:basir_accounting_system/features/goals/domain/entities/goal_category.dart';
import 'package:basir_accounting_system/features/goals/domain/repositories/goal_repository.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:decimal/decimal.dart';

/// مكيّف تجريبي لـGoalRepository باستخدام Drift.
///
/// لا يُسجل في Riverpod؛ يبقى Isar التنفيذ النشط حتى اجتياز موجة parity.
class DriftGoalRepository implements GoalRepository {
  DriftGoalRepository(BasirDatabase database, {this.userId})
      : _storage = GoalStore(database);

  /// منشئ اختبار/حقن يحافظ على عزل domain عن أنواع Drift.
  DriftGoalRepository.withStorage(this._storage, {this.userId});

  final GoalStorage _storage;
  final String? userId;

  @override
  Future<List<Goal>> getAllGoals({String? userId}) async {
    final records = await _storage.readAllForUser(userId ?? this.userId);
    return records.map(_toEntity).toList(growable: false);
  }

  @override
  Future<Goal?> getGoalById(String id) async {
    final record = await _storage.readById(id, userId);
    return record == null ? null : _toEntity(record);
  }

  @override
  Future<void> saveGoal(Goal goal) => _storage.save(
        _toRecord(
          Goal(
            id: goal.id,
            name: goal.name,
            category: goal.category,
            targetAmount: goal.targetAmount,
            currentAmount: goal.currentAmount,
            startDate: goal.startDate,
            targetDate: goal.targetDate,
            isActive: goal.isActive,
            description: goal.description,
            userId: userId,
          ),
        ),
      );

  @override
  Future<void> deleteGoal(String id) => _storage.deleteById(id, userId);

  @override
  Future<void> updateGoalProgress(String id, double amount) =>
      _storage.updateProgress(id, userId, amount.toString());

  static GoalRecord _toRecord(Goal goal) => GoalRecord(
        id: goal.id,
        name: goal.name,
        category: goal.category.name,
        targetAmount: goal.targetAmount.toString(),
        currentAmount: goal.currentAmount.toString(),
        startDate: goal.startDate,
        targetDate: goal.targetDate,
        isActive: goal.isActive,
        description: goal.description,
        userId: goal.userId,
      );

  static Goal _toEntity(GoalRecord record) => Goal(
        id: record.id,
        name: record.name,
        category: _categoryFromStorage(record.category),
        targetAmount: Decimal.parse(record.targetAmount),
        currentAmount: Decimal.parse(record.currentAmount),
        startDate: record.startDate,
        targetDate: record.targetDate,
        isActive: record.isActive,
        description: record.description,
        userId: record.userId,
      );

  static GoalCategory _categoryFromStorage(String value) =>
      GoalCategory.values.firstWhere(
        (category) => category.name == value,
        orElse: () => throw StateError('Unsupported goal category: $value'),
      );
}
