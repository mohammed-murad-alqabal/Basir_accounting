# Requirements Document - نظام تتبع الأخطاء والسجلات

**المشروع:** بصير MVP  
**التاريخ:** 3 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الإصدار:** 1.0  
**الحالة:** ✅ نشط

---

## Introduction

نظام تتبع الأخطاء والسجلات هو منظومة متكاملة لإدارة، تسجيل، تحليل، وتوثيق الأخطاء والمشكلات في مشروع بصير MVP. يهدف النظام إلى ضمان جودة عالية للكود، تتبع دقيق للمشكلات، وأتمتة كاملة لعملية الإبلاغ والمعالجة من خلال Git Hooks، GitHub Actions، وأدوات التحليل الآلي.

## Glossary

- **Error Tracking System (نظام تتبع الأخطاء)**: منظومة متكاملة لإدارة وتتبع الأخطاء والمشكلات في المشروع
- **Log Collection (جمع السجلات)**: عملية تجميع وتنظيم سجلات التطبيق والأخطاء بشكل تلقائي
- **Git Hooks (خطافات Git)**: سكريبتات تُنفذ تلقائياً عند أحداث Git محددة (commit، push)
- **GitHub Actions (إجراءات GitHub)**: نظام أتمتة CI/CD المدمج في GitHub
- **Issue Template (قالب Issue)**: نموذج موحد ومنظم لإنشاء Issues على GitHub
- **Conventional Commits (الالتزامات التقليدية)**: معيار موحد لكتابة رسائل commit بصيغة محددة
- **Flutter Analyze (تحليل Flutter)**: أداة فحص جودة كود Dart/Flutter المدمجة في Flutter SDK
- **Coverage Report (تقرير التغطية)**: تقرير يوضح نسبة الكود المغطى بالاختبارات
- **Archive (الأرشيف)**: مجلد لتخزين السجلات القديمة بشكل مضغوط
- **Semantic Versioning (الترقيم الدلالي)**: نظام ترقيم الإصدارات بصيغة MAJOR.MINOR.PATCH
- **Pre-commit Hook (خطاف ما قبل الالتزام)**: سكريبت يُنفذ قبل إتمام عملية commit
- **Pre-push Hook (خطاف ما قبل الدفع)**: سكريبت يُنفذ قبل إتمام عملية push
- **Workflow (سير العمل)**: مجموعة من الإجراءات المؤتمتة في GitHub Actions
- **Artifact (الأثر)**: ملف ناتج عن تنفيذ workflow يتم حفظه للمراجعة

## Requirements

### Requirement 1: تسجيل الأخطاء التلقائي

**User Story:** كمطور، أريد نظام تسجيل تلقائي للأخطاء، حتى أتمكن من تتبع جميع المشكلات دون تدخل يدوي.

#### Acceptance Criteria

1. WHEN Flutter Analyze يُنفذ، THEN THE Error Tracking System SHALL يجمع جميع الأخطاء والتحذيرات في ملف سجل منظم
2. WHEN الاختبارات تُنفذ، THEN THE Error Tracking System SHALL يسجل نتائج جميع الاختبارات مع التفاصيل الكاملة
3. WHEN خطأ يُكتشف، THEN THE Error Tracking System SHALL يحفظ معلومات كاملة تتضمن النوع والرسالة واسم الملف ورقم السطر والوقت
4. WHEN سجل جديد يُنشأ، THEN THE Error Tracking System SHALL يضيف timestamp دقيق وmetadata كاملة للسجل
5. WHEN أخطاء متعددة متشابهة تحدث، THEN THE Error Tracking System SHALL يمنع التكرار ويجمع الأخطاء المتشابهة في مجموعة واحدة

### Requirement 2: إنشاء التقارير الشاملة

**User Story:** كمدير مشروع، أريد تقارير شاملة يومية، حتى أتمكن من متابعة صحة المشروع واتخاذ قرارات مستنيرة.

#### Acceptance Criteria

1. WHEN يوم جديد يبدأ، THEN THE Error Tracking System SHALL ينشئ تقرير يومي شامل بصيغة Markdown
2. WHEN تقرير يُنشأ، THEN THE Error Tracking System SHALL يتضمن إحصائيات المشروع الكاملة (عدد الملفات، الحجم الإجمالي، عدد Commits)
3. WHEN تقرير يُنشأ، THEN THE Error Tracking System SHALL يتضمن ملخص تفصيلي للأخطاء والتحذيرات مع التصنيف
4. WHEN تقرير يُنشأ، THEN THE Error Tracking System SHALL يتضمن نتائج الاختبارات ونسبة التغطية الحالية
5. WHEN تقرير يُنشأ، THEN THE Error Tracking System SHALL يقدم توصيات قابلة للتنفيذ للتحسين بناءً على تحليل البيانات

