# دليل ملفات التوجيه

**المشروع:** بصير MVP  
**التاريخ:** 7 ديسمبر 2025  
**الإصدار:** 2.0  
**الحالة:** ✅ نشط

---

## نظرة عامة

تم إعادة هيكلة ملفات التوجيه لحل مشكلة تجاوز حد السياق وتحسين الكفاءة.

### التحسينات

- ✅ تقليل الحمل الأساسي بنسبة **97.6%**
- ✅ بنية هرمية منظمة
- ✅ تحميل انتقائي حسب الحاجة
- ✅ إزالة التكرار

---

## البنية النهائية (بعد التنظيف)

```
.kiro/steering/
├── core/              # الملفات الأساسية (تُحمّل دائماً)
│   ├── philosophy.md
│   ├── quick-reference.md
│   └── team-identity.md
│
├── standards/         # المعايير (عند الحاجة)
│   ├── naming.md
│   ├── code-quality.md
│   ├── flutter.md
│   ├── arabic.md
│   ├── documentation.md
│   └── testing.md
│
├── reference/        # المراجع (عند الطلب فقط)
│   ├── full-standards.md
│   ├── examples.md
│   ├── arabic-dictionary.md
│   ├── best-practices.md
│   └── strategic-docs.md
│
├── config.json       # تكوين التحميل
├── README.md         # هذا الملف
└── LOADING_GUIDE.md  # دليل التحميل
```

**إجمالي:** 17 ملف فقط - بنية نظيفة وبسيطة! ✅

---

## استراتيجية التحميل

### 1. Core (الأساسية) - تُحمّل دائماً

**الملفات:**

- `core/philosophy.md` - المبادئ الأساسية
- `core/quick-reference.md` - مرجع سريع
- `core/team-identity.md` - الهوية الموحدة

**الحجم:** ~160 سطر (~5KB)  
**الاستخدام:** 2.4% من السياق

### 2. Standards (المعايير) - عند الحاجة

**الملفات:**

- `standards/naming.md` - معايير التسمية
- `standards/code-quality.md` - معايير الجودة
- `standards/flutter.md` - معايير Flutter
- `standards/arabic.md` - معايير العربية
- `standards/documentation.md` - معايير التوثيق
- `standards/testing.md` - معايير الاختبارات

**الحجم:** ~900 سطر (~30KB)  
**متى تُحمّل:** عند العمل على كود أو مراجعة

### 3. Reference (المراجع) - عند الطلب فقط

**الملفات:**

- `reference/full-standards.md` - جميع المعايير الكاملة
- `reference/examples.md` - جميع الأمثلة التفصيلية
- `reference/arabic-dictionary.md` - القاموس العربي الكامل
- `reference/best-practices.md` - أفضل الممارسات الشاملة
- `reference/strategic-docs.md` - الوثائق الاستراتيجية

**الحجم:** ~6,000 سطر (~200KB)  
**متى تُحمّل:** عند الطلب الصريح فقط

---

## كيفية الاستخدام

### للوكيل

#### البداية

1. تُحمّل ملفات `core/` تلقائياً
2. استخدم `quick-reference.md` للمعلومات السريعة
3. اطلب ملفات `standards/` عند الحاجة

#### عند العمل على كود

```
"أحتاج معايير التسمية"
→ يُحمّل standards/naming.md
```

#### عند العمل على Flutter

```
"أحتاج دليل Flutter"
→ يُحمّل guides/flutter-guide.md
```

#### للمعلومات التفصيلية

```
"أحتاج القاموس العربي الكامل"
→ يُحمّل reference/arabic-dictionary.md

"أحتاج أمثلة تفصيلية"
→ يُحمّل reference/examples.md

"أحتاج أفضل الممارسات"
→ يُحمّل reference/best-practices.md

"أحتاج الوثائق الاستراتيجية"
→ يُحمّل reference/strategic-docs.md
```

### للمطور

#### قراءة المعايير

```bash
# المعايير الأساسية
cat .kiro/steering/core/quick-reference.md

# معيار محدد
cat .kiro/steering/standards/naming.md

# دليل كامل
cat .kiro/steering/guides/flutter-guide.md
```

#### البحث

```bash
# البحث في الملفات الأساسية
grep -r "pattern" .kiro/steering/core/

# البحث في المعايير
grep -r "pattern" .kiro/steering/standards/
```

---

## المقاييس

### قبل التحسين

| المقياس        |  القيمة |
| :------------- | ------: |
| إجمالي الملفات |      20 |
| إجمالي الأسطر  |   6,575 |
| إجمالي الحجم   | ~220 KB |
| الحمل الأساسي  |    100% |

### بعد التحسين

| المقياس          | القيمة |      التحسين |
| :--------------- | -----: | -----------: |
| الملفات الأساسية |      3 |            - |
| الأسطر الأساسية  |    160 | **97.6%** ⬇️ |
| الحجم الأساسي    |  ~5 KB | **97.7%** ⬇️ |
| الحمل الأساسي    |   2.4% | **97.6%** ⬇️ |

---

## الملفات القديمة

تم نقل الملفات القديمة إلى `archive/` للرجوع إليها عند الحاجة:

- `strategic-vision.md` → `archive/`
- `roadmap.md` → `archive/`
- `naming-conventions.md` → `archive/`
- وغيرها...

---

## الصيانة

### التحديثات

- **شهرياً:** مراجعة الملفات الأساسية
- **ربع سنوياً:** مراجعة المعايير
- **سنوياً:** مراجعة شاملة

### إضافة محتوى جديد

1. حدد الفئة المناسبة (core/standards/guides/reference)
2. أضف المحتوى بشكل مختصر
3. حدّث `config.json`
4. حدّث هذا الملف

---

## الدعم

للأسئلة أو المشاكل:

1. راجع `config.json` للتكوين
2. راجع `context-analysis-report.md` للتفاصيل
3. راجع `.kiro/specs/context-optimization/` للمواصفات

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 7 ديسمبر 2025  
**الإصدار:** 2.0  
**الحالة:** ✅ نشط ومعتمد
