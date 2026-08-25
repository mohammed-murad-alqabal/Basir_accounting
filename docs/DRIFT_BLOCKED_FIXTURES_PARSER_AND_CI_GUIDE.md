# دليل اختبارات الحالات المحجوبة وCI/CD

## النطاق

يوثق هذا الدليل كيفية اختبار `non_utc_date` و`standalone_transfer_type`، وكيف يتعامل مسار snapshot الحالي مع الحالات المحجوبة، وكيفية إضافة payloads صناعية مستقلة للحالات الأربع دون خلطها مع `cleanFixtures`.

> الحالات المحجوبة ليست failures. هي حالات رفض متعمد يحمي عقد التخزين من إسقاط أو تطبيع بيانات غير معتمدة.

## 1. اختبار `non_utc_date`

الاختبار الحالي يقرأ catalog المعقم، يفك JSON إلى بنية قابلة للتعديل، يغير تاريخ حركة واحدة إلى تاريخ ذي offset محلي، ثم يعيد تمرير catalog إلى parser. قيمة مثل `2026-01-01T00:00:00.000+03:00` لا تنتهي بحرف `Z`، ولذلك يجب أن يرفضها `_requiredUtcDate`.

```dart
test('rejects non-UTC movement dates', () {
  final source = File(
    'test/fixtures/stock_movements_golden_fixtures.json',
  ).readAsStringSync();
  final json = jsonDecode(source) as Map<String, dynamic>;
  final cleanFixtures = json['cleanFixtures'] as List<dynamic>;
  final firstFixture = cleanFixtures.first as Map<String, dynamic>;
  final movements = firstFixture['movements'] as List<dynamic>;
  final firstMovement = movements.first as Map<String, dynamic>;

  firstMovement['date'] = '2026-01-01T00:00:00.000+03:00';

  expect(
    () => StockMovementGoldenCatalog.fromJson(
      json.map<String, Object?>((key, value) => MapEntry(key, value)),
    ),
    throwsA(
      isA<FormatException>().having(
        (error) => error.message,
        'message',
        contains('canonical UTC'),
      ),
    ),
  );
});
```

سبب الفشل دلالي وليس شكليًا فقط. `asOfDate` في العقد inclusive ويُقارن مع `date` UTC، لذلك قبول offset ثم التطبيع الصامت قد يغيّر السجل الذي يدخل في الرصيد عند حدود اليوم أو عند تساوي التوقيتات بين المنصات.

## 2. اختبار `standalone_transfer_type`

الاختبار الحالي يغير نوع حركة نظيفة إلى `transfer` ثم يعيد تمريرها إلى parser. يمر parsing الأولي للـenum، لكن `_validateCleanContract` يرفض النوع عند فحص clean fixture لأن التحويل المنفرد لا يحدد هل الحركة خروج من المصدر أم دخول إلى الوجهة.

```dart
test('rejects standalone transfer inside a clean fixture', () {
  final json = jsonDecode(
    File('test/fixtures/stock_movements_golden_fixtures.json')
        .readAsStringSync(),
  ) as Map<String, dynamic>;
  final cleanFixtures = json['cleanFixtures'] as List<dynamic>;
  final firstFixture = cleanFixtures.first as Map<String, dynamic>;
  final movements = firstFixture['movements'] as List<dynamic>;
  final firstMovement = movements.first as Map<String, dynamic>;

  firstMovement['type'] = 'transfer';

  expect(
    () => StockMovementGoldenCatalog.fromJson(
      json.map<String, Object?>((key, value) => MapEntry(key, value)),
    ),
    throwsA(
      isA<FormatException>().having(
        (error) => error.message,
        'message',
        contains('blocked standalone transfer type'),
      ),
    ),
  );
});
```

إذا وصل transfer المنفرد إلى replay بدل parser، فإن الحماية الثانية هي `StockMovementGoldenBlockedException` برسالة تفيد بأن التحويل يحتاج dual-entry semantics. هذا يمنع replay من معاملته كـoutbound أو inbound تلقائيًا.

## 3. الفرق بين الحظر والـfailure في CI/CD الحالي

يمر `run_drift_stock_movements_snapshot.dart` بالمراحل التالية:

