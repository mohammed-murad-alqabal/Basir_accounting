import 'package:basir_accounting_system/features/goals/domain/entities/goal.dart';

/// واجهة مستودع الأهداف المالية (Financial Goal Repository)
abstract class GoalRepository {
  /// Get all goals, optionally filtered by user ID.
  Future<List<Goal>> getAllGoals({String? userId});

  /// Get a single goal by its ID.
  Future<Goal?> getGoalById(String id);

  /// Save a new or existing goal.
  Future<void> saveGoal(Goal goal);

  /// Delete a goal by its ID.
  Future<void> deleteGoal(String id);

  /// Update the progress amount of a goal.
  Future<void> updateGoalProgress(String id, double amount);
}
