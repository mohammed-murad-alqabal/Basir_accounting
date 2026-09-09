# خارطة تفعيل Drift عبر Providers وإكمال ترحيل Isar

## نقطة البداية

الطلب الحالي يجب أن يبقى **Draft** وأن يبقى `isarProvider` كما هو، لأن `core/providers.dart` يفتح 21 schema من Isar ويحقن المستودعات مباشرة. يوجد الآن مكيّفا Drift تجريبيان فقط لـ`BarcodeConfigRepository` و`MarketPriceRepository` ولم يُسجلا في Riverpod؛ وهذا صحيح في هذه المرحلة.

> القاعدة الحاكمة: لا يوجد تبديل عالمي من Isar إلى Drift. يفعّل كل repository منفردًا بعد اكتمال بياناته واختبار تكافؤه وموافقته الخاصة.

## طبقة Providers المقترحة

يضاف ملف مستقل `lib/core/persistence/local_storage_providers.dart` ولا يعدّل `isarProvider` في الموجة الأولى. يحتوي الملف على الوضع، وموفر قاعدة Drift، وموفر جاهزية اختباري.

```dart
enum LocalStorageMode { isarPrimary, shadowRead, driftRead, driftPrimary }

final storageModeProvider = Provider<LocalStorageMode>((ref) {
  // القيمة الافتراضية تبقى Isar حتى تكون هناك خطة قطع صريحة وموقعة.
  return LocalStorageMode.isarPrimary;
});

final driftDatabaseProvider = Provider<BasirDatabase>((ref) {
  final database = BasirDatabase();
  ref.onDispose(database.close);
  return database;
});

final driftReadinessProvider = FutureProvider<bool>((ref) async {
  final database = ref.watch(driftDatabaseProvider);
  await database.customSelect('SELECT 1').get();
  return true;
});
```

لا يبدأ التطبيق باختيار Drift بمجرد نجاح فتح القاعدة. يبقى كل provider خاص بمستودع على Isar إلى أن يصل Mode ذلك المستودع إلى `driftRead` أو `driftPrimary`.

## طريقة الحقن لكل Repository

لكل عقد مكتمل يضاف provider اختيار منفصل مع **Isar كقيمة افتراضية**. يبدأ `MarketPriceRepository` بهذا النمط فقط بعد اختبار الجاهزية:

```dart
final marketPriceStorageModeProvider = Provider<LocalStorageMode>(
  (ref) => ref.watch(storageModeProvider),
);

final marketPriceRepositoryProvider = Provider<MarketPriceRepository>((ref) {
  final mode = ref.watch(marketPriceStorageModeProvider);
  if (mode == LocalStorageMode.driftRead ||
      mode == LocalStorageMode.driftPrimary) {
    return DriftMarketPriceRepository(ref.watch(driftDatabaseProvider));
  }

  final isar = ref.watch(isarProvider.select((state) => state.value));
  if (isar == null) throw StateError('قاعدة Isar غير جاهزة');
  return MarketPriceRepositoryImpl(isar: isar);
});
```

يفضل ألا يستخدم `barcodeConfigRepositoryProvider` النمط نفسه قبل إضافة DAO البيانات الافتراضي وتأكيد التطبيق لا يعتمد على `Id` الخاص بـIsar.

## المراحل الآمنة للتفعيل

| المرحلة | القراءة | الكتابة | ظهور Drift للمستخدم | شرط الانتقال |
|---|---|---|---|---|
| A — معزول | Isar | Isar | لا | codegen واختبارات DAO ومكيّف ناجحة |
| B — Shadow read | Isar | Isar | لا | مقارنة DTO/تجزئة بين المحركين دون اختلاف |
| C — Read canary | Drift لمجموعة debug أو مستخدمين محددين | Isar | لا | telemetry بلا mismatch ضمن نافذة محددة |
| D — Dual write محدود | Isar مصدر العملية وDrift نسخة لاحقة قابلة للإصلاح | Isar ثم Drift/outbox | لا | قياس backlog = 0 وقابلية إعادة المحاولة |
| E — Drift primary | Drift | Drift + outbox إلى Supabase | نعم خلف feature flag | تدقيق بيانات ومراجعة بشرية وrollback مثبت |
| F — إزالة Isar للشريحة | Drift | Drift | نعم | فترة مراقبة ناجحة ونسخة Isar مؤرشفة |

