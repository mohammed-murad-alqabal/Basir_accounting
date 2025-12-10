# اختبارات نظام الأرشفة

**المشروع:** بصير MVP  
**التاريخ:** 4 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير

---

## نظرة عامة

هذا المجلد يحتوي على اختبارات الخصائص (Property-Based Tests) لنظام أرشفة السجلات.

## الاختبارات المتوفرة

### 1. اختبار الأرشفة حسب العمر

**الملف:** `property_test_archive_age.sh`  
**الخاصية:** Property 12 - Archive Age-based Migration  
**المتطلب:** Requirements 5.1

يتحقق من أن جميع السجلات الأقدم من 7 أيام يتم نقلها تلقائياً إلى مجلد الأرشيف.

```bash
bash test/archive/property_test_archive_age.sh
```

### 2. اختبار الضغط حسب الحجم

**الملف:** `property_test_compression_size.sh`  
**الخاصية:** Property 13 - Archive Size-based Compression  
**المتطلب:** Requirements 5.2

يتحقق من أن الأرشيف يتم ضغطه تلقائياً عندما يتجاوز حجمه 10MB.

```bash
bash test/archive/property_test_compression_size.sh
```

### 3. اختبار الحفاظ على السجلات الحديثة

**الملف:** `property_test_recent_logs.sh`  
**الخاصية:** Property 14 - Recent Logs Preservation  
**المتطلب:** Requirements 5.3

يتحقق من أن السجلات الأحدث من 7 أيام تبقى في مكانها الأصلي ولا يتم أرشفتها.

```bash
bash test/archive/property_test_recent_logs.sh
```

### 4. اختبار النسخ الاحتياطي

**الملف:** `property_test_backup.sh`  
**الخاصية:** Property 15 - Archived Logs Backup  
**المتطلب:** Requirements 5.4

يتحقق من أن جميع السجلات القديمة التي يتم حذفها من المجلد الأصلي يتم الاحتفاظ بنسخة منها في الأرشيف (مضغوطة أو غير مضغوطة).

```bash
bash test/archive/property_test_backup.sh
```

### 5. اختبار كفاءة الضغط

**الملف:** `property_test_compression_efficiency.sh`  
**الخاصية:** Property 23 - Compression Efficiency  
**المتطلب:** Requirements 10.4

يتحقق من أن عملية الضغط تقلل حجم الملفات بنسبة 70% على الأقل.

```bash
bash test/archive/property_test_compression_efficiency.sh
```

## تشغيل جميع الاختبارات

لتشغيل جميع اختبارات الأرشفة:

```bash
for test in test/archive/property_test_*.sh; do
    echo "Running $test..."
    bash "$test"
    echo ""
done
```

## معايير النجاح

- ✅ جميع الاختبارات يجب أن تنجح 100%
- ✅ كل اختبار يشغل 100 تكرار (أو 10-20 للاختبارات الثقيلة)
- ✅ جميع الخصائص يجب أن تتحقق في جميع الحالات

## ملاحظات

- الاختبارات تستخدم مجلدات مؤقتة وتنظف بعد نفسها
- الاختبارات مستقلة ويمكن تشغيلها بأي ترتيب
- الاختبارات تستخدم أعمار وأحجام عشوائية لضمان التغطية الشاملة

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**آخر تحديث:** 4 ديسمبر 2025
