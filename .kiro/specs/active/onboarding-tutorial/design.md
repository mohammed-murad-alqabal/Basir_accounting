# تصميم ميزة التعليمات التوضيحية (Onboarding Tutorial)

**المشروع:** بصير MVP  
**التاريخ:** 3 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ معتمد

---

## 1. البنية المعمارية

### 1.1 نظرة عامة

```
lib/core/tutorial/
├── models/
│   ├── tutorial_step.dart          # نموذج الخطوة
│   └── tutorial_config.dart        # إعدادات التعليمات
├── widgets/
│   ├── tutorial_overlay.dart       # Overlay الرئيسي
│   ├── tutorial_tooltip.dart       # بطاقة النصيحة
│   ├── tutorial_spotlight.dart     # تسليط الضوء
│   └── tutorial_controls.dart      # أزرار التحكم
├── services/
│   ├── tutorial_storage.dart       # التخزين
│   └── tutorial_controller.dart    # التحكم
└── data/
    ├── dashboard_tutorial.dart     # تعليمات Dashboard
    ├── customers_tutorial.dart     # تعليمات Customers
    ├── invoices_tutorial.dart      # تعليمات Invoices
    └── settings_tutorial.dart      # تعليمات Settings
```

---

## 2. نماذج البيانات (Data Models)

### 2.1 TutorialStep

```dart
/// خطوة واحدة في التعليمات
class TutorialStep {
  /// معرف فريد للخطوة
  final String id;

  /// عنوان النصيحة
  final String title;

  /// وصف النصيحة
  final String description;

  /// GlobalKey للعنصر المستهدف
  final GlobalKey? targetKey;

  /// موضع بطاقة النصيحة
  final TooltipPosition position;

  /// أيقونة النصيحة (اختياري)
  final IconData? icon;

  /// هل يمكن تخطي هذه الخطوة؟
  final bool skippable;

  /// مدة عرض الخطوة (بالثواني)
  final int? duration;

  const TutorialStep({
    required this.id,
    required this.title,
    required this.description,
    this.targetKey,
    this.position = TooltipPosition.bottom,
    this.icon,
    this.skippable = true,
    this.duration,
  });
}

/// موضع بطاقة النصيحة
enum TooltipPosition {
  top,
  bottom,
  left,
  right,
  center,
}
```

### 2.2 TutorialConfig

```dart
/// إعدادات التعليمات لشاشة معينة
class TutorialConfig {
  /// معرف الشاشة
  final String screenId;

  /// قائمة الخطوات
  final List<TutorialStep> steps;

  /// هل يتم عرض التعليمات تلقائياً؟
  final bool autoShow;

  /// هل يمكن تخطي جميع الخطوات؟
  final bool allowSkipAll;

  /// رسالة الترحيب (اختياري)
  final String? welcomeMessage;

  /// رسالة الإكمال (اختياري)
  final String? completionMessage;

  const TutorialConfig({
    required this.screenId,
    required this.steps,
    this.autoShow = true,
    this.allowSkipAll = true,
    this.welcomeMessage,
    this.completionMessage,
  });
}
```

### 2.3 TutorialState

