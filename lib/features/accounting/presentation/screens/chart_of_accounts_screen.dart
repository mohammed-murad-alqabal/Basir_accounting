import 'dart:typed_data';

import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/core/providers.dart';
import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:basir_app/features/accounting/application/accounting_service.dart';
import 'package:basir_app/features/accounting/domain/entities/account.dart';
import 'package:basir_app/features/reports/application/report_export_service.dart';
import 'package:basir_app/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Provider tracking the expansion state of hierarchical accounts in the tree view.
final expandedAccountsProvider = StateProvider<Set<String>>(
  (ref) => <String>{},
);

/// Interactive screen for browsing and managing the hierarchical Chart of Accounts (COA).
///
/// Features a searchable tree structure, multi-standard support (IFRS/ZATCA/FTA),
/// and real-time hierarchical balance roll-ups.
class ChartOfAccountsScreen extends ConsumerWidget {
  /// Creates the Chart of Accounts screen.
  const ChartOfAccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(accountingRepositoryProvider);
    final appIcons = ref.watch(appIconsProvider);
    final expandedIds = ref.watch(expandedAccountsProvider);

    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.labelChartOfAccounts,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: context.l10n.btnExport,
            onPressed: () => _showExportOptions(context, ref),
          ),
          IconButton(
            icon: Icon(appIcons.refresh),
            tooltip: context.l10n.tooltipRefresh,
            onPressed: () async {
              await ref.read(accountingServiceProvider.notifier).seedDefaultAccounts();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Account>>(
        future: repository.getAccounts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: AppLoadingIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${context.l10n.errorLoadingAccounts}: ${snapshot.error}',
                style: const TextStyle(color: AppColors.error),
              ),
            );
          }

          final allAccounts = snapshot.data ?? [];
          if (allAccounts.isEmpty) {
            return _buildEmptyState(context);
          }

          final displayList = _buildDisplayList(allAccounts, expandedIds);

          return ListView.builder(
            itemCount: displayList.length,
            itemBuilder: (context, index) {
              final account = displayList[index];
              final depth = _getDepth(account, allAccounts);
              final hierarchicalBalance = _calculateHierarchicalBalance(
                account,
                allAccounts,
              );

              return _AccountTreeItem(
                account: account,
                depth: depth,
                balance: hierarchicalBalance,
                isExpanded: expandedIds.contains(account.id),
                onToggle: () {
                  ref.read(expandedAccountsProvider.notifier).update((state) {
                    final newState = Set<String>.from(state);
                    if (newState.contains(account.id)) {
                      newState.remove(account.id);
                    } else {
                      newState.add(account.id);
                    }
                    return newState;
                  });
                },
              );
            },
          );
        },
      ),
    );
  }

  /// Renders a placeholder when No accounts are available.
  Widget _buildEmptyState(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.xl),
          child: Text(
            context.l10n.emptyAccountsMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );

  /// Performs a depth-first traversal to flatten the tree for ListView rendering.
  List<Account> _buildDisplayList(List<Account> all, Set<String> expandedIds) {
    final roots = all.where((a) => a.parentId == null).toList();
    roots.sort((a, b) => a.code.compareTo(b.code));

    final result = <Account>[];
    for (final root in roots) {
      _addChildrenRecursive(root, all, expandedIds, result);
    }
    return result;
  }

  /// Appends children to the display list if their parent is marked as expanded.
  void _addChildrenRecursive(
    Account account,
    List<Account> all,
    Set<String> expandedIds,
    List<Account> result,
  ) {
    result.add(account);
    if (expandedIds.contains(account.id)) {
      final children = all.where((a) => a.parentId == account.id).toList();
      children.sort((a, b) => a.code.compareTo(b.code));
      for (final child in children) {
        _addChildrenRecursive(child, all, expandedIds, result);
      }
    }
  }

  /// Calculates the visual indentation depth based on COA lineage.
  int _getDepth(Account account, List<Account> all) {
    var depth = 0;
    var current = account;
    while (current.parentId != null) {
      depth++;
      current = all.firstWhere((a) => a.id == current.parentId);
    }
    return depth;
  }

  /// Aggregates the balances of all recursive descendants for grouping accounts.
  Decimal _calculateHierarchicalBalance(Account account, List<Account> all) {
    var total = account.balance;
    final children = all.where((a) => a.parentId == account.id);
    for (final child in children) {
      total += _calculateHierarchicalBalance(child, all);
    }
    return total;
  }

  /// Displays the export destination picker (PDF/CSV).
  Future<void> _showExportOptions(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: Text(context.l10n.labelExportPdf),
              onTap: () async {
                Navigator.pop(context);
                await _exportReport(context, ref, asPdf: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: Text(context.l10n.labelExportCsv),
              onTap: () async {
                Navigator.pop(context);
                await _exportReport(context, ref, asPdf: false);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Generates and shares the Chart of Accounts in the requested format.
  Future<void> _exportReport(
    BuildContext context,
    WidgetRef ref, {
    required bool asPdf,
  }) async {
    try {
      final repository = ref.read(accountingRepositoryProvider);
      final accounts = await repository.getAccounts();
      if (!context.mounted) return;

      final exportService = ref.read(reportExportServiceProvider.notifier);

      final headers = [
        context.l10n.labelCode,
        context.l10n.labelAccount,
        context.l10n.labelType,
        context.l10n.labelBalance,
      ];

      final data = accounts
          .map(
            (a) => [
              a.code,
              a.nameAr,
              _getLocalizedTypeName(context, a.type),
              a.balance.toString(),
            ],
          )
          .toList();

      if (asPdf) {
        await exportService.shareTablePdf(
          title: context.l10n.labelChartOfAccounts,
          headers: headers,
          data: data,
          filename: 'chart_of_accounts.pdf',
        );
      } else {
        final csvData = exportService.generateTableCsv(
          headers: headers,
          data: data,
        );
        final bytes = Uint8List.fromList(csvData.codeUnits);
        final sharingService = ref.read(sharingServiceProvider);
        await sharingService.shareFile(
          bytes: bytes,
          fileName: 'chart_of_accounts.csv',
        );
      }
    } on Exception catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${context.l10n.errorExportingReport}: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  /// Returns the RTL/LTR localized string for an [AccountType].
  String _getLocalizedTypeName(BuildContext context, AccountType type) {
    switch (type) {
      case AccountType.asset:
        return context.l10n.labelAssets;
      case AccountType.liability:
        return context.l10n.labelLiabilities;
      case AccountType.equity:
        return context.l10n.labelEquity;
      case AccountType.revenue:
        return context.l10n.labelRevenue;
      case AccountType.expense:
        return context.l10n.labelExpenses;
    }
  }
}

/// Visual component representing a single node in the COA tree.
class _AccountTreeItem extends StatelessWidget {
  /// Creates an account tree item.
  const _AccountTreeItem({
    required this.account,
    required this.depth,
    required this.balance,
    required this.isExpanded,
    required this.onToggle,
  });

  /// The underlying account entity.
  final Account account;

  /// Indentation depth (0-based level).
  final int depth;

  /// Aggregated roll-up balance.
  final Decimal balance;

  /// Expansion state for grouping accounts.
  final bool isExpanded;

  /// Callback to toggle expansion state.
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) => Semantics(
        label: '${account.code}: ${account.nameAr}, '
            '${context.l10n.labelBalance}: '
            '${_formatCurrency(balance)}',
        child: InkWell(
          onTap: account.isParent ? onToggle : null,
          child: Padding(
            padding: EdgeInsets.only(
              left: (depth * Spacing.lg) + Spacing.md,
              right: Spacing.md,
              top: Spacing.sm,
              bottom: Spacing.sm,
            ),
            child: Row(
              children: [
                _buildLeading(context),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${account.code} - ${account.nameAr}',
                        style: TextStyle(
                          fontWeight: account.isParent ? FontWeight.bold : FontWeight.w600,
                          fontSize: account.isParent
                              ? AppTypography.titleMedium
                              : AppTypography.bodyLarge,
                        ),
                      ),
                      Text(
                        account.nameEn,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatCurrency(balance),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: balance < Decimal.zero ? AppColors.error : AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  /// Renders expansion indicators or account type markers.
  Widget _buildLeading(BuildContext context) {
    if (account.isParent) {
      return Icon(
        isExpanded ? Icons.expand_more : Icons.chevron_right,
        size: IconSizes.sm,
        color: AppColors.textSecondary,
      );
    }
    return Container(
      width: IconSizes.sm,
      height: IconSizes.sm,
      decoration: BoxDecoration(
        color: _getColorForType(account.type).withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: _getColorForType(account.type),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  /// Returns the standardized thematic color for a specific [AccountType].
  Color _getColorForType(AccountType type) {
    switch (type) {
      case AccountType.asset:
        return AppColors.info;
      case AccountType.liability:
        return AppColors.error;
      case AccountType.equity:
        return AppColors.statusPending;
      case AccountType.revenue:
        return AppColors.success;
      case AccountType.expense:
        return AppColors.warning;
    }
  }

  /// Formats currency values for display with 2 decimal precision.
  String _formatCurrency(Decimal amount) {
    final formatter = NumberFormat.currency(symbol: '', decimalDigits: 2);
    return formatter.format(amount.toDouble());
  }
}
