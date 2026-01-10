import 'package:basir_app/core/config/supabase_config.dart';
import 'package:basir_app/features/auth/data/services/supabase_auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_auth_provider.g.dart';

/// Supabase authentication service provider.
///
/// Provides a configured [SupabaseAuthService] instance for authentication
/// operations. This provider is marked as `keepAlive` to persist across
/// the application lifecycle.
@Riverpod(keepAlive: true)
SupabaseAuthService supabaseAuth(SupabaseAuthRef ref) =>
    SupabaseAuthService(supabaseClient: SupabaseConfig.client);

/// Authentication state stream provider.
///
/// Exposes a reactive stream of [AuthState] changes from Supabase.
/// Use this to react to sign-in, sign-out, and token refresh events.
///
/// ## Usage
/// ```dart
/// ref.listen(authStateProvider, (previous, next) {
///   if (next.value?.session == null) {
///     // User signed out
///   }
/// });
/// ```
@Riverpod(keepAlive: true)
Stream<AuthState> authState(AuthStateRef ref) =>
    ref.watch(supabaseAuthProvider).onAuthStateChange;

/// Current authenticated user provider.
///
/// Returns the currently authenticated [User] or `null` if not signed in.
/// Reacts to auth state changes automatically.
@Riverpod(keepAlive: true)
User? currentUser(CurrentUserRef ref) {
  final authState = ref.watch(authStateProvider).value;
  return authState?.session?.user ??
      ref.watch(supabaseAuthProvider).currentUser;
}
