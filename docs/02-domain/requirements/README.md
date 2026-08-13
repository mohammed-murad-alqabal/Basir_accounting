# سجل المتطلبات عالية الخطورة

> **document_id:** REQ-CATALOG-001
> **status:** DRAFT
> **authority_level:** 1
> **owner:** Engineering Lead
> **approved_by:** Pending formal repository owner approval
> **effective_from:** 2026-08-13
> **last_verified_sha:** Not applicable — catalog defines intent and acceptance criteria
> **review_due:** 2026-09-13

هذا السجل هو البداية الرسمية لسلسلة `REQ → ADR → TASK/PR → CODE → TEST → EVIDENCE`. المتطلبات هنا **مقترحات منظّمة تنتظر اعتماد مالكي المجالات**؛ لا تعني أن التنفيذ أو الامتثال قد تحقق.

| السجل | المجال | عدد المتطلبات | الأولوية |
|---|---|---:|---|
| [ACCOUNTING_REQUIREMENTS.md](ACCOUNTING_REQUIREMENTS.md) | قيود ودفتر أستاذ وفترات وعملات | 10 | P0 |
| [SECURITY_REQUIREMENTS.md](SECURITY_REQUIREMENTS.md) | مصادقة وأذونات وتدقيق وأدلة | 5 | P0 |
| [COMPLIANCE_REQUIREMENTS.md](COMPLIANCE_REQUIREMENTS.md) | VAT وZATCA وزكاة وIFRS وGOSI | 5 | P0 |
| [DATA_REQUIREMENTS.md](DATA_REQUIREMENTS.md) | Schema وmapping ومزامنة وترحيلات | 4 | P1 |
| [UX_REQUIREMENTS.md](UX_REQUIREMENTS.md) | tokens ووصولية وحالة مستندات | 3 | P1 |

## قواعد الاستخدام

كل PR يمس مجالًا عالي الأثر يجب أن يذكر IDs المتطلبات المتأثرة، وأن يضيف أو يحدث اختبار قبول ورابط دليل CI. تصبح حالة requirement `VERIFIED` في سجل الأدلة، لا داخل هذا الفهرس، فقط عند وجود تنفيذ واختبار وartifact SHA مؤرخين.

## المراجع

[1]: ../../00-governance/AUTHORITY_MODEL.md "نموذج السلطة"
[2]: ../../00-governance/DOCUMENT_METADATA_TEMPLATE.md "قالب metadata"
[3]: ../../audits/bkip-2026-08/REQUIREMENTS_TRACEABILITY_MATRIX.md "نتائج تتبع BKIP"
