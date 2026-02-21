import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/goals/domain/entities/goal.dart';
import 'package:basir_accounting_system/features/goals/domain/entities/goal_category.dart';
import 'package:basir_accounting_system/features/goals/presentation/screens/goal_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة لوحة تحكم الأهداف المالية (PRD GOL-*)
class GoalDashboardScreen extends ConsumerWidget {
  /// Creates the [GoalDashboardScreen].
  const GoalDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalService = ref.watch(goalServiceProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: const Text(
          'الأهداف المالية',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1F24),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task_outlined, color: Color(0xFF008080)),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const GoalFormScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Goal>>(
        future: goalService.getActiveGoals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF008080)),
            );
          }

          final goals = snapshot.data ?? [];
          if (goals.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: goals.length,
            itemBuilder: (context, index) => _GoalCard(goal: goals[index]),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flag_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              'لم تضع أي أهداف بعد',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('ابدأ بتحديد أهدافك المالية للإنجاز بذكاء'),
          ],
        ),
      );
}

class _GoalCard extends ConsumerWidget {
  const _GoalCard({required this.goal});
  final Goal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(goalServiceProvider);
    final percentage = goal.progressPercentage / 100;
    final monthlySavings = service.getRequiredMonthlySavings(goal);

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
              children: [
                _buildCategoryIcon(goal.category),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${goal.targetDate.year}-'
                        '${goal.targetDate.month}-${goal.targetDate.day}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
                if (goal.isAchieved)
                  const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الموفر: ${goal.currentAmount}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'المستهدف: ${goal.targetAmount}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: percentage.clamp(0.0, 1.0),
                minHeight: 12,
                backgroundColor: Colors.grey[100],
                valueColor: AlwaysStoppedAnimation<Color>(
                  goal.isAchieved ? Colors.green : const Color(0xFF008080),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!goal.isAchieved)
                  Text(
                    'المطلوب شهرياً: $monthlySavings',
                    style: const TextStyle(
                      color: Color(0xFF008080),
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else
                  const Text(
                    'تم تحقيق الهدف!',
                    style: TextStyle(
                      color: Colors.green,
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

  Widget _buildCategoryIcon(GoalCategory category) {
    IconData icon;
    switch (category) {
      case GoalCategory.emergencyFund:
        icon = Icons.emergency;
      case GoalCategory.savings:
        icon = Icons.savings;
      case GoalCategory.investment:
        icon = Icons.trending_up;
      case GoalCategory.bigPurchase:
        icon = Icons.shopping_cart;
      case GoalCategory.debtRepayment:
        icon = Icons.money_off;
      case GoalCategory.travel:
        icon = Icons.flight;
      case GoalCategory.other:
        icon = Icons.flag;
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
}
