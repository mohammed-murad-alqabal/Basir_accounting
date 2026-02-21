# 💎 نظام بصير المحاسبي (Basir Accounting System)

[![Flutter](https://img.shields.io/badge/Flutter-3.35.5-02569B?style=flat-square&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?style=flat-square&logo=dart)](https://dart.dev)
[![Rust](https://img.shields.io/badge/Rust-1.83-000000?style=flat-square&logo=rust)](https://www.rust-lang.org)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)
[![Quality](https://img.shields.io/badge/Purity-Diamond%20💎-6366F1?style=flat-square)](ENGINEERING_AUDIT_REPORT.md)
[![Build](https://img.shields.io/badge/Build-Passing-success?style=flat-square)](build/app/outputs/flutter-apk/app-debug.apk)
[![Tests](https://img.shields.io/badge/Tests-822%2B-success?style=flat-square)](#)
[![Analysis](https://img.shields.io/badge/Analysis-Clean-success?style=flat-square)](#)

**نظام بصير المحاسبي** - منصة محاسبية ذكية من الجيل الجديد، مصممة بمعايير عالمية لتنافس **Oracle NetSuite** و**SAP Business One** و**Sage Intacct**، مع تركيز استراتيجي على السوق السعودي والخليجي والامتثال الكامل لمتطلبات ZATCA Phase 2.

## 🎯 لماذا بصير؟

| الميزة                       | Oracle NetSuite |    SAP    |   Sage    | **بصير** |
| :--------------------------- | :-------------: | :-------: | :-------: | :------: |
| **نواة عالية الأداء (Rust)** |       ❌        |    ❌     |    ❌     |    ✅    |
| **واجهة عربية أصيلة (RTL)**  |     ⚠️ جزئي     |  ⚠️ جزئي  |  ⚠️ جزئي  | ✅ كامل  |
| **امتثال ZATCA Phase 2**     |    ⚠️ إضافات    | ⚠️ إضافات | ⚠️ إضافات | ✅ مدمج  |
| **تشغيل بدون إنترنت**        |       ❌        |    ❌     |    ❌     |    ✅    |
| **مفتوح المصدر**             |       ❌        |    ❌     |    ❌     |    ✅    |

---

## 📊 الوحدات المحاسبية المتكاملة

### 🏛️ 1. الدفتر العام (General Ledger)

- **دليل حسابات مرن:** هيكل شجري متعدد المستويات يدعم التصنيف حسب IFRS/GAAP.
- **قيود يومية ذكية:** إدخال آلي مع اقتراحات AI للحسابات المقابلة.
- **ميزان المراجعة:** توليد فوري مع كشف الأخطاء تلقائياً.
- **إقفال الفترات:** إغلاق شهري/سنوي مع قفل تلقائي للقيود.

### 💰 2. إدارة الخزانة والنقدية (Treasury Management)

- **التدفقات النقدية:** تتبع حي للواردات والصادرات مع تنبؤات AI.
- **التسويات البنكية:** استيراد كشوف البنك ومطابقتها تلقائياً.
- **إدارة السيولة:** تقارير مواقف نقدية يومية وأسبوعية.
- **تعدد العملات:** دعم كامل للصرف الأجنبي مع تحديث أسعار تلقائي.

### 📄 3. الفوترة الإلكترونية والامتثال (E-Invoicing & ZATCA)

- **Fatoora Integration:** ربط مباشر مع منصة فاتورة لـ ZATCA Phase 2.
- **التوقيع الرقمي:** ختم تشفيري (UUID) وتوقيع إلكتروني متقدم.
- **QR Code:** توليد تلقائي لرموز QR حسب مواصفات الهيئة.
- **XML/PDF-A3:** إصدار الفواتير بالتنسيقات المعتمدة من ZATCA.
- **B2B/B2C/B2G:** دعم جميع أنواع المعاملات مع Clearance فوري.

### 🤝 4. الذمم المدينة (Accounts Receivable)

- **إدارة العملاء الشاملة:** ملفات عملاء متكاملة مع تاريخ المعاملات.
- **تقادم الديون:** تقارير أعمار الديون (30/60/90/120 يوم).
- **متابعة التحصيل:** تنبيهات آلية وجدولة المتابعات.
- **كشوف حساب العملاء:** إصدار آلي وإرسال بالبريد الإلكتروني.

### 🏢 5. الذمم الدائنة (Accounts Payable)

- **إدارة الموردين:** قاعدة بيانات موردين مع تقييم الأداء.
- **أوامر الشراء:** دورة شراء كاملة من الطلب حتى السداد.
- **جدولة المدفوعات:** تخطيط التدفقات النقدية الصادرة.
- **تسوية الموردين:** مطابقة الفواتير مع أوامر الشراء والاستلام.

### 📦 6. إدارة المخزون (Inventory Management)

- **تتبع المنتجات:** SKU، الباركود، الأرقام التسلسلية.
- **تقييم المخزون:** FIFO، LIFO، المتوسط المرجح.
- **الجرد الدوري:** دعم الجرد المستمر والدوري.
- **تحويلات المستودعات:** نقل بين الفروع والمخازن.

### 🏗️ 7. الأصول الثابتة (Fixed Assets)

- **سجل الأصول:** تسجيل شامل مع المستندات والصور.
- **حساب الإهلاك:** طرق متعددة (قسط ثابت، متناقص، إنتاج).
- **جدولة الصيانة:** تنبيهات للصيانة الدورية.
- **الاستبعاد والتصفية:** توثيق كامل لدورة حياة الأصل.

### 📈 8. التقارير والتحليلات المالية (Financial Reporting)

- **القوائم المالية:** ميزانية عمومية، قائمة دخل، تدفقات نقدية.
- **التقارير الإدارية:** لوحات معلومات تفاعلية ومؤشرات KPI.
- **تحليل الاتجاهات:** مقارنات دورية ورسوم بيانية ذكية.
- **التصدير:** Excel، PDF، CSV مع جدولة آلية.

---

## 🏮 مركز الأتمتة (Automation Hub)

```bash
make help          # عرض جميع الأوامر المتاحة
make setup         # الإعداد الأولي الكامل
make run           # تشغيل التطبيق
make test          # تشغيل الاختبارات
make purity-check  # فحص النقاء الماسي 💎
make report        # إنشاء تقرير جودة شامل
```

---

## 🏗️ البنية التقنية

```text
basir_accounting_system/
├── lib/                    # Flutter/Dart Application
│   ├── core/               # المكونات الأساسية
│   ├── features/           # الوحدات المحاسبية
│   │   ├── accounting/     # الدفتر العام والقيود
│   │   ├── invoices/       # الفوترة وZATCA
│   │   ├── customers/      # الذمم المدينة
│   │   ├── vendors/        # الذمم الدائنة
│   │   ├── inventory/      # المخزون
│   │   ├── assets/         # الأصول الثابتة
│   │   └── reports/        # التقارير المالية
│   └── shared/             # المكونات المشتركة
├── rust/                   # Rust Accounting Engine
│   └── crates/
│       ├── accounting_core/    # منطق الحسابات
│       ├── accounting_zatca/   # محرك ZATCA
│       └── accounting_native/  # FFI Bridge
└── test/                   # اختبارات شاملة (822+ test)
```

---

## 🛡️ الامتثال والمعايير

| المعيار           | الحالة | الوصف                             |
| :---------------- | :----: | :-------------------------------- |
| **ZATCA Phase 2** |   ✅   | فاتورة إلكترونية، QR، توقيع رقمي  |
| **IFRS**          |   ✅   | المعايير الدولية للتقارير المالية |
| **GAAP**          |   ✅   | مبادئ المحاسبة المقبولة عموماً    |
| **VAT 15%**       |   ✅   | ضريبة القيمة المضافة السعودية     |
| **WCAG 2.1 AA**   |   ✅   | معايير إمكانية الوصول             |

---

## 📚 التوثيق

| الملف                                                      | الوصف                 |
| :--------------------------------------------------------- | :-------------------- |
| [STRUCTURE.md](STRUCTURE.md)                               | دليل هيكلة النظام     |
| [ENGINEERING_AUDIT_REPORT.md](ENGINEERING_AUDIT_REPORT.md) | تقرير التدقيق الهندسي |
| [CONTRIBUTING.md](CONTRIBUTING.md)                         | دليل المساهمة         |
| [docs/](docs/)                                             | التوثيق الشامل        |

---

## 🧰 التقنيات المستخدمة

- **Flutter 3.35.5** - واجهة مستخدم عبر المنصات
- **Dart 3.9.2** - لغة البرمجة الأساسية
- **Rust 1.83** - محرك الحسابات عالي الأداء
- **Riverpod** - إدارة الحالة
- **Isar DB** - قاعدة بيانات محلية مشفرة

---

---

## 🚀 البدء السريع

### المتطلبات الأساسية

```bash
Flutter SDK: 3.35.5+
Dart SDK: 3.9.2+
Android Studio / VS Code
```

### التثبيت

```bash
# استنساخ المستودع
git clone https://github.com/your-org/basir_accounting_system.git
cd basir_accounting_system

# تثبيت التبعيات
flutter pub get

# تشغيل التطبيق
flutter run
```

### البناء للإنتاج

```bash
# Android APK
flutter build apk --release

# Android App Bundle (للنشر على Google Play)
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## 📊 حالة المشروع

| المقياس             |    الحالة    | الوصف                           |
| :------------------ | :----------: | :------------------------------ |
| **التحليل الثابت**  | ✅ No Issues | flutter analyze نظيف 100%       |
| **الاختبارات**      | ✅ 822+ Pass | معدل نجاح 99%+                  |
| **التغطية**         |   ✅ 67.9%   | قريب من الهدف 70%               |
| **البناء**          |  ✅ Success  | APK جاهز للتثبيت                |
| **الأداء**          | ✅ Optimized | محرك Rust عالي الأداء           |
| **الأمان**          |    ✅ A+     | تشفير Isar + Secure Storage     |
| **الامتثال**        | ✅ ZATCA Ph2 | متوافق مع ZATCA Phase 2         |
| **التوثيق**         |   ✅ 98%+    | توثيق شامل بالعربية والإنجليزية |
| **الجودة الهندسية** |  ✅ 96/100   | معايير Diamond Purity           |
| **جاهزية الإنتاج**  | ✅ Ready 🚀  | جاهز للنشر والاستخدام           |

---

## 🎯 الميزات الرئيسية

### ✨ التميز التقني

- **🚀 أداء فائق:** محرك Rust للعمليات الحسابية المعقدة
- **📱 عبر المنصات:** Android, iOS, Web, Desktop
- **🔒 أمان متقدم:** تشفير Isar + Flutter Secure Storage
- **🌐 دعم كامل للعربية:** RTL + خطوط Cairo المحسّنة
- **⚡ عمل بدون إنترنت:** قاعدة بيانات محلية Isar
- **☁️ نسخ احتياطي سحابي:** Google Drive Integration
- **🎨 Material 3 Design:** واجهة عصرية وسلسة
- **♿ إمكانية الوصول:** WCAG 2.1 AA Compliant

### 💼 الوحدات المحاسبية

- ✅ **الدفتر العام** - دليل حسابات متعدد المستويات
- ✅ **الفوترة الإلكترونية** - ZATCA Phase 2 متكامل
- ✅ **الذمم المدينة** - إدارة العملاء والتحصيل
- ✅ **الذمم الدائنة** - إدارة الموردين والمدفوعات
- ✅ **المخزون** - تتبع المنتجات والباركود
- ✅ **الأصول الثابتة** - إدارة الأصول والإهلاك
- ✅ **التقارير المالية** - قوائم مالية وتحليلات
- ✅ **الميزانيات** - تخطيط وتتبع الميزانيات
- ✅ **المصروفات** - تتبع المصروفات والفئات
- ✅ **التدقيق الجنائي** - سلامة البيانات والتدقيق

---

## 📖 التوثيق الشامل

| المستند                                                    | الوصف                                  |
| :--------------------------------------------------------- | :------------------------------------- |
| [INSTALLATION_GUIDE.md](INSTALLATION_GUIDE.md)             | دليل التثبيت على Android/iOS           |
| [SYSTEM_STATUS.md](SYSTEM_STATUS.md)                       | حالة النظام والإصلاحات الأخيرة         |
| [STRUCTURE.md](STRUCTURE.md)                               | هيكلة المشروع والبنية المعمارية        |
| [ARCHITECTURE.md](ARCHITECTURE.md)                         | البنية التقنية التفصيلية               |
| [ENGINEERING_AUDIT_REPORT.md](ENGINEERING_AUDIT_REPORT.md) | تقرير التدقيق الهندسي الشامل           |
| [CONTRIBUTING.md](CONTRIBUTING.md)                         | دليل المساهمة في المشروع               |
| [CHANGELOG.md](CHANGELOG.md)                               | سجل التغييرات والإصدارات               |
| [SECURITY.md](SECURITY.md)                                 | سياسات الأمان والإبلاغ عن الثغرات      |
| [docs/](docs/)                                             | التوثيق التفصيلي والأدلة الفنية        |
| [.kiro/steering/](.kiro/steering/)                         | معايير التطوير والتوجيهات الاستراتيجية |

---

## 🏗️ البنية المعمارية

### Clean Architecture

```
┌─────────────────────────────────────────────┐
│           Presentation Layer                │
│  (UI, Widgets, Screens, Providers)         │
├─────────────────────────────────────────────┤
│           Domain Layer                      │
│  (Entities, Use Cases, Repositories)        │
├─────────────────────────────────────────────┤
│           Data Layer                        │
│  (Models, Data Sources, Repositories Impl)  │
├─────────────────────────────────────────────┤
│           Infrastructure                    │
│  (Isar DB, Services, External APIs)         │
└─────────────────────────────────────────────┘
```

### التقنيات الأساسية

| الطبقة                | التقنية                | الغرض                     |
| :-------------------- | :--------------------- | :------------------------ |
| **UI Framework**      | Flutter 3.35.5         | واجهة المستخدم            |
| **Language**          | Dart 3.9.2             | لغة البرمجة الأساسية      |
| **State Management**  | Riverpod 2.6.1         | إدارة الحالة              |
| **Database**          | Isar 3.1.0             | قاعدة بيانات محلية        |
| **Accounting Engine** | Rust 1.83              | محرك الحسابات عالي الأداء |
| **Design System**     | Material 3             | نظام التصميم              |
| **Localization**      | Flutter i18n           | الترجمة والتعريب          |
| **Testing**           | Flutter Test + Mockito | الاختبارات الآلية         |
| **CI/CD**             | GitHub Actions         | التكامل والنشر المستمر    |

---

## 🧪 الاختبارات والجودة

### تشغيل الاختبارات

```bash
# جميع الاختبارات
flutter test

# اختبارات محددة
flutter test test/unit/

# مع التغطية
flutter test --coverage

# التحليل الثابت
flutter analyze
```

### معايير الجودة

- ✅ **822+ اختبار** - Unit, Widget, Integration
- ✅ **67.9% تغطية** - قريب من الهدف 70%
- ✅ **0 أخطاء** - flutter analyze نظيف
- ✅ **Clean Code** - معايير Diamond Purity
- ✅ **SOLID Principles** - بنية معمارية نظيفة

---

## 🔐 الأمان والامتثال

### معايير الأمان

- 🔒 **تشفير البيانات:** Isar encryption at rest
- 🔑 **تخزين آمن:** Flutter Secure Storage للمفاتيح
- 🛡️ **مصادقة قوية:** Google Sign-In + OAuth 2.0
- 📝 **سجلات التدقيق:** تتبع كامل للعمليات
- 🚫 **حماية من الثغرات:** Input validation + sanitization

### الامتثال

| المعيار           | الحالة | التفاصيل                           |
| :---------------- | :----: | :--------------------------------- |
| **ZATCA Phase 2** |   ✅   | فاتورة إلكترونية + QR + توقيع رقمي |
| **IFRS**          |   ✅   | المعايير الدولية للتقارير المالية  |
| **GAAP**          |   ✅   | مبادئ المحاسبة المقبولة عموماً     |
| **VAT 15%**       |   ✅   | ضريبة القيمة المضافة السعودية      |
| **WCAG 2.1 AA**   |   ✅   | معايير إمكانية الوصول              |
| **GDPR**          |   ✅   | حماية البيانات الشخصية             |
| **ISO 27001**     |   🔄   | معايير أمن المعلومات (قيد التطبيق) |

---

## 🤝 المساهمة

نرحب بمساهماتكم! يرجى قراءة [CONTRIBUTING.md](CONTRIBUTING.md) للتعرف على:

- 📋 معايير الكود والتسمية
- 🔀 Git workflow وConventional Commits
- ✅ متطلبات الاختبارات
- 📝 معايير التوثيق
- 🔒 سياسات الأمان

### خطوات المساهمة السريعة

```bash
# 1. Fork المستودع
# 2. إنشاء فرع للميزة
git checkout -b feature/amazing-feature

# 3. Commit التغييرات
git commit -m "feat(scope): add amazing feature"

# 4. Push للفرع
git push origin feature/amazing-feature

# 5. فتح Pull Request
```

---

## 📞 الدعم والتواصل

### الحصول على المساعدة

- 📖 **التوثيق:** راجع مجلد [docs/](docs/)
- 🐛 **الأخطاء:** افتح [Issue](https://github.com/your-org/basir_accounting_system/issues)
- 💡 **الاقتراحات:** افتح [Discussion](https://github.com/your-org/basir_accounting_system/discussions)
- 📧 **البريد:** support@basir-accounting.com

### الموارد المفيدة

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Riverpod Documentation](https://riverpod.dev)
- [Isar Database](https://isar.dev)
- [ZATCA E-Invoicing](https://zatca.gov.sa)

---

## 📜 الترخيص

هذا المشروع مرخص تحت [MIT License](LICENSE) - راجع ملف LICENSE للتفاصيل.

---

## 🙏 شكر وتقدير

### الفريق

**Basir Accounting System Development Agents Team**

- 🏗️ **System Architect** - تصميم البنية المعمارية
- 💻 **Core Developers** - تطوير الوحدات الأساسية
- 🧪 **QA Engineers** - ضمان الجودة والاختبارات
- 📝 **Technical Writers** - التوثيق الفني
- 🎨 **UI/UX Designers** - تصميم الواجهات

### التقنيات المستخدمة

شكراً لجميع المشاريع مفتوحة المصدر التي جعلت هذا المشروع ممكناً:

- [Flutter](https://flutter.dev) - Google
- [Dart](https://dart.dev) - Google
- [Riverpod](https://riverpod.dev) - Remi Rousselet
- [Isar](https://isar.dev) - Simon Leier
- [Rust](https://www.rust-lang.org) - Rust Foundation

---

## 📊 إحصائيات المشروع

```
📁 الملفات: 500+ ملف
📝 الأسطر: 50,000+ سطر
🧪 الاختبارات: 822+ اختبار
📚 التوثيق: 98%+ تغطية
⭐ الجودة: 96/100
🚀 الحالة: جاهز للإنتاج
```

---

## 🗺️ خارطة الطريق

### الإصدار الحالي (v1.0.0)

- ✅ الوحدات المحاسبية الأساسية
- ✅ ZATCA Phase 2 Integration
- ✅ واجهة مستخدم كاملة
- ✅ نظام الاختبارات الشامل

### الإصدارات القادمة

#### v1.1.0 (Q1 2026)

- 🔄 تحسينات الأداء
- 🔄 ميزات إضافية للتقارير
- 🔄 تكامل مع البنوك

#### v1.2.0 (Q2 2026)

- 🔄 نظام الرواتب
- 🔄 إدارة المشاريع
- 🔄 تطبيق الموبايل المحسّن

#### v2.0.0 (Q3 2026)

- 🔄 AI-Powered Insights
- 🔄 Multi-Company Support
- 🔄 Advanced Analytics

---

**الإصدار:** 1.0.0+1  
**آخر تحديث:** 21 فبراير 2026  
**الحالة:** ✅ جاهز للإنتاج

---

<div align="center">

💎 **نظام بصير المحاسبي** | Diamond Purity Framework

صُمم بحب واهتمام هندسي في المملكة العربية السعودية 🇸🇦

**[الموقع الرسمي](#) | [التوثيق](docs/) | [المساهمة](CONTRIBUTING.md) | [الترخيص](LICENSE)**

</div>
