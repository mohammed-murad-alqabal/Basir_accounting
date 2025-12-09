# دليل Git الكامل

**المشروع:** بصير MVP  
**التاريخ:** 8 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ نشط

---

## 🎯 نظرة عامة

هذا الدليل يحتوي على جميع أفضل الممارسات والمعايير لاستخدام Git في مشروع بصير MVP.

---

## 📝 Commit Messages

### Conventional Commits

نستخدم معيار Conventional Commits لجميع الـ commits:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

#### الأنواع (Types)

| النوع      | الوصف          | مثال                                             |
| :--------- | :------------- | :----------------------------------------------- |
| `feat`     | ميزة جديدة     | `feat(customers): add search functionality`      |
| `fix`      | إصلاح خطأ      | `fix(invoices): resolve PDF export issue`        |
| `docs`     | تحديث التوثيق  | `docs(readme): update installation instructions` |
| `style`    | تنسيق الكود    | `style(customers): format code with dart format` |
| `refactor` | إعادة هيكلة    | `refactor(auth): simplify login logic`           |
| `test`     | إضافة اختبارات | `test(customers): add unit tests for repository` |
| `chore`    | مهام صيانة     | `chore(deps): update dependencies`               |
| `perf`     | تحسين الأداء   | `perf(invoices): optimize PDF generation`        |
| `ci`       | تحديث CI/CD    | `ci(workflows): add flutter analyze step`        |
| `build`    | تحديث البناء   | `build(android): update gradle version`          |

#### النطاق (Scope)

النطاق يحدد الجزء المتأثر من المشروع:

- `customers` - ميزة العملاء
- `invoices` - ميزة الفواتير
- `auth` - المصادقة
- `core` - المكونات الأساسية
- `ui` - واجهة المستخدم
- `db` - قاعدة البيانات
- `api` - الواجهة البرمجية

#### الوصف (Description)

- استخدم الفعل المضارع: "add" وليس "added"
- لا تبدأ بحرف كبير
- لا تنهي بنقطة
- كن واضحاً ومختصراً

#### أمثلة صحيحة

```bash
feat(customers): add customer search functionality
fix(invoices): resolve PDF export encoding issue
docs(readme): update installation instructions
style(customers): format code with dart format
refactor(auth): simplify login validation logic
test(customers): add unit tests for customer repository
chore(deps): update flutter to 3.24.0
perf(invoices): optimize invoice list rendering
ci(workflows): add code coverage reporting
build(android): update gradle to 8.0
```

#### أمثلة خاطئة

```bash
❌ Added customer search  # استخدم feat بدلاً من Added
❌ fix: bug in invoices   # أضف scope
❌ feat(customers): Add search.  # لا تبدأ بحرف كبير ولا تنهي بنقطة
❌ updated readme  # استخدم docs(readme): update
```

### Breaking Changes

للتغييرات الكبيرة، أضف `!` بعد النوع/النطاق:

```bash
feat(api)!: change customer API response format

BREAKING CHANGE: Customer API now returns nested address object
instead of flat fields. Update all API consumers accordingly.
```

---

## 🌿 Branching Strategy

### البنية الأساسية

```
main
├── feature/customer-search
├── feature/invoice-export
├── fix/pdf-encoding
└── hotfix/critical-bug
```

### أنواع الفروع

#### 1. main

- الفرع الرئيسي
- **دائماً مستقر** ✅
- يحتوي على كود جاهز للإنتاج
- محمي من الـ push المباشر

#### 2. feature/\*

للميزات الجديدة:

```bash
git checkout -b feature/customer-search
git checkout -b feature/invoice-export
git checkout -b feature/dark-mode
```

**القواعد:**

- تبدأ من `main`
- تُدمج في `main` عبر PR
- تُحذف بعد الدمج

#### 3. fix/\*

لإصلاح الأخطاء:

```bash
git checkout -b fix/pdf-encoding
git checkout -b fix/validation-error
git checkout -b fix/rtl-layout
```

**القواعد:**

- تبدأ من `main`
- تُدمج في `main` عبر PR
- تُحذف بعد الدمج

#### 4. hotfix/\*

للإصلاحات العاجلة:

```bash
git checkout -b hotfix/critical-security-issue
git checkout -b hotfix/data-loss-bug
```

**القواعد:**

- تبدأ من `main`
- تُدمج فوراً في `main`
- تتطلب مراجعة سريعة
- تُحذف بعد الدمج

#### 5. refactor/\*

لإعادة الهيكلة:

```bash
git checkout -b refactor/customer-repository
git checkout -b refactor/auth-logic
```

### سير العمل

#### إنشاء فرع جديد

