import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/border_contrast_design.dart';
import 'package:basir_accounting_system/core/theme/services/icon_customization_service.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/assets/presentation/screens/assets_screen.dart';
import 'package:basir_accounting_system/features/customers/presentation/screens/customers_screen.dart';
import 'package:basir_accounting_system/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:basir_accounting_system/features/inventory/presentation/screens/inventory_items_screen.dart';
import 'package:basir_accounting_system/features/invoices/presentation/screens/invoices_screen.dart';
import 'package:basir_accounting_system/features/reports/presentation/screens/reports_dashboard_screen.dart';
import 'package:basir_accounting_system/features/settings/presentation/screens/settings_screen.dart';
import 'package:basir_accounting_system/features/vendors/presentation/screens/vendors_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/basir_sidebar.dart';
import 'package:basir_accounting_system/shared/widgets/basir_topbar.dart';
import 'package:flutter/material.dart' hide Durations;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// الحد الأدنى لعرض الشاشة لاستخدام تخطيط سطح المكتب (شريط جانبي + شريط علوي).
const double kDesktopBreakpoint = 900;

/// عرض الشريط الجانبي عند طيّه (الأيقونات فقط).
const double kSidebarCollapsedWidth = 68;

/// عرض الشريط الجانبي عند فتحه (أيقونات + تسميات).
const double kSidebarExpandedWidth = 232;

/// ارتفاع الشريط العلوي.
const double kTopBarHeight = 56;

/// نقطة عرض نصوص سياق العمل في الشريط العلوي.
const double kChipLabelBreakpoint = 1048;

/// عرض الشريط الجانبي الحالي حسب حالة الطي.
double sidebarWidthOf({required bool collapsed}) =>
    collapsed ? kSidebarCollapsedWidth : kSidebarExpandedWidth;

/// حالة طي الشريط الجانبي، وتبقى مستقلة عن فهرس الوحدة النشطة.
final sidebarCollapsedProvider = StateProvider<bool>((ref) => false);

/// هيكل تطبيق بصير المتجاوب.
///
/// يحتفظ بفهرس الوحدة في حالة واحدة مشتركة بين تخطيط المكتب والهاتف. وبذلك لا
/// يختلف سلوك التنقل باختلاف حجم الشاشة، ولا تظهر شاشة بديلة عند فتح المسار
/// الرئيسي في التطبيق الفعلي.
class BasirAppShell extends ConsumerStatefulWidget {
  /// إنشاء هيكل تطبيق بصير.
  const BasirAppShell({super.key, this.screens, this.initialIndex = 0});

  /// الوحدات المعروضة، وتستخدم للاختبارات أو التخصيص المؤسسي.
  final List<Widget>? screens;

  /// الوحدة التي تظهر عند فتح الهيكل.
  final int initialIndex;

  @override
  ConsumerState<BasirAppShell> createState() => _BasirAppShellState();
}

class _BasirAppShellState extends ConsumerState<BasirAppShell> {
  late int _selectedIndex;
  late final Set<int> _visitedIndices;

  static const List<Widget> _defaultScreens = [
    DashboardScreen(),
    InvoicesScreen(),
    VendorsScreen(),
    CustomersScreen(),
    InventoryItemsScreen(),
    AssetsScreen(),
    ReportsDashboardScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, _screenCount - 1).toInt();
    _visitedIndices = {_selectedIndex};
  }

  int get _screenCount => (widget.screens ?? _defaultScreens).length;

  /// يبني الشاشة النشطة والشاشات التي زارها المستخدم فقط.
  ///
  /// هذا يحافظ على حالة الوحدات التي فُتحت سابقًا، ويمنع تهيئة مزودي البيانات
  /// الثقيلة للشاشات غير المستخدمة عند تحميل الهيكل الرئيسي.
  List<Widget> _screenStack(List<Widget> screens) => List<Widget>.generate(
    screens.length,
    (index) => _visitedIndices.contains(index)
        ? screens[index]
        : const SizedBox.shrink(),
  );

  void _selectIndex(int index) {
    if (index < 0 || index >= _screenCount || index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
      _visitedIndices.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appIcons = ref.watch(appIconsProvider);
    final l10n = context.l10n;
    final screens = widget.screens ?? _defaultScreens;
    final isDesktop = MediaQuery.sizeOf(context).width >= kDesktopBreakpoint;

    return Scaffold(
      body: isDesktop
          ? _DesktopLayout(
              selectedIndex: _selectedIndex,
              screens: _screenStack(screens),
              appIcons: appIcons,
              l10n: l10n,
              onItemSelected: _selectIndex,
            )
          : _MobileLayout(
              selectedIndex: _selectedIndex,
              screens: _screenStack(screens),
              appIcons: appIcons,
              l10n: l10n,
              onItemSelected: _selectIndex,
            ),
    );
  }
}

