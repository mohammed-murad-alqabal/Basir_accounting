import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

/// خدمة المصادقة السحابية عبر Supabase
///
/// تدير عمليات المصادقة باستخدام Supabase Auth.
class SupabaseAuthService {
  /// المنشئ
  SupabaseAuthService({required this.supabaseClient});

  /// عميل Supabase
  final SupabaseClient supabaseClient;

  /// دفق التغييرات في حالة المصادقة
  Stream<AuthState> get onAuthStateChange =>
      supabaseClient.auth.onAuthStateChange;

  /// الحصول على المستخدم الحالي
  User? get currentUser => supabaseClient.auth.currentUser;

  /// هل المستخدم مسجل دخوله؟
  bool get isLoggedIn => currentUser != null;

  /// إنشاء حساب جديد
  Future<AuthResponse> createAccount({
    required String email,
    required String password,
    String? displayName,
  }) async =>
      supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': displayName},
      );

  /// تسجيل الدخول
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async =>
      supabaseClient.auth.signInWithPassword(email: email, password: password);

  /// تسجيل الخروج
  Future<void> logout() async {
    await supabaseClient.auth.signOut();
  }

  /// إعادة تعيين كلمة المرور
  Future<void> resetPassword(String email) async {
    await supabaseClient.auth.resetPasswordForEmail(email);
  }

  /// تحديث بيانات المستخدم
  Future<UserResponse> updateUser({
    String? password,
    Map<String, dynamic>? data,
  }) async =>
      supabaseClient.auth.updateUser(
        UserAttributes(password: password, data: data),
      );
}
