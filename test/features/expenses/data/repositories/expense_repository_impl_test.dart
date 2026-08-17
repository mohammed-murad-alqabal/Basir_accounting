import 'package:basir_accounting_system/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:basir_accounting_system/features/expenses/domain/entities/expense.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ExpenseRepositoryImpl repository;

  setUp(() {
    repository = ExpenseRepositoryImpl();
  });

  group('ExpenseRepositoryImpl', () {
    test('يفلتر المصروفات ويرتبها ويجمعها بحسب الفئة والشهر', () async {
      await repository.createExpense(
        _expense(
          id: 'utilities-aug',
          date: DateTime.utc(2026, 8, 5),
          amount: '120.50',
        ),
      );
      await repository.createExpense(
        _expense(
          id: 'rent-aug',
          date: DateTime.utc(2026, 8, 20),
          amount: '900',
          categoryId: 'cat_rent',
          status: 'approved',
        ),
      );
      await repository.createExpense(
        _expense(
          id: 'utilities-sep',
          date: DateTime.utc(2026, 9),
          amount: '80',
        ),
      );

      final augustRent = await repository.getExpenses(
        startDate: DateTime.utc(2026, 8),
        endDate: DateTime.utc(2026, 8, 31),
        categoryId: 'cat_rent',
        status: 'approved',
      );
      expect(augustRent.map((expense) => expense.id), ['rent-aug']);

      final sorted = await repository.getExpenses();
      expect(sorted.map((expense) => expense.id), [
        'utilities-sep',
        'rent-aug',
        'utilities-aug',
      ]);
      expect(
        (await repository.getExpensesByCategory('cat_utilities')).map(
          (expense) => expense.id,
        ),
        ['utilities-aug', 'utilities-sep'],
      );

      final summary = await repository.getExpenseSummary(
        startDate: DateTime.utc(2026, 8),
        endDate: DateTime.utc(2026, 8, 31),
      );
      expect(summary.totalAmount, 1020.5);
      expect(summary.count, 2);
      expect(summary.averageAmount, 510.25);
      expect(summary.byCategory, {'cat_utilities': 120.5, 'cat_rent': 900.0});
      expect(summary.byMonth, {'2026-08': 1020.5});
      expect(
        await repository.getExpensesByCategories(
          startDate: DateTime.utc(2026, 8),
          endDate: DateTime.utc(2026, 8, 31),
        ),
        summary.byCategory,
      );
      expect(
        await repository.getExpenseSummary(
          startDate: DateTime.utc(2025),
          endDate: DateTime.utc(2025, 12, 31),
        ),
        isA<Object>(),
      );
    });

    test(
        'يحدّث المصروف وينشئ معرفاً عند غيابه ويحافظ على الفئات الافتراضية النشطة',
        () async {
      final generated = await repository.createExpense(
        _expense(id: '', date: DateTime.utc(2026, 8, 10), amount: '50'),
      );
      expect(generated.id, isNotEmpty);
      expect(generated.createdAt, isNotNull);
      expect(generated.updatedAt, isNotNull);

      final updated = await repository.updateExpense(
        generated.copyWith(
          description: 'فاتورة كهرباء معدلة',
          amount: Decimal.fromInt(75),
        ),
      );
      expect(updated.description, 'فاتورة كهرباء معدلة');
      expect(
        (await repository.getExpenseById(generated.id))?.amount,
        Decimal.fromInt(75),
      );
      expect(await repository.getCategories(), isNotEmpty);

      await expectLater(
        repository.updateExpense(
          _expense(id: 'missing', date: DateTime.utc(2026), amount: '1'),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('يرحل المصروف مرة واحدة ويحمي المصروف المرحل من الحذف', () async {
      await repository.createExpense(
        _expense(id: 'post-me', date: DateTime.utc(2026, 8, 15), amount: '300'),
      );
      await repository.createExpense(
        _expense(
          id: 'delete-me',
          date: DateTime.utc(2026, 8, 16),
          amount: '20',
        ),
      );

      await expectLater(
        repository.postToLedger('missing'),
        throwsA(isA<Exception>()),
      );
      final posted = await repository.postToLedger('post-me');
      expect(posted.status, 'posted');
      expect(posted.journalEntryId, isNotNull);
      await expectLater(
        repository.postToLedger('post-me'),
        throwsA(isA<Exception>()),
      );
      await expectLater(
        repository.deleteExpense('post-me'),
        throwsA(isA<Exception>()),
      );

      expect(await repository.deleteExpense('delete-me'), isTrue);
      expect(await repository.deleteExpense('delete-me'), isFalse);
    });
  });
}

Expense _expense({
  required String id,
  required DateTime date,
  required String amount,
  String categoryId = 'cat_utilities',
  String status = 'pending',
}) =>
    Expense(
      id: id,
      description: 'مصروف تشغيلي',
      amount: Decimal.parse(amount),
      currencyCode: 'SAR',
      expenseDate: date,
      categoryId: categoryId,
      status: status,
    );
