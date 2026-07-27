import 'dart:async';

import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/expenses/domain/entities/expense.dart';
import 'package:basir_accounting_system/features/expenses/domain/repositories/expense_repository.dart';
import 'package:basir_accounting_system/features/expenses/presentation/providers/expense_provider.dart';
import 'package:basir_accounting_system/features/expenses/presentation/screens/expense_form_screen.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Expenses Dashboard Screen following FORENSIC_ATLAS Screen 066.
///
/// Features:
/// - Summary cards (total, count, average)
/// - Category breakdown chart
/// - Recent expenses list
/// - Quick add button
class ExpensesDashboardScreen extends ConsumerWidget {
  /// Creates the [ExpensesDashboardScreen].
  const ExpensesDashboardScreen({super.key});

  /// The route name for navigation.
  static const routeName = '/expenses';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expensesNotifierProvider);
    final summary = ref.watch(expenseSummaryProvider);
    final categories = ref.watch(expenseCategoriesProvider);
    final theme = Theme.of(context);
    final l10n = context.isArabic;

    return GlassScaffold(
      title: l10n ? 'المصروفات' : 'Expenses',
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () => _showFilterDialog(context, ref),
          tooltip: l10n ? 'تصفية المصروفات' : 'Filter expenses',
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => const ExpenseFormScreen(),
            ),
          ),
          tooltip: l10n ? 'إضافة مصروف' : 'Add expense',
        ),
      ],
      body: RefreshIndicator(
        onRefresh: () => ref.read(expensesNotifierProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            // Summary Cards
            SliverToBoxAdapter(
              child: summary.when(
                data: (data) => _buildSummaryCards(context, data, l10n),
                loading: () => const SizedBox(
                  height: 120,
                  child: Center(child: AppLoadingIndicator()),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(Spacing.lg),
                  child: AppErrorWidget(
                    message: e.toString(),
                    onRetry: () => ref.invalidate(expenseSummaryProvider),
                  ),
                ),
              ),
            ),

            // Category Breakdown
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: AppCard(
                  child: Padding(
                    padding: const EdgeInsets.all(Spacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n ? 'حسب الفئة' : 'By Category',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        categories.when(
                          data: (cats) => summary.when(
                            data: (s) => _buildCategoryBreakdown(
                              context,
                              cats,
                              s,
                              l10n,
                            ),
                            loading: () => const Center(
                              child: AppLoadingIndicator(),
                            ),
                            error: (e, _) => AppErrorWidget(
                              message: e.toString(),
                              onRetry: () => ref.invalidate(
                                expenseSummaryProvider,
                              ),
                            ),
                          ),
                          loading: () => const Center(
                            child: AppLoadingIndicator(),
                          ),
                          error: (e, _) => AppErrorWidget(
                            message: e.toString(),
                            onRetry: () => ref.invalidate(
                              expenseCategoriesProvider,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n ? 'المصروفات الأخيرة' : 'Recent Expenses',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to all expenses
                      },
                      child: Text(l10n ? 'عرض الكل' : 'View All'),
                    ),
                  ],
                ),
              ),
            ),

            // Expenses List
            expenses.when(
              data: (list) => list.isEmpty
                  ? SliverToBoxAdapter(
                      child: _buildEmptyState(context, l10n),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildExpenseItem(
                          context,
                          list[index],
                          categories.valueOrNull ?? [],
                          l10n,
                        ),
                        childCount: list.length > 10 ? 10 : list.length,
                      ),
                    ),
              loading: () => const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: AppLoadingIndicator(),
                  ),
                ),
              ),
              error: (e, _) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.lg),
                  child: AppErrorWidget(
                    message: e.toString(),
                    onRetry: () => ref.invalidate(expensesNotifierProvider),
                  ),
                ),
              ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(
    BuildContext context,
    ExpenseSummary summary,
    bool l10n,
  ) {
    final currencyFormat = NumberFormat.currency(
      symbol: l10n ? 'ر.س ' : 'SAR ',
      decimalDigits: 2,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCard(
              title: l10n ? 'الإجمالي' : 'Total',
              value: currencyFormat.format(summary.totalAmount),
              icon: Icons.account_balance_wallet,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SummaryCard(
              title: l10n ? 'العدد' : 'Count',
              value: summary.count.toString(),
              icon: Icons.receipt_long,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SummaryCard(
              title: l10n ? 'المتوسط' : 'Average',
              value: currencyFormat.format(summary.averageAmount),
              icon: Icons.trending_flat,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown(
    BuildContext context,
    List<ExpenseCategory> categories,
    ExpenseSummary summary,
    bool l10n,
  ) {
    if (summary.byCategory.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            l10n ? 'لا توجد بيانات' : 'No data',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }

    final sortedCategories = summary.byCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: sortedCategories.take(5).map((entry) {
        final category = categories.firstWhere(
          (c) => c.id == entry.key,
          orElse: () => ExpenseCategory(
            id: entry.key,
            name: 'Unknown',
            nameAr: 'غير معروف',
          ),
        );

        final percentage = summary.totalAmount > 0 //
            ? (entry.value / summary.totalAmount * 100)
            : 0.0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _getCategoryColor(category.color) //
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getCategoryIcon(category.icon),
                  size: 18,
                  color: _getCategoryColor(category.color),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n ? category.nameAr : category.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(
                        _getCategoryColor(category.color),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExpenseItem(
    BuildContext context,
    Expense expense,
    List<ExpenseCategory> categories,
    bool l10n,
  ) {
    final category = categories.firstWhere(
      (c) => c.id == expense.categoryId,
      orElse: () => ExpenseCategory(
        id: expense.categoryId,
        name: 'Unknown',
        nameAr: 'غير معروف',
      ),
    );

    final dateFormat = DateFormat('dd/MM/yyyy');
    final currencyFormat = NumberFormat.currency(
      symbol: expense.currencyCode == 'SAR' ? (l10n ? 'ر.س ' : 'SAR ') : '',
      decimalDigits: 2,
    );

    return AppCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getCategoryColor(category.color).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getCategoryIcon(category.icon),
            color: _getCategoryColor(category.color),
          ),
        ),
        title: Text(
          expense.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${l10n ? category.nameAr : category.name}'
          ' • ${dateFormat.format(expense.expenseDate)}',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              currencyFormat.format(expense.amount.toDouble()),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            _buildStatusBadge(expense.status, l10n),
          ],
        ),
        onTap: () {
          // Navigate to expense detail
        },
      ),
    );
  }

  Widget _buildStatusBadge(String status, bool l10n) {
    Color color;
    String label;

    switch (status) {
      case 'posted':
        color = Colors.green;
        label = l10n ? 'مُرحّل' : 'Posted';
      case 'approved':
        color = Colors.blue;
        label = l10n ? 'موافق' : 'Approved';
      case 'rejected':
        color = Colors.red;
        label = l10n ? 'مرفوض' : 'Rejected';
      default:
        color = Colors.orange;
        label = l10n ? 'معلق' : 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool l10n) => AppEmptyState(
        title: l10n ? 'لا توجد مصروفات' : 'No expenses yet',
        description: l10n
            ? 'استخدم زر الإضافة من الأعلى لتسجيل مصروف جديد.'
            : 'Use the add action above to record a new expense.',
        icon: Icons.receipt_long,
      );

  Future<void> _showFilterDialog(BuildContext context, WidgetRef ref) async {
    final theme = Theme.of(context);
    final l10n = context.isArabic;
    final dateFormat = DateFormat('dd/MM/yyyy');

    final now = DateTime.now();
    DateTime? startDate = DateTime(now.year, now.month);
    DateTime? endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    String? categoryId;
    String? status;

    final categories = await ref.read(expenseCategoriesProvider.future);

    if (!context.mounted) return;

    final result = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (statefulContext, setDialogState) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.filter_list),
              const SizedBox(width: 8),
              Text(l10n ? 'تصفية المصروفات' : 'Filter Expenses'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // نطاق التواريخ
                Text(
                  l10n ? 'نطاق التاريخ' : 'Date Range',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: dialogContext,
                            initialDate: startDate ?? now,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setDialogState(() => startDate = picked);
                          }
                        },
                        icon: const Icon(Icons.date_range, size: 18),
                        label: Text(
                          startDate != null
                              ? dateFormat.format(startDate!)
                              : (l10n ? 'من تاريخ' : 'From'),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: dialogContext,
                            initialDate: endDate ?? now,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setDialogState(() => endDate = picked);
                          }
                        },
                        icon: const Icon(Icons.date_range, size: 18),
                        label: Text(
                          endDate != null
                              ? dateFormat.format(endDate!)
                              : (l10n ? 'إلى تاريخ' : 'To'),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // اختيار الفئة
                Text(
                  l10n ? 'الفئة' : 'Category',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: categoryId,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.category),
                    border: const OutlineInputBorder(),
                    hintText: l10n ? 'الكل' : 'All',
                  ),
                  items: [
                    DropdownMenuItem(
                      child: Text(l10n ? 'كل الفئات' : 'All categories'),
                    ),
                    ...categories.map(
                      (c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(l10n ? c.nameAr : c.name),
                      ),
                    ),
                  ],
                  onChanged: (v) => setDialogState(() => categoryId = v),
                ),
                const SizedBox(height: 16),

                // اختيار الحالة
                Text(
                  l10n ? 'الحالة' : 'Status',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: status,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.label),
                    border: const OutlineInputBorder(),
                    hintText: l10n ? 'الكل' : 'All',
                  ),
                  items: [
                    DropdownMenuItem(
                      child: Text(l10n ? 'كل الحالات' : 'All statuses'),
                    ),
                    DropdownMenuItem(
                      value: 'pending',
                      child: Text(l10n ? 'معلق' : 'Pending'),
                    ),
                    DropdownMenuItem(
                      value: 'approved',
                      child: Text(l10n ? 'موافق' : 'Approved'),
                    ),
                    DropdownMenuItem(
                      value: 'posted',
                      child: Text(l10n ? 'مُرحّل' : 'Posted'),
                    ),
                    DropdownMenuItem(
                      value: 'rejected',
                      child: Text(l10n ? 'مرفوض' : 'Rejected'),
                    ),
                  ],
                  onChanged: (v) => setDialogState(() => status = v),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // إعادة ضبط الفلاتر إلى الوضع الافتراضي (الشهر الحالي)
                unawaited(
                  ref.read(expensesNotifierProvider.notifier).refresh(),
                );
                ref.invalidate(expenseSummaryProvider);
                Navigator.of(dialogContext).pop();
              },
              child: Text(l10n ? 'إعادة ضبط' : 'Reset'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n ? 'إلغاء' : 'Cancel'),
            ),
            FilledButton.icon(
              onPressed: () {
                final endOfDay = endDate != null
                    ? DateTime(
                        endDate!.year,
                        endDate!.month,
                        endDate!.day,
                        23,
                        59,
                        59,
                      )
                    : null;

                Navigator.of(dialogContext).pop(<String, dynamic>{
                  'startDate': startDate,
                  'endDate': endOfDay,
                  'categoryId': categoryId,
                  'status': status,
                });
              },
              icon: const Icon(Icons.check, size: 18),
              label: Text(l10n ? 'تطبيق' : 'Apply'),
            ),
          ],
        ),
      ),
    );

    if (result == null) return;

    // تطبيق الفلاتر على مزود القائمة والموجز
    await ref.read(expensesNotifierProvider.notifier).loadExpenses(
          startDate: result['startDate'] as DateTime?,
          endDate: result['endDate'] as DateTime?,
          categoryId: result['categoryId'] as String?,
          status: result['status'] as String?,
        );

    // تحديث الموجز أيضاً ليعكس نفس نطاق التواريخ
    final s = result['startDate'] as DateTime?;
    final e = result['endDate'] as DateTime?;
    if (s != null && e != null) {
      // تجاوز الموجز عبر تحويل المزود إلى AsyncFamily إذا لزم الأمر
      // أو إعادة تحميله كأولوية لاحقة.
      ref.invalidate(expenseSummaryProvider);
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n ? 'تم تطبيق الفلاتر' : 'Filters applied'),
          backgroundColor: theme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Color _getCategoryColor(String? colorHex) {
    if (colorHex == null) return Colors.grey;
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } on FormatException {
      return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String? iconName) {
    switch (iconName) {
      case 'electric_bolt':
        return Icons.electric_bolt;
      case 'home':
        return Icons.home;
      case 'people':
        return Icons.people;
      case 'inventory':
        return Icons.inventory;
      case 'flight':
        return Icons.flight;
      case 'campaign':
        return Icons.campaign;
      case 'build':
        return Icons.build;
      default:
        return Icons.more_horiz;
    }
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16, color: color),
                  const SizedBox(width: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
}
