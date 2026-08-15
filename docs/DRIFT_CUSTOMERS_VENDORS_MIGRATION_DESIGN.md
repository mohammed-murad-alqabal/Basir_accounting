# التصميم الهندسي لموجة Customers وVendors في Drift

## القرار والنطاق

تُعامل Customers وVendors كموجة تخزين واحدة ذات شريحتين مستقلتين: `customers-v1` و`vendors-v1`. السبب هو أن الكيانين متشابهان في الهوية والنطاق والمزامنة، لكن لكل منهما رابط محاسبي مختلف وسلوك update مختلف يجب ألا يختفي داخل abstraction غير قابل للتدقيق.

تبقى **Isar مصدر التنفيذ الفعلي** في كامل هذه الموجة. يقتصر التنفيذ الأولي على DTOs محايدة، schema معزول، importer، parity، اختبارات تكامل، ثم shadow-read خلف flags مغلقة. لا يُسمح بتسجيل أي adapter في Providers النشطة أو بتغيير مسار Supabase sync قبل إغلاق بوابات القبول.

## الجرد الحالي

| العنصر | Customers | Vendors | أثره على الترحيل |
|---|---|---|---|
| المعرف الدوميني | `customerId`، ويُعرض كـ`Customer.id` | `vendorId`، ويُعرض كـ`Vendor.id` | يجب أن يصبح UUID/text هو المفتاح الأساسي المنطقي، لا Isar auto-increment |
| النطاق | `userId` يحقنه repository من المستخدم الحالي | `userId` يحقنه repository من المستخدم الحالي | يجب استخدام `scopeKey(userId)` في كل read/write/index |
| الأسماء | `nameAr`, `nameEn` | `nameAr`, `nameEn` | فهارس بحث منفصلة وparity نصية exact |
| بيانات الاتصال | `taxNumber`, `phone`, `email`, `address`, `notes` | `phone`, `email`, `address`, `notes` | nullable محفوظ كما هو؛ لا تنظيف تلقائي أو normalization في importer |
| الرابط المحاسبي | `receivableAccountId` | `payableAccountId` | حقل قبول حرج؛ يؤثر مباشرة على posting وaging وledger |
| القيم المالية | `creditLimit`, `balance` كـ`double` | `balance` كـ`double` | تُحفظ حاليًا كـREAL مع parity exact للـdouble؛ لا تُحوّل صامتًا إلى Decimal في هذه الموجة |
| المزامنة | `syncStatus`, `serverUpdatedAt`, `updatedAt` | نفس الحقول | يجب حفظ enum كنص canonical والتواريخ UTC |
| الحذف | repository يحذف فعليًا رغم وجود `isDeleted` | repository يحذف فعليًا رغم وجود `isDeleted` | importer يحفظ `isDeleted`; adapter الأولي يحافظ على hard-delete runtime semantics |
| البحث | Isar يبحث في الاسم العربي والإنجليزي فقط | Isar يبحث في الاسم العربي والإنجليزي فقط | يجب مطابقة repository search؛ UI يملك filter أوسع في الذاكرة ولا يُخلط بالـDAO |

## السلوك الذي يجب الحفاظ عليه

يجب أن يعيد `getAllCustomers` و`getAllVendors` سجلات النطاق الحالي فقط، وأن يعيد lookup بالمعرف `null` عند عدم وجود السجل في النطاق. تفرض عمليات الإضافة والتحديث `userId` المحقون من Provider بدل الثقة في قيمة الكيان الواردة؛ وهذا يمنع الكتابة في نطاق مستخدم آخر.

يجب أن يحافظ adapter الأولي على الفرق الحالي في التحديث: تحديث Customer غير الموجود يرفع خطأ، بينما تحديث Vendor غير الموجود لا يفعل شيئًا. لا يجوز توحيد السلوكين أثناء الترحيل لأن ذلك يغير contract غير المعلن للمستهلكين. يمكن اقتراح normalization لاحقًا في تغيير مستقل مع اختبارات domain واضحة.

> الحذف في المستودعين hard delete فعليًا. وجود `isDeleted` في النموذج لا يعني أن repository الحالي يطبق soft delete؛ لذلك لا يجوز أن يغيّر Drift هذه الدلالة في أول موجة.

## schema المقترح

يُضاف جدولان إلى schema Drift التالية، مع حفظ المفاتيح المنطقية والنطاقات بشكل صريح. يكون المفتاح الأساسي مركبًا من `scopeKey` و`uuid` لمنع تداخل مستخدمين يملكون نفس المعرف المنطقي، وتضاف فهارس على الاسم والتاريخ والرابط المحاسبي عند الحاجة التشخيصية.