```dart
/// حالة التعليمات المحفوظة
class TutorialState {
  /// هل تم إكمال تعليمات Dashboard؟
  final bool dashboardCompleted;

  /// هل تم إكمال تعليمات Customers؟
  final bool customersCompleted;

  /// هل تم إكمال تعليمات Invoices؟
  final bool invoicesCompleted;

  /// هل تم إكمال تعليمات Settings؟
  final bool settingsCompleted;

  /// عدم الإظهار مرة أخرى نهائياً
  final bool neverShowAgain;

  /// آخر مرة تم عرض التعليمات
  final DateTime? lastShown;

  const TutorialState({
    this.dashboardCompleted = false,
    this.customersCompleted = false,
    this.invoicesCompleted = false,
    this.settingsCompleted = false,
    this.neverShowAgain = false,
    this.lastShown,
  });

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'dashboardCompleted': dashboardCompleted,
      'customersCompleted': customersCompleted,
      'invoicesCompleted': invoicesCompleted,
      'settingsCompleted': settingsCompleted,
      'neverShowAgain': neverShowAgain,
      'lastShown': lastShown?.toIso8601String(),
    };
  }

  /// تحويل من JSON
  factory TutorialState.fromJson(Map<String, dynamic> json) {
    return TutorialState(
      dashboardCompleted: json['dashboardCompleted'] ?? false,
      customersCompleted: json['customersCompleted'] ?? false,
      invoicesCompleted: json['invoicesCompleted'] ?? false,
      settingsCompleted: json['settingsCompleted'] ?? false,
      neverShowAgain: json['neverShowAgain'] ?? false,
      lastShown: json['lastShown'] != null
          ? DateTime.parse(json['lastShown'])
          : null,
    );
  }

  /// نسخ مع تعديلات
  TutorialState copyWith({
    bool? dashboardCompleted,
    bool? customersCompleted,
    bool? invoicesCompleted,
    bool? settingsCompleted,
    bool? neverShowAgain,
    DateTime? lastShown,
  }) {
    return TutorialState(
      dashboardCompleted: dashboardCompleted ?? this.dashboardCompleted,
      customersCompleted: customersCompleted ?? this.customersCompleted,
      invoicesCompleted: invoicesCompleted ?? this.invoicesCompleted,
      settingsCompleted: settingsCompleted ?? this.settingsCompleted,
      neverShowAgain: neverShowAgain ?? this.neverShowAgain,
      lastShown: lastShown ?? this.lastShown,
    );
  }
}
```

---

## 3. الخدمات (Services)

### 3.1 TutorialStorage

```dart
/// خدمة تخزين حالة التعليمات
class TutorialStorage {
  static const String _key = 'tutorial_state';
  final SharedPreferences _prefs;

  TutorialStorage(this._prefs);

  /// حفظ الحالة
  Future<void> saveState(TutorialState state) async {
    await _prefs.setString(_key, jsonEncode(state.toJson()));
  }

  /// قراءة الحالة
  TutorialState loadState() {
    final json = _prefs.getString(_key);
    if (json == null) return const TutorialState();
    return TutorialState.fromJson(jsonDecode(json));
  }

  /// إعادة تعيين جميع التعليمات
  Future<void> resetAll() async {
    await _prefs.remove(_key);
  }

  /// تحديث حالة شاشة معينة
  Future<void> markScreenCompleted(String screenId) async {
    final state = loadState();
    TutorialState newState;

    switch (screenId) {
      case 'dashboard':
        newState = state.copyWith(dashboardCompleted: true);
        break;
      case 'customers':
        newState = state.copyWith(customersCompleted: true);
        break;
      case 'invoices':
        newState = state.copyWith(invoicesCompleted: true);
        break;
      case 'settings':
        newState = state.copyWith(settingsCompleted: true);
        break;
      default:
        return;
    }

    await saveState(newState.copyWith(lastShown: DateTime.now()));
  }

  /// تعيين "عدم الإظهار مرة أخرى"
  Future<void> setNeverShowAgain(bool value) async {
    final state = loadState();
    await saveState(state.copyWith(neverShowAgain: value));
  }

  /// هل يجب عرض التعليمات لشاشة معينة؟
  bool shouldShowForScreen(String screenId) {
    final state = loadState();

    if (state.neverShowAgain) return false;

    switch (screenId) {
      case 'dashboard':
        return !state.dashboardCompleted;
      case 'customers':
        return !state.customersCompleted;
      case 'invoices':
        return !state.invoicesCompleted;
      case 'settings':
        return !state.settingsCompleted;
      default:
        return false;
    }
  }
}
```

### 3.2 TutorialController

