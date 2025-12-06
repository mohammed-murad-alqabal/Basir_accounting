import 'package:basser_app/features/auth/presentation/screens/login_screen.dart';
import 'package:basser_app/features/auth/presentation/screens/setup_screen.dart';
import 'package:basser_app/features/customers/presentation/screens/customers_screen.dart';
import 'package:basser_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:basser_app/features/invoices/presentation/screens/invoices_screen.dart';
import 'package:basser_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:basser_app/features/testing/button_test_screen.dart';
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
  /// Navigator.pushNamed(context, '/dashboard');
  /// ```
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/setup':
        return MaterialPageRoute(builder: (_) => const SetupScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case '/customers':
        return MaterialPageRoute(builder: (_) => const CustomersScreen());
      case '/invoices':
        return MaterialPageRoute(builder: (_) => const InvoicesScreen());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case '/button-test':
        return MaterialPageRoute(builder: (_) => const ButtonTestScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('الشاشة غير موجودة: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
