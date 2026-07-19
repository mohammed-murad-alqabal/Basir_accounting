// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/color_tokens.dart';
import 'package:basir_accounting_system/core/theme/tokens/spacing_tokens.dart';
import 'package:basir_accounting_system/core/theme/tokens/typography_tokens.dart';
import 'package:basir_accounting_system/features/accounting/application/financial_year_service.dart';
import 'package:basir_accounting_system/features/accounting/data/models/financial_year_model.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_year.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Administrative screen for managing fiscal years and period locking.
class FiscalControlCenterScreen extends ConsumerWidget {
  /// The constructor for [FiscalControlCenterScreen].
  const FiscalControlCenterScreen({super.key});

  /// The route name for this screen.
  static const routeName = '/fiscal-control-center';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isar = ref.watch(isarProvider).value;

    return GlassScaffold(
      title: 'Fiscal Control Center',
      body: StreamBuilder<List<FinancialYear>>(
        stream: isar?.financialYearModels.watchLazy().asyncMap(
                  (_) => ref
                      .read(financialYearRepositoryProvider)
                      .getAllFinancialYears(),
                ) ??
            Stream.value([]),
        builder: (context, snapshot) {
          final years = snapshot.data ?? [];

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(Spacing.lg),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildOverviewCard(years),
                    const SizedBox(height: Spacing.xl),
                    Text(
                      'Financial Cycles',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: Spacing.md),
                    ...years.map((year) => _buildYearCard(context, ref, year)),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: AppEnhancedButton(
        label: 'Create Fiscal Year',
        icon: Icons.add,
        width: 200,
        onPressed: () => Navigator.pushNamed(context, '/financial-year-form'),
      ),
    );
  }

  Widget _buildOverviewCard(List<FinancialYear> years) {
    final activeYear = years.where((y) => !y.isClosed).firstOrNull;

    return GlassCard(
      padding: const EdgeInsets.all(Spacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_balance,
                color: AppColors.primary,
                size: 32,
              ),
              const SizedBox(width: Spacing.md),
              Text(
                'Operational Period',
                style: AppTextStyles.titleLarge
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: Spacing.lg),
          if (activeYear != null) ...[
            Text(
              activeYear.name,
              style: AppTextStyles.headlineMedium
                  .copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              '${DateFormat('MMMM dd, yyyy').format(activeYear.startDate)} - '
              '${DateFormat('MMMM dd, yyyy').format(activeYear.endDate)}',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
          ] else
            const Text(
              'No active financial year detected. '
              'System operation might be restricted.',
            ),
        ],
      ),
    );
  }

  Widget _buildYearCard(
    BuildContext context,
    WidgetRef ref,
    FinancialYear year,
  ) =>
      Padding(
        padding: const EdgeInsets.only(bottom: Spacing.md),
        child: GlassCard(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        year.name,
                        style: AppTextStyles.titleMedium
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        year.isClosed ? 'Status: Closed' : 'Status: Open',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: year.isClosed
                              ? AppColors.error
                              : AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  if (!year.isClosed)
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => Navigator.pushNamed(
                            context,
                            '/financial-year-form',
                            arguments: {'financialYear': year},
                          ),
                          tooltip: 'Edit Year Details',
                        ),
                        const SizedBox(width: Spacing.sm),
                        ElevatedButton.icon(
                          onPressed: () =>
                              _showCloseYearDialog(context, ref, year),
                          icon: const Icon(Icons.lock_clock),
                          label: const Text('Year-End Close'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const Divider(height: Spacing.xl),
              _buildPeriodGrid(context, ref, year),
            ],
          ),
        ),
      );

  Widget _buildPeriodGrid(
    BuildContext context,
    WidgetRef ref,
    FinancialYear year,
  ) =>
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: Spacing.sm,
          mainAxisSpacing: Spacing.sm,
          childAspectRatio: 2.5,
        ),
        itemCount: 12,
        itemBuilder: (context, index) => _buildPeriodGridItem(
          context,
          ref,
          year,
          index,
        ),
      );

  Future<void> _togglePeriodLock(
    WidgetRef ref,
    FinancialYear year,
    DateTime date,
    bool currentlyLocked,
  ) async {
    final service = ref.read(financialYearServiceProvider.notifier);
    if (currentlyLocked) {
      await service.unlockMonthlyPeriod(year.id, date);
    } else {
      await ref
          .read(financialYearServiceProvider.notifier)
          .lockMonthlyPeriod(year.id, date);
    }
  }

  Future<void> _showCloseYearDialog(
    BuildContext context,
    WidgetRef ref,
    FinancialYear year,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Initiate Year-End Rollover?'),
        content: Text(
          'This will permanently close ${year.name} and rollover all '
          'balances to the next fiscal year. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Close Year'),
          ),
        ],
      ),
    );

    if (result ?? false) {
      // Find next year
      final repo = ref.read(financialYearRepositoryProvider);
      final years = await repo.getAllFinancialYears();
      final nextYear =
          years.where((y) => y.startDate.isAfter(year.endDate)).firstOrNull;

      if (nextYear == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Error: Next fiscal year not found. Please create it first.',
              ),
            ),
          );
        }
        return;
      }

      try {
        await ref
            .read(financialYearServiceProvider.notifier)
            .rolloverBalances(year.id, nextYear.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Year closed and balances rolled over successfully.',
              ),
            ),
          );
        }
      } on Exception catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Rollover failed: $e')),
          );
        }
      }
    }
  }

  Widget _buildPeriodGridItem(
    BuildContext context,
    WidgetRef ref,
    FinancialYear year,
    int index,
  ) {
    final monthDate = DateTime(year.startDate.year, index + 1);
    final periodId =
        '${monthDate.year}-${(index + 1).toString().padLeft(2, '0')}';
    final isLocked = year.lockedPeriodIds.contains(periodId);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: year.isClosed
            ? null
            : () => _togglePeriodLock(ref, year, monthDate, isLocked),
        borderRadius: BorderRadius.circular(Radii.xs),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: isLocked
                  ? AppColors.error.withValues(alpha: 0.5)
                  : AppColors.success.withValues(alpha: 0.5),
            ),
            borderRadius: BorderRadius.circular(Radii.xs),
            color: isLocked
                ? AppColors.error.withValues(alpha: 0.1)
                : AppColors.success.withValues(alpha: 0.1),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isLocked ? Icons.lock : Icons.lock_open,
                  size: 14,
                  color: isLocked ? AppColors.error : AppColors.success,
                ),
                const SizedBox(width: Spacing.xs),
                Text(
                  DateFormat('MMM').format(monthDate),
                  style: AppTextStyles.labelMedium.copyWith(
                    color: isLocked ? AppColors.error : AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
