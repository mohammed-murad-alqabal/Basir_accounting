# التصميم الهندسي لموجة Inventory في Drift

## القرار التنفيذي

تُعامل موجة Inventory كمسار ترحيل تدريجي، ولا تُنفذ كتبديل شامل لقاعدة البيانات. يبقى **Isar مصدر التنفيذ الفعلي**، وتقتصر المرحلة التالية على تصميم schema معزول، وقراءة مصدرية deterministic، وimporter غير هدّام، وparity حتمية، ثم snapshot وshadow-read خلف flags مغلقة. لا يجوز تسجيل أي repository مرشح في Providers النشطة، ولا إدخال Drift في `sync_service` أو مسار posting قبل إغلاق بوابات القبول.

تُقسم الموجة إلى شرائح مستقلة حتى لا تختلط مخاطر البيانات المرجعية بمخاطر احتساب الرصيد:

| الشريحة | النطاق | القرار الأولي |
|---|---|---|
| Warehouses | CRUD للمستودعات وعزل المستخدم | تُنفذ أولًا؛ سلوكها بسيط نسبيًا، مع hard-delete محفوظ |
| InventoryItems | أصناف المخزون وحقول الحسابات والتقييم | تُنفذ بعد Warehouses، مع بوابة خاصة لفجوة `barcode` |
| StockMovements | سجل الحركات والرصيد المشتق | تُنفذ بعد تثبيت خوارزمية الرصيد ودلالة التحويل |
| WarehouseTransfers | وثائق التحويل والـembedded items | تُترك لشريحة لاحقة مرتبطة بحسم transfer semantics |

## السلوك المرجعي الذي يجب عدم تغييره

### Warehouses

جميع عمليات Warehouses محكومة بـ`userId`. القراءة والlookup لا يظهران مستودعات مستخدم آخر، والتحديث يرفع خطأ عند عدم وجود السجل داخل النطاق. الحذف **فعلي** عبر `isarId` وليس soft-delete. لا يحتوي النموذج الحالي على `syncStatus` أو `serverUpdatedAt` أو `isDeleted`؛ لا يجوز اختراع هذه الحقول في parity الأولى ثم اعتبارها بيانات مصدرية.

### InventoryItems

يستخدم `InventoryRepositoryImpl` نطاق المستخدم مع شرط مستودع يسمح بالسجل العام عندما يكون `warehouseId` فارغًا، أو بالسجل المطابق للمستودع الحالي. عمليات `getAllItems` و`searchItems` و`getItemBySku` تستبعد `isDeleted = true`، بينما `getItemById` لا يستبعد السجل المحذوف؛ هذه asymmetry عقد سلوكي يجب تغطيته باختبار مستقل.

يحقن المستودع `userId` عند الإضافة والتحديث، ويستخدم `item.warehouseId` إن وُجد وإلا يستخدم `warehouseId` الافتراضي للمستودع. التحديث يرفع خطأ إذا لم يوجد السجل داخل النطاق. الحذف soft-delete: يضع `isDeleted = true` ويحدث `updatedAt`، ولا يحذف الصف فعليًا.

يوجد فهرس Isar فريد على `id` وحده، وليس على `(userId, id)` أو `(warehouseId, id)`. هذا قيد تاريخي لا ينبغي نقله إلى Drift؛ المفتاح المنطقي المقترح هو `(scopeKey, uuid)`، مع تقرير واضح عن أي UUID مكرر بين المستخدمين أو النطاقات.

يوجد فرق مهم بين الـdomain وطبقة Isar: `InventoryItem` يحتوي `barcode`، لكن `InventoryItemModel` لا يملك حقلًا persisted له ولا ينسخه في `fromEntity` أو `toEntity`. لذلك لا يجوز اعتبار barcode محفوظًا فعليًا في parity الحالية. هذه **بوابة تحقيق مستقلة**: إما إصلاح persistence في Isar أولًا، أو توثيق قبول فقدان barcode التاريخي، أو إبقاء الحقل nullable في Drift مع اعتباره غير قابل للقبول في cutover حتى تثبت سياسة واضحة.

### StockMovements

تُقرأ الحركات لصنف حسب `itemId` و`userId`، مع السماح بـ`warehouseId IS NULL` أو مطابقة المستودع الفعال. يدعم التنفيذ الحالي `asOfDate` شاملًا، لكن واجهة domain لا تعلن هذه الوسيطة في `getMovementsForItem`؛ هذا **انحراف contract** يجب إصلاحه أو توثيقه قبل اعتماد adapter.

