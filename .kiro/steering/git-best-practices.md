---
title: Git Best Practices
inclusion: always
---

# Git Best Practices

## 1. Commit Messages (Conventional Commits)
- **القاعدة:** يجب أن تتبع جميع رسائل الالتزام (Commit Messages) تنسيق Conventional Commits: `type(scope): description`.
- **الأنواع المعتمدة:** `feat` (ميزة جديدة)، `fix` (إصلاح خطأ)، `docs` (توثيق)، `style` (تنسيق)، `refactor` (إعادة هيكلة)، `test` (اختبارات)، `chore` (مهام صيانة).
- **الالتزام بالجودة:** يجب أن تكون الرسالة موجزة (أقل من 50 حرفًا في السطر الأول) وتستخدم صيغة الأمر (Imperative Mood).

## 2. Branching Strategy
- **الأساسية:** استخدام فروع الميزات (Feature Branches) لكل تطوير جديد.
- **الاستقرار:** يجب أن يظل الفرع الرئيسي (`main` أو `master`) مستقرًا وقابلاً للنشر دائمًا.
- **التنظيف:** حذف الفروع المدمجة للحفاظ على نظافة المستودع.

## 3. Workflow & History
- **التنظيف:** استخدام إعادة الأساس التفاعلية (Interactive Rebase) لتنظيف سجل الالتزامات قبل الدمج (Merge).
- **الأمان:** **يجب** استخدام خطاف `pre-push` لضمان عدم دفع أي أسرار أو مفاتيح API إلى المستودع (مبدأ الأمان أولاً).

## 4. Repository Management
- **الإصدارات:** وضع علامات (Tag) على الإصدارات باستخدام الترقيم الدلالي (Semantic Versioning).
- **التجاهل:** استخدام `.gitignore` لاستبعاد ملفات البناء والملفات المؤقتة.
