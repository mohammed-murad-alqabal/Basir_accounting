---
id: "accessibility-standards"
title: "معايير إمكانية الوصول (Accessibility Standards)"
version: "1.0"
last_updated: "2025-12-25"
author: "فريق بصير"
compliance: "WCAG 2.1 AA"
---

# معايير إمكانية الوصول في Flutter

## 1. استخدام Semantics

تعتمد قارئات الشاشة (TalkBack/VoiceOver) على شجرة الـ Semantics.

```dart
// ✅ صحيح
Semantics(
  label: 'زر الإرسال',
  hint: 'انقر لإرسال النموذج',
  button: true,
  enabled: true,
  child: MyCustomButton(),
)

// ❌ خطأ (بدون معلومات)
MyCustomButton()
```

### استبعاد العناصر الزخرفية

استخدم `excludeSemantics: true` للعناصر التي لا تضيف قيمة للمستخدم (مثل الأيقونات التجميلية).

## 2. حجم النص (Text Scaling)

تأكد من أن النصوص قابلة للتكبير دون كسر التصميم.

```dart
// ✅ صحيح - السماح بالتكبير
Text('مرحباً بك', style: TextStyle(fontSize: 16))

// ❌ خطأ - حجم ثابت (textScaleFactor deprecated)
Text('مرحباً بك', textScaler: TextScaler.noScaling)
```

## 3. التباين (Color Contrast)

يجب أن تكون نسبة التباين 4.5:1 للنصوص العادية و 3:1 للنصوص الكبيرة.

- استخدم `ThemeData` الموحدة لضمان ألوان صحيحة.
- تجنب استخدام نصوص رمادية فاتحة على خلفية بيضاء.

## 4. حجم العناصر التفاعلية (Touch Targets)

يجب أن يكون حجم أي عنصر قابل للنقر 48x48 dp على الأقل.

```dart
// ✅ صحيح
SizedBox(
  width: 48,
  height: 48,
  child: IconButton(icon: Icon(Icons.add), onPressed: () {}),
)

// ❌ خطأ (صغير جداً)
Container(
  width: 30,
  height: 30,
  child: InkWell(onTap: () {}),
)
```

## 5. دعم قارئات الشاشة (Order & Focus)

تأكد من ترتيب العناصر منطقياً عند التنقل بـ Swipe.

```dart
MergeSemantics(
  child: Column(
    children: [
      Text('العنوان'),
      Text('الوصف'),
    ],
  ),
)
```