`getMovementsByReference` يرشح حسب `referenceId` و`userId` فقط ولا يضيف شرط المستودع. الإضافة والدفعة يحقنان `userId`، لكنهما لا يفرضان warehouse بديلًا؛ قيمة `warehouseId` الواردة من الحركة تبقى كما هي. لا يحتوي سجل الحركة على `updatedAt` أو `isDeleted`.

الرصيد مشتق من replay للحركات وليس من قيمة persisted موثوقة. الخوارزمية الحالية تضيف `inbound`، تطرح `outbound`، تضيف `adjustment`، وتطرح `transfer` افتراضيًا. توجد تعليقات متعارضة داخل التنفيذ حول كون `adjustment` موجبًا أو سالبًا، وحول كون `transfer` سببًا أم اتجاهًا. في المقابل، `InventoryService` ينشئ للتحويل حركتين صريحتين: `outbound` في المصدر و`inbound` في الوجهة، وكلتاهما بكمية موجبة. لذلك يجب عدم بناء cutover على فرع `StockMovementType.transfer` قبل تقرير بيانات فعلي يحدد وجوده ودلالته.

## schema المقترح في Drift

سيكون رقم schema التالي بعد قاعدة Customers/Vendors هو `schemaVersion = 6`، مع migrations additive فقط. لا تُحذف جداول أو أعمدة، ولا تُعاد تسمية أعمدة قائمة في هذه الموجة.

### جدول Warehouses

| العمود | النوع | القاعدة |
|---|---|---|
| `scopeKey` | text | جزء من المفتاح؛ مشتق حتميًا من المستخدم |
| `uuid` | text | الجزء الثاني من المفتاح؛ يساوي `Warehouse.id` |
| `nameAr`, `nameEn` | text | مطلوبان، مع فهارس اسمية داخل scope |
| `location` | text nullable | يحفظ كما هو دون normalization |
| `userId` | text nullable | يطابق المصدر بعد حقن repository |
| `createdAt`, `updatedAt` | datetime | UTC canonical |

المفتاح الأساسي هو `(scopeKey, uuid)`. لا تضاف أعمدة sync أو soft-delete حتى توجد موافقة تصميمية مستقلة على توسيع contract.

### جدول InventoryItems

| العمود | النوع | القاعدة |
|---|---|---|
| `scopeKey`, `uuid` | text | مفتاح مركب؛ لا unique عالميًا |
| `nameAr`, `nameEn` | text | مطلوبان؛ فهارس بحث داخل scope |
| `sku`, `description`, `unit`, `categoryId` | text nullable | تحفظ exact |
| `purchasePrice`, `salePrice` | real nullable | لا تحويل صامت إلى Decimal في هذه الموجة |
| `currentQuantity` | real | default `0`؛ parity مع القيمة المستخرجة من Isar |
| `valuationMethod` | text | canonical enum name: `fifo`, `weightedAverage` |
| `assetAccountId`, `cogsAccountId`, `revenueAccountId`, `primaryAccountId` | text nullable | حقول محاسبية حرجة |
| `syncStatus` | text | canonical enum name مع CHECK للقيم المعروفة |
| `serverUpdatedAt` | datetime nullable | UTC |
| `isDeleted` | boolean | default `false`; soft-delete semantics محفوظة |
| `createdAt`, `updatedAt` | datetime | UTC |
| `userId`, `warehouseId` | text nullable | يحفظان كما يخرجان من source |
| `taxCategory` | text | default `S` |
| `barcode` | text nullable | لا يُقبل في cutover قبل حسم فجوة Isar/domain |

يجب أن تكون فهارس القراءة مركبة على `(scopeKey, warehouseId, isDeleted)`، ويفضل إضافة فهارس مناسبة لـ`sku` وحقول الاسم بعد قياس SQLite/WASM. لا تفرض unique على SKU ما دام المصدر الحالي لا يفرضه.

### جدول StockMovements

| العمود | النوع | القاعدة |
|---|---|---|
| `scopeKey`, `uuid` | text | مفتاح مركب بدل unique العالمي في Isar |
| `itemId` | text | فهرس مع scope |
| `warehouseId` | text nullable | null معناها سجل عام كما في المصدر |
| `type` | text | canonical: `inbound`, `outbound`, `transfer`, `adjustment` |
| `quantity`, `unitCost` | real | يحفظان exact كـdouble في المرحلة الأولى |
| `date`, `createdAt` | datetime | UTC |
| `referenceId`, `description` | text nullable | reference index مع scope |
| `userId` | text nullable | scope source metadata |
| `syncStatus` | text | canonical enum name مع CHECK |

