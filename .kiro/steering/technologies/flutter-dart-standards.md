---
title: "Flutter/Dart Standards for Baseer MVP"
inclusion: fileMatch
fileMatchPattern: "*.dart"
version: "2.0"
kiro_compliance: "100%"
last_updated: "2025-12-15"
author: "فريق وكلاء تطوير مشروع بصير"
category: "flutter-dart-standards"
priority: "high"
dependencies: ["development-standards.md"]
target_audience: ["flutter-developers", "dart-developers"]
flutter_version: "3.35.5+"
dart_version: "3.9.2+"
---

**المشروع:** بصير MVP
**المؤلف:** فريق وكلاء تطوير مشروع بصير
**المصدر:** مكيف من مصادر مجتمع Kiro المعتمدة
**التاريخ:** 15 ديسمبر 2025  
**آخر تحديث:** 15 ديسمبر 2025 - تحديث لـ Flutter 3.35.5+ و Dart 3.9.2+

---

# معايير Flutter/Dart للمشروع

## معايير Dart 3.9.2+ (2025)

### التنسيق والأسلوب المحدث

- استخدم `dart format` مع `--line-length=100` (محدث من 80)
- اتبع `effective_dart` guidelines الإصدار 2025
- استخدم `const` constructors حيثما أمكن
- استخدم `final` للمتغيرات غير القابلة للتغيير
- **جديد**: استخدم `sealed classes` للـ pattern matching
- **جديد**: استخدم `extension types` للأداء المحسن
- **جديد**: استخدم `class modifiers` (base, interface, final, sealed)

### ميزات Dart 3.9.2+ الجديدة

- **Pattern Matching**: استخدم `switch expressions` المحسنة
- **Records**: استخدم `records` للبيانات المؤقتة
- **Destructuring**: استخدم `destructuring assignments`
- **Null Safety**: تطبيق كامل لـ sound null safety

### التسمية

- Classes: PascalCase (`CustomerRepository`)
- Functions/Variables: camelCase (`getAllCustomers`)
- Constants: lowerCamelCase (`maxRetries`)
- Private members: underscore prefix (`_privateMethod`)

## معايير Flutter 3.35.5+ (2025)

### البنية والتنظيم المحدثة

- اتبع Clean Architecture (3 layers) مع **Domain-Driven Design**
- استخدم feature-first organization مع **modular architecture**
- فصل UI عن Business Logic باستخدام **MVVM pattern**
- **جديد**: استخدم **Impeller rendering engine** (افتراضي)
- **جديد**: تطبيق **Material Design 3.0** كاملاً
- **جديد**: استخدام **Web Assembly** للأداء المحسن

### ميزات Flutter 3.35.5+ الجديدة

- **Element Tree Optimization**: تحسينات أداء الـ widget tree
- **Advanced Animations**: استخدم `AnimationController` المحسن
- **Accessibility Enhancements**: تحسينات إمكانية الوصول
- **Platform Integration**: تكامل أفضل مع المنصات المختلفة

### إدارة الحالة

- استخدم Riverpod كمزود رئيسي للحالة
- تجنب setState في الويدجت المعقدة
- استخدم StateNotifier للحالات المعقدة

### الأداء

- استخدم `const` widgets حيثما أمكن
- تجنب إعادة البناء غير الضرورية
- استخدم `ListView.builder` للقوائم الطويلة

### قاعدة البيانات المحلية

- استخدم Isar للقاعدة المحلية
- طبق indexing للاستعلامات السريعة
- استخدم transactions للعمليات المعقدة

## الاختبارات

### Unit Tests

- اختبر كل public function
- استخدم mocks للـ dependencies
- حقق 70%+ test coverage

### Widget Tests

- اختبر المسارات الحرجة
- تحقق من UI interactions
- اختبر حالات الخطأ

### Integration Tests

- اختبر user journeys كاملة
- تحقق من تدفق البيانات
- اختبر الأداء

## الأمان

### حماية البيانات

- استخدم `flutter_secure_storage` للبيانات الحساسة
- شفّر البيانات المحلية المهمة
- تحقق من صحة جميع المدخلات

### الشبكة

- استخدم HTTPS دائماً
- طبق certificate pinning
- تحقق من صحة الاستجابات

## التوثيق

### DartDoc

- وثّق جميع public APIs
- أضف أمثلة في التوثيق
- اشرح المعاملات والقيم المرجعة

### README

- اشرح كيفية تشغيل المشروع
- أضف متطلبات النظام
- وثّق عملية البناء والنشر
