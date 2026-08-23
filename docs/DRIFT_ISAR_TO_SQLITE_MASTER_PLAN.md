# خطة العمل الرئيسية لاستبدال Isar بـ Drift + SQLite/WASM

## 1. الهدف والنطاق

تهدف هذه الخطة إلى نقل طبقة التخزين المحلية في Basir Accounting تدريجيًا من Isar إلى Drift مع SQLite/WASM، مع الحفاظ على السلوك المحاسبي، عزل المستخدمين والمستودعات، سلامة المزامنة، التوافق متعدد المنصات، وإمكانية الرجوع إلى Isar في كل مرحلة.

لا تعتبر الخطة Isar قديمًا أو قابلًا للحذف الآن. القاعدة الحاكمة هي:

> **Isar يبقى مصدر التنفيذ الفعلي حتى اكتمال جميع بوابات القبول، وتبقى Drift تشخيصية أو خلفية حتى اعتماد cutover صريح وقابل للرجوع.**

تشمل الخطة تطبيق Flutter، الحزمة المعزولة `basir_drift_storage`، التخزين على Android وiOS وWindows وmacOS وLinux والويب عبر SQLite/WASM، Providers وRiverpod، المزامنة مع Supabase، العقود المحاسبية، بيانات المخزون، الفوترة، واختبارات backup/restore.

## 2. الحالة الحالية المثبتة

| المجال | الحالة الحالية |
|---|---|
| Drift package | موجودة ومعزولة، مع اتصال SQLite متعدد المنصات وschema تدريجي |
| مصدر التنفيذ | Isar؛ لم يتم نقل القراءة أو الكتابة النشطة إلى Drift |
| schema Drift | وصلت محليًا إلى v8 بعد Warehouses وInventoryItems وStockMovements |
| Customers/Vendors | storage وimporter وparity وsnapshot وshadow-read تشخيصي خلف flags مغلقة |
| Warehouses | `WarehouseStore` واختبارات scope وCRUD موجودة |
| InventoryItems | `InventoryItemStore` وحقول محاسبية وsoft-delete وsearch موجودة؛ barcode ما يزال بوابة قرار |
| StockMovements | storage وreplay وgolden fixtures وimporter وparity وsnapshot runner موجودة؛ transfer وnegative adjustment محجوبان |
| PRs | #147 و#148 و#149 و#156 و#159 و#160 و#163 مفتوحة Draft وفق آخر حالة معروفة؛ لا دمج حتى الآن |
| الإنتاج | لا توجد كتابة Drift إنتاجية، ولا canary، ولا cutover |
| الأمان | رمز GitHub المكشوف سابقًا يجب تدويره، وإصلاح workflow الذي يحتاج صلاحية `workflow` ما يزال بندًا مستقلًا؛ بوابة الأمان المحلية نجحت بعد إصلاحات harness/sanitizer/.gitignore |

## 3. مبادئ غير قابلة للتفاوض

1. لا حذف، ولا force push، ولا إعادة كتابة للتاريخ، ولا دمج تلقائي.
2. كل push يحتاج موافقة صريحة مستقلة، وكل فتح أو تعديل PR يحتاج موافقة صريحة مستقلة.
3. لا تتغير نتيجة التطبيق النشطة أثناء shadow-read؛ النتيجة المعادة تبقى من Isar.
4. لا تُكتب Drift في الإنتاج قبل clean parity على نسخة معقمة، ومراجعة بشرية، وخطة rollback مجربة.
5. لا تُصلح بيانات المصدر تلقائيًا عند وجود mismatch أو duplicate أو enum غير معروف.
6. كل migration تكون additive وقابلة لإعادة التشغيل، وكل batch لها checkpoint واضح.
7. لا يُحذف Isar أو generated code أو dependency قبل نجاح backup/restore وعمليات التشغيل الفعلية لفترة مراقبة متفق عليها.
8. لا يُعتبر تطابق العدد وحده parity؛ يجب مقارنة الهوية والنطاق والحقول المحاسبية والمجاميع المشتقة والمزامنة.

## 4. المرحلة الأولى: تثبيت خط الأساس وحوكمة الفروع والـPRs

