# 🎯 Kiro Strategic Blueprint - دليل الإعداد

## نظرة عامة

هذا المجلد يحتوي على **Kiro Strategic Blueprint** - نموذج هندسي كامل يطبق منهجية **Spec-Driven Development (SDD)** ومبدأ **Security First**.

## 📁 البنية

```
.kiro/
├── specs/              # المواصفات (Requirements → Design → Tasks)
├── steering/           # الحوكمة المعمارية (12 ملف)
├── prompts/            # توجيهات الوكيل (5 ملفات)
├── hooks/              # الأتمتة الوقائية
├── settings/           # الإعدادات (MCP)
└── README.md          # هذا الملف
```

## 🎨 ملفات Steering (الحوكمة)

### المبادئ الأساسية
1. **philosophy.md** - الفلسفة الهندسية (SDD + Security First)
2. **security.md** - معايير الأمان (OWASP)
3. **product.md** - نظرة عامة على المنتج

### المعايير التقنية
4. **tech-stack.md** - المكدس التقني المعتمد (Flutter/Dart)
5. **structure.md** - البنية الهيكلية والمعمارية
6. **tech.md** - التوجيهات التقنية العامة

### أفضل الممارسات
7. **flutter-best-practices.md** - أفضل ممارسات Flutter ⭐
8. **testing-best-practices.md** - أفضل ممارسات الاختبارات
9. **git-best-practices.md** - أفضل ممارسات Git
10. **docker-best-practices.md** - أفضل ممارسات Docker
11. **contracts.md** - العقود الهندسية (Design by Contract)
12. **terraform-governance.md** - حوكمة Terraform

## 🤖 ملفات Prompts (التوجيهات)

1. **system_default.prompt.md** - التوجيه الافتراضي
2. **system_spec_writer.prompt.md** - توجيه كتابة المواصفات
3. **system_code_generator.prompt.md** - توجيه توليد الكود
4. **executeTask.prompt.md** - توجيه تنفيذ المهام
5. **prReview.prompt.md** - توجيه مراجعة Pull Requests

## 🔧 ملفات Settings

### mcp.json (Model Context Protocol)
يحدد مصادر المعرفة الخارجية:
- Project Documentation (Priority: 95)
- Kiro Docs (Priority: 90)
- Flutter Docs (Priority: 88)
- Riverpod Docs (Priority: 85)
- OWASP Mobile (Priority: 87)
- Dart Style Guide (Priority: 82)

## 🪝 Hooks (الأتمتة الوقائية)

```
hooks/
├── on-commit/      # تُنفذ عند الـ commit
├── on-save/        # تُنفذ عند حفظ الملف
├── on-push/        # تُنفذ عند الـ push
├── pre-push/       # تُنفذ قبل الـ push
└── manual/         # Hooks يدوية
```

## 📋 Specs (المواصفات)

### البنية
كل spec يحتوي على:
1. **requirements.md** - المتطلبات (User Stories + Acceptance Criteria)
2. **design.md** - التصميم (Architecture + Components + Testing Strategy)
3. **tasks.md** - المهام (Implementation Plan)