| الجدول | المفتاح | الحقول الأساسية |
|---|---|---|
| `Customers` | `(scopeKey, uuid)` | `scopeKey`, `uuid`, `nameAr`, `nameEn`, `taxNumber`, `phone`, `email`, `address`, `notes`, `createdAt`, `updatedAt`, `creditLimit`, `balance`, `receivableAccountId`, `userId`, `syncStatus`, `serverUpdatedAt`, `isDeleted` |
| `Vendors` | `(scopeKey, uuid)` | `scopeKey`, `uuid`, `nameAr`, `nameEn`, `phone`, `email`, `address`, `notes`, `createdAt`, `updatedAt`, `payableAccountId`, `vatNumber`, `registrationNumber`, `balance`, `userId`, `syncStatus`, `serverUpdatedAt`, `isDeleted` |

تستخدم الحقول النصية nullable حيث يسمح domain بذلك، وتُحفظ التواريخ UTC. يُمثل `syncStatus` بقيم canonical هي `synced`, `pendingPush`, `pendingPull`, `conflict` بدل ordinal enum حتى لا يرتبط التخزين بترتيب Dart. يجب أن ترفض DAO القيم غير المعروفة عند القراءة أو الكتابة بدل fallback صامت.

## importer وDTOs

ينبغي إنشاء `CustomerRecord` و`VendorRecord` داخل حزمة `basir_drift_storage`، مع readers من Isar ترتب deterministic حسب `scopeKey` ثم `uuid`. يحتفظ importer بالمعرفات والحقول كما هي، ويحوّل `DateTime` إلى UTC، ولا يعدل phone أو email أو tax numbers أو الحسابات المرتبطة.

تحتاج كل شريحة checkpoint مستقلًا يحوي `sourceCount`, `migratedCount`, `completedAt`، ويُستخدم upsert على `(scopeKey, uuid)`. لا يُسمح بحذف سجلات Drift الزائدة أثناء importer؛ تُترك parity لتكشفها، لأن الحذف التلقائي قد يخفي اختلافًا بين مصدرين أو scope خاطئ.

## قواعد parity

يقارن verifier المصدر والهدف بعد ترتيب ثابت، ويحسب fingerprint مستقلًا لكل scope ولكل شريحة. تشمل المقارنة جميع الحقول التالية دون استثناء: الهوية، النطاق، الأسماء، الاتصال، الحقول الضريبية، الروابط المحاسبية، القيم المالية، التواريخ UTC، sync metadata، و`isDeleted`.

يجب أن تكشف parity الحالات التالية صراحةً: سجل زائد في Drift، سجل مفقود، اختلاف في `receivableAccountId` أو `payableAccountId`, اختلاف balance أو creditLimit، اختلاف syncStatus أو serverUpdatedAt، وتكرار UUID داخل scope. تُحجب الموافقة إذا كان scope غامضًا أو إذا كان fingerprint مطابقًا بعد إسقاط حقل حرج.

| بوابة | شرط النجاح |
|---|---|
| العدد | source count يساوي target count لكل شريحة ولكل scope |
| الهوية | لا يوجد UUID مكرر داخل scope، وجميع UUIDs محفوظة |
| المحاسبة | تطابق account link وbalance وcreditLimit |
| المزامنة | تطابق syncStatus وserverUpdatedAt وupdatedAt |
| الحذف | تطابق isDeleted، مع عدم تحويل hard-delete إلى soft-delete تلقائيًا |
| النطاق | لا يوجد تسرب بين userId أو anonymous scope |
| fingerprint | تطابق canonical fingerprint بعد deterministic sort |

## shadow-read والـProviders

بعد نجاح importer/parity على fixtures ثم لقطة معقمة، يُضاف comparator مستقل لـCustomer وVendor. يقارن `getAllCustomers`, `getCustomerById`, `searchCustomers`, والعمليات المناظرة للموردين. عند إغلاق flag لا يستدعي Drift، وعند فتحه تشخيصيًا يعيد Isar النتيجة دائمًا ويسجل metadata فقط: slice وoperation وoutcome ووقت التنفيذ.

تكون flags مستقلة: `driftCustomerShadowReadEnabledProvider` و`driftVendorShadowReadEnabledProvider`، وقيمتهما الافتراضية `false`. لا يُربط decorator تلقائيًا بـ`customerRepositoryProvider` أو `vendorRepositoryProvider`؛ بل يُوفر candidate وdecorator عبر Providers منفصلة للمراجعة والاختبارات.

## مخاطر يجب إغلاقها قبل التنفيذ

الخطر الأعلى هو تغيير السلوك المحاسبي بسبب فقدان رابط الحساب أو تغيير قيمة `balance`. لذلك تُعامل هذه الحقول كـcritical fields، وتُضاف اختبارات consumer-level تتأكد أن Accounts Receivable وAccounts Payable تستقبلان نفس IDs والقيم بعد adapter.

