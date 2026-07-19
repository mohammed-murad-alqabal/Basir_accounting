# Dashboard Test Integration - Requirements Document

**المشروع:** نظام بصير المحاسبي  
**التاريخ:** 12 يناير 2026  
**المؤلف:** فريق وكلاء تطوير نظام بصير المحاسبي  
**الإصدار:** 1.0  
**الحالة:** نشط

---

## المقدمة

هذا المستند يحدد متطلبات حل مشكلة اختبارات شاشة لوحة التحكم (Dashboard) في
نظام بصير المحاسبي. المشكلة الأساسية تتعلق بـ Timer Issues الناتجة عن
الـ Chart Widgets المعقدة التي تستخدم عمليات غير متزامنة (Async Operations)
مما يؤدي إلى فشل الاختبارات.

## المصطلحات

- **Dashboard Screen**: شاشة لوحة التحكم الرئيسية
- **Chart Widgets**: مكونات الرسوم البيانية (RevenueTrendChart, ExpenseCompositionChart)
- **Timer Issues**: مشاكل المؤقتات المعلقة في الاختبارات
- **Async Operations**: العمليات غير المتزامنة
- **Provider Mocking**: محاكاة مزودات Riverpod
- **Architectural Separation**: الفصل المعماري للاختبارات
- **Test-Specific Widgets**: مكونات مخصصة للاختبار

## المتطلبات

### Requirement 1: حل مشكلة Timer Issues

**User Story:** كمطور، أريد تشغيل اختبارات Dashboard بدون Timer Issues،
حتى أتمكن من التحقق من وظائف لوحة التحكم بشكل موثوق.

#### معايير القبول

1. WHEN اختبار DashboardScreen يتم تشغيله THEN النظام SHALL لا يعرض
   أخطاء "Timer is still pending"
2. WHEN Chart Widgets تستخدم async operations THEN النظام SHALL يستخدم
   mock widgets بدلاً من الـ widgets الحقيقية
3. WHEN اختبار ينتهي THEN النظام SHALL ينظف جميع الموارد والمؤقتات بشكل صحيح
4. WHEN جميع اختبارات Dashboard تنجح THEN النظام SHALL يحقق 100% نجاح
   في التنفيذ

### Requirement 2: إنشاء Test-Specific Dashboard

**User Story:** كمطور، أريد نسخة مخصصة للاختبار من DashboardScreen،
حتى أتمكن من اختبار الوظائف الأساسية بدون تعقيدات Chart Widgets.

#### معايير القبول

1. WHEN TestDashboardScreen يتم إنشاؤها THEN النظام SHALL تحتوي على
   جميع وظائف Dashboard الأساسية
2. WHEN TestDashboardScreen تستخدم MockDashboardCharts THEN النظام SHALL
   يعرض محتوى بسيط بدلاً من الرسوم البيانية المعقدة
3. WHEN اختبار يستخدم TestDashboardScreen THEN النظام SHALL يحافظ على
   نفس واجهة المستخدم والتفاعلات
4. WHEN TestDashboardScreen تتفاعل مع providers THEN النظام SHALL يستخدم
   نفس providers المحاكاة

### Requirement 3: تحسين Provider Mocking

**User Story:** كمطور، أريد محاكاة شاملة لجميع Providers المطلوبة،
حتى تعمل اختبارات Dashboard بشكل مستقل عن التبعيات الخارجية.

#### معايير القبول

1. WHEN MockAnalyticsService يتم إنشاؤه THEN النظام SHALL يحاكي جميع
   وظائف AnalyticsService
2. WHEN MockDashboardController يتم إنشاؤه THEN النظام SHALL يوفر
   بيانات DashboardData محاكاة
3. WHEN Provider overrides يتم تطبيقها THEN النظام SHALL يستخدم
   المحاكيات بدلاً من الخدمات الحقيقية
4. WHEN اختبار يحتاج بيانات THEN النظام SHALL يوفر بيانات اختبار
   واقعية ومتسقة

### Requirement 4: تحسين بنية الاختبارات

**User Story:** كمطور، أريد بنية اختبارات محسنة ومنظمة، حتى يسهل
صيانة وتطوير الاختبارات مستقبلاً.

#### معايير القبول

1. WHEN ملفات Mock يتم تنظيمها THEN النظام SHALL يضعها في مجلد
   test/mocks منظم
2. WHEN Test Helper Functions يتم إنشاؤها THEN النظام SHALL توفر
   دوال مساعدة لإنشاء بيانات الاختبار
