# معايير الاختبارات

**المشروع:** بصير MVP  
**الحالة:** ✅ نشط

---

## الأنواع

### Unit Tests

- **الهدف:** اختبار الدوال والـ Classes المعزولة
- **التغطية:** 70%+
- **السرعة:** سريعة جداً

### Widget Tests

- **الهدف:** اختبار الـ Widgets
- **التغطية:** المسارات الحرجة
- **السرعة:** سريعة

### Integration Tests

- **الهدف:** اختبار التدفقات الكاملة
- **التغطية:** رحلات المستخدم
- **السرعة:** متوسطة

---

## القواعد الأساسية

### الإلزامي

- ✅ اختبار كل public function
- ✅ اختبار الحالات الطبيعية والاستثنائية
- ✅ استخدام mocks للـ dependencies
- ✅ اختبارات مستقلة

### الممنوع

- ❌ اختبارات تعتمد على بعضها
- ❌ اختبارات بطيئة (> 30 ثانية للكل)
- ❌ استخدام بيانات حقيقية
- ❌ mocks لجعل الاختبارات تنجح

---

## البنية

### تنظيم الاختبارات

```
test/
├── unit/          # اختبارات الوحدة
├── widget/        # اختبارات الـ Widgets
└── integration/   # اختبارات التكامل
```

### تسمية الملفات

```
customer_repository.dart → customer_repository.test.dart
```

---

## أفضل الممارسات

### Setup و Teardown

```dart
setUp(() async {
  // إعداد قبل كل اختبار
});

tearDown(() async {
  // تنظيف بعد كل اختبار
});
```

### أسماء واضحة

```dart
test('should add customer successfully', () {
  // ...
});
```

### استخدام Matchers

```dart
expect(result, isNotNull);
expect(customers.length, equals(1));
expect(() => validate(''), throwsException);
```

---

## التشغيل

### الأوامر

```bash
flutter test                    # جميع الاختبارات
flutter test --coverage         # مع التغطية
flutter test test/unit/         # اختبارات محددة
```

---

**للأمثلة:** `.kiro/steering/reference/testing-examples.md`
