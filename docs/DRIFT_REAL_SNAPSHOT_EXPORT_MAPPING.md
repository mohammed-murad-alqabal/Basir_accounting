# StockMovements Real Snapshot Export Mapping

## الغرض

يوثق هذا المستند حدود تحويل `StockMovementModel` في Isar إلى snapshot معقمة قابلة للفحص والتشغيل offline. لا يمثل هذا المستند exporter تشغيليًا، ولا يفتح قاعدة Isar تلقائيًا، ولا يكتب Drift، ولا يغير Providers أو `sync_service`.

## المبدأ الحاكم

لا يجوز تحويل قيمة nullable إلى قيمة وهمية بهدف تمرير preflight أو إخفاء فقدان بيانات. أي سجل يفتقد هوية أو نطاقًا لازمًا يُحجب ويظهر في تقرير آمن بعدد عام وسبب تصنيفي، ولا يُحذف أو يُصلح تلقائيًا.

## خريطة الحقول

| Isar `StockMovementModel` | Snapshot المعقمة | القرار |
|---|---|---|
| `id` | `id` | إلزامي؛ `null` أو empty يحجب السجل |
| `itemId` | `itemId` | إلزامي؛ لا يُستبدل بقيمة افتراضية |
| `warehouseId` | `warehouseId` | يحافظ على null فقط إذا كان العقد يثبت معنى السجل العام؛ وإلا يحجب |
| `type.name` | `type` | يجب أن يكون enum معروفًا؛ unknown محجوب |
| `quantity` | `quantity` | finite وموجب في العقد الحالي |
| `unitCost` | `unitCost` | finite وغير سالب |
| `date` | `date` | UTC صريح؛ non-UTC محجوب قبل التطبيع |
| `referenceId` | `referenceId` | يحافظ على null فقط إذا كان العقد يسمح به؛ التحويل الثنائي يحتاج reference مشتركًا |
| `description` | `description` | يستبدل بقيمة عامة غير قابلة للربط أو يحذف بقرار موثق؛ لا تُنقل نصوص شخصية |
| `userId` | `userId` | يعقم مع الحفاظ على scope الداخلي؛ null يحتاج قرار anonymous scope |
| `syncStatus.name` | `syncStatus` | يجب أن يطابق enum المعتمد |
| `createdAt` | `createdAt` | UTC صريح؛ لا يستخدم بدل `date` في derived balance |

## الفجوات الحالية

نموذج Isar يسمح حاليًا بأن تكون `id` و`referenceId` و`userId` و`warehouseId` nullable بدرجات مختلفة، بينما clean snapshot يتطلب هوية ونطاقًا يمكن مقارنتهما بأمان. لذلك لا يجوز بناء snapshot واقعية بمجرد استدعاء `toJson` أو تمرير القيم null إلى catalog الحالي. يلزم قبل ذلك قرار مكتوب لمعنى السجل العام (`warehouseId = null`) وanonymous scope (`userId = null`) وغياب المرجع.

كما أن `StockMovementGoldenFixture` يتطلب `expectedBalances` و`expectedReferenceCounts`. لا يجوز اشتقاق القيم المتوقعة من نفس replay المستخدم للتحقق، لأن ذلك يخلق تطابقًا دائريًا. يجب أن تأتي الأرصدة المتوقعة من قراءة مرجعية مستقلة من Isar أو من تقرير يراجعه شخص، مع إبقاء التفاصيل الحساسة خارج artifacts.

## شروط الحظر

يُحجب السجل أو snapshot عند غياب id أو item scope، أو وجود enum غير معروف، أو quantity غير finite أو غير موجبة، أو unit cost سالب، أو تاريخ غير UTC، أو duplicate scoped key، أو transfer منفرد، أو adjustment سالب غير معتمد. لا يُسمح بالتطبيع أو الإسقاط الصامت لهذه الحالات.

تُحجب snapshot كاملة أيضًا إذا لم يمكن إثبات أن التعقيم حافظ على العلاقات الداخلية بين item وwarehouse وreference وuser، أو إذا احتوت على secret pattern أو connection URL أو نصوص شخصية غير لازمة، أو إذا لم يمكن تحديد مصدر `expectedBalances` بطريقة مستقلة.

## مسار التصدير المقترح لاحقًا

عند توفر موافقة مالك البيانات ونسخة offline، يُقرأ المصدر عبر قارئ محايد مثل `IsarStockMovementMigrationSource` دون أي كتابة. ثم تُحوّل السجلات إلى DTO وسيط خارج Git، وتُعقّم المعرفات مع الحفاظ على العلاقات، وتُجرى preflight على الملف النهائي، ويُنشأ expected balance report مستقل. بعد ذلك فقط يُشغّل runner على SQLite in-memory.

المخرجات المقبولة هي counters وأسباب عامة فقط. لا تُحفظ النسخة الأصلية أو snapshot النهائية في المستودع أو CI، ولا تُرسل إلى خدمة خارجية، ولا يُستدل من التقرير على هوية المستخدم أو العنصر أو المستودع.

## الوضع الحالي

لا يوجد exporter واقعي منفذ ولا snapshot واقعية معقمة مقدمة. الموجود هو importer محايد وpreflight وgolden runner. لذلك تبقى parity الواقعية محجوبة، وتستمر Isar كمصدر التنفيذ، ولا يوجد إذن لـDrift writes أو shadow-read مفعّل أو canary أو cutover.
