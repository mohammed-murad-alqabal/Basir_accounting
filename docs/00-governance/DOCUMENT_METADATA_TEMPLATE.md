# قالب metadata للوثائق الحاكمة

> **document_id:** GOV-TPL-001
> **status:** ACTIVE
> **authority_level:** 4
> **owner:** Documentation Steward
> **approved_by:** Engineering Lead
> **effective_from:** 2026-08-13
> **last_verified_sha:** `ce825c55c6e9959645f6eef330a78e2bbd844c7c`
> **review_due:** 2026-11-13

انسخ الكتلة التالية إلى بداية أي requirement أو ADR أو تصميم أو عقد حاكم. لا تطبقها على كل تقرير تاريخي؛ التقرير يحتاج تاريخًا وSHA وسياقًا، لا metadata سلطة كاملة.

```markdown
> **document_id:** REQ-AREA-001
> **status:** DRAFT | ACTIVE | APPROVED | SUPERSEDED | ARCHIVED
> **authority_level:** 1 | 2 | 3 | 4 | 5
> **owner:** <responsible role>
> **approved_by:** <approver role or Pending>
> **effective_from:** YYYY-MM-DD
> **last_verified_sha:** `<git sha>` | Not applicable
> **review_due:** YYYY-MM-DD
> **related_requirements:** REQ-AREA-001, REQ-AREA-002
> **related_adrs:** ADR-001
> **supersedes:** <document id or None>
> **superseded_by:** <document id or None>
```

## قواعد الحقول

| الحقل | القاعدة |
|---|---|
| `document_id` | ثابت وفريد ولا يعاد استخدامه بعد الأرشفة. |
| `status` | يستخدم قاموس الحالات المعتمد فقط. |
| `authority_level` | يطابق [نموذج السلطة](AUTHORITY_MODEL.md). |
| `owner` | دور مسؤول، لا عبارة عامة مثل «الفريق». |
| `approved_by` | مطلوب للوثائق ذات المستوى 1 أو 2؛ يجوز `Pending` للمسودة فقط. |
| `last_verified_sha` | مطلوب لكل ادعاء سلوك/اختبار/حالة؛ لا تضع SHA عند عدم وجود تحقق. |
| `review_due` | تاريخ حقيقي؛ يستعمله الفاحص الأسبوعي لاكتشاف الانجراف. |
| `related_requirements` | IDs فقط؛ يمنع الرابط الغامض إلى اسم مستند. |
| `supersedes`/`superseded_by` | إلزامي عند الإحلال لحماية المسار التاريخي. |

## مثال Requirement

```markdown
> **document_id:** REQ-ACC-004
> **status:** APPROVED
> **authority_level:** 1
> **owner:** Accounting Domain Owner
> **approved_by:** Engineering Lead
> **effective_from:** 2026-08-13
> **last_verified_sha:** `ce825c55...`
> **review_due:** 2026-11-13
> **related_adrs:** ADR-001
> **supersedes:** None
> **superseded_by:** None
```

## مثال تقرير تاريخي

```markdown
> **status:** ARCHIVED
> **historical_as_of_sha:** `<sha-or-unknown>`
> **historical_as_of_date:** YYYY-MM-DD
> **not_current_source_of_truth:** true
> **superseded_by:** <current document or evidence index>
```

**المراجع:** [نموذج السلطة](AUTHORITY_MODEL.md) و[ملكية الوثائق](DOCUMENT_OWNERSHIP.md).
