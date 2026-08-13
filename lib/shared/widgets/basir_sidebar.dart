import 'package:basir_accounting_system/core/theme/border_contrast_design.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/app_shell.dart';
import 'package:flutter/material.dart' hide Durations;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// نموذج بيانات بند الشريط الجانبي
class SidebarNavItem {
  /// إنشاء بند شريط جانبي
  const SidebarNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.labelKey,
  });

  /// الأيقونة الافتراضية
  final IconData icon;

  /// أيقونة الحالة المحددة
  final IconData selectedIcon;

  /// مفتاح l10n للتسمية
  final String labelKey;
}

/// بنود الشريط الجانبي الثمانية (لوحة متابعة، مبيعات، مشتريات، حسابات،
/// مخزون، أسعار وضرائب، تقارير، إدارة) مع تكييفها لشاشات المشروع الحالية
const List<SidebarNavItem> basirSidebarItems = [
  SidebarNavItem(
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
    labelKey: 'navHome',
  ),
  SidebarNavItem(
    icon: Icons.receipt_long_outlined,
    selectedIcon: Icons.receipt_long,
    labelKey: 'navInvoices',
  ),
  SidebarNavItem(
    icon: Icons.business_center_outlined,
    selectedIcon: Icons.business_center,
    labelKey: 'navVendors',
  ),
  SidebarNavItem(
    icon: Icons.people_outline,
    selectedIcon: Icons.people,
    labelKey: 'navCustomers',
  ),
  SidebarNavItem(
    icon: Icons.inventory_2_outlined,
    selectedIcon: Icons.inventory_2,
    labelKey: 'navInventory',
  ),
  SidebarNavItem(
    icon: Icons.account_balance_wallet_outlined,
    selectedIcon: Icons.account_balance_wallet,
    labelKey: 'navAssets',
  ),
  SidebarNavItem(
    icon: Icons.analytics_outlined,
    selectedIcon: Icons.analytics,
    labelKey: 'navReports',
  ),
  SidebarNavItem(
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
    labelKey: 'navSettings',
  ),
];

/// الشريط الجانبي لتطبيق بصير المكتبي
///
/// قابل للطي بين [kSidebarCollapsedWidth] (أيقونات فقط)
/// و[kSidebarExpandedWidth] (أيقونات + تسميات)، مع مؤشر نشط
/// بلون الهوية الأساسي وتباين ≥ 3:1.
class BasirSidebar extends ConsumerWidget {
  /// إنشاء الشريط الجانبي
  const BasirSidebar({
    required this.selectedIndex,
    required this.appIcons,
    required this.l10n,
    super.key,
    this.items = basirSidebarItems,
  });

  /// الفهرس النشط حاليًا
  final int selectedIndex;

  /// أيقونات التطبيق (قابلة للتخصيص)
  final dynamic appIcons;

  /// الترجمات النشطة
  final AppLocalizations l10n;

  /// بنود الشريط (قابلة للتخصيص لاختبارات الوحدات)
  final List<SidebarNavItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collapsed = ref.watch(sidebarCollapsedProvider);
    final brightness = Theme.of(context).brightness;
    final width = sidebarWidthOf(collapsed: collapsed);

    return AnimatedContainer(
      duration: Durations.short,
      curve: AnimationCurves.fastOutSlowIn,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(
            color: BorderContrastDesign.getBorderNormal(brightness),
          ),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(context, ref, collapsed),
          const Divider(height: 1, color: AppColors.divider, thickness: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final isSelected = index == selectedIndex;
                return _buildNavItem(
                  context: context,
                  index: index,
                  item: items[index],
                  isSelected: isSelected,
                  collapsed: collapsed,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// رأس الشريط: شعار بصير + زر الطي
  Widget _buildHeader(BuildContext context, WidgetRef ref, bool collapsed) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return SizedBox(
      height: kTopBarHeight,
      child: Row(
        children: [
          if (!collapsed) ...[
            const SizedBox(width: Spacing.sm),
            const Icon(
              Icons.auto_awesome,
              color: AppColors.primary,
              size: IconSizes.md,
            ),
            const SizedBox(width: Spacing.xs),
            Expanded(
              child: Text(
                l10n.dashboardBasirSystemTitle,
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeights.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          const SizedBox(width: Spacing.sm),
          Semantics(
            button: true,
            label: l10n.shellToggleNav,
            child: SizedBox(
              width: TouchTargets.minimum,
              height: TouchTargets.minimum,
              child: Center(
                child: AnimatedRotation(
                  duration: Durations.fast,
                  turns: (collapsed && !isRtl) || (!collapsed && isRtl)
                      ? 0.5
                      : 0.0,
                  child: const Icon(
                    Icons.chevron_left,
                    color: AppColors.textSecondary,
                    size: IconSizes.md,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: Spacing.sm),
        ].toList(),
      ),
    );
  }

  /// بند واحد في الشريط الجانبي
  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required SidebarNavItem item,
    required bool isSelected,
    required bool collapsed,
  }) {
    final label = _labelFor(item.labelKey);

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {},
          splashColor: AppColors.primary.withValues(alpha: 0.12),
          child: AnimatedContainer(
            duration: Durations.short,
            curve: AnimationCurves.fastOutSlowIn,
            margin: const EdgeInsets.symmetric(
              horizontal: Spacing.sm,
              vertical: Spacing.xs / 2,
            ),
            height: 48,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryLight : Colors.transparent,
              borderRadius: BorderRadius.circular(Radii.sm),
              border: isSelected
                  ? const Border(
                      right: BorderSide(
                        color: AppColors.primary,
                        width: 3,
                      ),
                    )
                  : null,
            ),
            child: Row(
              mainAxisAlignment: collapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                if (!collapsed) const SizedBox(width: Spacing.md),
                Icon(
                  isSelected ? item.selectedIcon : item.icon,
                  size: IconSizes.md,
                  color:
                      isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
                if (!collapsed) ...[
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: Text(
                      label,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontWeight:
                            isSelected ? FontWeights.bold : FontWeights.medium,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ترجمة مفتاح البند إلى التسمية النشطة
  String _labelFor(String key) => switch (key) {
        'navHome' => l10n.navHome,
        'navInvoices' => l10n.navInvoices,
        'navVendors' => l10n.navVendors,
        'navCustomers' => l10n.navCustomers,
        'navInventory' => l10n.navInventory,
        'navAssets' => l10n.navAssets,
        'navReports' => l10n.navReports,
        'navSettings' => l10n.navSettings,
        _ => key,
      };
}
