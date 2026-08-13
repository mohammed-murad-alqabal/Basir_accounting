/// اختبارات سلوك خدمة تفضيلات المظهر.
library;

import 'package:basir_accounting_system/core/theme/services/appearance_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppearanceState', () {
    test('copyWith يحتفظ بالقيم غير المعدلة', () {
      const initial = AppearanceState(highContrast: true, reduceMotion: false);

      final updated = initial.copyWith(reduceMotion: true);

      expect(updated.highContrast, isTrue);
      expect(updated.reduceMotion, isTrue);
    });
  });

  group('AppearanceService', () {
    late ProviderContainer container;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer();
    });

    tearDown(() => container.dispose());

    test('يبدأ بتفضيلات إمكانية وصول افتراضية عند عدم وجود قيم محفوظة',
        () async {
      final state = await container.read(appearanceServiceProvider.future);

      expect(state.highContrast, isFalse);
      expect(state.reduceMotion, isFalse);
    });

    test('يستعيد تفضيلات إمكانية الوصول المحفوظة عند بدء التطبيق', () async {
      container.dispose();
      SharedPreferences.setMockInitialValues({
        'appearance_high_contrast': true,
        'appearance_reduce_motion': true,
      });
      container = ProviderContainer();

      final state = await container.read(appearanceServiceProvider.future);

      expect(state.highContrast, isTrue);
      expect(state.reduceMotion, isTrue);
    });

    test('يحفظ تغيير التباين العالي ويحتفظ بتفضيل الحركة الحالي', () async {
      await container.read(appearanceServiceProvider.future);
      final service = container.read(appearanceServiceProvider.notifier);

      await service.setReduceMotion(enabled: true);
      await service.setHighContrast(enabled: true);

      final state = container.read(appearanceServiceProvider).requireValue;
      final preferences = await SharedPreferences.getInstance();
      expect(state.highContrast, isTrue);
      expect(state.reduceMotion, isTrue);
      expect(preferences.getBool('appearance_high_contrast'), isTrue);
      expect(preferences.getBool('appearance_reduce_motion'), isTrue);
    });

    test('يحفظ تغيير تقليل الحركة دون تبديل التباين العالي', () async {
      await container.read(appearanceServiceProvider.future);
      final service = container.read(appearanceServiceProvider.notifier);

      await service.setHighContrast(enabled: true);
      await service.setReduceMotion(enabled: false);

      final state = container.read(appearanceServiceProvider).requireValue;
      final preferences = await SharedPreferences.getInstance();
      expect(state.highContrast, isTrue);
      expect(state.reduceMotion, isFalse);
      expect(preferences.getBool('appearance_reduce_motion'), isFalse);
    });

    test('يعيد إعدادات المظهر إلى الافتراضي ويحذف التفضيلات المحفوظة',
        () async {
      await container.read(appearanceServiceProvider.future);
      final service = container.read(appearanceServiceProvider.notifier);
      await service.setHighContrast(enabled: true);
      await service.setReduceMotion(enabled: true);

      await service.resetToDefault();

      final state = container.read(appearanceServiceProvider).requireValue;
      final preferences = await SharedPreferences.getInstance();
      expect(state.highContrast, isFalse);
      expect(state.reduceMotion, isFalse);
      expect(preferences.containsKey('appearance_high_contrast'), isFalse);
      expect(preferences.containsKey('appearance_reduce_motion'), isFalse);
    });
  });
}