### Requirement 3: Git Hooks للتحقق من الجودة

**User Story:** كمطور، أريد فحوصات تلقائية قبل commit وpush، حتى أضمن عدم دفع كود معيب.

#### Acceptance Criteria

1. WHEN مطور يحاول commit، THEN THE Pre-commit Hook SHALL يتحقق من تنسيق الكود باستخدام Flutter Format
2. WHEN مطور يحاول commit، THEN THE Pre-commit Hook SHALL يشغل Flutter Analyze ويمنع commit عند وجود أخطاء حرجة
3. WHEN مطور يحاول commit، THEN THE Pre-commit Hook SHALL يتحقق من صحة رسالة commit وفقاً لمعيار Conventional Commits
4. WHEN مطور يحاول push، THEN THE Pre-push Hook SHALL يشغل جميع الاختبارات ويمنع push عند فشل أي اختبار
5. WHEN مطور يحاول push، THEN THE Pre-push Hook SHALL يفحص الكود عن الأسرار المكشوفة ويمنع push عند اكتشاف أي سر

### Requirement 4: GitHub Actions للتحليل المستمر

**User Story:** كفريق تطوير، نريد تحليل مستمر للكود على GitHub، حتى نضمن جودة عالية في جميع الأوقات.

#### Acceptance Criteria

1. WHEN push يحدث إلى فرع main أو develop، THEN THE GitHub Actions Workflow SHALL يشغل Flutter Analyze تلقائياً
2. WHEN push يحدث إلى أي فرع، THEN THE GitHub Actions Workflow SHALL يشغل جميع الاختبارات ويحسب نسبة التغطية
3. WHEN أخطاء حرجة تُكتشف في التحليل، THEN THE GitHub Actions Workflow SHALL ينشئ Issue تلقائياً على GitHub مع التفاصيل الكاملة
4. WHEN Pull Request يُنشأ، THEN THE GitHub Actions Workflow SHALL يضيف تعليق يحتوي على ملخص جودة الكود ونتائج الاختبارات
5. WHEN workflow يكتمل بنجاح، THEN THE GitHub Actions Workflow SHALL يحفظ جميع التقارير كـ artifacts قابلة للتحميل

### Requirement 5: إدارة السجلات والأرشفة

**User Story:** كمدير نظام، أريد إدارة فعالة للسجلات، حتى لا تتراكم الملفات وتستهلك المساحة.

#### Acceptance Criteria

1. WHEN سجلات عمرها أكثر من 7 أيام، THEN THE Error Tracking System SHALL ينقلها تلقائياً إلى مجلد الأرشيف
2. WHEN حجم الأرشيف يتجاوز 10 ميجابايت، THEN THE Error Tracking System SHALL يضغط السجلات في ملف tar.gz واحد
3. WHEN عملية أرشفة تحدث، THEN THE Error Tracking System SHALL يحتفظ بالسجلات الحديثة (أقل من 7 أيام) في مكانها الأصلي
4. WHEN سجلات قديمة تُحذف من المجلد الأصلي، THEN THE Error Tracking System SHALL يحتفظ بنسخة مضغوطة منها في الأرشيف
5. WHEN مستخدم يطلب استخراج سجل قديم، THEN THE Error Tracking System SHALL يوفر أمر بسيط لفك ضغط واستخراج السجل المطلوب

### Requirement 6: دفع السجلات إلى Git

**User Story:** كفريق، نريد حفظ السجلات في Git، حتى نتمكن من تتبع تاريخ المشكلات والتحسينات.

#### Acceptance Criteria

1. WHEN سكريبت جمع السجلات يُنفذ مع خيار --push، THEN THE Error Tracking System SHALL يضيف جميع السجلات الجديدة إلى Git staging area
2. WHEN commit للسجلات يُنشأ، THEN THE Error Tracking System SHALL يستخدم رسالة موحدة بصيغة Conventional Commits (مثل: "chore(logs): update logs")
3. WHEN commit للسجلات يُنشأ، THEN THE Error Tracking System SHALL يضيف [skip ci] في رسالة الـ commit لتجنب تشغيل workflows غير ضرورية
4. WHEN عملية push تفشل لأي سبب، THEN THE Error Tracking System SHALL يعرض رسالة تحذير للمستخدم دون إيقاف العملية بالكامل
5. WHEN لا توجد تغييرات جديدة في السجلات، THEN THE Error Tracking System SHALL يتخطى عملية الـ commit والـ push ويعرض رسالة إعلامية

### Requirement 7: Issue Templates الموحدة

**User Story:** كمساهم، أريد قوالب موحدة للـ Issues، حتى أتمكن من الإبلاغ عن المشكلات بشكل منظم.

