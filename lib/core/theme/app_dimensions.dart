/// نظام الأبعاد والمسافات الموحد للتطبيق
///
/// يحتوي على جميع الأبعاد والمسافات المستخدمة في التطبيق

/// الأبعاد والمسافات الموحدة للتطبيق
class AppDimensions {
  AppDimensions._();

  // المسافات الأساسية

  /// مسافة صغيرة جداً (4px)
  static const double spacingXs = 4;

  /// مسافة صغيرة (8px)
  static const double spacingSm = 8;

  /// مسافة متوسطة (16px)
  static const double spacingMd = 16;

  /// مسافة كبيرة (24px)
  static const double spacingLg = 24;

  /// مسافة كبيرة جداً (32px)
  static const double spacingXl = 32;

  /// مسافة كبيرة جداً جداً (48px)
  static const double spacingXxl = 48;

  // نصف أقطار الحواف

  /// نصف قطر صغير (4px)
  static const double radiusSm = 4;

  /// نصف قطر متوسط (8px)
  static const double radiusMd = 8;

  /// نصف قطر كبير (12px)
  static const double radiusLg = 12;

  /// نصف قطر كبير جداً (16px)
  static const double radiusXl = 16;

  /// نصف قطر دائري كامل (999px)
  static const double radiusFull = 999;

  // أحجام الأيقونات

  /// حجم أيقونة صغير (16px)
  static const double iconSm = 16;

  /// حجم أيقونة متوسط (24px)
  static const double iconMd = 24;

  /// حجم أيقونة كبير (32px)
  static const double iconLg = 32;

  /// حجم أيقونة كبير جداً (48px)
  static const double iconXl = 48;

  // أحجام الأزرار

  /// ارتفاع زر صغير (32px)
  static const double buttonHeightSm = 32;

  /// ارتفاع زر متوسط (40px)
  static const double buttonHeightMd = 40;

  /// ارتفاع زر كبير (48px)
  static const double buttonHeightLg = 48;

  /// ارتفاع زر كبير جداً (56px)
  static const double buttonHeightXl = 56;

  // أحجام حقول الإدخال

  /// ارتفاع حقل إدخال صغير (32px)
  static const double inputHeightSm = 32;

  /// ارتفاع حقل إدخال متوسط (40px)
  static const double inputHeightMd = 40;

  /// ارتفاع حقل إدخال كبير (48px)
  static const double inputHeightLg = 48;

  // الحد الأدنى لمساحة اللمس (Touch Target)

  /// الحد الأدنى لمساحة اللمس (48px) - معيار WCAG
  static const double minTouchTarget = 48;

  /// الحد الأدنى الموصى به لمساحة اللمس (44px) - معيار iOS
  static const double minTouchTargetIos = 44;

  // عرض الحاويات

  /// عرض أقصى للمحتوى على الشاشات الكبيرة (1200px)
  static const double maxContentWidth = 1200;

  /// عرض أقصى للنماذج (600px)
  static const double maxFormWidth = 600;

  /// عرض أقصى للبطاقات (400px)
  static const double maxCardWidth = 400;

  // ارتفاعات ثابتة

  /// ارتفاع شريط التطبيق (56px)
  static const double appBarHeight = 56;

  /// ارتفاع شريط التنقل السفلي (56px)
  static const double bottomNavHeight = 56;

  /// ارتفاع شريط علامات التبويب (48px)
  static const double tabBarHeight = 48;

  // الظلال

  /// ارتفاع ظل صغير (2px)
  static const double elevationSm = 2;

  /// ارتفاع ظل متوسط (4px)
  static const double elevationMd = 4;

  /// ارتفاع ظل كبير (8px)
  static const double elevationLg = 8;

  /// ارتفاع ظل كبير جداً (16px)
  static const double elevationXl = 16;
}
