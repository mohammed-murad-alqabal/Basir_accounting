import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Local notification service for push notification management.
///
/// Handles initialization and display of local notifications using
/// [FlutterLocalNotificationsPlugin]. Supports theme-aware accent colors
/// and customizable notification content.
///
/// ## Features
/// - Cross-platform support (Android, iOS)
/// - Theme-aware accent colors
/// - BigText style for long messages
/// - Attachment support via payload
///
/// ## Usage
/// ```dart
/// final service = ref.read(notificationServiceProvider);
/// await service.initialize();
/// await service.showNotification(
///   id: 1,
///   title: 'Invoice Created',
///   body: 'Invoice #12345 has been created successfully.',
/// );
/// ```
class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initializes the notification service.
  ///
  /// Must be called before showing any notifications. Safe to call multiple
  /// times; subsequent calls are no-ops.
  Future<void> initialize() async {
    if (_isInitialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        // Notification tap handling can be added here
      },
    );

    _isInitialized = true;
  }

  /// Displays a local notification.
  ///
  /// ## Parameters
  /// - [id]: Unique notification identifier (used for updates/cancellation).
  /// - [title]: Notification title text.
  /// - [body]: Notification body content.
  /// - [accentColor]: Optional theme accent color for Android.
  /// - [payload]: Optional data payload for tap handling.
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    Color? accentColor,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'basir_default_channel',
      'Basir Notifications',
      channelDescription: 'Primary notification channel for Basir app',
      importance: Importance.max,
      priority: Priority.high,
      color: accentColor,
      styleInformation: BigTextStyleInformation(body),
    );

    const iosDetails = DarwinNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(id, title, body, details, payload: payload);
  }
}

/// Notification service provider.
///
/// Provides a singleton [NotificationService] instance.
final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);