### Specs الحالية
- **testing-system/** - نظام الاختبارات الشامل
- **critical-fixes/** - الإصلاحات الحرجة

## 🎯 المبادئ الأساسية

### 0. المبدأ الصفري: Security First
> "يجب أن تلتزم جميع أنشطة التطوير بمعايير الأمان المحددة في `steering/security.md`"

### 1. المبدأ الأساسي: Spec-Driven Development
> "كل عمل يجب أن يكون ناتجاً عن مواصفة واضحة ومكتملة وموافق عليها"

### 2. القيم الأساسية
- **الاستدامة (Sustainability)** - حلول قابلة للصيانة
- **الشفافية (Transparency)** - قرارات موثقة
- **الجودة أولاً (Quality First)** - تغطية 70%+ اختبارات

## 🚀 كيفية الاستخدام

### للمطورين

#### 1. إنشاء ميزة جديدة
```bash
# 1. إنشاء spec جديد
# افتح Kiro IDE واطلب: "أريد إنشاء spec لميزة X"

# 2. اتبع دورة SDD
# Requirements → Design → Tasks

# 3. ابدأ التنفيذ
# افتح tasks.md وابدأ بالمهمة الأولى
```

#### 2. تنفيذ مهمة
```bash
# 1. افتح .kiro/specs/[feature-name]/tasks.md
# 2. اختر المهمة التالية
# 3. اطلب من Kiro: "نفذ المهمة X.Y"
```

#### 3. مراجعة الكود
```bash
# الوكيل سيستخدم prReview.prompt.md تلقائياً
# للتحقق من:
# - الالتزام بالمعايير
# - الأمان
# - الجودة
```

### للوكيل (Kiro Agent)

#### القواعد الإلزامية
1. **اقرأ steering/** قبل أي عمل
2. **التزم بـ tech-stack.md** - لا استثناءات
3. **اتبع structure.md** - البنية إلزامية
4. **طبق security.md** - الأمان أولاً
5. **استخدم flutter-best-practices.md** - دائماً

#### عند إنشاء كود
```
1. تحقق من وجود spec
2. اقرأ requirements.md
3. اقرأ design.md
4. نفذ tasks.md
5. اكتب الاختبارات
6. تحقق من الجودة
```

## 📊 معايير الجودة

### Code Quality
- **Test Coverage:** ≥ 70%
- **Linting:** 0 errors, 0 warnings
- **Documentation:** جميع public APIs موثقة

### Security
- **OWASP Compliance:** إلزامي
- **No Hardcoded Secrets:** إلزامي
- **Input Validation:** إلزامي

### Performance
- **Build Time:** < 30s (debug)
- **App Size:** < 50 MB (release)
- **Startup Time:** < 2s

## 🔍 التحقق من الإعداد

### تحقق من اكتمال البنية
```bash
# يجب أن ترى:
tree .kiro -L 2

# النتيجة المتوقعة:
# .kiro/
# ├── specs/
# ├── steering/ (12 ملف)
# ├── prompts/ (5 ملفات)
# ├── hooks/
# ├── settings/
# └── README.md
```

### تحقق من ملفات steering
```bash
ls -1 .kiro/steering/

# يجب أن ترى 12 ملف:
# contracts.md
# docker-best-practices.md
# flutter-best-practices.md
# git-best-practices.md
# philosophy.md
# product.md
# security.md
# structure.md
# tech.md
# tech-stack.md
# terraform-governance.md
# testing-best-practices.md
```

## 📚 الموارد

### التوثيق
- [KIRO_STRATEGIC_ANALYSIS.md](../KIRO_STRATEGIC_ANALYSIS.md) - تحليل شامل
- [README.md](../README.md) - دليل المشروع
- [DEVELOPMENT_GUIDE.md](../DEVELOPMENT_GUIDE.md) - دليل التطوير

### المراجع الخارجية
- [Kiro IDE Docs](https://kiro.dev/docs)
- [Flutter Docs](https://docs.flutter.dev)
- [Riverpod Docs](https://riverpod.dev)
- [OWASP Mobile](https://owasp.org/www-project-mobile-security)

## 🤝 المساهمة

### تحديث ملفات Steering
```
⚠️ تحذير: لا تعدل ملفات steering مباشرة!

الطريقة الصحيحة:
1. إنشاء spec جديد
2. توثيق التغيير المقترح
3. مراجعة والموافقة
4. تحديث الملف
```

### إضافة spec جديد
```bash
# 1. إنشاء مجلد جديد
mkdir -p .kiro/specs/[feature-name]

# 2. إنشاء الملفات الثلاثة
touch .kiro/specs/[feature-name]/requirements.md
touch .kiro/specs/[feature-name]/design.md
touch .kiro/specs/[feature-name]/tasks.md

# 3. اتبع القوالب الموجودة
```

## ⚠️ تحذيرات مهمة

### ❌ لا تفعل
- ❌ لا تعدل ملفات steering بدون spec
- ❌ لا تتجاوز المكدس التقني المعتمد
- ❌ لا تكتب كود بدون spec موافق عليه
- ❌ لا تخزن أسرار في الكود
- ❌ لا تتجاهل معايير الأمان

### ✅ افعل
- ✅ اقرأ steering/ قبل البدء
- ✅ اتبع دورة SDD
- ✅ اكتب اختبارات شاملة
- ✅ وثق الكود
- ✅ راجع الجودة

## 📞 الدعم

للحصول على المساعدة:
1. راجع التوثيق في `Documentation/`
2. اقرأ `KIRO_STRATEGIC_ANALYSIS.md`
3. افتح issue في المستودع

---

**تم الإعداد بواسطة:** Kiro Strategic Agent  
**التاريخ:** 27 نوفمبر 2025  
**الإصدار:** 1.0  
**الحالة:** ✅ جاهز للاستخدام
