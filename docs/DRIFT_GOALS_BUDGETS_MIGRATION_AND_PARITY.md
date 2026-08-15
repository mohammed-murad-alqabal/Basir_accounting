# Importer وParity لموجة Goals وBudgets

## النطاق

تضيف هذه الموجة مسارًا تجريبيًا لقراءة Goals وBudgets من Isar إلى DTOs محايدة ثم كتابتها idempotently إلى Drift. Isar مصدر قراءة فقط، وDrift هدف كتابة فقط، ولا يُستدعى المهاجر تلقائيًا من التطبيق أو Providers.

## التحويل

يُحافظ importer على UUID، التصنيف، التواريخ UTC، حالة النشاط، النطاق، والقيم المالية كنصوص Decimal. تُرتب مصادر Isar حسب `scopeKey` ثم معرف الكيان لضمان ثبات الدفعات والبصمات. تُستخدم شرائح checkpoints مستقلة:

| الشريحة | المفتاح |
|---|---|
| Goals | `goals-v1` |
| Budgets | `budgets-v1` |

كل دفعة تحفظ `sourceCount` و`migratedCount`، ثم يحفظ checkpoint مكتمل بعد انتهاء الشريحة. إعادة التشغيل تستخدم upsert في Drift ولا تنشئ نسخًا إضافية.

## قواعد parity

يقارن verifier كامل سجلات المصدر والهدف بعد ترتيب deterministic. المقارنة تشمل الحقول النصية المالية دون تحويل إلى `double`، التواريخ UTC، enum names، القيم الاختيارية، والقيم المنطقية. يعلن verifier mismatch عند اختلاف العدد أو fingerprint، ويكشف السجلات الزائدة في Drift. كما يحجب التقدم عند وجود أكثر من سجل مصدر في نفس `scopeKey` لأن ذلك يدل على غموض لا يجوز علاجه بالحذف التلقائي.

لا تعرض تقارير parity السجلات أو userId؛ فهي تخرج counts وfingerprints وحالات boolean وقوائم نطاقات مبصمة فقط.

## الاختبارات

| الاختبار | النتيجة |
|---|---|
| batch/checkpoint/idempotency | ناجح |
| mismatch وسجل Drift زائد | ناجح |
| duplicate user scope | ناجح ويمنع التقدم |
| Isar مؤقت → SQLite في الذاكرة → parity | ناجح |
| بقاء بيانات Isar المصدرية | ناجح؛ السجلات المصدرية بقيت كما هي |

## بوابات الانتقال

لا تُسجل المكيّفات في Providers، ولا يُفتح shadow-read، ولا تُنفذ كتابة Drift في الإنتاج قبل تشغيل importer/parity على لقطة بيانات معقمة ومراجعة. يجب أن تكون النتيجة نظيفة، وأن تكون كل النطاقات غير غامضة، وأن يثبت rollback قابل للقراءة قبل أي canary.
