---
title: البنية الهيكلية والمعمارية
inclusion: always
---

# البنية الهيكلية والمعمارية لمشروع بصير

## المبدأ الأساسي: الفصل الواضح للمسؤوليات (Clear Separation of Concerns)

يجب أن يتم تنظيم المشروع بطريقة تعكس الفصل الواضح للمسؤوليات المعمارية، مما يضمن قابلية الصيانة والتوسع.

## 1. البنية الجذرية للمشروع

```
Basser_MVP/
├── lib/                    # كود التطبيق الرئيسي
├── test/                   # الاختبارات
├── assets/                 # الموارد (صور، خطوط، إلخ)
├── Documentation/          # التوثيق الشامل
├── .kiro/                 # إعدادات Kiro Strategic Workspace
├── android/               # كود Android الأصلي
├── ios/                   # كود iOS الأصلي
├── linux/                 # كود Linux الأصلي
├── macos/                 # كود macOS الأصلي
├── windows/               # كود Windows الأصلي
├── web/                   # كود Web
└── pubspec.yaml           # ملف التبعيات

```

## 2. بنية مجلد lib/ (Feature-First Architecture)

```
lib/
├── main.dart              # نقطة الدخول الرئيسية
├── core/                  # المكونات الأساسية المشتركة
│   ├── theme/            # نظام التصميم والثيمات
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   └── app_text_styles.dart
│   ├── widgets/          # Widgets قابلة لإعادة الاستخدام
│   │   ├── app_button.dart
│   │   ├── app_card.dart
│   │   ├── app_text_field.dart
│   │   └── app_app_bar.dart
│   ├── utils/            # دوال مساعدة
│   │   ├── validators.dart
│   │   └── formatters.dart
│   ├── router/           # التوجيه والملاحة
│   │   └── app_router.dart
│   └── constants.dart    # الثوابت العامة
│
├── features/             # الميزات الرئيسية (Feature-First)
│   ├── auth/            # ميزة المصادقة
│   │   ├── domain/
│   │   │   └── entities/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   └── services/
│   │   └── presentation/
│   │       ├── screens/
│   │       ├── widgets/
│   │       └── providers/
│   │
│   ├── customers/       # ميزة إدارة العملاء
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│   │
│   ├── invoices/        # ميزة إدارة الفواتير
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│   │
│   ├── dashboard/       # ميزة لوحة التحكم
│   │   └── presentation/
│   │
│   └── settings/        # ميزة الإعدادات
│       └── presentation/
│
└── data/                # طبقة البيانات المشتركة
    ├── models/          # نماذج البيانات (Isar Models)
    │   ├── customer_model.dart
    │   └── invoice_model.dart
    ├── repositories/    # Repositories
    │   ├── customer_repository.dart
    │   └── invoice_repository.dart
    └── services/        # الخدمات
        ├── auth_service.dart
        ├── settings_service.dart
        └── pdf_service.dart
```

## 3. بنية مجلد test/ (تطابق بنية lib/)

```
test/
├── helpers/             # دوال مساعدة للاختبارات
│   ├── test_helpers.dart
│   ├── mock_data.dart
│   └── test_utils.dart
├── mocks/              # Mock objects
│   ├── mock_secure_storage.dart
│   ├── mock_customer_repository.dart
│   └── mock_invoice_repository.dart
├── fixtures/           # بيانات ثابتة للاختبار
│   ├── customer_fixtures.dart
│   └── invoice_fixtures.dart
├── unit/               # اختبارات الوحدة
│   ├── data/
│   │   ├── models/
│   │   ├── repositories/
│   │   └── services/
│   └── core/
│       └── utils/
└── widget/             # اختبارات الـ Widgets
    ├── core/
    │   └── widgets/
    └── features/
        ├── auth/
        ├── customers/
        ├── invoices/
        └── dashboard/
```

## 4. بنية مجلد .kiro/ (Kiro Strategic Workspace)

```
.kiro/
├── specs/              # المواصفات (Spec-Driven Development)
│   ├── testing-system/
│   │   ├── requirements.md
│   │   ├── design.md
│   │   └── tasks.md
│   └── critical-fixes/
│       ├── requirements.md
│       ├── design.md
│       └── tasks.md
├── steering/           # الحوكمة المعمارية
│   ├── philosophy.md
│   ├── security.md
│   ├── testing-best-practices.md
│   ├── flutter-best-practices.md
│   ├── tech-stack.md
│   ├── structure.md
│   └── ...
├── prompts/            # توجيهات الوكيل
│   ├── system_spec_writer.prompt.md
│   ├── system_code_generator.prompt.md
│   └── ...
├── hooks/              # الأتمتة الوقائية
│   ├── on-commit/
│   ├── on-save/
│   └── pre-push/
└── settings/           # الإعدادات
    └── mcp.json
```

