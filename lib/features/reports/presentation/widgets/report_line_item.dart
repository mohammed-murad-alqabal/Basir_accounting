import 'package:basir_app/core/utils/format_helpers.dart';
import 'package:basir_app/src/rust/api/reports.dart';
import 'package:flutter/material.dart';

/// ودجيت لعرض سطر واحد في التقرير المالي (قائمة الدخل، الميزانية العمومية، إلخ)
class ReportLineItem extends StatelessWidget {
  /// إنشاء سطر تقرير جديد.
  const ReportLineItem({
    required this.line,
    super.key,
  });

  /// بيانات سطر التقرير (DTO) القادمة من محرك التقارير.
  final FinancialReportLineDto line;

  @override
  Widget build(BuildContext context) {
    // Parse the decimal string to double for formatting.
    // Note: Use double for display formatting only; Core math is in Rust.
    final amount = double.tryParse(line.amount) ?? 0.0;

    // Determine styles based on line type
    final isHeader = line.isTitle;
    final isTotal = line.isTotal;

    final labelStyle = TextStyle(
      fontWeight: isHeader || isTotal ? FontWeight.bold : FontWeight.normal,
      fontSize: isHeader ? 16.0 : 14.0,
    );

    final amountStyle = TextStyle(
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
      color: isHeader
          ? Colors.transparent
          : null, // Hide amount for section headers if 0
    );

    // Don't show amount for pure headers if it is zero
    final showAmount = !isHeader || amount != 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: isTotal
          ? const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey, width: 2),
              ),
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: line.indentLevel * 24.0, // Indentation per level
              ),
              child: Text(
                line.label,
                style: labelStyle,
              ),
            ),
          ),
          if (showAmount)
            Text(
              FormatHelpers.formatCurrency(amount),
              style: amountStyle,
            ),
        ],
      ),
    );
  }
}
