import 'dart:async';

import 'package:basser_app/core/constants.dart';
import 'package:basser_app/core/router.dart';
import 'package:basser_app/core/theme.dart';
import 'package:basser_app/features/auth/data/services/auth_service.dart';
import 'package:basser_app/features/customers/data/models/customer_model.dart';
import 'package:basser_app/features/invoices/data/models/invoice_model.dart';
import 'package:basser_app/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

/// قاعدة البيانات المحلية Isar
late Isar isar;

/// خدمة التخزين الآمن
late FlutterSecureStorage secureStorage;

/// خدمة المصادقة
late AuthService authService;

/// خدمة الإعدادات
late SettingsService settingsService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Isar
  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open(
    [CustomerModelSchema, InvoiceModelSchema],
    directory: dir.path,
  );

  // تهيئة Secure Storage
  secureStorage = const FlutterSecureStorage();

  // تهيئة الخدمات
  authService = AuthService(secureStorage: secureStorage);
  settingsService = SettingsService(secureStorage: secureStorage);

  runApp(const ProviderScope(child: BasserApp()));
}

/// تطبيق بصير الرئيسي
class BasserApp extends StatelessWidget {
  /// إنشاء تطبيق بصير
  const BasserApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: AppConfig.appName,
        theme: createAppTheme(),
        home: const SplashScreen(),
        onGenerateRoute: AppRouter.generateRoute,
        debugShowCheckedModeBanner: false,
      );
}

/// شاشة البداية (Splash Screen)
///
/// تعرض شعار التطبيق وتتحقق من حالة المصادقة
class SplashScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة البداية
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(_checkAuthStatus());
  }

  Future<void> _checkAuthStatus() async {
    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final hasAccount = await authService.hasAccount();
    final isLoggedIn = await authService.isLoggedIn();

    if (!mounted) return;

    if (!hasAccount) {
      await Navigator.of(context).pushReplacementNamed('/setup');
    } else if (isLoggedIn) {
      await Navigator.of(context).pushReplacementNamed('/dashboard');
    } else {
      await Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppConfig.appName,
                style: TextStyle(
                  fontSize: AppTypography.headlineLarge,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      );
}

/// شاشة تجريبية مؤقتة
///
/// تستخدم كـ placeholder للشاشات قيد التطوير
// ignore_for_file: unreachable_from_main
class PlaceholderScreen extends StatelessWidget {
  /// إنشاء شاشة تجريبية
  const PlaceholderScreen({required this.title, super.key});

  /// عنوان الشاشة
  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(
          child: Text('قريبًا: $title'),
        ),
      );
}
