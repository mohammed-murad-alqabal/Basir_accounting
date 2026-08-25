import 'package:basir_accounting_system/core/providers/secure_storage_provider.dart';
import 'package:basir_accounting_system/core/providers/supabase_auth_provider.dart';
import 'package:basir_accounting_system/features/auth/application/auth_service.dart';
import 'package:basir_accounting_system/features/auth/domain/models/auth_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ***
/// Cognitive Foundation: Auth Providers
///
/// Reactive source of truth for all institutional identity and security states.
/// These providers bridge the gap between the application services and the
/// presentation layer, ensuring high-fidelity updates across the entire app.
/// ***

/// [authServiceProvider]
///
/// Provides the singleton instance of the [AuthService].
/// Optimized with precise selection of dependencies to minimize rebuilds.
final authServiceProvider = Provider((ref) {
  final secureStorage = ref.watch(
    secureStorageProvider.select((storage) => storage),
  );
  final service = AuthService(secureStorage: secureStorage);
  ref.onDispose(service.dispose);
  return service;
});

/// مزود التحقق من وجود حساب
final hasAccountProvider = FutureProvider<bool>((ref) async {
  // استخدام select() لتحسين الأداء - مراقبة الخدمة فقط
  final authService = ref.watch(
    authServiceProvider.select((service) => service),
  );
  return authService.hasAccount();
});

/// مزود حالة تسجيل الدخول
final isLoggedInProvider = StateProvider<bool>((ref) => false);

/// مزود اسم المستخدم الحالي
final currentUsernameProvider = StateProvider<String?>((ref) => null);

/// مزود الملف الشخصي للمستخدم الحالي (للوصول المتزامن)
final currentUserProfileProvider = StateProvider<BasirUser?>((ref) => null);

/// مزود عملية تسجيل الدخول
///
/// يدير عملية تسجيل الدخول ويحدث الحالة عند النجاح
final loginProvider = FutureProvider.family<bool, (String, String)>((
  ref,
  credentials,
) async {
  // استخدام select() لتحسين الأداء
  final authService = ref.watch(
    authServiceProvider.select((service) => service),
  );
  final (username, password) = credentials;

  try {
    final result = await authService.login(username, password);
    if (result) {
      ref.read(isLoggedInProvider.notifier).state = true;
      ref.read(currentUsernameProvider.notifier).state = username;

      // تحديث الملف الشخصي
      final user = await authService.getCurrentUser();
      ref.read(currentUserProfileProvider.notifier).state = user;
    }
    return result;
  } on Exception {
    return false;
  }
});

/// مزود عملية الإعداد الأولي
final setupProvider = FutureProvider.family<bool, (String, String)>((
  ref,
  credentials,
) async {
  // استخدام select() لتحسين الأداء - مراقبة الخدمة فقط
  final authService = ref.watch(
    authServiceProvider.select((service) => service),
  );
  final (username, password) = credentials;

  try {
    await authService.createAccount(username, password);
    ref.read(isLoggedInProvider.notifier).state = true;
    ref.read(currentUsernameProvider.notifier).state = username;

    // تحديث الملف الشخصي
    final user = await authService.getCurrentUser();
    ref.read(currentUserProfileProvider.notifier).state = user;

    return true;
  } on Exception {
    return false;
  }
});

/// مزود عملية تسجيل الخروج
final logoutProvider = FutureProvider<bool>((ref) async {
  // استخدام select() لتحسين الأداء - مراقبة الخدمة فقط
  final authService = ref.watch(
    authServiceProvider.select((service) => service),
  );

  try {
    await authService.logout();
    ref.read(isLoggedInProvider.notifier).state = false;
    ref.read(currentUsernameProvider.notifier).state = null;
    ref.read(currentUserProfileProvider.notifier).state = null;
    return true;
  } on Exception {
    return false;
  }
});

/// مزود عملية تغيير كلمة المرور
final changePasswordProvider = FutureProvider.family<bool, (String, String)>((
  ref,
  passwords,
) async {
  // استخدام select() لتحسين الأداء - مراقبة الخدمة فقط
  final authService = ref.watch(
    authServiceProvider.select((service) => service),
  );
  final (oldPassword, newPassword) = passwords;

  try {
    await authService.changePassword(oldPassword, newPassword);
    return true;
  } on Exception {
    return false;
  }
});

/// مزود التحقق من وضع الضيف
final isGuestProvider = StreamProvider<bool>((ref) async* {
  final authService = ref.watch(authServiceProvider);

  // التحقق الأولي
  yield await authService.isGuest();

  // الاستماع للتغييرات
  await for (final _ in authService.onAuthStateChange) {
    yield await authService.isGuest();
  }
});

/// موحد المستخدم (Unified Basir User)
///
/// يوفر المستخدم الحالي من الخدمة المحلية (ذات الأولوية) أو السحابية
/// هذا المزود هو المصدر الوحيد للحقيقة لبيانات المستخدم في طبقة التطبيق
final basirUserProvider = Provider<BasirUser?>((ref) {
  // 1. المستخدم المحلي المسجل (المصدر الأساسي)
  final localUser = ref.watch(currentUserProfileProvider);
  if (localUser != null) {
    return localUser;
  }

  // 2. التحقق من وضع الضيف (المصدر الثانوي)
  final isGuest = ref.watch(isGuestProvider).maybeWhen(
        data: (v) => v,
        orElse: () => false,
      );

  if (isGuest) {
    return const BasirUser(
      id: 'guest',
      email: 'guest@basir.local',
      displayName: 'مستخدم ضيف',
      isGuest: true,
    );
  }

  // 3. التحقق من Supabase (احتياطي قديم)
  final supabaseUser = ref.watch(currentUserProvider);
  if (supabaseUser != null) {
    return BasirUser.fromSupabase(supabaseUser);
  }

  return null;
});
