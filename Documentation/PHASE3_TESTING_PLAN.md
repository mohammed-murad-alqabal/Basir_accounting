# خطة المرحلة 3: الاختبار والتحقق

**المشروع:** بصير MVP  
**التاريخ:** 5 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**المرحلة:** 3 من 4 (الاختبار والتحقق)  
**الحالة:** 📋 جاهز للتنفيذ

---

## 🎯 الأهداف

### الهدف الرئيسي

التحقق من أن `AppEnhancedButton` يعمل بشكل صحيح على جميع المنصات (Android/iOS/Web) وفي جميع الحالات، مع عدم وجود أي قص للنصوص.

### الأهداف الفرعية

1. ✅ إنشاء أداة اختبار textScaleFactor تفاعلية
2. ✅ اختبار شامل على Android (جهاز حقيقي)
3. ✅ اختبار على iOS (محاكي أو جهاز)
4. ✅ اختبار على Web (متصفح)
5. ✅ التحقق من عدم وجود RenderFlex overflow
6. ✅ توثيق جميع النتائج والمشاكل

---

## 📋 المهام التفصيلية

### المهمة 1: إنشاء TextScaleFactorTester Widget

**الهدف:** أداة تفاعلية لاختبار الأزرار مع textScaleFactor مختلفة

**الملف:** `lib/core/widgets/text_scale_factor_tester.dart`

**المتطلبات:**

```dart
/// أداة لاختبار الأزرار مع textScaleFactor مختلفة
class TextScaleFactorTester extends StatefulWidget {
  final Widget child;
  final bool showControls;

  const TextScaleFactorTester({
    Key? key,
    required this.child,
    this.showControls = true,
  }) : super(key: key);

  @override
  State<TextScaleFactorTester> createState() => _TextScaleFactorTesterState();
}

class _TextScaleFactorTesterState extends State<TextScaleFactorTester> {
  double _textScaleFactor = 1.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // شريط التحكم (يظهر فقط في debug mode)
        if (widget.showControls && kDebugMode)
          _buildControlBar(),

        // المحتوى مع textScaleFactor المخصص
        Expanded(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: _textScaleFactor,
            ),
            child: widget.child,
          ),
        ),
      ],
    );
  }

  Widget _buildControlBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.amber.withOpacity(0.2),
      child: Column(
        children: [
          Text(
            'Text Scale Factor: ${_textScaleFactor.toStringAsFixed(1)}x',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Slider(
            value: _textScaleFactor,
            min: 1.0,
            max: 2.0,
            divisions: 10,
            label: '${_textScaleFactor.toStringAsFixed(1)}x',
            onChanged: (value) {
              setState(() => _textScaleFactor = value);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPresetButton('1.0x', 1.0),
              _buildPresetButton('1.2x', 1.2),
              _buildPresetButton('1.5x', 1.5),
              _buildPresetButton('1.8x', 1.8),
              _buildPresetButton('2.0x', 2.0),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetButton(String label, double value) {
    return ElevatedButton(
      onPressed: () {
        setState(() => _textScaleFactor = value);
      },
      child: Text(label),
    );
  }
}
```

**الاختبارات:**

- ✅ اختبار عرض شريط التحكم
- ✅ اختبار تغيير textScaleFactor
- ✅ اختبار الأزرار المسبقة

**الوقت المقدر:** 1-2 ساعة

---

### المهمة 2: إنشاء شاشة اختبار شاملة

**الهدف:** شاشة تحتوي على جميع أنواع الأزرار للاختبار

**الملف:** `lib/features/testing/button_test_screen.dart`

**المتطلبات:**

```dart
class ButtonTestScreen extends StatelessWidget {
  const ButtonTestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختبار الأزرار'),
      ),
      body: TextScaleFactorTester(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // قسم: أزرار Primary
              _buildSection(
                title: 'أزرار Primary',
                children: [
                  AppEnhancedButton(
                    text: 'نص قصير',
                    onPressed: () {},
                    type: AppEnhancedButtonType.primary,
                  ),
                  const SizedBox(height: 8),
                  AppEnhancedButton(
                    text: 'نص متوسط الطول للاختبار',
                    onPressed: () {},
                    type: AppEnhancedButtonType.primary,
                  ),
                  const SizedBox(height: 8),
                  AppEnhancedButton(
                    text: 'نص طويل جداً جداً جداً قد يسبب مشاكل في العرض',
                    onPressed: () {},
                    type: AppEnhancedButtonType.primary,
                  ),
                  const SizedBox(height: 8),
                  AppEnhancedButton(
                    text: 'مع أيقونة',
                    icon: Icons.add,
                    onPressed: () {},
                    type: AppEnhancedButtonType.primary,
                  ),
                  const SizedBox(height: 8),
                  AppEnhancedButton(
                    text: 'معطل',
                    onPressed: null,
                    type: AppEnhancedButtonType.primary,
                  ),
                  const SizedBox(height: 8),
                  AppEnhancedButton(
                    text: 'تحميل',
                    onPressed: () {},
                    isLoading: true,
                    type: AppEnhancedButtonType.primary,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // قسم: أزرار Secondary
              _buildSection(
                title: 'أزرار Secondary',
                children: [
                  // نفس الأزرار بنوع secondary
                ],
              ),

              const SizedBox(height: 24),

              // قسم: أزرار Text
              _buildSection(
                title: 'أزرار Text',
                children: [
                  // نفس الأزرار بنوع text
                ],
              ),

              const SizedBox(height: 24),

              // قسم: أزرار في Row
              _buildSection(
                title: 'أزرار في Row',
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppEnhancedButton(
                          text: 'إلغاء',
                          onPressed: () {},
                          type: AppEnhancedButtonType.secondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppEnhancedButton(
                          text: 'موافق',
                          onPressed: () {},
                          type: AppEnhancedButtonType.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}
```

