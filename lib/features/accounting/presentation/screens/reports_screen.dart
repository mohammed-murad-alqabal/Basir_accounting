import 'dart:async';

import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/aging_reports_screen.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/balance_sheet_screen.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/cash_flow_screen.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/income_statement_screen.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/trial_balance_screen.dart';
import 'package:basir_accounting_system/features/onboarding/presentation/widgets/cognitive_overlay.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Central hub for accessing statutory and management financial reports.
class ReportingOverviewScreen extends ConsumerStatefulWidget {
  /// Creates the reporting overview screen.
  const ReportingOverviewScreen({super.key});

  @override
  ConsumerState<ReportingOverviewScreen> createState() =>
      _ReportingOverviewScreenState();
}

class _ReportingOverviewScreenState
    extends ConsumerState<ReportingOverviewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showCognitiveHint(
        context,
        'Use these reports to maintain absolute financial oversight '
        'and ensure IFRS 18 compliance.',
        title: 'Financial Strategy',
      );
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppAppBar(title: context.l10n.reportingOverviewTitle),
        body: ListView(
          padding: const EdgeInsets.all(Spacing.md),
          children: [
            _buildReportCard(
              context,
              title: context.l10n.trialBalanceTitle,
              subtitle: context.l10n.trialBalanceSubtitle,
              icon: Icons.account_balance_rounded,
              onTap: () {
                unawaited(
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const TrialBalanceScreen(),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: Spacing.md),
            _buildReportCard(
              context,
              title: context.l10n.incomeStatementTitle,
              subtitle: context.l10n.incomeStatementSubtitle,
              icon: Icons.pie_chart_rounded,
              onTap: () {
                unawaited(
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const IncomeStatementScreen(),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: Spacing.md),
            _buildReportCard(
              context,
              title: context.l10n.balanceSheetTitle,
              subtitle: context.l10n.balanceSheetSubtitle,
              icon: Icons.assessment_rounded,
              onTap: () {
                unawaited(
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const BalanceSheetScreen(),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: Spacing.md),
            _buildReportCard(
              context,
              title: context.l10n.cashFlowTitle,
              subtitle: context.l10n.cashFlowSubtitle,
              icon: Icons.money_rounded,
              onTap: () {
                unawaited(
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const CashFlowScreen(),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: Spacing.md),
            _buildReportCard(
              context,
              title: context.l10n.agingReportsTitle,
              subtitle: context.l10n.agingReportsSubtitle,
              icon: Icons.timer_rounded,
              onTap: () {
                unawaited(
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const AgingReportsScreen(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );

  /// Builds a high-level navigation card for a specific report category.
  Widget _buildReportCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) =>
      AppCard(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(Spacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: Radii.borderRadiusMd,
                ),
                child: Icon(icon, color: AppColors.primary, size: 32),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      );
}
