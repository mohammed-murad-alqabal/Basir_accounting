# ADR-DATA-001 — حدود تخزين البيانات المالية وتحويل Decimal

> **document_id:** ADR-DATA-001
> **status:** APPROVED
> **authority_level:** 2
> **owner:** Data Owner
> **approved_by:** Engineering Lead
> **effective_from:** 2026-08-13
> **last_verified_sha:** `3001138357c7aa3d12b07cb18a1537f9d6574c10`
> **review_due:** 2026-11-13
> **related_requirements:** REQ-DATA-001, REQ-DATA-002, REQ-DATA-003, REQ-ACC-008
> **supersedes:** None

## السياق

يستخدم نطاق المحاسبة `Decimal`، بينما يخزن نموذج Isar بعض القيم المالية كسلاسل ويملك PostgreSQL/SQLx ترحيلات وعقودًا مستقلة. إن عدم توثيق حد التحويل يفتح مجالًا لفقد الدقة أو اختلاف parsing أو تغير حقول sync دون عقد واضح.

## القرار

يظل `Decimal` هو النوع الحاكم داخل domain. تتحول القيم المالية إلى نص عشري قانوني عند حد Isar ثم تعاد عبر `Decimal.parse`، ولا تستخدم `double` كوسيط تخزين أو حساب في تدفقات الدفتر. تحتفظ عملية العملة غير الأساسية معًا بـ`originalCurrency` و`originalAmount` و`exchangeRate` وقيمة الأساس، ويمنع الحارس النطاقي وجود جزء من هذه المجموعة دون بقية الحقول.

يعرض PostgreSQL schema وعقود الترحيل في وثائق data منفصلة؛ لا يفترض تشابه كل حقل أو نوع بين Isar وPostgreSQL. أي migration تمس entity ماليًا تتطلب تحديث قاموس البيانات ومصفوفة mapping واختبار قاعدة نظيفة ومسار ترحيل مدعوم.

## النتائج

| القرار | الأثر |
|---|---|
| `Decimal` في domain | يحافظ على الدقة في الحساب والتوازن. |
| النص العشري في Isar | يجعل التحويل صريحًا وقابلًا للاختبار، مع ضرورة رفض النص غير الصالح. |
| مجموعة العملة الأصلية atomic | تمنع تقرير عملة أو تحويلًا مبنيًا على سياق ناقص. |
| لا schema موحد ضمني | يلزم mapping contract بدل استنتاج التطابق من أسماء الحقول. |

## المخاطر المعروفة

هذا القرار لا يثبت أن جميع ترحيلات PostgreSQL أو مزامنة الأجهزة تلتزم به بعد؛ يلزم ADR-DATA-002 وعقد مزامنة منفصل. كما أن إضافة حقل `reversesEntryId` أو idempotency key إلى التخزين تحتاج migration مصممة ومنفذة في PR مستقل.

## التحقق

تتحقق اختبارات نطاق القيد من اكتمال سياق العملة. وتضاف لاحقًا round-trip tests بين `JournalEntry` و`JournalEntryModel` وترحيلات SQL وفق REQ-DATA-002 وREQ-DATA-003 قبل إعلانها `VERIFIED`.

## المراجع

[1]: ../../02-domain/requirements/DATA_REQUIREMENTS.md "متطلبات البيانات"
[2]: ../../02-domain/requirements/ACCOUNTING_REQUIREMENTS.md "متطلبات العملات"
[3]: ../../audits/bkip-2026-08/FINDINGS_REGISTER.md "نتيجة BKIP-006"