**الوقت المقدر:** 1 ساعة

---

### المهمة 3: الاختبار على Android

**الهدف:** اختبار شامل على جهاز Android حقيقي

**الجهاز:** U693CL (Android 9 - API 28)

**خطوات الاختبار:**

#### 3.1 الإعداد

```bash
# 1. توصيل الجهاز
adb devices

# 2. بناء وتثبيت التطبيق
flutter build apk --release
flutter install
```

#### 3.2 الاختبارات الأساسية

**الاختبار 1: عرض الأزرار**

- [ ] جميع أنواع الأزرار تظهر بشكل صحيح
- [ ] النصوص واضحة وقابلة للقراءة
- [ ] الألوان صحيحة
- [ ] الأيقونات تظهر بشكل صحيح

**الاختبار 2: التفاعل**

- [ ] الأزرار تستجيب للنقر
- [ ] ripple effect يعمل
- [ ] الأزرار المعطلة لا تستجيب
- [ ] حالة التحميل تعمل

**الاختبار 3: النصوص الطويلة**

- [ ] النصوص الطويلة تظهر كاملة
- [ ] لا يوجد قص أفقي
- [ ] لا يوجد قص عمودي
- [ ] التفاف النص يعمل بشكل صحيح

**الاختبار 4: textScaleFactor**

- [ ] 1.0x - يعمل بشكل صحيح
- [ ] 1.2x - يعمل بشكل صحيح
- [ ] 1.5x - يعمل بشكل صحيح
- [ ] 1.8x - يعمل بشكل صحيح
- [ ] 2.0x - يعمل بشكل صحيح

**الاختبار 5: RTL**

- [ ] النصوص العربية محاذاة صحيحة
- [ ] الأيقونات في الموضع الصحيح
- [ ] التخطيط RTL يعمل

**الاختبار 6: الأزرار في Row**

- [ ] الأزرار تتوزع بشكل صحيح
- [ ] لا يوجد overflow
- [ ] Expanded يعمل بشكل صحيح

#### 3.3 فحص DevTools

```bash
# تشغيل DevTools
flutter pub global activate devtools
flutter pub global run devtools

# فتح التطبيق في DevTools
# التحقق من:
# - لا توجد تحذيرات RenderFlex overflow
# - الأداء جيد (60fps)
# - لا توجد memory leaks
```

**الوقت المقدر:** 2-3 ساعات

---

### المهمة 4: الاختبار على iOS

**الهدف:** التحقق من الاتساق مع Android

**الجهاز:** محاكي iOS أو جهاز حقيقي

**خطوات الاختبار:**

#### 4.1 الإعداد

```bash
# 1. فتح محاكي iOS
open -a Simulator

# 2. بناء وتشغيل التطبيق
flutter run -d ios
```

#### 4.2 الاختبارات

**نفس الاختبارات من المهمة 3**

**التركيز على:**

- [ ] الاتساق مع Android
- [ ] خط Cairo يعمل بشكل صحيح
- [ ] لا اختلافات في العرض
- [ ] الأداء مماثل

**الوقت المقدر:** 1-2 ساعة

---

### المهمة 5: الاختبار على Web

**الهدف:** التحقق من العمل على المتصفحات

**المتصفحات:** Chrome, Firefox, Safari

**خطوات الاختبار:**

#### 5.1 الإعداد

```bash
# بناء وتشغيل على Web
flutter run -d chrome
```

#### 5.2 الاختبارات

**نفس الاختبارات من المهمة 3**

**التركيز على:**

- [ ] خط Cairo يتم تحميله بشكل صحيح
- [ ] fallback يعمل إذا فشل التحميل
- [ ] الأداء مقبول
- [ ] لا مشاكل في العرض

**الوقت المقدر:** 1 ساعة

---

### المهمة 6: التوثيق

**الهدف:** توثيق جميع النتائج والمشاكل