### الأعمال

يُنشأ سجل مركزي للفروع والـPRs والـcommits والعلاقات بينها. تُحفظ نقاط رجوع محلية لكل طبقة، وتُثبت قواعد PR إلى قاعدة واضحة، ويُمنع خلط storage مع importer أو contract-fix أو shadow-read في PR واحدة ما لم يكن الاعتماد ضروريًا ومعلنًا.

يجب تثبيت الفروع التي تمثل الطبقات الحالية: storage، golden fixtures، importer/parity، contract، ثم مراجعة ما إذا كانت فروع القاعدة الاصطناعية مثل `work/stock-movements-storage-base-20260817` ستبقى حتى نهاية المراجعة أو تُؤرشف بعد الدمج. لا تُحذف أي منها قبل إثبات عدم وجود commits فريدة خارج PRs.

### مخرج المرحلة

وثيقة branch/PR ledger، خريطة dependencies، وقرار واضح لقاعدة الدمج لكل PR. نجاح هذه المرحلة شرط قبل بدء أي cutover.

## 5. المرحلة الثانية: الأمان وCI/CD

### الأعمال

يجب تدوير رمز GitHub الذي ظهر في المحادثة، ثم التحقق من عدم وجوده في history أو ملفات العمل أو سجلات CI. لا يُستخدم الرمز المكشوف مرة أخرى.

يُعالج `auto_assign.yml` عبر رمز جديد يملك صلاحيات workflow المناسبة، مع اختبار workflow على PR تجريبية. كما تُثبت أوامر Flutter/Dart وbuild_runner وDrift code generation في CI، ويُضاف check يمنع generated drift files غير المتزامنة، وcheck لتشغيل parity fixtures، وcheck يمنع تفعيل rollout flags افتراضيًا.

### بوابة القبول

لا توجد أسرار مكشوفة، workflows الأساسية خضراء، generated sources قابلة لإعادة التوليد، وCI يثبت أن Isar ما يزال active primary وأن flags Drift مغلقة.

**حالة التنفيذ المحلية (2026-08-23):** اجتازت بوابة الأمان المحلية 3 مجموعات و77 حالة فرعية بنسبة نجاح 100%، مع فحص Bash syntax، وتنظيف PEM غير المكتمل، واختبارات البريد والهواتف وعناوين IP والبطاقات، وتغطية `.gitignore`. لا تُعد هذه النتيجة بديلًا عن تدوير رمز GitHub المكشوف أو التحقق من CI البعيد؛ فهما ما يزالان مطلوبين قبل أي push أو تفعيل صلاحيات workflow.

## 6. المرحلة الثالثة: عقد التخزين والمفاتيح والمزامنة

### القرارات المطلوبة

يُعتمد مفتاح مركب منطقي من `scopeKey + uuid` بدل unique UUID عالمي، مع تعريف دقيق لـ`scopeKey` لكل user وwarehouse. يجب تحديد ما إذا كان `warehouseId = null` سجلًا عامًا أم قيمة غير معروفة، وكيف يتفاعل مع القراءة الخاصة بمستودع.

تُثبت سياسة UTC، canonical enum names، nullability، soft-delete، hard-delete، timestamps، وLWW metadata. لا يجوز أن يؤدي اختلاف SQLite/WASM في collation أو floating-point أو ترتيب الصفوف إلى اختلاف parity.

### المزامنة

تُفصل عملية نقل التخزين عن تغيير sync behavior. في البداية تُحفظ `syncStatus` وserver timestamps كما هي، ويُؤجل تفعيل outbox أو إعادة تصميم LWW إلى موجة مستقلة. أي duplicate أو conflict يُصدر تقريرًا ولا يُحل تلقائيًا.

### بوابة القبول

يُعتمد storage contract لكل جدول، وتوجد اختبارات scope وUTC وenum وreplay، ويُثبت أن database connection يعمل على VM وFlutter والويب دون ربط التطبيق بمسار كتابة Drift.

## 7. المرحلة الرابعة: إكمال البيانات المرجعية والتهيئة

