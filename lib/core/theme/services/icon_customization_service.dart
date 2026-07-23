import 'package:basir_accounting_system/core/theme/services/theme_storage_utils.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// حالة تخصيص الأيقونات
class IconCustomizationState {
  /// إنشاء حالة تخصيص الأيقونات
  const IconCustomizationState({required this.iconPack});

  /// حزمة الأيقونات المختارة
  final IconPack iconPack;

  /// الحصول على بيانات الأيقونات بناءً على الحزمة
  AppIconsBase get icons {
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
/// تدعم تعدد المستخدمين عبر [basirUserProvider].
class IconCustomizationService extends AsyncNotifier<IconCustomizationState> {
  static const String _iconPackKey = 'custom_icon_pack';

  @override
  Future<IconCustomizationState> build() async {
    // إعادة البناء عند تغيير المستخدم
    final user = ref.watch(basirUserProvider);
    return _loadSettings(user?.id);
  }

  /// الحصول على المفتاح المناسب للمستخدم
  String _getStorageKey(String? username) =>
      ThemeStorageUtils.getUserSpecificKey(_iconPackKey, username);

  Future<IconCustomizationState> _loadSettings(String? username) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getStorageKey(username);
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
      final user = ref.read(basirUserProvider);
      final key = _getStorageKey(user?.id);
      await prefs.setString(key, pack.name);
    } on Object catch (e) {
      debugPrint('Error saving icon pack: $e');
    }
  }

  /// استعادة الافتراضي
  Future<void> resetToDefault() async {
    state = const AsyncValue.data(
      IconCustomizationState(iconPack: IconPack.material),
    );
    try {
      final prefs = await SharedPreferences.getInstance();
      final user = ref.read(basirUserProvider);
      await prefs.remove(_getStorageKey(user?.id));
    } on Object catch (e) {
      debugPrint('Error resetting icon pack: $e');
    }
  }
}

/// موفر خدمة تخصيص الأيقونات
final iconCustomizationProvider =
    AsyncNotifierProvider<IconCustomizationService, IconCustomizationState>(
  IconCustomizationService.new,
);

/// مزود الأيقونات الحالي لسهولة الوصول
final appIconsProvider = Provider<AppIconsBase>((ref) {
  final state = ref.watch(iconCustomizationProvider).value;
  return state?.icons ?? const MaterialAppIcons();
});
