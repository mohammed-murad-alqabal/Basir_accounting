# Implementation Plan - نظام الترجمة والتدويل

**المشروع:** بصير MVP  
**التاريخ:** 9 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** 🔄 جاهز للتنفيذ

---

## Overview

خطة تنفيذ شاملة لبناء نظام الترجمة والتدويل في تطبيق بصير MVP. التنفيذ مقسم إلى مراحل تدريجية لضمان الجودة والاستقرار.

---

## Implementation Tasks

- [ ] 1. إعداد البنية الأساسية للترجمة

  - إنشاء مجلد `lib/l10n/` وملفات ARB الأساسية
  - إضافة dependencies المطلوبة (flutter_localizations, intl)
  - إنشاء ملف `l10n.yaml` للتكوين
  - توليد ملف `app_localizations.dart`
  - _Requirements: 1.1, 1.2, 1.3, 1.4_

- [ ] 1.1 إنشاء ملفات ARB الأساسية

  - إنشاء `lib/l10n/app_ar.arb` مع النصوص العربية الأساسية
  - إنشاء `lib/l10n/app_en.arb` مع الترجمات الإنجليزية
  - إضافة metadata للمفاتيح (@description)
  - التحقق من صحة JSON structure
  - _Requirements: 1.2_

- [ ] 1.2 تكوين l10n.yaml

  - إنشاء ملف `l10n.yaml` في الجذر
  - تحديد arb-dir و template-arb-file
  - تحديد output-localization-file
  - تحديد preferred-supported-locales
  - _Requirements: 1.3_

- [ ] 1.3 تحديث pubspec.yaml

  - إضافة flutter_localizations dependency
  - إضافة intl package
  - إضافة shared_preferences للتخزين
  - إضافة `generate: true` في flutter section
  - _Requirements: 1.1_

- [ ] 1.4 توليد AppLocalizations

  - تشغيل `flutter gen-l10n`
  - التحقق من توليد الملفات في `.dart_tool/flutter_gen/`
  - اختبار استيراد AppLocalizations
  - _Requirements: 1.4_

- [ ]\* 1.5 اختبار البنية الأساسية

  - كتابة unit test للتحقق من وجود المفاتيح
  - اختبار تحميل الترجمات
  - التحقق من fallback mechanism
  - _Requirements: 8.1_

- [ ] 2. إنشاء نظام إدارة اللغة

  - إنشاء LocaleProvider باستخدام Riverpod
  - إنشاء LocaleRepository للتخزين المحلي
  - إضافة دوال مساعدة للتنسيق (FormatHelpers)
  - تكامل مع MaterialApp
  - _Requirements: 6.1, 6.2, 6.3, 6.4_

- [ ] 2.1 إنشاء LocaleRepository

  - إنشاء `lib/core/repositories/locale_repository.dart`
  - تنفيذ `getSavedLocale()` method
  - تنفيذ `saveLocale()` method
  - تنفيذ `clearLocale()` method
  - معالجة الأخطاء والحالات الاستثنائية
  - _Requirements: 6.2, 6.4_

- [ ] 2.2 إنشاء LocaleProvider

  - إنشاء `lib/core/providers/locale_provider.dart`
  - تنفيذ StateNotifier للغة
  - إضافة `setLocale()` method
  - إضافة getters (isArabic, isEnglish, textDirection)
  - تحميل اللغة المحفوظة عند البدء
  - _Requirements: 6.1, 6.3_

- [ ] 2.3 إنشاء FormatHelpers

  - إنشاء `lib/core/utils/format_helpers.dart`
  - تنفيذ `formatDate()` للتواريخ
  - تنفيذ `formatDateTime()` للتاريخ والوقت
  - تنفيذ `formatNumber()` للأرقام
  - تنفيذ `formatCurrency()` للعملات
  - تنفيذ `formatRelativeTime()` للوقت النسبي
  - _Requirements: 5.1, 5.2, 5.3, 5.4_

- [ ] 2.4 تكامل مع MaterialApp

  - تحديث `main.dart` لإضافة localizationsDelegates
  - إضافة supportedLocales
  - ربط LocaleProvider مع MaterialApp.locale
  - إضافة Directionality wrapper
  - _Requirements: 6.3_

