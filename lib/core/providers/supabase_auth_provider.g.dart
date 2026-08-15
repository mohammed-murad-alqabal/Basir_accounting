// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$supabaseAuthHash() => r'79c9d6afa0c0409387592b5bb2cdfd06b4ac9ce7';

/// Supabase authentication service provider.
///
/// Provides a configured [SupabaseAuthService] instance for authentication
/// operations. This provider is marked as `keepAlive` to persist across
/// the application lifecycle.
///
/// Copied from [supabaseAuth].
@ProviderFor(supabaseAuth)
final supabaseAuthProvider = Provider<SupabaseAuthService>.internal(
  supabaseAuth,
  name: r'supabaseAuthProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$supabaseAuthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SupabaseAuthRef = ProviderRef<SupabaseAuthService>;
String _$authStateHash() => r'c14073d271d15a2c32dd13f08daf514c2a5970f1';

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
///
/// Copied from [authState].
@ProviderFor(authState)
final authStateProvider = StreamProvider<AuthState>.internal(
  authState,
  name: r'authStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthStateRef = StreamProviderRef<AuthState>;
String _$currentUserHash() => r'128d56712a53cad1bebf603be1448afe83cf4a72';

/// Current authenticated user provider.
///
/// Returns the currently authenticated [User] or `null` if not signed in.
/// Reacts to auth state changes automatically.
///
/// Copied from [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = Provider<User?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentUserRef = ProviderRef<User?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
