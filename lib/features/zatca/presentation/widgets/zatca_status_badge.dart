import 'package:basir_accounting_system/core/theme/tokens/color_tokens.dart';
import 'package:basir_accounting_system/core/theme/tokens/typography_tokens.dart';
import 'package:basir_accounting_system/features/zatca/domain/zatca_types.dart';
import 'package:flutter/material.dart';

/// A badge widget that displays the ZATCA submission status of an invoice.
class ZatcaStatusBadge extends StatelessWidget {
  /// Creates a ZATCA status badge.
  const ZatcaStatusBadge({
    required this.status,
    super.key,
  });

  /// The current ZATCA status to display.
  final ZatcaSubmissionStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, label, icon) = _getStatusAttributes();

    if (status == ZatcaSubmissionStatus.notReported) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  (Color, String, IconData) _getStatusAttributes() {
    switch (status) {
      case ZatcaSubmissionStatus.reported:
        return (AppColors.success, 'Reported', Icons.check_circle_outline);
      case ZatcaSubmissionStatus.reportedWithWarnings:
        return (
          AppColors.warning,
          'Reported (Warn)',
          Icons.warning_amber_rounded,
        );
      case ZatcaSubmissionStatus.rejected:
        return (AppColors.error, 'Rejected', Icons.error_outline);
      case ZatcaSubmissionStatus.notReported:
        return (
          Colors.grey,
          'Not Reported',
          Icons.help_outline,
        ); // Should be hidden
    }
  }
}
