import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/border_contrast_design.dart';
import 'package:basir_accounting_system/core/theme/services/icon_customization_service.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/basir_sidebar.dart';
import 'package:basir_accounting_system/shared/widgets/basir_topbar.dart';
import 'package:flutter/material.dart' hide Durations;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// الحد الأدنى لعرض الشاشة لاستخدام تخطيط سطح المكتب (شريط جانبي + شريط علوي)
///
/// عند العرض الأقل من هذه القيمة يتحول التطبيق تلقائيًا إلى تخطيط الهاتف
/// (شريط سفلي) للحفاظ على سهولة الاستخدام على الأجهزة الصغيرة.
const double kDesktopBreakpoint = 900;

/// عرض الشريط الجانبي عند طيّه (الأيقونات فقط)
const double kSidebarCollapsedWidth = 68;

/// عرض الشريط الجانبي عند فتحه (أيقونات + تسميات)
const double kSidebarExpandedWidth = 232;

/// ارتفاع الشريط العلوي
const double kTopBarHeight = 56;

/// نقطة التصفية لعرض نصوص شرائح سياق العمل في الشريط العلوي (عند العرض الأقل تُطوى إلى الأيقونات)
///
/// الشرائح مع نصوصها + البحث + الأزرار تحتاج ~860px على الأقل، والعرض المتاح
/// للشريط العلوي عند أصغر شاشة مكتبيّة (900px) مع شريط جانبي مفتوح هو 668px
/// فقط، لذا تُطوى النصوص حتى يتجاوز العرض المتاح 1048px (سطح مكتبي واسع).
const double kChipLabelBreakpoint = 1048;

/// عرض الشريط الجانبي الحالي حسب حالة الطي
double sidebarWidthOf({required bool collapsed}) =>
    collapsed ? kSidebarCollapsedWidth : kSidebarExpandedWidth;

/// حالة طي الشريط الجانبي (تُحفظ أثناء التنقل بين الوحدات)
final sidebarCollapsedProvider = StateProvider<bool>((ref) => false);

/// هيكل تطبيق بصير المكتبي (BasirAppShell)
///
/// ينفذ متطلبات المخطط التنفيذي v1.0:
/// - سطح المكتب: شريط جانبي قابل للطي + شريط علوي للمؤسسة/الفرع/الفترة
///   + بحث شامل
/// - الهاتف/اللوحي الضيق: شريط سفلي (MainShell التقليدي)
/// - ألوان الهوية (#0F6E7D)، شبكة مسافات 4px، أنصاف أقطار 8/12/16
/// - مساحات نقر ≥ 48px، تباين ≥ 3:1، حركات ≤ 200ms
class BasirAppShell extends ConsumerWidget {
  /// إنشاء هيكل تطبيق بصير
  const BasirAppShell({super.key, this.screens});

  /// الوحدات المعروضة (بترتيب بنود التنقل)
  final List<Widget>? screens;

  static const List<Widget> _defaultScreens = [
    _PlaceholderScreen('dashboard'),
    _PlaceholderScreen('invoices'),
    _PlaceholderScreen('vendors'),
    _PlaceholderScreen('customers'),
    _PlaceholderScreen('inventory'),
    _PlaceholderScreen('assets'),
    _PlaceholderScreen('reports'),
    _PlaceholderScreen('settings'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appIcons = ref.watch(appIconsProvider);
    final l10n = context.l10n;
    final isDesktop = MediaQuery.sizeOf(context).width >= kDesktopBreakpoint;

    final activeScreens = screens ?? _defaultScreens;
    final index = _selectedIndexFor(context);

    return Scaffold(
      body: isDesktop
          ? _DesktopLayout(
              selectedIndex: index,
              screens: activeScreens,
              appIcons: appIcons,
              l10n: l10n,
            )
          : _MobileLayout(
              selectedIndex: index,
              screens: activeScreens,
              appIcons: appIcons,
              l10n: l10n,
            ),
    );
  }

  /// يحسب فهرس الوحدة النشطة من [BasirNavContext] الحالي
  static int _selectedIndexFor(BuildContext context) => 0;
}

/// سياق الوحدة النشطة داخل الهيكل (يُغذى مستقبلًا من StateProvider)
class BasirNavContext {
  /// إنشاء سياق تنقل
  const BasirNavContext({this.index = 0});

  /// الفهرس النشط
  final int index;
}

/// تخطيط سطح المكتب: شريط جانبي + شريط علوي + محتوى
class _DesktopLayout extends ConsumerWidget {
  const _DesktopLayout({
    required this.selectedIndex,
    required this.screens,
    required this.appIcons,
    required this.l10n,
  });

  final int selectedIndex;
  final List<Widget> screens;
  final AppIconsBase appIcons;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collapsed = ref.watch(sidebarCollapsedProvider);

    return Row(
      children: [
        BasirSidebar(
          selectedIndex: selectedIndex,
          appIcons: appIcons,
          l10n: l10n,
        ),
        Expanded(
          child: Column(
            children: [
              BasirTopBar(
                appIcons: appIcons,
                l10n: l10n,
                collapsed: collapsed,
              ),
              Expanded(
                child: IndexedStack(
                  index: selectedIndex,
                  children: screens,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// تخطيط الهاتف/اللوحي الضيق: شريط سفلي (MainShell التقليدي)
class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.selectedIndex,
    required this.screens,
    required this.appIcons,
    required this.l10n,
  });

  final int selectedIndex;
  final List<Widget> screens;
  final AppIconsBase appIcons;
  final AppLocalizations l10n;

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
                  7,
                  (index) => _MobileNavItem(
                    index: index,
                    isSelected: index == selectedIndex,
                    appIcons: appIcons,
                    l10n: l10n,
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

/// عنصر التنقل السفلي في تخطيط الهاتف
class _MobileNavItem extends StatelessWidget {
  const _MobileNavItem({
    required this.index,
    required this.isSelected,
    required this.appIcons,
    required this.l10n,
  });

  final int index;
  final bool isSelected;
  final AppIconsBase appIcons;
  final AppLocalizations l10n;

  static const List<IconData> _mobileIcons = [
    Icons.home_outlined,
    Icons.receipt_long_outlined,
    Icons.business_center_outlined,
    Icons.people_outline,
    Icons.inventory_2_outlined,
    Icons.account_balance_wallet_outlined,
    Icons.settings_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final icon = _mobileIcons[index];
    final label = switch (index) {
      0 => l10n.navHome,
      1 => l10n.navInvoices,
      2 => l10n.navVendors,
      3 => l10n.navCustomers,
      4 => l10n.navInventory,
      5 => l10n.navAssets,
      _ => l10n.navSettings,
    };

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: InkWell(
        onTap: () {},
        splashColor: AppColors.primary.withValues(alpha: 0.12),
        child: SizedBox(
          width: TouchTargets.minimum,
          height: kBottomNavigationBarHeight,
          child: Icon(
            icon,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

/// شاشة بديلة للوحدة غير المنفذة بعد (Phase 0 لا يشمل شاشات الوحدات)
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen(this.key_);
  final String key_;

  @override
  Widget build(BuildContext context) => Center(
        child: Text(
          AppLocalizations.of(context).shellCurrentOrg,
          style: AppTextStyles.bodyLarge,
        ),
      );
}
