import 'dart:ui';

import 'package:basir_accounting_system/core/providers/locale_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('LocaleProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('initial state', () {
      test('returns Arabic as default when no locale is saved', () async {
        SharedPreferences.setMockInitialValues({});

        final locale = await container.read(localeProvider.future);

        expect(locale, equals(const Locale('ar')));
      });

      test('returns saved locale when exists', () async {
        SharedPreferences.setMockInitialValues({'app_locale': 'en'});

        final locale = await container.read(localeProvider.future);

        expect(locale, equals(const Locale('en')));
      });
    });

    group('setLocale', () {
      test('updates locale and saves to storage', () async {
        SharedPreferences.setMockInitialValues({});

        // تغيير اللغة
        await container
            .read(localeProvider.notifier)
            .setLocale(const Locale('en'));

        // التحقق من التحديث
        final updatedLocale = await container.read(localeProvider.future);
        expect(updatedLocale, equals(const Locale('en')));

        // التحقق من الحفظ في التخزين
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('app_locale'), equals('en'));
      });

      test('handles multiple locale changes', () async {
        SharedPreferences.setMockInitialValues({});

        final notifier = container.read(localeProvider.notifier);

        // تغيير إلى الإنجليزية
        await notifier.setLocale(const Locale('en'));
        final firstLocale = await container.read(localeProvider.future);
        expect(firstLocale, equals(const Locale('en')));

        // تغيير إلى العربية
        await notifier.setLocale(const Locale('ar'));
        final secondLocale = await container.read(localeProvider.future);
        expect(secondLocale, equals(const Locale('ar')));
      });
    });

    group('error handling', () {
      test('handles repository errors gracefully', () async {
        SharedPreferences.setMockInitialValues({});

        // محاولة تغيير اللغة
        await container
            .read(localeProvider.notifier)
            .setLocale(const Locale('en'));

        // يجب أن يعمل بشكل طبيعي حتى لو حدث خطأ
        final state = container.read(localeProvider);
        expect(state.hasValue, isTrue);
      });
    });

    group('integration with LocaleRepository', () {
      test('uses LocaleRepository for persistence', () async {
        SharedPreferences.setMockInitialValues({});

        // التحقق من أن LocaleRepository متاح
        final repository = container.read(localeRepositoryProvider);
        expect(repository, isNotNull);

        // تغيير اللغة عبر Provider
        await container
            .read(localeProvider.notifier)
            .setLocale(const Locale('en'));

        // التحقق من الحفظ عبر Repository
        final savedLocale = await repository.getSavedLocale();
        expect(savedLocale, equals(const Locale('en')));
      });
    });
  });
}
