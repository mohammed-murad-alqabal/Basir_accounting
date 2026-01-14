// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/utils/format_helpers.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';

/// ودجيت لتصفية التقارير المالية حسب التاريخ أو الفترة.
class ReportFilterWidget extends StatelessWidget {
  /// إنشاء ودجيت تصفية جديد.
  const ReportFilterWidget({
    required this.toDate,
    required this.onFromDateChanged,
    required this.onToDateChanged,
    super.key,
    this.fromDate,
    this.showFromDate = true,
  });

  /// تاريخ البداية (اختياري).
  final DateTime? fromDate;

  /// تاريخ النهاية.
  final DateTime toDate;

  /// وظيفة تُستدعى عند تغيير تاريخ البداية.
  final ValueChanged<DateTime> onFromDateChanged;

  /// وظيفة تُستدعى عند تغيير تاريخ النهاية.
  final ValueChanged<DateTime> onToDateChanged;

  /// هل يتم إظهار تاريخ البداية (للفترات) أم لا (للتقارير اللحظية).
  final bool showFromDate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labelFrom = l10n.labelFromDate;
    final labelTo = l10n.labelToDate;
    final labelAsOf = l10n.labelAsOfDate;

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (showFromDate) ...[
            Expanded(
              child: _DateSelector(
                label: labelFrom,
                value: fromDate ?? DateTime.now(), // Fallback if null but shown
                onChanged: onFromDateChanged,
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: _DateSelector(
              label: showFromDate ? labelTo : labelAsOf,
              value: toDate,
              onChanged: onToDateChanged,
            ),
          ),
          const SizedBox(width: 16),
          // Refresh Icon just for affordance, functionality is reactive usually
          IconButton(
            onPressed: () {}, // Handled by parents usually via state updates
            icon: const Icon(Icons.filter_list),
            tooltip: l10n.tooltipUpdateReport,
          ),
        ],
      ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  const _DateSelector({
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () async {
          final result = await showDatePicker(
            context: context,
            initialDate: value,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (result != null) {
            onChanged(result);
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            suffixIcon: const Icon(Icons.calendar_today, size: 20),
          ),
          child: Text(
            FormatHelpers.formatDate(value),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
}
