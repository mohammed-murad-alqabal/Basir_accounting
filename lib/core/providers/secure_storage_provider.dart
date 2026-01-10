import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// مزود خدمة التخزين الآمن (Secure Storage)
///
/// يوفر وصولاً آمناً لتخزين البيانات الحساسة.
/// يتم تكوينه مع خيارات أمان محسنة للأندرويد و iOS و macOS.
final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(
    aOptions: AndroidOptions(
      sharedPreferencesName: 'basir_secure_prefs',
      preferencesKeyPrefix: 'basir_',
    ),
    iOptions: IOSOptions(
      groupId: 'group.com.basir.app',
      accountName: 'basir_keychain',
      accessibility: <credential-fixture>,
    ),
    mOptions: MacOsOptions(
      groupId: 'group.com.basir.app',
      accountName: 'basir_keychain',
      accessibility: <credential-fixture>,
    ),
  ),
);
