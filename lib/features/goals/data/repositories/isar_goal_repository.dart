import 'package:basir_accounting_system/features/goals/data/models/goal_model.dart';
import 'package:basir_accounting_system/features/goals/domain/entities/goal.dart';
import 'package:basir_accounting_system/features/goals/domain/repositories/goal_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:isar/isar.dart';

/// تنفيذ مستودع الأهداف المالية باستخدام Isar
class IsarGoalRepository implements GoalRepository {
  /// Creates an instance of [IsarGoalRepository].
  IsarGoalRepository(this._isar, {String? userId}) : _userId = userId;

  final Isar _isar;
  final String? _userId;

  @override
  Future<List<Goal>> getAllGoals({String? userId}) async {
    final effectiveUserId = userId ?? _userId;

    List<GoalModel> models;
    if (effectiveUserId != null) {
      models = await _isar.goalModels
          .filter()
          .userIdEqualTo(effectiveUserId)
          .findAll();
    } else {
      models = await _isar.goalModels.where().findAll();
    }

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Goal?> getGoalById(String id) async {
    final model = await _isar.goalModels.where().uuidEqualTo(id).findFirst();
    return model?.toEntity();
  }

  @override
  Future<void> saveGoal(Goal goal) async {
    final model = GoalModel.fromEntity(goal);

    // Check if exists
    final existing =
        await _isar.goalModels.where().uuidEqualTo(goal.id).findFirst();
    if (existing != null) {
      model.id = existing.id;
    }

    await _isar.writeTxn(() async {
      await _isar.goalModels.put(model);
    });
  }

  @override
  Future<void> deleteGoal(String id) async {
    await _isar.writeTxn(() async {
      await _isar.goalModels.where().uuidEqualTo(id).deleteAll();
    });
  }

  @override
  Future<void> updateGoalProgress(String id, double amount) async {
    final model = await _isar.goalModels.where().uuidEqualTo(id).findFirst();
    if (model != null) {
      final current = Decimal.parse(model.currentAmount);
      final newAmount = current + Decimal.parse(amount.toString());
      model.currentAmount = newAmount.toString();

      await _isar.writeTxn(() async {
        await _isar.goalModels.put(model);
      });
    }
  }
}