3. WHEN اختبارات متعددة تحتاج نفس البيانات THEN النظام SHALL يستخدم
   Pre-computed Test Data
4. WHEN اختبار يفشل THEN النظام SHALL يعرض رسالة خطأ واضحة ومفيدة

### Requirement 5: تحقيق تغطية اختبارات شاملة

**User Story:** كمطور، أريد تغطية شاملة لجميع وظائف Dashboard،
حتى أضمن جودة وموثوقية الكود.

#### معايير القبول

1. WHEN اختبارات Statistics Section تتم THEN النظام SHALL يختبر
   عرض جميع البطاقات الإحصائية (4 بطاقات)
2. WHEN اختبارات Quick Actions تتم THEN النظام SHALL يختبر جميع
   الأزرار والتنقل
3. WHEN اختبارات Recent Activity تتم THEN النظام SHALL يختبر عرض
   الأنشطة الأخيرة
4. WHEN اختبارات Accessibility تتم THEN النظام SHALL يتحقق من
   Semantic Labels

### Requirement 6: حل مشكلة Deprecated Parent Parameter

**User Story:** كمطور، أريد حل تحذيرات Deprecated Code، حتى يكون
الكود متوافقاً مع أحدث إصدارات Riverpod.

#### معايير القبول

1. WHEN ProviderScope يتم استخدامه THEN النظام SHALL لا يستخدم
   parent parameter المهجور
2. WHEN Container overrides يتم تطبيقها THEN النظام SHALL يستخدم
   الطريقة الجديدة المعتمدة
3. WHEN اختبار يتم تشغيله THEN النظام SHALL لا يعرض تحذيرات deprecation
4. WHEN Riverpod يتم تحديثه THEN النظام SHALL يبقى متوافقاً مع
   الإصدارات الجديدة

## أولويات التنفيذ

### المرحلة 1: حل Timer Issues (عالية الأولوية)

- ✅ إنشاء MockDashboardCharts widget
- ✅ إنشاء TestDashboardScreen
- ✅ تطبيق Architectural Separation approach

### المرحلة 2: تحسين Provider Mocking (عالية الأولوية)

- ✅ إنشاء MockAnalyticsService
- ✅ إنشاء MockDashboardController
- ✅ تحسين Provider overrides

### المرحلة 3: حل Deprecated Code (متوسطة الأولوية)

- ⏳ إزالة parent parameter من ProviderScope
- ⏳ تحديث Container setup

### المرحلة 4: تحسين التغطية (متوسطة الأولوية)

- ⏳ التحقق من نجاح جميع الاختبارات (18/18)
- ⏳ تحسين رسائل الخطأ
- ⏳ إضافة اختبارات إضافية حسب الحاجة

## معايير النجاح

| المعيار                           | القيمة المستهدفة | الحالة الحالية |
| :-------------------------------- | :--------------- | :------------- |
| **نجاح اختبارات Dashboard**       | 18/18 (100%)     | 15/18 (83%)    |
| **عدم وجود Timer Issues**         | 0 أخطاء          | مُحل جزئياً    |
| **عدم وجود Deprecation Warnings** | 0 تحذيرات        | 1 تحذير        |
| **وقت تنفيذ الاختبارات**          | < 10 ثواني       | ~8 ثواني       |
| **تغطية Dashboard Code**          | ≥ 90%            | ~85%           |

## المخاطر والتحديات

### المخاطر التقنية

1. **Chart Widget Dependencies**: تعقيد إزالة التبعيات من Chart Widgets
2. **Provider Complexity**: تعقيد محاكاة Nested Providers
3. **Flutter Test Framework**: قيود إطار عمل Flutter Testing

### استراتيجيات التخفيف

1. **Architectural Separation**: فصل اختبارات Chart Widgets عن Dashboard Tests
2. **Comprehensive Mocking**: محاكاة شاملة لجميع التبعيات
3. **Incremental Testing**: اختبار تدريجي لكل مكون على حدة

## الخلاصة

هذا المشروع يهدف إلى حل مشكلة Timer Issues في اختبارات Dashboard من خلال
تطبيق Architectural Separation approach. النهج المقترح يحافظ على جودة
الاختبارات مع تجنب التعقيدات التقنية للـ Chart Widgets.

---

**تم إعداد هذا المستند بواسطة:** فريق وكلاء تطوير نظام بصير المحاسبي  
**آخر تحديث:** 12 يناير 2026  
**الحالة:** ✅ نشط ومعتمد
