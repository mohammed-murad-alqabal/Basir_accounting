import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// خدمة الإشعارات المحلية
///
/// مسؤولة عن إعداد وعرض الإشعارات المحلية باستخدام
/// flutter_local_notifications. تدعم التخصيص حسب ثيم التطبيق.
class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// تهيئة الخدمة
  Future<void> initialize() async {
    if (_isInitialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        // يمكن إضافة منطق التفاعل هنا لاحقاً
      },
    );

    _isInitialized = true;
  }

  /// عرض إشعار بسيط
  ///
  /// [id] معرف الإشعار
  /// [title] العنوان
  /// [body] المحتوى
  /// [accentColor] لون التمييز
  /// (يظهر في Android كـ Small Icon Color أو Text Color)
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
      channelDescription: 'قناة الإشعارات الأساسية لتطبيق بصير',
      importance: Importance.max,
      priority: Priority.high,
      color: accentColor, // تطبيق لون الثيم هنا
      styleInformation: BigTextStyleInformation(body),
    );

    const iosDetails = DarwinNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }
}

/// موفر خدمة الإشعارات
final notificationServiceProvider =
    Provider<NotificationService>((ref) => NotificationService());
