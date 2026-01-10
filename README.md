# 💎 نظام بصير المحاسبي (Basir Accounting System)

[![Flutter](https://img.shields.io/badge/Flutter-3.35.5-02569B?style=flat-square&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?style=flat-square&logo=dart)](https://dart.dev)
[![Rust](https://img.shields.io/badge/Rust-1.83-000000?style=flat-square&logo=rust)](https://www.rust-lang.org)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)
[![Quality](https://img.shields.io/badge/Purity-Diamond%20💎-6366F1?style=flat-square)](ENGINEERING_AUDIT_REPORT.md)

**نظام بصير المحاسبي** هو حل تقني متطور لإدارة العمليات المالية والمحاسبية، مصمم للشركات التي تسعى للنقاء الماسي في بياناتها، والامتثال للمعايير العالمية (**IFRS/GAAP**) مع دعم كامل لـ **ZATCA** (هيئة الزكاة والضريبة والجمارك السعودية).

> 🎯 **تم بناء هذا النظام وفق منهجيات هندسية صارمة:**
>
> - **Spec-Driven Development (SDD)** - التطوير المبني على المواصفات.
> - **Security First** - الأمان أولاً في كل طبقة.
> - **Diamond Purity** - نظافة مطلقة بصفر أخطاء.

---

## 📋 المحتويات

- [✨ الميزات الرئيسية](#-الميزات-الرئيسية)
- [🏮 مركز الأتمتة (Automation Hub)](#-مركز-الأتمتة-automation-hub)
- [🚀 البدء السريع](#-البدء-السريع)
- [🏗️ البنية المعمارية](#%ef%b8%8f-البنية-المعمارية)
- [🛡️ الجودة والموثوقية](#%ef%b8%8f-الجودة-والموثوقية)
- [📚 التوثيق والمراجع](#-التوثيق-والمراجع)

---

## ✨ الميزات الرئيسية

| الميزة                   | الوصف                                            |
| :----------------------- | :----------------------------------------------- |
| **🧮 محرك محاسبي مزدوج** | نواة Rust عالية الأداء مع واجهة Flutter أنيقة.   |
| **🌍 ثنائية اللغة**      | دعم كامل للعربية والإنجليزية مع تخطيط RTL/LTR.   |
| **🔒 تخزين محلي آمن**    | استخدام Isar DB مع تشفير بيانات كامل.            |
| **📜 امتثال ZATCA**      | توليد فواتير إلكترونية ورموز QR بتوقيع رقمي.     |
| **📊 التقارير المالية**  | ميزانية عمومية، قوائم دخل، وتقارير أعمار الديون. |
| **🤖 أتمتة ذكية**        | Makefile ثنائي اللغة يدير كافة العمليات.         |
| **🛡️ حماية الكود**       | Git Hooks ونظام Sentinel للتدقيق التلقائي.       |

---

## 🏮 مركز الأتمتة (Automation Hub)

يستخدم المشروع `Makefile` كنقطة دخول موحدة لجميع العمليات. للحصول على قائمة الأوامر الكاملة:

```bash
make help
```

### الأوامر الأساسية

| الأمر          | الوصف العربي                         | English              |
| :------------- | :----------------------------------- | :------------------- |
| `make setup`   | الإعداد الأولي الكامل 🏗️             | Full initial setup   |
| `make run`     | تشغيل التطبيق 🚀                     | Run the application  |
| `make test`    | تشغيل كافة الاختبارات 🧪             | Run all test suites  |
| `make analyze` | تحليل الكود الثابت 🔍                | Static code analysis |
| `make format`  | تنسيق الكود تلقائياً 📝              | Auto-format code     |
| `make gen`     | توليد الأكواد (Freezed, Riverpod) ⚙️ | Generate code        |

### أوامر الجودة والتقارير

| الأمر               | الوصف                                       |
| :------------------ | :------------------------------------------ |
| `make report`       | إنشاء تقرير جودة شامل في `logs/reports/` 📊 |
| `make purity-check` | فحص معايير "النقاء الماسي" 💎               |
| `make health-check` | فحص صحة البيئة التطويرية 🏥                 |
| `make rust-build`   | بناء المكتبة الأصلية Rust 🦀                |

---

## 🚀 البدء السريع

### المتطلبات الأساسية

- **Flutter SDK**: 3.35.5 أو أحدث
- **Dart SDK**: 3.9.2 أو أحدث
- **Rust Toolchain**: 1.83 أو أحدث
- **Make**: (مثبت مسبقاً على Linux/macOS)

### خطوات التشغيل

```bash
# 1️⃣ استنساخ المستودع
git clone <repository-url>
cd basir_accounting_system

# 2️⃣ الإعداد الشامل (يشمل Flutter, Rust, Git Hooks)
make setup

# 3️⃣ توليد الأكواد (Freezed, Riverpod Generators)
make gen

# 4️⃣ التشغيل في وضع التطوير
make run

# (اختياري) بناء APK للإنتاج
make build-apk
```

---

## 🏗️ البنية المعمارية

يتبع المشروع **Feature-First Clean Architecture** مع فصل صارم بين الطبقات:

```text
basir_accounting_system/
├── 📂 lib/                          # كود التطبيق (Flutter/Dart)
│   ├── core/                        # المكونات الأساسية
│   │   ├── assets/                  # الشعارات والرموز
│   │   ├── theme/                   # نظام التصميم (Design Tokens)
│   │   ├── providers/               # Riverpod Providers المشتركة
│   │   └── services/                # الخدمات العامة (Auth, Sync)
│   ├── features/                    # الميزات المستقلة
│   │   ├── accounting/              # المحاسبة (Chart of Accounts, Journal)
│   │   ├── invoices/                # الفواتير والـ ZATCA
│   │   ├── reports/                 # التقارير المالية
│   │   └── settings/                # الإعدادات والتخصيص
│   └── shared/                      # Widgets مشتركة
│
├── 🦀 rust/                         # المحرك المحاسبي الأصلي
│   └── src/                         # منطق الحسابات المتقدم
│
├── 🧪 test/                         # الاختبارات الشاملة
│   ├── unit/                        # اختبارات الوحدات
│   ├── widget/                      # اختبارات الواجهات
│   ├── integration/                 # اختبارات التكامل
│   └── property/                    # اختبارات الخصائص
│
├── 📜 scripts/                      # سكريبتات الأتمتة
│   ├── verify_branding.sh           # تدقيق الهوية
│   └── archive/                     # أرشيف السكريبتات القديمة
│
├── 🔧 tools/                        # أدوات التشخيص والمقاييس
│
└── 📚 docs/                         # التوثيق الشامل
```

### طبقات الـ Feature

```text
features/[feature_name]/
├── domain/          # 🧠 المنطق والواجهات (Entities, Repositories)
├── data/            # 💾 التنفيذ (API, Local Storage, Models)
├── application/     # ⚙️ الخدمات (Business Logic Services)
└── presentation/    # 🎨 واجهة المستخدم (Screens, Widgets, Providers)
```

---

## 🛡️ الجودة والموثوقية

### حالة النظام الحالية

| المقياس                           | الحالة                     |
| :-------------------------------- | :------------------------- |
| **تحليل الكود (Flutter Analyze)** | ✅ No issues found!        |
| **التنسيق (Dart Format)**         | ✅ 0 changes               |
| **نسبة نجاح الاختبارات**          | ✅ 100% (822+ tests)       |
| **تدقيق الهوية (Branding)**       | ✅ Clean                   |
| **حالة النقاء**                   | 💎 Diamond Purity Achieved |

### أنظمة الحماية التلقائية

1. **Elite Sentinel (Git Pre-commit Hook):**

   - التحقق من الهوية/البراند.
   - منع انتهاكات Clean Architecture.
   - اكتشاف الألوان المحددة يدوياً (Hardcoded Colors).

2. **Pre-push Hooks:**

   - تشغيل جميع الاختبارات قبل الدفع.
   - التحقق من تغطية الكود.

3. **Branding Verification Script:**

   ```bash
   ./scripts/verify_branding.sh
   ```

---

## 📚 التوثيق والمراجع

| الملف                                                      | الوصف                    |
| :--------------------------------------------------------- | :----------------------- |
| [STRUCTURE.md](STRUCTURE.md)                               | 🗺️ دليل هيكلة النظام     |
| [ENGINEERING_AUDIT_REPORT.md](ENGINEERING_AUDIT_REPORT.md) | 🛡️ تقرير التدقيق الهندسي |
| [CONTRIBUTING.md](CONTRIBUTING.md)                         | 🤝 دليل المساهمة         |
| [docs/design_tokens_guide.md](docs/design_tokens_guide.md) | 🎨 دليل نظام التصميم     |
| [docs/QUICK_START.md](docs/QUICK_START.md)                 | ⚡ البدء السريع المفصل   |
| [.kiro/steering/README.md](.kiro/steering/README.md)       | 🧭 المعايير الاستراتيجية |

---

## 🧰 التقنيات المستخدمة

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"/>
  <img src="https://img.shields.io/badge/Rust-000000?style=for-the-badge&logo=rust&logoColor=white" alt="Rust"/>
  <img src="https://img.shields.io/badge/Riverpod-00B4AB?style=for-the-badge&logo=dart&logoColor=white" alt="Riverpod"/>
  <img src="https://img.shields.io/badge/Isar_DB-5C2D91?style=for-the-badge&logo=database&logoColor=white" alt="Isar"/>
</p>

---

## 📄 الترخيص

هذا المشروع مرخص بموجب [MIT License](LICENSE).

---

<p align="center">
  <strong>نظام بصير المحاسبي</strong> | Diamond Purity Framework 💎<br>
  <em>صُمم بحب واهتمام هندسي في المملكة العربية السعودية 🇸🇦</em>
</p>

---

**الإصدار:** 2.0.0 (Diamond Purity Release)  
**آخر تحديث:** 10 يناير 2026
