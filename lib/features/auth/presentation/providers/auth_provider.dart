import 'package:basir_app/core/providers/secure_storage_provider.dart';
import 'package:basir_app/core/providers/supabase_auth_provider.dart';
import 'package:basir_app/features/auth/application/auth_service.dart';
import 'package:basir_app/features/auth/domain/models/auth_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// مزود خدمة المصادقة
///
/// يوفر instance من AuthService مع التخزين الآمن
///
/// Example:
/// ```dart
/// final authService = ref.watch(authServiceProvider,);
/// await authService.login('username', 'password',);
/// ```
final authServiceProvider = Provider((ref) {
  // استخدام select() لتحسين الأداء - مراقبة التخزين الآمن فقط
  final secureStorage = ref.watch(
    secureStorageProvider.select((storage) => storage),
  );
  return AuthService(secureStorage: secureStorage);
});

/// مزود التحقق من وجود حساب
///
/// يتحقق من وجود حساب مسجل في التطبيق
///
/// Returns: `Future<bool>` - true إذا كان هناك حساب
///
/// Example:
/// ```dart
/// final hasAccount = await ref.watch(hasAccountProvider.future,);
/// if (hasAccount) {
///   // انتقل إلى شاشة تسجيل الدخول
/// } else {
///   // انتقل إلى شاشة الإعداد
/// }
/// ```
final hasAccountProvider = FutureProvider<bool>((ref) async {
  // استخدام select() لتحسين الأداء - مراقبة الخدمة فقط
  final authService = ref.watch(
    authServiceProvider.select((service) => service),
  );
  return authService.hasAccount();
});

/// مزود حالة تسجيل الدخول
///
/// يحفظ حالة تسجيل الدخول الحالية للمستخدم
///
/// Example:
/// ```dart
/// final isLoggedIn = ref.watch(isLoggedInProvider,);
/// // تحديث الحالة
/// ref.read(isLoggedInProvider.notifier).state = true;
/// ```
final isLoggedInProvider = StateProvider<bool>((ref) => false);

/// مزود اسم المستخدم الحالي
///
/// يحفظ اسم المستخدم المسجل حالياً
///
/// Example:
/// ```dart
/// final username = ref.watch(currentUsernameProvider,);
/// if (username != null) {
///   debugPrint('مرحباً $username',);
/// }
/// ```
final currentUsernameProvider = StateProvider<String?>((ref) => null);

/// مزود عملية تسجيل الدخول
///
/// يدير عملية تسجيل الدخول ويحدث الحالة عند النجاح
///
/// Parameters:
/// - credentials: (username, password) - بيانات الاعتماد
///
/// Returns: `Future<bool>` - true إذا نجح تسجيل الدخول
///
/// Side Effects:
/// - يحدث isLoggedInProvider إلى true عند النجاح
/// - يحدث currentUsernameProvider باسم المستخدم
///
/// Example:
/// ```dart
/// final result = await ref.watch(
///   loginProvider(('admin', 'password123')).future,
///,);
/// if (result) {
///   // تسجيل الدخول نجح
/// }
/// ```
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
    }
    return result;
  } on Exception {
    return false;
  }
});

/// مزود عملية الإعداد الأولي
///
/// يدير عملية إنشاء حساب جديد ويحدث الحالة عند النجاح
///
/// Parameters:
/// - credentials: (username, password) - بيانات الحساب الجديد
///
/// Returns: `Future<bool>` - true إذا نجح إنشاء الحساب
///
/// Side Effects:
/// - يحدث isLoggedInProvider إلى true عند النجاح
/// - يحدث currentUsernameProvider باسم المستخدم
///
/// Example:
/// ```dart
/// final result = await ref.watch(
///   setupProvider(('admin', 'password123')).future,
///,);
/// if (result) {
///   // تم إنشاء الحساب بنجاح
/// }
/// ```
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
    return true;
  } on Exception {
    return false;
  }
});

/// مزود عملية تسجيل الخروج
///
/// يدير عملية تسجيل الخروج ويحدث الحالة
///
/// Returns: `Future<bool>` - true إذا نجح تسجيل الخروج
///
/// Side Effects:
/// - يحدث isLoggedInProvider إلى false
/// - يحدث currentUsernameProvider إلى null
///
/// Example:
/// ```dart
/// final result = await ref.watch(logoutProvider.future,);
/// if (result) {
///   // تم تسجيل الخروج بنجاح
///   Navigator.pushReplacementNamed(context, '/login',);
/// }
/// ```
final logoutProvider = FutureProvider<bool>((ref) async {
  // استخدام select() لتحسين الأداء - مراقبة الخدمة فقط
  final authService = ref.watch(
    authServiceProvider.select((service) => service),
  );

  try {
    await authService.logout();
    ref.read(isLoggedInProvider.notifier).state = false;
    ref.read(currentUsernameProvider.notifier).state = null;
    return true;
  } on Exception {
    return false;
  }
});

/// مزود عملية تغيير كلمة المرور
///
/// يدير عملية تغيير كلمة المرور للمستخدم الحالي
///
/// Parameters:
/// - passwords: (oldPassword, newPassword) - كلمة المرور القديمة والجديدة
///
/// Returns: `Future<bool>` - true إذا نجح تغيير كلمة المرور
///
/// Example:
/// ```dart
/// final result = await ref.watch(
///   changePasswordProvider(('oldPass', 'newPass')).future,
///,);
/// if (result) {
///   // تم تغيير كلمة المرور بنجاح
/// }
/// ```
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
///
/// يتحقق مما إذا كان المستخدم الحالي ضيفاً
/// يتفاعل مع تغييرات حالة المصادقة (تسجيل دخول/خروج/ترقية)
///
/// Example:
/// ```dart
/// final isGuest = ref.watch(isGuestProvider);
/// if (isGuest.value == true) {
///   // إظهار زر الترقية
/// }
/// ```
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
/// يوفر المستخدم الحالي سواء من Supabase أو كضيف محلي
/// هذا المزود هو المصدر الوحيد للحقيقة لبيانات المستخدم في طبقة التطبيق
final basirUserProvider = Provider<BasirUser?>((ref) {
  // 1. التحقق من Supabase (المصدر الأساسي)
  final supabaseUser = ref.watch(currentUserProvider);
  if (supabaseUser != null) {
    return BasirUser.fromSupabase(supabaseUser);
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

  return null;
});
