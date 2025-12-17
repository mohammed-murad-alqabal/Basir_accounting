/// ملف تصدير مركزي لجميع الـ Widgets المخصصة
///
/// يسهل استيراد جميع الـ Widgets بسطر واحد
///
/// Example:
/// ```dart
/// import 'package:basser_app/core/widgets/index.dart';
///
/// // الآن يمكن استخدام جميع الـ Widgets:
/// AppEnhancedButton(...)
/// AppCard(...)
/// AppTextField(...)
/// AppAppBar(...)
/// ```
library;

export 'app_app_bar.dart';
export 'app_button.dart'; // Legacy - سيتم إزالته تدريجياً
export 'app_card.dart';
export 'app_enhanced_button.dart'; // الزر المحسّن الجديد
export 'app_text_field.dart';
export 'overflow_detector.dart';
export 'responsive_text.dart';
export 'text_scale_factor_tester.dart';
