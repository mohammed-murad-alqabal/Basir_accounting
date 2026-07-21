import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/goals/domain/entities/goal.dart';
import 'package:basir_accounting_system/features/goals/domain/entities/goal_category.dart';
import 'package:basir_accounting_system/features/goals/presentation/screens/goal_form_screen.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة لوحة تحكم الأهداف المالية (PRD GOL-*)
class GoalDashboardScreen extends ConsumerWidget {
  /// Creates the [GoalDashboardScreen].
  const GoalDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalService = ref.watch(goalServiceProvider);

    return GlassScaffold(
      title: 'الأهداف المالية',
      actions: [
        IconButton(
          icon: const Icon(Icons.add_task_outlined, size: 26),
          tooltip: 'إضافة هدف مالي',
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
      body: FutureBuilder<List<Goal>>(
        future: goalService.getActiveGoals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: AppLoadingIndicator(),
            );
          }

          if (snapshot.hasError) {
            return AppErrorWidget(
              message: 'حدث خطأ: ${snapshot.error}',
              onRetry: () => ref.refresh(goalServiceProvider),
            );
          }

          final goals = snapshot.data ?? [];
          if (goals.isEmpty) {
            return AppEmptyState(
              title: 'لم تضع أي أهداف بعد',
              description: 'ابدأ بتحديد أهدافك المالية للإنجاز بذكاء.',
              icon: Icons.flag_outlined,
              actionLabel: 'إنشاء أول هدف',
              onActionPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const GoalFormScreen(),
                  ),
                );
              },
            );
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
}

class _GoalCard extends ConsumerWidget {
  const _GoalCard({required this.goal});
  final Goal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(goalServiceProvider);
    final percentage = goal.progressPercentage / 100;
    final monthlySavings = service.getRequiredMonthlySavings(goal);

    return AppCard(
      margin: const EdgeInsets.only(bottom: 16),
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
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${goal.targetDate.year}-'
                      '${goal.targetDate.month}-${goal.targetDate.day}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (goal.isAchieved)
                const Icon(Icons.check_circle, color: AppColors.success),
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
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage.clamp(0.0, 1.0),
              minHeight: 12,
              backgroundColor: AppColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                goal.isAchieved ? AppColors.success : AppColors.primary,
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
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                )
              else
                const Text(
                  'تم تحقيق الهدف!',
                  style: TextStyle(
                    color: AppColors.success,
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
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: AppColors.primary),
    );
  }
}
