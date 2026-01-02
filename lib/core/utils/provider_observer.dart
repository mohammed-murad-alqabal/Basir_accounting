import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// مراقب عالمي للمزودين (ProviderObserver)
///
/// يقوم بمراقبة جميع التغييرات والأخطاء في Providers
/// مفيد لتتبع حالة التطبيق واكتشاف المشاكل في وقت مبكر
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
  /// يقوم بتسجيل الخطأ في السجل (Console)
  /// يمكن استخدامه لإرسال الأخطاء إلى خدمة تتبع خارجية
  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    debugPrint('❌ Provider Error: ${provider.name ?? provider.runtimeType}');
    debugPrint('Error: $error');
    debugPrint('StackTrace: $stackTrace');

    // TODO(team): Add external error logging service like Sentry or Firebase
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
