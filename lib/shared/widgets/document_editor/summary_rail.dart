/// لوحة ملخص وإجراءات محرر الوثيقة.
///
/// تستقبل المسودة ومعاينة الأثر من طبقة الخدمات ولا تحسب سياسات الضرائب أو
/// المخزون أو القيود بنفسها.
library;

import 'package:basir_accounting_system/core/domain/contracts/index.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_colors.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_text_styles.dart';
import 'package:basir_accounting_system/core/theme/tokens/spacing.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// لوحة ملخص قابلة لإعادة الاستخدام في الفاتورة والشراء والمرتجع.
class SummaryRail extends StatelessWidget {
  /// ينشئ الملخص من مسودة، مع معاينة أثر اختيارية وإجراءات يملكها المستدعي.
  const SummaryRail({
    required this.draft,
    super.key,
    this.preview,
    this.onPreviewRequested,
    this.onSaveDraftRequested,
    this.onPostRequested,
  });

  /// المسودة الحالية التي تحسب عقودها الإجماليات الأولية.
  final DocumentDraft draft;

  /// ناتج طبقة المجال قبل الترحيل؛ لا ينشئه هذا الودجت.
  final PostingPreview? preview;

  /// يطلب من المستدعي استدعاء خدمة معاينة الأثر.
  final VoidCallback? onPreviewRequested;

  /// يحفظ المستدعي المسودة بلا أثر محاسبي.
  final VoidCallback? onSaveDraftRequested;

  /// يؤكد المستدعي تنفيذ الترحيل بعد وجود معاينة صالحة.
  final VoidCallback? onPostRequested;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final canPost =
        draft.isSaveable && preview != null && onPostRequested != null;

    return Semantics(
      container: true,
      label: l10n.workDocumentSummary,
      child: Container(
        constraints: const BoxConstraints(minWidth: 280, maxWidth: 360),
        padding: const EdgeInsets.all(Spacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.borderLight),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D17202A),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.workDocumentSummary, style: AppTextStyles.titleMedium),
            const SizedBox(height: Spacing.md),
            _TotalRow(
              label: l10n.labelSubtotal,
              amount: draft.subTotal,
              currency: draft.currencyCode,
            ),
            const SizedBox(height: Spacing.sm),
            _TotalRow(
              label: l10n.labelTaxTotal,
              amount: draft.taxTotal,
              currency: draft.currencyCode,
            ),
            const Divider(height: Spacing.xl),
            _TotalRow(
              label: l10n.labelGrandTotal,
              amount: draft.grandTotal,
              currency: draft.currencyCode,
              emphasis: true,
            ),
            const SizedBox(height: Spacing.lg),
            _PreviewSection(preview: preview),
            const SizedBox(height: Spacing.lg),
            OutlinedButton.icon(
              key: const Key('summaryRailPreviewAction'),
              onPressed: draft.isSaveable ? onPreviewRequested : null,
              icon: const Icon(Icons.preview_outlined),
              label: Text(l10n.workDocumentRequestPreview),
            ),
            const SizedBox(height: Spacing.sm),
            if (onSaveDraftRequested != null)
              TextButton.icon(
                key: const Key('summaryRailSaveDraftAction'),
                onPressed: onSaveDraftRequested,
                icon: const Icon(Icons.save_outlined),
                label: Text(l10n.workDocumentSaveDraft),
              ),
            if (onSaveDraftRequested != null)
              const SizedBox(height: Spacing.sm),
            Tooltip(
              message: canPost ? '' : l10n.workDocumentPreviewRequired,
              child: FilledButton.icon(
                key: const Key('summaryRailPostAction'),
                onPressed: canPost ? onPostRequested : null,
                icon: const Icon(Icons.verified_outlined),
                label: Text(l10n.workDocumentPost),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewSection extends StatelessWidget {
  const _PreviewSection({required this.preview});

  final PostingPreview? preview;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (preview == null) {
      return Semantics(
        liveRegion: true,
        child: Text(
          l10n.workDocumentPreviewRequired,
          style:
              AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.workDocumentPreviewImpact, style: AppTextStyles.labelLarge),
          const SizedBox(height: Spacing.sm),
          if (preview!.requiresAdditionalApproval)
            _ApprovalNotice(reason: preview!.approvalReason),
          if (preview!.lines.isEmpty)
            Text(l10n.workDocumentNoImpact, style: AppTextStyles.bodySmall)
          else
            ...preview!.lines.map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: Spacing.xs),
                child: Text(
                  '${line.description} · '
                  '${_formatAmount(line.amount, line.currencyCode)}',
                  style: AppTextStyles.bodySmall,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ApprovalNotice extends StatelessWidget {
  const _ApprovalNotice({required this.reason});

  final String? reason;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: Spacing.sm),
        child: Text(
          reason ?? l10n.workDocumentApprovalRequired,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning),
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.amount,
    required this.currency,
    this.emphasis = false,
  });

  final String label;
  final double amount;
  final String currency;
  final bool emphasis;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: emphasis
                  ? AppTextStyles.titleSmall
                  : AppTextStyles.bodyMedium,
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Text(
            _formatAmount(amount, currency),
            textDirection: TextDirection.ltr,
            style:
                (emphasis ? AppTextStyles.titleSmall : AppTextStyles.bodyMedium)
                    .copyWith(
              color: emphasis ? AppColors.primary : AppColors.textPrimary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      );
}

String _formatAmount(double amount, String currency) =>
    '${amount.toStringAsFixed(2)} $currency';
