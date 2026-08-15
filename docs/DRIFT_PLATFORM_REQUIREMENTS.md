# متطلبات Drift + SQLite متعددة المنصات

**الحالة:** وثيقة تصميم للـSpike المحلي. لا تلغي Isar ولا تعيد كتابة أي بيانات.

## نطاق المنصات

| المنصة | المنفذ المستهدف | شرط القبول |
|---|---|---|
| Android وiOS | `drift_flutter` مع SQLite المضمن | فتح القاعدة، معاملات ذرية، مفاتيح خارجية، واختبارات مستودعات |
| Windows وmacOS وLinux | `drift_flutter` مع SQLite المضمن | بناء وتشغيل قاعدة محلية دون تبعيات Isar أو FFI خاصة بها |
| Flutter Web | `DriftWebOptions` مع `sqlite3.wasm` و`drift_worker.dart.js` | بناء Web وتشغيل persistence في متصفح مدعوم مع إظهار تحذير إن اختير مخزن غير موثوق |

## حقائق تصميمية

يفصل Drift بين واجهات الاستعلام النقية والمنفذ الخاص بالمنصة؛ لذلك تبقى الجداول والمستودعات مشتركة، ويتغير إنشاء `QueryExecutor` فقط [1]. تستخدم المنصات المحلية SQLite عبر FFI، بينما يستخدم Web SQLite في WebAssembly مع worker ومخزن متصفح مناسب [1][2].

يحتاج Web إلى ملفي `sqlite3.wasm` و`drift_worker.dart.js` المتوافقين مع نسخة Drift المقفلة، وإلى تقديم WASM بترويسة `Content-Type: application/wasm` [2]. قد تحسن ترويسات COOP/COEP الأداء، لكن لا تُفعّل قبل اختبار Google Sign-In والنوافذ المنبثقة لأن لها آثار توافق محتملة [2].

## قيود Basir المكتشفة

| المؤشر | النتيجة |
|---|---|
| المنصات الموجودة | Android، iOS، macOS، Windows، Linux، Web |
| تبعيات التخزين الحالية | `isar 3.1.0+1` و`isar_flutter_libs` و`isar_generator` مع `path_provider` و`supabase_flutter` |
| استيرادات Isar غير المولدة | 36 ملف تطبيق، تشمل النماذج والمستودعات وتهيئة providers |
| ملفات schema المولدة | 24 ملفًا |
| فتحة Isar المركزية | `lib/core/providers.dart` |

## قرارات ملزمة للـSpike

1. يبقى Isar في مكانه خلال الـSpike ولا تزال كل الشاشات تستخدمه؛ Drift يعمل بالتوازي في مساحة أسماء وملف قاعدة مستقلين.
2. تستخدم جميع مبالغ Drift وحدات صغرى صحيحة ولا تستخدم `double` لأي قيمة نقدية.
3. تُستخدم معرفات نصية متوافقة مع UUID لمطابقة Supabase، مع مفاتيح وفهارس صريحة.
4. تُفرض قواعد القيد المزدوج في transaction محلية، وتُعاد فرضها في PostgreSQL/Supabase عند المزامنة.
5. يُنشأ outbox مستقل لاحقًا؛ لا يُسمح بأن تجعل المزامنة الشبكية عملية حفظ محلية تفشل.
6. يحفظ Drift snapshots وtests للمخطط باستخدام `drift_dev make-migrations` قبل أول تغير موجه للمستخدم [3].

## المراجع

[1]: https://drift.simonbinder.eu/platforms/ — Supported platforms
[2]: https://drift.simonbinder.eu/platforms/web/ — Drift Web and Wasm setup
[3]: https://drift.simonbinder.eu/migrations/ — Guided migrations
