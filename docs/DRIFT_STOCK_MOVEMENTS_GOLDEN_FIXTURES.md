# تصميم Golden Fixtures لحركات المخزون والرصيد المشتق

## الغرض والنطاق

تحدد هذه الوثيقة مجموعة fixtures اصطناعية، صغيرة، deterministic، وprivacy-safe لاختبار تخزين `StockMovements` وحساب الرصيد المشتق قبل إدخال Drift في أي Provider أو مسار مزامنة. لا تمثل fixtures مصدر بيانات حقيقيًا، ولا تمنح موافقة على cutover أو shadow-read أو الكتابة في الإنتاج.

المرجع السلوكي الحالي هو `StockMovementRepositoryImpl`: القراءة حسب `itemId` و`userId`، والسماح بالحركة العامة ذات `warehouseId = null` أو الحركة الخاصة بالمستودع الفعال، ودعم `asOfDate` الشامل في التنفيذ. توجد فجوة contract لأن واجهة domain لا تعلن `asOfDate` في `getMovementsForItem`، كما أن فرع `transfer` و`adjustment` غير محسومين بما يكفي لقبول parity للرصيد.

## العقد المرجعي المقترح للاختبار

يجب أن تستخدم كل fixtures التواريخ UTC، ومعرفات اصطناعية ثابتة، وكمية موجبة. لا تستخدم fixtures أرقامًا عشرية طويلة أو قيمًا عشوائية؛ الغرض هو كشف اختلاف sign أو scope أو التاريخ، لا اختبار دقة IEEE-754.

| القاعدة | القرار الاختباري |
|---|---|
| `inbound` | يضيف `quantity` إلى الرصيد |
| `outbound` | يطرح `quantity` من الرصيد |
| `adjustment` الموجب | يضيف `quantity` في المرحلة الحالية فقط |
| `adjustment` السالب | **محجوب** حتى يُعتمد نموذج اتجاه صريح؛ لا يُفسر بصمت |
| `transfer` standalone | **محجوب** في clean fixtures؛ لا يُستخدم كإشارة اتجاه غامضة |
| التحويل المعتمد | حركتان ذريتان: `outbound` في المصدر و`inbound` في الوجهة، بنفس `referenceId` |
| `asOfDate` | شامل؛ الحركة التي تاريخها يساوي الحد تدخل في الرصيد |
| ترتيب replay | `date ASC` ثم `uuid ASC` بعد تحويل التاريخ إلى UTC |
| `warehouseId = null` | حركة عامة تدخل عند حساب مستودع محدد، وفق سلوك Isar الحالي |
| scope | لا تدخل حركة مستخدم آخر حتى لو تطابق `itemId` أو `uuid` |
| `getMovementsByReference` | يعيد كل حركات المرجع داخل user scope؛ لا يرشح مستودعًا إلا إذا تغير contract صراحة |
| الحذف | لا يوجد soft-delete في سجل الحركة الحالي؛ الحركات append-only في هذه الموجة |

> لا تُستخدم هذه القواعد لإخفاء التناقض الحالي. إذا اختلف التنفيذ عن القاعدة، يجب أن تفشل fixture مع تقرير واضح، لا أن تعدل expected value تلقائيًا.

## شكل fixture المعياري

يحفظ الملف machine-readable في `test/fixtures/stock_movements_golden_fixtures.json`، ويعلن `fixtureVersion: 1` و`sanitized: true`. كل حالة تحتوي `id`, `userId`, `itemId`, و`movements`. كل حركة تحتوي على `id`, `itemId`, `warehouseId`, `type`, `quantity`, `unitCost`, `date`, `createdAt`, `referenceId`, `description`, `userId`, و`syncStatus`.

حقول `description` الاصطناعية لا تحتوي أسماء عملاء أو أرقام فواتير حقيقية. ويجب أن يرفض parser أي fixture لا تعلن `sanitized: true` أو تحتوي enum غير معروف أو تاريخًا غير UTC أو كمية غير موجبة.

## حالات القبول النظيفة

### `basic_lifecycle`

تختبر دورة الوارد والصادر والتسوية الموجبة لصنف واحد في مستودع واحد. الحركات هي وارد 10، صادر 3، وتسوية موجبة 2؛ لذلك الرصيد النهائي هو **9**. يجب أن يعطي replay النتائج 10 بعد أول حركة، و7 بعد الثانية، و9 بعد الثالثة.

### `general_and_warehouse_scope`

تضع fixture حركة عامة مقدارها 5 بلا مستودع، وحركة صادرة مقدارها 2 في `wh-a`، وحركة واردة مقدارها 100 في `wh-b`. عند حساب `wh-a` يكون الرصيد **3**، وعند حساب `wh-b` يكون **105** إذا ظل contract الحالي الذي يضم الحركة العامة قائمًا. كما يجب إثبات أن الحركة الخاصة بـ`wh-b` لا تدخل رصيد `wh-a`.

