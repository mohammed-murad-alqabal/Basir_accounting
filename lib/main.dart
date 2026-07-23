// ignore_for_file: lines_longer_than_80_chars
import 'dart:async';

import 'package:basir_accounting_system/core/assets/app_logo.dart';
import 'package:basir_accounting_system/core/config/app_environment_config.dart';
import 'package:basir_accounting_system/core/config/supabase_config.dart';
import 'package:basir_accounting_system/core/constants.dart';
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/router.dart';
import 'package:basir_accounting_system/core/theme/app_theme.dart';
import 'package:basir_accounting_system/core/theme/font_manager.dart';
import 'package:basir_accounting_system/core/theme/services/color_customization_service.dart';
import 'package:basir_accounting_system/core/theme/services/font_customization_service.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/core/utils/provider_observer.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/error_widget.dart'
    as basir;
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  unawaited(
    runZonedGuarded(
      () async {
        // تهيئة Flutter bindings
        WidgetsFlutterBinding.ensureInitialized();

        // Performance Optimization: Parallel initialization of lightweight services
        await Future.wait([
          // تهيئة Environment Variables (must be first)
          AppEnvironmentConfig.initialize(),
          // تهيئة Supabase (lightweight)
          SupabaseConfig.initialize(),
          // تهيئة FontManager (lightweight)
          FontManager.initialize(),
          // تحسين الأداء: تعيين اتجاه النظام
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]),
          // Diamond Experience: Enable Edge-to-Edge
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge),
        ]);

        // إعداد شاشة الأخطاء العالمية

        ErrorWidget.builder =
            (details) => basir.GlobalErrorWidget(errorDetails: details);

        // تهيئة الخدمات الأساسية قبل البدء
        final container = ProviderContainer(
          observers: [BasirProviderObserver()],
        );

        // AuthService initialization is handled in SplashScreen for better TTI

        // بدء التطبيق
        runApp(
          UncontrolledProviderScope(
            container: container,
            child: const BasirApp(),
          ),
        );
      },
      (error, stack) {
        debugPrint('❌ [FATAL] Uncaught Async Error: $error');
        debugPrint('Stack trace: $stack');
      },
    ),
  );
}

/// تطبيق بصير الرئيسي
class BasirApp extends ConsumerWidget {
  /// إنشاء تطبيق بصير
  const BasirApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Performance Optimization: Use default theme with async updates
    final themeModeAsync = ref.watch(themeProvider);
    final customColorAsync = ref.watch(colorCustomizationProvider);
    final fontCustomizationAsync = ref.watch(fontCustomizationProvider);
    final localeAsync = ref.watch(localeProvider);

    // Default values for immediate rendering
    final themeMode = themeModeAsync.value ?? ThemeMode.system;
    final seedColor = customColorAsync.value;
    final fontState = fontCustomizationAsync.value;
    final fontFamily = fontState?.fontFamily;
    final textScale = fontState?.textScaleFactor ?? 1.0;
    final locale = localeAsync.value ?? const Locale('ar');

    return MaterialApp(
      title: AppConfig.appName,
      // Performance Optimization: Use computed themes directly
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
      // Performance Optimization: Parallel initialization
      final initStartTime = DateTime.now();

      // Phase 1: Critical services in parallel
      await Future.wait([
        // Initialize Isar in background (non-blocking)
        _initializeIsarBackground(),
        // Initialize AuthService (lightweight)
        ref.read(authServiceProvider).initialize(),
      ]);

      final duration = DateTime.now().difference(initStartTime).inMilliseconds;
      debugPrint('⚙️ [SYSTEM] Core Services Ready in ${duration}ms');

      // Phase 2: Authentication state check (optimized)
      final authService = <credential-fixture>(authServiceProvider);

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

      if (isLoggedIn) {
        // Hydrate User Profile Sync (Important for RBAC)
        final user = await authService.getCurrentUser();
        ref.read(currentUserProfileProvider.notifier).state = user;
      }

      if (!mounted) return;

      debugPrint(
        '🔑 [AUTH] Account: $hasAccount, '
        'LoggedIn: $isLoggedIn, Guest: $isGuest',
      );

      // اتخاذ قرار التوجيه الفوري (Refined Logic)
      if (isGuest || (isLoggedIn && keepLoggedIn)) {
        // ضيف أو مسجل دخول ومفعل "تذكرني" -> لوحة التحكم
        await Navigator.of(context).pushReplacementNamed('/dashboard');
      } else if (!hasAccount) {
        // لا يوجد حساب ولا وضع ضيف -> شاشة الإعداد الأولية
        await Navigator.of(context).pushReplacementNamed('/setup');
      } else {
        // يوجد حساب ولكن غير مسجل دخول أو انتهت الجلسة (KeepLoggedIn false)
        // -> شاشة تسجيل الدخول
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

  /// Performance Optimization: Background Isar initialization
  Future<void> _initializeIsarBackground() async {
    try {
      // Start Isar initialization but don't block on completion
      final isarFuture = ref.read(isarProvider.future);

      // Allow UI to render while Isar initializes
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Now wait for Isar to complete
      await isarFuture;

      debugPrint('📊 [ISAR] Database initialized successfully');
    } on Exception catch (e) {
      debugPrint('❌ [ISAR] Background initialization failed: $e');
      // Don't throw - allow app to continue with limited functionality
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(color: Colors.white),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // الشعار المطور Basir 2.0
                const BasirLogo(size: 140),
                const SizedBox(height: Spacing.xl),
                Text(
                  context.l10n.appTitle,
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003D82), // Basir Blue
                    fontFamily: 'Cairo',
                    letterSpacing: 4,
                  ),
                ),
                Text(
                  AppConfig.appDescription,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFF003D82).withValues(alpha: 0.6),
                    fontFamily: 'Cairo',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                if (_error == null)
                  Column(
                    children: [
                      const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF003D82),
                          ),
                          strokeWidth: 2,
                        ),
                      ),
                      const SizedBox(height: Spacing.md),
                      Text(
                        _status,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: const Color(0xFF003D82).withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: Spacing.md),
                      Text(
                        _error ?? context.l10n.splashCriticalError,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: Spacing.xl),
                      AppEnhancedButton(
                        label: context.l10n.retryLabel,
                        onPressed: () {
                          setState(() {
                            _error = null;
                            _status = context.l10n.splashInitializing;
                          });
                          unawaited(_initializeApp());
                        },
                        type: AppEnhancedButtonType.outlined,
                        foregroundColor: Colors.white,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
}
