# دليل أتمتة Git الاحترافي

**المشروع:** بصير MVP  
**التاريخ:** 3 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ نشط ومعتمد

---

## 📋 نظرة عامة

نظام أتمتة Git احترافي يوفر:

- ✅ كوميتات ذكية تلقائية
- ✅ فحوصات جودة قبل الدفع
- ✅ رسائل كوميت موحدة (Conventional Commits)
- ✅ تحليل تلقائي للتغييرات
- ✅ منع دفع الأسرار
- ✅ تقارير تفصيلية

---

## 🎯 الأوامر المتاحة

### 1. الكوميت الذكي

```bash
# كوميت تلقائي (يحلل التغييرات)
./.kiro/automation/git/smart-commit.sh

# كوميت مع نوع محدد
./.kiro/automation/git/smart-commit.sh feat code "إضافة ميزة جديدة"

# كوميت توثيق
./.kiro/automation/git/smart-commit.sh docs documentation "تحديث التوثيق"
```

### 2. الدفع الذكي

```bash
# دفع مع فحوصات كاملة
./.kiro/automation/git/smart-push.sh

# دفع سريع (بدون اختبارات)
SKIP_TESTS=true ./.kiro/automation/git/smart-push.sh
```

### 3. الكوميت والدفع معاً

```bash
# كوميت ودفع في خطوة واحدة
./.kiro/automation/git/commit-and-push.sh "رسالة الكوميت"
```

---

## 📝 أنواع الكوميت (Conventional Commits)

### الأنواع المدعومة

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

### النطاقات (Scopes)

| النطاق          | الوصف          |
| :-------------- | :------------- |
| `code`          | كود التطبيق    |
| `ui`            | واجهة المستخدم |
| `auth`          | المصادقة       |
| `database`      | قاعدة البيانات |
| `api`           | API            |
| `config`        | الإعدادات      |
| `workspace`     | Kiro Workspace |
| `documentation` | التوثيق        |
| `testing`       | الاختبارات     |

---

## 🔍 الفحوصات التلقائية

### 1. فحص التنسيق

```bash
flutter format --set-exit-if-changed .
```

- يتحقق من تنسيق الكود
- يطبق التنسيق تلقائياً إذا لزم الأمر

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
- يحذر إذا فشلت (لا يمنع الدفع)

### 4. فحص الأسرار

```bash
git diff --cached | grep -iE '(api[_-]?key|password|secret|token)'
```

- يبحث عن أسرار محتملة
- يمنع الدفع إذا وجدت أسرار

---

## 🤖 التحليل التلقائي

### كيف يعمل؟

النظام يحلل الملفات المتغيرة ويحدد:

1. **نوع التغيير:**

   - ملفات `.dart` → `feat` أو `fix`
   - ملفات `.md` → `docs`
   - ملفات `.yaml` → `chore`
   - ملفات test → `test`

2. **النطاق:**

   - `lib/features/auth/` → `auth`
   - `lib/core/` → `core`
   - `.kiro/` → `workspace`
   - `test/` → `testing`

3. **الوصف:**
   - يولد وصف مناسب تلقائياً
   - يمكن تخصيصه يدوياً

---

## 📊 التقارير

### موقع التقارير

```
.kiro/analytics/reports/git/
├── push-20251203-143022.md
├── push-20251203-150145.md
└── ...
```

### محتوى التقرير

- التاريخ والوقت
- hash الكوميت
- الفرع
- نوع التغيير
- الملفات المتغيرة
- الإحصائيات (إضافات/حذف)
- الحالة (نجح/فشل)

---

## 🔧 الإعدادات المتقدمة

### تخطي الاختبارات

```bash
SKIP_TESTS=true ./.kiro/automation/git/smart-push.sh
```

### تخطي الفحوصات (غير موصى به)

```bash
SKIP_CHECKS=true ./.kiro/automation/git/smart-push.sh
```

### دفع قسري (خطر!)

```bash
FORCE_PUSH=true ./.kiro/automation/git/smart-push.sh
```

---

## 🎓 أفضل الممارسات

### 1. كوميتات صغيرة ومتكررة

```bash
# ✅ جيد
git commit -m "feat(auth): إضافة validation للبريد"
git commit -m "feat(auth): إضافة error handling"

# ❌ سيء
git commit -m "تحديثات كثيرة"
```

### 2. رسائل واضحة

```bash
# ✅ جيد
feat(ui): إصلاح overflow في StatCard

# ❌ سيء
fix: إصلاح
```

### 3. فحص قبل الدفع