### `transfer_dual_entry`

تبدأ fixture برصيد وارد مقداره 20 في `wh-a`. يمثل التحويل إلى `wh-b` بحركتين تحملان `referenceId = transfer-001`: صادر 7 من `wh-a` ووارد 7 إلى `wh-b`. الرصيد المتوقع هو **13** في المصدر و**7** في الوجهة. لا توجد حركة من النوع `transfer` في clean fixture، ويجب أن يكشف verifier أي حركة standalone من هذا النوع بدل احتسابها تلقائيًا.

### `same_date_inclusive_boundary`

تضع fixture حركة وارد 10 وحركة صادر 4 في نفس التاريخ والوقت UTC، ثم تطلب الرصيد قبل التاريخ وفي التاريخ نفسه. النتيجة قبل الحد **0**، والنتيجة عند الحد **6**. يجب أن يثبت UUID tie-break أن النتيجة لا تعتمد على ترتيب الصفوف العائد من SQLite أو Isar.

### `reference_lookup_cross_warehouse`

تستخدم نفس `referenceId` لحركتي تحويل في مستودعين مختلفين داخل نفس user scope. يجب أن يعيد `getMovementsByReference` الحركتين معًا، وأن يثبت الاختبار أن تصفية المستودع ليست جزءًا من هذا contract الحالي. إذا تقرر لاحقًا إضافة warehouse filter، يجب تغيير contract والـfixture معًا.

### `user_scope_isolation`

تكرر `itemId` وUUIDات اصطناعية في user scope آخر مع كميات مختلفة. رصيد `user-a` لا يتأثر بأي حركة لـ`user-b`: المثال يعطي **10** للأول و**50** للثاني. هذه الحالة تمنع نجاح adapter ينسى `userId` في الاستعلام أو fingerprint.

## مصفوفة النتائج المتوقعة

| الحالة | scope | warehouse | قبل الحد | عند الحد | النتيجة النهائية |
|---|---|---|---:|---:|---:|
| basic lifecycle | user-a/item-coffee | wh-a | 0 | 9 بعد كامل السجل | 9 |
| general + private A | user-a/item-oil | wh-a | 0 | 3 | 3 |
| general + private B | user-a/item-oil | wh-b | 0 | 105 | 105 |
| transfer source | user-a/item-rice | wh-a | 20 | 13 بعد التحويل | 13 |
| transfer destination | user-a/item-rice | wh-b | 0 | 7 بعد التحويل | 7 |
| same-date boundary | user-a/item-date | wh-a | 0 | 6 | 6 |
| isolated user A | user-a/item-shared | wh-a | 0 | 10 | 10 |
| isolated user B | user-b/item-shared | wh-a | 0 | 50 | 50 |

## الحالات المحجوبة أو السلبية

هذه الحالات مهمة، لكنها لا تدخل clean acceptance قبل حسم العقد:

| الحالة | المتوقع حاليًا | قرار القبول |
|---|---|---|
| حركة `transfer` منفردة بكمية 7 | التنفيذ الحالي يميل إلى طرحها | `BLOCKED`; لا parity للرصيد حتى تُحسم الدلالة |
| `adjustment` سالب بكمية -3 | التعليقات والعقد متعارضان | `BLOCKED`; يجب اعتماد signed quantity أو adjustment direction |
| `asOfDate` في واجهة domain | التنفيذ يدعمها والواجهة لا تعلنها | `CONTRACT_FIX`; لا adapter نهائي قبل التوحيد |
| حركة بتاريخ local timezone | قد تختلف عند التخزين والمقارنة | `REJECT`; يجب UTC canonical |
| حركة بكمية NaN أو Infinity | قد تلوث الرصيد | `REJECT`; parser وDAO يرفضانها |
| enum غير معروف | قد يؤدي إلى fallback أو فشل غير واضح | `REJECT`; لا fallback صامت |
| reference واحد بحركتين في scope مختلف | قد يخفي تسربًا أو merge خطأ | `REJECT`; يجب أن يكون scope جزءًا من fingerprint |

## الاختبارات التي ستستهلك fixtures

يجب تحويل كل حالة إلى اختبارات مستقلة بدل اختبار شامل واحد. الاختبار الأول يتحقق من parser والـschema، والثاني يتحقق من insert/read round-trip، والثالث يطبق replay المرجعي في الذاكرة، والرابع يقارن `StockMovementStore.getStockLevel` مع expected snapshots، والخامس يتحقق من scope وwarehouse predicates، والسادس يتحقق من `getMovementsByReference`، والسابع يمرر الحالات المحجوبة ويتأكد من رفضها برسالة تصنيفية.

يجب أن يفشل الاختبار برسالة تشمل `fixtureId`, `scope`, `itemId`, `warehouseId`, `asOfDate`, و`expected/actual`، دون طباعة payload كامل في CI. يمكن تسجيل hash للfixture بدل بيانات الحركة عند الحاجة إلى telemetry.