**الملف:** `Documentation/PHASE3_TESTING_RESULTS.md`

**المحتوى المطلوب:**

```markdown
# نتائج المرحلة 3: الاختبار والتحقق

## ملخص النتائج

### Android

- ✅/❌ جميع الاختبارات
- المشاكل المكتشفة
- لقطات الشاشة

### iOS

- ✅/❌ جميع الاختبارات
- المشاكل المكتشفة
- لقطات الشاشة

### Web

- ✅/❌ جميع الاختبارات
- المشاكل المكتشفة
- لقطات الشاشة

## التحليل

### نقاط القوة

- ...

### نقاط الضعف

- ...

### المشاكل الحرجة

- ...

### المشاكل غير الحرجة

- ...

## التوصيات

### للمرحلة 4

- ...

### للمستقبل

- ...
```

**الوقت المقدر:** 2 ساعة

---

## 📊 جدول التنفيذ

| المهمة                       | الوقت المقدر  | الأولوية | الحالة |
| :--------------------------- | :-----------: | :------: | :----: |
| **1. TextScaleFactorTester** |   1-2 ساعة    |  عالية   |   📋   |
| **2. شاشة الاختبار**         |    1 ساعة     |  عالية   |   📋   |
| **3. اختبار Android**        |   2-3 ساعات   |   حرجة   |   📋   |
| **4. اختبار iOS**            |   1-2 ساعة    |  متوسطة  |   📋   |
| **5. اختبار Web**            |    1 ساعة     |  منخفضة  |   📋   |
| **6. التوثيق**               |    2 ساعة     |  عالية   |   📋   |
| **الإجمالي**                 | **8-11 ساعة** |    -     | **0%** |

---

## ✅ معايير النجاح

### معايير إلزامية

- [ ] **0 حالات قص** في جميع الأزرار على جميع المنصات
- [ ] **0 تحذيرات RenderFlex overflow** في DevTools
- [ ] **100% عرض كامل** عند textScaleFactor 1.0-2.0
- [ ] **الأداء ≥ 58fps** على جميع المنصات
- [ ] **الاتساق 100%** بين Android/iOS/Web

### معايير مرغوبة

- [ ] **خط Cairo يعمل** على جميع المنصات
- [ ] **fallback يعمل** بشكل سلس
- [ ] **لا مشاكل في RTL** على أي منصة
- [ ] **الأيقونات تعمل** بشكل صحيح
- [ ] **حالة التحميل واضحة** على جميع المنصات

---

## 🔧 الأدوات المطلوبة

### أدوات التطوير

- ✅ Flutter SDK 3.24.0+
- ✅ Android Studio / VS Code
- ✅ Xcode (للـ iOS)
- ✅ Chrome DevTools

### أدوات الاختبار

- ✅ Flutter DevTools
- ✅ Android Debug Bridge (adb)
- ✅ iOS Simulator
- ✅ Chrome Browser

### أدوات التوثيق

- ✅ Screenshot tools
- ✅ Screen recording tools
- ✅ Markdown editor

---

## 📝 قائمة التحقق

### قبل البدء

- [ ] قراءة تقرير المرحلة 2
- [ ] فهم AppEnhancedButton
- [ ] تحضير الأجهزة
- [ ] تحضير الأدوات

### أثناء التنفيذ

- [ ] اتباع الخطوات بالترتيب
- [ ] توثيق كل مشكلة
- [ ] أخذ لقطات شاشة
- [ ] تسجيل الملاحظات

### بعد الانتهاء

- [ ] مراجعة جميع النتائج
- [ ] كتابة التقرير النهائي
- [ ] تحديث CHANGELOG
- [ ] الاستعداد للمرحلة 4

---

## 🚨 المشاكل المتوقعة والحلول

### مشكلة 1: خط Cairo لا يتم تحميله على Web

**الحل:**

- التحقق من `pubspec.yaml`
- التحقق من مسار الخط
- استخدام fallback

### مشكلة 2: اختلافات في العرض بين المنصات

**الحل:**

- استخدام AppFontMetrics
- ضبط line-height
- اختبار على جميع المنصات

### مشكلة 3: أداء بطيء على Web

**الحل:**

- تحسين الكود
- استخدام const constructors
- تقليل rebuilds

---

## 📞 الدعم والمساعدة

**للمساعدة:**

- راجع `Documentation/PHASE2_ENHANCED_BUTTON_REPORT.md`
- راجع `lib/core/widgets/app_enhanced_button.dart`
- راجع `test/widget/core/widgets/app_enhanced_button_test.dart`

**للأسئلة:**

- راجع `.kiro/specs/ui-ux-improvements/`
- راجع `Documentation/UI_UX_IMPROVEMENTS_PROGRESS.md`

---

**تم إعداد الخطة بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 5 ديسمبر 2025  
**الإصدار:** 1.0  
**الحالة:** 📋 جاهز للتنفيذ
