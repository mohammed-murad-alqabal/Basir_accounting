---
title: المكدس التقني المعتمد
inclusion: always
---

# المكدس التقني المعتمد لمشروع بصير (Basser MVP)

## المبدأ الأساسي

يجب على فريق وكلاء تطوير مشروع بصير الالتزام الصارم بالمكدس التقني المعتمد في هذا الملف. الهدف هو توحيد الأدوات، تقليل التعقيد، وضمان التوافق مع أفضل الممارسات.

## التوجيهات للوكيل

1. **الالتزام الإلزامي:** لا يجوز استخدام أي لغة، إطار عمل، أو أداة غير مدرجة في هذا الملف دون موافقة صريحة.
2. **الرفض التلقائي:** إذا طُلب منك استخدام تقنية غير معتمدة، يجب عليك رفض الطلب وتوضيح أن المكدس التقني المعتمد هو المصدر الوحيد للحقيقة.
3. **التحديث عبر المواصفات:** لا يمكن تعديل هذا الملف مباشرة. أي تغيير في المكدس التقني يجب أن يمر عبر عملية مواصفات رسمية (`Spec`) تتم مراجعتها والموافقة عليها.

## المكدس التقني المعتمد

| الطبقة (Layer)       | التقنية (Technology)          | الإصدار (Version)   | ملاحظات                          |
| :------------------- | :---------------------------- | :------------------ | :------------------------------- |
| **Framework**        | Flutter                       | `3.24.0+`           | إطار العمل الأساسي لبناء التطبيق |
| **Language**         | Dart                          | `3.5.0+`            | لغة البرمجة الأساسية             |
| **State Management** | Riverpod                      | `2.4.0+`            | إدارة الحالة الموصى بها          |
| **Local Database**   | Isar                          | `3.1.0+`            | قاعدة بيانات محلية عالية الأداء  |
| **Secure Storage**   | flutter_secure_storage        | `9.0.0+`            | تخزين آمن للبيانات الحساسة       |
| **PDF Generation**   | pdf + printing                | `3.10.4+ / 5.11.1+` | توليد وطباعة ملفات PDF           |
| **Icons**            | material_design_icons_flutter | `7.0.7296+`         | مكتبة الأيقونات                  |
| **Localization**     | intl                          | `0.19.0+`           | دعم اللغات المتعددة              |
| **Utilities**        | uuid, get_it, path_provider   | Latest              | أدوات مساعدة                     |

## أدوات التطوير (Dev Dependencies)

| الأداة                 | الإصدار  | الاستخدام                     |
| :--------------------- | :------- | :---------------------------- |
| **flutter_test**       | SDK      | إطار الاختبار الأساسي         |
| **mockito**            | `5.4.4+` | إنشاء Mock objects للاختبارات |
| **build_runner**       | `2.4.0+` | توليد الكود                   |
| **isar_generator**     | `3.1.0+` | توليد كود Isar                |
| **riverpod_generator** | `2.3.0+` | توليد كود Riverpod            |
| **flutter_lints**      | `4.0.0+` | قواعد Linting                 |

## معايير الجودة

### Code Quality

- **Linting:** استخدام `flutter_lints` مع قواعد صارمة
- **Type Safety:** تفعيل null safety في جميع الملفات
- **Documentation:** توثيق جميع الـ public APIs

### Testing

- **Unit Tests:** تغطية ≥ 70% للكود
- **Widget Tests:** اختبار جميع الـ widgets الأساسية
- **Integration Tests:** اختبار التدفقات الحرجة

### Performance

- **Build Time:** < 30 ثانية للـ debug build
- **App Size:** < 50 MB للـ release build
- **Startup Time:** < 2 ثانية

## الأنماط المعمارية المعتمدة

### Clean Architecture

```
lib/
├── core/           # المكونات المشتركة
├── features/       # الميزات (Feature-First)
└── data/          # طبقة البيانات
```

### Design Patterns

- **Repository Pattern:** للوصول إلى البيانات
- **Provider Pattern:** لإدارة الحالة
- **Factory Pattern:** لإنشاء الكائنات المعقدة
- **Singleton Pattern:** للخدمات المشتركة (GetIt)

## قواعد الأمان

### Data Security

- **Encryption:** تشفير جميع البيانات الحساسة
- **Secure Storage:** استخدام flutter_secure_storage للمفاتيح
- **Input Validation:** التحقق من جميع المدخلات
- **No Hardcoded Secrets:** عدم تخزين أي مفاتيح في الكود

### Code Security

- **Dependency Scanning:** فحص دوري للثغرات
- **Code Review:** مراجعة جميع التغييرات
- **Static Analysis:** استخدام flutter analyze

## CI/CD Requirements

### GitHub Actions

- **على كل Push:** تشغيل الاختبارات
- **على كل PR:** فحص الجودة والتغطية
- **على كل Tag:** بناء ونشر Release

### Quality Gates

- **Test Coverage:** ≥ 70%
- **Linting:** 0 errors, 0 warnings
- **Build:** نجاح البناء على جميع المنصات

---

**ملاحظة:** هذا المكدس التقني تم تصميمه خصيصاً لمشروع بصير MVP ويجب الالتزام به في جميع مراحل التطوير.
