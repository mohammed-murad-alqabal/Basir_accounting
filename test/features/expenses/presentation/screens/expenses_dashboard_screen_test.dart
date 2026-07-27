import 'package:basir_accounting_system/features/expenses/application/expense_service.dart';
import 'package:basir_accounting_system/features/expenses/domain/entities/expense.dart';
import 'package:basir_accounting_system/features/expenses/domain/repositories/expense_repository.dart';
import 'package:basir_accounting_system/features/expenses/presentation/screens/expense_form_screen.dart';
import 'package:basir_accounting_system/features/expenses/presentation/screens/expenses_dashboard_screen.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<ExpenseService>()])
import 'expenses_dashboard_screen_test.mocks.dart';

void main() {
  late MockExpenseService mockService;

  setUp(() {
    mockService = MockExpenseService();
  });

  Widget createSubject() => ProviderScope(
        overrides: [
          expenseServiceProvider.overrideWithValue(mockService),
        ],
        child: const MaterialApp(
          home: ExpensesDashboardScreen(),
        ),
      );

  group('ExpensesDashboardScreen', () {
    final testExpense = Expense(
      id: '1',
      description: 'Office Rent',
      amount: Decimal.parse('5000'),
      currencyCode: 'SAR',
      expenseDate: DateTime.now(),
      categoryId: 'cat_rent',
    );

    const testSummary = ExpenseSummary(
      totalAmount: 5000,
      count: 1,
      averageAmount: 5000,
      byCategory: {'cat_rent': 5000},
      byMonth: {'2026-01': 5000},
    );

    final testCategories = [
      const ExpenseCategory(
        id: 'cat_rent',
        name: 'Rent',
        nameAr: 'الإيجار',
        icon: 'home',
        color: '#9C27B0',
      ),
    ];

    testWidgets('renders loading state initially', (tester) async {
      when(mockService.getCurrentMonthExpenses()).thenAnswer(
        (_) async => [],
      );
      when(
        mockService.getExpenseSummary(
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
        ),
      ).thenAnswer(
        (_) async => ExpenseSummary.empty(),
      );
      when(mockService.getCategories()).thenAnswer(
        (_) async => [],
      );

      await tester.pumpWidget(createSubject());

      expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
    });

    testWidgets('renders summary cards and expense list when data loaded',
        (tester) async {
      when(mockService.getCurrentMonthExpenses()).thenAnswer(
        (_) async => [testExpense],
      );
      when(
        mockService.getExpenseSummary(
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
        ),
      ).thenAnswer(
        (_) async => testSummary,
      );
      when(mockService.getCategories()).thenAnswer(
        (_) async => testCategories,
      );

      await tester.pumpWidget(createSubject());
      await tester.pumpAndSettle();

      // Check Summary Cards
      expect(find.text('SAR 5,000.00'), findsWidgets); // Total and Item
      expect(find.text('1'), findsAtLeastNWidgets(1)); // Count

      // Check List Item
      expect(find.text('Office Rent'), findsOneWidget);
    });

    testWidgets('navigates to add screen when FAB tapped', (tester) async {
      when(mockService.getCurrentMonthExpenses()).thenAnswer(
        (_) async => [],
      );
      when(
        mockService.getExpenseSummary(
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
        ),
      ).thenAnswer(
        (_) async => ExpenseSummary.empty(),
      );
      when(mockService.getCategories()).thenAnswer(
        (_) async => [],
      );

      await tester.pumpWidget(createSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.byType(ExpenseFormScreen), findsOneWidget);
    });
  });
}
