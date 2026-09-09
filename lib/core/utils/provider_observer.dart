import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// واجهة قابلة للإضافة لتسجيل الأخطاء في خدمات خارجية
/// (Sentry, Firebase Crashlytics, Datadog, etc.)
///
/// يمكن إضافة تنفيذ حقيقي لاحقاً دون تعديل المراقب نفسه.
abstract class ExternalErrorLogger {
  /// يتم استدعاؤها عند حدوث خطأ غير متوقع
  FutureOr<void> captureException(
    Object error,
    StackTrace stackTrace, {
    Object? context,
    String? providerName,
  });

  /// إغلاق أي موارد مفتوحة
  Future<void> dispose() async {}
}

/// تنفيذ افتراضي لا يقوم بأي شيء حتى لا يكسر التطبيق
/// حتى يتم إعداد خدمة التتبع الحقيقية
class _NoopErrorLogger implements ExternalErrorLogger {
  const _NoopErrorLogger();

  @override
  FutureOr<void> captureException(
    Object error,
    StackTrace stackTrace, {
    Object? context,
    String? providerName,
  }) async {}

  @override
  Future<void> dispose() async {}
}

class TraeDebugHttpErrorLogger implements ExternalErrorLogger {
  TraeDebugHttpErrorLogger({
    Dio? dio,
    this.endpoint = 'http://127.0.0.1:17373/log',
  }) : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(milliseconds: 800),
                sendTimeout: const Duration(milliseconds: 800),
                receiveTimeout: const Duration(milliseconds: 1200),
                headers: const {
                  'Content-Type': 'application/json',
                },
              ),
            );

  final Dio _dio;
  final String endpoint;

  @override
  FutureOr<void> captureException(
    Object error,
    StackTrace stackTrace, {
    Object? context,
    String? providerName,
  }) async {
    // #region debug-point mobile-device-validation-error
    try {
      await _dio.post<void>(
        endpoint,
        data: jsonEncode({
          'ts': DateTime.now().toIso8601String(),
          'type': 'provider_error',
          'provider': providerName,
          'error': error.toString(),
          'stack': stackTrace.toString(),
          'context': context,
        }),
      );
    } on Object catch (_) {}
    // #endregion debug-point mobile-device-validation-error
  }

  @override
  Future<void> dispose() async {
    _dio.close(force: true);
  }
}

/// مزود قابل للتبديل - يمكن تجاوزه لاحقاً من خلال ProviderScope
/// مثال:
/// ```dart
/// ProviderScope(
///   overrides: [
///     externalErrorLoggerProvider.overrideWithValue(SentryLogger()),
///   ],
///   child: const BasirApp(),
/// )
/// ```
final externalErrorLoggerProvider = Provider<ExternalErrorLogger>(
  (ref) => const _NoopErrorLogger(),
);

/// مراقب عالمي للمزودين (ProviderObserver)
///
/// يقوم بمراقبة جميع التغييرات والأخطاء في Providers
/// مفيد لتتبع حالة التطبيق واكتشاف المشاكل في وقت مبكر
///
/// يتم توجيه الأخطاء تلقائياً إلى [ExternalErrorLogger] عند إعداده.
class BasirProviderObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (kDebugMode) {
      debugPrint('Provider Updated: ${provider.name ?? provider.runtimeType}');
    }
  }

  /// يتم استدعاؤه عند فشل المزود
  ///
  /// 1. تسجيل الخطأ في السجل المحلي (Console)
  /// 2. إرسال نسخة عن الخطأ إلى المسجل الخارجي عند إعداده
  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    final name = provider.name ?? provider.runtimeType.toString();

    debugPrint('❌ Provider Error: $name');
    debugPrint('Error: $error');
    debugPrint('StackTrace: $stackTrace');

    // إرسال الخطأ إلى المسجل الخارجي إذا كان متوفراً
    // يتم الالتقاط الآمن لأن container.read قد يرمي أخطاءً أثناء الإقلاع
    try {
      final logger = container.read(externalErrorLoggerProvider);
      Future<void> dispatch() async => logger.captureException(
            error,
            stackTrace,
            providerName: name,
            context: {
              'provider': name,
              'time': DateTime.now().toIso8601String(),
            },
          );
      unawaited(dispatch());
    } on Exception catch (e) {
      // لا نبعث خطأً من داخل معالج الأخطاء نفسه
      debugPrint(
        '⚠️ Failed to dispatch to ExternalErrorLogger (non-critical): $e',
      );
    }
  }

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    if (kDebugMode) {
      debugPrint('Provider Added: ${provider.name ?? provider.runtimeType}');
    }
  }
}
