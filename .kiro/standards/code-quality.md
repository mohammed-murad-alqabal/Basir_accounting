# معايير جودة الكود

**المشروع:** بصير MVP  
**الحالة:** ✅ نشط

---

## المعايير الأساسية

| المعيار         | القيمة | الإلزامية |
| :-------------- | :----: | :-------: |
| Test Coverage   |  70%+  |    ✅     |
| Max Line Length |   80   |    ✅     |
| Max Complexity  |   10   |    ✅     |
| DRY Principle   |   -    |    ✅     |

---

## SOLID Principles

### 1. Single Responsibility (SRP)

كل class مسؤولية واحدة فقط

### 2. Open/Closed (OCP)

مفتوح للتوسع، مغلق للتعديل

### 3. Liskov Substitution (LSP)

الأنواع الفرعية قابلة للاستبدال

### 4. Interface Segregation (ISP)

لا تجبر على interfaces غير مطلوبة

### 5. Dependency Inversion (DIP)

الاعتماد على abstractions

---

## Clean Code

### Meaningful Names

- أسماء واضحة تعبر عن الغرض
- تجنب الاختصارات المبهمة
- استخدام أسماء قابلة للنطق

### Small Functions

- دالة واحدة = مسؤولية واحدة
- الحد الأقصى: 20-30 سطر
- مستوى واحد من التجريد

### DRY (Don't Repeat Yourself)

- تجنب تكرار الكود
- استخدام functions للكود المتكرر
- استخدام constants للقيم المتكررة

---

## Error Handling

### استخدام Exceptions

- استخدام custom exceptions
- معالجة الأخطاء في المستوى المناسب
- عدم ابتلاع الأخطاء

### Async Operations

- استخدام try-catch
- معالجة جميع الحالات
- تسجيل الأخطاء

---

## Performance

### Const Constructors

- استخدام const حيثما أمكن
- تقليل rebuilds

### Lazy Loading

- تحميل البيانات عند الحاجة
- استخدام pagination

---

**للتفاصيل الكاملة:** `.kiro/steering/reference/quality-examples.md`