- [ ]\* 2.5 اختبار نظام إدارة اللغة

  - كتابة unit tests لـ LocaleRepository
  - كتابة unit tests لـ LocaleProvider
  - كتابة unit tests لـ FormatHelpers
  - اختبار تبديل اللغة
  - _Requirements: 8.2_

- [ ] 3. استخراج وترجمة النصوص الأساسية

  - استخراج نصوص التنقل (Navigation)
  - استخراج نصوص الإجراءات (Actions)
  - استخراج رسائل التحقق (Validation)
  - استخراج رسائل النجاح والخطأ
  - _Requirements: 2.1, 2.2, 2.3_

- [ ] 3.1 ترجمة نصوص التنقل

  - استخراج نصوص من BottomNavigationBar
  - استخراج نصوص من Drawer/AppBar
  - إضافة المفاتيح في ARB files
  - استبدال النصوص المشفرة بـ AppLocalizations
  - _Requirements: 2.1, 2.2_

- [ ] 3.2 ترجمة نصوص الإجراءات

  - استخراج نصوص الأزرار (إضافة، تعديل، حذف، إلخ)
  - إضافة المفاتيح في ARB files
  - استبدال في جميع الشاشات
  - _Requirements: 2.1, 2.2_

- [ ] 3.3 ترجمة رسائل التحقق

  - استخراج رسائل validation من Validators
  - إضافة المفاتيح في ARB files
  - تحديث جميع validation functions
  - _Requirements: 2.1, 2.2_

- [ ] 3.4 ترجمة رسائل النجاح والخطأ

  - استخراج رسائل SnackBar
  - استخراج رسائل Dialog
  - إضافة المفاتيح في ARB files
  - استبدال في جميع الأماكن
  - _Requirements: 2.1, 2.2_

- [ ]\* 3.5 اختبار الترجمات الأساسية

  - اختبار عرض النصوص بالعربية
  - اختبار عرض النصوص بالإنجليزية
  - التحقق من عدم وجود نصوص مشفرة
  - _Requirements: 8.2_

- [ ] 4. Checkpoint - التحقق من الترجمات الأساسية

  - Ensure all tests pass, ask the user if questions arise.

- [ ] 5. ترجمة وحدة العملاء (Customers Module)

  - استخراج نصوص شاشات العملاء
  - استخراج نصوص نماذج العملاء
  - استخراج نصوص قوائم العملاء
  - تحديث جميع widgets
  - _Requirements: 2.1, 2.2_

- [ ] 5.1 ترجمة CustomersListScreen

  - استخراج عنوان الشاشة
  - استخراج نصوص البحث
  - استخراج نصوص الفلترة
  - استخراج نصوص Empty state
  - استبدال جميع النصوص المشفرة
  - _Requirements: 2.1, 2.2_

- [ ] 5.2 ترجمة CustomerFormScreen

  - استخراج labels للحقول
  - استخراج hints للحقول
  - استخراج نصوص الأزرار
  - استخراج رسائل التحقق
  - استبدال جميع النصوص المشفرة
  - _Requirements: 2.1, 2.2_

- [ ] 5.3 ترجمة CustomerCard widget

  - استخراج نصوص العرض
  - استخراج نصوص الإجراءات
  - استبدال جميع النصوص المشفرة
  - _Requirements: 2.1, 2.2_

- [ ]\* 5.4 اختبار وحدة العملاء

  - widget tests لـ CustomersListScreen
  - widget tests لـ CustomerFormScreen
  - widget tests لـ CustomerCard
  - التحقق من RTL/LTR
  - _Requirements: 8.2, 8.3_

- [ ] 6. ترجمة وحدة الفواتير (Invoices Module)

  - استخراج نصوص شاشات الفواتير
  - استخراج نصوص نماذج الفواتير
  - استخراج نصوص قوائم الفواتير
  - تحديث جميع widgets
  - _Requirements: 2.1, 2.2_

- [ ] 6.1 ترجمة InvoicesListScreen

  - استخراج عنوان الشاشة
  - استخراج نصوص الفلترة (حسب الحالة)
  - استخراج نصوص البحث
  - استخراج نصوص Empty state
  - استبدال جميع النصوص المشفرة
  - _Requirements: 2.1, 2.2_

- [ ] 6.2 ترجمة InvoiceFormScreen

  - استخراج labels للحقول
  - استخراج نصوص إضافة البنود
  - استخراج نصوص الحسابات (المجموع، الضريبة، إلخ)
  - استبدال جميع النصوص المشفرة
  - _Requirements: 2.1, 2.2_

