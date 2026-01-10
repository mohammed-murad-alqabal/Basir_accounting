# 🗺️ مشروع بصير - دليل هيكلة النظام (STRUCTURE.md)

**المشروع:** نظام بصير المحاسبي (Basir Accounting System)  
**الحالة:** ✅ مكتمل (Diamond Purity Achieved)  
**آخر تحديث:** 10 يناير 2026

---

## 📋 نظرة عامة

هذا الملف هو المرجع الأساسي لهيكل المشروع وتنظيمه. تم تصميم الهيكل ليكون نظيفاً، احترافياً، وقابلاً للتوسع، مع الالتزام بمبادئ Clean Architecture و Separation of Concerns.

---

## 🏮 مركز الأتمتة (Automation Hub)

يعتمد المشروع على **Makefile** كمركز أتمتة شامل يدعم اللغتين (العربية والإنجليزية):

- **الإعداد:** `make setup`
- **الجودة:** `make purity-check`, `make health-check`, `make report`
- **التطوير:** `make run`, `make rust-build`, `make gen`

---

## 🏗️ هيكل المجلدات الرئيسي

| المجلد       | الوصف                   | المكونات الأساسية                                                                                 |
| :----------- | :---------------------- | :------------------------------------------------------------------------------------------------ |
| **lib/**     | كود التطبيق (Flutter)   | الوجدات (Widgets)، النماذج (Models)، الخدمات (Services)                                           |
| **rust/**    | المحرك المحاسبي (Rust)  | نماذج البيانات، منطق الحسابات المتقدم، والـ Core Accounting Logic                                 |
| **docs/**    | التوثيق الموحد          | [ENGINEERING_AUDIT_REPORT.md](ENGINEERING_AUDIT_REPORT.md), أرشيف الجلسات، لقطات الشاشة           |
| **.kiro/**   | نظام التوجيه والمواصفات | المواصفات النشطة (specs/), ملفات التوجيه (steering/)                                              |
| **test/**    | الاختبارات              | اختبارات الوحدات (Unit Tests), الوجدات، والاختبارات التكامليّة (Integration)                      |
| **tools/**   | الأدوات البرمجية        | أدوات التشخيص (diagnostics/), المقاييس (metrics/), والأتمتة المساعدة                              |
| **scripts/** | سكريبتات مساعدة         | سكريبتات البراند (verify_branding.sh)، التقارير (generate_quality_report.sh)، والأرشيف (archive/) |
| **assets/**  | الأصول الثابتة          | الصور، الخطوط، أيقونات التطبيق                                                                    |
| **logs/**    | السجلات والتقارير       | أرشيف التقارير الذكية (reports/), سجلات العمليات والتشخيص                                         |

---

## 🎯 المواصفات النشطة (Active Specs)

يمكنك تتبع تقدم التطوير من خلال المواصفات في [.kiro/specs/active/]:

1. **[git-merge-automation](.kiro/specs/active/git-merge-automation/)**: أتمتة عمليات الدمج وضمان الجودة (مكتمل).
2. **[guest-mode-upgrade-ui](.kiro/specs/active/guest-mode-upgrade-ui/)**: تنفيذ واجهة ترقية وضع الضيف (قيد التنفيذ).
3. **[brand-visual-identity](.kiro/specs/active/brand-visual-identity/)**: الهوية البصرية ونظام التصميم (مكتمل).

---

## 🛡️ معايير الجودة والتوافق

- **Architecture**: Clean Architecture with Riverpod & Isar.
- **I18n**: دعم كامل للغتين العربية والإنجليزية (RTL/LTR).
- **Testing**: التزام بنسبة تغطية عالية للاختبارات (100% Pass Rate).
- **Automation**: استخدام Git Hooks و GitHub Actions لضمان الجودة.

---

## 📞 الدعم والمساهمة

يرجى الرجوع إلى [CONTRIBUTING.md](CONTRIBUTING.md) لفهم معايير كتابة الكود والتوثيق.