```bash
# دائماً استخدم smart-push
./.kiro/automation/git/smart-push.sh

# بدلاً من
git push  # قد يدفع كود معطوب
```

### 4. مراجعة التغييرات

```bash
# قبل الكوميت
git status
git diff

# بعد الكوميت
git log -1
git show HEAD
```

---

## 🚨 حالات الطوارئ

### 1. تراجع عن آخر كوميت

```bash
# تراجع مع الاحتفاظ بالتغييرات
git reset --soft HEAD~1

# تراجع وحذف التغييرات
git reset --hard HEAD~1
```

### 2. تعديل آخر كوميت

```bash
# تعديل الرسالة
git commit --amend -m "رسالة جديدة"

# إضافة ملفات منسية
git add forgotten-file.dart
git commit --amend --no-edit
```

### 3. إلغاء دفع

```bash
# إذا لم يسحب أحد بعد
git push --force-with-lease
```

### 4. حل تعارضات

```bash
# سحب مع rebase
git pull --rebase

# حل التعارضات
# ... تعديل الملفات ...
git add .
git rebase --continue
```

---

## 📚 أمثلة عملية

### مثال 1: إضافة ميزة جديدة

```bash
# 1. إنشاء فرع
git checkout -b feature/new-dashboard

# 2. تطوير الميزة
# ... كتابة الكود ...

# 3. كوميت ذكي
./.kiro/automation/git/smart-commit.sh feat dashboard "إضافة لوحة تحكم جديدة"

# 4. دفع ذكي
./.kiro/automation/git/smart-push.sh

# 5. إنشاء PR
gh pr create --title "feat(dashboard): إضافة لوحة تحكم جديدة"
```

### مثال 2: إصلاح خطأ

```bash
# 1. إنشاء فرع hotfix
git checkout -b hotfix/overflow-fix

# 2. إصلاح الخطأ
# ... تعديل الكود ...

# 3. كوميت
./.kiro/automation/git/smart-commit.sh fix ui "إصلاح overflow في StatCard"

# 4. دفع
./.kiro/automation/git/smart-push.sh

# 5. دمج مباشر
git checkout main
git merge hotfix/overflow-fix
git push
```

### مثال 3: تحديث توثيق

```bash
# 1. تعديل التوثيق
# ... تحديث README.md ...

# 2. كوميت تلقائي (يكتشف أنه docs)
./.kiro/automation/git/smart-commit.sh

# 3. دفع (يتخطى الاختبارات تلقائياً)
./.kiro/automation/git/smart-push.sh
```

---

## 🔗 التكامل مع الأدوات

### GitHub Actions

```yaml
name: Quality Gates

on: [push, pull_request]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter analyze
      - run: flutter test
```

### Pre-commit Hooks

```bash
# تثبيت
cp .kiro/automation/hooks/pre-commit/.git/hooks/

# تفعيل
chmod +x .git/hooks/pre-commit
```

### VS Code Tasks

```json
{
  "label": "Smart Push",
  "type": "shell",
  "command": "./.kiro/automation/git/smart-push.sh"
}
```

---

## 📈 المقاييس والتحليلات

### عرض الإحصائيات

```bash
# عدد الكوميتات
git rev-list --count HEAD

# المساهمون
git shortlog -sn

# الملفات الأكثر تعديلاً
git log --pretty=format: --name-only | sort | uniq -c | sort -rg | head -10

# النشاط الأخير
git log --oneline --graph --all --decorate -20
```

---

## ✅ قائمة التحقق

### قبل كل كوميت

- [ ] مراجعة التغييرات (`git diff`)
- [ ] اختبار محلي
- [ ] تحديث التوثيق إذا لزم
- [ ] رسالة كوميت واضحة

### قبل كل دفع

- [ ] جميع الاختبارات تنجح
- [ ] لا أخطاء في التحليل
- [ ] لا أسرار في الكود
- [ ] التنسيق صحيح

### قبل كل PR

- [ ] الفرع محدث مع main
- [ ] لا تعارضات
- [ ] وصف PR واضح
- [ ] مراجعة ذاتية

---

## 🎯 الخلاصة

نظام أتمتة Git هذا يوفر:

✅ **سرعة:** كوميت ودفع في ثوان  
✅ **جودة:** فحوصات تلقائية  
✅ **أمان:** منع دفع أسرار  
✅ **احترافية:** رسائل موحدة  
✅ **تتبع:** تقارير تفصيلية

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 3 ديسمبر 2025  
**الحالة:** ✅ نشط ومعتمد
