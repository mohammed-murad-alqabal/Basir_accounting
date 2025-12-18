import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ${PROVIDER_NAME} - ${DESCRIPTION}
/// 
/// المشروع: بصير MVP
/// المؤلف: فريق وكلاء تطوير مشروع بصير
/// 
/// مثال على الاستخدام:
/// ```dart
/// final ${VARIABLE_NAME} = ref.watch(${PROVIDER_NAME});
/// ```

// Provider للحالة
final ${PROVIDER_NAME} = StateNotifierProvider<${NOTIFIER_NAME}, ${STATE_TYPE}>((ref) {
  return ${NOTIFIER_NAME}();
});

/// StateNotifier لإدارة حالة ${FEATURE_NAME}
class ${NOTIFIER_NAME} extends StateNotifier<${STATE_TYPE}> {
  ${NOTIFIER_NAME}() : super(${INITIAL_STATE});

  /// تحديث الحالة
  void updateState(${STATE_TYPE} newState) {
    state = newState;
  }

  /// إعادة تعيين الحالة
  void reset() {
    state = ${INITIAL_STATE};
  }
}