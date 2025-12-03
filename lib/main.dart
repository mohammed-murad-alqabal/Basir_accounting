import 'dart:async';

import 'package:basser_app/core/constants.dart';
import 'package:basser_app/core/providers.dart';
import 'package:basser_app/core/router.dart';
import 'package:basser_app/core/theme.dart';
import 'package:basser_app/features/auth/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        // إعدادات اللغة العربية والاتجاه من اليمين لليسار
        locale: const Locale('ar', 'SA'),
        supportedLocales: const [
          Locale('ar', 'SA'), // العربية
          Locale('en', 'US'), // الإنجليزية
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // تحديد اتجاه النص بناءً على اللغة
        localeResolutionCallback: (locale, supportedLocales) {
          // إذا كانت اللغة عربية، استخدم RTL
          if (locale?.languageCode == 'ar') {
            return const Locale('ar', 'SA');
          }
          // وإلا استخدم الإنجليزية
          return const Locale('en', 'US');
        },
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
  String? _error;

  @override
  void initState() {
    super.initState();
    // تهيئة Isar من خلال provider
    unawaited(_initializeApp());
  }

  Future<void> _initializeApp() async {
    try {
      // 1. تهيئة Isar من خلال provider
      setState(() => _status = 'جاري فتح قاعدة البيانات...');
      await ref.read(isarProvider.future);

      // 2. تهيئة الخدمات من خلال providers
      setState(() => _status = 'جاري تهيئة الخدمات...');
      final authService = ref.read(authServiceProvider);

      // 3. التحقق من حالة المصادقة
      setState(() => _status = 'جاري التحقق من الحساب...');
      await _checkAuthStatus(authService);
    } on Exception catch (e) {
      setState(() {
        _status = 'حدث خطأ أثناء التهيئة';
        _error = e.toString();
      });
      // عرض رسالة خطأ للمستخدم
      if (mounted) {
        unawaited(
          ScaffoldMessenger.of(context)
              .showSnackBar(
                SnackBar(
                  content: Text('خطأ: $e'),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 5),
                ),
              )
              .closed,
        );
      }
    }
  }

  Future<void> _checkAuthStatus(AuthService authService) async {
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
              if (_error == null)
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              else
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.white70,
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
              if (_error != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Text(
                    _error!,
                    style: const TextStyle(
                      fontSize: AppTypography.bodySmall,
                      color: Colors.white60,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
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
