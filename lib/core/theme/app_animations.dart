/// نظام الحركات والانتقالات الموحد لتطبيق بصير
///
/// يوفر هذا الملف جميع الحركات والانتقالات المستخدمة في التطبيق
/// بما يتوافق مع معايير إمكانية الوصول وتجربة المستخدم.
///
/// **المعايير المطبقة:**
/// - مدة الانتقالات: 200-300ms (سريعة ومريحة)
/// - منحنيات الحركة: Material Design curves
/// - حركات سلسة وطبيعية
///
/// **الاستخدام:**
/// ```dart
/// AnimatedContainer(
///   duration: AppAnimations.durationNormal,
///   curve: AppAnimations.curveEaseInOut,
///   child: MyWidget(),
/// )
/// ```
library;

import 'package:flutter/material.dart';

/// نظام الحركات والانتقالات الموحد
class AppAnimations {
  AppAnimations._();

  // ======================================================
  // مدد الحركات (Animation Durations)
  // ======================================================

  /// مدة الحركة السريعة جداً (100ms)
  ///
  /// **الاستخدام:** تغييرات بسيطة، hover effects
  static const Duration durationFast = Duration(milliseconds: 100);

  /// مدة الحركة العادية (200ms) - المدة الأساسية
  ///
  /// **الاستخدام:** معظم الحركات في التطبيق
  /// **المعيار:** مدة مريحة للعين وسريعة كافية
  static const Duration durationNormal = Duration(milliseconds: 200);

  /// مدة الحركة المتوسطة (300ms)
  ///
  /// **الاستخدام:** انتقالات بين الشاشات، حركات معقدة
  static const Duration durationMedium = Duration(milliseconds: 300);

  /// مدة الحركة البطيئة (400ms)
  ///
  /// **الاستخدام:** حركات كبيرة، انتقالات مهمة
  static const Duration durationSlow = Duration(milliseconds: 400);

  /// مدة الحركة البطيئة جداً (500ms)
  ///
  /// **الاستخدام:** حركات خاصة، تأثيرات درامية
  static const Duration durationVerySlow = Duration(milliseconds: 500);

  // ======================================================
  // منحنيات الحركة (Animation Curves)
  // ======================================================

  /// منحنى الدخول السريع (Ease In)
  ///
  /// **الاستخدام:** عناصر تدخل الشاشة
  /// **الوصف:** يبدأ ببطء ثم يتسارع
  static const Curve curveEaseIn = Curves.easeIn;

  /// منحنى الخروج السريع (Ease Out)
  ///
  /// **الاستخدام:** عناصر تخرج من الشاشة
  /// **الوصف:** يبدأ بسرعة ثم يتباطأ
  static const Curve curveEaseOut = Curves.easeOut;

  /// منحنى الدخول والخروج السريع (Ease In Out)
  /// - المنحنى الأساسي
  ///
  /// **الاستخدام:** معظم الحركات في التطبيق
  /// **الوصف:** يبدأ ببطء، يتسارع، ثم يتباطأ
  static const Curve curveEaseInOut = Curves.easeInOut;

  /// منحنى خطي (Linear)
  ///
  /// **الاستخدام:** حركات ثابتة السرعة
  /// **الوصف:** سرعة ثابتة من البداية للنهاية
  static const Curve curveLinear = Curves.linear;

  /// منحنى مرن (Elastic)
  ///
  /// **الاستخدام:** تأثيرات مرحة، تنبيهات
  /// **الوصف:** حركة مرنة مع ارتداد
  static const Curve curveElastic = Curves.elasticOut;

  /// منحنى الارتداد (Bounce)
  ///
  /// **الاستخدام:** تأثيرات خاصة
  /// **الوصف:** حركة مع ارتداد في النهاية
  static const Curve curveBounce = Curves.bounceOut;

  /// منحنى Material (Fast Out Slow In)
  ///
  /// **الاستخدام:** انتقالات Material Design
  /// **الوصف:** المنحنى الموصى به من Material Design
  static const Curve curveFastOutSlowIn = Curves.fastOutSlowIn;

  // ==========================================================
  // انتقالات الشاشات (Page Transitions)
  // ==========================================================

  /// انتقال الانزلاق من اليمين (Slide from Right)
  ///
  /// **الاستخدام:** الانتقال للأمام في التطبيق
  ///
  /// **مثال:**
  /// ```dart
  /// Navigator.push(
  ///   context,
  ///   PageRouteBuilder(
  ///     pageBuilder: (context, animation, secondaryAnimation) => NextScreen(),
  ///     transitionsBuilder: AppAnimations.slideFromRight,
  ///   ),
  /// );
  /// ```
  static Widget slideFromRight(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1, 0);
    const end = Offset.zero;
    final tween = Tween(begin: begin, end: end);
    final offsetAnimation = animation.drive(
      tween.chain(CurveTween(curve: curveEaseInOut)),
    );

