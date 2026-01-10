# 🗺️ مشروع بصير - دليل هيكلة النظام (STRUCTURE.md)

**المشروع:** نظام بصير المحاسبي (Basir Accounting System)  
**الحالة:** 💎 Diamond Purity Achieved  
**الإصدار:** 2.0.0  
**آخر تحديث:** 10 يناير 2026

---

## 📋 نظرة عامة

هذا الملف هو **المرجع الأساسي** لهيكل المشروع وتنظيمه. تم تصميم الهيكل ليكون نظيفاً، احترافياً، وقابلاً للتوسع، مع الالتزام بمبادئ:

- ✅ **Clean Architecture** - فصل صارم بين الطبقات.
- ✅ **Separation of Concerns** - كل مكون له مسؤولية واحدة.
- ✅ **Diamond Purity** - صفر أخطاء، صفر تحذيرات.

---

## 🏮 مركز الأتمتة (Automation Hub)

يعتمد المشروع على **Makefile** كمركز أتمتة شامل يدعم اللغتين (العربية والإنجليزية):

### أوامر الإعداد والتطوير

```bash
make setup           # الإعداد الأولي الكامل
make run             # تشغيل التطبيق
make gen             # توليد الأكواد
make rust-build      # بناء المكتبة الأصلية
```

### أوامر الجودة والتدقيق

```bash
make analyze         # تحليل الكود
make test            # تشغيل الاختبارات
make purity-check    # فحص النقاء الماسي 💎
make health-check    # فحص صحة البيئة
make report          # إنشاء تقرير جودة شامل
```

---

## 🏗️ هيكل المجلدات الرئيسي

### 📂 مجلدات الكود المصدري