لا تستخدم Dual write للقيود والسندات المحاسبية قبل وجود outbox ذري وidempotency في PostgreSQL. في محركات محلية منفصلة لا توجد معاملة ذرية مشتركة؛ لذلك تستخدم الشريحة الحرجة **single-primary cutover** بعد تحقق البيانات، لا write مزدوجًا صامتًا.

## مقارنة Shadow Read

ينشأ `RepositoryParityProbe` ضمن طبقة data وليس UI. عند كل قراءة Isar، ينفذ قراءة Drift مقابلة في isolate أو task غير حاجب، ثم يقارن canonical DTO بعد ترتيب القوائم وتوحيد UTC واستبعاد حقول التخزين الداخلية. يسجل فقط: `repository`, `operation`, `key`, `isarHash`, `driftHash`, `schemaVersion`, ووقت التنفيذ. لا يسجل أسماء عملاء أو قيود أو أسرار في logs.

عند mismatch: لا يغير probe واجهة المستخدم، ولا يبدل provider، ويكتب حدثًا قابلًا لإعادة المعالجة في `sync_outbox` أو سجل تشخيص منفصل. أي mismatch في بيانات مالية يوقف تقدم الموجة تلقائيًا.

## ترتيب الموجات

1. **الموجة الحالية:** BarcodeConfig وMarketPrice؛ تفعيل Shadow Read ثم read canary.
2. **موجة الإعدادات:** Profile وBusinessSettings؛ تضيف فصل المستخدم وSupabase sync contract أولًا.
3. **موجة التخطيط:** Goals وBudgets؛ تضيف اختبارات حدود التاريخ والعملات وقواعد التعديل.
4. **موجة الأطراف والأصول والمخزون:** Customers، Vendors، Assets، Warehouses، InventoryItems ثم StockMovements/Transfers.
5. **الموجة المحاسبية الحرجة:** Accounts، FinancialYears، Vouchers، Invoices، JournalEntries، Payments وReceipts.
6. **الإنهاء:** نقل كل schema غير المنقولة، تعطيل Isar تدريجيًا، ثم إزالة package وملفات النماذج المولدة فقط بعد إثبات الرجوع والأرشفة.

## ترحيل البيانات لكل موجة

1. يكتب `MigrationCheckpoint` يتضمن اسم الشريحة، schema المصدر/الهدف، cursor، count، checksum، وقت البدء والانتهاء.
2. يقرأ Isar دفعات محددة، ويحّولها إلى DTO محايد، ويكتبها إلى Drift بـupsert بحسب UUID.
3. بعد كل دفعة يقارن عدد السجلات وتجزئة canonical payload؛ لا يحدّث checkpoint عند اختلاف.
4. يعاد تشغيل العملية بأمان من checkpoint نفسه؛ upsert وUUID يمنعان التكرار.
5. لا يحذف مصدر Isar؛ يبقى read-only fallback طوال نافذة المراقبة.
6. بعد نجاح المصدر المحلي، تسجل المزامنة outbox مع idempotency key ثابت إلى Supabase؛ لا يسمح للعميل بتجاوز RLS أو تنفيذ قيود محاسبية منشورة من دون دالة PostgreSQL ذرية.

## بوابات القطع والـRollback

لا ينتقل repository إلى `driftPrimary` قبل: 100% تطابق count/hash، صفر mismatch في Shadow read، اختبارات DAO والمكيّف، تحليل بلا أخطاء أو تحذيرات، بناء المنصات المستهدفة، اختبار upgrade من schema السابق، وتأكيد نسخة Isar احتياطية قابلة للقراءة.

يكون الـrollback **Provider-only** ما دامت الكتابة الأساسية Isar. بعد Drift-primary، يوقف feature flag القراءة من Drift، يعيد Isar إلى read-only fallback إن كانت البيانات متطابقة، ويحتفظ بالـoutbox للمراجعة؛ لا يحذف قاعدة Drift أو Isar آليًا.

## ما يسبق إزالة Isar النهائية

يجب أولًا حل بناء Web الحالي، توفير أصول `sqlite3.wasm` و`drift_worker.dart.js` المتوافقة، ترحيل كل الـ21 schema، تحويل `core/providers.dart` إلى composition root لا يستورد موديلات Isar، إعادة كتابة backup/restore بصيغة Drift، نجاح اختبارات الترحيل على نسخ واقعية معقمة، وموافقة بشرية على تقرير الإزالة. عندها فقط يصبح حذف Isar وتبعياته وملفاته المولدة عملية مستقلة قابلة للمراجعة والرجوع.
