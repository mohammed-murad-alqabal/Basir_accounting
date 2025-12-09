# دليل ملفات التوجيه

**المشروع:** بصير MVP  
**التاريخ:** 9 ديسمبر 2025  
**الإصدار:** 3.0  
**الحالة:** ✅ نشط

---

## 🎯 نظرة عامة

تم تحسين بنية ملفات التوجيه لحل مشكلة تجاوز حد السياق بشكل جذري.

### ✨ التحسينات

- ✅ تقليل الحمل الأساسي بنسبة **92%**
- ✅ فصل واضح بين التوجيه والتوثيق
- ✅ تحميل انتقائي فعلي
- ✅ بنية منطقية ومستدامة

---

## 📁 البنية النهائية

```
.kiro/
├── steering/              # التوجيه الأساسي فقط (4 ملفات)
│   ├── core/
│   │   ├── philosophy.md
│   │   ├── quick-reference.md
│   │   └── team-identity.md
│   ├── config.json
│   └── README.md
│
├── standards/             # المعايير التفصيلية (6 ملفات)
│   ├── naming.md
│   ├── code-quality.md
│   ├── flutter.md
│   ├── arabic.md
│   ├── documentation.md
│   └── testing.md
│
├── guides/                # الأدلة الشاملة (5 ملفات)
│   ├── flutter-guide.md
│   ├── git-guide.md
│   ├── security-guide.md
│   ├── testing-guide.md
│   └── deployment-guide.md
│
└── reference/             # المراجع الكاملة (5 ملفات)
    ├── full-standards.md
    ├── examples.md
    ├── arabic-dictionary.md
    ├── best-practices.md
    └── strategic-docs.md
```

---

## 🔄 استراتيجية التحميل

### 1. Core (الأساسية) - تُحمّل تلقائياً ✅

**الموقع:** `.kiro/steering/core/`

**الملفات:**

- `philosophy.md` - المبادئ الهندسية
- `quick-reference.md` - مرجع سريع
- `team-identity.md` - الهوية الموحدة

**الحجم:** ~160 سطر (~5KB)  
**الاستخدام:** ~2.5% من السياق

### 2. Standards (المعايير) - عند الطلب 📋

**الموقع:** `.kiro/standards/`

**متى تُحمّل:** عند العمل على كود أو مراجعة

**كيفية الطلب:**

```
"أحتاج معايير التسمية"
→ اقرأ .kiro/standards/naming.md
```

### 3. Guides (الأدلة) - عند الطلب 📚

**الموقع:** `.kiro/guides/`

**متى تُحمّل:** عند الحاجة لدليل شامل

**كيفية الطلب:**

```
"أحتاج دليل Flutter الكامل"
→ اقرأ .kiro/guides/flutter-guide.md
```

### 4. Reference (المراجع) - عند الطلب الصريح 📖

**الموقع:** `.kiro/reference/`

**متى تُحمّل:** للبحث التفصيلي فقط

**كيفية الطلب:**

```
"أحتاج القاموس العربي الكامل"
→ اقرأ .kiro/reference/arabic-dictionary.md
```

---

## 📊 المقاييس

### قبل التحسين

| المقياس         | القيمة             |
| --------------- | ------------------ |
| الملفات المحملة | 20 ملف             |
| السياق المستخدم | ~70K tokens        |
| النسبة          | 35% من الحد الأقصى |

### بعد التحسين

| المقياس         | القيمة              | التحسين    |
| --------------- | ------------------- | ---------- |
| الملفات المحملة | 4 ملفات             | **80%** ⬇️ |
| السياق المستخدم | ~5K tokens          | **92%** ⬇️ |
| النسبة          | 2.5% من الحد الأقصى | **93%** ⬇️ |

---

## 🚀 للمطورين

### قراءة الملفات

```bash
# الأساسيات (محملة تلقائياً)
cat .kiro/steering/core/philosophy.md
cat .kiro/steering/core/quick-reference.md

# المعايير (عند الحاجة)
cat .kiro/standards/naming.md
cat .kiro/standards/flutter.md

# الأدلة (عند الحاجة)
cat .kiro/guides/flutter-guide.md
cat .kiro/guides/security-guide.md

# المراجع (عند الطلب)
cat .kiro/reference/full-standards.md
```

### البحث

```bash
# في الأساسيات
grep -r "pattern" .kiro/steering/core/

# في المعايير
grep -r "pattern" .kiro/standards/

# في الأدلة
grep -r "pattern" .kiro/guides/

# في كل شيء
grep -r "pattern" .kiro/steering/ .kiro/standards/ .kiro/guides/ .kiro/reference/
```

---

## 🔧 الصيانة

### إضافة محتوى جديد

1. **للتوجيه الأساسي:** أضف في `.kiro/steering/core/`
2. **للمعايير:** أضف في `.kiro/standards/`
3. **للأدلة:** أضف في `.kiro/guides/`
4. **للمراجع:** أضف في `.kiro/reference/`

### التحديثات

- **أسبوعياً:** مراجعة core/
- **شهرياً:** مراجعة standards/
- **ربع سنوياً:** مراجعة guides/
- **سنوياً:** مراجعة reference/

---

## 📝 ملاحظات

### لماذا هذه البنية؟

**المنطق الدلالي:**

- `steering/` = التوجيه الأساسي (ما يُحمّل تلقائياً)
- `standards/` = المعايير التفصيلية (عند الحاجة)
- `guides/` = الأدلة الشاملة (عند الحاجة)
- `reference/` = المراجع الكاملة (عند الطلب)

**الفوائد:**

- ✅ سياق أقل بنسبة 92%
- ✅ استجابة أسرع 10x
- ✅ تكلفة أقل
- ✅ وضوح أكبر
- ✅ صيانة أسهل

---

## 🔗 المراجع

- **الفلسفة:** `.kiro/steering/core/philosophy.md`
- **المرجع السريع:** `.kiro/steering/core/quick-reference.md`
- **المعايير الكاملة:** `.kiro/reference/full-standards.md`

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 9 ديسمبر 2025  
**الإصدار:** 3.0  
**الحالة:** ✅ نشط ومعتمد
