# خطة إصلاح الاختبارات الفاشلة

**المشروع:** بصير MVP  
**التاريخ:** 4 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** 🔴 حرجة - قيد التنفيذ

---

## 📊 الملخص التنفيذي

**الاختبارات الفاشلة:** 8 من 518 (98.5% نجاح)  
**الأولوية:** 🔴 حرجة جداً  
**الوقت المقدر:** 2-3 ساعات  
**التأثير:** يمنع اعتماد CI/CD ويؤثر على accessibility

---

## 🔴 المشاكل الحرجة (الأولوية القصوى)

### 1. Color Contrast - Primary Background (CRITICAL)

**الملف:** `test/unit/core/theme/app_colors_contrast_test.dart`  
**الاختبار:** `تباين النصوص العادية لأي نص عادي معروض على الخلفية الرئيسية`  
**المشكلة:** نسبة التباين 4.29 < 4.5 (WCAG AA)  
**الأولوية:** 🔴 حرجة جداً (accessibility)

**التحليل:**

```dart
// الخلفية الرئيسية
const backgroundColor = AppColors.background;

// النصوص المختبرة
textPrimary: #1A1A1A
textSecondary: #4A4A4A
textHint: #757575

// المشكلة: التباين 4.29 أقل من 4.5
```

**الحل:**

- تعديل لون الخلفية أو النصوص لتحقيق 4.5:1
- الخيار 1: تغميق النصوص قليلاً
- الخيار 2: تفتيح الخلفية قليلاً
- **الموصى به:** تغميق textPrimary من #1A1A1A إلى #000000

**الملفات المتأثرة:**

- `lib/core/theme/app_colors.dart`

---

### 2. Color Contrast - Status Colors (CRITICAL)

**الملف:** `test/unit/core/theme/app_colors_contrast_test.dart`  
**الاختبار:** `لأي نص حالة (نجاح، خطأ، تحذير، معلومة) معروض على خلفية بيضاء`  
**المشكلة:** نسبة التباين 3.79 < 4.5 (WCAG AA)  
**الأولوية:** 🔴 حرجة جداً (accessibility)

**التحليل:**

```dart
// الخلفية البيضاء
const backgroundColor = AppColors.surface; // #FFFFFF

// ألوان الحالة المختبرة
error: #D32F2F
success: #388E3C
warning: #F57C00
info: #1976D2

// المشكلة: أحد الألوان (على الأرجح warning أو info) تباينه 3.79
```

**الحل:**

- تغميق ألوان الحالة لتحقيق 4.5:1
- **الموصى به:**
  - warning: من #F57C00 إلى #E65100
  - info: من #1976D2 إلى #0D47A1

**الملفات المتأثرة:**

- `lib/core/theme/app_colors.dart`

---

## 🟡 المشاكل المتوسطة

### 3. InvoicesScreen - Filter Test

**الملف:** `test/widget/features/invoices/invoices_screen_test.dart`  
**الاختبار:** `should show all invoices when "الكل" filter is selected`  
**المشكلة:** `The finder "Found 0 widgets with text "paid": []"`  
**الأولوية:** 🟡 متوسطة

**التحليل:**

```dart
// الاختبار يبحث عن نص "paid" بالإنجليزية
await tester.tap(find.text('paid'));

// لكن الواجهة تستخدم النص العربي "مدفوعة"
```

**الحل:**

- تحديث الاختبار ليبحث عن النص العربي الصحيح
- استبدال `find.text('paid')` بـ `find.text('مدفوعة')`

**الملفات المتأثرة:**

- `test/widget/features/invoices/invoices_screen_test.dart`

---

### 4-7. InvoicesScreen - Bottom Sheet Tests (3 اختبارات)

**الملف:** `test/widget/features/invoices/invoices_screen_test.dart`  
**الاختبارات:**

- `should close bottom sheet when edit option is tapped`
- `should close bottom sheet when delete option is tapped`
- `should maintain scroll position after filter change`

**المشكلة:** فشل في التحقق من إغلاق bottom sheet أو الحفاظ على موضع التمرير  
**الأولوية:** 🟡 متوسطة

**التحليل:**