تُستكمل أو تُراجع موجات LocalMetadata وBarcodeConfigs وMarketPrices وProfiles وBusinessSettings وGoals وBudgets وCustomers وVendors. لكل كيان يجب توفير schema، record، DAO/store، importer، parity، snapshot، اختبارات، وقرار soft-delete.

يجب فصل barcode كقرار مستقل: إذا كان domain يملكه وIsar لا يحفظه، فلا يجوز ادعاء parity كاملة قبل تحديد مصدر الحقيقة أو تنفيذ migration صريحة. لا تُملأ قيم افتراضية تخفي الفقد.

### بوابة القبول

لكل كيان clean snapshot معقم، raw parity نظيفة، وderived parity إن كانت له مجاميع أو علاقات. تبقى providers النشطة على Isar.

## 8. المرحلة الخامسة: إكمال Inventory وStockMovements

### InventoryItems

تُستكمل parity على snapshot حقيقية معقمة، وتُحسم barcode، وُتختبر الحقول المحاسبية `assetAccountId` و`cogsAccountId` و`revenueAccountId` و`primaryAccountId`، والأسعار والكميات والـtax category، مع الحفاظ على soft-delete وlookup semantics الحالية.

### Warehouses

تُثبت parity لعزل user وhard-delete والسجل العام أو الخاص، ثم تُضاف snapshot وshadow-read تشخيصية إذا كانت مفيدة، مع عدم تغيير النتيجة النشطة.

### StockMovements

يُعتمد `asOfDate` الشامل على `date` بعد UTC، ويُحسم positive/negative adjustment. التحويل الرسمي هو dual-entry: `outbound` في المصدر و`inbound` في الوجهة بالـreference نفسه. standalone `transfer` يبقى blocked ولا يعاد تصنيفه تلقائيًا.

تُشغل golden fixtures، replay، storage parity، importer checkpoints، ثم snapshot runner على نسخة معقمة. لا تُنفذ parity فعلية قبل اعتماد contract بشري.

### بوابة القبول

لا توجد raw أو derived mismatches، لا duplicate scoped keys، كل balances تتطابق عبر as-of boundaries، ولا يمر standalone transfer أو adjustment غير معتمد.

## 9. المرحلة السادسة: الكيانات المحاسبية الحرجة

هذه المرحلة الأعلى خطورة لأنها تؤثر في ledger والتقارير والضرائب. يُنقل كل كيان في PR مستقلة أو طبقة واضحة: Accounts، FinancialYears، Vouchers، JournalEntries، ثم balances وposting links.

### لكل كيان

يُحدد مصدر الحقيقة، ويُحفظ ترتيب القيد، وتُقارن debit/credit والمجاميع والأرصدة وperiod boundaries، وتُختبر idempotency وduplicate posting وvoid/reversal وcurrency precision. يجب إنشاء golden fixtures لحالات القيد العادي، القيد العكسي، الفترة المغلقة، والفشل الجزئي.

### بوابة القبول

تطابق trial balance وledger totals والتقارير المحاسبية على snapshots معقمة، مع فشل مغلق عند أي فرق في debit/credit أو period scope.

## 10. المرحلة السابعة: الفوترة والامتثال والمزامنة

تُرحّل Invoices وInvoiceItems والروابط إلى العملاء والأصناف والحسابات، ثم سجلات ZATCA وQR/hash أو أي artifacts امتثال مرتبطة بالفاتورة. لا يجوز تغيير canonical serialization أو hash أو tax totals أثناء النقل.

بعد ذلك تُراجع sync metadata وoutbox وLWW وconflict handling. تُختبر حالات offline create، retry، duplicate delivery، conflict، server pull، وreplay بعد restore. أي تغيير في المزامنة يكون PR مستقلة عن cutover التخزين.

## 11. المرحلة الثامنة: parity الشاملة واللقطات المعقمة

يُبنى orchestrator واحد يشغل snapshots لكل الجداول والعلاقات في ترتيب dependency. المخرجات العامة privacy-safe وتحتوي counts وhashes وoutcomes فقط. لا تُسجل user IDs أو business payload أو tokens.

### مستويات parity

