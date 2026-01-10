# نظام بصير المحاسبي (Basir Accounting System)

[![Flutter](https://img.shields.io/badge/Flutter-3.35.5-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.2-blue.svg)](https://dart.dev)
[![CI/CD](https://github.com/YOUR_USERNAME/basir-app/workflows/Flutter%20CI/CD/badge.svg)](https://github.com/YOUR_USERNAME/basir-app/actions)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**نظام بصير المحاسبي** هو حل تقني متطور لإدارة العمليات المالية والمحاسبية، مصمم للشركات التي تسعى للنقاء الماسي في بياناتها والامتثال للمعايير العالمية (IFRS/GAAP) مع واجهة عربية احترافية.

> 🎯 **Kiro Strategic Workspace** - يتبع المشروع منهجية Spec-Driven Development (SDD) ومبدأ Security First ومبدأ Diamond Purity.

---

## 📋 المحتويات

- [نظرة عامة](#نظرة-عامة)
- [⚙️ نظام الأتمتة (Automation Hub)](#%ef%b8%8f-نظام-الأتمتة-automation-hub)
- [🚀 البدء السريع](#-البدء-السريع)
- [🏗️ البنية المعمارية](#%ef%b8%8f-البنية-المعمارية)
- [🛡️ جودة الكود والتقارير](#%ef%b8%8f-جودة-الكود-والتقارير)
- [📚 الموارد والاختصارات](#-الموارد-والاختصارات)

---

## نظرة عامة

يوفر نظام بصير حلاً متكاملاً يجمع بين سرعة **Rust** ومرونة **Flutter**:

- **نواة محاسبية صلبة:** محرك محاسبي مبني بـ Rust لضمان الدقة والسرعة.
- **تخزين محلي آمن:** استخدام Isar DB مع تشفير كامل.
- **امتثال كامل:** دعم ضريبة القيمة المضافة (VAT) ومعايير ZATCA.
- **أتمتة شاملة:** نظام Makefile ثنائي اللغة لإدارة دورة حياة المشروع.

---

## ⚙️ نظام الأتمتة (Automation Hub)

نستخدم `Makefile` لإدارة كافة العمليات بذكاء. يمكنك عرض المساعدة عبر:

```bash
make help
```

### الأوامر الأساسية:

| الأمر               | الوصف العربي               | English Description       |
| :------------------ | :------------------------- | :------------------------ |
| `make setup`        | الإعداد الأولي للبيئة      | Initial environment setup |
| `make run`          | تشغيل التطبيق              | Run the application       |
| `make test`         | تشغيل كافة الاختبارات      | Run all suites            |
| `make report`       | إنشاء تقرير جودة احترافي   | Generate quality report   |
| `make purity-check` | فحص معايير "النقاء الماسي" | Diamond Purity check      |

---

## 🚀 البدء السريع

### المتطلبات

- Flutter SDK (Latest Stable)
- Rust Toolchain
- Make (للأنظمة المتوافقة مع Unix)

### خطوات التشغيل

```bash
# 1. استنساخ المستودع
git clone <repository-url>
cd basir_accounting_system

# 2. الإعداد والبناء
make setup
make gen

# 3. التشغيل
make run
```

---

## 🛡️ جودة الكود والتقارير

يتميز المشروع بنظام **Elite Quality Engine** الذي يضمن سلامة الكود قبل الدمج:

- **التقارير الآلية:** استخدم `make report` لإنشاء تقرير شامل في `logs/reports/`.
- **التدقيق البرمجي:** سكريبت `verify_branding.sh` يفحص كافة الملفات لضمان ثبات الهوية.
- **التحليل الثابت:** تحليل دقيق بنسبة أخطاء (0).

---

## 🏗️ البنية المعمارية (Feature-First)

```text
lib/
├── core/              # المكونات الأساسية (Security, Theme, Providers)
├── features/          # الميزات المستقلة (Accounting, Auth, Dashboard)
│   ├── [Feature]/
│   │   ├── domain/     # Logic & Interfaces
│   │   ├── data/       # Repositories & Models
│   │   └── presentation/# UI & State
└── shared/            # Widgets و Utilities مشتركة
```

---

## 📚 الموارد والاختصارات

- [دليل التطوير](DEVELOPMENT_GUIDE.md) - للمساهمين الجدد.
- [تقرير التدقيق الهندسي](ENGINEERING_AUDIT_REPORT.md) - تفاصيل التحسينات الكبرى.
- [المعايير الاستراتيجية](.kiro/steering/README.md) - قوانين العمل في Kiro.

---

**الإصدار الحلي:** 1.7.5 (Global Expansion Phase)
_تم التحديث بذكاء ودقة عالية في 10 يناير 2026_
