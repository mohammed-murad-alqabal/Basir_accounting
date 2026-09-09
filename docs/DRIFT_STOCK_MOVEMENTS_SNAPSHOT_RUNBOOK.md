# StockMovements Snapshot Runbook

## الغرض

يشغل هذا المسار golden fixtures معقمة داخل SQLite in-memory للتحقق من importer وparity وحساب الرصيد المشتق. المسار تشخيصي فقط؛ لا يفتح قاعدة Isar التشغيلية، ولا يكتب Isar، ولا يبدل أي Provider، ولا يفعّل `sync_service` أو shadow-read أو canary.

## المتطلبات

يجب تشغيل الأوامر من جذر المستودع وبنسخة Flutter/Dart المقفلة للمشروع. الملف الافتراضي هو `test/fixtures/stock_movements_golden_fixtures.json`، ويجب أن يعلن `sanitized: true` و`fixtureVersion: 1`.

## التشغيل

```bash
dart run tool/run_drift_stock_movements_snapshot.dart
```

ويمكن تمرير ملف بديل معقم:

```bash
dart run tool/run_drift_stock_movements_snapshot.dart path/to/sanitized-fixtures.json
```

يشغل CLI كل clean fixtures بقاعدة `NativeDatabase.memory()` منفصلة لكل fixture وبحجم batch صغير لاختبار checkpoints. تُغلق القاعدة في `finally` بعد كل تشغيل، ولا يحتفظ التقرير بصفوف الحركة.

## شكل المخرجات الآمنة

يصدر CLI JSON واحدًا يحتوي `clean`، وعدد fixtures، وتقريرًا لكل fixture يقتصر على `fixtureId`، counts، حالة checkpoint، أعداد raw/reference/derived scopes، وعدد duplicate keys، و`blockedReasons`. لا يصدر `userId` أو `itemId` أو `referenceId` أو الوصف أو payload الحركة أو expected quantities التفصيلية.

مثال مختصر:

```json
{
  "clean": true,
  "fixtureCount": 6,
  "blockedFixtureCount": 4,
  "reports": [
    {
      "fixtureId": "basic_lifecycle",
      "clean": true,
      "sourceCount": 3,
      "migratedCount": 3,
      "blockedCount": 0,
      "duplicateScopedKeys": 0,
      "blockedReasons": []
    }
  ]
}
```

## تفسير النتائج

| النتيجة | الإجراء |
|---|---|
| `clean: true` وكل reports نظيفة | يسمح بمتابعة مراجعة الكود فقط، ولا يمنح موافقة على بيانات الإنتاج أو rollout |
| checkpoint غير مكتمل | أوقف المسار وراجع batch write قبل أي retry على بيانات فعلية |
| `blockedCount > 0` | أوقف parity؛ راجع `transfer` أو `adjustment` أو صحة المصدر |
| duplicate scoped keys | أوقف الاستيراد ولا تُصلح أو تحذف تلقائيًا |
| raw/reference mismatch | أوقف المسار وراجع canonicalization وscope والحقول المفقودة |
| derived mismatch | أوقف المسار وراجع sign وas-of boundary وdual-entry transfer |

## الحالات المحجوبة

لا تدخل الحالات الأربع المحجوبة في تشغيل clean: standalone transfer، negative adjustment، non-UTC date، وunknown enum. وجودها في metadata يثبت أن الكتالوج يعرفها، لكنه لا يحولها إلى acceptance. يجب اعتماد contract مكتوب قبل إدخال أي منها إلى clean fixtures.

## بوابات ما قبل البيانات الفعلية

يلزم نجاح parser وgolden replay وSQLite storage parity وimporter checkpoint parity، ثم مراجعة بشرية لعقد `asOfDate` وpositive/negative adjustment وdual-entry transfer. بعد ذلك فقط يمكن تصميم تشغيل snapshot على نسخة معقمة من Isar، مع منع تسجيل payload أو الأسرار، وبدون تفعيل الكتابة أو shadow-read.

## التحقق الحالي

تم التحقق من snapshot runner وCLI عبر **57 اختبارًا ناجحًا**، و`flutter analyze` بلا ملاحظات، و`git diff --check` سليم. هذه الحالة محلية على فرع contract-fix، ولم يُنفذ commit أو push لمخرجات snapshot حتى اعتماد مستقل.