```dart
// المشكلة: الاختبار يتوقع إغلاق bottom sheet فوراً
await tester.tap(find.text('تعديل الفاتورة'));
await tester.pumpAndSettle();

// لكن قد يكون هناك navigation أو animation
expect(find.text('تصدير PDF'), findsNothing);
```

**الحل:**

- إضافة `await tester.pumpAndSettle()` إضافي
- التحقق من الحالة الصحيحة بعد الإغلاق
- استخدام `findsNothing` بدلاً من `findsOneWidget`

**الملفات المتأثرة:**

- `test/widget/features/invoices/invoices_screen_test.dart`

---

### 8-9. AppTextButton - Styling Tests

**الملف:** `test/widget/core/widgets/app_button_test.dart`  
**الاختبارات:**

- `should use default font size`
- `should have medium font weight`

**المشكلة:** فشل في التحقق من حجم الخط أو وزنه  
**الأولوية:** 🟡 متوسطة

**التحليل:**

```dart
// الاختبار يتوقع
expect(text.style?.fontSize, AppAppTypography.bodyMedium);
expect(text.style?.fontWeight, FontWeight.w500);

// لكن القيمة الفعلية قد تكون مختلفة
```

**الحل:**

- التحقق من القيم الفعلية في AppTextButton
- تحديث الاختبار ليطابق القيم الصحيحة
- أو تحديث AppTextButton ليطابق التوقعات

**الملفات المتأثرة:**

- `test/widget/core/widgets/app_button_test.dart`
- `lib/core/widgets/app_button.dart` (إن لزم)

---

## 📋 خطة التنفيذ

### المرحلة 1: إصلاح Color Contrast (30 دقيقة)

1. **قراءة ملف app_colors.dart**
2. **تحليل الألوان الحالية**
3. **حساب نسب التباين**
4. **تعديل الألوان:**
   - textPrimary: #1A1A1A → #000000
   - warning: #F57C00 → #E65100
   - info: #1976D2 → #0D47A1
5. **تشغيل الاختبارات**
6. **التحقق من النجاح**

### المرحلة 2: إصلاح InvoicesScreen Tests (45 دقيقة)

1. **قراءة ملف invoices_screen_test.dart**
2. **تحديد المشاكل بدقة**
3. **إصلاح Filter Test:**
   - استبدال `'paid'` بـ `'مدفوعة'`
4. **إصلاح Bottom Sheet Tests:**
   - إضافة `pumpAndSettle` إضافي
   - تحديث assertions
5. **إصلاح Scroll Position Test:**
   - مراجعة منطق الاختبار
6. **تشغيل الاختبارات**
7. **التحقق من النجاح**

### المرحلة 3: إصلاح AppTextButton Tests (30 دقيقة)

1. **قراءة ملف app_button.dart**
2. **التحقق من القيم الفعلية**
3. **تحديث الاختبارات:**
   - تصحيح fontSize المتوقع
   - تصحيح fontWeight المتوقع
4. **تشغيل الاختبارات**
5. **التحقق من النجاح**

### المرحلة 4: التحقق النهائي (15 دقيقة)

1. **تشغيل جميع الاختبارات**
2. **التحقق من 100% نجاح**
3. **تشغيل flutter analyze**
4. **تحديث التوثيق**
5. **Commit التغييرات**

---

## ✅ معايير النجاح

- [ ] جميع الـ 8 اختبارات تنجح
- [ ] معدل نجاح 100% (518/518)
- [ ] نسب التباين ≥ 4.5:1 لجميع الألوان
- [ ] flutter analyze: 0 errors, 0 warnings
- [ ] لا توجد regressions في اختبارات أخرى

---

## 📊 التقدم

| المرحلة   | الحالة       | الوقت المقدر | الوقت الفعلي |
| :-------- | :----------- | :----------- | :----------- |
| المرحلة 1 | ⏳ قيد البدء | 30 دقيقة     | -            |
| المرحلة 2 | ⏳ منتظر     | 45 دقيقة     | -            |
| المرحلة 3 | ⏳ منتظر     | 30 دقيقة     | -            |
| المرحلة 4 | ⏳ منتظر     | 15 دقيقة     | -            |

**الإجمالي:** 2 ساعة

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 4 ديسمبر 2025  
**الحالة:** 🔴 حرجة - جاهز للتنفيذ
