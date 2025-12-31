import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// مزود خدمة التخزين الآمن (Secure Storage)
///
/// يوفر وصولاً آمناً لتخزين البيانات الحساسة.
/// يتم تكوينه مع خيارات أمان محسنة للأندرويد و iOS و macOS.
final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      sharedPreferencesName: 'basser_secure_prefs',
      preferencesKeyPrefix: 'basser_',
    ),
    iOptions: IOSOptions(
      groupId: 'group.com.basser.app',
      accountName: 'basser_keychain',
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
    mOptions: MacOsOptions(
      groupId: 'group.com.basser.app',
      accountName: 'basser_keychain',
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  ),
);
