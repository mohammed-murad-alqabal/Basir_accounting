import 'dart:ui';

import 'package:basir_app/core/repositories/locale_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repository provider for locale persistence operations.
final localeRepositoryProvider = Provider<LocaleRepository>(
  (ref) => LocaleRepository(),
);

/// Locale state controller for application internationalization.
///
/// Manages the application locale with automatic persistence of user
/// preferences. Supports Arabic (ar) as default and English (en).
///
/// ## Features
/// - Persists locale preference across sessions
/// - Defaults to Arabic locale for RTL-first design
/// - Async loading with proper state management
///
/// ## Usage
/// ```dart
/// // Watch current locale
/// final locale = ref.watch(localeProvider).valueOrNull;
///
/// // Change locale
/// await ref.read(localeProvider.notifier).setLocale(Locale('en'));
/// ```
class LocaleNotifier extends AsyncNotifier<Locale> {
  @override
  Future<Locale> build() async {
    final repository = ref.read(localeRepositoryProvider);
    final savedLocale = await repository.getSavedLocale();

    if (savedLocale != null) {
      return savedLocale;
    }

    // Default: Arabic (RTL-first design)
    return const Locale('ar');
  }

  /// Changes the application locale and persists the preference.
  ///
  /// [locale] - The target [Locale] to apply.
  ///
  /// Throws an [Exception] if persistence fails.
  Future<void> setLocale(Locale locale) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(localeRepositoryProvider);
      final success = await repository.saveLocale(locale);

      if (!success) {
        throw Exception('Failed to save locale');
      }

      return locale;
    });
  }
}

/// Primary locale state provider.
///
/// Exposes the current [Locale] and [LocaleNotifier] for state management.
final localeProvider = AsyncNotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