| المرحلة | السلوك | هل تفشل البوابة؟ |
|---|---|---|
| قراءة الملف | قراءة JSON من المسار المحلي | نعم إذا تعذر الملف |
| Preflight | فحص `sanitized` وschema والـsecret patterns والاتصالات الحساسة | نعم؛ يخرج CLI بـexit code 1 |
| Parsing | بناء `StockMovementGoldenCatalog` | نعم عند JSON أو enum أو UTC غير صالح |
| Clean replay | تشغيل `runAllClean` على `cleanFixtures` فقط داخل SQLite in-memory | نعم إذا كان أي report غير clean |
| Blocked metadata | قراءة `id` و`reason` و`expectedOutcome` فقط | لا؛ تُحسب في `blockedFixtureCount` |
| التقرير | إخراج counters آمنة دون payload | لا ما دام `clean=true` |

الـCLI يعيد حاليًا `clean=true` و`fixtureCount=6` و`blockedFixtureCount=4`. الحالات الأربع المحجوبة لا تدخل `runAllClean`، ولذلك لا تُحسب في `reports.length` ولا تخفض النتيجة. الفشل لا يحدث إلا إذا فشل preflight، أو فشل parser، أو فشل replay لإحدى الحالات النظيفة.

في مسار CI/CD، يجب أن يكون أمر snapshot gate خطوة صريحة في Quality Gate، مثل:

```yaml
- name: Run sanitized StockMovements snapshot gate
  shell: bash
  run: |
    set -euo pipefail
    output="$(flutter pub run tool/run_drift_stock_movements_snapshot.dart \
      test/fixtures/stock_movements_golden_fixtures.json)"
    printf '%s\n' "$output"
    python3 - "$output" <<'PY'
    import json
    import sys

    report = json.loads(sys.argv[1])
    assert report["clean"] is True
    assert report["fixtureCount"] == 6
    assert report["blockedFixtureCount"] == 4
    PY
```

ينبغي أن يعامل CI `blockedFixtureCount=4` على أنه counter متوقع، لا كعدد failures. وإذا تغير العدد، يجب أن يتغير catalog والاختبار والوصف في commit واحد بمراجعة واضحة؛ لا ينبغي رفع threshold أو تجاهل الحالات تلقائيًا.

المسار الحالي أثبت هذه البوابة محليًا، بينما checks PR #166 شغلت workflow التحليل والتعليق بنجاح. ولرفع مستوى الضمان، يجب إبقاء snapshot CLI كخطوة مسماة مستقلة في Quality Gate بدل الاعتماد على أن `flutter test` سيشغله ضمنيًا.

## 4. تصميم payloads صناعية مستقلة للحالات الأربع

لا يُنصح بإضافة payloads إلى `cleanFixtures` أو جعل runner يعاملها كحالات نظيفة. الأفضل إنشاء ملف مستقل، مثل:

```text
test/fixtures/stock_movements_blocked_payloads.json
```

ويحتوي على marker التعقيم والإصدار وحالات `blockedCases` كاملة، مع أسماء وقيم صناعية ثابتة. يجب أن يتضمن كل payload الحد الأدنى من الحقول المطلوبة حتى يكون سبب الرفض هو الحالة المقصودة لا نقصًا عشوائيًا في JSON.

بنية مقترحة:

```json
{
  "fixtureVersion": 1,
  "sanitized": true,
  "blockedCases": [
    {
      "id": "blocked_standalone_transfer",
      "expectedFailure": "cleanContract",
      "messageContains": "blocked standalone transfer type",
      "payload": {
        "id": "synthetic-transfer",
        "userId": "synthetic-user",
        "itemId": "synthetic-item",
        "warehouseId": "synthetic-warehouse",
        "movements": [
          {
            "id": "synthetic-transfer-movement",
            "itemId": "synthetic-item",
            "warehouseId": "synthetic-warehouse",
            "type": "transfer",
            "quantity": 1.0,
            "unitCost": 1.0,
            "date": "2026-07-01T00:00:00.000Z",
            "createdAt": "2026-07-01T00:01:00.000Z",
            "referenceId": "synthetic-reference",
            "description": "synthetic blocked transfer",
            "userId": "synthetic-user",
            "syncStatus": "synced"
          }
        ],
        "expectedBalances": [
          {
            "asOfDate": "2026-07-01T00:00:00.000Z",
            "warehouseId": "synthetic-warehouse",
            "quantity": 0.0
          }
        ]
      }
    }
  ]
}
```

