# 🗺️ مشروع بصير - دليل هيكلة النظام

**المشروع:** نظام بصير المحاسبي (Basir Accounting System)  
**الحالة:** 💎 Diamond Purity Achieved  
**الإصدار:** 1.0.0+1  
**آخر تحديث:** 06 أبريل 2026

---

## 📋 نظرة عامة

نظام بصير هو منصة محاسبية متكاملة من الجيل الجديد تنافس الحلول العالمية مثل Oracle NetSuite وSAP وSage. يجمع بين قوة **Rust** للحسابات ومرونة **Flutter** للواجهات، مع امتثال كامل لـ **ZATCA Phase 2**.

### المبادئ المعمارية

| المبدأ                 | التطبيق                                |
| :--------------------- | :------------------------------------- |
| **Clean Architecture** | فصل صارم بين Domain/Data/Presentation  |
| **Feature-First**      | كل وحدة محاسبية مستقلة بذاتها          |
| **Offline-First**      | تشغيل كامل بدون إنترنت مع مزامنة لاحقة |
| **Security-First**     | تشفير البيانات في الراحة والنقل        |

---

## 🏮 مركز الأتمتة (Makefile Hub)

```bash
# الإعداد
make setup           # إعداد كامل للبيئة
make gen             # توليد الأكواد (Freezed, Riverpod)

# التطوير
make run             # تشغيل التطبيق
make rust-build      # بناء محرك Rust

# الجودة
make analyze         # تحليل الكود الثابت
make test            # تشغيل جميع الاختبارات
make purity-check    # فحص النقاء الماسي 💎
make report          # تقرير جودة شامل
```

---

## 📁 هيكل المشروع الرئيسي

```text
basir_accounting_system/
│
├── 📂 lib/                          # كود Flutter/Dart
│   ├── core/                        # المكونات الأساسية المشتركة
│   │   ├── assets/                  # الشعارات والأيقونات
│   │   ├── config/                  # إعدادات التطبيق
│   │   ├── l10n/                    # الترجمة (عربي/إنجليزي)
│   │   ├── models/                  # النماذج الأساسية
│   │   ├── providers/               # Riverpod Providers
│   │   ├── router/                  # GoRouter Navigation
│   │   ├── services/                # الخدمات العامة
│   │   ├── theme/                   # نظام التصميم (Design Tokens)
│   │   └── utils/                   # أدوات مساعدة
│   │
│   ├── features/                    # الوحدات المحاسبية
│   │   ├── accounting/              # 🧮 الدفتر العام
│   │   ├── invoices/                # 📄 الفوترة وZATCA
│   │   ├── customers/               # 👥 الذمم المدينة
│   │   ├── vendors/                 # 🏢 الذمم الدائنة
│   │   ├── inventory/               # 📦 المخزون
│   │   ├── assets/                  # 🏗️ الأصول الثابتة
│   │   ├── reports/                 # 📊 التقارير المالية
│   │   ├── dashboard/               # 📈 لوحة التحكم
│   │   ├── auth/                    # 🔐 المصادقة
│   │   └── settings/                # ⚙️ الإعدادات
│   │
│   └── shared/                      # المكونات المشتركة
│       └── widgets/                 # Widgets قابلة لإعادة الاستخدام
│
├── 🦀 rust/                         # محرك الحسابات (Rust)
│   └── crates/
│       ├── accounting_core/         # منطق الحسابات والقيود
│       ├── accounting_zatca/        # محرك ZATCA (QR, XML, Signing)
│       └── accounting_native/       # FFI Bridge مع Flutter
│
├── 🧪 test/                         # الاختبارات الشاملة
│   ├── unit/                        # اختبارات الوحدات
│   ├── widget/                      # اختبارات الواجهات
│   ├── integration/                 # اختبارات التكامل
│   └── property/                    # اختبارات الخصائص
│
├── 📜 scripts/                      # سكريبتات الأتمتة
│   ├── verify_branding.sh           # تدقيق الهوية
│   ├── generate_quality_report.sh   # تقرير الجودة
│   └── archive/                     # سكريبتات مؤرشفة
│
├── 🔧 tools/                        # أدوات التشخيص
│   ├── diagnostics/                 # أدوات تحليل الأخطاء
│   └── metrics/                     # قياس الأداء
│
├── 📚 docs/                         # التوثيق الشامل
│   ├── Core/                        # الوثائق الأساسية
│   ├── guides/                      # أدلة الاستخدام
│   └── reports/                     # التقارير
│
└── 🔒 .kiro/                        # نظام Kiro للتوجيه
    ├── specs/active/                # المواصفات النشطة
    └── steering/                    # قواعد التوجيه
```

---

## 🧩 هيكل الوحدة المحاسبية (Feature Structure)

كل وحدة محاسبية تتبع **Clean Architecture**:

```text
features/[module]/
├── domain/              # 🧠 منطق العمل
│   ├── entities/        # الكيانات (Business Objects)
│   └── repositories/    # واجهات المستودعات
│
├── data/                # 💾 التنفيذ
│   ├── models/          # نماذج البيانات (JSON/Isar)
│   └── repositories/    # تنفيذ المستودعات
│
├── application/         # ⚙️ الخدمات
│   └── *_service.dart   # Business Logic Services
│
└── presentation/        # 🎨 واجهة المستخدم
    ├── screens/         # الشاشات الرئيسية
    ├── widgets/         # Widgets خاصة
    └── providers/       # Riverpod State
```

---

## 🎯 الوحدات المحاسبية التفصيلية

| الوحدة            | المسار                 | الوظائف الرئيسية                |
| :---------------- | :--------------------- | :------------------------------ |
| **الدفتر العام**  | `features/accounting/` | دليل حسابات، قيود، ميزان مراجعة |
| **الفوترة**       | `features/invoices/`   | ZATCA، QR، توقيع رقمي           |
| **الذمم المدينة** | `features/customers/`  | عملاء، تقادم، تحصيل             |
| **الذمم الدائنة** | `features/vendors/`    | موردين، مشتريات، سداد           |
| **المخزون**       | `features/inventory/`  | منتجات، تقييم، جرد              |
| **الأصول**        | `features/assets/`     | إهلاك، صيانة، استبعاد           |
| **التقارير**      | `features/reports/`    | قوائم مالية، KPIs               |

---

## 🛡️ معايير الجودة

| المعيار         | الحالة               |
| :-------------- | :------------------- |
| Flutter Analyze | ✅ No issues         |
| Dart Format     | ✅ 0 changes         |
| Test Pass Rate  | ✅ 100% (822+ tests) |
| Branding Check  | ✅ Clean             |
| Diamond Purity  | 💎 Achieved          |

---

## 📚 الملفات الجذرية

| الملف                   | الغرض            |
| :---------------------- | :--------------- |
| `README.md`             | الواجهة الرئيسية |
| `STRUCTURE.md`          | هذا الملف        |
| `Makefile`              | مركز الأتمتة     |
| `pubspec.yaml`          | تكوين Flutter    |
| `analysis_options.yaml` | قواعد التحليل    |
| `CONTRIBUTING.md`       | دليل المساهمة    |

---

💎 **Diamond Purity Framework** | نظام بصير المحاسبي
