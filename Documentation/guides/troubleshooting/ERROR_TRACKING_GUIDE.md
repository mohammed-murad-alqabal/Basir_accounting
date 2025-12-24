# دليل نظام تتبع الأخطاء والسجلات

**المشروع:** بصير MVP  
**التاريخ:** 5 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الإصدار:** 1.0  
**الحالة:** ✅ نشط

---

## نظرة عامة

نظام تتبع الأخطاء والسجلات هو منظومة متكاملة لإدارة، تسجيل، تحليل، وتوثيق الأخطاء والمشكلات في مشروع بصير MVP. يهدف النظام إلى ضمان جودة عالية للكود، تتبع دقيق للمشكلات، وأتمتة كاملة لعملية الإبلاغ والمعالجة.

### المكونات الرئيسية

1. **Git Hooks** - فحوصات تلقائية قبل commit وpush
2. **Log Collection** - جمع وتنظيم السجلات
3. **Archive Management** - أرشفة وضغط السجلات القديمة
4. **Report Generation** - إنشاء تقارير شاملة
5. **GitHub Actions** - تحليل مستمر وأتمتة CI/CD

---

## 1. Git Hooks

### 1.1 Pre-commit Hook

يُنفذ تلقائياً قبل كل commit للتحقق من جودة الكود.

#### الفحوصات المنفذة

- ✅ **Flutter Format** - التحقق من تنسيق الكود
- ✅ **Flutter Analyze** - التحليل الثابت للكود
- ✅ **Commit Message** - التحقق من صيغة رسالة الـ commit

#### الاستخدام

```bash
# يتم تشغيله تلقائياً عند:
git commit -m "feat(customers): add customer search feature"
```

#### مثال على الإخراج

```
🔍 Running pre-commit checks...

✅ Flutter Format: PASSED
✅ Flutter Analyze: PASSED (0 issues)
✅ Commit Message: PASSED

✨ All checks passed! Proceeding with commit...
```

#### في حالة الفشل

```
❌ Flutter Analyze: FAILED (3 errors)

Errors found:
  lib/features/customers/customer_repository.dart:45:12
  - Missing return type for function 'getAllCustomers'

Please fix the errors and try again.
```

#### تخطي الفحوصات (غير موصى به)

```bash
# في حالات الطوارئ فقط
git commit --no-verify -m "emergency fix"
```

### 1.2 Pre-push Hook

يُنفذ تلقائياً قبل كل push للتحقق من جاهزية الكود.

#### الفحوصات المنفذة

- ✅ **All Tests** - تشغيل جميع الاختبارات
- ✅ **Secret Scan** - فحص الأسرار المكشوفة

#### الاستخدام

```bash
# يتم تشغيله تلقائياً عند:
git push origin main
```

#### مثال على الإخراج

```
🧪 Running pre-push checks...

✅ Tests: PASSED (45/45 tests)
✅ Secret Scan: PASSED (no secrets found)

🚀 All checks passed! Proceeding with push...
```

#### في حالة فشل الاختبارات

```
❌ Tests: FAILED (43/45 tests)

Failed tests:
  ✗ CustomerRepository should add customer successfully
  ✗ InvoiceService should calculate tax correctly

Please fix the failing tests and try again.
```

#### في حالة اكتشاف أسرار

```
❌ Secret Scan: FAILED

Secrets found:
  lib/services/api_service.dart:12
  - API Key detected: sk_live_xxxxx

Please remove the secrets and use secure storage instead.
```

---

## 2. جمع السجلات (Log Collection)

### 2.1 السكريبت الأساسي

```bash
# جمع السجلات فقط
./scripts/collect_logs.sh

# جمع السجلات ودفعها إلى Git
./scripts/collect_logs.sh --push
```

### 2.2 ما يتم جمعه

#### سجلات Flutter Analyze

```
logs/flutter_analyze_2025-12-05_14-30-00.log
```

يحتوي على:

- جميع الأخطاء والتحذيرات
- موقع كل مشكلة (ملف + سطر)
- نوع المشكلة (error/warning/info)

