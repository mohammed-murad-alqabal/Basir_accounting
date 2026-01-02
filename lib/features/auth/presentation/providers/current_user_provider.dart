import 'package:basir_app/core/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// موفر حالة المستخدم الحالي
///
/// يستمع إلى خدمة المصادقة ويوفر اسم المستخدم الحالي بشكل متفاعل.
/// عندما يتغير المستخدم (تسجيل دخول/خروج)، يتم تحديث هذا الموفر،
/// مما يؤدي إلى تحديث جميع الموفرين الذين يعتمدون عليه (مثل إعدادات الثيم).
final currentUserProvider = StreamProvider<String?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.onAuthStateChange;
});
