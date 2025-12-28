import 'package:basser_app/core/theme/services/theme_storage_utils.dart';
import 'package:basser_app/core/theme/tokens/app_icons.dart';
import 'package:basser_app/features/auth/presentation/providers/current_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// حالة تخصيص الأيقونات
class IconCustomizationState {
  /// إنشاء حالة تخصيص الأيقونات
  const IconCustomizationState({
    required this.iconPack,
  });

  /// حزمة الأيقونات المختارة
  final IconPack iconPack;

  /// الحصول على بيانات الأيقونات بناءً على الحزمة
  AppIconsData get icons {
    switch (iconPack) {
      case IconPack.material:
        return const MaterialAppIcons();
      case IconPack.cupertino:
        return const CupertinoAppIcons();
    }
  }
}

/// خدمة تخصيص الأيقونات
///
/// تدير حالة الأيقونات المخصصة من قبل المستخدم وتحفظها في التخزين المحلي.
/// تدعم تعدد المستخدمين عبر [currentUserProvider].
class IconCustomizationService extends AsyncNotifier<IconCustomizationState> {
  static const String _iconPackKey = '<credential-fixture>';

  @override
  Future<IconCustomizationState> build() async {
    // إعادة البناء عند تغيير المستخدم
    ref.watch(currentUserProvider);
    return _loadSettings();
  }

  /// الحصول على المفتاح المناسب للمستخدم الحالي
  String get _storageKey {
    final username = ref.read(currentUserProvider).value;
    return ThemeStorageUtils.getUserSpecificKey(_iconPackKey, username);
  }

  Future<IconCustomizationState> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = <credential-fixture>;
      final packString = prefs.getString(key) ?? 'material';

      final pack = IconPack.values.firstWhere(
        (e) => e.name == packString,
        orElse: () => IconPack.material,
      );

      return IconCustomizationState(iconPack: pack);
    } on Object catch (e) {
      debugPrint('Error loading icon settings: $e');
      return const IconCustomizationState(iconPack: IconPack.material);
    }
  }

  /// تغيير حزمة الأيقونات
  Future<void> setIconPack(IconPack pack) async {
    state = AsyncValue.data(IconCustomizationState(iconPack: pack));
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = <credential-fixture>;
      await prefs.setString(key, pack.name);
    } on Object catch (e) {
      debugPrint('Error saving icon pack: $e');
    }
  }
}

/// موفر خدمة تخصيص الأيقونات
final iconCustomizationProvider =
    AsyncNotifierProvider<IconCustomizationService, IconCustomizationState>(
  IconCustomizationService.new,
);

/// مزود الأيقونات الحالي لسهولة الوصول
final appIconsProvider = Provider<AppIconsData>((ref) {
  final state = ref.watch(iconCustomizationProvider).valueOrNull;
  return state?.icons ?? const MaterialAppIcons();
});
