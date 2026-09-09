# Real Snapshot Parity Intake — StockMovements

## الغرض والنطاق

يعرّف هذا المستند مسار استقبال نسخة snapshot واقعية **معقمة** من مصدر Isar لتشغيل importer وraw/reference/derived parity على شريحة `StockMovements`. المسار تشخيصي offline فقط، ولا يفتح قاعدة Isar التشغيلية من داخل التطبيق، ولا يكتب Drift في الإنتاج، ولا يغير Provider أو `sync_service` أو نتيجة القراءة المرئية.

> لا تُعتبر snapshot الواقعية صالحة للتشغيل لمجرد أنها JSON قابلة للقراءة. يجب إثبات مصدرها، وتعقيمها، واكتمال عقدها، وسلامة نطاقها قبل إدخالها إلى runner.

## ما يلزم قبل الاستقبال

يجب أن يثبت مالك البيانات أن النسخة صادرة من نسخة عمل أو backup غير متصل، وأنها لا تحتوي رموز وصول أو كلمات مرور أو tokens أو cookies أو مفاتيح تشفير أو عناوين اتصال أو بيانات تعريف شخصية غير مطلوبة للـparity. لا تُرفع النسخة إلى Git، ولا تُرسل إلى خدمة خارجية، ولا تُحفظ في سجل CI. تحفظ محليًا خارج working tree، وتُحذف أو تُتلف وفق سياسة الفريق بعد انتهاء التدقيق.

يجب أن يقتصر النطاق على الحقول اللازمة للعقد الحالي: الهوية المركبة، `itemId`، `warehouseId`، نوع الحركة، الكمية، التكلفة، `date`، `createdAt`، `referenceId`، `userId`، `syncStatus`، والحقول المطلوبة لحساب الرصيد. إذا كان المصدر يحتوي حقولًا إضافية، فلا تُنسخ إلى snapshot إلا بعد قرار موثق يثبت ضرورتها.

## عقد التعقيم

يُستبدل كل معرّف حقيقي بقيمة ثابتة غير قابلة للربط خارج snapshot نفسها، مع الحفاظ على العلاقات الداخلية والتكرارات المقصودة. يجب أن يكون لكل snapshot نطاق واحد معلن أو مجموعة scopes معلنة، وأن تبقى العلاقات بين `itemId` و`warehouseId` و`referenceId` متسقة. التعقيم لا يغير النوع أو sign أو التاريخ أو حدود `asOfDate` أو حالة المزامنة.

| الفئة | الحالة المطلوبة |
|---|---|
| الأسرار والاعتمادات | صفر؛ أي ظهور يوقف المسار فورًا |
| معرفات المستخدم والعناصر والمستودعات | معقمة، ثابتة داخل النسخة، وغير قابلة للربط خارجيًا |
| التواريخ | UTC صريحة، مع الحفاظ على حالات boundary اللازمة |
| الكميات والتكاليف | أرقام finite؛ الكمية موجبة في العقد الحالي |
| الأنواع والحالات | enums معروفة؛ unknown enum محجوب |
| التحويلات | dual-entry فقط؛ standalone `transfer` محجوب |
| adjustments | positive adjustment فقط حتى اعتماد العقد السالب |
| duplicates | لا تُحل تلقائيًا؛ تُسجل كفشل وتُراجع يدويًا |

## فحوصات ما قبل التشغيل

قبل تشغيل runner، تُجرى الفحوصات التالية على نسخة العمل خارج Git:

1. فحص بنية JSON ووجود marker تعقيم صريح وإصدار schema معروف.
2. فحص secret patterns وconnection URLs وPEM وBearer وAWS variables، مع منع طباعة السطر المطابق.
3. فحص UTC والأنواع والحقول الإلزامية وpositive finite quantities.
4. فحص duplicate scoped keys وduplicate movement IDs.
5. فحص اتساق العلاقات داخل snapshot، بما في ذلك reference الخاص بالتحويل الثنائي.
6. فحص أن الحالات المحجوبة مصنفة ولا تدخل clean fixtures.
7. حفظ hash للنسخة محليًا فقط لتثبيت reproducibility، دون حفظ محتواها أو hash في CI العام إذا كان يمكن أن يربطها بمصدر حقيقي.

أي فشل في هذه القائمة يوقف التشغيل. لا يجوز للمصحح حذف الصفوف أو تغيير القيم أو إسقاط الحقول لتجاوز الفشل.

## التشغيل الآمن

بعد اجتياز الفحوصات، يُشغل runner من جذر المستودع باستخدام نسخة Flutter/Dart المقفلة:

```bash
dart run tool/run_drift_stock_movements_snapshot.dart /secure/path/stock-movements-sanitized.json
```

يستخدم runner SQLite in-memory لكل تشغيل، ويعيد counters وmetadata آمنة فقط. لا يجب أن يظهر في stdout أو stderr أي `userId` أو `itemId` أو `warehouseId` أو `referenceId` أو وصف أو كمية متوقعة تفصيلية. إذا ظهر payload، يُوقف التشغيل وتُراجع نقطة التسجيل قبل إعادة المحاولة.

## بوابات parity

| البوابة | شرط القبول |
|---|---|
| Raw parity | تطابق العدد والهوية والنطاق والحقول المسموح بها دون duplicates |
| Reference parity | تطابق lookup حسب reference مع بقاء العلاقات cross-warehouse صحيحة |
| Derived parity | تطابق الرصيد لكل `asOfDate` وwarehouse boundary ضمن tolerance موثق |
| Importer | اكتمال checkpoints، وإعادة التشغيل idempotent، وعدم الكتابة عند blocked rows |
| Privacy | لا secrets ولا payload في artifacts أو logs |
| Rollback | لا تغيير في Isar أو Provider؛ حذف output المحلي يعيد النظام إلى حالته السابقة |

القبول يكون **per slice**. نتيجة `clean: true` تثبت snapshot المحددة فقط، ولا تمنح إذنًا لتفعيل shadow-read أو canary أو Drift writes.

## الحالات التي تمنع التفعيل

يُمنع الانتقال إلى shadow-read أو canary عند وجود أي raw/reference/derived mismatch، أو duplicate، أو checkpoint غير مكتمل، أو enum غير معروف، أو تاريخ غير UTC، أو standalone transfer، أو adjustment سالب غير معتمد، أو نقص في قرار barcode/حقول المخزون ذات الأثر المحاسبي. كما يُمنع استخدام snapshot اصطناعية أو golden fixtures كبديل عن snapshot واقعية عند اتخاذ قرار rollout.

## المخرجات المطلوبة للمراجعة

يُحفظ تقرير آمن يتضمن version وhash محليًا وcounts فقط، ونتائج كل بوابة، وعدد الصفوف المحجوبة وأسبابها العامة، ونسخة runner وcommit المصدر. لا يتضمن التقرير محتوى snapshot أو المعرفات أو القيم المحاسبية التفصيلية. يراجع التقرير شخصان على الأقل قبل أي طلب لتفعيل flag، وتبقى الموافقة على التفعيل منفصلة عن موافقة commit أو push.

## الوضع الحالي

المتاح حاليًا هو golden catalog معقم وsnapshot runner لحركات المخزون؛ لم تُقدّم snapshot واقعية معقمة في هذه المرحلة. لذلك تبقى بوابة parity الواقعية **غير مكتملة**، وتبقى Isar مصدر التنفيذ، وflags shadow-read مغلقة، ولا توجد Drift writes أو canary أو cutover.
