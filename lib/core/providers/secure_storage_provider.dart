import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage provider for sensitive data persistence.
///
/// Provides a configured [FlutterSecureStorage] instance with platform-specific
/// security options optimized for Android, iOS, and macOS.
///
/// ## Security Features
/// - **Android**: Uses dedicated SharedPreferences with custom namespace
/// - **iOS/macOS**: Keychain storage with device-bound accessibility
///
/// ## Usage
/// ```dart
/// final storage = ref.watch(secureStorageProvider);
/// await storage.write(key: 'token', value: 'secret');
/// final token = await storage.read(key: 'token');
/// ```
final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(
    aOptions: AndroidOptions(
      sharedPreferencesName: 'basir_secure_prefs',
      preferencesKeyPrefix: 'basir_',
    ),
    iOptions: IOSOptions(
      groupId: 'group.com.basir.app',
      accountName: 'basir_keychain',
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
    mOptions: MacOsOptions(
      groupId: 'group.com.basir.app',
      accountName: 'basir_keychain',
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  ),
);
