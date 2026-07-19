// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/budget/domain/entities/budget.dart';
import 'package:basir_accounting_system/features/budget/domain/entities/budget_category.dart';
import 'package:basir_accounting_system/features/budget/presentation/screens/budget_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة لوحة تحكم الميزانيات (PRD BUD-001)
/// تصميم مميز (Teal & White) مع تجربة مستخدم فاخرة.
class BudgetDashboardScreen extends ConsumerWidget {
  /// Creates the [BudgetDashboardScreen].
  const BudgetDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetService = ref.watch(budgetServiceProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: const Text(
          'الميزانيات الشخصية',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1F24),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon:
                const Icon(Icons.add_circle_outline, color: Color(0xFF008080)),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const BudgetFormScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Budget>>(
        future: budgetService.getActiveBudgets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF008080)),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          }

          final budgets = snapshot.data ?? [];

          if (budgets.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: budgets.length,
            itemBuilder: (context, index) {
              final budget = budgets[index];
              return _BudgetCard(budget: budget);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            const Text(
              'لا توجد ميزانيات نشطة',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const BudgetFormScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008080),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('إنشاء ميزانيتك الأولى'),
            ),
          ],
        ),
      );
}

class _BudgetCard extends ConsumerWidget {
  const _BudgetCard({required this.budget});
  final Budget budget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(budgetServiceProvider);
    final percentage = service.getSpentPercentage(budget) / 100;
    final isAlert = service.isAlertTriggered(budget);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildCategoryIcon(budget.category),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          budget.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1F24),
                          ),
                        ),
                        Text(
                          _getCategoryName(budget.category),
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
                if (isAlert)
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.redAccent,
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'المصروف: ${budget.spentAmount}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'الهدف: ${budget.limitAmount}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: percentage.clamp(0.0, 1.0),
                minHeight: 10,
                backgroundColor: Colors.grey[100],
                valueColor: AlwaysStoppedAnimation<Color>(
                  isAlert ? Colors.redAccent : const Color(0xFF008080),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'المتبقي: ${service.getRemainingAmount(budget)}',
                  style: TextStyle(
                    color: isAlert ? Colors.redAccent : const Color(0xFF008080),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${(percentage * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(BudgetCategory category) {
    IconData icon;
    switch (category) {
      case BudgetCategory.food:
        icon = Icons.restaurant;
      case BudgetCategory.transportation:
        icon = Icons.directions_car;
      case BudgetCategory.housing:
        icon = Icons.home;
      case BudgetCategory.utilities:
        icon = Icons.electrical_services;
      case BudgetCategory.entertainment:
        icon = Icons.movie_outlined;
      case BudgetCategory.health:
        icon = Icons.medical_services_outlined;
      case BudgetCategory.savings:
        icon = Icons.savings_outlined;
      case BudgetCategory.insurance:
        icon = Icons.security;
      case BudgetCategory.personal:
        icon = Icons.person_outline;
      case BudgetCategory.education:
        icon = Icons.school_outlined;
      case BudgetCategory.debt:
        icon = Icons.credit_card_off;
      case BudgetCategory.other:
        icon = Icons.category_outlined;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: const Color(0xFF008080)),
    );
  }

  String _getCategoryName(BudgetCategory category) {
    switch (category) {
      case BudgetCategory.food:
        return 'طعام وشراب';
      case BudgetCategory.transportation:
        return 'مواصلات';
      case BudgetCategory.housing:
        return 'سكن';
      case BudgetCategory.utilities:
        return 'خدمات';
      case BudgetCategory.savings:
        return 'ادخار';
      case BudgetCategory.health:
        return 'صحة';
      case BudgetCategory.insurance:
        return 'تأمين';
      case BudgetCategory.personal:
        return 'شخصي';
      case BudgetCategory.entertainment:
        return 'ترفيه';
      case BudgetCategory.education:
        return 'تعليم';
      case BudgetCategory.debt:
        return 'ديون';
      case BudgetCategory.other:
        return 'أخرى';
    }
  }
}