- [ ] 6.3 ترجمة InvoiceCard widget

  - استخراج نصوص العرض
  - استخراج نصوص الحالة (مسودة، مرسلة، مدفوعة، إلخ)
  - استبدال جميع النصوص المشفرة
  - _Requirements: 2.1, 2.2_

- [ ]\* 6.4 اختبار وحدة الفواتير

  - widget tests لـ InvoicesListScreen
  - widget tests لـ InvoiceFormScreen
  - widget tests لـ InvoiceCard
  - التحقق من تنسيق الأرقام والعملات
  - _Requirements: 8.2, 8.4_

- [ ] 7. ترجمة وحدة الإعدادات والشاشات الأخرى

  - ترجمة SettingsScreen
  - ترجمة DashboardScreen
  - ترجمة AboutScreen
  - إضافة واجهة تبديل اللغة
  - _Requirements: 2.1, 2.2, 6.1_

- [ ] 7.1 ترجمة SettingsScreen

  - استخراج عناوين الأقسام
  - استخراج نصوص الخيارات
  - إضافة Language Picker widget
  - استبدال جميع النصوص المشفرة
  - _Requirements: 2.1, 2.2, 6.1_

- [ ] 7.2 إنشاء LanguagePickerDialog

  - إنشاء dialog لاختيار اللغة
  - عرض اللغات المدعومة مع الأعلام
  - حفظ الاختيار عند التأكيد
  - إعادة بناء الواجهة بعد التغيير
  - _Requirements: 6.1, 6.2, 6.3_

- [ ] 7.3 ترجمة DashboardScreen

  - استخراج عناوين الإحصائيات
  - استخراج نصوص الرسوم البيانية
  - استبدال جميع النصوص المشفرة
  - _Requirements: 2.1, 2.2_

- [ ]\* 7.4 اختبار الإعدادات والشاشات الأخرى

  - widget tests لـ SettingsScreen
  - widget tests لـ LanguagePickerDialog
  - integration test لتبديل اللغة
  - _Requirements: 8.2_

- [ ] 8. Checkpoint - التحقق من اكتمال الترجمات

  - Ensure all tests pass, ask the user if questions arise.

- [ ] 9. إصلاح RTL/LTR Alignments

  - البحث عن جميع استخدامات left/right
  - استبدال بـ start/end
  - استخدام EdgeInsetsDirectional
  - اختبار في كلا الاتجاهين
  - _Requirements: 3.3, 3.4_

- [ ] 9.1 إصلاح Alignment properties

  - البحث عن `Alignment.centerLeft`
  - البحث عن `Alignment.centerRight`
  - استبدال بـ `Alignment.centerStart/End`
  - البحث عن `TextAlign.left/right`
  - استبدال بـ `TextAlign.start/end`
  - _Requirements: 3.3_

- [ ] 9.2 إصلاح EdgeInsets

  - البحث عن `EdgeInsets.only(left:` أو `right:`
  - استبدال بـ `EdgeInsetsDirectional.only(start:` أو `end:`
  - البحث عن `EdgeInsets.symmetric(horizontal:`
  - التحقق من الحاجة لـ EdgeInsetsDirectional
  - _Requirements: 3.4_

- [ ] 9.3 إصلاح Icons

  - البحث عن icons تحتاج انعكاس في RTL
  - إضافة `textDirection` parameter حيث يلزم
  - اختبار في RTL mode
  - _Requirements: 3.5_

- [ ]\* 9.4 اختبار RTL/LTR

  - widget tests للتحقق من الاتجاه الصحيح
  - visual regression tests
  - اختبار على أجهزة حقيقية
  - _Requirements: 8.3_

- [ ] 10. إضافة Text Overflow Handling

  - البحث عن جميع Text widgets
  - إضافة overflow property
  - إضافة maxLines حيث يلزم
  - استخدام Flexible/Expanded حيث يلزم
  - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5_

- [ ] 10.1 إضافة overflow لـ Text widgets

  - البحث عن جميع `Text(` في الكود
  - إضافة `overflow: TextOverflow.ellipsis`
  - تحديد `maxLines` مناسب (1-3 حسب السياق)
  - _Requirements: 4.1, 4.2, 4.3_

