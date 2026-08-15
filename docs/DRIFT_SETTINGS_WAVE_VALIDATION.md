# تحقق موجة Drift الثانية: Profile وBusinessSettings

## النطاق

تضيف هذه الموجة جداول Drift وDAOs ومكيّفات تجريبية لـ`Profile` و`BusinessSettings`. لا تغيّر أي Provider في التطبيق، ولا تفتح قاعدة Drift عبر واجهة المستخدم، ولا تستورد بيانات Isar، ولا تعدّل مخزن Isar. لذلك يظل Isar مصدر القراءة والكتابة الفعلي لكلا العقدين.

## المخطط والملكية

ترفع الحزمة `schemaVersion` من 2 إلى 3. جدولَا `profiles` و`business_settings` يحتفظان بكل حقول العقد اللازمة للمزامنة الحالية: `id` و`userId` و`syncStatus` و`serverUpdatedAt` و`isDeleted`، إلى جانب حقول المجال الخاصة بكل كيان.

| الجدول | مفتاح الصف | قاعدة الملكية | نتيجة الحفظ اللاحق |
|---|---|---|---|
| `profiles` | `scopeKey` | سجل واحد لكل `userId` أو نطاق مجهول | upsert يستبدل ملف المستخدم نفسه |
| `business_settings` | `scopeKey` | إعدادات واحدة لكل `userId` أو نطاق مجهول | upsert يستبدل إعدادات المستخدم نفسها |

يُشتق `scopeKey` من المستخدم بصيغة مختلفة للحالة المجهولة (`anonymous`) وللمستخدم النصي (`user:<id>`). يمنع ذلك تداخل مستخدم يملك قيمة `userId = anonymous` مع السجل المجهول. لا يرسل هذا المفتاح إلى Supabase ولا يمثل هوية سحابية.

## التوافق مع السلوك الحالي

يفرض مكيّفا التطبيق `DriftProfileRepository` و`DriftBusinessSettingsRepository` قيمة `userId` التي يحقنها repository، تمامًا كما يفعل تنفيذ Isar الحالي. يحتفظان بقيم `SyncStatus` وبالحذف الناعم؛ ويقدم مكيّف Profile حذفًا مقيدًا بالنطاق. لا تسجل المكيّفات في Riverpod في هذه الموجة.

## التحقق المنفذ

| المجال | التحقق |
|---|---|
| schema | توليد `build_runner` ناجح لمخطط الإصدار 3 |
| DAO | اختبارات SQLite في الذاكرة لعزل المستخدم، الاستبدال، حذف Profile، metadata والحذف الناعم |
| مكيّفات التطبيق | اختبارات فرض `userId` والتحويل ذهابًا وإيابًا لحقول المزامنة والإعدادات |
| الجودة | التحليل الساكن المستهدف بلا ملاحظات وفحص diff بلا أخطاء مسافات |

## ما لا تغطيه هذه الموجة

لا يوجد importer من Isar لهذه الشريحة بعد، ولا checkpoint أو parity على لقطة بيانات حقيقية، ولا outbox أو مزامنة Supabase، ولا shadow-read/canary/cutover. يجب تنفيذ import وparity ثم telemetry قبل تسجيل أي مكيّف Drift في Providers، وبعد ذلك فقط يمكن تقييم `driftPrimary` لكل عقد بصورة منفصلة.