لا يضاف `updatedAt` أو `isDeleted` إلى جدول الحركة في parity الأولى. الفهارس الأساسية هي `(scopeKey, itemId, date)`, `(scopeKey, warehouseId, date)`, و`(scopeKey, referenceId)`.

## بوابات parity والقبول

لا يعتبر نجاح importer وحده قبولًا. يجب أن يمر كل scope وكل شريحة بالبوابات التالية:

| البوابة | شرط النجاح |
|---|---|
| الهوية | لا UUID مكرر داخل scope؛ جميع UUIDs محفوظة دون توليد بديل صامت |
| العدد | source count يساوي target count لكل شريحة وscope |
| النطاق | لا تسرب بين userId أو warehouse scope؛ null warehouse يظل null |
| Warehouses | تطابق الأسماء والموقع والتواريخ، مع إثبات hard-delete/update error semantics |
| InventoryItems | تطابق account links وprices وquantity وvaluation وtax category وsync metadata |
| soft-delete | `getAll/search/sku` تستبعد المحذوف، و`getById` يستطيع رؤية المحذوف كما في Isar |
| StockMovements | تطابق كل الحقول، خصوصًا type وquantity وunitCost وreferenceId والتواريخ |
| derived stock | تطابق replay مع Isar على fixtures، مع اختبار as-of-date شامل |
| barcode | لا clean acceptance إذا ظهرت قيمة barcode في domain دون سياسة persistence معتمدة |
| transfer | لا clean acceptance للرصيد إذا وُجدت حركة `transfer` غير مصنفة أو غير مفسرة |
| fingerprint | canonical fingerprint متطابق بعد ترتيب deterministic |
| عدم الإتلاف | importer لا يحذف صفوف Drift الزائدة ولا يصلح mismatch تلقائيًا |

يجب أن تُجرى parity للـraw records أولًا، ثم parity منفصلة للقراءة السلوكية، ثم parity ثالثة للرصيد المشتق. لا يجوز إسقاط الحقول الحرجة من fingerprint بحجة أن القراءة الحالية لا تعرضها.

## خطة التنفيذ المرحلية

تبدأ المرحلة التنفيذية بفرع مستقل مبني على قاعدة Drift المستقرة، وليس على الفرع الأساسي مباشرة. تُنفذ Warehouses أولًا مع schema وstorage وreader وparity واختبارات CRUD والنطاق. بعد ذلك تُنفذ InventoryItems مع اختبار asymmetry للـsoft-delete وبوابة barcode. لا يبدأ StockMovements قبل إضافة golden fixtures للحركات الأربع وإصلاح أو توثيق `asOfDate` في interface.

بعد نجاح الاختبارات المحلية، تُضاف readers من Isar وimporter مستقل لكل شريحة مع checkpoints منفصلة. ثم يضاف snapshot parser مع شرط `sanitized: true` وCLI privacy-safe، ويُشغل على fixture اصطناعية قبل أي لقطة فعلية. بعد لقطة فعلية معقمة ومراجعة parity، يمكن إضافة shadow-read decorators؛ تظل flags مغلقة، وتعيد decorators نتيجة Isar دائمًا، وتفوض كل الكتابات والحذف إلى Isar.

تؤجل WarehouseTransfers إلى PR لاحقة ما لم يثبت أن الحاجة إلى parity مشتركة تفرض إدخالها في نفس الموجة. سبب التأجيل هو أن التحويل وثيقة embedded تحتوي قائمة عناصر، بينما الأثر المخزني الفعلي ينتج من حركتين منفصلتين، ويجب منع ازدواجية المصدر أو تكرار الحركات عند الترحيل.

## تصنيف عناصر التدقيق

| العنصر | التصنيف | القرار |
|---|---|---|
| Isar repositories الحالية | KEEP | المرجع السلوكي ومصدر التنفيذ حتى cutover معتمد |
| Isar global unique IDs | FIX/REORGANIZE | لا تنتقل كقيد عالمي؛ Drift يستخدم scope + UUID |
| Warehouse hard-delete | KEEP مؤقتًا | يحفظ في adapter الأولي ويُراجع لاحقًا |
| InventoryItem soft-delete | CRITICAL KEEP | يجب حفظ asymmetry بين list/search/lookup |
| InventoryItem account links | CRITICAL KEEP | بوابة محاسبية لا يجوز إسقاطها |
| InventoryItem barcode gap | INVESTIGATE/FIX | لا cutover قبل سياسة persistence واضحة |
| StockMovement `asOfDate` mismatch | FIX/INVESTIGATE | توحيد interface أو توثيق contract قبل adapter |
| StockMovement transfer branch | BLOCKED/INVESTIGATE | لا قبول للرصيد قبل حسم الدلالة والبيانات الفعلية |
| WarehouseTransfers | ARCHITECTURE FOLLOW-UP | PR لاحقة بعد تثبيت حركة المخزون |
| `sync_service` wiring | KEEP OUT OF SCOPE | لا تعديل في هذه الموجة |
| Drift active Providers | KEEP DISABLED | لا تبديل من Isar ولا canary تلقائي |

