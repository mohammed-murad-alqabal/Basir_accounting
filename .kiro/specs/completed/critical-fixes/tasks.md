# Implementation Plan - إصلاحات حرجة فورية

## Overview

خطة تنفيذ الإصلاحات الحرجة الفورية لمشروع بصير MVP.

---

## Tasks

- [x] 1. إعداد البيئة

  - إنشاء branch جديد للإصلاحات
  - التأكد من نجاح جميع الاختبارات الحالية
  - إنشاء نسخة احتياطية
  - _Requirements: 8.2_

- [x] 2. إصلاح التبعيات

  - [x] 2.1 إضافة crypto إلى pubspec.yaml
    - تشغيل `flutter pub add crypto`
    - التحقق من التثبيت الصحيح
    - _Requirements: 1.1, 1.2_

- [x] 3. إصلاح معالجة الاستثناءات

  - [x] 3.1 إصلاح auth_service.dart

    - إصلاح 2 موضع catch
    - استخدام `on Exception catch`
    - إضافة stack trace logging
    - _Requirements: 2.1, 2.2, 2.4_

  - [x] 3.2 إصلاح auth_provider.dart

    - إصلاح 4 مواضع catch
    - استخدام `on Exception catch`
    - تحسين رسائل الخطأ
    - _Requirements: 2.1, 2.2, 2.5_

  - [x] 3.3 إصلاح login_screen.dart

    - إصلاح 1 موضع catch
    - استخدام `on Exception catch`
    - _Requirements: 2.1, 2.2_

  - [x] 3.4 إصلاح setup_screen.dart
    - إصلاح 1 موضع catch
    - استخدام `on Exception catch`
    - _Requirements: 2.1, 2.2_

- [x] 4. إصلاح Future calls

  - [x] 4.1 إصلاح login_screen.dart

    - إضافة await لـ Navigator.push (2 مواضع)
    - التحقق من معالجة النتائج
    - _Requirements: 3.1, 3.2_

  - [x] 4.2 إصلاح dashboard_screen.dart

    - إضافة await أو unawaited (5 مواضع)
    - تحسين تدفق البرنامج
    - _Requirements: 3.1, 3.3_

  - [x] 4.3 إصلاح invoices_screen.dart
    - إضافة await لـ Navigator.push (1 موضع)
    - _Requirements: 3.1, 3.4_

- [x] 5. استبدال Deprecated APIs

  - [x] 5.1 استبدال withOpacity

    - login_screen.dart: استخدام withValues
    - setup_screen.dart: استخدام withValues
    - _Requirements: 4.1_

  - [x] 5.2 استبدال Table.fromTextArray
    - pdf_service.dart: استخدام TableHelper.fromTextArray
    - _Requirements: 4.2_

- [x] 6. تحسين TODO comments

  - [x] 6.1 تحديث TODO في login_screen.dart

    - إضافة username
    - إضافة issue reference إن وجد
    - _Requirements: 5.1, 5.2_

  - [x] 6.2 تحديث TODO في setup_screen.dart

    - إضافة username
    - إضافة issue reference إن وجد
    - _Requirements: 5.1, 5.2_

  - [x] 6.3 تحديث TODO في settings_screen.dart

    - تحديث 2 موضع TODO
    - إضافة تفاصيل واضحة
    - _Requirements: 5.1, 5.3_

  - [x] 6.4 تحديث TODO في invoices_screen.dart
    - إضافة username وتفاصيل
    - _Requirements: 5.1_

- [x] 7. إضافة التوثيق المفقود

  - [x] 7.1 توثيق customer.dart

    - إضافة documentation للـ copyWith method
    - _Requirements: 6.1, 6.2_

  - [x] 7.2 توثيق dashboard_screen.dart

    - إضافة documentation للـ DashboardScreen class
    - _Requirements: 6.1_

  - [x] 7.3 توثيق pdf_service.dart

    - إضافة documentation للـ PdfService class
    - إضافة documentation للـ generateInvoicePdf method
    - _Requirements: 6.1, 6.2, 6.3_

  - [x] 7.4 توثيق settings_screen.dart
    - إضافة documentation للـ SettingsScreen class
    - _Requirements: 6.1_

- [x] 8. Checkpoint - التحقق من الإصلاحات

  - تشغيل flutter analyze
  - التحقق من تقليل عدد المشاكل
  - تشغيل جميع الاختبارات
  - _Requirements: 8.1, 8.2_

- [~] 9. بناء واختبار التطبيق

  - [x] 9.1 بناء debug build

    - تشغيل `flutter build apk --debug`
    - التحقق من نجاح البناء
    - _Requirements: 8.4_

  - [x] 9.2 تثبيت على الموبايل

    - تثبيت التطبيق على جهاز Android
    - التحقق من التثبيت الناجح
    - _Requirements: 7.1_

  - [!] 9.3 اختبار الميزات الأساسية
    - ⚠️ يحتاج اختبار يدوي من المستخدم
    - راجع ACTUAL_TESTING_REPORT.md
    - _Requirements: 7.2, 7.3, 7.4, 7.5_

- [~] 10. بناء release build

  - [x] 10.1 بناء release APK

    - تشغيل `flutter build apk --release`
    - التحقق من حجم التطبيق
    - _Requirements: 8.4_

  - [!] 10.2 اختبار release build
    - ⚠️ يحتاج اختبار يدوي من المستخدم
    - راجع ACTUAL_TESTING_REPORT.md
    - _Requirements: 7.2, 7.3_

- [x] 11. التحقق النهائي

  - [x] 11.1 مراجعة flutter analyze

    - التحقق من تقليل المشاكل إلى < 50
    - توثيق المشاكل المتبقية
    - _Requirements: 8.1_

  - [x] 11.2 مراجعة الاختبارات

    - التحقق من نجاح جميع الاختبارات
    - التحقق من تغطية التوثيق
    - _Requirements: 8.2, 8.3_

  - [x] 11.3 مراجعة الأداء
    - قياس startup time
    - قياس memory usage
    - قياس frame rate
    - _Requirements: 7.2, 7.3_

- [x] 12. التوثيق والنشر

  - [x] 12.1 إنشاء تقرير الإصلاحات

    - توثيق جميع الإصلاحات المطبقة
    - توثيق المشاكل المتبقية
    - إنشاء قائمة بالخطوات التالية
    - _Requirements: 8.1_

  - [x] 12.2 تحديث CHANGELOG

    - إضافة قسم للإصلاحات
    - توثيق التغييرات المهمة
    - _Requirements: 8.1_

  - [x] 12.3 إنشاء Pull Request
    - كتابة وصف شامل
    - إضافة screenshots
    - طلب code review
    - _Requirements: 8.1_

---

## Summary

**Total Tasks:** 12 main tasks  
**Sub-tasks:** 28 sub-tasks  
**Estimated Time:** 4-6 hours  
**Priority:** 🔴 Critical

---

**Version:** 1.0  
**Status:** Ready for execution  
**Date:** 28 نوفمبر 2025
