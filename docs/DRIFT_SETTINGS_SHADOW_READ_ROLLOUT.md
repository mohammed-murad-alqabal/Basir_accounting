# تشغيل Shadow-Read لموجة Profile وBusinessSettings

## التصميم

تضيف هذه المرحلة `ShadowReadProfileRepository` و`ShadowReadBusinessSettingsRepository` كـdecorators اختيارية حول مستودع Isar ومكيّف Drift. عند إغلاق flag، يعيد decorator مستودع Isar مباشرة ولا يستدعي Drift. عند فتحه، يقرأ Isar أولًا، يستدعي Drift للمقارنة التشخيصية، ثم يعيد **قيمة Isar نفسها**. جميع عمليات الحفظ والحذف تذهب إلى Isar فقط؛ لا يوجد dual-write.

| الشريحة | flag الافتراضي | المصدر المعاد للمستخدم | الكتابة |
|---|---|---|---|
| Profile | `false` | Isar | Isar فقط |
| BusinessSettings | `false` | Isar | Isar فقط |

الـflags مستقلة عن `driftRolloutStageProvider` العام، وتبقى مرحلة rollout العامة `isarPrimary`. لا تُبدّل هذه الإضافات Provider النشط في `lib/core/providers.dart`؛ وهي متاحة فقط لبناء تركيب canary لاحق بعد اعتماد منفصل.

## عقد telemetry

يسجل comparator نوع العملية والشريحة والنتيجة (`match` أو `mismatch` أو `sourceError` أو `candidateError`) ووقت UTC. لا يسجل `userId` أو payload أو fingerprint أو رسالة استثناء. فشل Drift لا يفشل قراءة المستخدم من Isar، بل يتحول إلى حدث تشخيصي من نوع `candidateError`.

## بوابة التفعيل

لا يُفتح أي flag قبل الحصول على تقرير parity نظيف من لقطة بيانات معقمة ومراجعة، وتأكيد عدم وجود نطاقات مستخدم غامضة، وتثبيت sink مراقبة مقيد بالحقول أعلاه. بعد ذلك يفتح flag لشريحة واحدة وبـsampling منخفض في بيئة canary، مع مراقبة mismatch وcandidateError، ويبقى Isar مصدر النتيجة. لا يتحول Drift إلى `driftPrimary` بناءً على shadow telemetry وحدها.

## التحقق الحالي

تثبت الاختبارات أن flag المغلق لا يستدعي المرشح، وأن flag المفتوح يستدعيه تشخيصيًا فقط، وأن mismatch لا يغير قيمة Isar، وأن عمليات الكتابة لا تصل إلى المرشح. كما نجح التحليل المستهدف بلا ملاحظات، ونجحت 22 حالة اختبار مستهدفة تشمل Providers والمقارنة والمهاجر والـparity والتكامل.
