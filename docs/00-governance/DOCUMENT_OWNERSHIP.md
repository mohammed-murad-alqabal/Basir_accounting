# ملكية الوثائق والمجالات

> **document_id:** GOV-OWN-001
> **status:** ACTIVE
> **authority_level:** 1
> **owner:** Engineering Lead
> **approved_by:** Pending formal repository owner approval
> **effective_from:** 2026-08-13
> **last_verified_sha:** `ce825c55c6e9959645f6eef330a78e2bbd844c7c`
> **review_due:** 2026-11-13

## المبدأ

المالك هنا **دور مسؤول** وليس اسم شخص ثابتًا؛ يعين مالك المستودع الشخص الذي يشغل الدور. لا تصبح وثيقة حاكمة أو ادعاء امتثال أو قرار معماري نهائيًا حتى يتولى الدور المناسب اعتماده ومراجعته في الموعد المحدد.

| المجال | المالك | المراجع/المعتمد | مسؤوليات لا تقبل التفويض الصامت |
|---|---|---|---|
| نموذج السلطة والـADRs | Engineering Lead | Repository Owner | حل تعارض المصدر الحاكم، تعيين مالكي المجالات، واعتماد ADRs. |
| القواعد المحاسبية والتقارير | Accounting Domain Owner | Engineering Lead | تعريف invariants والترحيل والعكس والفترات والعملات واختبارات القبول. |
| البيانات والترحيلات والمزامنة | Data Owner | Engineering Lead | قاموس البيانات وعقود Isar/PostgreSQL وmigration compatibility. |
| المصادقة والأذونات والأسرار | Security Owner | Engineering Lead | نموذج التهديد والضوابط وخوارزميات كلمة المرور وCI security evidence. |
| ZATCA وVAT والزكاة والنطاق القانوني | Compliance Owner | Repository Owner | تصنيف محاكاة/اختبار/تكامل/اعتماد، ومنع ادعاءات الامتثال غير المثبتة. |
| التصميم والوصولية وtokens | UX Owner | Product Owner | مصدر tokens الحاكم، Semantics، وتحقق وصولية الواجهات. |
| الاستراتيجية والـroadmap وحالة المنتج | Product Owner | Engineering Lead | ترتيب المتطلبات، scope، ومصالحة خطة التنفيذ مع evidence. |
| الاختبارات والأدلة وإصدارات CI | QA Owner | Engineering Lead | acceptance criteria، evidence index، وربط SHA/Run ID. |
| الفهرسة والأرشفة والروابط | Documentation Steward | Engineering Lead | هيكل docs وmetadata والمراجع وقرارات MOVE/MERGE/ARCHIVE. |
| workflow والبوابات وحماية الفروع | DevOps Owner | Engineering Lead | إعداد checks، artifacts، branch protection، والاستثناءات المنتهية. |

## SLA المراجعة

| نوع الأصل | المراجعة الدنيا | المحفزات الإلزامية |
|---|---|---|
| Requirement أو ADR معتمد | كل 90 يومًا أو عند تغير نطاقه | تغير code path عالي الأثر، أو قرار متعارض، أو فشل acceptance evidence. |
| Security/Compliance | كل 60 يومًا أو قبل إصدار | تغير dependency أو تكامل أو نموذج مصادقة أو إعلان قانوني. |
| Data schema/mapping | مع كل migration | تغير جدول أو field أو type أو sync boundary. |
| دليل تشغيل/runbook | كل 180 يومًا أو بعد incident | فشل استرجاع أو نشر أو مراقبة. |
| تقرير حالة | مؤرخ ويؤرشف خلال 90 يومًا | ظهور SHA أحدث أو تقرير لاحق. |

## الاستثناءات

يجوز استثناء PR منخفض الأثر من REQ/ADR linkage فقط عبر قسم واضح في قالب PR: السبب، owner، وتاريخ انتهاء. لا يستثنى أي تغيير في `lib/features/accounting/` أو `rust/migrations/` أو الأمن أو ZATCA أو بيانات الإنتاج من دليل اختبار مناسب.

## المراجع

[1]: AUTHORITY_MODEL.md "نموذج السلطة"
[2]: ../audits/bkip-2026-08/EXECUTION_ROADMAP.md "خارطة التنفيذ"
