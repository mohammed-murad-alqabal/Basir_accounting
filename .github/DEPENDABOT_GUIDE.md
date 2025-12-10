# دليل Dependabot

**المشروع:** بصير MVP  
**التاريخ:** 8 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ نشط

---

## 🎯 نظرة عامة

Dependabot هو أداة GitHub لإدارة التبعيات تلقائياً. يقوم بفحص التبعيات وإنشاء Pull Requests لتحديثها.

---

## 📋 التكوين الحالي

الملف: `.github/dependabot.yml`

```yaml
version: 2
updates:
  # Pub dependencies
  - package-ecosystem: "pub"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 10

  # GitHub Actions
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
```

---

## 🔧 كيفية التفعيل

### الخطوة 1: تفعيل Dependabot

1. اذهب إلى المستودع على GitHub
2. Settings → Security → Code security and analysis
3. فعّل "Dependabot alerts"
4. فعّل "Dependabot security updates"
5. فعّل "Dependabot version updates"

### الخطوة 2: التحقق من التفعيل

1. اذهب إلى Insights → Dependency graph
2. تحقق من وجود "Dependabot" tab
3. يجب أن ترى قائمة بالتبعيات

---

## 📊 كيفية العمل

### Dependabot Alerts

**ماذا يفعل:**

- يفحص التبعيات للثغرات الأمنية
- يرسل تنبيهات عند اكتشاف ثغرات
- يقترح تحديثات أمنية

**كيفية الاستجابة:**

1. راجع التنبيه في Security → Dependabot alerts
2. اقرأ تفاصيل الثغرة
3. راجع الـ PR المقترح
4. اختبر التحديث
5. ادمج الـ PR

### Dependabot Version Updates

**ماذا يفعل:**

- يفحص التبعيات أسبوعياً
- ينشئ PRs لتحديثات الإصدارات
- يحدث GitHub Actions workflows

**كيفية الاستجابة:**

1. راجع الـ PR
2. تحقق من CHANGELOG للتبعية
3. تحقق من CI/CD results
4. اختبر محلياً إذا لزم الأمر
5. ادمج أو أغلق الـ PR

---

## ✅ أفضل الممارسات

### مراجعة PRs

- ✅ راجع كل PR بعناية
- ✅ تحقق من breaking changes
- ✅ اختبر التحديثات الكبيرة محلياً
- ✅ راجع CHANGELOG للتبعية
- ✅ تحقق من CI/CD results

### إدارة PRs

- ✅ ادمج التحديثات الأمنية فوراً
- ✅ ادمج التحديثات الصغيرة (patch) بسرعة
- ✅ اختبر التحديثات الكبيرة (major) بعناية
- ✅ أغلق PRs غير المرغوبة مع تعليق
- ✅ استخدم auto-merge للتحديثات الآمنة

### التكوين

- ✅ حدد جدول مناسب (weekly موصى به)
- ✅ حدد عدد PRs المفتوحة (10 موصى به)
- ✅ استخدم labels للتنظيم
- ✅ استخدم assignees للمسؤولية
- ✅ استخدم reviewers للمراجعة

---

## 🔍 مراقبة التبعيات

### Dependency Graph

**الوصول:**
Insights → Dependency graph

**الفوائد:**

- عرض جميع التبعيات
- تتبع التبعيات الفرعية
- اكتشاف التبعيات غير المستخدمة

### Security Advisories

**الوصول:**
Security → Dependabot alerts

**الفوائد:**

- تنبيهات فورية للثغرات
- تفاصيل الثغرات
- حلول مقترحة

---

## 📝 أمثلة على PRs

### PR للتحديث الأمني

```
Title: Bump package_name from 1.0.0 to 1.0.1

Description:
Bumps package_name from 1.0.0 to 1.0.1.

Security:
- Fixes CVE-2024-XXXXX

Changelog:
- Security fix for XSS vulnerability
```

**الإجراء:** ادمج فوراً بعد مراجعة سريعة

### PR للتحديث الصغير (Patch)

```
Title: Bump package_name from 1.0.0 to 1.0.1

Description:
Bumps package_name from 1.0.0 to 1.0.1.

Changelog:
- Bug fixes
- Performance improvements
```

**الإجراء:** راجع وادمج خلال يوم

### PR للتحديث الكبير (Major)

```
Title: Bump package_name from 1.0.0 to 2.0.0

Description:
Bumps package_name from 1.0.0 to 2.0.0.

Breaking Changes:
- API changes
- Removed deprecated methods

Changelog:
- New features
- Breaking changes
```

**الإجراء:** راجع بعناية، اختبر محلياً، ثم ادمج

---

## 🛠️ استكشاف الأخطاء

### Dependabot لا يعمل

**الأسباب المحتملة:**

1. لم يتم تفعيله في Settings
2. ملف `dependabot.yml` غير صحيح
3. المستودع private بدون GitHub Advanced Security

**الحل:**

1. تحقق من Settings → Security
2. تحقق من صحة `dependabot.yml`
3. فعّل GitHub Advanced Security (للمستودعات private)

### PRs كثيرة جداً

**الحل:**

```yaml
# في dependabot.yml
open-pull-requests-limit: 5 # قلل العدد
```

### تحديثات غير مرغوبة

**الحل:**

```yaml
# في dependabot.yml
ignore:
  - dependency-name: "package_name"
    versions: ["2.x"] # تجاهل الإصدار 2.x
```

---

## 📚 المراجع

### الوثائق الرسمية

- [Dependabot Documentation](https://docs.github.com/en/code-security/dependabot)
- [Dependabot Configuration](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file)

### الأدلة الداخلية

- `.github/dependabot.yml` - ملف التكوين
- `.github/workflows/dependency-review.yml` - Workflow للمراجعة

---

## 📞 الدعم

للمساعدة:

1. راجع هذا الدليل
2. تحقق من GitHub Docs
3. راجع Security tab للتنبيهات

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 8 ديسمبر 2025  
**الإصدار:** 1.0  
**الحالة:** ✅ نشط ومعتمد