#### سجلات الاختبارات

```
logs/flutter_test_2025-12-05_14-30-00.log
```

يحتوي على:

- نتائج جميع الاختبارات
- الاختبارات الناجحة والفاشلة
- وقت التنفيذ
- نسبة التغطية

### 2.3 تنظيف البيانات الحساسة

يقوم النظام تلقائياً بإزالة:

- كلمات المرور
- مفاتيح API
- الرموز السرية (Tokens)
- معلومات شخصية حساسة

#### مثال

```
قبل التنظيف:
API_KEY=redacted

بعد التنظيف:
API_KEY=[REDACTED]
```

### 2.4 إزالة التكرار

يقوم النظام بتجميع الأخطاء المتشابهة:

```
قبل:
Error: Null check operator used on a null value (x5)
Error: Null check operator used on a null value (x5)
Error: Null check operator used on a null value (x5)

بعد:
Error: Null check operator used on a null value (occurred 15 times)
```

---

## 3. إدارة الأرشيف (Archive Management)

### 3.1 الأرشفة التلقائية

```bash
# تشغيل الأرشفة يدوياً
./scripts/archive_logs.sh
```

#### القواعد

- السجلات الأقدم من **7 أيام** تُنقل إلى الأرشيف
- عندما يتجاوز الأرشيف **10 ميجابايت**، يتم ضغطه
- السجلات الحديثة تبقى في مكانها

### 3.2 بنية المجلدات

```
logs/
├── flutter_analyze_2025-12-05.log    # حديث
├── flutter_test_2025-12-05.log       # حديث
└── archive/
    ├── flutter_analyze_2025-11-28.log    # قديم
    ├── flutter_test_2025-11-28.log       # قديم
    └── archive_2025-11-28.tar.gz         # مضغوط
```

### 3.3 استخراج من الأرشيف

```bash
# فك ضغط أرشيف معين
tar -xzf logs/archive/archive_2025-11-28.tar.gz -C logs/archive/

# البحث في الأرشيف
zgrep "Error" logs/archive/archive_2025-11-28.tar.gz
```

---

## 4. إنشاء التقارير (Report Generation)

### 4.1 التقرير اليومي

```bash
# إنشاء تقرير شامل
./scripts/generate_report.sh
```

#### محتويات التقرير

1. **إحصائيات المشروع**

   - عدد الملفات
   - حجم المشروع
   - عدد الـ commits

2. **ملخص الأخطاء**

   - عدد الأخطاء حسب النوع
   - الأخطاء الأكثر تكراراً
   - الملفات الأكثر مشاكل

3. **نتائج الاختبارات**

   - عدد الاختبارات الناجحة/الفاشلة
   - نسبة التغطية
   - وقت التنفيذ

4. **التوصيات**
   - إجراءات مقترحة للتحسين
   - أولويات الإصلاح
   - نصائح للأداء

### 4.2 مثال على تقرير

```markdown
# تقرير يومي - 5 ديسمبر 2025

## إحصائيات المشروع

- عدد الملفات: 156
- حجم المشروع: 2.4 MB
- عدد الـ commits: 234

## ملخص الأخطاء

- أخطاء: 0
- تحذيرات: 3
- معلومات: 12

### الأخطاء الأكثر تكراراً

1. Unused import (5 مرات)
2. Missing documentation (3 مرات)

## نتائج الاختبارات

- الاختبارات الناجحة: 45/45 (100%)
- التغطية: 72%
- وقت التنفيذ: 23 ثانية

## التوصيات

✅ جودة الكود ممتازة
⚠️ يُنصح بزيادة التغطية إلى 75%+
💡 إزالة الـ imports غير المستخدمة
```

---

## 5. GitHub Actions

### 5.1 Analysis Workflow

يُنفذ تلقائياً عند:

- Push إلى main أو develop
- إنشاء Pull Request

#### الإجراءات

1. تشغيل Flutter Analyze
2. تشغيل جميع الاختبارات
3. حساب التغطية
4. حفظ التقارير كـ artifacts