## بوابات قبول موجة StockMovements

| البوابة | شرط النجاح |
|---|---|
| parser | كل clean fixtures معقمة، UTC، enum صحيح، وكمية finite وموجبة |
| storage | round-trip كامل لكل الحقول دون إسقاط `referenceId` أو `unitCost` أو sync metadata |
| scope | لا تسرب user أو warehouse، والحركة العامة تتبع contract المعلن |
| ordering | replay حتمي لا يتأثر بترتيب database الطبيعي |
| as-of | الحد شامل، وتاريخ الحركة لا `createdAt` هو معيار الإدراج |
| transfers | الحركتان الذرية متطابقتان في المرجع، ولا double-count |
| adjustment | contract موقع ومعتمد قبل إدخال negative adjustment |
| parity | raw parity ثم behavioral parity ثم derived-balance parity |
| rollback | Isar يبقى مصدر النتيجة والكتابة؛ لا Drift write activation |
| review | تقرير بشري يوافق على contract قبل shadow-read أو canary |

## التنفيذ المحلي الحالي

أُنشئ الفرع المحلي `work/stock-movements-golden-fixtures-20260817` فوق commit InventoryItems المنشور `47452e8b`. أُضيف parser typed في `lib/core/persistence/drift_stock_movements_golden.dart`، ورفض صريح للـpayload غير المعقم، والتواريخ التي لا تنتهي بـ`Z`، والقيم غير finite، وenum غير المعروف، وstandalone `transfer` داخل clean fixtures. أُضيف `StockMovementGoldenReplay` مستقل عن SQLite وIsar يستخدم `date` لا `createdAt`، ويدعم scope العام، الترتيب `date ثم UUID`، وحساب reference counts.

أُضيف اختبار `test/core/persistence/drift_stock_movements_golden_test.dart` بعدد **9 اختبارات ناجحة** تغطي parser والـcatalog، جميع clean fixtures، دورة الحركة، scope العام والخاص، حد `asOfDate` الشامل، dual-entry transfer، عزل المستخدمين، رفض non-UTC، ورفض standalone transfer. نجح `flutter analyze` للملفات المتأثرة بلا ملاحظات، ونجح `git diff --check`. لم يُضف أي Drift schema أو DAO أو importer، ولم يتغير Isar أو Providers أو `sync_service`.

## التنفيذ المحلي الحالي: Storage وSQLite parity

أُنشئ فرع `work/stock-movements-drift-20260817` فوق commit golden fixtures المنشور `dd716a36`. أُضيف جدول `StockMovements` إلى Drift مع migration additive إلى `schemaVersion = 8`، composite scope key `(scopeKey, uuid)`، وفهارس item/date وwarehouse/date وreference. لا يخزن الجدول رصيدًا مشتقًا داخل الصف.

أُضيف `StockMovementRecord` و`StockMovementStorage` و`StockMovementStore` مع القراءة حسب الصنف والمستخدم والمستودع والتاريخ، القراءة حسب reference داخل user scope، القراءة الكاملة، الإضافة الفردية والدفعية، وحساب الرصيد من `inbound` و`outbound` وpositive `adjustment`. تُحفظ الحركة `transfer` في storage لرصد البيانات، لكن `readStockLevel` يرفض حسابها كحركة standalone حتى يثبت dual-entry contract.

أُضيف اختبار SQLite يحمّل clean fixtures نفسها ويقارن الأرصدة المتوقعة مع `StockMovementStore`، واختبارات scope وasOfDate وbatch/reference وround-trip والبوابة المحجوبة. نجحت **50 اختبارًا** في الاختبارات المستهدفة، ونجح `flutter analyze` للملفات المتأثرة بلا ملاحظات، و`git diff --check`. لم يتغير Isar أو Providers أو `sync_service`، ولا يوجد commit أو push لشريحة Storage هذه حتى الآن.

## الخطوة التالية بعد اعتماد التصميم

بعد المراجعة البشرية، يمكن طلب إذن مستقل لإنشاء commit محلي لشريحة StockMovements Storage. لا يُسمح بإنشاء importer من Isar أو parity على بيانات فعلية أو shadow-read قبل تثبيت قرار `asOfDate` في domain، واعتماد positive/negative adjustment، والتحقق من dual-entry transfer. لا يُسمح بأي push أو PR جديدة دون موافقة مستقلة.

## المراجع الداخلية

[1]: ../lib/features/inventory/domain/entities/stock_movement.dart "StockMovement domain contract"
[2]: ../lib/features/inventory/domain/repositories/stock_movement_repository.dart "StockMovement repository interface"
[3]: ../lib/features/inventory/data/repositories/stock_movement_repository_impl.dart "Current Isar movement behavior"
[4]: ../lib/features/inventory/application/inventory_service.dart "Dual-entry transfer orchestration"
