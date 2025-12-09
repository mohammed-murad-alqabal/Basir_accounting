import 'dart:async';

import 'package:basser_app/core/assets/app_logo.dart';
import 'package:basser_app/core/constants.dart';
import 'package:basser_app/core/providers.dart';
import 'package:basser_app/core/router.dart';
import 'package:basser_app/core/theme.dart';
import 'package:basser_app/core/theme_dark.dart';
import 'package:basser_app/features/auth/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // تهيئة Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // تحسين الأداء: تعيين اتجاه النظام
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // بدء التطبيق
  runApp(const ProviderScope(child: BasserApp()));
}

/// تطبيق بصير الرئيسي
class BasserApp extends ConsumerWidget {
  /// إنشاء تطبيق بصير
  const BasserApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // مراقبة حالة الثيم من provider
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: AppConfig.appName,
      theme: createAppTheme(),
      darkTheme: createDarkTheme(),
      themeMode: themeMode,
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
      // ✅ تهيئة متوازية لتحسين الأداء (إزالة التأخير الاصطناعي)
      setState(() => _status = 'جاري التهيئة...');

      // تهيئة جميع الخدمات بالتوازي لتحسين الأداء
      await Future.wait([
        ref.read(isarProvider.future),
        // يمكن إضافة خدمات أخرى هنا للتهيئة المتوازية
      ]);

      // التحقق من حالة المصادقة
      setState(() => _status = 'جاري التحقق من الحساب...');
      final authService = ref.read(authServiceProvider);
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
          // استخدام الشعار المخصص بدلاً من Material Icon
          const BasserLogo(size: 100),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            AppConfig.appName,
            style: TextStyle(
              fontSize: AppTypography.headlineLarge,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            AppConfig.appDescription,
            style: TextStyle(
              fontSize: AppTypography.bodyMedium,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          if (_error == null)
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            )
          else
            const Icon(Icons.error_outline, size: 48, color: Colors.white70),
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
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
    body: Center(child: Text('قريبًا: $title')),
  );
}
