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

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // بدء التطبيق فوراً بدون انتظار
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
  String _status = 'جاري التهيئة...';

  @override
  void initState() {
    super.initState();
    unawaited(_initializeApp());
  }

  Future<void> _initializeApp() async {
    try {
      // 1. تهيئة Isar
      setState(() => _status = 'جاري فتح قاعدة البيانات...');
      final dir = await getApplicationDocumentsDirectory();
      isar = await Isar.open(
        [CustomerModelSchema, InvoiceModelSchema],
        directory: dir.path,
      );

      // 2. تهيئة Secure Storage
      setState(() => _status = 'جاري تهيئة التخزين الآمن...');
      secureStorage = const FlutterSecureStorage();

      // 3. تهيئة الخدمات
      setState(() => _status = 'جاري تهيئة الخدمات...');
      authService = AuthService(secureStorage: secureStorage);
      settingsService = SettingsService(secureStorage: secureStorage);

      // 4. التحقق من حالة المصادقة
      setState(() => _status = 'جاري التحقق من الحساب...');
      await _checkAuthStatus();
    } on Exception catch (e) {
      setState(() => _status = 'حدث خطأ: $e');
      // يمكن إضافة معالجة الخطأ هنا
    }
  }

  Future<void> _checkAuthStatus() async {
    if (!mounted) return;

    final hasAccount = await authService.hasAccount();
    final isLoggedIn = await authService.isLoggedIn();
    final isGuest = await authService.isGuest();
    final keepLoggedIn = await authService.shouldKeepLoggedIn();

    if (!mounted) return;

    // إذا كان ضيف أو مسجل دخول مع البقاء مسجلاً
    if (isGuest || (isLoggedIn && keepLoggedIn)) {
      await Navigator.of(context).pushReplacementNamed('/dashboard');
    } else if (!hasAccount) {
      // لا يوجد حساب - اذهب للإعداد أو تسجيل الدخول
      await Navigator.of(context).pushReplacementNamed('/login');
    } else if (isLoggedIn) {
      // مسجل دخول لكن بدون البقاء مسجلاً
      await Navigator.of(context).pushReplacementNamed('/dashboard');
    } else {
      // يوجد حساب لكن غير مسجل دخول
      await Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.receipt_long,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                AppConfig.appName,
                style: TextStyle(
                  fontSize: AppTypography.headlineLarge,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                _status,
                style: const TextStyle(
                  fontSize: AppTypography.bodySmall,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
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
