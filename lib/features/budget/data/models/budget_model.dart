import 'package:basir_accounting_system/features/budget/domain/entities/budget.dart';
import 'package:basir_accounting_system/features/budget/domain/entities/budget_category.dart';
import 'package:decimal/decimal.dart';
import 'package:isar/isar.dart';

part 'budget_model.g.dart';

/// نموذج بيانات ميزانية Isar (Data Layer Model)
@collection
class BudgetModel {
  /// Default constructor for Isar.
  BudgetModel();

  /// إنشاء نموذج من الكينونة
  BudgetModel.fromEntity(Budget budget) {
    budgetId = budget.id;
    name = budget.name;
    category = budget.category;
    limitAmountStr = budget.limitAmount.toString();
    spentAmountStr = budget.spentAmount.toString();
    startDate = budget.startDate;
    endDate = budget.endDate;
    alertThreshold = budget.alertThreshold;
    isRollover = budget.isRollover;
    isActive = budget.isActive;
    userId = budget.userId;
  }

  /// المعرف الذاتي لـ Isar
  Id id = Isar.autoIncrement;

  /// المعرف الفريد للميزانية (UUID)
  @Index(unique: true)
  late String budgetId;

  /// اسم الميزانية
  late String name;

  /// التصنيف
  @enumerated
  late BudgetCategory category;

  /// القيمة القصوى كنص
  late String limitAmountStr;

  /// المبلغ المصروف كنص
  late String spentAmountStr;

  /// تاريخ البدء
  late DateTime startDate;

  /// تاريخ الانتهاء
  late DateTime endDate;

  /// عتبة التنبيه
  late double alertThreshold;

  /// خيار الترحيل
  late bool isRollover;

  /// نشط أم لا
  late bool isActive;

  /// معرف المستخدم
  String? userId;

  /// تحويل إلى كائن Domain
  Budget toEntity() => Budget(
        id: budgetId,
        name: name,
        category: category,
        limitAmount: Decimal.parse(limitAmountStr),
        spentAmount: Decimal.parse(spentAmountStr),
        startDate: startDate,
        endDate: endDate,
        alertThreshold: alertThreshold,
        isRollover: isRollover,
        isActive: isActive,
        userId: userId,
      );
}
