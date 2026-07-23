import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/opacity_compositing_design.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/reports/presentation/screens/aging_report_screen.dart';
import 'package:basir_accounting_system/features/reports/presentation/screens/audit_trail_report_screen.dart';
import 'package:basir_accounting_system/features/reports/presentation/screens/financial_report_screen.dart';
import 'package:basir_accounting_system/features/reports/presentation/screens/trial_balance_screen.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';

/// Dashboard for accessing various financial reports.
class ReportsDashboardScreen extends StatelessWidget {
  /// Creates a reports dashboard screen.
  const ReportsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) => GlassScaffold(
        title: context.l10n.reportingOverviewTitle,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle(title: context.l10n.sectionBasicReports),
              const SizedBox(height: Spacing.md),
              _ReportCard(
                title: context.l10n.trialBalanceTitle,
                description: context.l10n.trialBalanceSubtitle,
                icon: Icons.balance,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const TrialBalanceScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: Spacing.md),
              _SectionTitle(title: context.l10n.sectionFinancialStatements),
              const SizedBox(height: Spacing.md),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: Spacing.md,
                mainAxisSpacing: Spacing.md,
                childAspectRatio: 1.3,
                children: [
                  _ReportCard(
                    title: context.l10n.incomeStatementTitle,
                    description: context.l10n.incomeStatementSubtitle,
                    icon: Icons.show_chart,
                    color: Colors.blue.shade50,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => const FinancialReportScreen(
                            reportType: FinancialReportType.incomeStatement,
                          ),
                        ),
                      );
                    },
                  ),
                  _ReportCard(
                    title: context.l10n.balanceSheetTitle,
                    description: context.l10n.balanceSheetSubtitle,
                    icon: Icons.account_balance,
                    color: Colors.green.shade50,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => const FinancialReportScreen(
                            reportType: FinancialReportType.balanceSheet,
                          ),
                        ),
                      );
                    },
                  ),
                  _ReportCard(
                    title: context.l10n.cashFlowTitle,
                    description: context.l10n.cashFlowSubtitle,
                    icon: Icons.currency_exchange,
                    color: Colors.orange.shade50,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => const FinancialReportScreen(
                            reportType: FinancialReportType.cashFlow,
                          ),
                        ),
                      );
                    },
                  ),
                  // Placeholder for Zakah
                  OpacityCompositingDesign.buildSafeOpacityWidget(
                    opacity: 0.5,
                    textColor: AppColors.textPrimary,
                    background: AppColors.surface,
                    child: _ReportCard(
                      title: 'Zakah / زكاة الأعمال',
                      description: context.l10n.placeholderComingSoon(''),
                      icon: Icons.calculate,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.xl),
              _SectionTitle(title: context.l10n.sectionAgingAnalysis),
              const SizedBox(height: Spacing.md),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: Spacing.md,
                mainAxisSpacing: Spacing.md,
                childAspectRatio: 1.3,
                children: [
                  _ReportCard(
                    title: context.l10n.receivablesAgingTitle,
                    description: context.l10n.receivablesAgingLabel,
                    icon: Icons.people_outline,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => const AgingReportScreen(
                            reportType: AgingReportType.receivables,
                          ),
                        ),
                      );
                    },
                  ),
                  _ReportCard(
                    title: context.l10n.payablesAgingTitle,
                    description: context.l10n.payablesAgingLabel,
                    icon: Icons.local_shipping_outlined,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => const AgingReportScreen(
                            reportType: AgingReportType.payables,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: Spacing.xl),
              _SectionTitle(title: context.l10n.auditTrailTitle),
              const SizedBox(height: Spacing.md),
              _ReportCard(
                title: context.l10n.auditTrailTitle,
                description: context.l10n.auditTrailSubtitle,
                icon: Icons.gpp_maybe,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const AuditTrailReportScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      );
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
    this.color,
  });
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) => AppCard(
        backgroundColor: color,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 32, color: Theme.of(context).primaryColor),
                const SizedBox(height: Spacing.md),
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      );
}
