// ignore_for_file: discarded_futures
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/border_contrast_design.dart';
import 'package:basir_accounting_system/core/theme/services/icon_customization_service.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/assets/presentation/screens/assets_screen.dart';
import 'package:basir_accounting_system/features/customers/presentation/screens/customers_screen.dart';
import 'package:basir_accounting_system/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:basir_accounting_system/features/inventory/presentation/screens/inventory_items_screen.dart';
import 'package:basir_accounting_system/features/invoices/presentation/screens/invoices_screen.dart';
import 'package:basir_accounting_system/features/settings/presentation/screens/settings_screen.dart';
import 'package:basir_accounting_system/features/vendors/presentation/screens/vendors_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart' hide Durations;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// الهيكل الرئيسي للتطبيق (Main Shell)
///
/// المتطلبات:
/// - لون مميز واضح للعنصر النشط (تباين ≥ 3:1)
/// - تحديث فوري للمؤشر خلال 200ms
/// - حجم الأيقونات 24px (IconSizes.md)
/// - مساحة نقر لا تقل عن 48x48px
/// - حركات انتقالية سلسة بين الشاشات
class MainShell extends ConsumerStatefulWidget {
  /// إنشاء الهيكل الرئيسي للتطبيق
  const MainShell({
    super.key,
    this.screens,
  });

  final List<Widget>? screens;

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> with TickerProviderStateMixin {
  late int _selectedIndex;
  late AnimationController _indicatorController;
  late AnimationController _pageTransitionController;

  static const Duration _indicatorUpdateDuration = Durations.short;
  static const double _indicatorElevationBoost = 4;

  static const List<Widget> _defaultScreens = [
    DashboardScreen(),
    InvoicesScreen(),
    VendorsScreen(),
    CustomersScreen(),
    InventoryItemsScreen(),
    AssetsScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _indicatorController = AnimationController(
      vsync: this,
      duration: _indicatorUpdateDuration,
      value: 1,
    );
    _pageTransitionController = AnimationController(
      vsync: this,
      duration: Durations.short3,
      value: 1,
    );
  }

  @override
  void dispose() {
    _indicatorController.dispose();
    _pageTransitionController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    HapticFeedback.selectionClick();

    setState(() {
      _selectedIndex = index;
    });

    _indicatorController.forward(from: 0);
    _pageTransitionController.forward(from: 0);
  }

  List<_NavItemData> _buildNavItems(
    AppIconsBase appIcons,
    AppLocalizations l10n,
  ) =>
      [
        _NavItemData(
          icon: appIcons.home,
          label: l10n.navHome,
          semanticLabel: 'الصفحة الرئيسية',
        ),
        _NavItemData(
          icon: appIcons.invoices,
          label: l10n.navInvoices,
          semanticLabel: 'الفواتير',
        ),
        _NavItemData(
          icon: Icons.business_center,
          label: l10n.navVendors,
          semanticLabel: 'الموردون',
        ),
        _NavItemData(
          icon: appIcons.customers,
          label: l10n.navCustomers,
          semanticLabel: 'العملاء',
        ),
        _NavItemData(
          icon: Icons.inventory_2,
          label: l10n.navInventory,
          semanticLabel: 'المخزون',
        ),
        _NavItemData(
          icon: Icons.account_balance_wallet_outlined,
          label: l10n.navAssets,
          semanticLabel: 'الأصول',
        ),
        _NavItemData(
          icon: appIcons.settings,
          label: l10n.navSettings,
          semanticLabel: 'الإعدادات',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final appIcons = ref.watch(appIconsProvider);
    final l10n = context.l10n;
    final brightness = Theme.of(context).brightness;
    final navItems = _buildNavItems(appIcons, l10n);

    return Scaffold(
      body: AnimatedBuilder(
        animation: _pageTransitionController,
        builder: (context, child) {
          final animValue = Curves.easeOut.transform(
            _pageTransitionController.value,
          );
          return Opacity(
            opacity: 0.92 + 0.08 * animValue,
            child: Transform.translate(
              offset: Offset(0, (1 - animValue) * 2),
              child: child,
            ),
          );
        },
        child: IndexedStack(
          index: _selectedIndex,
          children: widget.screens ?? _defaultScreens,
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: Elevation.md,
              offset: Offset(0, -Elevation.sm / 2),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: BorderContrastDesign.getBorderNormal(brightness),
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: kBottomNavigationBarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(navItems.length, (index) {
                final isSelected = index == _selectedIndex;
                return _buildNavItem(
                  item: navItems[index],
                  index: index,
                  isSelected: isSelected,
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required _NavItemData item,
    required int index,
    required bool isSelected,
  }) =>
      Semantics(
        button: true,
        selected: isSelected,
        label: item.semanticLabel,
        hint: isSelected ? 'عنصر التنقل المحدد حالياً' : 'اضغط للانتقال',
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => _onItemTapped(index),
            borderRadius: BorderRadius.circular(Radii.md),
            splashColor: AppColors.primary.withValues(alpha: 0.12),
            highlightColor: Colors.transparent,
            child: SizedBox(
              width: TouchTargets.minimum,
              height: kBottomNavigationBarHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedScale(
                    duration: _indicatorUpdateDuration,
                    curve: AnimationCurves.fastOutSlowIn,
                    scale: isSelected ? 1.1 : 1.0,
                    child: AnimatedContainer(
                      duration: _indicatorUpdateDuration,
                      curve: AnimationCurves.fastOutSlowIn,
                      padding: EdgeInsets.all(isSelected ? Spacing.xs : 0),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryLight : Colors.transparent,
                        borderRadius: BorderRadius.circular(Radii.sm),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.12,
                                  ),
                                  blurRadius: _indicatorElevationBoost,
                                  offset: const Offset(0, Elevation.sm / 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        item.icon,
                        size: IconSizes.md,
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  AnimatedDefaultTextStyle(
                    duration: _indicatorUpdateDuration,
                    curve: AnimationCurves.fastOutSlowIn,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeights.bold : FontWeights.medium,
                    ),
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textScaler: TextScaler.noScaling,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _NavItemData {
  const _NavItemData({
    required this.icon,
    required this.label,
    required this.semanticLabel,
  });
  final IconData icon;
  final String label;
  final String semanticLabel;
}
