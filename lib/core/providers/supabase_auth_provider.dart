import 'package:basir_app/core/config/supabase_config.dart';
import 'package:basir_app/features/auth/data/services/supabase_auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_auth_provider.g.dart';

/// مزود خدمة المصادقة
@Riverpod(keepAlive: true)
SupabaseAuthService supabaseAuth(SupabaseAuthRef ref) =>
    SupabaseAuthService(supabaseClient: SupabaseConfig.client);

/// مزود حالة المصادقة
@Riverpod(keepAlive: true)
Stream<AuthState> authState(AuthStateRef ref) => ref.watch(supabaseAuthProvider).onAuthStateChange;

/// مزود المستخدم الحالي
@Riverpod(keepAlive: true)
User? currentUser(CurrentUserRef ref) {
  final authState = ref.watch(authStateProvider).value;
  return authState?.session?.user ?? ref.watch(supabaseAuthProvider).currentUser;
}
