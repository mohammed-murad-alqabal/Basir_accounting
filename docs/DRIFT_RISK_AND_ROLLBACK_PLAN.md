# سجل مخاطر Drift وخطة التراجع

**حالة التنفيذ:** محلي فقط. لا commit ولا push ولا provider switch ولا حذف لـIsar.

## سجل المخاطر

| المعرف | الخطر | الاحتمال | الأثر | المعالجة والبوابة |
|---|---|---:|---:|---|
| R1 | تعارض `drift_dev` مع Freezed/Mockito/Isar generator | متوسط | عالٍ | اختيار Drift `2.26` المتوافق مع Dart 3.5 وsource_gen <3؛ يلزم `flutter pub get` نظيف قبل commit |
| R2 | فشل توليد Drift أو تعارض ملفات `.g.dart` | متوسط | متوسط | تشغيل build_runner على فرع Spike فقط ومراجعة diff للملفات المولدة قبل إدراجها |
| R3 | فقد أو تحريف بيانات عند ترحيل Isar | منخفض مع الضوابط | حرج | export بإصدار، batches transactional، hashes/counts ومجاميع، واحتفاظ Isar دون حذف |
| R4 | ازدواج مزامنة أو retry يكرر العملية | متوسط | حرج | operation UUID فريد وسجل idempotency في PostgreSQL/RPC؛ لا upsert عام للقيود |
| R5 | LWW يمحو تعديلًا محاسبيًا | متوسط | حرج | لا LWW للقيود المنشورة؛ conflict workflow أو قيد عكسي فقط |
| R6 | Web يعمل على مخزن غير آمن أو in-memory | متوسط | عالٍ | فحص `WasmDatabaseResult`، تحذير/حجب العمليات الحرجة، مصفوفة متصفحات واختبار تعدد التبويبات |
| R7 | WASM أو worker غير متوافقين مع Drift lock | متوسط | عالٍ | تنزيل الملفين من release مطابق للنسخة المقفلة، فحص checksum/HTTP content type وبناء Web في CI |
| R8 | COOP/COEP يكسر Google Sign-In أو popups | متوسط | متوسط | لا تفعيل في Spike؛ اختبار صريح قبل التفعيل مع fallback موثق |
| R9 | مسار Drift لا يحافظ على قيود Supabase/RLS | متوسط | حرج | RLS، indexes، RPCs ودوال posting مراجعة قبل S2/S5؛ لا service-role في التطبيق |
| R10 | انتقال مبكر لواجهة التطبيق | منخفض | عالٍ | لا تغيير لـRiverpod provider حتى ينجح adapter وmigration وdual-run |
| R11 | الاعتماد على PR #52 Draft كقاعدة | متوسط | متوسط | لا فتح PR للـSpike قبل استقرار #52 أو إعادة تأسيس الفرع على main المعتمد |
| R12 | غياب Flutter/Dart من sandbox الحالي | مؤكد | متوسط | لا ادعاء بنجاح runtime؛ تنفيذ بوابات SDK في CI/بيئة Flutter قبل أي نشر |

## بوابات القبول المتسلسلة

| البوابة | مطلوب قبل الانتقال | حالة Spike الحالية |
|---|---|---|
| G0: سلامة Git | فرع محلي نظيف وبداية معروفة وعدم وجود force/rewrite | مكتمل؛ الفرع مبني فوق PR #52 |
| G1: حل التبعيات | `flutter pub get` ناجح وlock diff مراجع | معلق: SDK غير متاح |
| G2: التوليد | `dart run build_runner build` ناجح والـgenerated diff مراجع | معلق: SDK غير متاح |
| G3: الوحدة | اختبار Drift adapter واختبارات migrations ناجحة | معلق: يعتمد G2 |
| G4: المنصات المحلية | Android/iOS/Desktop يفتحون قاعدة ويجتازون smoke tests | معلق |
| G5: Web | WASM/worker صحيحان و`flutter build web` وتشغيل المتصفح ناجحان | معلق؛ assets غير مضافة |
| G6: التكافؤ | Isar/Drift samples متطابقة وmigration resume مثبت | لم يبدأ |
| G7: المزامنة | RLS/RPC/idempotency/conflict tests ناجحة | لم يبدأ |
| G8: قطع Feature | مراقبة dual-run وموافقة بشرية ومسار restore مجرب | ممنوع قبل G0–G7 |

## بروتوكول التراجع

1. يظل Isar هو provider الفعال في كل مراحل Spike وS0؛ لذلك فشل Drift لا يؤثر في المستخدمين.
2. بعد بدء dual-read أو dual-write، يمر اختيار التنفيذ عبر feature flag لكل feature، ويعاد إلى Isar دون تغيير بنية Git أو حذف بيانات.
3. لا يُحذف ملف Drift عند التراجع؛ يصنّف كأثر تشخيصي ويمكن تصديره للمراجعة. لا يُحذف Isar مطلقًا داخل مسار آلي.
4. عند فشل migration batch، يعاد تشغيله من `migration_manifest` بعد إصلاح المصدر؛ لا يجرى rollback SQL عشوائي.
5. عند رفض Supabase عملية، تبقى في outbox مع error مصنف أو تتحول إلى `sync_conflict`؛ لا تحذف العملية تلقائيًا.
6. حذف تبعيات Isar أو ملفات schema أو فروع الإصلاح لا يُناقش إلا بعد إصدار مستقر ومراقبة ونسخة احتياطية مجربة وموافقة منفصلة.

## شروط عدم التقدم

يتوقف التطوير تلقائيًا عند: عدم توازن قيد، mismatch في مجموع مالي، اختيار `unsafeIndexedDb` للبيانات الحرجة، failed migration verification، فشل RLS/RPC authorization، أو أي تحليل/اختبار أحمر لم يثبت أنه مستقل عن التغيير.