- [ ] 10.2 إصلاح layout constraints

  - البحث عن Text widgets في Row/Column
  - إضافة `Flexible` أو `Expanded` حيث يلزم
  - التحقق من عدم overflow errors
  - _Requirements: 4.4_

- [ ] 10.3 إصلاح Button text overflow

  - التحقق من جميع الأزرار
  - إضافة overflow handling
  - ضمان عدم تجاوز حدود الزر
  - _Requirements: 4.5_

- [ ]\* 10.4 اختبار Text overflow

  - widget tests مع نصوص طويلة
  - اختبار على شاشات صغيرة
  - التحقق من عدم overflow errors
  - _Requirements: 8.4_

- [ ] 11. تطبيق تنسيق التواريخ والأرقام

  - استبدال جميع عرض التواريخ بـ FormatHelpers
  - استبدال جميع عرض الأرقام بـ FormatHelpers
  - استبدال جميع عرض العملات بـ FormatHelpers
  - إضافة relative time formatting
  - _Requirements: 5.1, 5.2, 5.3, 5.4_

- [ ] 11.1 تنسيق التواريخ

  - البحث عن جميع `DateTime.toString()`
  - استبدال بـ `FormatHelpers.formatDate()`
  - استخدام `formatDateTime()` للتاريخ والوقت
  - _Requirements: 5.1_

- [ ] 11.2 تنسيق الأرقام

  - البحث عن جميع عرض الأرقام
  - استبدال بـ `FormatHelpers.formatNumber()`
  - إضافة thousands separator
  - _Requirements: 5.2_

- [ ] 11.3 تنسيق العملات

  - البحث عن جميع عرض المبالغ المالية
  - استبدال بـ `FormatHelpers.formatCurrency()`
  - إضافة رمز العملة المناسب
  - _Requirements: 5.3_

- [ ] 11.4 إضافة Relative time

  - استخدام `formatRelativeTime()` للتواريخ النسبية
  - عرض "منذ ساعة"، "قبل يومين"، إلخ
  - _Requirements: 5.4_

- [ ]\* 11.5 اختبار التنسيق

  - unit tests لجميع format functions
  - اختبار مع locales مختلفة
  - التحقق من الصحة
  - _Requirements: 8.5_

- [ ] 12. Checkpoint - التحقق من جميع التحسينات

  - Ensure all tests pass, ask the user if questions arise.

- [ ] 13. إنشاء أدوات المطور

  - سكريبت لاستخراج النصوص المشفرة
  - سكريبت للتحقق من اكتمال الترجمات
  - سكريبت لمزامنة مفاتيح الترجمة
  - سكريبت لتوليد تقرير الإحصائيات
  - _Requirements: 7.1, 7.2, 7.3, 7.4, 10.1, 10.2, 10.3, 10.4_

- [ ] 13.1 سكريبت استخراج النصوص

  - إنشاء `scripts/i18n/extract_strings.sh`
  - البحث عن Text widgets بنصوص مشفرة
  - توليد قائمة بالنصوص المكتشفة
  - _Requirements: 10.1_

- [ ] 13.2 سكريبت التحقق من الاكتمال

  - إنشاء `scripts/i18n/check_completeness.sh`
  - مقارنة جميع ملفات ARB
  - عرض المفاتيح المفقودة
  - توليد تقرير
  - _Requirements: 7.1, 7.2, 7.3, 7.4, 10.2_

- [ ] 13.3 سكريبت المزامنة

  - إنشاء `scripts/i18n/sync_keys.sh`
  - إضافة المفاتيح المفقودة تلقائياً
  - الحفاظ على الترتيب
  - _Requirements: 10.3_

- [ ] 13.4 سكريبت الإحصائيات

  - إنشاء `scripts/i18n/stats.sh`
  - حساب عدد المفاتيح لكل لغة
  - حساب نسبة الاكتمال
  - توليد تقرير مفصل
  - _Requirements: 10.4_

- [ ]\* 13.5 اختبار الأدوات

  - اختبار جميع السكريبتات
  - التحقق من صحة النتائج
  - توثيق الاستخدام
  - _Requirements: 10.1, 10.2, 10.3, 10.4_

- [ ] 14. التوثيق الشامل

  - كتابة دليل المطور
  - كتابة دليل الاستخدام
  - إضافة أمثلة عملية
  - إضافة قسم troubleshooting
  - _Requirements: 9.1, 9.2, 9.3, 9.4, 9.5_