    return SlideTransition(position: offsetAnimation, child: child);
  }

  /// انتقال الانزلاق من اليسار (Slide from Left)
  ///
  /// **الاستخدام:** الانتقال للخلف في التطبيق
  static Widget slideFromLeft(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(-1, 0);
    const end = Offset.zero;
    final tween = Tween(begin: begin, end: end);
    final offsetAnimation = animation.drive(
      tween.chain(CurveTween(curve: curveEaseInOut)),
    );

    return SlideTransition(position: offsetAnimation, child: child);
  }

  /// انتقال الانزلاق من الأسفل (Slide from Bottom)
  ///
  /// **الاستخدام:** فتح الحوارات، القوائم السفلية
  static Widget slideFromBottom(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0, 1);
    const end = Offset.zero;
    final tween = Tween(begin: begin, end: end);
    final offsetAnimation = animation.drive(
      tween.chain(CurveTween(curve: curveEaseOut)),
    );

    return SlideTransition(position: offsetAnimation, child: child);
  }

  /// انتقال الانزلاق من الأعلى (Slide from Top)
  ///
  /// **الاستخدام:** إشعارات، تنبيهات
  static Widget slideFromTop(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0, -1);
    const end = Offset.zero;
    final tween = Tween(begin: begin, end: end);
    final offsetAnimation = animation.drive(
      tween.chain(CurveTween(curve: curveEaseOut)),
    );

    return SlideTransition(position: offsetAnimation, child: child);
  }

  /// انتقال التلاشي (Fade)
  ///
  /// **الاستخدام:** انتقالات ناعمة، تغييرات بسيطة
  static Widget fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => FadeTransition(opacity: animation, child: child);

  /// انتقال التكبير (Scale)
  ///
  /// **الاستخدام:** فتح الحوارات، عرض التفاصيل
  static Widget scaleTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => ScaleTransition(
    scale: Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: animation, curve: curveEaseOut)),
    child: child,
  );

  /// انتقال مركب: تلاشي + انزلاق (Fade + Slide)
  ///
  /// **الاستخدام:** انتقالات احترافية بين الشاشات
  static Widget fadeSlideTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0, 0.3);
    const end = Offset.zero;
    final tween = Tween(begin: begin, end: end);
    final offsetAnimation = animation.drive(
      tween.chain(CurveTween(curve: curveEaseOut)),
    );

    return SlideTransition(
      position: offsetAnimation,
      child: FadeTransition(opacity: animation, child: child),
    );
  }

  // ==========================================================
  // حركات العناصر (Widget Animations)
  // ==========================================================

  /// حركة الظهور التدريجي (Fade In)
  ///
  /// **الاستخدام:** إظهار عناصر جديدة
  ///
  /// **مثال:**
  /// ```dart
  /// AnimatedOpacity(
  ///   opacity: isVisible ? 1.0 : 0.0,
  ///   duration: AppAnimations.durationNormal,
  ///   curve: AppAnimations.curveEaseIn,
  ///   child: MyWidget(),
  /// )
  /// ```
  static Widget fadeIn({
    required Widget child,
    Duration? duration,
    Curve? curve,
  }) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: duration ?? durationNormal,
    curve: curve ?? curveEaseIn,
    builder: (context, value, child) => Opacity(opacity: value, child: child),
    child: child,
  );

  /// حركة الاختفاء التدريجي (Fade Out)
  ///
  /// **الاستخدام:** إخفاء عناصر
  static Widget fadeOut({
    required Widget child,
    Duration? duration,
    Curve? curve,
  }) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 1, end: 0),
    duration: duration ?? durationNormal,
    curve: curve ?? curveEaseOut,
    builder: (context, value, child) => Opacity(opacity: value, child: child),
    child: child,
  );

  /// حركة الانزلاق للأعلى (Slide Up)
  ///
  /// **الاستخدام:** إظهار عناصر من الأسفل
  static Widget slideUp({
    required Widget child,
    Duration? duration,
    Curve? curve,
    double offset = 50.0,
  }) => TweenAnimationBuilder<double>(
    tween: Tween(begin: offset, end: 0),
    duration: duration ?? durationNormal,
    curve: curve ?? curveEaseOut,
    builder: (context, value, child) =>
        Transform.translate(offset: Offset(0, value), child: child),
    child: child,
  );

  /// حركة التكبير (Scale Up)
  ///
  /// **الاستخدام:** إظهار عناصر بتأثير التكبير
  static Widget scaleUp({
    required Widget child,
    Duration? duration,
    Curve? curve,
  }) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: duration ?? durationNormal,
    curve: curve ?? curveEaseOut,
    builder: (context, value, child) =>
        Transform.scale(scale: value, child: child),
    child: child,
  );

  // ==========================================================
  // تأثيرات التفاعل (Interaction Effects)
  // ==========================================================

  /// تأثير الضغط (Press Effect)
  ///
  /// **الاستخدام:** تأثير عند الضغط على الأزرار
  ///
  /// **مثال:**
  /// ```dart
  /// GestureDetector(
  ///   onTapDown: (_) => setState(() => _isPressed = true),
  ///   onTapUp: (_) => setState(() => _isPressed = false),
  ///   child: AnimatedScale(
  ///     scale: _isPressed ? 0.95 : 1.0,
  ///     duration: AppAnimations.durationFast,
  ///     child: MyButton(),
  ///   ),
  /// )
  /// ```
  static const double pressScale = 0.95;

  /// تأثير الحوم (Hover Effect)
  ///
  /// **الاستخدام:** تأثير عند الحوم على العناصر
  static const double hoverScale = 1.05;

  /// تأثير الارتفاع (Elevation Effect)
  ///
  /// **الاستخدام:** تغيير الارتفاع عند التفاعل

  /// الارتفاع العادي
  static const double elevationNormal = 2;

  /// الارتفاع عند الحوم
  static const double elevationHovered = 4;

  /// الارتفاع عند الضغط
  static const double elevationPressed = 1;

  // ==========================================================
  // حركات القوائم (List Animations)
  // ==========================================================

  /// تأخير بين عناصر القائمة (Stagger Delay)
  ///
  /// **الاستخدام:** إظهار عناصر القائمة بشكل متتابع
  ///
  /// **مثال:**
  /// ```dart
  /// ListView.builder(
  ///   itemCount: items.length,
  ///   itemBuilder: (context, index) {
  ///     return AnimatedBuilder(
  ///       animation: _controller,
  ///       builder: (context, child) {
  ///         final delay = index *
  ///             AppAnimations.staggerDelay.inMilliseconds;
  ///         // تطبيق الحركة مع التأخير
  ///       },
  ///     );
  ///   },
  /// )
  /// ```
  static const Duration staggerDelay = Duration(milliseconds: 50);

  /// مدة حركة عنصر القائمة
  static const Duration listItemDuration = Duration(milliseconds: 300);

  // ==========================================================
  // حركات التحميل (Loading Animations)
  // ==========================================================

  /// مدة دوران مؤشر التحميل
  static const Duration loadingRotationDuration = Duration(milliseconds: 1000);

  /// مدة نبض مؤشر التحميل
  static const Duration loadingPulseDuration = Duration(milliseconds: 1500);

  // ==========================================================
  // دوال مساعدة (Helper Functions)
  // ==========================================================

  /// ينشئ PageRoute مع انتقال مخصص
  ///
  /// **الاستخدام:**
  /// ```dart
  /// Navigator.push(
  ///   context,
  ///   AppAnimations.createRoute(
  ///     page: NextScreen(),
  ///     transition: AppAnimations.slideFromRight,
  ///   ),
  /// );
  /// ```
  static PageRouteBuilder<T> createRoute<T>({
    required Widget page,
    required RouteTransitionsBuilder transition,
    Duration? duration,
  }) => PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: transition,
    transitionDuration: duration ?? durationMedium,
  );

  /// يحسب التأخير للعنصر في القائمة
  ///
  /// **الاستخدام:**
  /// ```dart
  /// final delay = AppAnimations.calculateStaggerDelay(index);
  /// ```
  static Duration calculateStaggerDelay(int index, {int maxDelay = 500}) {
    final delayMs = index * staggerDelay.inMilliseconds;
    return Duration(milliseconds: delayMs > maxDelay ? maxDelay : delayMs);
  }

  /// ينشئ AnimationController مع المدة المحددة
  ///
  /// **الاستخدام:**
  /// ```dart
  /// final controller = AppAnimations.createController(
  ///   vsync: this,
  ///   duration: AppAnimations.durationNormal,
  /// );
  /// ```
  static AnimationController createController({
    required TickerProvider vsync,
    Duration? duration,
  }) => AnimationController(vsync: vsync, duration: duration ?? durationNormal);
}
