# دليل سير عمل Git

## قبل بدء العمل

```bash
# تحديث وتجهيز
git fetch origin
git checkout develop
git pull origin develop

# إنشاء فرع جديد
git checkout -b feature/<ticket>-<description>
```

## أثناء العمل

### الالتزام المنتظم

```bash
git add <files>
git commit -m "<type>(<scope>): <description>"
```

### أنواع الالتزام

| النوع      | الوصف       |
| ---------- | ----------- |
| `feat`     | ميزة جديدة  |
| `fix`      | إصلاح خطأ   |
| `docs`     | توثيق       |
| `refactor` | إعادة هيكلة |
| `test`     | اختبارات    |
| `chore`    | صيانة       |

### مزامنة دورية (يومياً)

```bash
git fetch origin
git rebase origin/develop
```

## رفع التغييرات

```bash
# رفع أولي
git push -u origin feature/...

# رفع لاحق
git push

# بعد rebase
git push --force-with-lease
```

## فتح Pull Request

1. افتح GitHub → Pull Requests → New
2. Base: `develop` ← Compare: `feature/...`
3. املأ القالب
4. أضف Reviewers
5. انتظر CI + Review

## حل التعارضات

```bash
git fetch origin
git rebase origin/develop

# عند وجود تعارض:
# 1. افتح الملفات المتعارضة
# 2. ابحث عن <<<<<<< وحل الخلاف
# 3. احفظ واستمر:
git add <resolved-files>
git rebase --continue
```

## بعد الدمج

```bash
git checkout develop
git pull origin develop
git branch -d feature/...    # حذف محلي
```

## Hotfix (طوارئ)

```bash
git checkout main
git pull origin main
git checkout -b hotfix/PROD-001-critical

# إصلاح + التزام
git commit -m "fix: resolve critical issue"

# PR مباشر لـ main
git push -u origin hotfix/PROD-001-critical

# بعد الدمج في main، دمج إلى develop أيضاً
```

---

**الإصدار:** 1.0 | **التاريخ:** 2026-01-08
