# Git Hooks - Error Tracking System

**المشروع:** بصير MVP  
**التاريخ:** 3 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير

---

## الـ Hooks المتوفرة

### 1. Pre-commit Hook

يتم تشغيله قبل كل commit ويقوم بـ:

- ✅ فحص تنسيق الكود (Flutter Format)
- ✅ تشغيل التحليل الثابت (Flutter Analyze)
- ✅ التنسيق التلقائي (اختياري)
- ✅ حفظ نتائج التحليل في السجلات

### 2. Commit-msg Hook

يتم تشغيله للتحقق من رسالة الـ commit:

- ✅ التحقق من صيغة Conventional Commits
- ✅ التأكد من وجود type صحيح
- ✅ عرض أمثلة عند الفشل

### 3. Pre-push Hook

يتم تشغيله قبل كل push ويقوم بـ:

- ✅ تشغيل جميع الاختبارات
- ✅ فحص الأسرار المكشوفة
- ✅ منع push عند وجود مشاكل

---

## التثبيت

```bash
# تثبيت جميع الـ hooks
./scripts/install_hooks.sh
```

---

## التكوين

يمكن تكوين الـ hooks من ملف `.kiro/config/error_tracking.yml`:

```yaml
hooks:
  pre_commit:
    enabled: true
    auto_format: true
    block_on_errors: true
    max_execution_time: 30

  pre_push:
    enabled: true
    run_tests: true
    scan_secrets: true
    max_execution_time: 120
```

---

## تعطيل مؤقت

### تعطيل لـ commit واحد

```bash
git commit --no-verify -m "message"
```

### تعطيل لـ push واحد

```bash
git push --no-verify
```

---

## استكشاف الأخطاء

### المشكلة: Hook لا يعمل

**الحل:** تأكد من أن الملف قابل للتنفيذ

```bash
chmod +x .git/hooks/pre-commit
```

### المشكلة: Flutter Analyze يفشل

**الحل:** قم بإصلاح الأخطاء أو تعطيل block_on_errors مؤقتاً

### المشكلة: رسالة commit مرفوضة

**الحل:** استخدم صيغة Conventional Commits:

```
type(scope): description
```

---

## Conventional Commits

### الأنواع المسموحة

| Type       | الوصف       | مثال                        |
| :--------- | :---------- | :-------------------------- |
| `feat`     | ميزة جديدة  | `feat(auth): add login`     |
| `fix`      | إصلاح خطأ   | `fix(invoice): correct tax` |
| `docs`     | توثيق       | `docs: update README`       |
| `style`    | تنسيق       | `style: format code`        |
| `refactor` | إعادة هيكلة | `refactor(core): simplify`  |
| `test`     | اختبارات    | `test: add unit tests`      |
| `chore`    | صيانة       | `chore(logs): update`       |
| `perf`     | أداء        | `perf: optimize query`      |
| `ci`       | CI/CD       | `ci: update workflow`       |
| `build`    | بناء        | `build: update deps`        |
| `audit`    | تدقيق وحوكمة وضوابط | `audit(ledger): verify controls` |

---

**ملاحظة:** الـ hooks تعمل تلقائياً بعد التثبيت ولا تحتاج لتدخل يدوي.
