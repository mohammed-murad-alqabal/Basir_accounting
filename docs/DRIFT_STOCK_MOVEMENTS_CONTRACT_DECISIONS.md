# قرارات عقد StockMovements

## الغرض

تثبت هذه الوثيقة القرارات الدنيا اللازمة قبل إعلان parity لحركات المخزون أو تفعيل shadow-read. لا تغيّر هذه المرحلة مصدر التنفيذ؛ **Isar يبقى مصدر القراءة والكتابة الفعلي**، بينما تبقى Drift وأدوات importer/parity تشخيصية ومعزولة.

## القرار الأول: `asOfDate`

أصبح `asOfDate` معلنًا في عقد `StockMovementRepository.getMovementsForItem` كوسيط اختياري. الحد الزمني شامل، ويُقارن بحقل `date` الخاص بالحركة بعد تحويله إلى UTC، وليس بحقل `createdAt`. يظل `getStockLevel` محتفظًا بوسيطه الحالي، وتبقى هذه الإضافة source-compatible لأن الوسيط named وoptional.

يجب أن تستخدم implementations ترتيبًا حتميًا `date ASC ثم id ASC` عند replay، حتى لا تعتمد النتيجة على ترتيب قاعدة البيانات الطبيعي. ويجب أن تغطي اختبارات العقد الحالة التي يساوي فيها تاريخ الحركة الحد الزمني.

## القرار الثاني: `adjustment`

كيان domain يصف `quantity` بأنها موجبة وأن النوع يحدد الاتجاه، بينما implementation الحالي يحتوي تعليقًا متعارضًا يسمح ضمنيًا بتفسير signed adjustment. لذلك تعتمد بوابات Drift الحالية **positive adjustment فقط**؛ تُحجب الكمية الصفرية أو السالبة قبل الاستيراد أو حساب الرصيد، ولا تُفسر بصمت.

اعتماد negative adjustment مستقبلًا يتطلب تعديلًا صريحًا في domain contract، وتحديد ما إذا كان الاتجاه في `quantity` أو في حقل direction مستقل، ثم تحديث Isar وDrift وgolden fixtures والـparity معًا.

## القرار الثالث: `transfer`

خدمة `InventoryService` تنفذ التحويل كحركتين ذريتين: `outbound` في المستودع المصدر و`inbound` في المستودع الوجهة، بالـ`referenceId` نفسه. لذلك لا تُستخدم حركة `transfer` منفردة لحساب الرصيد، وتُحفظ فقط إن ظهرت في بيانات legacy لغرض الرصد والحجب.

الـparity النظيفة تتطلب عدم وجود صف standalone من النوع `transfer`. وأي بيانات legacy تحتويه تُصدر `blocked` ولا تُكتب إلى Drift في importer الآمن، ولا تُصلح أو تعيد تصنيفها تلقائيًا.

## حدود هذه المرحلة

لا تغيّر هذه الوثيقة `StockMovementRepositoryImpl` الحساب الحالي؛ إذ إن الحساب الحالي يحتوي فروعًا legacy غير محسومة لـ`transfer` و`adjustment`. التغيير البرمجي المحلي في هذه المرحلة هو إعلان `asOfDate` في واجهة القراءة فقط، مع اختبارات مستقلة للموجات المعزولة. لا توجد تغييرات في Providers أو `sync_service` أو Isar schemas أو rollout flags.

## بوابات ما قبل parity الفعلية

| البوابة | شرط النجاح |
|---|---|
| `asOfDate` | معلن في العقد، شامل، ويستخدم `date` بعد UTC canonicalization |
| `adjustment` | positive فقط حتى اعتماد signed contract مكتوب |
| `transfer` | dual-entry `outbound + inbound` فقط؛ standalone محجوب |
| المصدر | Isar فقط، دون mutation أو repair تلقائي |
| التحقق | golden replay وSQLite parity ناجحان مع تقارير privacy-safe |
| التفعيل | ممنوع shadow-read أو canary قبل مراجعة بشرية وتقرير parity فعلي نظيف |

## الحالة

هذه الوثيقة والتعديل على عقد `getMovementsForItem` محليان على فرع `work/stock-movements-contract-fix-20260817`. لم يُنفذ commit أو push أو merge لهذه المرحلة.