| المستوى | ما يثبت |
|---|---|
| Schema parity | الجداول والأعمدة والـnullability والفهارس موجودة |
| Identity parity | نفس عدد السجلات ومفاتيح scope/UUID دون duplicates |
| Field parity | تطابق الحقول النصية والمالية والتواريخ والـenums |
| Relation parity | تطابق العلاقات والروابط المفقودة |
| Derived parity | تطابق الأرصدة والمجاميع والتقارير والحسابات المشتقة |
| Operational parity | checkpoint، retry، idempotency، backup/restore، وperformance |

أي mismatch يوقف المرحلة ويحتاج triage وتصنيفًا: source defect، mapping defect، precision defect، ordering defect، أو contract defect.

## 12. المرحلة التاسعة: shadow-read والمراقبة

يُضاف decorator لكل repository موجةً بعد موجة. عند flag مغلق لا يُستدعى Drift إطلاقًا. عند flag مفتوح، تُقرأ Isar وتُقرأ Drift تشخيصيًا، وتُعاد نتيجة Isar دائمًا، ويُسجل slice وoperation وoutcome والوقت فقط.

تُحدد نافذة مراقبة ومؤشرات: mismatch rate، latency، blocked records، duplicate keys، query error rate، وmemory footprint. لا يُسمح بإخفاء mismatch أو تخفيفه عبر threshold غير موثق.

### بوابة القبول

صفر mismatches غير مفسرة في golden وsanitized snapshots، وmismatch rate فعلي ضمن حد معتمد، وعدم وجود أثر وظيفي أو تسريب خصوصية.

## 13. المرحلة العاشرة: canary وdual-write القابل للرجوع

يبدأ canary داخليًا أو بنسبة صغيرة محددة، مع feature flag kill switch. في أول تشغيل، تكون الكتابة إلى Isar هي المرجع، ويمكن تسجيل Drift shadow أو dual-write فقط إذا كان فشل Drift لا يفشل العملية الأساسية ولا يغير النتيجة.

يجب أن تكون كل كتابة idempotent، وأن يحمل كل record migration/version marker، وأن تُسجل أخطاء Drift في telemetry privacy-safe. يجب اختبار rollback أثناء عملية كتابة، وبعد restart، وبعد انقطاع الشبكة، وبعد conflict.

### شروط الإيقاف

أي mismatch محاسبي، فقد سجل، duplicate posting، اختلاف في balance، فشل restore، أو ارتفاع غير مقبول في latency يوقف canary ويعيد flags إلى الوضع المغلق.

## 14. المرحلة الحادية عشرة: نقل Providers والمسار النشط

بعد نجاح shadow-read وcanary، تُنقل providers والمستودعات موجةً موجة إلى Drift primary. يجب أن يظل rollback إلى Isar ممكنًا من خلال flag أو release configuration، دون migration عكسي مدمّر.

يُحدث `core/providers.dart` وproviders persistence النشطة فقط بعد اعتماد موجة مستقلة. تُراجع خدمات `InventoryService` وvaluation وinvoice posting وsync للتأكد من أنها تستخدم العقود نفسها ولا تعتمد على Isar-specific behavior.

### بوابة القبول

كل العمليات الأساسية تعمل على Drift في بيئة staging، وتطابق التقارير المحاسبية، وbackup/restore ناجحان، وrollback مجرب، ولا توجد كتابة مزدوجة غير مقصودة.

## 15. المرحلة الثانية عشرة: إيقاف Isar وإزالته

لا تبدأ هذه المرحلة إلا بعد فترة مراقبة متفق عليها ونجاح release أو أكثر على Drift primary. يُغلق مسار Isar تدريجيًا بدل حذفه دفعة واحدة.

### الترتيب

1. تعطيل Isar writes مع إبقاء read-only fallback مؤقتًا.
2. تأكيد عدم وجود قراءات Isar نشطة عبر telemetry وstatic search.
3. حفظ backup نهائي وexport قابل للاسترجاع قبل إزالة dependency.
4. إزالة repositories وProviders وservices التي تعتمد على Isar.
5. إزالة Isar models وgenerated files وschema registrations.
6. إزالة dependency وتهيئة Isar native/web وأي build hooks.
7. تشغيل build وtest matrix لكل المنصات.
8. إبقاء migration/archive documentation وعدم حذف backups أو التاريخ.

