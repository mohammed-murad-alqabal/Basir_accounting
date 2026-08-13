// السجل الزمني للتدقيق الموحد لنظام بصير المحاسبي.
//
// يعرض أحداث التدقيق (إنشاء/تعديل/اعتماد/ترحيل/إلغاء/عكس) كتسلسل
// زمني: من نفّذ، ماذا فعل، متى، ولماذا — مع إمكانية الرجوع للوثيقة
// المرتبطة عند توفر معرّف المرجع.
//
// المرجع: مخطط UI/UX التنفيذي — القسم 6 (سجل التدقيق) + القسم 7.

import 'package:basir_accounting_system/core/domain/contracts/index.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_colors.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_text_styles.dart';
import 'package:basir_accounting_system/core/theme/tokens/border_widths.dart';
import 'package:basir_accounting_system/core/theme/tokens/font_weights.dart';
import 'package:basir_accounting_system/core/theme/tokens/icon_sizes.dart';
import 'package:basir_accounting_system/core/theme/tokens/spacing.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// عنصر سجل تدقيق واحد معروضة داخل [WorkAuditTimeline].
class WorkAuditTimelineItem {
  /// يبني عنصرًا من حدث تدقيق مع معرّف عرض.
  const WorkAuditTimelineItem({
    required this.entry,
    this.title,
    this.onReferenceTap,
  });

  /// حدث التدقيق الأساسي.
  final AuditEntry entry;

  /// عنوان العنصر اليدوي (إن لم يُقدَّم يُشتق من نوع الحدث).
  final String? title;

  /// تُستدعى عند النقر على الوثيقة المرجعية المرتبطة.
  final VoidCallback? onReferenceTap;
}

/// السجل الزمني للتدقيق: قائمة أحداث زمنية مرتبة من الأحدث للأقدم.
class WorkAuditTimeline extends StatelessWidget {
  /// يبني السجل بالإلزامية عبر [items].
  const WorkAuditTimeline({
    required this.items,
    super.key,
    this.dateFormat,
    this.emptyLabel,
    this.title,
  });

  /// عناصر السجل (تُعرض من الأحدث إلى الأقدم).
  final List<WorkAuditTimelineItem> items;

  /// نمط عرض التاريخ؛ افتراضيًا يوم/شهر/سنة.
  final DateFormat? dateFormat;

  /// نص وصف حالة الفراغ.
  final String? emptyLabel;

  /// عنوان السجل الظاهر أعلى القائمة.
  final String? title;

  @override
  Widget build(BuildContext context) {
    final sorted = [...items]
      ..sort((a, b) => b.entry.occurredAt.compareTo(a.entry.occurredAt));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.sm,
            ),
            child: Text(
              title!,
              style: AppTextStyles.titleSmall
                  .copyWith(fontWeight: FontWeights.semiBold),
            ),
          ),
        if (sorted.isEmpty)
          Padding(
            padding: const EdgeInsets.all(Spacing.xl),
            child: Semantics(
              label: emptyLabel ?? AppLocalizations.of(context).workAuditEmpty,
              child: Text(
                emptyLabel ?? AppLocalizations.of(context).workAuditEmpty,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textHint),
              ),
            ),
          )
        else
          ...sorted.asMap().entries.map(
                (entry) => _buildTimelineItem(
                  entry.value,
                  entry.key == sorted.length - 1,
                  context,
                ),
              ),
      ],
    );
  }

  Widget _buildTimelineItem(
    WorkAuditTimelineItem item,
    bool isLast,
    BuildContext ctx,
  ) {
    final entry = item.entry;
    final dateFormatter = dateFormat ?? DateFormat.yMMMd('ar');

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTrack(isLast, entry),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title ?? entry.type.localizedLabelOf(ctx),
                          style: AppTextStyles.labelLarge
                              .copyWith(fontWeight: FontWeights.semiBold),
                        ),
                      ),
                      Text(
                        dateFormatter.format(entry.occurredAt),
                        style: AppTextStyles.labelSmall
                            .copyWith(color: AppColors.textHint),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    entry.operatorName,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  if (entry.reason != null) ...[
                    const SizedBox(height: Spacing.xs),
                    Text(
                      entry.reason!,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                  if (entry.referenceId != null) ...[
                    const SizedBox(height: Spacing.xs),
                    Semantics(
                      label: AppLocalizations.of(ctx)
                          .workAuditOpenLinked(entry.referenceId!),
                      button: true,
                      child: GestureDetector(
                        onTap: item.onReferenceTap,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.link,
                              size: IconSizes.xs,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: Spacing.xs),
                            Text(
                              AppLocalizations.of(ctx)
                                  .workAuditLinkedDoc(entry.referenceId!),
                              style: AppTextStyles.bodySmall
                                  .copyWith(color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrack(bool isLast, AuditEntry entry) => Column(
        children: [
          const SizedBox(height: Spacing.sm),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: entry.type.semanticColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              entry.type.icon,
              size: IconSizes.xs,
              color: AppColors.textOnDark,
            ),
          ),
          if (!isLast)
            Expanded(
              child: Container(
                width: BorderWidths.normal,
                color: AppColors.borderLight,
              ),
            )
          else
            const SizedBox(height: Spacing.sm),
        ],
      );
}
