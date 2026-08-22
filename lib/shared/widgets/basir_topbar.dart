import 'dart:async';

import 'package:basir_accounting_system/core/theme/border_contrast_design.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/navigation/presentation/widgets/omnibar.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/app_shell.dart';
import 'package:flutter/material.dart' hide Durations;

/// الشريط العلوي لتطبيق بصير المكتبي
///
/// يعرض سياق العمل الحالي (المؤسسة/الفرع/الفترة) — وهي بيانات محاسبية
/// توضح مصدر كل رقم يعرض في التطبيق — مع البحث الشامل والإشعارات.
class BasirTopBar extends StatelessWidget {
  /// إنشاء الشريط العلوي
  const BasirTopBar({
    required this.appIcons,
    required this.l10n,
    required this.collapsed,
    super.key,
    this.orgName,
    this.branchName,
    this.periodName,
  });

  /// أيقونات التطبيق (قابلة للتخصيص)
  final dynamic appIcons;

  /// الترجمات النشطة
  final AppLocalizations l10n;

  /// حالة طي الشريط الجانبي (يستخدم لتوحيد المسافات)
  final bool collapsed;

  /// اسم المؤسسة المعروض (افتراضي: المؤسسة الافتراضية)
  final String? orgName;

  /// اسم الفرع المعروض (افتراضي: الفرع الرئيسي)
  final String? branchName;

  /// اسم الفترة المالية المعروضة (افتراضي: الفترة المالية الحالية)
  final String? periodName;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final org = orgName ?? l10n.shellCurrentOrg;
    final branch = branchName ?? l10n.shellCurrentBranch;
    final period = periodName ?? l10n.shellCurrentPeriod;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: BorderContrastDesign.getBorderNormal(brightness),
          ),
        ),
      ),
      child: SizedBox(
        height: kTopBarHeight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // عند ضيق العرض (أقل من نقطة التصفية) تُطوى نصوص الشرائح إلى الأيقونات
            final screenWidth = MediaQuery.sizeOf(context).width;
            final showChipLabels = screenWidth >= kChipLabelBreakpoint;
            return Row(
              children: [
                const SizedBox(width: Spacing.sm),
                _buildContextChip(
                  label: l10n.shellOrgLabel,
                  value: org,
                  icon: Icons.business_outlined,
                  showLabel: showChipLabels,
                ),
                const SizedBox(width: Spacing.xs),
                _buildContextChip(
                  label: l10n.shellBranchLabel,
                  value: branch,
                  icon: Icons.account_tree_outlined,
                  showLabel: showChipLabels,
                ),
                const SizedBox(width: Spacing.xs),
                _buildContextChip(
                  label: l10n.shellPeriodLabel,
                  value: period,
                  icon: Icons.calendar_month_outlined,
                  showLabel: showChipLabels,
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 240),
                    child: BasirGlobalSearchField(
                      l10n: l10n,
                      onTap: () => _showSearchDialog(context),
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                _buildIconButton(
                  icon: Icons.notifications_outlined,
                  semanticsLabel: l10n.shellNotifications,
                  onTap: () => _showNotifications(context, l10n),
                ),
                const SizedBox(width: Spacing.sm),
              ],
            );
          },
        ),
      ),
    );
  }

  /// رقاقة سياق عمل (مؤسسة/فرع/فترة) — تتقلص إلى الأيقونة فقط عند ضيق المساحة
  Widget _buildContextChip({
    required String label,
    required String value,
    required IconData icon,
    required bool showLabel,
  }) => Semantics(
    label: '$label: $value',
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: IconSizes.sm, color: AppColors.textSecondary),
          if (showLabel) ...[
            const SizedBox(width: Spacing.xs),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  value,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeights.medium,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );

  /// زر أيقونة وظيفي (إشعارات/إعدادات)
  Widget _buildIconButton({
    required IconData icon,
    required String semanticsLabel,
    required VoidCallback onTap,
  }) => Semantics(
    button: true,
    label: semanticsLabel,
    child: SizedBox(
      width: TouchTargets.minimum,
      height: TouchTargets.minimum,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radii.full),
        splashColor: AppColors.primary.withValues(alpha: 0.12),
        child: Center(child: Icon(icon, color: AppColors.textSecondary)),
      ),
    ),
  );

  void _showNotifications(BuildContext context, AppLocalizations l10n) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.shellNotifications)));
  }

  void _showSearchDialog(BuildContext context) {
    unawaited(showOmnibar<void>(context).then<void>((_) {}));
  }
}

/// حقل البحث الشامل في الشريط العلوي.
///
/// يفتح Omnibar الفعلي الذي يجمع الأوامر ونتائج الوحدات في تجربة واحدة.
class BasirGlobalSearchField extends StatelessWidget {
  /// إنشاء حقل البحث
  const BasirGlobalSearchField({required this.l10n, super.key, this.onTap});

  /// الترجمات النشطة
  final AppLocalizations l10n;

  /// فتح تجربة البحث الشامل.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    textField: true,
    label: l10n.shellSearchAll,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Radii.md),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              size: IconSizes.sm,
              color: AppColors.textHint,
            ),
            const SizedBox(width: Spacing.xs),
            Expanded(
              child: Text(
                l10n.shellSearchHint,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textHint,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: Spacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.xs,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(Radii.xs),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Text(
                '⌘K',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
