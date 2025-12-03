# نظام الأتمتة الاحترافي - Kiro Strategic Workspace

**المشروع:** بصير MVP  
**التاريخ:** 3 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ نشط ومعتمد

---

## 📋 نظرة عامة

نظام أتمتة شامل يوفر:

- 🤖 أتمتة Git (كوميت، دفع، hooks)
- 🔍 فحوصات جودة تلقائية
- 📊 تقارير تفصيلية
- 🚀 سير عمل احترافي
- 🔒 أمان وحماية

---

## 📁 البنية

```
.kiro/automation/
├── git/                    # أتمتة Git
│   ├── smart-commit.sh    # كوميت ذكي
│   ├── smart-push.sh      # دفع ذكي
│   ├── commit-and-push.sh # كوميت ودفع معاً
│   └── GIT_AUTOMATION_GUIDE.md
├── hooks/                  # Git Hooks
│   ├── pre-commit/        # قبل الكوميت
│   ├── pre-push/          # قبل الدفع
│   └── install-hooks.sh   # تثبيت الـ hooks
├── pipelines/             # CI/CD Pipelines
├── scripts/               # سكريبتات مساعدة
├── triggers/              # المحفزات
├── workflows/             # سير العمل
└── README.md              # هذا الملف
```

---

## 🚀 البدء السريع

### 1. تثبيت Git Hooks

```bash
./.kiro/automation/hooks/install-hooks.sh
```

### 2. كوميت ودفع ذكي

```bash
# كوميت ودفع في خطوة واحدة
./.kiro/automation/git/commit-and-push.sh "رسالة الكوميت"

# أو بشكل منفصل
./.kiro/automation/git/smart-commit.sh
./.kiro/automation/git/smart-push.sh
```

### 3. استخدام يومي

```bash
# بعد إجراء تغييرات
git status
./.kiro/automation/git/commit-and-push.sh

# سيقوم تلقائياً بـ:
# ✅ تحليل التغييرات
# ✅ فحص الجودة
# ✅ إنشاء كوميت
# ✅ الدفع
# ✅ إنشاء تقرير
```

---

## 🎯 الميزات الرئيسية

### 1. الكوميت الذكي

- ✅ تحليل تلقائي للتغييرات
- ✅ تحديد النوع والنطاق
- ✅ رسائل موحدة (Conventional Commits)
- ✅ توليد وصف تلقائي

### 2. الدفع الذكي

- ✅ فحص التنسيق
- ✅ فحص التحليل
- ✅ تشغيل الاختبارات
- ✅ فحص الأسرار
- ✅ منع دفع كود معطوب

### 3. Git Hooks

- ✅ Pre-commit: فحص قبل الكوميت
- ✅ Pre-push: فحص قبل الدفع
- ✅ Commit-msg: التحقق من الرسالة

### 4. التقارير

- ✅ تقارير تفصيلية لكل عملية
- ✅ إحصائيات دقيقة
- ✅ تتبع التغييرات

---

## 📝 أنواع الكوميت

| النوع      | الوصف       | مثال                              |
| :--------- | :---------- | :-------------------------------- |
| `feat`     | ميزة جديدة  | `feat(auth): إضافة تسجيل دخول`    |
| `fix`      | إصلاح خطأ   | `fix(ui): إصلاح overflow`         |
| `docs`     | توثيق       | `docs(readme): تحديث التوثيق`     |
| `style`    | تنسيق       | `style(code): تطبيق formatter`    |
| `refactor` | إعادة هيكلة | `refactor(core): تحسين البنية`    |
| `test`     | اختبارات    | `test(unit): إضافة اختبارات`      |
| `chore`    | مهام صيانة  | `chore(deps): تحديث dependencies` |
| `perf`     | تحسين أداء  | `perf(app): تحسين وقت البدء`      |
| `ci`       | CI/CD       | `ci(github): تحديث workflows`     |
| `build`    | بناء        | `build(gradle): تحديث إعدادات`    |

---

## 🔍 الفحوصات التلقائية

### 1. فحص التنسيق

```bash
flutter format --set-exit-if-changed .
```

- يتحقق من تنسيق الكود
- يطبق التنسيق تلقائياً

### 2. فحص التحليل

```bash
flutter analyze --no-pub
```

- يتحقق من أخطاء الكود
- يمنع الدفع إذا وجدت أخطاء

### 3. فحص الاختبارات

```bash
flutter test
```

- يشغل جميع الاختبارات
- يحذر إذا فشلت

### 4. فحص الأسرار

```bash
git diff --cached | grep -iE '(api[_-]?key|password|secret|token)'
```

- يبحث عن أسرار محتملة
- يمنع الدفع إذا وجدت

### 5. فحص حجم الملفات

- يحذر من الملفات الكبيرة (> 5MB)
- يمنع دفع ملفات ضخمة

---

## 🎓 أمثلة الاستخدام

### مثال 1: تطوير ميزة جديدة

```bash
# 1. إنشاء فرع
git checkout -b feature/new-feature

# 2. تطوير الميزة
# ... كتابة الكود ...

# 3. كوميت ودفع
./.kiro/automation/git/commit-and-push.sh "إضافة ميزة جديدة"

# النتيجة:
# ✅ feat(code): إضافة ميزة جديدة
# ✅ جميع الفحوصات نجحت
# ✅ تم الدفع بنجاح
```