### 5.2 Issue Creator Workflow

يُنفذ تلقائياً عند:

- فشل Analysis Workflow
- اكتشاف أخطاء حرجة

#### ما يحدث

1. تحليل نتائج الفحوصات
2. إنشاء Issue على GitHub
3. إضافة labels تلقائية
4. تعيين الأولوية

### 5.3 PR Comment Workflow

يُنفذ تلقائياً عند:

- إنشاء Pull Request
- تحديث Pull Request

#### ما يحدث

1. تشغيل جميع الفحوصات
2. إنشاء ملخص للجودة
3. إضافة تعليق على PR
4. عرض نتائج الاختبارات

---

## 6. استكشاف الأخطاء وإصلاحها

### 6.1 Pre-commit Hook لا يعمل

#### المشكلة

```
Pre-commit hook not found
```

#### الحل

```bash
# التأكد من وجود الملف
ls -la .git/hooks/pre-commit

# إذا لم يكن موجوداً، نسخه
cp scripts/hooks/pre-commit .git/hooks/

# إعطاء صلاحيات التنفيذ
chmod +x .git/hooks/pre-commit
```

### 6.2 Flutter Analyze يفشل

#### المشكلة

```
flutter analyze command not found
```

#### الحل

```bash
# التأكد من تثبيت Flutter
flutter --version

# إذا لم يكن مثبتاً، تثبيته
# راجع: https://docs.flutter.dev/get-started/install

# تحديث Flutter
flutter upgrade
```

### 6.3 الاختبارات تفشل

#### المشكلة

```
Tests failed: 43/45
```

#### الحل

```bash
# تشغيل الاختبارات محلياً
flutter test

# تشغيل اختبار محدد
flutter test test/features/customers/customer_repository_test.dart

# عرض تفاصيل الفشل
flutter test --verbose
```

### 6.4 Secret Scan يكتشف أسرار خاطئة

#### المشكلة

```
False positive: "password" in comment
```

#### الحل

```bash
# تحديث patterns في السكريبت
# تحرير: scripts/hooks/pre-push

# إضافة استثناءات للتعليقات
# أو استخدام secure storage
```

### 6.5 مساحة القرص ممتلئة

#### المشكلة

```
No space left on device
```

#### الحل

```bash
# أرشفة السجلات القديمة
./scripts/archive_logs.sh

# حذف الأرشيفات القديمة جداً (> 30 يوم)
find logs/archive -name "*.tar.gz" -mtime +30 -delete

# تنظيف build cache
flutter clean
```

### 6.6 Git Push يفشل

#### المشكلة

```
Push failed: remote rejected
```

#### الحل

```bash
# التحقق من الاتصال
git remote -v

# سحب آخر التحديثات
git pull origin main

# إعادة المحاولة
git push origin main

# إذا استمرت المشكلة، تخطي hook
git push --no-verify origin main
```

---

## 7. أفضل الممارسات

### 7.1 للمطورين

#### ✅ افعل

- اكتب رسائل commit واضحة
- شغّل الاختبارات قبل الـ push
- راجع السجلات بانتظام
- أصلح التحذيرات فوراً
- استخدم secure storage للأسرار

#### ❌ لا تفعل

- لا تتخطى الـ hooks بدون سبب
- لا تدفع كود به أخطاء
- لا تتجاهل التحذيرات
- لا تخزن أسرار في الكود
- لا تحذف السجلات يدوياً

### 7.2 للفريق

#### الاجتماعات اليومية

- مراجعة التقرير اليومي
- مناقشة الأخطاء الحرجة
- تحديد الأولويات
- توزيع المهام

#### المراجعة الأسبوعية

- تحليل الاتجاهات
- تقييم جودة الكود
- تحديث المعايير
- تحسين العمليات

---

## 8. الأوامر السريعة

### 8.1 الفحوصات اليومية