```bash
# التأكد من أننا على main
git checkout main

# تحديث main
git pull origin main

# إنشاء فرع جديد
git checkout -b feature/customer-search

# العمل على الفرع
# ... تعديلات ...

# commit
git add .
git commit -m "feat(customers): add search functionality"

# push
git push origin feature/customer-search
```

#### دمج الفرع

```bash
# التأكد من تحديث main
git checkout main
git pull origin main

# دمج الفرع
git merge feature/customer-search

# push
git push origin main

# حذف الفرع المحلي
git branch -d feature/customer-search

# حذف الفرع البعيد
git push origin --delete feature/customer-search
```

---

## 🔍 Pull Requests

### قبل إنشاء PR

قائمة التحقق:

- [ ] جميع الاختبارات تنجح (`flutter test`)
- [ ] لا توجد أخطاء في التحليل (`flutter analyze`)
- [ ] الكود منسق (`dart format .`)
- [ ] التوثيق محدث
- [ ] CHANGELOG محدث
- [ ] لا توجد conflicts مع main

### قالب PR

```markdown
## الوصف

وصف موجز للتغييرات

## النوع

- [ ] ميزة جديدة
- [ ] إصلاح خطأ
- [ ] تحديث توثيق
- [ ] إعادة هيكلة
- [ ] تحسين أداء

## التغييرات

- تغيير 1
- تغيير 2
- تغيير 3

## الاختبارات

- [ ] Unit tests
- [ ] Widget tests
- [ ] Integration tests

## Screenshots (إن وجدت)

## الملاحظات

أي ملاحظات إضافية للمراجعين
```

### مراجعة PR

#### للمراجع

قائمة التحقق:

- [ ] الكود يتبع المعايير
- [ ] لا توجد مشاكل أمنية
- [ ] الاختبارات كافية
- [ ] التوثيق واضح
- [ ] الأداء مقبول

#### التعليقات

```markdown
# ✅ موافقة

LGTM! (Looks Good To Me)

# 💬 اقتراح

يمكن تحسين هذا الجزء باستخدام...

# ⚠️ مشكلة

هذا قد يسبب مشكلة في...

# ❌ رفض

يجب إصلاح... قبل الدمج
```

---

## 🔧 Git Hooks

### Pre-commit Hook

يتم تشغيله قبل كل commit:

```bash
#!/bin/bash
# .git/hooks/pre-commit

echo "Running pre-commit checks..."

# Format code
echo "Formatting code..."
dart format .

# Analyze code
echo "Analyzing code..."
flutter analyze
if [ $? -ne 0 ]; then
  echo "❌ Flutter analyze failed"
  exit 1
fi

# Run tests
echo "Running tests..."
flutter test
if [ $? -ne 0 ]; then
  echo "❌ Tests failed"
  exit 1
fi

echo "✅ Pre-commit checks passed"
exit 0
```

### Pre-push Hook

يتم تشغيله قبل كل push:

```bash
#!/bin/bash
# .git/hooks/pre-push

echo "Running pre-push checks..."

# Run all tests with coverage
echo "Running tests with coverage..."
flutter test --coverage
if [ $? -ne 0 ]; then
  echo "❌ Tests failed"
  exit 1
fi

# Check coverage threshold
echo "Checking coverage threshold..."
# ... coverage check logic ...

echo "✅ Pre-push checks passed"
exit 0
```

### تفعيل Hooks

```bash
# جعل الـ hooks قابلة للتنفيذ
chmod +x .git/hooks/pre-commit
chmod +x .git/hooks/pre-push

# أو استخدام Husky
npm install husky --save-dev
npx husky install
npx husky add .husky/pre-commit "flutter analyze && flutter test"
```

---

## 🏷️ Tags و Releases

### Semantic Versioning

نستخدم Semantic Versioning (SemVer):

```
MAJOR.MINOR.PATCH

مثال: 1.2.3
```

- **MAJOR**: تغييرات كبيرة (breaking changes)
- **MINOR**: ميزات جديدة (backward compatible)
- **PATCH**: إصلاحات (bug fixes)

### إنشاء Tag

```bash
# إنشاء tag
git tag -a v1.2.3 -m "Release version 1.2.3"

# push tag
git push origin v1.2.3

# push جميع الـ tags
git push origin --tags
```

### إنشاء Release

```bash
# على GitHub
1. اذهب إلى Releases
2. اضغط "Create a new release"
3. اختر tag
4. أضف release notes
5. أضف الملفات (APK, IPA, etc.)
6. انشر
```

---

## 🔄 Git Workflow

### السيناريو 1: ميزة جديدة