#### Acceptance Criteria

1. WHEN مستخدم ينشئ Issue جديد على GitHub، THEN THE Error Tracking System SHALL يعرض قوالب متعددة (Bug Report، Feature Request، Code Quality)
2. WHEN قالب Bug Report يُستخدم، THEN THE Issue Template SHALL يطلب حقول إلزامية (الوصف، خطوات الإعادة، السلوك المتوقع، معلومات البيئة)
3. WHEN قالب Feature Request يُستخدم، THEN THE Issue Template SHALL يطلب حقول إلزامية (الوصف، المشكلة المراد حلها، الحل المقترح، الأولوية)
4. WHEN Issue يُنشأ من أي قالب، THEN THE GitHub System SHALL يضيف labels تلقائياً بناءً على نوع القالب المستخدم
5. WHEN Issue يُنشأ تلقائياً بواسطة GitHub Actions، THEN THE Error Tracking System SHALL يضيف label "automated" للتمييز

### Requirement 8: التوثيق الشامل

**User Story:** كمطور جديد، أريد توثيق شامل للنظام، حتى أتمكن من فهم واستخدام جميع الأدوات بسهولة.

#### Acceptance Criteria

1. WHEN مطور يبحث عن دليل نظام تتبع الأخطاء، THEN THE Error Tracking System SHALL يوفر ملف ERROR_TRACKING_GUIDE.md شامل في مجلد Documentation
2. WHEN مطور يبحث عن دليل Git وGitHub، THEN THE Error Tracking System SHALL يوفر ملف GIT_GITHUB_GUIDE.md مفصل يشرح جميع العمليات
3. WHEN مطور يقرأ أي دليل، THEN THE Documentation SHALL يتضمن أمثلة عملية قابلة للتنفيذ وأوامر جاهزة للنسخ
4. WHEN مشكلة شائعة تحدث، THEN THE Documentation SHALL يوفر قسم "استكشاف الأخطاء وإصلاحها" مع حلول واضحة
5. WHEN دليل يُحدث، THEN THE Documentation SHALL يضيف تاريخ التحديث الأخير ورقم الإصدار في رأس الملف

### Requirement 9: الأمان والخصوصية

**User Story:** كمدير أمان، أريد ضمان عدم تسريب معلومات حساسة، حتى نحافظ على أمان المشروع.

#### Acceptance Criteria

1. WHEN سجل جديد يُنشأ، THEN THE Error Tracking System SHALL يفحص المحتوى ويزيل تلقائياً أي معلومات حساسة (كلمات المرور، الرموز، المفاتيح السرية)
2. WHEN pre-push hook يُنفذ، THEN THE Pre-push Hook SHALL يفحص جميع الملفات المعدلة عن أنماط الأسرار المكشوفة باستخدام regex patterns
3. WHEN سر مكشوف يُكتشف في الكود، THEN THE Pre-push Hook SHALL يمنع عملية push ويعرض رسالة تحذير واضحة للمطور مع موقع السر
4. WHEN ملف .gitignore يُحدث، THEN THE Error Tracking System SHALL يتضمن جميع أنواع الملفات الحساسة (مفاتيح، شهادات، ملفات بيئة)
5. WHEN سجلات تُدفع إلى Git، THEN THE Error Tracking System SHALL يتحقق مسبقاً من عدم احتواء السجلات على أي بيانات حساسة

### Requirement 10: الأداء والكفاءة

**User Story:** كمطور، أريد أن تكون الفحوصات سريعة، حتى لا تعيق سير العمل.

#### Acceptance Criteria

1. WHEN pre-commit hook يُنفذ، THEN THE Pre-commit Hook SHALL يكمل جميع الفحوصات في أقل من 30 ثانية
2. WHEN pre-push hook يُنفذ، THEN THE Pre-push Hook SHALL يكمل جميع الاختبارات والفحوصات في أقل من دقيقتين
3. WHEN سكريبت جمع السجلات يُنفذ، THEN THE Log Collection Script SHALL يكمل عملية الجمع والتنظيم في أقل من دقيقة واحدة
4. WHEN عملية أرشفة تحدث، THEN THE Error Tracking System SHALL يستخدم خوارزمية ضغط فعالة (gzip) لتقليل حجم الملفات بنسبة 70% على الأقل
5. WHEN عمليات متعددة تُنفذ بشكل متكرر، THEN THE Error Tracking System SHALL يستخدم آلية caching ذكية لتحسين الأداء وتقليل وقت التنفيذ

---

**تم إعداد هذه الوثيقة بواسطة:** فريق وكلاء تطوير مشروع بصير  
**آخر تحديث:** 3 ديسمبر 2025
