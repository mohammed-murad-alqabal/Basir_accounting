**المشروع:** بصير MVP
**المؤلف:** فريق وكلاء تطوير مشروع بصير
**المصدر:** مكيف من مصادر مجتمع Kiro المعتمدة
**التاريخ:** 10 ديسمبر 2025

---

# معايير Flutter/Dart للمشروع

## معايير Dart

### التنسيق والأسلوب

- استخدم `dart format` للتنسيق التلقائي
- اتبع `effective_dart` guidelines
- استخدم `const` constructors حيثما أمكن
- استخدم `final` للمتغيرات غير القابلة للتغيير

### التسمية

- Classes: PascalCase (`CustomerRepository`)
- Functions/Variables: camelCase (`getAllCustomers`)
- Constants: lowerCamelCase (`maxRetries`)
- Private members: underscore prefix (`_privateMethod`)

## معايير Flutter

### البنية والتنظيم

- اتبع Clean Architecture (3 layers)
- استخدم feature-first organization
- فصل UI عن Business Logic

### إدارة الحالة

- استخدم Riverpod كمزود رئيسي للحالة
- تجنب setState في الويدجت المعقدة
- استخدم StateNotifier للحالات المعقدة

### الأداء

- استخدم `const` widgets حيثما أمكن
- تجنب إعادة البناء غير الضرورية
- استخدم `ListView.builder` للقوائم الطويلة

### قاعدة البيانات المحلية

- استخدم Isar للقاعدة المحلية
- طبق indexing للاستعلامات السريعة
- استخدم transactions للعمليات المعقدة

## الاختبارات

### Unit Tests

- اختبر كل public function
- استخدم mocks للـ dependencies
- حقق 70%+ test coverage

### Widget Tests

- اختبر المسارات الحرجة
- تحقق من UI interactions
- اختبر حالات الخطأ

### Integration Tests

- اختبر user journeys كاملة
- تحقق من تدفق البيانات
- اختبر الأداء

## الأمان

### حماية البيانات

- استخدم `flutter_secure_storage` للبيانات الحساسة
- شفّر البيانات المحلية المهمة
- تحقق من صحة جميع المدخلات

### الشبكة

- استخدم HTTPS دائماً
- طبق certificate pinning
- تحقق من صحة الاستجابات

## التوثيق

### DartDoc

- وثّق جميع public APIs
- أضف أمثلة في التوثيق
- اشرح المعاملات والقيم المرجعة

### README

- اشرح كيفية تشغيل المشروع
- أضف متطلبات النظام
- وثّق عملية البناء والنشر
