import 'package:basir_accounting_system/features/reports/presentation/screens/aging_report_screen.dart';
import 'package:basir_accounting_system/features/reports/presentation/screens/financial_report_screen.dart';
import 'package:basir_accounting_system/features/reports/presentation/screens/trial_balance_screen.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';

/// Dashboard for accessing various financial reports.
class ReportsDashboardScreen extends StatelessWidget {
  /// Creates a reports dashboard screen.
  const ReportsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const AppAppBar(title: 'التقارير المالية'), // Financial Reports
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(title: 'التقارير الأساسية'), // Basic Reports
              const SizedBox(height: 16),
              _ReportCard(
                title: 'ميزان المراجعة', // Trial Balance
                description: 'أرصدة جميع الحسابات للتحقق من التوازن',
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
              const SizedBox(height: 16),
              const _SectionTitle(title: 'القوائم المالية (IAS 1/IFRS)'),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
                children: [
                  _ReportCard(
                    title: 'قائمة الدخل', // Income Statement
                    description: 'الأداء المالي والربحية',
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
                    title: 'المركز المالي', // Balance Sheet
                    description: 'الأصول، الالتزامات، وحقوق الملكية',
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
                    title: 'التدفقات النقدية', // Cash Flow
                    description: 'حركة النقدية (تشغيلي، استثماري، تمويلي)',
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
                  Opacity(
                    opacity: 0.5,
                    child: _ReportCard(
                      title: 'زكاة الأعمال',
                      description: 'قريباً...',
                      icon: Icons.calculate,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const _SectionTitle(title: 'تحليل السداد وأعمار الديون'),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
                children: [
                  _ReportCard(
                    title: 'أعمار العملاء',
                    description: 'تحليل مستحقات العملاء غير المحصلة',
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
                    title: 'أعمار الموردين',
                    description: 'تحليل الالتزامات المستحقة للموردين',
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
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 32, color: Theme.of(context).primaryColor),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
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