```bash
# فحص سريع للكود
flutter analyze --no-pub

# تشغيل الاختبارات
flutter test

# جمع السجلات
./scripts/collect_logs.sh

# إنشاء تقرير
./scripts/generate_report.sh
```

### 8.2 الصيانة الأسبوعية

```bash
# أرشفة السجلات القديمة
./scripts/archive_logs.sh

# تنظيف build cache
flutter clean

# تحديث التبعيات
flutter pub upgrade

# فحص الأمان
./scripts/security_scan.sh
```

### 8.3 الطوارئ

```bash
# تخطي pre-commit (طوارئ فقط)
git commit --no-verify -m "emergency fix"

# تخطي pre-push (طوارئ فقط)
git push --no-verify origin main

# استعادة من الأرشيف
tar -xzf logs/archive/archive_DATE.tar.gz
```

---

## 9. التكامل مع IDE

### 9.1 VS Code

#### إضافة مهام (Tasks)

```json
// .vscode/tasks.json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Collect Logs",
      "type": "shell",
      "command": "./scripts/collect_logs.sh",
      "group": "build"
    },
    {
      "label": "Generate Report",
      "type": "shell",
      "command": "./scripts/generate_report.sh",
      "group": "build"
    }
  ]
}
```

#### اختصارات لوحة المفاتيح

```json
// .vscode/keybindings.json
[
  {
    "key": "ctrl+shift+l",
    "command": "workbench.action.tasks.runTask",
    "args": "Collect Logs"
  }
]
```

### 9.2 Android Studio

#### External Tools

1. Settings → Tools → External Tools
2. Add New Tool:
   - Name: Collect Logs
   - Program: ./scripts/collect_logs.sh
   - Working Directory: $ProjectFileDir$

---

## 10. الموارد والمراجع

### الوثائق الداخلية

- [Design Document](../../../.kiro/specs/error-tracking-system/design.md)
- [Requirements](../../../.kiro/specs/error-tracking-system/requirements.md)
- [Tasks](../../../.kiro/specs/error-tracking-system/tasks.md)

### الأدوات المستخدمة

- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)
- [GitHub Actions](https://github.com/features/actions)
- [Git Hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)

### المعايير المتبعة

- [Conventional Commits](https://www.conventionalcommits.org/)
- [OWASP Security](https://owasp.org/)
- [Flutter Best Practices](https://docs.flutter.dev/development/best-practices)

---

## 11. الدعم والمساعدة

### الحصول على المساعدة

1. **راجع هذا الدليل** - معظم الأسئلة مجاب عنها هنا
2. **راجع قسم استكشاف الأخطاء** - حلول للمشاكل الشائعة
3. **راجع السجلات** - تحتوي على تفاصيل الأخطاء
4. **اسأل الفريق** - في حالة المشاكل المعقدة

### الإبلاغ عن مشكلة

عند الإبلاغ عن مشكلة، قدم:

- وصف واضح للمشكلة
- خطوات إعادة إنتاج المشكلة
- رسائل الخطأ الكاملة
- السجلات ذات الصلة
- بيئة التشغيل (OS, Flutter version)

---

## 12. سجل التحديثات

### الإصدار 1.0 (5 ديسمبر 2025)

- ✅ إطلاق النظام الأساسي
- ✅ Git Hooks (pre-commit, pre-push)
- ✅ Log Collection
- ✅ Archive Management
- ✅ Report Generation
- ✅ GitHub Actions Integration
- ✅ التوثيق الشامل

### التحديثات المخططة

- 📋 دعم عملات متعددة في التقارير
- 📋 تكامل مع Slack للإشعارات
- 📋 لوحة تحكم ويب للتقارير
- 📋 تحليل متقدم بالذكاء الاصطناعي

---

**تم إعداد هذا الدليل بواسطة:** فريق وكلاء تطوير مشروع بصير  
**آخر تحديث:** 5 ديسمبر 2025  
**الإصدار:** 1.0  
**الحالة:** ✅ نشط ومعتمد

**للأسئلة والاستفسارات:** راجع قسم الدعم والمساعدة أعلاه
