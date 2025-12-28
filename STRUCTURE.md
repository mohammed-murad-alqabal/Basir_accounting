# 🗺️ مشروع بصير - دليل هيكلة النظام (STRUCTURE.md)

**المشروع:** بصير MVP  
**الحالة:** 🔄 قيد التحسين والتنظيف (Phase 0)  
**آخر تحديث:** 26 ديسمبر 2025

---

## 📋 نظرة عامة

هذا الملف هو المرجع الأساسي لهيكل المشروع وتنظيمه. يهدف إلى تسهيل التصفح وفهم العلاقة بين المكونات البرمجية والمواصفات التي تقود عملية التطوير (Spec-Driven Development).

---

## 🏗️ هيكل المجلدات الرئيسي

| المجلد                                                                  | الوصف                   | المكونات الأساسية                                                                                                    |
| :---------------------------------------------------------------------- | :---------------------- | :------------------------------------------------------------------------------------------------------------------- |
| **[lib/](file:///home/m/Projects/Basser_MVP/lib/)**                     | كود التطبيق (Flutter)   | الوجدات (Widgets)، النماذج (Models)، الخدمات (Services)                                                              |
| **[Documentation/](file:///home/m/Projects/Basser_MVP/Documentation/)** | التوثيق الموحد          | [Project Status](file:///home/m/Projects/Basser_MVP/Documentation/status/PROJECT_STATUS.md), تقارير الجلسات، الأرشيف |
| **[.kiro/](file:///home/m/Projects/Basser_MVP/.kiro/)**                 | نظام التوجيه والمواصفات | المواصفات النشطة (specs/), ملفات التوجيه (steering/)                                                                 |
| **[test/](file:///home/m/Projects/Basser_MVP/test/)**                   | الاختبارات              | اختبارات الوحدات (Unit Tests), اختبارات الوجدات (Widget Tests)                                                       |
| **[tools/](file:///home/m/Projects/Basser_MVP/tools/)**                 | الأدوات البرمجية        | أدوات التنظيف والتنظيم (advanced-cleanup/)                                                                           |
| **[logs/](file:///home/m/Projects/Basser_MVP/logs/)**                   | السجلات                 | أرشيف السجلات، سجلات العمليات                                                                                        |

---

## 🎯 المواصفات النشطة (Active Specs)

يمكنك تتبع تقدم التطوير من خلال المواصفات في [.kiro/specs/active/](file:///home/m/Projects/Basser_MVP/.kiro/specs/active/):

- ✅ **[repository-cleanup-organization](file:///home/m/Projects/Basser_MVP/.kiro/specs/active/repository-cleanup-organization/)**: تنظيف المستودع من التضخم.
- 🔄 **[structure-optimization](file:///home/m/Projects/Basser_MVP/.kiro/specs/active/structure-optimization/)**: تحسين وتطوير هذا الدليل.
- 🎨 **[brand-visual-identity](file:///home/m/Projects/Basser_MVP/.kiro/specs/active/brand-visual-identity/)**: الهوية البصرية والتصاميم الموحدة.

---

## 🛡️ معايير الجودة والتوافق

- **Architecture**: Clean Architecture with Riverpod & Isar.
- **I18n**: دعم كامل للغتين العربية والإنجليزية.
- **Testing**: التزام بنسبة تغطية عالية للاختبارات.

---

## 📞 الدعم والمساهمة

يرجى الرجوع إلى [CONTRIBUTING.md](file:///home/m/Projects/Basser_MVP/CONTRIBUTING.md) لفهم معايير كتابة الكود والتوثيق.