### مثال 2: إصلاح خطأ

```bash
# 1. إصلاح الخطأ
# ... تعديل الكود ...

# 2. كوميت ودفع تلقائي
./.kiro/automation/git/commit-and-push.sh

# النظام يكتشف تلقائياً:
# ✅ النوع: fix
# ✅ النطاق: ui
# ✅ الوصف: إصلاح مشاكل في ui
```

### مثال 3: تحديث توثيق

```bash
# 1. تعديل التوثيق
# ... تحديث README.md ...

# 2. كوميت ودفع
./.kiro/automation/git/commit-and-push.sh

# النظام يكتشف:
# ✅ النوع: docs
# ✅ يتخطى الاختبارات تلقائياً
# ✅ دفع سريع
```

---

## ⚙️ الإعدادات المتقدمة

### تخطي الاختبارات

```bash
SKIP_TESTS=true ./.kiro/automation/git/commit-and-push.sh
```

### تخطي جميع الفحوصات (غير موصى به)

```bash
SKIP_CHECKS=true ./.kiro/automation/git/commit-and-push.sh
```

### تعطيل الـ hooks مؤقتاً

```bash
git commit --no-verify
git push --no-verify
```

---

## 📊 التقارير

### موقع التقارير

```
.kiro/analytics/reports/git/
├── commit-push-20251203-143022.md
├── commit-push-20251203-150145.md
└── push-20251203-152030.md
```

### محتوى التقرير

- التاريخ والوقت
- hash الكوميت
- الفرع
- نوع التغيير
- الملفات المتغيرة
- الإحصائيات
- حالة الفحوصات

---

## 🔧 الصيانة

### تحديث الـ hooks

```bash
./.kiro/automation/hooks/install-hooks.sh
```

### إزالة الـ hooks

```bash
rm .git/hooks/pre-commit
rm .git/hooks/pre-push
rm .git/hooks/commit-msg
```

### اختبار السكريبتات

```bash
# اختبار الكوميت الذكي
./.kiro/automation/git/smart-commit.sh --help

# اختبار الدفع الذكي
./.kiro/automation/git/smart-push.sh --help

# اختبار الكوميت والدفع
./.kiro/automation/git/commit-and-push.sh --help
```

---

## 🚨 استكشاف الأخطاء

### المشكلة: فشل فحص التحليل

```bash
# الحل: إصلاح الأخطاء
flutter analyze
# ... إصلاح الأخطاء ...
flutter analyze --no-pub
```

### المشكلة: فشلت الاختبارات

```bash
# الحل 1: إصلاح الاختبارات
flutter test

# الحل 2: تخطي الاختبارات مؤقتاً
SKIP_TESTS=true ./.kiro/automation/git/commit-and-push.sh
```

### المشكلة: اكتشاف أسرار

```bash
# الحل: إزالة الأسرار من الكود
# 1. مراجعة التغييرات
git diff

# 2. إزالة الأسرار
# ... تعديل الملفات ...

# 3. المحاولة مرة أخرى
./.kiro/automation/git/commit-and-push.sh
```

### المشكلة: فشل الدفع

```bash
# الحل: سحب التغييرات أولاً
git pull --rebase
./.kiro/automation/git/smart-push.sh
```

---

## 📚 الوثائق الإضافية

- [دليل أتمتة Git](.kiro/automation/git/GIT_AUTOMATION_GUIDE.md)
- [معايير Git](../../steering/git-best-practices.md)
- [Conventional Commits](https://www.conventionalcommits.org/)

---

## ✅ قائمة التحقق

### قبل البدء

- [ ] تثبيت Git Hooks
- [ ] قراءة الدليل
- [ ] فهم أنواع الكوميت

### الاستخدام اليومي

- [ ] مراجعة التغييرات
- [ ] استخدام الكوميت الذكي
- [ ] التحقق من التقارير

### الصيانة الدورية

- [ ] تحديث الـ hooks
- [ ] مراجعة التقارير
- [ ] تحسين السكريبتات

---

## 🎯 الخلاصة

نظام الأتمتة هذا يوفر:

✅ **سرعة:** كوميت ودفع في ثوان  
✅ **جودة:** فحوصات تلقائية شاملة  
✅ **أمان:** منع دفع أسرار وكود معطوب  
✅ **احترافية:** رسائل موحدة ومنظمة  
✅ **تتبع:** تقارير تفصيلية لكل عملية  
✅ **سهولة:** أوامر بسيطة وواضحة

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 3 ديسمبر 2025  
**الحالة:** ✅ نشط ومعتمد ومفعّل

---

## 🙏 المساهمة

لتحسين نظام الأتمتة:

1. اقتراح تحسينات
2. الإبلاغ عن مشاكل
3. إضافة ميزات جديدة
4. تحديث التوثيق

---

**ملاحظة:** هذا النظام مصمم خصيصاً لمشروع بصير MVP ويمكن تخصيصه حسب الحاجة.
