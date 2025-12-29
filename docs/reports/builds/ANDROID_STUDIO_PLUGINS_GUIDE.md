# دليل تثبيت Android Studio Plugins

**المشروع:** بصير MVP  
**التاريخ:** 4 ديسمبر 2025  
**المنفذ:** فريق وكلاء تطوير مشروع بصير  
**النوع:** دليل تفصيلي  
**الحالة:** ✅ جاهز للتنفيذ

---

## 🎯 الهدف

تثبيت Flutter و Dart Plugins في Android Studio لتحسين تجربة التطوير.

---

## 📋 المتطلبات

- ✅ Android Studio مثبت (2025.1.3) ✓
- ✅ Flutter SDK مثبت (3.35.5) ✓
- ✅ اتصال بالإنترنت

---

## 🚀 الطريقة 1: التثبيت من Marketplace (موصى بها)

### الخطوات التفصيلية

#### 1. فتح Android Studio

```bash
# من Terminal
android-studio &

# أو من قائمة التطبيقات
# Applications → Development → Android Studio
```

#### 2. الوصول إلى إعدادات Plugins

**الطريقة الأولى:**

- اضغط على `File` في القائمة العلوية
- اختر `Settings` (أو اضغط `Ctrl+Alt+S`)

**الطريقة الثانية:**

- من شاشة الترحيب (Welcome Screen)
- اضغط على أيقونة الترس ⚙️ في الأسفل
- اختر `Plugins`

#### 3. البحث عن Flutter Plugin

1. في نافذة Settings، اختر `Plugins` من القائمة اليسرى
2. اضغط على تبويب `Marketplace` في الأعلى
3. في مربع البحث، اكتب: `Flutter`
4. ستظهر نتيجة: **Flutter** by flutter.io

#### 4. تثبيت Flutter Plugin

1. اضغط على زر `Install` بجانب Flutter Plugin
2. سيبدأ التحميل (حجم ~50-100 MB)
3. انتظر حتى يكتمل التحميل

#### 5. تثبيت Dart Plugin (تلقائي)

- عند تثبيت Flutter Plugin، سيظهر تنبيه:
  ```
  Flutter plugin requires Dart plugin to be installed.
  Would you like to install it?
  ```
- اضغط على `Yes` أو `Install`
- سيتم تثبيت Dart Plugin تلقائياً

#### 6. إعادة تشغيل Android Studio

1. بعد اكتمال التثبيت، سيظهر زر `Restart IDE`
2. اضغط على `Restart IDE`
3. انتظر حتى يعيد Android Studio التشغيل

---

## ✅ التحقق من التثبيت

### بعد إعادة التشغيل

#### 1. التحقق من Plugins

1. افتح `File` → `Settings` → `Plugins`
2. اختر تبويب `Installed`
3. يجب أن ترى:
   - ✅ **Flutter** (مع علامة ✓ خضراء)
   - ✅ **Dart** (مع علامة ✓ خضراء)

#### 2. التحقق من Flutter SDK

1. افتح `File` → `Settings`
2. اختر `Languages & Frameworks` → `Flutter`
3. يجب أن ترى:
   - Flutter SDK path: `/home/m/snap/flutter/common/flutter`
   - أو المسار الصحيح لديك

#### 3. اختبار الميزات الجديدة

**ميزات Flutter في Android Studio:**

1. **Flutter Commands:**

   - `Tools` → `Flutter` → `Flutter Doctor`
   - `Tools` → `Flutter` → `Flutter Upgrade`
   - `Tools` → `Flutter` → `Flutter Clean`

2. **Hot Reload:**

   - عند تشغيل التطبيق، ستظهر أيقونات:
   - ⚡ Hot Reload (Ctrl+\)
   - 🔄 Hot Restart (Ctrl+Shift+\)

3. **Widget Inspector:**

   - عند تشغيل التطبيق في Debug mode
   - ستظهر نافذة Flutter Inspector
   - يمكنك فحص Widget tree

4. **Dart Analysis:**
   - تحليل الكود في الوقت الفعلي
   - اقتراحات تلقائية
   - إصلاحات سريعة (Quick Fixes)

---

## 🎨 الطريقة 2: التثبيت اليدوي (متقدمة)

### إذا فشلت الطريقة الأولى

#### 1. تحميل Plugins يدوياً

**Flutter Plugin:**

- الرابط: https://plugins.jetbrains.com/plugin/9212-flutter
- اضغط على `Versions`
- اختر إصدار متوافق مع Android Studio 2025.1
- اضغط على `Download`

**Dart Plugin:**

