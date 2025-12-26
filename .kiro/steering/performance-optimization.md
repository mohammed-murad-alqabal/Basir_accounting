---
id: "performance-optimization"
description: "دليل تحسين وتحليل الأداء (Performance Optimization Guide)"
version: "1.0"
last_updated: "2025-12-25"
inclusion: always
author: "فريق وكلاء تطوير مشروع بصير"
metrics:
  impact: "High"
---

# Performance Optimization Guide

## 1. Profiling & Monitoring

### 1.1 Flutter DevTools

- **Performance View**: تحديد إطارات UI البطيئة (Jank).
- **CPU Profiler**: تحديد الدوال التي تستهلك المعالج.
- **Memory View**: اكتشاف تسرب الذاكرة (Memory Leaks).

### 1.2 Custom Metrics

- قياس زمن الاستجابة للعمليات الحرجة.
- تسجيل مؤشرات الأداء الرئيسية (KPIs) وإرسالها لنظام المراقبة.

## 2. Rendering Optimization

### 2.1 Build Method Optimization

- تجنب العمليات الحسابية الثقيلة داخل `build()`.
- استخدام `const` constructors كلما أمكن.
- تقسيم الـ Widgets الكبيرة إلى Widgets أصغر.

### 2.2 List Optimization

- استخدام `ListView.builder` للقوائم الطويلة.
- تفعيل `addAutomaticKeepAlives` بحذر.
- **جديد**: استخدم `RepaintBoundary` حول عناصر القائمة المعقدة لمنع إعادة رسم القائمة بأكملها.

### 2.3 Image Optimization

- استخدام `cacheWidth` و `cacheHeight` عند تحميل الصور لتقليل استهلاك الذاكرة.
- استخدام صيغ فعالة مثل `.webp` بدلاً من `.png`/`.jpg`.
- **Pre-caching**: تحميل الصور المهمة مبكراً باستخدام `precacheImage`.

### 2.4 Rendering Engine (Impeller)

- **Impeller**: محرك العرض الافتراضي في Flutter 3.10+ (iOS) و 3.16+ (Android).
- يقضي على مشكلة jank التجميع المسبق للظلال (Shader compilation jank).
- **نصيحة**: لا حاجة لـ warm-up shaders يدوياً مع Impeller.

## 3. State Management Efficiency

### 3.1 Riverpod Best Practices

- استخدام `select` لإعادة بناء الـ Widget فقط عند تغير جزء محدد من الحالة.
- تجنب `watch` للمشاهدات غير الضرورية.

## 4. Scalability Strategies

### 4.1 Caching

- **Local Caching**: تخزين البيانات محلياً (Isar, Hive) لتقليل طلبات الشبكة.
- **CDN**: توزيع المحتوى الثابت عبر شبكة توصيل المحتوى.

### 4.2 Asynchronous Operations

- استخدام `Isolate` للعمليات الثقيلة (مثل معالجة الصور، تحليل JSON الضخم) لمنع تجميد واجهة المستخدم.

## 5. Testing Methodologies

### 5.1 Benchmark Tests

- كتابة اختبارات قياس الأداء (Benchmarking) للعمليات الحرجة.
- مقارنة النتائج مع الإصدارات السابقة.

### 5.2 Load Testing (Backend)

- اختبار تحمل الـ Backend للأحمال العالية.
