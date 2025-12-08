# Git Hooks - Enhanced v2.0

**المشروع:** بصير MVP  
**التاريخ:** 8 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ نشط

---

## نظرة عامة

هذا المجلد يحتوي على Git hooks محسّنة تطبق المبادئ الخمسة:

- ✅ COLLABORATION FIRST
- ✅ KISS
- ✅ Security First
- ✅ Quality First
- ✅ ENGLISH FOR CODE

---

## الـ Hooks المتاحة

### 1. pre-commit

**الوصف:** يتم تشغيله قبل كل commit

**الفحوصات:**

- ✅ Code formatting (dart format)
- ✅ Static analysis (flutter analyze)
- ✅ Hardcoded secrets detection
- ✅ Commit message format
- ✅ English code validation
- ✅ KISS principle check (function complexity)

**الاستخدام:**

```bash
# يتم تشغيله تلقائياً عند:
git commit -m "feat: add feature"
```

### 2. pre-push

**الوصف:** يتم تشغيله قبل كل push

**الفحوصات:**

- ✅ All tests (flutter test)
- ✅ Test coverage (70%+ recommended)
- ✅ Static analysis (flutter analyze)
- ✅ Critical TODOs check
- ✅ Debug code detection
- ✅ Branch protection warning
- ✅ Sensitive files detection

**الاستخدام:**

```bash
# يتم تشغيله تلقائياً عند:
git push origin feature-branch
```

---

## التثبيت

### الطريقة 1: تثبيت يدوي

```bash
# نسخ الـ hooks إلى .git/hooks
cp .githooks/pre-commit .git/hooks/pre-commit
cp .githooks/pre-push .git/hooks/pre-push

# جعلها قابلة للتنفيذ
chmod +x .git/hooks/pre-commit
chmod +x .git/hooks/pre-push
```

### الطريقة 2: تكوين Git

```bash
# تكوين Git لاستخدام .githooks
git config core.hooksPath .githooks

# جعل الـ hooks قابلة للتنفيذ
chmod +x .githooks/pre-commit
chmod +x .githooks/pre-push
```

### الطريقة 3: استخدام Husky (اختياري)

```bash
# تثبيت Husky
npm install husky --save-dev

# تفعيل Husky
npx husky install

# إضافة الـ hooks
npx husky add .husky/pre-commit "bash .githooks/pre-commit"
npx husky add .husky/pre-push "bash .githooks/pre-push"
```

---

## التحقق من التثبيت

```bash
# التحقق من pre-commit
.githooks/pre-commit

# التحقق من pre-push
.githooks/pre-push
```

---

## تخطي الـ Hooks (للحالات الطارئة فقط)

```bash
# تخطي pre-commit
git commit --no-verify -m "message"

# تخطي pre-push
git push --no-verify
```

**⚠️ تحذير:** استخدم `--no-verify` فقط في الحالات الطارئة!

---

## التخصيص

### تعديل الفحوصات

يمكنك تعديل الـ hooks حسب احتياجات مشروعك:

```bash
# تعديل pre-commit
nano .githooks/pre-commit

# تعديل pre-push
nano .githooks/pre-push
```

### إضافة فحوصات جديدة

أضف فحوصاتك الخاصة في نهاية كل hook:

```bash
# مثال: إضافة فحص مخصص
print_header "🔍 Custom Check"
print_message "$BLUE" "Running custom check..."

# Your custom check here

print_message "$GREEN" "✅ Custom check passed"
```

---

## استكشاف الأخطاء

### المشكلة: الـ hook لا يعمل

**الحل:**

```bash
# تأكد من أن الملف قابل للتنفيذ
chmod +x .githooks/pre-commit
chmod +x .githooks/pre-push

# تأكد من التكوين
git config core.hooksPath .githooks
```

### المشكلة: Flutter not found

**الحل:**

```bash
# تأكد من تثبيت Flutter
flutter --version

# أضف Flutter إلى PATH
export PATH="$PATH:/path/to/flutter/bin"
```

### المشكلة: الـ hook بطيء جداً

**الحل:**

- قلل عدد الفحوصات
- استخدم `--no-verify` للـ commits السريعة (غير موصى به)
- حسّن الفحوصات المخصصة

---

## أفضل الممارسات

### 1. اختبر الـ Hooks محلياً

```bash
# اختبر قبل الـ commit
.githooks/pre-commit

# اختبر قبل الـ push
.githooks/pre-push
```

### 2. حافظ على الـ Hooks بسيطة (KISS)

- ركز على الفحوصات الأساسية
- تجنب الفحوصات المعقدة
- استخدم CI/CD للفحوصات الثقيلة

### 3. وثّق التغييرات

- أضف تعليقات واضحة
- حدّث هذا الملف عند إضافة فحوصات جديدة

### 4. شارك مع الفريق

- تأكد من أن جميع المطورين يستخدمون نفس الـ hooks
- وثّق عملية التثبيت

---

## المتطلبات

### الأساسية

- Git 2.0+
- Bash 4.0+
- Flutter SDK 3.24.0+

### الاختيارية (للفحوصات المتقدمة)

- lcov (لحساب التغطية)
- bc (للحسابات)

**التثبيت:**

```bash
# Linux
sudo apt-get install lcov bc

# macOS
brew install lcov bc
```

---

## الأمثلة

### مثال 1: Commit ناجح

```bash
$ git commit -m "feat(customers): add search functionality"

==================================================
🔍 Pre-Commit Hook v2.0
==================================================

Running pre-commit checks...

==================================================
📝 Code Formatting
==================================================

Checking code formatting...
✅ Code formatting OK

==================================================
🔍 Static Analysis
==================================================

Running flutter analyze...
✅ Static analysis passed

==================================================
🔒 Security Checks
==================================================

Checking for hardcoded secrets...
✅ No hardcoded secrets found

==================================================
✅ Pre-Commit Checks Passed!
==================================================

🎉 All checks passed!
📝 Proceeding with commit...
```

### مثال 2: Commit فاشل (formatting issues)

```bash
$ git commit -m "add feature"

==================================================
📝 Code Formatting
==================================================

Checking code formatting...
⚠️  Code formatting issues found. Auto-formatting...
✅ Code formatted. Please review and commit again.
```

---

## المراجع

### الوثائق الرسمية

- [Git Hooks Documentation](https://git-scm.com/docs/githooks)
- [Husky Documentation](https://typicode.github.io/husky/)

### المعايير الداخلية

- `.kiro/steering/core/philosophy.md` - المبادئ الأساسية
- `.kiro/steering/guides/git-guide.md` - دليل Git الكامل

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 8 ديسمبر 2025  
**الإصدار:** 2.0  
**الحالة:** ✅ نشط ومعتمد