- الرابط: https://plugins.jetbrains.com/plugin/6351-dart
- اضغط على `Versions`
- اختر إصدار متوافق
- اضغط على `Download`

#### 2. تثبيت من ملف ZIP

1. افتح `File` → `Settings` → `Plugins`
2. اضغط على أيقونة الترس ⚙️ في الأعلى
3. اختر `Install Plugin from Disk...`
4. اختر ملف ZIP الذي حملته
5. اضغط على `OK`
6. كرر للـ Plugin الثاني
7. اضغط على `Restart IDE`

---

## 🔧 حل المشاكل الشائعة

### المشكلة 1: لا يظهر Flutter في Marketplace

**الحل:**

1. تحقق من اتصال الإنترنت
2. جرب إعادة تشغيل Android Studio
3. جرب تحديث قائمة Plugins:
   - `File` → `Settings` → `Plugins`
   - أيقونة الترس ⚙️ → `Manage Plugin Repositories...`
   - تأكد من وجود: `https://plugins.jetbrains.com`

### المشكلة 2: فشل التثبيت

**الحل:**

1. تحقق من المساحة المتاحة (يحتاج ~200 MB)
2. تحقق من صلاحيات الكتابة في مجلد Plugins
3. جرب الطريقة اليدوية (الطريقة 2)

### المشكلة 3: Flutter SDK غير معروف

**الحل:**

1. افتح `File` → `Settings` → `Languages & Frameworks` → `Flutter`
2. اضغط على `...` بجانب Flutter SDK path
3. اختر مسار Flutter SDK:
   ```
   /home/m/snap/flutter/common/flutter
   ```
4. اضغط على `OK`

### المشكلة 4: Dart Plugin لم يُثبت تلقائياً

**الحل:**

1. افتح `File` → `Settings` → `Plugins`
2. ابحث عن `Dart` في Marketplace
3. ثبّته يدوياً
4. أعد تشغيل Android Studio

---

## 📊 مقارنة: VS Code vs Android Studio

### VS Code (الحالي)

**المميزات:**

- ✅ خفيف وسريع
- ✅ استهلاك ذاكرة أقل
- ✅ Extensions ممتازة
- ✅ يعمل بشكل مثالي حالياً

**العيوب:**

- ❌ Widget Inspector أقل قوة
- ❌ Refactoring tools أقل
- ❌ UI Designer غير متوفر

### Android Studio (بعد تثبيت Plugins)

**المميزات:**

- ✅ Widget Inspector قوي جداً
- ✅ Refactoring tools متقدمة
- ✅ UI Designer مدمج
- ✅ Android Emulator مدمج
- ✅ Profiling tools قوية

**العيوب:**

- ❌ أثقل وأبطأ
- ❌ استهلاك ذاكرة أعلى (2-4 GB)
- ❌ وقت بدء أطول

---

## 💡 التوصيات

### متى تستخدم Android Studio؟

استخدم Android Studio إذا:

- ✅ تحتاج Widget Inspector قوي
- ✅ تعمل على UI معقدة
- ✅ تحتاج Refactoring متقدم
- ✅ تعمل على Android بشكل أساسي
- ✅ لديك ذاكرة كافية (8GB+)

### متى تستخدم VS Code؟

استخدم VS Code إذا:

- ✅ تحتاج محرر خفيف وسريع
- ✅ تعمل على أكثر من لغة/framework
- ✅ ذاكرة محدودة (< 8GB)
- ✅ تفضل البساطة والسرعة
- ✅ تعمل على Web/Desktop أيضاً

### التوصية للمشروع الحالي

**🎯 استخدم كلاهما:**

- **VS Code** للتطوير اليومي (سريع وخفيف)
- **Android Studio** للمهام المتقدمة:
  - تصميم UI معقدة
  - Profiling وتحليل الأداء
  - Debugging متقدم
  - Android-specific features

---

## 📈 الفوائد المتوقعة

### بعد تثبيت Plugins

**تحسينات الإنتاجية:**

- ⚡ Hot Reload أسرع
- 🔍 Widget Inspector متقدم
- 🛠️ Refactoring tools قوية
- 📊 Performance profiling
- 🎨 UI Designer مدمج

**تحسينات الجودة:**

- ✅ Dart analysis في الوقت الفعلي
- ✅ اقتراحات أفضل
- ✅ اكتشاف أخطاء أسرع
- ✅ Code completion أقوى

**الوقت المتوقع للتوفير:**

- 📉 تقليل وقت Debugging: 20-30%
- 📉 تقليل وقت UI Development: 15-25%
- 📉 تقليل وقت Refactoring: 30-40%

