import 'package:basir_accounting_system/features/goals/domain/entities/goal.dart';
import 'package:basir_accounting_system/features/goals/domain/entities/goal_category.dart';
import 'package:decimal/decimal.dart';
import 'package:isar/isar.dart';

part 'goal_model.g.dart';

/// نموذج الهدف المالي الخاص بـ Isar
@Collection()
class GoalModel {
  /// Default constructor for Isar.
  GoalModel();

  /// إنشاء نموذج من الكينونة
  GoalModel.fromEntity(Goal goal) {
    uuid = goal.id;
    name = goal.name;
    category = goal.category;
    targetAmount = goal.targetAmount.toString();
    currentAmount = goal.currentAmount.toString();
    startDate = goal.startDate;
    targetDate = goal.targetDate;
    isActive = goal.isActive;
    description = goal.description;
    userId = goal.userId;
  }

  /// The local Isar ID.
  Id id = Isar.autoIncrement;

  /// The unique UUID of the goal.
  @Index(unique: true)
  late String uuid;

  /// The name of the goal.
  late String name;

  /// The category of the goal.
  @Enumerated(EnumType.name)
  late GoalCategory category;

  /// The target financial amount (stored as String for Decimal precision).
  late String targetAmount;

  /// The current accumulated amount (stored as String for Decimal precision).
  late String currentAmount;

  /// The start date of the goal.
  late DateTime startDate;

  /// The target date for achieving the goal.
  late DateTime targetDate;

  /// Whether the goal is currently active.
  bool isActive = true;

  /// A description of the goal.
  String? description;

  /// The ID of the user who owns this goal.
  String? userId;

  /// تحويل من النموذج (Model) إلى الكينونة (Entity)
  Goal toEntity() => Goal(
        id: uuid,
        name: name,
        category: category,
        targetAmount: Decimal.parse(targetAmount),
        currentAmount: Decimal.parse(currentAmount),
        startDate: startDate,
        targetDate: targetDate,
        isActive: isActive,
        description: description,
        userId: userId,
      );
}
