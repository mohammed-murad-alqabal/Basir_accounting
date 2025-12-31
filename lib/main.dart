import 'dart:async';

import 'package:basser_app/core/assets/app_logo.dart';
import 'package:basser_app/core/constants.dart';
import 'package:basser_app/core/extensions/context_extensions.dart';
import 'package:basser_app/core/providers.dart';
import 'package:basser_app/core/router.dart';
import 'package:basser_app/core/theme/app_theme.dart';
import 'package:basser_app/core/theme/font_manager.dart';
import 'package:basser_app/core/theme/services/color_customization_service.dart';
import 'package:basser_app/core/theme/services/font_customization_service.dart';
import 'package:basser_app/core/theme/tokens/index.dart';
import 'package:basser_app/core/utils/provider_observer.dart';
import 'package:basser_app/core/widgets/error_widget.dart' as basser;
import 'package:basser_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // تهيئة Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة FontManager
  await FontManager.initialize();

  // تحسين الأداء: تعيين اتجاه النظام
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  // إعداد شاشة الأخطاء العالمية
  // ignore: lines_longer_than_80_chars
  ErrorWidget.builder =
      (details) => basser.GlobalErrorWidget(errorDetails: details);

  // تهيئة الخدمات الأساسية قبل البدء
  final container = ProviderContainer(
    observers: [BasserProviderObserver()],
  );

  try {
    // تهيئة AuthService (تنظيف البيانات القديمة عند إعادة التثبيت)
    await container.read(authServiceProvider).initialize();
    // ignore: avoid_catches_without_on_clauses
  } catch (e, stackTrace) {
    debugPrint('❌ Critical initialization error: $e');
    debugPrint('Stack trace: $stackTrace');
  }

  // بدء التطبيق
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const BasserApp(),
    ),
  );
}

/// تطبيق بصير الرئيسي
class BasserApp extends ConsumerWidget {
  /// إنشاء تطبيق بصير
  const BasserApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // مراقبة حالة الثيم (AsyncValue)
    final themeModeAsync = ref.watch(themeProvider);
    final customColorAsync = ref.watch(colorCustomizationProvider);
    final fontCustomizationAsync = ref.watch(fontCustomizationProvider);
    final localeAsync = ref.watch(localeProvider);

    return themeModeAsync.when(
      data: (themeMode) {
        final seedColor = customColorAsync.value;
        final fontState = fontCustomizationAsync.value;
        final fontFamily = fontState?.fontFamily;
        final textScale = fontState?.textScaleFactor ?? 1.0;
        final locale = localeAsync.value ?? const Locale('ar');

        return MaterialApp(
          title: AppConfig.appName,
          // ... (theme config) ...
          theme: AppTheme.getTheme(
            mode: ThemeMode.light,
            seedColor: seedColor,
            fontFamily: fontFamily,
            textScaleFactor: textScale,
          ),
          darkTheme: AppTheme.getTheme(
            mode: ThemeMode.dark,
            seedColor: seedColor,
            fontFamily: fontFamily,
            textScaleFactor: textScale,
          ),
          themeMode: themeMode,
          home: const SplashScreen(),
          onGenerateRoute: AppRouter.generateRoute,
          debugShowCheckedModeBanner: false,
          // إعدادات اللغة (ديناميكية)
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // تحديد اتجاه النص بناءً على اللغة
          localeResolutionCallback: (locale, supportedLocales) {
            // إذا كانت اللغة عربية، استخدم RTL
            if (locale?.languageCode == 'ar') {
              return const Locale(
                'ar',
                'SA',
              );
            }
            // وإلا استخدم الإنجليزية
            return const Locale(
              'en',
              'US',
            );
          },
        );
      },
      loading: () => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color(0xFF003D82), // لون البراند الأساسي
          body: Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ),
      ),
      error: (err, stack) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: basser.GlobalErrorWidget(
          errorDetails: FlutterErrorDetails(
            exception: err,
            stack: stack,
            library: 'Theme Initialization',
          ),
        ),
      ),
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
  String? _error;
  late String _status;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _status = context.l10n.splashInitializing;
  }

  @override
  void initState() {
    super.initState();
    // تأخير التهيئة للسماح برسم الشاشة الأولى (Splash UI)
    // هذا يمنع ظهور الشاشة البيضاء أثناء تحميل Isar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_initializeApp());
    });
  }

  Future<void> _initializeApp() async {
    try {
      debugPrint('🚀 [SYSTEM] Institutional Initialization Started...');

      // تهيئة الخدمات الأساسية بالتوازي (Zero Latency Strategy)
      // ننتظر Isar ونتأكد من جاهزية AuthService
      final initStartTime = DateTime.now();

      await Future.wait([
        ref.read(isarProvider.future),
        // نتأكد من أن AuthService جاهز للاستخدام
        ref.read(authServiceProvider).initialize(),
      ]);

      final duration = DateTime.now().difference(initStartTime).inMilliseconds;
      debugPrint('⚙️ [SYSTEM] Core Services Ready in ${duration}ms');

      // التحقق من حالة المصادقة للانتقال السريع
      final authService = ref.read(authServiceProvider);

      // جلب جميع الحالات في طلب واحد متوازي (Optimization)
      final results = await Future.wait([
        authService.hasAccount(),
        authService.isLoggedIn(),
        authService.isGuest(),
        authService.shouldKeepLoggedIn(),
      ]);

      final hasAccount = results[0];
      final isLoggedIn = results[1];
      final isGuest = results[2];
      final keepLoggedIn = results[3];

      if (!mounted) return;

      debugPrint(
        '🔑 [AUTH] Account: $hasAccount, '
        'LoggedIn: $isLoggedIn, Guest: $isGuest',
      );

      // اتخاذ قرار التوجيه الفوري
      if (isGuest || (isLoggedIn && keepLoggedIn)) {
        await Navigator.of(context).pushReplacementNamed('/dashboard');
      } else if (!hasAccount) {
        await Navigator.of(context).pushReplacementNamed('/login');
      } else if (isLoggedIn) {
        await Navigator.of(context).pushReplacementNamed('/dashboard');
      } else {
        await Navigator.of(context).pushReplacementNamed('/login');
      }
    } on Exception catch (e) {
      debugPrint('❌ [FATAL] Initialization Failed: $e');
      if (mounted) {
        setState(() {
          _status = context.l10n.splashCriticalError;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF003D82),
                Color(0xFF001A33),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // الشعار المطور Mastery 2.0
                const BasserLogo(size: 140),
                const SizedBox(height: Spacing.xl),
                Text(
                  context.l10n.appTitle,
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    letterSpacing: 4,
                  ),
                ),
                Text(
                  AppConfig.appDescription,
                  style: TextStyle(
                    fontSize: FontSizes.bodyMedium,
                    color: Colors.white.withValues(alpha: 0.6),
                    fontFamily: 'Cairo',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                if (_error == null)
                  Column(
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            const Color(0xFFFFD700).withValues(alpha: 0.8),
                          ),
                          strokeWidth: 2,
                        ),
                      ),
                      const SizedBox(height: Spacing.md),
                      Text(
                        _status,
                        style: TextStyle(
                          fontSize: FontSizes.bodySmall,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  )
                else
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: SemanticColors.error,
                  ),
              ],
            ),
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
        body: Center(child: Text(context.l10n.placeholderComingSoon(title))),
      );
}
