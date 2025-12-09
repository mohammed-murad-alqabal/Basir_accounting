# معايير Flutter

**المشروع:** بصير MVP  
**الحالة:** ✅ نشط

---

## البنية المعمارية

### Clean Architecture

- **Presentation Layer**: Screens, Widgets, Providers
- **Domain Layer**: Business Logic, Use Cases
- **Data Layer**: Models, Repositories, Services

### Feature-First Organization

```
lib/
├── core/          # مشترك
├── features/      # حسب الميزة
└── data/          # البيانات
```

---

## إدارة الحالة

### Riverpod (الموصى به)

- `Provider`: قيم ثابتة
- `StateProvider`: حالات بسيطة
- `FutureProvider`: async operations
- `StateNotifierProvider`: حالات معقدة

---

## قاعدة البيانات

### Isar (المعتمد)

- استخدام Isar في الذاكرة للاختبارات
- إغلاق الاتصالات بشكل صحيح
- استخدام Transactions للعمليات المتعددة
- إنشاء Indexes للبحث

---

## الأمان

### التخزين الآمن

- استخدام `flutter_secure_storage`
- عدم تخزين كلمات المرور بشكل نصي
- استخدام Hashing (SHA-256+)

---

## الاختبارات

### الأنواع

- **Unit Tests**: للدوال والـ Classes
- **Widget Tests**: للـ Widgets
- **Integration Tests**: للتدفقات الكاملة

### القواعد

- تغطية 70%+
- استخدام Mocks
- اختبارات سريعة (< 30 ثانية)

---

## الأداء

### التحسينات

- استخدام `const` constructors
- تجنب rebuilds غير ضرورية
- استخدام `ListView.builder`
- Lazy loading للصور

---

## دعم RTL

### القواعد

- استخدام `Directionality`
- اختبار في كلا الاتجاهين
- استخدام خطوط عربية مناسبة
- `TextAlign.start` بدلاً من `left`

---

**للدليل الكامل:** `.kiro/steering/guides/flutter-guide.md`
