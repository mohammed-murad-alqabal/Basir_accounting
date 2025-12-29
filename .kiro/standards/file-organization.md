# معايير تنظيم الملفات

**المشروع:** بصير MVP  
**التاريخ:** 9 ديسمبر 2025  
**الحالة:** ✅ نشط ومعتمد

---

## 🎯 الهدف

ضمان تنظيم ممتاز ومستدام للملفات في المشروع، مع منع تراكم الفوضى.

---

## 📁 البنية الأساسية

### 1. الجذر (Root) - نظيف دائماً

**القاعدة الذهبية:** فقط الملفات الضرورية والمعيارية

#### ✅ الملفات المسموحة

```
README.md              # وصف المشروع
LICENSE                # الترخيص
CHANGELOG.md           # سجل التغييرات
CONTRIBUTING.md        # دليل المساهمة
SECURITY.md            # سياسة الأمان
ARCHITECTURE.md        # البنية المعمارية
TESTING.md             # دليل الاختبارات
```

#### ❌ الملفات الممنوعة

```
*.log                  # السجلات → logs/
*.tmp                  # الملفات المؤقتة → /tmp/
*.bak                  # النسخ الاحتياطية → backups/
*.db                   # قواعد البيانات → .kiro/data/
*_REPORT.md            # التقارير → docs/ أو .kiro/docs/
*_STATUS.md            # الحالة → .kiro/docs/reports/
```

---

### 2. docs/ - التوثيق الرسمي

**الغرض:** التوثيق الرسمي للمشروع والتقارير الهامة طويلة المدى

#### البنية

```
docs/
├── api/               # توثيق API
├── Archive/           # أرشيف الوثائق القديمة
├── Core/              # الوثائق الأساسية
├── guides/            # الأدلة الشاملة
│   ├── deployment/
│   └── development/
├── reports/           # التقارير الهامة
│   ├── analysis/
│   └── fixes/
└── sessions/          # تقارير الجلسات
```

#### القواعد

- ✅ التوثيق الرسمي فقط
- ✅ التقارير الهامة طويلة المدى
- ✅ الأدلة الشاملة
- ❌ لا تقارير مؤقتة
- ❌ لا ملفات تجريبية

#### الأرشفة

- الملفات القديمة (> 90 يوم) → `Archive/`
- الأرشيف المضغوط → `.kiro/archives/`

---

### 3. .kiro/docs/ - التوثيق الداخلي

**الغرض:** التقارير الداخلية، الخطط، والمواصفات

#### البنية

```
.kiro/docs/
├── plans/             # خطط العمل
├── reports/           # التقارير الداخلية
│   ├── kiro/         # تقارير Kiro
│   ├── phases/       # تقارير المراحل
│   ├── components/   # تقارير المكونات
│   ├── sessions/     # تقارير الجلسات
│   ├── enhancements/ # تقارير التحسينات
│   ├── status/       # تقارير الحالة
│   ├── quality/      # تقارير الجودة
│   └── reorganization/ # تقارير إعادة التنظيم
└── [ملفات أخرى]
```

#### القواعد

- ✅ التقارير الداخلية
- ✅ الخطط والمواصفات
- ✅ التوثيق التقني
- ❌ لا ملفات \*\_TEMP.md
- ❌ لا ملفات \*\_OLD.md

#### الأرشفة

- التقارير القديمة (> 3 أشهر) → أرشيف مضغوط
- الاحتفاظ بالتقارير المهمة فقط

---

### 4. scripts/ - السكريبتات

**الغرض:** جميع السكريبتات منظمة حسب الفئة

#### البنية

```
scripts/
├── archive/           # سكريبتات مؤرشفة
├── hooks/             # Git hooks
├── maintenance/       # سكريبتات الصيانة
├── utils/             # أدوات مساعدة
└── [سكريبتات رئيسية]
```

#### القواعد

- ✅ تنظيم حسب الفئة
- ✅ أسماء واضحة ووصفية
- ✅ توثيق داخل السكريبت
- ✅ صلاحيات تنفيذ مناسبة

#### أمثلة

```bash
# ✅ صحيح
scripts/maintenance/cleanup_project.sh
scripts/utils/compress.sh
scripts/hooks/pre-commit

# ❌ خطأ
cleanup.sh                    # في الجذر
scripts/script1.sh            # اسم غير واضح
scripts/temp_fix.sh           # مؤقت
```

---

### 5. logs/ - السجلات

**الغرض:** جميع السجلات منظمة حسب النوع

