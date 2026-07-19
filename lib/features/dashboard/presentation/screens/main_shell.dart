import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/services/icon_customization_service.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/assets/presentation/screens/assets_screen.dart';
import 'package:basir_accounting_system/features/customers/presentation/screens/customers_screen.dart';
import 'package:basir_accounting_system/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:basir_accounting_system/features/inventory/presentation/screens/inventory_items_screen.dart';
import 'package:basir_accounting_system/features/invoices/presentation/screens/invoices_screen.dart';
import 'package:basir_accounting_system/features/settings/presentation/screens/settings_screen.dart';
import 'package:basir_accounting_system/features/vendors/presentation/screens/vendors_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// الهيكل الرئيسي للتطبيق (Main Shell)
///
/// يدير التنقل السفلي ويحافظ على حالة الشاشات الأساسية
/// باستخدام [IndexedStack].
class MainShell extends ConsumerStatefulWidget {
  /// إنشاء الهيكل الرئيسي للتطبيق
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    InvoicesScreen(),
    VendorsScreen(),
    CustomersScreen(),
    InventoryItemsScreen(),
    AssetsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appIcons = ref.watch(appIconsProvider);

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: [
            BottomNavigationBarItem(
              icon: Icon(appIcons.home),
              label: context.l10n.navHome,
            ),
            BottomNavigationBarItem(
              icon: Icon(appIcons.invoices),
              label: context.l10n.navInvoices,
            ),
            BottomNavigationBarItem(
              icon: Icon(appIcons.customers),
              label: context.l10n.navCustomers,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.business_center),
              label: context.l10n.navVendors,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.inventory_2),
              label: context.l10n.navInventory,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_balance_wallet_outlined),
              label: context.l10n.navAssets,
            ),
            BottomNavigationBarItem(
              icon: Icon(appIcons.settings),
              label: context.l10n.navSettings,
            ),
          ],
        ),
      ),
    );
  }
}