```dart
/// متحكم التعليمات
class TutorialController extends ChangeNotifier {
  final TutorialStorage _storage;
  final TutorialConfig config;

  int _currentStep = 0;
  bool _isShowing = false;

  TutorialController({
    required TutorialStorage storage,
    required this.config,
  }) : _storage = storage;

  /// الخطوة الحالية
  int get currentStep => _currentStep;

  /// هل التعليمات معروضة؟
  bool get isShowing => _isShowing;

  /// عدد الخطوات
  int get totalSteps => config.steps.length;

  /// الخطوة الحالية
  TutorialStep get currentStepData => config.steps[_currentStep];

  /// هل هذه أول خطوة؟
  bool get isFirstStep => _currentStep == 0;

  /// هل هذه آخر خطوة؟
  bool get isLastStep => _currentStep == totalSteps - 1;

  /// بدء التعليمات
  void start() {
    _currentStep = 0;
    _isShowing = true;
    notifyListeners();
  }

  /// الانتقال للخطوة التالية
  void next() {
    if (!isLastStep) {
      _currentStep++;
      notifyListeners();
    } else {
      complete();
    }
  }

  /// العودة للخطوة السابقة
  void previous() {
    if (!isFirstStep) {
      _currentStep--;
      notifyListeners();
    }
  }

  /// تخطي التعليمات
  void skip() {
    _isShowing = false;
    notifyListeners();
  }

  /// إكمال التعليمات
  Future<void> complete() async {
    await _storage.markScreenCompleted(config.screenId);
    _isShowing = false;
    notifyListeners();
  }

  /// عدم الإظهار مرة أخرى
  Future<void> neverShowAgain() async {
    await _storage.setNeverShowAgain(true);
    _isShowing = false;
    notifyListeners();
  }

  /// إعادة تعيين
  void reset() {
    _currentStep = 0;
    _isShowing = false;
    notifyListeners();
  }
}
```

---

## 4. المكونات (Widgets)

### 4.1 TutorialOverlay

```dart
/// Overlay الرئيسي للتعليمات
class TutorialOverlay extends StatefulWidget {
  final TutorialController controller;
  final Widget child;

  const TutorialOverlay({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.durationNormal,
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.curveEaseInOut,
    );

    widget.controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (widget.controller.isShowing) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.controller.isShowing)
          FadeTransition(
            opacity: _fadeAnimation,
            child: _buildOverlay(),
          ),
      ],
    );
  }

  Widget _buildOverlay() {
    final step = widget.controller.currentStepData;

    return Stack(
      children: [
        // خلفية شبه شفافة
        Container(
          color: Colors.black.withOpacity(0.7),
        ),

        // تسليط الضوء على العنصر
        if (step.targetKey != null)
          TutorialSpotlight(targetKey: step.targetKey!),

        // بطاقة النصيحة
        TutorialTooltip(
          step: step,
          currentStep: widget.controller.currentStep + 1,
          totalSteps: widget.controller.totalSteps,
        ),

        // أزرار التحكم
        Positioned(
          bottom: AppSpacing.xl,
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          child: TutorialControls(
            controller: widget.controller,
          ),
        ),
      ],
    );
  }
}
```

### 4.2 TutorialTooltip

```dart
/// بطاقة النصيحة
class TutorialTooltip extends StatelessWidget {
  final TutorialStep step;
  final int currentStep;
  final int totalSteps;

  const TutorialTooltip({
    super.key,
    required this.step,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _calculateTop(context),
      left: AppSpacing.lg,
      right: AppSpacing.lg,
      child: AppCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان مع الأيقونة
              Row(
                children: [
                  if (step.icon != null) ...[
                    Icon(
                      step.icon,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Expanded(
                    child: Text(
                      step.title,
                      style: const TextStyle(
                        fontSize: AppTypography.titleMedium,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // الوصف
              Text(
                step.description,
                style: const TextStyle(
                  fontSize: AppTypography.bodyMedium,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // رقم الخطوة
              Center(
                child: Text(
                  '$currentStep / $totalSteps',
                  style: TextStyle(
                    fontSize: AppTypography.bodySmall,
                    color: AppColors.textSecondary.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateTop(BuildContext context) {
    // حساب الموضع بناءً على targetKey
    // سيتم تطبيقه في المرحلة التالية
    return MediaQuery.of(context).size.height * 0.3;
  }
}
```

