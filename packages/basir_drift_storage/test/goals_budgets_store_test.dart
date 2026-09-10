import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BasirDatabase database;
  late GoalStore goals;
  late BudgetStore budgets;

  setUp(() {
    database = BasirDatabase(NativeDatabase.memory());
    goals = GoalStore(database);
    budgets = BudgetStore(database);
  });

  tearDown(() => database.close());

  test('keeps goals isolated and updates Decimal progress exactly', () async {
    await goals.save(_goal(id: 'goal-a', userId: 'user-a'));
    await goals.save(_goal(id: 'goal-a', userId: 'user-b'));

    await goals.updateProgress('goal-a', 'user-a', '0.10');

    final userA = await goals.readAllForUser('user-a');
    final userB = await goals.readAllForUser('user-b');

    expect(userA, hasLength(1));
    expect(userA.single.currentAmount, '1.35');
    expect(userB.single.currentAmount, '1.25');
    expect(await goals.readById('goal-a', null), isNull);
  });

  test(
      'keeps budgets isolated, preserves Decimal strings, and deletes one scope',
      () async {
    await budgets.save(_budget(id: 'budget-a', userId: 'user-a'));
    await budgets.save(
      _budget(id: 'budget-a', userId: 'user-b', spentAmount: '2.500'),
    );
    await budgets.save(
      _budget(id: 'budget-a', userId: 'user-a', spentAmount: '3.750'),
    );

    final userA = await budgets.readAllForUser('user-a');
    final userB = await budgets.readAllForUser('user-b');

    expect(userA, hasLength(1));
    expect(userA.single.spentAmount, '3.750');
    expect(userB.single.spentAmount, '2.500');

    await budgets.deleteById('budget-a', 'user-a');

    expect(await budgets.readById('budget-a', 'user-a'), isNull);
    expect(await budgets.readById('budget-a', 'user-b'), isNotNull);
  });
}

GoalRecord _goal({required String id, required String? userId}) => GoalRecord(
      id: id,
      name: 'Emergency fund',
      category: 'emergencyFund',
      targetAmount: '10.00',
      currentAmount: '1.25',
      startDate: DateTime.utc(2026),
      targetDate: DateTime.utc(2026, 12),
      isActive: true,
      description: null,
      userId: userId,
    );

BudgetRecord _budget({
  required String id,
  required String? userId,
  String spentAmount = '1.250',
}) =>
    BudgetRecord(
      id: id,
      name: 'January budget',
      category: 'housing',
      limitAmount: '100.000',
      spentAmount: spentAmount,
      startDate: DateTime.utc(2026),
      endDate: DateTime.utc(2026, 1, 31),
      alertThreshold: 0.8,
      isRollover: false,
      isActive: true,
      userId: userId,
    );