#### البنية

```
logs/
├── errors/            # سجلات الأخطاء
├── flutter/           # سجلات Flutter
├── git/               # سجلات Git
└── .gitignore         # تجاهل السجلات المؤقتة
```

#### القواعد

- ✅ تنظيم حسب النوع
- ✅ تسمية واضحة مع التاريخ
- ✅ أرشفة دورية
- ❌ لا سجلات في الجذر

#### التسمية

```bash
# ✅ صحيح
logs/errors/error_2025-12-09.log
logs/flutter/flutter_build_2025-12-09.log

# ❌ خطأ
error.log                     # في الجذر
logs/log1.log                 # اسم غير واضح
```

---

### 6. .kiro/data/ - البيانات الداخلية

**الغرض:** قواعد البيانات والبيانات الداخلية لـ Kiro

#### القواعد

- ✅ قواعد بيانات MCP
- ✅ ملفات التكوين
- ✅ البيانات المؤقتة
- ❌ لا بيانات حساسة

---

## 🚫 الممنوعات

### في الجذر

```bash
❌ *.log                # → logs/
❌ *.tmp                # → /tmp/
❌ *.bak                # → backups/
❌ *.db                 # → .kiro/data/
❌ *.so, *.dll          # مُولدة تلقائياً
❌ *_REPORT.md          # → docs/ أو .kiro/docs/
❌ *_STATUS.md          # → .kiro/docs/reports/
❌ *_SUMMARY.md         # → .kiro/docs/reports/
❌ CHECKPOINT_*.md      # → .kiro/docs/reports/
```

### في أي مكان

```bash
❌ *_TEMP.md            # ملفات مؤقتة
❌ *_OLD.md             # ملفات قديمة
❌ test_*.txt           # ملفات اختبار
❌ backup_*             # نسخ احتياطية غير منظمة
```

---

## ✅ أمثلة عملية

### مثال 1: إضافة تقرير جديد

```bash
# ❌ خطأ
echo "تقرير" > NEW_REPORT.md

# ✅ صحيح - تقرير رسمي
echo "تقرير" > docs/reports/analysis/feature_analysis.md

# ✅ صحيح - تقرير داخلي
echo "تقرير" > .kiro/docs/reports/sessions/session_report.md
```

### مثال 2: إضافة سكريبت جديد

```bash
# ❌ خطأ
echo "#!/bin/bash" > cleanup.sh

# ✅ صحيح
echo "#!/bin/bash" > scripts/maintenance/cleanup_database.sh
chmod +x scripts/maintenance/cleanup_database.sh
```

### مثال 3: إضافة سجل

```bash
# ❌ خطأ
echo "error" > error.log

# ✅ صحيح
echo "error" > logs/errors/error_$(date +%Y-%m-%d).log
```

---

## 🔍 التحقق

### قبل Commit

```bash
# التحقق من عدم وجود ملفات غير مرغوبة في الجذر
ls -1 *.log *.tmp *.bak *_REPORT.md 2>/dev/null

# يجب أن يكون الناتج فارغاً
```

### دوري (شهرياً)

```bash
# التحقق من حجم المجلدات
du -sh Documentation .kiro/docs scripts logs

# أرشفة الملفات القديمة
find docs/Archive -mtime +90 -type f
```

---

## 📋 قائمة التحقق

### عند إضافة ملف جديد

- [ ] هل الملف في المكان الصحيح؟
- [ ] هل الاسم واضح ووصفي؟
- [ ] هل يتبع معايير التسمية؟
- [ ] هل هو في .gitignore إذا كان مؤقتاً؟

### عند إنشاء مجلد جديد

- [ ] هل المجلد ضروري؟
- [ ] هل الموقع منطقي؟
- [ ] هل يحتوي على README.md؟
- [ ] هل البنية واضحة؟

---

## 🛠️ الأدوات المساعدة

### Git Hook

استخدم `.githooks/pre-commit-file-check` للتحقق التلقائي

### سكريبتات الصيانة

```bash
# مراقبة الحجم
scripts/maintenance/check_size.sh

# أرشفة التقارير القديمة
scripts/maintenance/archive_old_reports.sh
```

---

## 📚 المراجع

- **Git Guide:** `.kiro/guides/git-guide.md`
- **Quick Reference:** `.kiro/steering/core/quick-reference.md`
- **Philosophy:** `.kiro/steering/core/philosophy.md`

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 9 ديسمبر 2025  
**الحالة:** ✅ نشط ومعتمد