### 4.3 TutorialControls

```dart
/// أزرار التحكم في التعليمات
class TutorialControls extends StatelessWidget {
  final TutorialController controller;

  const TutorialControls({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // زر السابق
        if (!controller.isFirstStep)
          AppSecondaryButton(
            label: 'السابق',
            onPressed: controller.previous,
            icon: Icons.arrow_back,
          )
        else
          const SizedBox(width: 100),

        // زر تخطي
        TextButton(
          onPressed: () => _showSkipDialog(context),
          child: const Text(
            'تخطي',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppTypography.bodyMedium,
            ),
          ),
        ),

        // زر التالي/إنهاء
        AppPrimaryButton(
          label: controller.isLastStep ? 'إنهاء' : 'التالي',
          onPressed: controller.next,
          icon: controller.isLastStep ? Icons.check : Icons.arrow_forward,
        ),
      ],
    );
  }

  Future<void> _showSkipDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تخطي التعليمات'),
        content: const Text(
          'هل تريد تخطي التعليمات؟\n\n'
          'يمكنك إعادة عرضها لاحقاً من الإعدادات.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'skip'),
            child: const Text('تخطي'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'never'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('عدم الإظهار مرة أخرى'),
          ),
        ],
      ),
    );

    if (result == 'skip') {
      controller.skip();
    } else if (result == 'never') {
      await controller.neverShowAgain();
    }
  }
}
```

---

## 5. بيانات التعليمات

### 5.1 Dashboard Tutorial

```dart
final dashboardTutorial = TutorialConfig(
  screenId: 'dashboard',
  welcomeMessage: 'مرحباً بك في بصير! دعنا نأخذ جولة سريعة.',
  completionMessage: 'رائع! الآن أنت جاهز للبدء.',
  steps: [
    TutorialStep(
      id: 'dashboard_welcome',
      title: 'مرحباً بك في بصير',
      description: 'بصير هو نظام متكامل لإدارة الفواتير والعملاء. '
          'سنساعدك على فهم كيفية استخدامه.',
      icon: Icons.waving_hand,
      position: TooltipPosition.center,
    ),
    TutorialStep(
      id: 'dashboard_stats',
      title: 'بطاقات الإحصائيات',
      description: 'هنا يمكنك رؤية ملخص سريع لفواتيرك وعملائك.',
      icon: Icons.analytics,
      // targetKey: statsCardsKey,
    ),
    TutorialStep(
      id: 'dashboard_quick_actions',
      title: 'الإجراءات السريعة',
      description: 'استخدم هذه الأزرار لإضافة فاتورة أو عميل جديد بسرعة.',
      icon: Icons.flash_on,
      // targetKey: quickActionsKey,
    ),
    TutorialStep(
      id: 'dashboard_navigation',
      title: 'شريط التنقل',
      description: 'استخدم شريط التنقل السفلي للانتقال بين الشاشات المختلفة.',
      icon: Icons.navigation,
      // targetKey: bottomNavKey,
    ),
  ],
);
```

---

## 6. الاستخدام

### 6.1 في الشاشة

```dart
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late TutorialController _tutorialController;

  @override
  void initState() {
    super.initState();

    final storage = ref.read(tutorialStorageProvider);
    _tutorialController = TutorialController(
      storage: storage,
      config: dashboardTutorial,
    );

    // عرض التعليمات إذا لزم الأمر
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (storage.shouldShowForScreen('dashboard')) {
        _tutorialController.start();
      }
    });
  }

  @override
  void dispose() {
    _tutorialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TutorialOverlay(
      controller: _tutorialController,
      child: Scaffold(
        // ... محتوى الشاشة
      ),
    );
  }
}
```

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 3 ديسمبر 2025  
**الحالة:** ✅ معتمد للتنفيذ
