# سجل mapping التخزيني لقيد اليومية

> **document_id:** DATA-LEDGER-MAPPING-001
> **status:** DRAFT
> **authority_level:** 2
> **owner:** Data Owner
> **approved_by:** Pending formal repository owner approval
> **effective_from:** 2026-08-13
> **last_verified_sha:** `ad39da61ec7cc756e6d551aa356c0e1824d9ab19` — [Quality Gates 31750243155](https://github.com/mohammed-murad-alqabal/Basir_accounting/actions/runs/31750243155)
> **review_due:** 2026-09-13
> **related_requirements:** REQ-DATA-001, REQ-DATA-002, REQ-DATA-003, REQ-ACC-008
> **related_adrs:** ADR-DATA-001, ADR-ACC-001
> **supersedes:** None

## الغرض والحد الحاكم

يوثق هذا السجل التمثيلات الفعلية لـ`JournalEntry` في نطاق Dart وIsar وفي مسار Rust/PostgreSQL. **لا يشكل ذلك عقد مزامنة ولا يعلن أن المخزنين متطابقان.** يظل كيان Dart الحاكم لسلوك التطبيق المحلي، بينما يعد `accounting_core::ledger::JournalEntry` ومسار PostgreSQL نموذج دفتر أستاذ مستقلًا له أسماء وحقول ومراحل حياة مختلفة. لا يسمح بأي تحويل تلقائي بينهما قبل عقد DTO وإصدار ADR للمزامنة.[1] [2]

> لا يعد تشابه اسم الحقل أو قدرته على التحويل دليلًا على تكافؤ المعنى. لا يكون الحقل `CANONICAL` بين المخزنين إلا إذا حدد هذا السجل تحويله واتجاهه وخطر فقده واختباره.

## حدود النماذج

| الحد | النموذج الحاكم داخل الحد | وظيفة التخزين | حالة التكافؤ |
|---|---|---|---|
| Dart domain ↔ Isar | `JournalEntry` و`JournalEntryModel` | استمرار محلي لتدفق Flutter | يجب أن يكون round-trip محافظًا على جميع حقول Dart المحفوظة، بما فيها `Decimal` والسياق متعدد العملات وسجل التدقيق. |
| Rust core ↔ PostgreSQL | `accounting_core::ledger::JournalEntry` و`PgLedgerRepository` | دفتر أستاذ PostgreSQL وسجل تدقيق | اختبار قاعدة البيانات يقيس الحقول المصرح بها في Rust فقط؛ لا يعيد تكوين DTO Flutter كاملًا حاليًا. |
| Flutter ↔ Rust native | `EntryDto` في `accounting_native` | حد API محلي/أصلي | **جزئي وخاسر حاليًا**؛ يختزل السطر إلى `amount` و`is_debit` ويصنع أو يسقط حقولًا تشغيلية. يحتاج عقد API مستقل قبل اعتماد sync. |

## سجل الحقول

| معنى الحقل | Dart domain | Isar | Rust/PostgreSQL | سياسة التحويل والحالة |
|---|---|---|---|---|
| هوية القيد | `id` نص UUID | `id` نص مفهرس فريد | `entry_id`/`journal_entries.id` UUID | `CANONICAL` داخل كل حد؛ لا يوجد محول Flutter↔Rust معتمد بعد. |
| المرجع | `referenceNumber` | `referenceNumber` | `entry_number` | `TRANSFORMED` بالاسم؛ يثبت اختبار Isar الحفظ، ويحتاج DTO mapping صريح قبل cross-store. |
| الزمن | `date` وحقول `temporal` الثلاثة | `date` و`TemporalJustificationModel` | `transaction_date` و`effective_date` و`recording_date` | `PARTIAL`: Isar يحفظ الثلاثة؛ PostgreSQL يستعمل `DATE` لأول حقلين وقد يفقد time-of-day الدلالي. |
| حالة القيد | `draft/posted/voided` | enum Dart | `Draft/Posted/Reversed/...` | `INCOMPATIBLE`: المجموعتان لا تتطابقان واحدًا لواحد؛ لا يجرى تحويل صامت. |
| السطر والحساب | `accountId` و`accountName` | يحفظ الاثنين | UUID `account_id` فقط | `PARTIAL`: الاسم المنزوع في PostgreSQL ليس مصدر حقيقة. |
| المبالغ | `Decimal debit/credit` | strings عبر `Decimal.toString/parse` | `DECIMAL(20,4)` | `CANONICAL` نحو Isar مع round-trip دقيق؛ PostgreSQL يقيد الدقة إلى 4 منازل ولا يقبل تمثيل Dart الأوسع بلا قرار rounding مستقل. |
| العملة الأصلية | رمز ومبلغ وسعر | strings nullable | `TEXT` و`DECIMAL(20,4)`/`DECIMAL(20,10)` | `PARTIAL`: Isar يحافظ على النص؛ PostgreSQL يملك scale محددًا يجب اختباره لكل policy rounding. |
| مرجع المصدر/مركز التكلفة | `sourceDocumentRef` و`costCenterId` | محفوظان | لا أعمدة في مسار ledger المراجع | `LOCAL-ONLY`: لا يحول أو يُحذف ضمن عقد API مقبول. |
| التدقيق | `auditLogs`, `hash`, `previousHash` | hash/previousHash؛ يجب حفظ auditLogs صراحة | `audit_log` منفصل؛ header لا يحفظ `previous_hash` | `INCOMPATIBLE`: لا تساوي قائمة تدقيق Dart سلسلة PostgreSQL؛ يلزم اختبار Isar مستقل وعدم نسخها إلى Rust. |
| المنشئ والتحديث والنشر | `createdBy`, timestamps, `postedAt` | محفوظة | core يعيد defaults/placeholders في `list_entries` | `LOSSY`: لا يعرض إلى Flutter كقيمة موثوقة حتى توسعة migration/query/DTO. |
| عزل المستخدم والمستودع والمزامنة | `userId`, `warehouseId`, `syncStatus`, `serverUpdatedAt`, `isDeleted` | محفوظة | غير موجودة في ledger المراجع | `LOCAL-ONLY / PLANNED`: لا تمثل دعماً للمزامنة. |

## قواعد هذه الدفعة

تطبق هذه الدفعة اختبارات round-trip كاملة على حد **Dart domain ↔ Isar**، بما في ذلك الاعتيادي والمتعدد العملات وحقول التدقيق والحقول nullable. ويجب أن يرفض التحويل من Isar إلى domain أي نص عشري غير صالح بدل استبداله بصفر أو تقريبه.

في مسار **Rust/PostgreSQL**، تمنع هذه الدفعة تحويل JSON عددي عبر `f64` داخل قارئ ledger، لأنه وسيط لا يثبت دقة `Decimal`. يحلل القارئ النص أو الرقم كتمثيل عشري مباشرة ثم يفشل بصورة قابلة للتشخيص للقيمة غير الصالحة. لا تتوسع هذه الدفعة في migration أو sync، لأن توافق statuses والحقول الخاسرة ودقة أعمدة SQL يحتاج ADR منفصلًا وخطة migration/rollback وفق `REQ-DATA-003`.

## معايير القبول التنفيذية

| المعرّف | الدليل المطلوب لهذه الدفعة |
|---|---|
| DATA-RT-ISAR-001 | fixture شامل يتحول `JournalEntry → JournalEntryModel → JournalEntry` ويحافظ على كل حقل محفوظ و`Decimal` من دون `double`. مرّ ضمن [Quality Gates 31750243155](https://github.com/mohammed-murad-alqabal/Basir_accounting/actions/runs/31750243155). |
| DATA-RT-ISAR-002 | إدخال نص decimal معطوب في نموذج Isar يفشل ولا يتحول إلى `Decimal.zero`. مرّ ضمن الاختبار نفسه في CI. |
| DATA-PG-DEC-001 | اختبار Rust خالص يثبت أن JSON decimal النصي والعددي يتحولان إلى `rust_decimal::Decimal` بلا `f64`، وأن القيمة المعطوبة تعيد خطأ. أضيف الاختبار، لكن لم يجر محليًا بسبب cache Cargo غير مكتمل؛ لا يعد دليل PostgreSQL integration. |
| DATA-SCHEMA-BOUNDARY-001 | يثبت هذا السجل أن حقل PostgreSQL الخاسر أو غير المتوافق لا يعامل كـcanonical ولا يدّعى دعم sync. |

## خطوات مؤجلة صراحة

لا تنفذ هذه الدفعة `ADR-DATA-002` أو مزامنة سحابية أو توحيد statuses أو ترحيل قاعدة PostgreSQL. تبدأ الدفعة التالية بعد اعتماد مالك البيانات نطاق DTO الحاكم، وسياسة تقريب `DECIMAL(20,4)` و`DECIMAL(20,10)`، وخطة توافق للحقول المحلية الموجودة بالفعل في Isar.

## المراجع

[1]: [عقد بيانات قيد اليومية](JOURNAL_ENTRY_DATA_CONTRACT.md) — العقد النطاقي المعتمد.
[2]: [ADR-DATA-001](../03-architecture/adrs/ADR-DATA-001-financial-data-boundaries.md) — قرار حدود التخزين وتحويل Decimal.
[3]: [متطلبات البيانات](../02-domain/requirements/DATA_REQUIREMENTS.md) — معايير القبول ومراحل التحقق.
[4]: [مستودع PostgreSQL](../../rust/crates/accounting_data/src/db/ledger.rs) — تنفيذ ledger المراجع.
[5]: [محول Flutter–Rust](../../rust/crates/accounting_native/src/api/ledger.rs) — حد DTO الحالي.

**المؤلف:** Manus AI
