import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:basir_app/features/accounting/application/financial_statement_service.dart';
import 'package:basir_app/features/accounting/domain/entities/financial_report.dart';
import 'package:basir_app/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

/// شاشة قائمة الدخل (Income Statement Screen)
/// تعرض الأرباح والخسائر مصنفة وفق معايير IFRS 18.
class IncomeStatementScreen extends ConsumerWidget {
  /// إنشاء شاشة قائمة الدخل.
  const IncomeStatementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final fromDate = DateTime(now.year, now.month);
    final toDate = now;

    final incomeStatementAsync = ref
        .watch(
          financialStatementServiceProvider.notifier,
        )
        .generateIncomeStatement(fromDate, toDate);

    final currencyFormatter =
        intl.NumberFormat.currency(symbol: '', decimalDigits: 2);

    return Scaffold(
      appBar: AppAppBar(
        title: '${context.l10n.incomeStatementTitle} (IFRS 18)',
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _exportReport(context, ref),
            tooltip: context.l10n.actionShare,
          ),
        ],
      ),
      body: FutureBuilder<FinancialReport>(
        future: incomeStatementAsync,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: AppLoadingIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final report = snapshot.data;
          final lines = report?.lines ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(Spacing.md),
            itemCount: lines.length,
            itemBuilder: (context, index) {
              final line = lines[index];

              if (line.isTitle) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
                  child: Text(
                    line.label,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.only(
                  left: line.indentLevel * Spacing.md,
                  right: Spacing.sm,
                  top: Spacing.xs,
                  bottom: Spacing.xs,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      line.label,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight:
                            line.isTotal ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    Text(
                      currencyFormatter.format(line.amount.toDouble()),
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: line.amount >= Decimal.zero
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _exportReport(BuildContext context, WidgetRef ref) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ميزة التصدير ستتوفر قريباً')),
    );
  }
}
