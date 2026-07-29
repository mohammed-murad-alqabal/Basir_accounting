import 'package:basir_accounting_system/core/config/supabase_config.dart';
import 'package:basir_accounting_system/core/providers/secure_storage_provider.dart';
import 'package:basir_accounting_system/features/mfa/domain/services/phone_auth_service_impl.dart';
import 'package:basir_accounting_system/features/mfa/domain/services/local_auth_service.dart';
import 'package:basir_accounting_system/features/mfa/domain/services/phone_auth_service_interface.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// LocalAuthService provider
final localAuthServiceProvider = Provider<LocalAuthService>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return LocalAuthService(secureStorage: secureStorage);
});

/// PhoneAuthService interface provider
final phoneAuthServiceInterfaceProvider =
    Provider<PhoneAuthServiceInterface>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final supabaseClient = SupabaseConfig.client;
  return PhoneAuthService(
      supabaseClient: supabaseClient, secureStorage: secureStorage);
});

/// Biometric availability provider
final biometricAvailableProvider = FutureProvider<bool>((ref) async {
  final localAuth = ref.watch(localAuthServiceProvider);
  return localAuth.canCheckBiometric();
});

/// Biometric enabled state
final biometricEnabledProvider =
    StateNotifierProvider<BiometricEnabledNotifier, bool>(
  BiometricEnabledNotifier.new,
);

class BiometricEnabledNotifier extends StateNotifier<bool> {
  BiometricEnabledNotifier(this.ref) : super(false);

  final Ref ref;

  Future<void> loadState() async {
    final localAuth = ref.read(localAuthServiceProvider);
    final enabled = await localAuth.isBiometricEnabled();
    state = enabled;
  }

  Future<void> toggle({required bool enabled}) async {
    final localAuth = ref.read(localAuthServiceProvider);
    await localAuth.setBiometricEnabled(enabled: enabled);
    state = enabled;
  }
}

final appLockEnabledProvider =
    StateNotifierProvider<AppLockEnabledNotifier, bool>(
        AppLockEnabledNotifier.new);

class AppLockEnabledNotifier extends StateNotifier<bool> {
  AppLockEnabledNotifier(this.ref) : super(false);

  final Ref ref;

  Future<void> loadState() async {
    final localAuth = ref.read(localAuthServiceProvider);
    final enabled = await localAuth.isAppLockEnabled();
    state = enabled;
  }

  Future<void> toggle({required bool enabled}) async {
    final localAuth = ref.read(localAuthServiceProvider);
    await localAuth.setAppLockEnabled(enabled: enabled);
    state = enabled;
  }
}

final lockOnResumeProvider =
    StateNotifierProvider<LockOnResumeNotifier, bool>(LockOnResumeNotifier.new);

class LockOnResumeNotifier extends StateNotifier<bool> {
  LockOnResumeNotifier(this.ref) : super(false);

  final Ref ref;

  Future<void> loadState() async {
    final localAuth = ref.read(localAuthServiceProvider);
    final enabled = await localAuth.isLockOnResume();
    state = enabled;
  }

  Future<void> toggle({required bool enabled}) async {
    final localAuth = ref.read(localAuthServiceProvider);
    await localAuth.setLockOnResume(enabled: enabled);
    state = enabled;
  }
}

final cloudMfaRequiredProvider =
    StateNotifierProvider<CloudMfaRequiredNotifier, bool>(
        CloudMfaRequiredNotifier.new);

class CloudMfaRequiredNotifier extends StateNotifier<bool> {
  CloudMfaRequiredNotifier(this.ref) : super(false);

  final Ref ref;

  Future<void> loadState() async {
    final localAuth = ref.read(localAuthServiceProvider);
    final enabled = await localAuth.isCloudMfaRequired();
    state = enabled;
  }

  Future<void> toggle({required bool enabled}) async {
    final localAuth = ref.read(localAuthServiceProvider);
    await localAuth.setCloudMfaRequired(enabled: enabled);
    state = enabled;
  }
}

/// PIN set state
final pinSetProvider = FutureProvider<bool>((ref) async {
  final localAuth = ref.read(localAuthServiceProvider);
  return localAuth.hasPinCode();
});

/// Pattern set state
final patternSetProvider = FutureProvider<bool>((ref) async {
  final localAuth = ref.read(localAuthServiceProvider);
  return localAuth.hasPatternLock();
});

final lastMfaUnlockAtProvider = FutureProvider<DateTime?>((ref) async {
  final localAuth = ref.read(localAuthServiceProvider);
  return localAuth.getLastMfaUnlockAt();
});

/// Phone verified state
final phoneVerifiedProvider = FutureProvider<bool>((ref) async {
  final phoneAuth = ref.read(phoneAuthServiceInterfaceProvider);
  return phoneAuth.isPhoneVerified();
});

/// Stored phone number
final storedPhoneNumberProvider = FutureProvider<String?>((ref) async {
  final phoneAuth = ref.read(phoneAuthServiceInterfaceProvider);
  return phoneAuth.getPhoneNumber();
});

/// PIN setup provider
final pinSetupProvider = FutureProvider.family<bool, String>((ref, pin) {
  final localAuth = ref.read(localAuthServiceProvider);
  return localAuth.setPinCode(pin).then((_) => true);
});

/// Pattern setup provider (النمط الآن عبارة عن مصفوفة من الأرقام 0-8)
final patternSetupProvider =
    FutureProvider.family<bool, List<int>>((ref, pattern) {
  final localAuth = ref.read(localAuthServiceProvider);
  return localAuth.setPatternLock(pattern).then((_) => true);
});

/// Biometric login provider
final biometricLoginProvider = FutureProvider<bool>((ref) {
  final localAuth = ref.read(localAuthServiceProvider);
  return localAuth.loginWithBiometric();
});

/// PIN login provider
final pinLoginProvider = FutureProvider.family<bool, String>((ref, pin) {
  final localAuth = ref.read(localAuthServiceProvider);
  return localAuth.loginWithPin(pin);
});

/// Pattern login provider (النمط الآن عبارة عن مصفوفة من الأرقام 0-8)
final patternLoginProvider =
    FutureProvider.family<bool, List<int>>((ref, pattern) {
  final localAuth = ref.read(localAuthServiceProvider);
  return localAuth.loginWithPattern(pattern);
});

/// Phone OTP send provider
final phoneOtpSendProvider = FutureProvider.family<bool, String>((ref, phone) {
  final phoneAuth = ref.read(phoneAuthServiceInterfaceProvider);
  return phoneAuth.sendOtp(phone).then((_) => true);
});

/// Phone OTP verify provider
final phoneOtpVerifyProvider =
    FutureProvider.family<bool, ({String phone, String otp})>(
  (ref, params) {
    final phoneAuth = ref.read(phoneAuthServiceInterfaceProvider);
    return phoneAuth.verifyOtp(params.phone, params.otp);
  },
);

/// Auth method preference
final authMethodProvider =
    StateNotifierProvider<AuthMethodNotifier, AuthMethod>(
  (ref) => AuthMethodNotifier(),
);

enum AuthMethod {
  password,
  pin,
  pattern,
  biometric,
  phone,
}

class AuthMethodNotifier extends StateNotifier<AuthMethod> {
  AuthMethodNotifier() : super(AuthMethod.password);

  AuthMethod get method => state;

  set method(AuthMethod newMethod) {
    state = newMethod;
  }
}
