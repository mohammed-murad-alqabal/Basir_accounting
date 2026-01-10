import 'dart:io';

import 'package:basir_app/features/auth/application/auth_service.dart';
import 'package:basir_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:basir_app/src/rust/api.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

/// Provider for the AuditService
final auditServiceProvider = Provider<AuditService>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuditService(authService);
});

/// [AuditService]
///
/// Manages the security context for the current session and provides
/// standard audit metadata (`WhoDto`, `WhereDto`) for all institutional transactions.
class AuditService {
  AuditService(this._authService);

  final AuthService _authService;

  String? _deviceId;
  String? _appVersion;
  String? _systemId;
  String _sessionId = const Uuid().v4();

  /// Initializes session context (device info, system ID).
  Future<void> initialize() async {
    final deviceInfo = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();

    _appVersion = packageInfo.version;

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        _deviceId = androidInfo.id;
        _systemId = 'ANDROID_${androidInfo.model}';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        _deviceId = iosInfo.identifierForVendor;
        _systemId = 'IOS_${iosInfo.name}';
      } else if (Platform.isLinux) {
        final linuxInfo = await deviceInfo.linuxInfo;
        _deviceId = linuxInfo.machineId;
        _systemId = 'LINUX_${linuxInfo.name}';
      } else if (Platform.isMacOS) {
        final macInfo = await deviceInfo.macOsInfo;
        _deviceId = macInfo.systemGUID;
        _systemId = 'MACOS_${macInfo.model}';
      } else if (Platform.isWindows) {
        final winInfo = await deviceInfo.windowsInfo;
        _deviceId = winInfo.deviceId;
        _systemId = 'WINDOWS_${winInfo.computerName}';
      }
    } catch (e) {
      debugPrint('Warning: Could not fetch device info: $e');
      _deviceId = 'UNKNOWN_DEVICE';
      _systemId = 'UNKNOWN_SYSTEM';
    }
  }

  /// Resets the session ID (e.g., on login/logout).
  void refreshSession() {
    _sessionId = const Uuid().v4();
  }

  /// Generates the [AuditMetadataDto] required for Rust bridge operations.
  ///
  /// Capture the 5 Ws:
  /// - Who: Current user & role
  /// - Where: Device & System ID
  /// - Why: Intent (reason)
  /// - How: Method/Procedure
  Future<AuditMetadataDto> generateMetadata({
    required String action,
    String? reason,
    String? justification,
  }) async {
    final user = await _authService.getCurrentUser();

    // Default to "System" or "Guest" if no user is logged in
    final userId = user?.id ?? '00000000-0000-0000-0000-000000000000';
    final userName =
        user?.displayName ?? (user?.isGuest ?? false ? 'Guest' : 'System');
    final userRole = user?.role.name ?? 'system';

    return AuditMetadataDto(
      who: WhoDto(
        userId: userId,
        userName: userName,
        role: userRole,
        sessionId: _sessionId,
      ),
      where: WhereDto(
        systemId: _systemId ?? 'UNKNOWN',
        deviceId: _deviceId,
        appVersion: _appVersion,
      ),
      why: WhyDto(
        reasonCode: reason,
        justification: justification,
      ),
      how: HowDto(
        method: action,
      ),
    );
  }
}