---

## ⏱️ الوقت المطلوب

### التثبيت

| الخطوة             |  الوقت المقدر   |
| :----------------- | :-------------: |
| فتح Android Studio |    1-2 دقيقة    |
| البحث والتثبيت     |   5-10 دقائق    |
| إعادة التشغيل      |    1-2 دقيقة    |
| التحقق والإعداد    |    2-3 دقائق    |
| **الإجمالي**       | **10-17 دقيقة** |

### التعلم والتكيف

| المرحلة            | الوقت المقدر |
| :----------------- | :----------: |
| استكشاف الميزات    | 15-30 دقيقة  |
| التعود على الواجهة |   1-2 ساعة   |
| الإتقان الكامل     |   1-2 يوم    |

---

## 🎯 الخطوات التالية

### بعد التثبيت

1. **افتح المشروع:**

   ```bash
   # من Terminal
   cd ~/Projects/Basser_MVP
   android-studio .
   ```

2. **جرب Hot Reload:**

   - شغّل التطبيق (Shift+F10)
   - عدّل أي widget
   - اضغط Ctrl+\ للـ Hot Reload

3. **استكشف Widget Inspector:**

   - شغّل التطبيق في Debug mode
   - افتح Flutter Inspector
   - استكشف Widget tree

4. **جرب Refactoring:**
   - اختر أي widget
   - اضغط Ctrl+Alt+Shift+T
   - جرب Extract Widget

---

## 📚 الموارد المفيدة

### الوثائق الرسمية

- [Flutter in Android Studio](https://docs.flutter.dev/tools/android-studio)
- [Dart Plugin Documentation](https://plugins.jetbrains.com/plugin/6351-dart)
- [Flutter Plugin Documentation](https://plugins.jetbrains.com/plugin/9212-flutter)

### الفيديوهات التعليمية

- [Android Studio for Flutter](https://www.youtube.com/watch?v=X0Vl_Do_yQA)
- [Flutter Widget Inspector](https://www.youtube.com/watch?v=JIcmJNT9DNI)

### الاختصارات المفيدة

| الاختصار           | الوظيفة         |
| :----------------- | :-------------- |
| `Ctrl+\`           | Hot Reload      |
| `Ctrl+Shift+\`     | Hot Restart     |
| `Shift+F10`        | Run             |
| `Shift+F9`         | Debug           |
| `Ctrl+Alt+Shift+T` | Refactor Menu   |
| `Alt+Enter`        | Quick Fix       |
| `Ctrl+Space`       | Code Completion |

---

## ✅ قائمة التحقق

### قبل التثبيت

- [ ] Android Studio مفتوح
- [ ] اتصال إنترنت نشط
- [ ] مساحة كافية (~200 MB)

### أثناء التثبيت

- [ ] فتح Settings → Plugins
- [ ] البحث عن Flutter
- [ ] تثبيت Flutter Plugin
- [ ] تثبيت Dart Plugin (تلقائي)
- [ ] إعادة تشغيل IDE

### بعد التثبيت

- [ ] التحقق من Plugins في Installed
- [ ] تعيين Flutter SDK path
- [ ] اختبار Hot Reload
- [ ] اختبار Widget Inspector
- [ ] استكشاف الميزات الجديدة

---

## 🎉 الخلاصة

### ما ستحصل عليه

✅ **Flutter Plugin** - ميزات Flutter كاملة  
✅ **Dart Plugin** - تحليل Dart متقدم  
✅ **Hot Reload** - تطوير أسرع  
✅ **Widget Inspector** - debugging أفضل  
✅ **Refactoring Tools** - كود أنظف

### الوقت المطلوب

⏱️ **10-17 دقيقة** للتثبيت  
⏱️ **1-2 ساعة** للتعود  
⏱️ **1-2 يوم** للإتقان

### التوصية النهائية

**🎯 ثبّت الـ Plugins إذا:**

- تستخدم Android Studio بشكل أساسي
- تحتاج ميزات متقدمة
- لديك ذاكرة كافية (8GB+)

**🎯 استمر مع VS Code إذا:**

- راضٍ عن الأداء الحالي
- تفضل البساطة والسرعة
- ذاكرة محدودة

**كلا الخيارين ممتاز!** 🚀

---

**تم إعداد الدليل بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 4 ديسمبر 2025  
**الإصدار:** 1.0  
**الحالة:** ✅ جاهز للتنفيذ

**📖 اتبع الخطوات وستكون جاهزاً في 15 دقيقة!**
