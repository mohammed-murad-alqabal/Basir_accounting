import 'package:basir_app/core/utils/format_helpers.dart';
import 'package:basir_app/shared/widgets/index.dart';
import 'package:flutter/material.dart';

/// A widget for filtering financial reports by date/period.
class ReportFilterWidget extends StatelessWidget {
  const ReportFilterWidget({
    required this.toDate,
    required this.onFromDateChanged,
    required this.onToDateChanged,
    super.key,
    this.fromDate,
    this.showFromDate = true,
  });
  final DateTime? fromDate;
  final DateTime toDate;
  final ValueChanged<DateTime> onFromDateChanged;
  final ValueChanged<DateTime> onToDateChanged;
  final bool showFromDate;

  @override
  Widget build(BuildContext context) {
    // TODO: Localization
    const labelFrom = 'من تاريخ';
    const labelTo = 'إلى تاريخ';
    const labelAsOf = 'كما في تاريخ';

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
            tooltip: 'تحديث التقرير', // Update Report
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
