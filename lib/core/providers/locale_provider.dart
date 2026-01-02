import 'dart:ui';

import 'package:basir_app/core/repositories/locale_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// مزود LocaleRepository
final localeRepositoryProvider = Provider<LocaleRepository>(
  (ref) => LocaleRepository(),
);

/// مزود اللغة (Locale Provider)
///
/// يدير لغة التطبيق ويحفظ تفضيلات المستخدم.
/// - يدعم العربية (ar) كافتراضي
/// - يدعم الإنجليزية (en)
class LocaleNotifier extends AsyncNotifier<Locale> {
  @override
  Future<Locale> build() async {
    final repository = ref.read(localeRepositoryProvider);
    final savedLocale = await repository.getSavedLocale();

    if (savedLocale != null) {
      return savedLocale;
    }

    // الافتراضي: العربية
    return const Locale('ar');
  }

  /// تغيير لغة التطبيق
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

/// المزود العام للغة
final localeProvider = AsyncNotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
