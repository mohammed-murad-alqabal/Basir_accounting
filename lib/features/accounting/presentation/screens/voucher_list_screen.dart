// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/accounting/application/treasury_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_voucher.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

/// Screen displaying a comprehensive history of financial vouchers.
///
/// Provides filtering by voucher type (Receipt/Payment) and date range.
class VoucherListScreen extends ConsumerStatefulWidget {
  /// Creates the [VoucherListScreen].
  const VoucherListScreen({super.key});

  @override
  ConsumerState<VoucherListScreen> createState() => _VoucherListScreenState();
}

class _VoucherListScreenState extends ConsumerState<VoucherListScreen> {
  VoucherType? _filterType;
  DateTimeRange? _dateRange;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final vouchersAsync = ref.watch(getVouchersProvider);

    return GlassScaffold(
      title: context.l10n.recentVouchersTitle,
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: _showFilterDialog,
          tooltip: 'تصفية',
        ),
      ],
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: vouchersAsync.when(
              data: (vouchers) {
                final filtered = _applyFilters(vouchers);
                if (filtered.isEmpty) {
                  return AppEmptyState(
                    title: context.l10n.noVouchersMessage,
                    description: 'لم يتم العثور على سندات تطابق البحث',
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(Spacing.md),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: Spacing.sm),
                  itemBuilder: (context, index) {
                    final voucher = filtered[index];
                    return _buildVoucherCard(context, voucher);
                  },
                );
              },
              loading: () => const Center(child: AppLoadingIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() => Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: GlassCard(
          padding: EdgeInsets.zero,
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: const InputDecoration(
              hintText: 'بحث برقم المرجع أو الاسم...',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: Spacing.md,
                vertical: Spacing.sm,
              ),
            ),
          ),
        ),
      );

  Widget _buildVoucherCard(BuildContext context, FinancialVoucher voucher) {
    final color = voucher.type == VoucherType.receipt
        ? AppColors.success
        : AppColors.error;

    return AppCard(
      onTap: () {
        // Future: Navigate to detail/print preview
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(
            voucher.type == VoucherType.receipt ? Icons.add : Icons.remove,
            color: color,
          ),
        ),
        title: Text(
          voucher.personName ?? context.l10n.anonymousPerson,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${intl.DateFormat('yyyy/MM/dd').format(voucher.date)} - ${voucher.referenceNumber}',
              style: const TextStyle(fontSize: 12),
            ),
            if (voucher.description.isNotEmpty)
              Text(
                voucher.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${voucher.amount} ر.س',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 16,
              ),
            ),
            if (voucher.isPosted)
              const Icon(Icons.check_circle, size: 12, color: AppColors.success)
            else
              const Icon(Icons.history, size: 12, color: AppColors.warning),
          ],
        ),
      ),
    );
  }

  List<FinancialVoucher> _applyFilters(List<FinancialVoucher> vouchers) =>
      vouchers.where((v) {
        final matchesType = _filterType == null || v.type == _filterType;
        final matchesDate = _dateRange == null ||
            (v.date.isAfter(_dateRange!.start) &&
                v.date.isBefore(_dateRange!.end.add(const Duration(days: 1))));
        final matchesSearch = _searchQuery.isEmpty ||
            v.referenceNumber
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (v.personName?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
                false) ||
            v.description.toLowerCase().contains(_searchQuery.toLowerCase());

        return matchesType && matchesDate && matchesSearch;
      }).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  Future<void> _showFilterDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('تصفية السندات'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<VoucherType>(
                initialValue: _filterType,
                decoration: const InputDecoration(labelText: 'نوع السند'),
                items: const [
                  DropdownMenuItem(child: Text('الكل')),
                  DropdownMenuItem(
                    value: VoucherType.receipt,
                    child: Text('قبض'),
                  ),
                  DropdownMenuItem(
                    value: VoucherType.payment,
                    child: Text('صرف'),
                  ),
                ],
                onChanged: (val) {
                  setDialogState(() => _filterType = val);
                  setState(() => _filterType = val);
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('نطاق التاريخ'),
                subtitle: Text(
                  _dateRange == null
                      ? 'الكل'
                      : '${intl.DateFormat('yyyy/MM/dd').format(_dateRange!.start)} - ${intl.DateFormat('yyyy/MM/dd').format(_dateRange!.end)}',
                ),
                onTap: () async {
                  final range = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    initialDateRange: _dateRange,
                  );
                  if (range != null) {
                    setDialogState(() => _dateRange = range);
                    setState(() => _dateRange = range);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _filterType = null;
                  _dateRange = null;
                });
                Navigator.pop(context);
              },
              child: const Text('إعادة تعيين'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('تم'),
            ),
          ],
        ),
      ),
    );
  }
}
