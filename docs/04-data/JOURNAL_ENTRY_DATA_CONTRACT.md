# عقد بيانات قيد اليومية

> **document_id:** DATA-LEDGER-001
> **status:** ACTIVE
> **authority_level:** 2
> **owner:** Data Owner
> **approved_by:** Engineering Lead
> **effective_from:** 2026-08-13
> **last_verified_sha:** `ad39da61ec7cc756e6d551aa356c0e1824d9ab19` — [Quality Gates 31750243155](https://github.com/mohammed-murad-alqabal/Basir_accounting/actions/runs/31750243155)
> **review_due:** 2026-10-13
> **related_requirements:** REQ-ACC-008, REQ-DATA-001, REQ-DATA-002, REQ-DATA-003
> **related_adrs:** ADR-DATA-001, ADR-ACC-001

## نطاق العقد

يصف هذا العقد ما يجب أن يبقى متسقًا بين `JournalEntry` في domain و`JournalEntryModel` في Isar وترحيلات PostgreSQL. لا يجعل العقد المخازن متطابقة، ولا يمثل موافقة على sync أو migration غير منفذ. يعد domain الحاكم للسلوك والقيم؛ تعد Isar وPostgreSQL تمثيلين تشغيليين يحتاج كل منهما اختبار round-trip وترحيل خاصًا.

## الحقول الجوهرية

| معنى المجال | Domain | Isar الحالي | قاعدة العقد |
|---|---|---|---|
| هوية القيد | `id` | `id` | UUID/معرف ثابت لا يعاد استخدامه. |
| مرجع ظاهر | `referenceNumber` | `referenceNumber` | فريد ضمن نطاق الأعمال الذي يحدده repository. |
| تاريخ الأثر | `date`, `temporal.effectiveDate` | `date`, `temporal` | لا يرحل في فترة مقفلة؛ القرار في الخدمة. |
| حالة القيد | `status` | `status` | لا يكتب أثر مرحل مخالف للـvalidator. |
| سطور القيد | `lines` | embedded `lines` | سطران أو أكثر؛ طرف واحد موجب؛ إجمالي متوازن. |
| قيم المدين/الدائن | `Decimal` | `String` | تمثيل نص عشري قانوني؛ يمنع `double` كقيمة حاكمة. |
| عملة أصلية | `originalCurrency`, `originalAmount`, `exchangeRate` | strings/nullable | العملة الأجنبية تتطلب الحقول الثلاثة موجبة؛ في العملة الأساسية يجوز غياب الرمز، لكن المبلغ والسعر يوجدان معًا أو يغيبان معًا. |
| دليل جنائي | `hash`, `previousHash`, `auditLogs` | `hash` و`previousHash` و`auditLogs` embedded | لا تعني الحقول وحدها أن السلسلة متحققة؛ يمثل `auditLogs` مسار Dart/Isar المحلي ولا يعادل `audit_log` في PostgreSQL. |
| مزامنة | `syncStatus`, `serverUpdatedAt`, `isDeleted` | حقول مطابقة تقريبًا | لا يعلن دعم sync حتى ADR-DATA-002 واختبارات التعارض. |

## قواعد التحويل

| الاتجاه | القاعدة | حالة التحقق |
|---|---|---|
| Domain → Isar | `Decimal.toString()` يكتب نصًا عشريًا بلا تقريب عبر `double`، وتطبع الأزمنة عند القراءة إلى UTC. | يغطيه `journal_entry_model_round_trip_test.dart` و[Quality Gates 31750243155](https://github.com/mohammed-murad-alqabal/Basir_accounting/actions/runs/31750243155): `1,223` نجاح، `2` تخطٍ. |
| Isar → Domain | `Decimal.parse()` يقرأ النص؛ النص غير الصالح يفشل بـ`FormatException` ولا يتحول إلى صفر. | يغطيه اختبار الحالة السلبية في round-trip. |
| Domain → PostgreSQL | يحدد migration/type الفعلي العقد؛ لا تستنتج دقة SQL من Isar. | يوثق `JOURNAL_ENTRY_STORAGE_MAPPING_REGISTER.md` الانحرافات؛ يحتاج contract DTO وترحيل تكاملي مستقل. |
| عملة غير أساسية | تسجل العملة والمبلغ والسعر وقيمة الأساس في العملية نفسها. | validator يفرض اكتمال الحقول؛ mapping test لاحق. |
| عملة أساسية | قد يغيب الرمز، لكن المبلغ الأصلي وسعره زوج موجب ومتلازم إذا خزّنا. | validator يرفض وجود أحدهما دون الآخر. |

## تغييرات schema

لا يدمج PR يعدل `JournalEntryModel` أو `rust/migrations/` من دون: ID متطلب، ADR عند تغير الحد، تحديث هذا العقد أو data dictionary، اختبار schema/round-trip مناسب، وخطة توافق أو rollback. يلزم أي حقل للعكس أو idempotency — مثل `reversesEntryId` أو `idempotencyKey` — migration مستقلة ولا يضاف بصورة ضمنية.

## الفجوات المفتوحة

1. لا يوجد بعد contract DTO معتمد بين Flutter وRust يحدد تحويل statuses والحقول الخاسرة ودقة PostgreSQL؛ السجل يصف الانحراف ولا يحله.
2. لا يوجد اختبار تكامل PostgreSQL يعيد قراءة كل حقل أو يثبت سياسة تقريب `DECIMAL(20,4)` و`DECIMAL(20,10)` من قاعدة نظيفة.
3. لا يملك نموذج القيد علاقة reversal صريحة أو idempotency key مخزنة.
4. لا توجد سياسة تعارض مزامنة معتمدة؛ يحكمها ADR-DATA-002 لاحقًا.

## المراجع

[1]: ../03-architecture/adrs/ADR-DATA-001-financial-data-boundaries.md "قرار حدود البيانات"
[2]: ../03-architecture/adrs/ADR-ACC-001-journal-entry-posting-invariants.md "قرار حمايات القيود"
[3]: ../02-domain/requirements/DATA_REQUIREMENTS.md "متطلبات البيانات"
[4]: JOURNAL_ENTRY_STORAGE_MAPPING_REGISTER.md "سجل mapping التخزيني لقيد اليومية"
