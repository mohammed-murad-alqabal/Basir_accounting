import 'package:basser_app/features/auth/data/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// مزود خدمة التخزين الآمن
///
/// يوفر instance من FlutterSecureStorage للاستخدام في التطبيق
///
/// Example:
/// ```dart
/// final storage = ref.watch(secureStorageProvider,);
/// await storage.write(key: 'key', value: 'value',);
/// ```
final secureStorageProvider = Provider(
  (ref) => const FlutterSecureStorage(),
);

/// مزود خدمة المصادقة
///
/// يوفر instance من AuthService مع التخزين الآمن
///
/// Example:
/// ```dart
/// final authService = <credential-fixture>(authServiceProvider,);
/// await authService.login('username', 'password',);
/// ```
final authServiceProvider = <credential-fixture>((ref) {
  // استخدام select() لتحسين الأداء - مراقبة التخزين الآمن فقط
  final secureStorage = ref.watch(
    secureStorageProvider.select((storage) => storage),
  );
  return AuthService(
    secureStorage: secureStorage,
  );
});

/// مزود التحقق من وجود حساب
///
/// يتحقق من وجود حساب مسجل في التطبيق
///
/// Returns: Future<bool> - true إذا كان هناك حساب
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
  final authService = <credential-fixture>(
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
final isLoggedInProvider = StateProvider<bool>(
  (ref) => false,
);

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
final currentUsernameProvider = StateProvider<String?>(
  (ref) => null,
);

/// مزود عملية تسجيل الدخول
///
/// يدير عملية تسجيل الدخول ويحدث الحالة عند النجاح
///
/// Parameters:
/// - credentials: (username, password) - بيانات الاعتماد
///
/// Returns: Future<bool> - true إذا نجح تسجيل الدخول
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
  final authService = <credential-fixture>(
    authServiceProvider.select((service) => service),
  );
  final (username, password) = credentials;

  try {
    final result = await authService.login(
      username,
      password,
    );
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
/// Returns: Future<bool> - true إذا نجح إنشاء الحساب
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
  final authService = <credential-fixture>(
    authServiceProvider.select((service) => service),
  );
  final (username, password) = credentials;

  try {
    await authService.createAccount(
      username,
      password,
    );
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
/// Returns: Future<bool> - true إذا نجح تسجيل الخروج
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
  final authService = <credential-fixture>(
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
/// Returns: Future<bool> - true إذا نجح تغيير كلمة المرور
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
  final authService = <credential-fixture>(
    authServiceProvider.select((service) => service),
  );
  final (oldPassword, newPassword) = passwords;

  try {
    await authService.changePassword(
      oldPassword,
      newPassword,
    );
    return true;
  } on Exception {
    return false;
  }
});