/// سياق الوحدة النشطة داخل الهيكل.
class BasirNavContext {
  /// إنشاء سياق تنقل.
  const BasirNavContext({this.index = 0});

  /// الفهرس النشط.
  final int index;
}

/// تخطيط سطح المكتب: شريط جانبي + شريط علوي + محتوى.
class _DesktopLayout extends ConsumerWidget {
  const _DesktopLayout({
    required this.selectedIndex,
    required this.screens,
    required this.appIcons,
    required this.l10n,
    required this.onItemSelected,
  });

  final int selectedIndex;
  final List<Widget> screens;
  final AppIconsBase appIcons;
  final AppLocalizations l10n;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collapsed = ref.watch(sidebarCollapsedProvider);

    return Row(
      children: [
        BasirSidebar(
          selectedIndex: selectedIndex,
          appIcons: appIcons,
          l10n: l10n,
          onItemSelected: onItemSelected,
        ),
        Expanded(
          child: Column(
            children: [
              BasirTopBar(appIcons: appIcons, l10n: l10n, collapsed: collapsed),
              Expanded(
                child: IndexedStack(index: selectedIndex, children: screens),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// تخطيط الهاتف/اللوحي الضيق: شريط علوي وشريط إجراءات سفلي سياقي.
class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.selectedIndex,
    required this.screens,
    required this.appIcons,
    required this.l10n,
    required this.onItemSelected,
  });

  final int selectedIndex;
  final List<Widget> screens;
  final AppIconsBase appIcons;
  final AppLocalizations l10n;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Column(
      children: [
        BasirTopBar(appIcons: appIcons, l10n: l10n, collapsed: false),
        Expanded(
          child: IndexedStack(index: selectedIndex, children: screens),
        ),
        DecoratedBox(
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
                children: List.generate(
                  screens.length,
                  (index) => _MobileNavItem(
                    index: index,
                    isSelected: index == selectedIndex,
                    appIcons: appIcons,
                    l10n: l10n,
                    onTap: () => onItemSelected(index),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// عنصر التنقل السفلي في تخطيط الهاتف.
class _MobileNavItem extends StatelessWidget {
  const _MobileNavItem({
    required this.index,
    required this.isSelected,
    required this.appIcons,
    required this.l10n,
    required this.onTap,
  });

  final int index;
  final bool isSelected;
  final AppIconsBase appIcons;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  static const List<IconData> _mobileIcons = [
    Icons.home_outlined,
    Icons.receipt_long_outlined,
    Icons.business_center_outlined,
    Icons.people_outline,
    Icons.inventory_2_outlined,
    Icons.account_balance_wallet_outlined,
    Icons.analytics_outlined,
    Icons.settings_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final icon = index < _mobileIcons.length
        ? _mobileIcons[index]
        : Icons.apps_outlined;
    final label = switch (index) {
      0 => l10n.navHome,
      1 => l10n.navInvoices,
      2 => l10n.navVendors,
      3 => l10n.navCustomers,
      4 => l10n.navInventory,
      5 => l10n.navAssets,
      6 => l10n.navReports,
      _ => l10n.navSettings,
    };

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          splashColor: AppColors.primary.withValues(alpha: 0.12),
          child: SizedBox(
            width: TouchTargets.minimum,
            height: kBottomNavigationBarHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight: isSelected
                        ? FontWeights.bold
                        : FontWeights.medium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