الخطر الثاني هو اختلاف semantics update بين Customer وVendor. سيُحفظ الفرق في أول موجة، ويُوثق في الاختبار بدل إدخاله ضمن abstraction عام. الخطر الثالث هو sync: المسار الحالي يقرأ ويكتب Isar مباشرة ويطبق LWW مع Supabase؛ لذلك لا يُدخل Drift في sync_service في هذه الموجة، ويُكتفى parity للـsync metadata.

الخطر الرابع هو أن Isar repository يبحث في الاسم فقط، بينما UI يفلتر أيضًا email وphone. يجب اختبار DAO search مقابل سلوك repository الحالي، مع إبقاء UI filtering خارج قرار schema حتى لا تتسع الموجة بلا داعٍ.

## خطة التنفيذ المتدرجة

أولًا، تُنشأ schema وDTOs وDAOs في الحزمة المعزولة، ثم readers وcheckpoints وparity لكل شريحة. ثانيًا، تُضاف adapters تجريبية غير مسجلة، واختبارات CRUD وscope وsearch والحقول الحرجة. ثالثًا، يُضاف اختبار Isar مؤقت إلى SQLite in-memory يثبت parity وعدم تغير المصدر. رابعًا، يُضاف snapshot parser وrunner وrunbook للموجة. خامسًا فقط، وبعد لقطة معقمة نظيفة، تُضاف shadow-read decorators والـflags المغلقة.

لا يبدأ canary read قبل مراجعة parity، ولا يبدأ Drift write أو تعديل sync_service قبل موجة قبول مستقلة. لا يدمج هذا التصميم في الفرع الأساسي، ولا يرفع commit جديدًا أو يعدل PR #62 دون موافقة المستخدم.

## الحالة التصنيفية الحالية

| العنصر | التصنيف | القرار |
|---|---|---|
| Customer/Vendor Isar models | KEEP | مصدر الحقيقة الحالي حتى اكتمال القبول |
| Isar repositories | KEEP | سلوك مرجعي للـparity وrollback |
| Isar auto-increment IDs | FIX/REORGANIZE | لا تنتقل إلى Drift؛ المفتاح المنطقي هو UUID + scope |
| hard delete runtime behavior | KEEP مؤقتًا | يُحفظ في adapter الأولي ويُراجع لاحقًا |
| sync_service وإدخال Drift فيه | INVESTIGATE لاحقًا | خارج نطاق هذه الموجة الأولى |
| account links وbalances | CRITICAL KEEP | بوابة قبول محاسبية لا يجوز إسقاطها |
| UI search الأوسع | KEEP خارج DAO | لا يغير schema ولا repository contract الآن |

## القرار التالي

التصميم جاهز للتنفيذ المحلي في commit مستقل، لكن التنفيذ ينبغي أن يبدأ بعد مراجعة بشرية لهذا العقد لأن schema سيزيد `schemaVersion` ويضيف جداول جديدة. لا يحتاج التصميم إلى snapshot حقيقي في هذه المرحلة، ولا يغيّر PR #62 أو Providers النشطة. بعد الموافقة يمكن تنفيذ schema وDTOs أولًا، ثم التوقف عند بوابة الاختبارات قبل أي commit أو push لاحق.

## حالة التنفيذ المحلية للمرحلة الأولى

أُضيفت الجداول إلى Drift `schemaVersion = 5` مع migration من الإصدارات السابقة، وأُنشئ `CustomerRecord` و`VendorRecord` وواجهتا `CustomerStorage` و`VendorStorage`. تدعم DAOs القراءة حسب النطاق، القراءة الكاملة لأدوات migration اللاحقة، lookup بالمعرف، البحث المتوافق مع Isar في الاسم العربي والإنجليزي، upsert، والحذف المقيد بالنطاق.

أُضيفت اختبارات وحدة تغطي عزل UUID بين المستخدمين، الحقول المحاسبية، sync metadata، البحث، الحذف، ورفض sync status غير المعروف. كما أُضيف اختبار تكامل فعلي Isar مؤقت → SQLite في الذاكرة يثبت حفظ Customers وVendors وعدم تغير عدد سجلات Isar المصدرية. نجحت اختبارات الحزمة وعددها 24 اختبارًا، ونجحت الاختبارات المستهدفة المشتركة وعددها 25 اختبارًا، والتحليل الساكن للملفات الجديدة بلا ملاحظات.

لم تُنفذ بعد importer/parity الخاصة بالموجة، ولا shadow-read decorators أو flags، ولا أي wiring في Providers أو `sync_service`. هذه العناصر تبقى بوابات لاحقة مستقلة، كما لم يُنشأ commit أو push جديد لهذه المرحلة.