| المجلد    | الوصف                  | المكونات الأساسية                       |
| :-------- | :--------------------- | :-------------------------------------- |
| **lib/**  | كود التطبيق (Flutter)  | core/, features/, shared/               |
| **rust/** | المحرك المحاسبي (Rust) | منطق الحسابات المتقدم، نماذج البيانات   |
| **test/** | الاختبارات الشاملة     | unit/, widget/, integration/, property/ |

### 📂 مجلدات البنية التحتية

| المجلد               | الوصف                    | المكونات الأساسية                              |
| :------------------- | :----------------------- | :--------------------------------------------- |
| **scripts/**         | سكريبتات الأتمتة         | verify_branding.sh، generate_quality_report.sh |
| **scripts/archive/** | أرشيف السكريبتات القديمة | سكريبتات الإعداد والتثبيت القديمة              |
| **tools/**           | أدوات التشخيص            | diagnostics/, metrics/, test_diagnostics/      |

### 📂 مجلدات التوثيق والمساندة

| المجلد      | الوصف                   | المكونات الأساسية         |
| :---------- | :---------------------- | :------------------------ |
| **docs/**   | التوثيق الموحد          | أدلة، تقارير، جلسات العمل |
| **.kiro/**  | نظام التوجيه والمواصفات | specs/, steering/         |
| **logs/**   | السجلات والتقارير       | reports/, archive/        |
| **assets/** | الأصول الثابتة          | الصور، الخطوط، الأيقونات  |

---

## 📁 تفصيل مجلد lib/

```text
lib/
├── 📂 core/                          # المكونات الأساسية المشتركة
│   ├── assets/                       # الشعارات والرموز البرمجية
│   ├── config/                       # إعدادات التطبيق
│   ├── l10n/                         # ملفات الترجمة (ARB)
│   ├── models/                       # نماذج البيانات الأساسية
│   ├── providers/                    # Riverpod Providers المشتركة
│   ├── router/                       # نظام التوجيه (GoRouter)
│   ├── services/                     # الخدمات العامة
│   ├── theme/                        # 🎨 نظام التصميم الموحد
│   │   ├── tokens/                   # Design Tokens
│   │   └── services/                 # خدمات المظهر والتخصيص
│   └── utils/                        # أدوات مساعدة
│
├── 📂 features/                      # الميزات المستقلة (Feature-First)
│   ├── accounting/                   # 🧮 المحاسبة (Chart of Accounts, Journal)
│   ├── auth/                         # 🔐 المصادقة والأمان
│   ├── customers/                    # 👥 إدارة العملاء
│   ├── dashboard/                    # 📊 لوحة التحكم
│   ├── invoices/                     # 📄 الفواتير و ZATCA
│   ├── reports/                      # 📈 التقارير المالية
│   ├── settings/                     # ⚙️ الإعدادات
│   └── vendors/                      # 🏢 الموردين
│
└── 📂 shared/                        # المكونات المشتركة
    └── widgets/                      # Widgets قابلة لإعادة الاستخدام
```

### طبقات الـ Feature

كل ميزة تتبع هيكل **Clean Architecture**:

```text
features/[feature_name]/
├── domain/          # 🧠 المنطق والواجهات
│   ├── entities/    # الكيانات (Business Objects)
│   └── repositories/ # واجهات المستودعات (Interfaces)
│
├── data/            # 💾 التنفيذ
│   ├── models/      # نماذج البيانات (JSON/DB)
│   └── repositories/ # تنفيذ المستودعات
│
├── application/     # ⚙️ الخدمات
│   └── *_service.dart # منطق العمل (Business Logic)
│
└── presentation/    # 🎨 واجهة المستخدم
    ├── screens/     # الشاشات الرئيسية
    ├── widgets/     # Widgets خاصة بالميزة
    └── providers/   # Riverpod Providers
```

---

## 🎯 المواصفات النشطة (Active Specs)

يمكنك تتبع تقدم التطوير من خلال المواصفات في `.kiro/specs/active/`:

| المواصفة                          | الحالة         | الوصف                               |
| :-------------------------------- | :------------- | :---------------------------------- |
| `git-merge-automation/`           | ✅ مكتمل       | أتمتة عمليات الدمج وضمان الجودة     |
| `brand-visual-identity/`          | ✅ مكتمل       | الهوية البصرية ونظام التصميم        |
| `accounting-standards-framework/` | 🔄 قيد التنفيذ | إطار المعايير المحاسبية (IFRS/GAAP) |
| `guest-mode-upgrade-ui/`          | 🔄 قيد التنفيذ | واجهة ترقية وضع الضيف               |

---

## 🛡️ معايير الجودة والتوافق

### المعايير التقنية

| المعيار              | التفاصيل                             |
| :------------------- | :----------------------------------- |
| **Architecture**     | Clean Architecture + Riverpod + Isar |
| **Language Support** | العربية والإنجليزية (RTL/LTR)        |
| **Testing**          | 100% Pass Rate (822+ tests)          |
| **Analysis**         | Zero issues (flutter analyze)        |
| **Formatting**       | Zero changes (dart format)           |

### أنظمة الحماية التلقائية

1. **Elite Sentinel** - حارس البراند في Git Pre-commit.
2. **Architecture Guard** - منع انتهاكات الطبقات.
3. **Token Enforcement** - منع الألوان المحددة يدوياً.
4. **Pre-push Tests** - تشغيل الاختبارات قبل الدفع.

---

## 📚 الملفات الجذرية الرئيسية

| الملف                         | الغرض                    |
| :---------------------------- | :----------------------- |
| `README.md`                   | الواجهة الرئيسية للمشروع |
| `STRUCTURE.md`                | هذا الملف - دليل الهيكلة |
| `ENGINEERING_AUDIT_REPORT.md` | تقرير التدقيق الهندسي    |
| `CONTRIBUTING.md`             | دليل المساهمة            |
| `Makefile`                    | 🏮 مركز الأتمتة الموحد   |
| `pubspec.yaml`                | تكوين Flutter والتبعيات  |
| `analysis_options.yaml`       | قواعد التحليل الثابت     |

---

## 📞 الدعم والمساهمة

يرجى الرجوع إلى [CONTRIBUTING.md](CONTRIBUTING.md) لفهم معايير كتابة الكود والتوثيق.

---

<p align="center">
  💎 <strong>Diamond Purity Framework</strong> 💎<br>
  <em>نظام بصير المحاسبي</em>
</p>
