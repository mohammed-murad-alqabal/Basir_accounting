# البنية المعمارية لتطبيق بصير

## مقدمة

تطبيق بصير يستخدم **Clean Architecture** لضمان فصل الاهتمامات وسهولة الصيانة والاختبار. تم تقسيم التطبيق إلى ثلاث طبقات رئيسية:

1. **طبقة العرض (Presentation Layer)**
2. **طبقة المجال (Domain Layer)**
3. **طبقة البيانات (Data Layer)**

## الطبقات الثلاث

### 1. طبقة العرض (Presentation Layer)

تحتوي على جميع واجهات المستخدم والشاشات. كل ميزة لها مجلد خاص بها يحتوي على:

- **Screens**: الشاشات الرئيسية
- **Widgets**: المكونات المعاد استخدامها
- **Providers**: مزودو Riverpod لإدارة الحالة

**الملفات الرئيسية:**
- `setup_screen.dart`: شاشة الإعداد الأولي
- `login_screen.dart`: شاشة تسجيل الدخول
- `dashboard_screen.dart`: لوحة التحكم
- `customers_screen.dart`: إدارة العملاء
- `invoices_screen.dart`: إدارة الفواتير
- `settings_screen.dart`: الإعدادات

### 2. طبقة المجال (Domain Layer)

تحتوي على منطق الأعمال والقواعد الأساسية. كل ميزة لها مجلد يحتوي على:

- **Entities**: كائنات المجال (مثل Customer و Invoice)
- **Repositories**: واجهات المستودعات (العقود)
- **Use Cases**: حالات الاستخدام (اختياري في MVP)

**الملفات الرئيسية:**
- `customer.dart`: كيان العميل
- `invoice.dart`: كيان الفاتورة
- `customer_repository.dart`: واجهة مستودع العملاء
- `invoice_repository.dart`: واجهة مستودع الفواتير

### 3. طبقة البيانات (Data Layer)

تحتوي على التطبيقات الفعلية للمستودعات والنماذج. كل ميزة لها مجلد يحتوي على:

- **Models**: نماذج البيانات (Isar Models)
- **Repositories**: تطبيقات المستودعات
- **Services**: الخدمات المساعدة

**الملفات الرئيسية:**
- `customer_model.dart`: نموذج العميل لـ Isar
- `invoice_model.dart`: نموذج الفاتورة لـ Isar
- `customer_repository_impl.dart`: تطبيق مستودع العملاء
- `invoice_repository_impl.dart`: تطبيق مستودع الفواتير

## تدفق البيانات

```
┌─────────────────────────────────────────────────────────────┐
│                    طبقة العرض (UI)                          │
│  (Screens, Widgets, Providers)                              │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                   طبقة المجال (Domain)                       │
│  (Entities, Repository Interfaces, Use Cases)               │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                   طبقة البيانات (Data)                       │
│  (Models, Repository Implementations, Services)             │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│              قاعدة البيانات المحلية (Isar)                   │
│              والتخزين الآمن (Secure Storage)                 │
└─────────────────────────────────────────────────────────────┘
```

## هيكل المشروع

```
lib/
├── core/
│   ├── constants.dart              # الثوابت والألوان والرسائل
│   ├── providers.dart              # مزودو Riverpod
│   └── router.dart                 # نظام التوجيه
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   └── services/
│   │   │       └── auth_service.dart
│   │   └── presentation/
│   │       └── screens/
│   │           ├── setup_screen.dart
│   │           └── login_screen.dart
│   ├── customers/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── customer_model.dart
│   │   │   └── repositories/
│   │   │       └── customer_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── customer.dart
│   │   │   └── repositories/
│   │   │       └── customer_repository.dart
│   │   └── presentation/
│   │       └── screens/
│   │           └── customers_screen.dart
│   ├── invoices/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── invoice_model.dart
│   │   │   └── repositories/
│   │   │       └── invoice_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── invoice.dart
│   │   │   └── repositories/
│   │   │       └── invoice_repository.dart
│   │   └── presentation/
│   │       └── screens/
│   │           └── invoices_screen.dart
│   ├── dashboard/
│   │   └── presentation/
│   │       └── screens/
│   │           └── dashboard_screen.dart
│   └── settings/
│       └── presentation/
│           └── screens/
│               └── settings_screen.dart
├── services/
│   └── settings_service.dart       # خدمة الإعدادات
└── main.dart                       # نقطة الدخول الرئيسية
```

## مثال على تدفق البيانات

### إضافة عميل جديد

1. **المستخدم يدخل البيانات في الشاشة (Presentation Layer)**
   - يملأ نموذج إضافة عميل جديد

2. **استدعاء المستودع (Domain Layer)**
   - `customerRepository.addCustomer(customer)`

3. **تطبيق المستودع (Data Layer)**
   - تحويل الـ Entity إلى Model
   - حفظ في قاعدة البيانات (Isar)

4. **إرجاع النتيجة**
   - عرض رسالة نجاح للمستخدم

## إدارة الحالة (State Management)

يستخدم التطبيق **Flutter Riverpod** لإدارة الحالة:

- **Providers**: توفير الخدمات والبيانات
- **StateNotifier**: إدارة الحالة المتغيرة
- **FutureProvider**: للعمليات غير المتزامنة

## التخزين المحلي

### Isar Database
- تخزين العملاء والفواتير
- أداء عالي جدًا
- دعم الاستعلامات المعقدة

### Flutter Secure Storage
- تخزين بيانات الاعتماد (اسم المستخدم، كلمة المرور)
- تخزين إعدادات الشركة
- تشفير آمن

## أفضل الممارسات

### 1. الفصل بين الطبقات
- لا تستورد من طبقة أعلى إلى طبقة أقل
- استخدم الواجهات (Interfaces) للتواصل بين الطبقات

### 2. معالجة الأخطاء
- استخدم `try-catch` في كل عملية
- وفر رسائل خطأ واضحة للمستخدم
- سجل الأخطاء للتصحيح

### 3. إعادة الاستخدام
- أنشئ Widgets قابلة لإعادة الاستخدام
- استخدم Providers لمشاركة الحالة
- تجنب تكرار الكود

### 4. الأداء
- استخدم `const` للـ Widgets الثابتة
- تجنب إعادة البناء غير الضرورية
- استخدم Lazy Loading عند الحاجة

## الاختبار

### اختبارات الوحدة
- اختبر كل دالة بشكل منفصل
- استخدم Mock Objects للتبعيات

### اختبارات التكامل
- اختبر تدفق البيانات الكامل
- تحقق من التفاعل بين الطبقات

### اختبارات الواجهة
- اختبر الشاشات والمكونات
- تحقق من سلوك المستخدم

## الخطوات التالية

### المرحلة الثانية
- إضافة Use Cases لكل ميزة
- تطبيق اختبارات شاملة
- تحسين الأداء
- إضافة ميزات متقدمة

### المرحلة الثالثة
- تطوير واجهة برمجية (API)
- المزامنة السحابية
- دعم المدفوعات الإلكترونية

---

**ملاحظة**: هذا الملف يشرح البنية الحالية ويمكن تحديثه مع تطور المشروع.
