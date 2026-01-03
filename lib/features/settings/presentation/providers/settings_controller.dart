import 'dart:async';

import 'package:basir_app/core/models/sync_status.dart';
import 'package:basir_app/core/providers.dart';
import 'package:basir_app/core/providers/supabase_auth_provider.dart';
import 'package:basir_app/features/settings/domain/entities/profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// حالة شاشة الإعدادات
class SettingsState {
  /// إنشاء حالة الإعدادات
  SettingsState({
    this.isLoading = false,
    this.error,
    this.notificationsEnabled = true,
  });

  /// حالة التحميل
  final bool isLoading;

  /// رسالة الخطأ إن وجدت
  final String? error;

  /// هل التنبيهات مفعلة
  final bool notificationsEnabled;

  /// إنشاء نسخة جديدة من الحالة مع تغيير بعض القيم
  SettingsState copyWith({
    bool? isLoading,
    String? error,
    bool? notificationsEnabled,
  }) =>
      SettingsState(
        isLoading: isLoading ?? this.isLoading,
        error: error,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      );
}

/// وحدة التحكم في الإعدادات (Settings Controller)
class SettingsController extends StateNotifier<SettingsState> {
  /// إنشاء وحدة تحكم الإعدادات
  SettingsController(this._ref) : super(SettingsState()) {
    unawaited(_init());
  }
  final Ref _ref;

  Future<void> _init() async {
    final secureStorage = _ref.read(secureStorageProvider);
    final enabled = await secureStorage.read(key: '<credential-fixture>');
    state = state.copyWith(notificationsEnabled: enabled != 'false');
  }

  /// تحديث حالة الإشعارات
  Future<void> toggleNotifications({required bool enabled}) async {
    final secureStorage = _ref.read(secureStorageProvider);
    await secureStorage.write(
      key: '<credential-fixture>',
      value: enabled.toString(),
    );
    state = state.copyWith(notificationsEnabled: enabled);
  }

  /// تحديث بيانات الشركة
  Future<bool> updateCompanySettings({
    required String name,
    required String taxNumber,
    required double taxRate,
    String? currencySymbol,
    String? countryCode,
    String? invoiceStyle,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final service = _ref.read(settingsServiceProvider);
      await service.setCompanySettings(
        companyName: name,
        taxNumber: taxNumber,
        taxRate: taxRate,
        currencySymbol: currencySymbol,
        countryCode: countryCode,
        invoiceStyle: invoiceStyle,
      );
      _ref.invalidate(companySettingsProvider);
      state = state.copyWith(isLoading: false);
      return true;
    } on Object catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// تحديث بيانات الحساب
  Future<bool> updateAccount({
    String? username,
    String? oldPassword,
    String? newPassword,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final authService = <credential-fixture>(authServiceProvider);

      if (username != null && username.isNotEmpty) {
        await authService.updateUsername(username);
        _ref.read(currentUsernameProvider.notifier).state = username;
      }

      if (oldPassword != null &&
          newPassword != null &&
          newPassword.isNotEmpty) {
        await authService.changePassword(oldPassword, newPassword);
      }

      state = state.copyWith(isLoading: false);
      return true;
    } on Object catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// تحديث الملف الشخصي
  Future<bool> updateProfile({
    String? displayName,
    String? avatarUrl,
    String? phoneNumber,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final repository = _ref.read(profileRepositoryProvider);
      final profile = await repository.getProfile() ??
          Profile(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            email: _ref.read(supabaseAuthProvider).currentUser?.email ?? '',
          );

      await repository.saveProfile(
        profile.copyWith(
          displayName: displayName ?? profile.displayName,
          avatarUrl: avatarUrl ?? profile.avatarUrl,
          phoneNumber: phoneNumber ?? profile.phoneNumber,
          syncStatus: SyncStatus.pendingPush,
        ),
      );

      state = state.copyWith(isLoading: false);
      return true;
    } on Object catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    await _ref.read(logoutProvider.future);
  }
}

/// مزود وحدة تحكم الإعدادات
final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsState>(
  SettingsController.new,
);