## 5. المبادئ المعمارية

### أ. Clean Architecture (الطبقات الثلاث)

#### 1. Presentation Layer (طبقة العرض)

- **المسؤولية:** عرض البيانات والتفاعل مع المستخدم
- **المكونات:** Screens, Widgets, Providers
- **القاعدة:** لا تحتوي على منطق أعمال

#### 2. Domain Layer (طبقة المجال)

- **المسؤولية:** منطق الأعمال والقواعد
- **المكونات:** Entities, Use Cases
- **القاعدة:** مستقلة عن الإطار والمكتبات

#### 3. Data Layer (طبقة البيانات)

- **المسؤولية:** الوصول إلى البيانات
- **المكونات:** Models, Repositories, Services
- **القاعدة:** تطبيق Repository Pattern

### ب. Feature-First Organization

**المبدأ:** تنظيم الكود حسب الميزات وليس حسب النوع

**الفوائد:**

- سهولة العثور على الكود المتعلق بميزة معينة
- تقليل الاعتماديات بين الميزات
- تسهيل العمل الجماعي

**القاعدة:** كل ميزة يجب أن تكون مستقلة قدر الإمكان

### ج. Dependency Injection

**المبدأ:** استخدام GetIt للـ Service Locator

**القاعدة:**

- تسجيل جميع الخدمات في `main.dart`
- استخدام Riverpod للـ Providers
- عدم إنشاء instances مباشرة في الكود

## 6. اتفاقيات التسمية

| العنصر        | الاتفاقية      | مثال                       |
| :------------ | :------------- | :------------------------- |
| **الملفات**   | snake_case     | `customer_repository.dart` |
| **المجلدات**  | snake_case     | `customer_repository/`     |
| **Classes**   | PascalCase     | `CustomerRepository`       |
| **Functions** | camelCase      | `getAllCustomers()`        |
| **Variables** | camelCase      | `customerList`             |
| **Constants** | lowerCamelCase | `maxRetries`               |
| **Private**   | \_prefix       | `_privateMethod()`         |

## 7. قواعد الاستيراد (Import Rules)

### ترتيب الاستيراد:

1. Dart SDK imports
2. Flutter imports
3. Package imports
4. Relative imports

### مثال:

```dart
// Dart SDK
import 'dart:async';

// Flutter
import 'package:flutter/material.dart';

// Packages
import 'package:riverpod/riverpod.dart';
import 'package:isar/isar.dart';

// Relative
import '../models/customer.dart';
import '../../core/widgets/app_button.dart';
```

## 8. متطلبات الهيكلة الإلزامية

### للوكيل (Agent):

1. **الالتزام بالبنية:** يجب إنشاء جميع الملفات في المواقع الصحيحة
2. **Feature Isolation:** كل ميزة يجب أن تكون مستقلة
3. **No Circular Dependencies:** منع الاعتماديات الدائرية
4. **Test Mirroring:** بنية test/ يجب أن تطابق lib/

### للمطور (Developer):

1. **لا تخلط الطبقات:** لا تضع منطق أعمال في Presentation
2. **استخدم Providers:** لا تنشئ instances مباشرة
3. **اتبع التسمية:** التزم باتفاقيات التسمية
4. **وثق الكود:** أضف تعليقات للكود المعقد

## 9. أنماط التصميم المعتمدة

| النمط          | الاستخدام           | المثال                |
| :------------- | :------------------ | :-------------------- |
| **Repository** | الوصول إلى البيانات | `CustomerRepository`  |
| **Provider**   | إدارة الحالة        | `customersProvider`   |
| **Factory**    | إنشاء كائنات معقدة  | `Customer.fromJson()` |
| **Singleton**  | خدمات مشتركة        | `GetIt.instance`      |
| **Observer**   | مراقبة التغييرات    | Riverpod Providers    |

## 10. قواعد الأمان الهيكلية

1. **فصل الأسرار:** لا تخزن أسرار في الكود
2. **Secure Storage:** استخدم flutter_secure_storage
3. **Input Validation:** في طبقة Data
4. **Error Handling:** في جميع الطبقات

---

**ملاحظة:** هذه البنية تم تصميمها لتحقيق أقصى قدر من القابلية للصيانة والتوسع والاختبار.