### rollback

إذا ظهر خلل بعد الإزالة، لا يُعاد حذف أو force push؛ تُستخدم release سابقة أو branch محفوظة، ويُعاد تفعيل read-only/backup path وفق خطة تشغيل منفصلة. لا تُحذف artifacts القديمة حتى انقضاء فترة الاحتفاظ المعتمدة.

## 16. المرحلة الثالثة عشرة: التسليم النهائي

يُسلّم تقرير قبول نهائي يتضمن قائمة الكيانات، commits وPRs، نتيجة كل parity، نتائج الأداء، backup/restore، مصفوفة المنصات، سجل المخاطر، خطة rollback، وتاريخ إيقاف Isar.

### معايير الإكمال النهائي

| المعيار | شرط الإكمال |
|---|---|
| التغطية | كل Isar collections لها بديل Drift أو قرار موثق |
| correctness | لا mismatches غير مفسرة في الحقول أو المجاميع أو التقارير |
| accounting | trial balance وledger وtax totals متطابقة |
| sync | offline/retry/conflict/restore ناجحة |
| platforms | Android وiOS وdesktop والويب مجتازة |
| operations | backup، restore، migration، retry، rollback موثقة ومجربة |
| security | لا أسرار أو payloads في telemetry أو fixtures |
| governance | كل merge وpush وPR خضع للموافقة المطلوبة |
| Isar removal | لا dependency أو provider أو generated runtime path متبقٍ بعد الاعتماد |

## 17. ترتيب التنفيذ الفوري المقترح

1. مراجعة PRs الحالية وتثبيت قاعدة كل طبقة دون merge تلقائي.
2. تدوير رمز GitHub المكشوف وإصلاح CI workflow بصلاحية صحيحة.
3. اعتماد contract-fix لـStockMovements ومراجعة PR #163.
4. تشغيل snapshot runner على fixtures ثم إعداد آلية snapshot معقمة من Isar، دون payload.
5. استكمال parity لـInventoryItems وWarehouses وStockMovements على بيانات معقمة.
6. إضافة shadow-read مغلق افتراضيًا للموجات الثلاث.
7. بدء موجة Accounts ثم FinancialYears ثم Vouchers ثم JournalEntries، مع golden fixtures محاسبية.
8. ترحيل Invoices وZATCA والمزامنة بعد تثبيت ledger.
9. تشغيل parity الشاملة ثم shadow-read ثم canary.
10. نقل Providers إلى Drift primary مع rollback.
11. مراقبة release كاملة قبل تعطيل Isar.
12. إزالة Isar تدريجيًا، ثم تسليم تقرير القبول النهائي.

## 18. آلية الموافقات والتنفيذ

كل مرحلة لها مخرج قابل للمراجعة. لا يُنشأ commit محلي إلا بعد موافقة المستخدم عندما يكون ضمن نطاق المهمة المتفق عليه، ولا يُنفذ push إلا بموافقة صريحة مستقلة، ولا تُفتح أو تُعدل PR إلا بموافقة صريحة مستقلة. لا يُنفذ merge أو حذف أو force push تحت هذه الخطة دون موافقة إضافية وتقرير أثر وبديل آمن.

## المراجع الداخلية

[1]: DRIFT_INVENTORY_WAVE_DESIGN.md "Inventory wave design"
[2]: DRIFT_STOCK_MOVEMENTS_GOLDEN_FIXTURES.md "StockMovements golden fixtures"
[3]: DRIFT_STOCK_MOVEMENTS_CONTRACT_DECISIONS.md "StockMovements contract decisions"
[4]: DRIFT_STOCK_MOVEMENTS_SNAPSHOT_RUNBOOK.md "StockMovements snapshot runbook"
[5]: ../lib/core/persistence/drift_providers.dart "Drift rollout providers and flags"
[6]: ../packages/basir_drift_storage/lib/src/basir_database.dart "Drift schema and migrations"