## الحالة المستهدفة

الحالة الآمنة المستهدفة هي ثلاث شرائح Drift معزولة، لكل منها schema واضح وDAO وimporter وparity وsnapshot وshadow-read مستقل، مع composite scope keys وفingerprints حتمية. يظل Isar قابلًا للرجوع إليه ومصدرًا وحيدًا للكتابة، ولا يبدأ canary إلا بعد تقرير نظيف يتضمن الحقول المحاسبية، soft-delete، null warehouse، الرصيد المشتق، وقرار barcode وtransfer.

## حالة التنفيذ المحلية: Warehouses وInventoryItems

أُنشئ فرع Warehouses المحلي `work/inventory-warehouses-drift-20260817` فوق commit Customers/Vendors المستقر، وأُضيف جدول `Warehouses` إلى Drift مع `schemaVersion = 6` وmigration additive ومفتاح مركب `(scopeKey, uuid)` وفهارس اسمية. أُضيف `WarehouseRecord` و`WarehouseStorage` و`WarehouseStore` مع القراءة حسب المستخدم، القراءة الكاملة، lookup، upsert، والحذف الفعلي المقيد بالنطاق. أصبح هذا الجزء في commit محلي منشور ضمن PR #148، ولم يُدمج.

بدأ فرع InventoryItems `work/inventory-items-drift-20260817` من commit Warehouses المنشور `69b16563`. أُضيف جدول `InventoryItems` وmigration additive إلى `schemaVersion = 7`، مع composite scope key، وwarehouse scope nullable، وفهارس SKU والأسماء وsoft-delete. أُضيف `InventoryItemRecord` و`InventoryItemStorage` و`InventoryItemStore` مع:

| السلوك | التنفيذ المحلي |
|---|---|
| النطاق | `scopeKey` مع السجل العام `warehouseId = null` أو المستودع المطابق |
| list/search/SKU | تستبعد `isDeleted = true` كما في Isar |
| lookup بالمعرف | لا يستبعد المحذوف، للحفاظ على asymmetry الحالية |
| الحذف | soft-delete وتحديث `updatedAt` بدل حذف الصف |
| الحقول الحرجة | account links، الأسعار، الكمية، valuation، sync metadata، tax category |
| barcode | محفوظ في Drift كـnullable، لكنه **غير مقبول للـparity أو cutover** قبل إصلاح فجوة Isar/domain |

نجحت اختبارات الحزمة وعددها **33 اختبارًا** بعد إضافة خمس اختبارات InventoryItems، ونجح التحليل الساكن للملفات المتأثرة بلا ملاحظات، كما نجح `git diff --check`. لم يُسجل InventoryItemStore في Providers التطبيق، ولم يتغير Isar أو `sync_service` أو أي مسار posting. لا يوجد commit أو push لشريحة InventoryItems حتى الآن.

الخطوة الآمنة التالية هي مراجعة بوابة barcode وتقرير ما إذا كان سيتم إصلاح persistence في Isar في تغيير مستقل أو اعتماد barcode غير متاح تاريخيًا. بعد ذلك يمكن طلب إذن مستقل لإنشاء commit محلي لهذه الشريحة، ثم طلب آخر قبل أي push أو فتح PR.

## المراجع الداخلية

[1]: ../lib/features/inventory/data/repositories/inventory_repository_impl.dart "InventoryItem Isar repository"
[2]: ../lib/features/inventory/data/repositories/stock_movement_repository_impl.dart "StockMovement Isar repository"
[3]: ../lib/features/inventory/data/repositories/warehouse_repository_impl.dart "Warehouse Isar repository"
[4]: ../lib/features/inventory/data/models/inventory_item_model.dart "InventoryItem Isar model"
[5]: ../lib/features/inventory/data/models/stock_movement_model.dart "StockMovement Isar model"
[6]: ../lib/features/inventory/application/inventory_service.dart "Inventory transfer orchestration"
[7]: ../packages/basir_drift_storage/lib/src/basir_database.dart "Current Drift schema"