```bash
# 1. إنشاء فرع
git checkout main
git pull origin main
git checkout -b feature/customer-search

# 2. العمل على الميزة
# ... تعديلات ...
git add .
git commit -m "feat(customers): add search functionality"

# 3. push
git push origin feature/customer-search

# 4. إنشاء PR على GitHub

# 5. بعد الموافقة والدمج
git checkout main
git pull origin main
git branch -d feature/customer-search
```

### السيناريو 2: إصلاح خطأ

```bash
# 1. إنشاء فرع
git checkout main
git pull origin main
git checkout -b fix/pdf-encoding

# 2. إصلاح الخطأ
# ... تعديلات ...
git add .
git commit -m "fix(invoices): resolve PDF encoding issue"

# 3. push
git push origin fix/pdf-encoding

# 4. إنشاء PR

# 5. بعد الدمج
git checkout main
git pull origin main
git branch -d fix/pdf-encoding
```

### السيناريو 3: hotfix عاجل

```bash
# 1. إنشاء فرع
git checkout main
git pull origin main
git checkout -b hotfix/critical-bug

# 2. إصلاح المشكلة
# ... تعديلات ...
git add .
git commit -m "fix(auth)!: resolve critical security issue"

# 3. push ودمج فوري
git push origin hotfix/critical-bug
# مراجعة سريعة ودمج

# 4. تنظيف
git checkout main
git pull origin main
git branch -d hotfix/critical-bug
```

---

## ❌ الأخطاء الشائعة

### 1. Commit مباشر على main

```bash
# ❌ خطأ
git checkout main
git add .
git commit -m "changes"
git push origin main

# ✅ صحيح
git checkout -b feature/my-feature
git add .
git commit -m "feat: add feature"
git push origin feature/my-feature
# ثم PR
```

### 2. رسائل commit غير واضحة

```bash
# ❌ خطأ
git commit -m "fix"
git commit -m "update"
git commit -m "changes"

# ✅ صحيح
git commit -m "fix(invoices): resolve PDF export encoding issue"
git commit -m "feat(customers): add search functionality"
git commit -m "docs(readme): update installation instructions"
```

### 3. عدم تحديث main قبل إنشاء فرع

```bash
# ❌ خطأ
git checkout -b feature/my-feature
# العمل على فرع قديم!

# ✅ صحيح
git checkout main
git pull origin main
git checkout -b feature/my-feature
```

### 4. عدم حذف الفروع بعد الدمج

```bash
# ❌ خطأ
# ترك الفروع القديمة

# ✅ صحيح
git branch -d feature/old-feature
git push origin --delete feature/old-feature
```

---

## 💡 نصائح وحيل

### 1. Git Aliases

```bash
# إضافة aliases مفيدة
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.visual 'log --oneline --graph --all'

# استخدام
git co main
git br feature/my-feature
git ci -m "feat: add feature"
git st
```

### 2. Git Stash

```bash
# حفظ التغييرات مؤقتاً
git stash

# عرض الـ stashes
git stash list

# استرجاع آخر stash
git stash pop

# استرجاع stash محدد
git stash apply stash@{0}

# حذف stash
git stash drop stash@{0}
```

### 3. Git Rebase

```bash
# تحديث الفرع من main
git checkout feature/my-feature
git rebase main

# إذا حدثت conflicts
# ... حل الـ conflicts ...
git add .
git rebase --continue

# إلغاء rebase
git rebase --abort
```

### 4. Git Cherry-pick

```bash
# نقل commit محدد إلى فرع آخر
git checkout target-branch
git cherry-pick <commit-hash>
```

### 5. Git Bisect

```bash
# للبحث عن commit الذي سبب خطأ
git bisect start
git bisect bad  # الـ commit الحالي به خطأ
git bisect good <commit-hash>  # commit قديم بدون خطأ

# Git سيختبر commits تلقائياً
# بعد كل اختبار:
git bisect good  # أو
git bisect bad

# بعد الانتهاء
git bisect reset
```

---

## 📚 المراجع

### الوثائق الرسمية

- [Git Documentation](https://git-scm.com/doc)
- [GitHub Guides](https://guides.github.com)
- [Conventional Commits](https://www.conventionalcommits.org)
- [Semantic Versioning](https://semver.org)

### المعايير الداخلية

- `.kiro/steering/core/philosophy.md` - المبادئ الأساسية
- `.kiro/steering/standards/code-quality.md` - معايير الجودة
- `.kiro/steering/reference/best-practices.md` - أفضل الممارسات

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 8 ديسمبر 2025  
**الإصدار:** 1.0  
**الحالة:** ✅ نشط ومعتمد
