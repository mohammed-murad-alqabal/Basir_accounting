import 'package:basir_accounting_system/core/utils/format_helpers.dart';
import 'package:basir_accounting_system/src/rust/api/reports.dart';
import 'package:flutter/material.dart';

/// ودجيت لعرض سطر واحد في التقرير المالي (قائمة الدخل، الميزانية العمومية، إلخ)
class ReportLineItem extends StatelessWidget {
  /// إنشاء سطر تقرير جديد.
  const ReportLineItem({required this.line, super.key});

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
      // Hide amount for section headers if 0
      color: isHeader //
          ? Colors.transparent
          : null,
    );

    // Don't show amount for pure headers if it is zero
    final showAmount = !isHeader || amount != 0.0;

    // Pro-grade Heuristic: Try to extract a code if it looks like "1101 - Cash"
    final codeMatch = RegExp(r'^(\d{4,})\s-\s').firstMatch(line.label);
    final probableAccountId = codeMatch?.group(1);

    return InkWell(
      onTap: probableAccountId != null && !isTotal && !isHeader
          ? () async {
              // Navigate to General Ledger
              // We infer accountId from the code
              // (assuming they match for now, or use mapped ID)
              // For now, passing the code as ID for demonstration of the flow
              await Navigator.pushNamed(
                context,
                '/general-ledger',
                arguments: {
                  'accountId': probableAccountId,
                  'accountName': line.label.substring(codeMatch!.end),
                  'fromDate': DateTime(2025), // TODO(basir): Get from parent
                  'toDate': DateTime.now(),
                },
              );
            }
          : null,
      child: Container(
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
                child: Row(
                  children: [
                    Text(line.label, style: labelStyle),
                    if (probableAccountId != null) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.open_in_new,
                        size: 12,
                        color: Colors.blue.withValues(alpha: 0.5),
                      ),
                    ],
                  ],
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
      ),
    );
  }
}
