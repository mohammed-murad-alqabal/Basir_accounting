import 'dart:async';

import 'package:basir_accounting_system/core/constants.dart';
import 'package:basir_accounting_system/features/mfa/domain/services/phone_auth_service_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthException, OtpType, Session, SupabaseClient, User;

/// PhoneAuthService - Phone OTP authentication via Supabase
class PhoneAuthService implements PhoneAuthServiceInterface {
  PhoneAuthService({required this.supabaseClient, required this.secureStorage});

  final SupabaseClient supabaseClient;
  final FlutterSecureStorage secureStorage;
  final _phoneAuthStateController = StreamController<String?>.broadcast();

  Stream<String?> get onPhoneAuthStateChange => _phoneAuthStateController.stream;
  Session? get currentSession => supabaseClient.auth.currentSession;
  User? get currentUser => supabaseClient.auth.currentUser;
  bool get isPhoneLoggedIn => currentUser != null;

  /// Send OTP to phone number
  Future<void> sendOtp(String phoneNumber) async {
    try {
      final normalizedNumber = _normalizePhone(phoneNumber);
      await supabaseClient.auth.signInWithOtp(phone: normalizedNumber);
      if (!kReleaseMode) {
        debugPrint('📱 [PHONE_AUTH] OTP sent to $normalizedNumber');
      }
    } on AuthException catch (e) {
      debugPrint('⚠️ [PHONE_AUTH] OTP send error: ${e.message}');
      rethrow;
    }
  }

  /// Verify OTP code
  Future<bool> verifyOtp(String phoneNumber, String otpCode) async {
    try {
      final normalizedNumber = _normalizePhone(phoneNumber);
      // Supabase verify OTP - يجب استخدام verifyOTP
      final response = await supabaseClient.auth.verifyOTP(
        phone: normalizedNumber,
        token: otpCode,
        type: OtpType.sms,
      );

      if (response.session != null) {
        await secureStorage.write(key: StorageKeys.phoneNumber, value: normalizedNumber);
        await secureStorage.write(key: StorageKeys.phoneVerified, value: 'true');
        _phoneAuthStateController.add(normalizedNumber);
        if (!kReleaseMode) {
          debugPrint('✅ [PHONE_AUTH] OTP verified');
        }
        return true;
      }
      return false;
    } on AuthException catch (e) {
      debugPrint('⚠️ [PHONE_AUTH] OTP verify error: ${e.message}');
      return false;
    }
  }

  /// Login with phone and password
  Future<bool> loginWithPhone(String phoneNumber, String password) async {
    try {
      final normalizedNumber = _normalizePhone(phoneNumber);
      final response = await supabaseClient.auth.signInWithPassword(
        phone: normalizedNumber,
        password: password,
      );

      if (response.session != null) {
        _phoneAuthStateController.add(normalizedNumber);
        if (!kReleaseMode) {
          debugPrint('✅ [PHONE_AUTH] Phone login successful');
        }
        return true;
      }
      return false;
    } on AuthException catch (e) {
      debugPrint('⚠️ [PHONE_AUTH] Login error: ${e.message}');
      return false;
    }
  }

  /// Sign up with phone
  Future<bool> signUpWithPhone(String phoneNumber, String password) async {
    try {
      final normalizedNumber = _normalizePhone(phoneNumber);
      final response = await supabaseClient.auth.signUp(
        phone: normalizedNumber,
        password: password,
      );

      if (response.user != null) {
        if (!kReleaseMode) {
          debugPrint('✅ [PHONE_AUTH] Phone signup successful');
        }
        return true;
      }
      return false;
    } on AuthException catch (e) {
      debugPrint('⚠️ [PHONE_AUTH] Signup error: ${e.message}');
      return false;
    }
  }

  /// Get stored phone number
  Future<String?> getPhoneNumber() async => secureStorage.read(key: StorageKeys.phoneNumber);

  /// Check if phone is verified
  Future<bool> isPhoneVerified() async =>
      await secureStorage.read(key: StorageKeys.phoneVerified) == 'true';

  /// Sign out
  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
    await secureStorage.delete(key: StorageKeys.phoneNumber);
    await secureStorage.delete(key: StorageKeys.phoneVerified);
    _phoneAuthStateController.add(null);
    if (!kReleaseMode) {
      debugPrint('📱 [PHONE_AUTH] Signed out');
    }
  }

  /// Normalize phone number (add Saudi code if missing)
  String _normalizePhone(String phone) {
    if (phone.startsWith('+')) return phone;
    if (phone.startsWith('0')) return '+966${phone.substring(1)}';
    return '+966$phone';
  }

  /// Format phone for display
  String formatPhone(String phone) {
    final clean = phone.replaceFirst('+', '');
    if (clean.length == 12 && clean.startsWith('966')) {
      final local = clean.substring(3);
      return '${local.substring(0, 3)} ${local.substring(3, 6)} ${local.substring(6)}';
    }
    return phone;
  }

  void dispose() => _phoneAuthStateController.close();
}
