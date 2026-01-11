import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/features/assets/presentation/screens/asset_form_screen.dart';
import 'package:basir_accounting_system/features/assets/presentation/screens/assets_screen.dart';
import 'package:basir_accounting_system/features/auth/presentation/screens/guest_upgrade_screen.dart';
import 'package:basir_accounting_system/features/auth/presentation/screens/login_screen.dart';
import 'package:basir_accounting_system/features/auth/presentation/screens/setup_screen.dart';
import 'package:basir_accounting_system/features/customers/presentation/screens/customer_form_screen.dart';
import 'package:basir_accounting_system/features/customers/presentation/screens/customers_screen.dart';
import 'package:basir_accounting_system/features/dashboard/presentation/screens/main_shell.dart';
import 'package:basir_accounting_system/features/inventory/presentation/screens/inventory_item_form_screen.dart';
import 'package:basir_accounting_system/features/inventory/presentation/screens/inventory_items_screen.dart';
import 'package:basir_accounting_system/features/invoices/presentation/screens/invoice_form_screen.dart';
import 'package:basir_accounting_system/features/invoices/presentation/screens/invoices_screen.dart';
import 'package:basir_accounting_system/features/settings/presentation/screens/settings_screen.dart';
import 'package:basir_accounting_system/features/vendors/presentation/screens/vendor_form_screen.dart';
import 'package:basir_accounting_system/features/vendors/presentation/screens/vendors_screen.dart';
import 'package:flutter/material.dart';

/// نظام التوجيه للتطبيق
///
/// يدير التنقل بين جميع شاشات التطبيق باستخدام Named Routes
/// ويوفر معالجة مركزية لجميع المسارات
///
/// Example:
/// ```dart
/// MaterialApp(
///   onGenerateRoute: AppRouter.generateRoute,
///   initialRoute: '/setup',
/// )
/// ```
class AppRouter {
  /// توليد المسار المناسب بناءً على الاسم
  ///
  /// يستقبل [RouteSettings] ويعيد [Route] المناسب للشاشة المطلوبة
  ///
  /// Parameters:
  /// - [settings]: إعدادات المسار تحتوي على اسم المسار والمعاملات
  ///
  /// Returns: [Route] للشاشة المطلوبة أو شاشة خطأ إذا لم يتم العثور على المسار
  ///
  /// المسارات المتاحة:
  /// - `/setup`: شاشة الإعداد الأولي
  /// - `/login`: شاشة تسجيل الدخول
  /// - `/dashboard`: لوحة التحكم الرئيسية
  /// - `/customers`: شاشة إدارة العملاء
  /// - `/invoices`: شاشة إدارة الفواتير
  /// - `/settings`: شاشة الإعدادات
  /// - `/button-test`: شاشة اختبار الأزرار (debug only)
  ///
  /// Example:
  /// ```dart
  /// Navigator.pushNamed(context, '/dashboard',);
  /// ```
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/setup':
        return MaterialPageRoute(builder: (_) => const SetupScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const MainShell());
      case '/customers':
        return MaterialPageRoute(builder: (_) => const CustomersScreen());
      case '/vendors':
        return MaterialPageRoute(builder: (_) => const VendorsScreen());
      case '/invoices':
        return MaterialPageRoute(builder: (_) => const InvoicesScreen());
      case '/invoice-form':
        return MaterialPageRoute(builder: (_) => const InvoiceFormScreen());
      case '/customer-form':
        return MaterialPageRoute(builder: (_) => const CustomerFormScreen());
      case '/vendor-form':
        return MaterialPageRoute(builder: (_) => const VendorFormScreen());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case '/inventory':
        return MaterialPageRoute(builder: (_) => const InventoryItemsScreen());
      case '/inventory-form':
        return MaterialPageRoute(
          builder: (_) => const InventoryItemFormScreen(),
        );
      case '/assets':
        return MaterialPageRoute(builder: (_) => const AssetsScreen());
      case '/asset-form':
        return MaterialPageRoute(builder: (_) => const AssetFormScreen());

      case '/guest-upgrade':
        return MaterialPageRoute(builder: (_) => const GuestUpgradeScreen());
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text(
                context.l10n.errorScreenNotFound(settings.name ?? ''),
              ),
            ),
          ),
        );
    }
  }
}