يُستكمل الملف بثلاث حالات إضافية: `negative_adjustment` مع `quantity=-1.0` وتتوقع رسالة signed adjustment، و`non_utc_date` مع تاريخ `+03:00` وتتوقع canonical UTC، و`unknown_enum` مع variant لنوع حركة غير معروف. ولتغطية فرعي unknown movement وunknown sync status دون تحويلهما إلى فئتين business مختلفتين، يمكن جعل `unknown_enum` يحتوي `payloadVariants` اثنين: أحدهما يستخدم `type: "future_type"` والآخر يستخدم `syncStatus: "future_status"`.

## 5. اختبار payloads المستقلة

يمكن تعريف DTO اختبار صغير لا يعتمد على Isar أو Drift، ثم تحميل كل payload وتشغيله على `StockMovementGoldenFixture.fromJson`:

```dart
test('all blocked payloads fail for their declared reason', () {
  final source = File(
    'test/fixtures/stock_movements_blocked_payloads.json',
  ).readAsStringSync();
  final json = jsonDecode(source) as Map<String, dynamic>;
  expect(json['sanitized'], isTrue);
  expect(json['fixtureVersion'], 1);

  final cases = json['blockedCases'] as List<dynamic>;
  expect(cases, hasLength(4));

  for (final item in cases) {
    final blocked = item as Map<String, dynamic>;
    final payload = blocked['payload'] as Map<String, dynamic>;
    final expected = blocked['messageContains'] as String;

    expect(
      () => StockMovementGoldenFixture.fromJson(
        payload.map<String, Object?>((key, value) => MapEntry(key, value)),
      ),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          contains(expected),
        ),
      ),
      reason: blocked['id'] as String,
    );
  }
});
```

عمليًا، `non_utc_date` و`unknown_enum` و`negative_adjustment` تفشل أثناء parsing، لأن parser يتحقق من UTC وenum وpositive quantity قبل بناء clean fixture. أما `standalone_transfer` فيمر من parsing نوع الحركة ثم يفشل أثناء clean-contract validation. لذلك يجب أن يسمح DTO الاختبار بحقل `expectedFailureStage` بقيمتي `parser` و`cleanContract`، حتى توثق الاختبارات مرحلة الرفض لا الرسالة فقط.

## 6. اختبار importer للحالات التي تتجاوز parser

للحالات التي تأتي من مصدر Isar محايد، يجب إضافة اختبار منفصل للمهاجر يثبت عدم الكتابة الجزئية:

```dart
final report = await migrator.migrate();
expect(report.migratedCount, 0);
expect(report.checkpoint.isComplete, isFalse);
expect(
  report.issues.map((issue) => issue.reason),
  contains('signed-adjustment'),
);
```

ينطبق ذلك على `negative_adjustment` و`standalone transfer` إذا كان المصدر DTO يسمح بمرورهما قبل طبقة parser. يجب أن يبقى Drift فارغًا في هذا المسار، وأن يكون checkpoint غير مكتمل، وأن يظهر سبب عام فقط.

## 7. ضوابط الخصوصية والحوكمة

يجب أن تكون كل القيم صناعية، وألا تحتوي على معرفات حقيقية أو أوصاف شخصية أو connection URLs أو secrets. يجب ألا يطبع الاختبار payload عند الفشل؛ يكفي `reason` و`expectedFailureStage` واسم الحالة الصناعي. يجب أن تبقى payloads المحجوبة في ملف test مستقل، وألا تدخل runner الإنتاجي أو أي snapshot artifact، وألا تُستخدم لتبرير تفعيل Drift أو shadow-read أو canary.

## الحالة المنفذة

أضيف الملف المستقل `test/fixtures/stock_movements_blocked_payloads.json` بأربع حالات محجوبة صناعية. وتحتوي `unknown_enum` على variantين لتغطية نوع حركة غير معروف وحالة مزامنة غير معروفة، لذلك ينتج عن الحالات الأربع خمس محاولات parser مستقلة. كما أضيف `drift_stock_movements_blocked_payload_test.dart` ليثبت marker التعقيم، عدد الحالات، ومرحلة ورسالة الرفض لكل payload.

النتيجة الحالية: اختبار payloads المستقل نجح بحالتَي اختبار، وregression الموسع نجح بـ37 اختبارًا. بقي `cleanFixtures` دون تغيير، ولم تُضاف أي خطوة كتابة إلى Drift أو Provider أو sync service. الخطوة التالية الموصى بها هي إدخال اختبار payloads كخطوة مسماة في Quality Gate عند تحديث مسار CI، دون اعتبار blocked cases failures.
