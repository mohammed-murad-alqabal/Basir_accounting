# Runbook: Customers وVendors Snapshot Validation

## الغرض والنطاق

يوفر هذا الـrunbook مسارًا offline للتحقق من importer وparity لموجة Customers وVendors باستخدام SQLite في الذاكرة فقط. لا يفتح المسار قاعدة Isar التشغيلية، ولا يقرأ بيانات المستخدمين الحقيقية، ولا يسجل Providers أو `sync_service`.

> نجاح snapshot شرط قبول تشخيصي للموجة، وليس تفويضًا لتفعيل Drift أو تحويل مصدر القراءة والكتابة.

## عقد الخصوصية

يجب أن يحتوي الملف على `sanitized: true` و`schemaVersion: 1`. يجب أن تكون كل identifiers pseudonymous، ويُمنع إدراج أرقام هوية أو VAT حقيقية أو أرقام هواتف أو بريد أو عناوين أو payloads من Supabase. لا يُحفظ ملف snapshot داخل Git، ويجب حذفه بعد انتهاء التشغيل.

الحقول المالية (`creditLimit` و`balance`) أرقام JSON finite، والتواريخ ISO-8601، وحالة المزامنة واحدة من `synced` أو `pendingPush` أو `pendingPull` أو `conflict`. يقبل parser القيم الاختيارية `null` ولا يسمح بتحويل صامت أو قيمة غير صالحة.

## التشغيل

```bash
dart run tool/run_drift_customers_vendors_snapshot.dart /absolute/path/to/sanitized.json
```

يعمل CLI بقاعدة `NativeDatabase.memory()` ويغلق `BasirDatabase` في `finally`. مخرجات النجاح لا تتضمن identifiers أو payloads:

```json
{
  "clean": true,
  "migration": {
    "customers": {"sourceCount": 1, "migratedCount": 1, "complete": true},
    "vendors": {"sourceCount": 1, "migratedCount": 1, "complete": true}
  },
  "parity": {
    "customersMatch": true,
    "vendorsMatch": true,
    "duplicateCustomerKeyCount": 0,
    "duplicateVendorKeyCount": 0
  }
}
```

يعيد CLI رمز الاستخدام `64` عند غياب المسار أو زيادته، ورمزًا غير صفري عند فشل parser أو migration أو parity. عند الخطأ يطبع نوع الخطأ فقط ولا يطبع payload.

## بوابات القبول

لا تُعتبر اللقطة مقبولة إلا إذا كان `clean: true`، وكانت الشريحتان مكتملتين، وتساوى source count مع migrated count، وتطابقت fingerprints، وكان عدد duplicate scoped keys يساوي صفرًا. يجب كذلك أن ينجح التحليل الساكن واختبار snapshot واختبار التكامل المحلي.

أي duplicate للمفتاح `(scopeKey, uuid)` أو mismatch في الحقول المحاسبية أو روابط `receivableAccountId` و`payableAccountId` يمنع الانتقال إلى shadow-read. لا توجد معالجة تلقائية للتعارضات داخل parity.

## التحقق المنفذ محليًا

نجح parser وrunner واختبار snapshot بأربع حالات اختبار، والتحليل الساكن بلا ملاحظات، وتشغيل CLI end-to-end على fixture معقمة أعاد `clean: true` مع تطابق Customers وVendors وصفر duplicate keys. كما نجحت اختبارات الحزمة والتكامل السابقة على فرع العمل المعاد تأسيسه.

## الحدود والخطوة التالية

لا يغير هذا المسار Providers، ولا يكتب Drift في الإنتاج، ولا يفعّل shadow-read. بعد توفير لقطة بيانات فعلية معقمة ومراجعتها يدويًا، يُعاد التشغيل offline وتُحفظ النتيجة فقط كـsummary. بعد ذلك يمكن تصميم shadow-read مستقل خلف flag مغلق، مع rollback واضح ومراجعة بشرية منفصلة.