- [ ] 14.1 دليل المطور

  - إنشاء `.kiro/docs/i18n/developer-guide.md`
  - شرح بنية الترجمة
  - شرح كيفية إضافة نصوص جديدة
  - شرح كيفية إضافة لغات جديدة
  - _Requirements: 9.1, 9.2, 9.3_

- [ ] 14.2 دليل الاستخدام

  - إنشاء `.kiro/docs/i18n/user-guide.md`
  - شرح كيفية تبديل اللغة
  - شرح الميزات المتاحة
  - _Requirements: 9.1_

- [ ] 14.3 أمثلة عملية

  - إضافة أمثلة لكل حالة استخدام
  - أمثلة للترجمة
  - أمثلة للتنسيق
  - أمثلة للـ RTL/LTR
  - _Requirements: 9.5_

- [ ] 14.4 Troubleshooting

  - إضافة قسم للمشاكل الشائعة
  - إضافة حلول للمشاكل
  - إضافة FAQs
  - _Requirements: 9.4_

- [ ] 15. الاختبارات الشاملة النهائية

  - تشغيل جميع الاختبارات
  - اختبار على أجهزة حقيقية
  - اختبار جميع السيناريوهات
  - إصلاح أي مشاكل مكتشفة
  - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.5_

- [ ] 15.1 Unit tests شاملة

  - تشغيل جميع unit tests
  - التحقق من تغطية > 80%
  - إصلاح الاختبارات الفاشلة
  - _Requirements: 8.1_

- [ ] 15.2 Widget tests شاملة

  - تشغيل جميع widget tests
  - اختبار بكلا اللغتين
  - اختبار RTL/LTR
  - _Requirements: 8.2, 8.3_

- [ ] 15.3 Integration tests

  - اختبار تبديل اللغة end-to-end
  - اختبار جميع الشاشات
  - اختبار على أجهزة مختلفة
  - _Requirements: 8.2_

- [ ] 15.4 Manual testing

  - اختبار يدوي على Android
  - اختبار يدوي على iOS
  - اختبار على أحجام شاشات مختلفة
  - التحقق من UX
  - _Requirements: 8.4_

- [ ] 16. Final Checkpoint - المراجعة النهائية
  - Ensure all tests pass, ask the user if questions arise.

---

## Testing Requirements

### Unit Tests

- LocaleRepository tests
- LocaleProvider tests
- FormatHelpers tests
- Translation key completeness tests

### Widget Tests

- Localization widget tests
- RTL/LTR direction tests
- Text overflow tests
- Language switching tests

### Integration Tests

- End-to-end language switching
- Full app navigation in both languages
- Date/number formatting in context

---

## Success Criteria

- [ ] 0 hardcoded strings in codebase
- [ ] 100% translation key coverage
- [ ] 0 left/right alignments
- [ ] 100% text widgets have overflow handling
- [ ] All dates/numbers formatted correctly
- [ ] Language switching works seamlessly
- [ ] All tests passing (> 80% coverage)
- [ ] Documentation complete

---

## Estimated Timeline

| Phase                        | Duration    | Tasks        |
| :--------------------------- | :---------- | :----------- |
| Phase 1: Setup               | 3 days      | Tasks 1-2    |
| Phase 2: Core Translations   | 5 days      | Tasks 3-4    |
| Phase 3: Module Translations | 10 days     | Tasks 5-7    |
| Phase 4: Refinements         | 7 days      | Tasks 9-11   |
| Phase 5: Tools & Docs        | 5 days      | Tasks 13-14  |
| Phase 6: Testing             | 5 days      | Task 15      |
| **Total**                    | **35 days** | **~7 weeks** |

---

## Dependencies

### External

- flutter_localizations (SDK)
- intl package
- shared_preferences package
- riverpod packages

### Internal

- Existing UI components
- Existing business logic
- Existing data models

---

## Risks and Mitigation

### Risk 1: Large number of strings (191)

**Mitigation:** Incremental approach, module by module

### Risk 2: RTL layout issues

**Mitigation:** Thorough testing, use of start/end consistently

### Risk 3: Performance impact

**Mitigation:** Lazy loading, caching, optimization

### Risk 4: Missing translations

**Mitigation:** Automated checks, fallback mechanism

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 9 ديسمبر 2025  
**الإصدار:** 1.0  
**الحالة:** 🔄 جاهز للتنفيذ
