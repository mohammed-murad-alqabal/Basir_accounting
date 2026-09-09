/// PhoneAuthServiceInterface - Interface for phone authentication services
abstract class PhoneAuthServiceInterface {
  /// Send OTP to phone number
  Future<void> sendOtp(String phoneNumber);

  /// Verify OTP code
  Future<bool> verifyOtp(String phone, String otp);

  /// Check if phone is verified
  Future<bool> isPhoneVerified();

  /// Get stored phone number
  Future<String?> getPhoneNumber();
}
