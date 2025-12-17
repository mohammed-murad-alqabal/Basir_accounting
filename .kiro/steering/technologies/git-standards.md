---
id: "git-standards"
description: "معايير Git الشاملة للمشروع"
version: "1.0"
last_updated: "2025-12-17"
inclusion: always
author: "فريق وكلاء تطوير مشروع بصير"
metrics:
  size: "5KB"
  lines: 180
  context_usage: "2.5%"
---

# معايير Git الشاملة - بصير MVP

**المشروع:** بصير MVP  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 17 ديسمبر 2025  
**الحالة:** ✅ نشط

---

## 🌿 استراتيجية التفريع (Branching Strategy)

### تسمية الفروع

- **Feature branches**: `feature/description-of-feature`
- **Bug fixes**: `fix/description-of-bug`
- **Hotfixes**: `hotfix/critical-issue-description`
- **Releases**: `release/version-number`

### قواعد التفريع

- استخدام feature branches للتطوير الجديد
- الحفاظ على main/master مستقر ودائماً قابل للنشر
- استخدام أسماء وصفية (feature/user-auth, fix/login-bug)
- حذف الفروع المدمجة للحفاظ على نظافة المستودع

---

## 📝 تنسيق رسائل الـ Commit

### الصيغة القياسية

```
type(scope): description

[optional body]

[optional footer]
```

### الأنواع المتاحة

- **feat**: ميزة جديدة
- **fix**: إصلاح خطأ
- **docs**: تحديث التوثيق
- **style**: تنسيق الكود
- **refactor**: إعادة هيكلة
- **test**: إضافة اختبارات
- **chore**: مهام صيانة

### أفضل الممارسات

- السطر الأول أقل من 50 حرف
- استخدام صيغة الأمر ("Add feature" وليس "Added feature")
- إضافة body للتغييرات المعقدة
- الالتزام بالتنسيق الموحد

---

## 🔄 سير العمل (Workflow)

### قبل البدء

- سحب آخر التغييرات: `git pull origin main`
- إنشاء فرع جديد: `git checkout -b feature/my-feature`

### أثناء التطوير

- Commit بشكل متكرر مع أجزاء منطقية
- استخدام interactive rebase لتنظيف التاريخ
- مراجعة التغييرات قبل الـ commit

### قبل الدمج

- تشغيل جميع الاختبارات
- التأكد من نجاح flutter analyze
- مراجعة الكود مع الفريق

---

## 🔍 مراجعة الكود (Code Review)

### متطلبات Pull Request

- وصف واضح للتغييرات
- ربط القضايا المتعلقة (fixes #123)
- نجاح جميع الاختبارات
- موافقة واحدة على الأقل قبل الدمج

### معايير المراجعة

- جودة الكود والأمان والأداء
- تغطية الاختبارات للوظائف الجديدة
- تحديث التوثيق عند الحاجة
- عدم وجود تغييرات كاسرة بدون versioning مناسب

---

## 🗂️ إدارة المستودع

### .gitignore

- استبعاد build artifacts والأسرار
- استخدام Git LFS للملفات الكبيرة
- الحفاظ على حجم المستودع معقول

### الإصدارات (Versioning)

- استخدام semantic versioning للإصدارات
- وضع tags للإصدارات: `git tag v1.0.0`
- توثيق استراتيجية التفريع في README

---

## 🔒 الأمان

### قواعد إلزامية

- ❌ عدم commit الأسرار أو API keys أو كلمات المرور
- ✅ استخدام متغيرات البيئة للتكوين
- ✅ مراجعة الـ commits للمعلومات الحساسة
- ✅ استخدام signed commits عند الإمكان

### فحص الأمان

```bash
# فحص التاريخ للأسرار
git log -p | grep -i "password\|secret\|key"

# إزالة ملف من التاريخ
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch PATH-TO-FILE" \
  --prune-empty --tag-name-filter cat -- --all
```

---

## 🛠️ أوامر مفيدة

### التطوير اليومي

```bash
# إنشاء فرع جديد
git checkout -b feature/new-feature

# حفظ التغييرات
git add .
git commit -m "feat: add new feature"

# دفع الفرع
git push origin feature/new-feature

# تحديث من main
git fetch origin
git rebase origin/main
```

### التنظيف والصيانة

```bash
# حذف الفروع المدمجة
git branch --merged | grep -v "\*" | xargs -n 1 git branch -d

# تنظيف الفروع البعيدة
git remote prune origin

# ضغط المستودع
git gc --aggressive --prune=now
```

---

## 📋 قائمة التحقق

### قبل كل Commit

- [ ] flutter analyze نظيف
- [ ] جميع الاختبارات تنجح
- [ ] رسالة commit واضحة ومتبعة للمعايير
- [ ] لا توجد أسرار في الكود

### قبل كل Pull Request

- [ ] الفرع محدث من main
- [ ] التغييرات مراجعة ذاتياً
- [ ] التوثيق محدث
- [ ] وصف PR واضح وشامل

---

**للمراجع التفصيلية:** راجع [Git Documentation](https://git-scm.com/doc)
