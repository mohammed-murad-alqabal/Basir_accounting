# نظام فحص التوافق التلقائي لملفات التوجيه

**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 16 ديسمبر 2025  
**الإصدار:** 1.0.0

---

## نظرة عامة

نظام شامل لفحص ملفات التوجيه تلقائياً للتأكد من توافقها مع مكدس Flutter/Dart ومنع إضافة مراجع لتقنيات غير متوافقة.

## المكونات الأساسية

### 1. السكريبتات الرئيسية

| الملف                               | الوصف                  |
| ----------------------------------- | ---------------------- |
| `steering_compatibility_checker.py` | السكريبت الأساسي للفحص |
| `check_steering_compatibility.sh`   | واجهة سهلة الاستخدام   |
| `install_steering_hooks.sh`         | تثبيت Git hooks        |
| `test_steering_compatibility.sh`    | اختبار النظام          |

### 2. ملفات التكوين

| الملف                            | الوصف                        |
| -------------------------------- | ---------------------------- |
| `incompatible_technologies.json` | قائمة التقنيات غير المتوافقة |
| `steering_rules.yml`             | قواعد الفحص المتقدمة         |

### 3. Git Hooks

| الملف                             | الوصف             |
| --------------------------------- | ----------------- |
| `hooks/pre-commit-steering-check` | فحص قبل كل commit |

### 4. GitHub Actions

| الملف                                                | الوصف               |
| ---------------------------------------------------- | ------------------- |
| `.github/workflows/steering_compatibility_check.yml` | فحص تلقائي في CI/CD |

---

## التثبيت والإعداد

### 1. التثبيت الأساسي

```bash
# تأكد من وجود Python 3
python3 --version

# اجعل السكريبتات قابلة للتنفيذ
chmod +x scripts/*.sh
chmod +x scripts/hooks/*
```

### 2. تثبيت Git Hooks

```bash
# تثبيت hooks للفحص التلقائي
./scripts/install_steering_hooks.sh
```

### 3. اختبار النظام

```bash
# تشغيل اختبارات شاملة
./scripts/test_steering_compatibility.sh
```

---

## الاستخدام

### 1. الفحص اليدوي

#### فحص جميع الملفات

```bash
# فحص أساسي
./scripts/check_steering_compatibility.sh

# فحص مع تقرير JSON فقط
./scripts/check_steering_compatibility.sh --output json

# فحص صامت
./scripts/check_steering_compatibility.sh --quiet
```

#### فحص ملف واحد

```bash
# فحص ملف محدد
./scripts/check_steering_compatibility.sh --file .kiro/steering/technologies/frontend-standards.md

# فحص مع مستوى خطورة عالي
./scripts/check_steering_compatibility.sh --file path/to/file.md --severity high
```

### 2. الفحص في CI/CD

#### وضع CI/CD (يفشل عند وجود مشاكل)

```bash
# فحص للاستخدام في CI/CD
./scripts/check_steering_compatibility.sh --ci --severity medium
```

#### استخدام السكريبت Python مباشرة

```bash
# فحص مع خيارات متقدمة
python3 scripts/steering_compatibility_checker.py \
  --output-format both \
  --severity-threshold high \
  --fail-on-issues
```

### 3. الفحص التلقائي

#### Git Hooks

```bash
# الفحص يتم تلقائياً عند:
git commit  # pre-commit hook

# لتجاهل الفحص مؤقتاً
git commit --no-verify
```

#### GitHub Actions

الفحص يتم تلقائياً عند:

- Push إلى ملفات التوجيه
- Pull Request يتضمن ملفات التوجيه
- يومياً في الساعة 2 صباحاً (UTC)
- تشغيل يدوي من GitHub

---

## التكوين

### 1. إضافة تقنيات جديدة غير متوافقة

عدّل ملف `scripts/incompatible_technologies.json`:

```json
{
  "incompatible_technologies": [
    {
      "name": "تقنية جديدة",
      "type": "نوع التقنية",
      "reason": "سبب عدم التوافق",
      "replacement": "البديل المقترح",
      "patterns": ["\\bpattern1\\b", "pattern2"]
    }
  ]
}
```

### 2. تخصيص القواعد

عدّل ملف `scripts/steering_rules.yml` لتخصيص:

- مستويات الخطورة
- استثناءات السياق
- إعدادات التقارير
- تكوين CI/CD

### 3. تخصيص GitHub Actions

عدّل `.github/workflows/steering_compatibility_check.yml` لتغيير:

- متى يتم تشغيل الفحص
- مستوى الخطورة المطلوب
- إعدادات التقارير

---

## التقارير

### 1. تنسيقات التقارير

#### Markdown Report

```
reports/compatibility/compatibility_report_YYYYMMDD_HHMMSS.md
```

#### JSON Report

```
reports/compatibility/compatibility_issues_YYYYMMDD_HHMMSS.json
```

### 2. محتوى التقارير

- **الملخص التنفيذي**: إحصائيات عامة
- **تصنيف المشاكل**: حسب الخطورة
- **التقنيات الأكثر ظهوراً**: قائمة مرتبة
- **تفاصيل المشاكل**: لكل ملف وسطر
- **التوصيات**: إجراءات مقترحة

### 3. مثال على تقرير JSON

```json
{
  "timestamp": "2025-12-16T10:30:00",
  "total_files": 15,
  "files_with_issues": 3,
  "total_issues": 8,
  "issues": {
    ".kiro/steering/example.md": [
      {
        "line_number": 25,
        "line_content": "استخدم npm install",
        "technology": "Node.js",
        "severity": "high",
        "suggestion": "استبدل 'Node.js' بـ 'Flutter SDK'"
      }
    ]
  }
}
```

---

## استكشاف الأخطاء

### 1. مشاكل شائعة

#### Python غير مثبت

```bash
# تثبيت Python 3
sudo apt install python3  # Ubuntu/Debian
brew install python3      # macOS
```

#### أذونات الملفات

```bash
# إصلاح أذونات السكريبتات
chmod +x scripts/*.sh
chmod +x scripts/hooks/*
```

#### Git hooks لا تعمل

```bash
# إعادة تثبيت hooks
./scripts/install_steering_hooks.sh

# التحقق من وجود hooks
ls -la .git/hooks/
```

### 2. تصحيح الأخطاء

#### تشغيل في وضع التصحيح

```bash
# تشغيل مع تفاصيل أكثر
python3 scripts/steering_compatibility_checker.py --file path/to/file.md

# فحص ملف محدد بتفصيل
./scripts/check_steering_compatibility.sh --file path/to/file.md
```

#### فحص تكوين Git hooks

```bash
# عرض محتوى pre-commit hook
cat .git/hooks/pre-commit

# اختبار hook يدوياً
bash .git/hooks/pre-commit
```

### 3. حل مشاكل التوافق

#### إضافة استثناءات

إذا كان هناك مرجع مشروع لتقنية غير متوافقة، أضف سياق توضيحي:

```markdown
<!-- قبل -->

استخدم Node.js للتطوير

<!-- بعد -->

تجنب استخدام Node.js، استخدم Flutter SDK بدلاً من ذلك
```

#### تحديث الأنماط

عدّل `incompatible_technologies.json` لتحسين دقة الكشف.

---

## الصيانة

### 1. تحديث القواعد

```bash
# تحديث قائمة التقنيات غير المتوافقة
vim scripts/incompatible_technologies.json

# تحديث قواعد الفحص
vim scripts/steering_rules.yml
```

### 2. تنظيف التقارير القديمة

```bash
# حذف التقارير الأقدم من 30 يوم
find reports/compatibility -name "*.md" -mtime +30 -delete
find reports/compatibility -name "*.json" -mtime +30 -delete
```

### 3. مراقبة الأداء

```bash
# فحص أداء النظام
time ./scripts/check_steering_compatibility.sh

# مراقبة استخدام الذاكرة
/usr/bin/time -v python3 scripts/steering_compatibility_checker.py
```

---

## التطوير والمساهمة

### 1. إضافة ميزات جديدة

1. عدّل `steering_compatibility_checker.py`
2. أضف اختبارات في `test_steering_compatibility.sh`
3. حدّث التوثيق

### 2. اختبار التغييرات

```bash
# تشغيل جميع الاختبارات
./scripts/test_steering_compatibility.sh

# اختبار ميزة محددة
python3 scripts/steering_compatibility_checker.py --file test_file.md
```

### 3. معايير الكود

- استخدم Python 3.8+
- اتبع PEP 8 للتنسيق
- أضف تعليقات باللغة العربية للوضوح
- اكتب اختبارات للميزات الجديدة

---

## الأمان

### 1. اعتبارات الأمان

- لا تضع معلومات حساسة في ملفات التكوين
- استخدم متغيرات البيئة للمعلومات السرية
- راجع التقارير قبل مشاركتها

### 2. أذونات الملفات

```bash
# التأكد من الأذونات الصحيحة
chmod 755 scripts/*.sh
chmod 644 scripts/*.json scripts/*.yml
chmod 755 scripts/hooks/*
```

---

## الدعم

### 1. الحصول على المساعدة

```bash
# عرض مساعدة السكريبت الرئيسي
./scripts/check_steering_compatibility.sh --help

# عرض مساعدة Python script
python3 scripts/steering_compatibility_checker.py --help
```

### 2. الإبلاغ عن المشاكل

1. تشغيل `./scripts/test_steering_compatibility.sh`
2. جمع معلومات النظام
3. إنشاء issue مع التفاصيل

### 3. طلب ميزات جديدة

1. وصف الميزة المطلوبة
2. تقديم أمثلة على الاستخدام
3. شرح الفائدة للمشروع

---

## الإصدارات

### الإصدار 1.0.0 (16 ديسمبر 2025)

**الميزات الأساسية:**

- ✅ فحص تلقائي لملفات التوجيه
- ✅ كشف التقنيات غير المتوافقة
- ✅ تقارير Markdown و JSON
- ✅ Git hooks للفحص التلقائي
- ✅ GitHub Actions للـ CI/CD
- ✅ واجهة سطر أوامر سهلة الاستخدام
- ✅ نظام اختبار شامل

**التحسينات المستقبلية:**

- إضافة المزيد من التقنيات غير المتوافقة
- تحسين دقة كشف السياق
- إضافة إصلاح تلقائي للمشاكل
- دعم تنسيقات تقارير إضافية
- تكامل مع أدوات أخرى

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**للدعم:** راجع قسم الدعم أعلاه  
**الترخيص:** حسب ترخيص المشروع الأساسي
