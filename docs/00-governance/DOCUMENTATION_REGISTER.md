# سجل الوثائق الحاكم — Basir Accounting

> **document_id:** GOV-DOC-001
> **status:** DRAFT
> **authority_level:** 1
> **owner:** Documentation Steward
> **approved_by:** Pending formal repository owner approval
> **effective_from:** 2026-08-15
> **last_verified_sha:** `705c63e7586f1ae063ac6f092890da81ed439192`
> **review_due:** 2026-11-13
> **related_requirements:** REQ-UX-004
> **related_adrs:** None
> **supersedes:** None
> **superseded_by:** None

## الغرض والحالة

هذا السجل هو **فهرس حاكم مسود** لمسارات الوثائق التي تصف سلوك المشروع أو متطلباته أو قراراته. لا يحذف هذا السجل أي فهرس أو تقرير تاريخي، ولا يحول وجود الرابط إلى دليل صحة أو اكتمال. كل حالة `APPROVED` أو `VERIFIED` تحتاج مرجعًا مباشرًا إلى متطلب أو ADR أو اختبار أو تشغيل CI وفق مصفوفة التتبع.

ظل `docs/INDEX.md` وفهارس `.kiro/` التاريخية محفوظة بوصفها مراجع legacy إلى أن تتم مراجعة الروابط واعتماد خطة نقل أو إعادة تصنيف مستقلة. هذا السجل لا يكرر محتواها؛ بل يحدد أين يجب أن تكون **الحقيقة الحالية** بعد اعتماد المالك.

## مصادر الحقيقة حسب المجال

| مجال الحقيقة | المصدر الحاكم المقترح | المالك | مستوى السلطة | دليل الحالة الحالي |
|---|---|---|---:|---|
| نموذج السلطة والحوكمة | [AUTHORITY_MODEL](AUTHORITY_MODEL.md) و[DOCUMENT_OWNERSHIP](DOCUMENT_OWNERSHIP.md) | Engineering Lead | 1 | metadata وقرار المالك؛ الاعتماد الرسمي ما زال Pending |
| المتطلبات المحاسبية | [ACCOUNTING_REQUIREMENTS](../02-domain/requirements/ACCOUNTING_REQUIREMENTS.md) | Accounting Domain Owner | 1 | REQ-ID ومعايير قبول؛ يلزم ربط كل ادعاء باختبار/CI |
| المتطلبات البيانية | [DATA_REQUIREMENTS](../02-domain/requirements/DATA_REQUIREMENTS.md) | Data Owner | 1 | عقود البيانات وmapping؛ فجوات PostgreSQL موثقة |
| متطلبات UX | [UX_REQUIREMENTS](../02-domain/requirements/UX_REQUIREMENTS.md) | UX Owner | 1 | `REQ-UX-001…004`؛ آخر إضافة Atlas تحتاج اعتمادًا رسميًا |
| القرارات المعمارية | [adrs/](../03-architecture/adrs/) | Engineering Lead | 2 | كل ADR يحمل حالة وSHA؛ المسودات لا تعامل كاعتماد |
| عقد قيد اليومية | [JOURNAL_ENTRY_DATA_CONTRACT](../04-data/JOURNAL_ENTRY_DATA_CONTRACT.md) | Data Owner | 1 | round-trip Isar موثق؛ حدود PostgreSQL الجزئية معلنة |
| سجل Atlas | [ATLAS_FEATURE_REGISTER](../02-domain/ATLAS_FEATURE_REGISTER.md) | Product + QA | 1 | `FR-ATLAS-001…099` مع evidence وREQ-UX-004 |
| بوابات الجودة والأدلة | [bkip-2026-08/](../audits/bkip-2026-08/) | QA Owner | 3 | سجلات تشغيل SHA/Run ID؛ ليست بديلًا عن متطلبات أو ADR |
| التقارير التاريخية | [docs/archive/](../archive/) و[.kiro/specs/archived/](../../.kiro/specs/archived/) | Documentation Steward | 4 | banner تاريخي؛ لا تستخدم كمصدر حالي |
| مواصفات legacy | [.kiro/specs/](../../.kiro/specs/) | Product + QA | 4 | تعاد تصنيفها حسب evidence؛ لا تفترض الحالة من اسم المجلد |

## قواعد تحديد المصدر الحاكم

عند تعارض وثيقتين، تكون الأولوية لوثيقة ذات `document_id` حاكم ومالك محدد وحالة غير تاريخية، ثم للأحدث تحققًا على SHA فعلي، ثم للوثيقة التي ترتبط بمصفوفة المتطلبات. لا تكفي عبارة `complete` أو `production ready` أو `100%` لإثبات الحالة. عند غياب دليل، تسجل الحالة `UNVERIFIED` أو `PENDING_REVIEW` ولا يعاد تفسيرها كنجاح.

لا تنقل وثيقة إلا بعد تسجيل قرار `MOVE` يذكر المسار القديم والجديد وسبب النقل والمالك وفحص الروابط. ولا تدمج نسختين إلا بقرار `MERGE` يذكر المصدر الحاكم، وما الذي فُقد أو أُبقي، وموافقة المالك. أما التقرير التاريخي فيحتاج banner يثبت `historical_as_of_sha` و`historical_as_of_date` و`not_current_source_of_truth: true` قبل وضعه في archive.

## الحالة التشغيلية

| الحالة | المعنى | الإجراء المسموح |
|---|---|---|
| `CANONICAL-DRAFT` | مرشح مصدر حقيقة بانتظار الاعتماد | يمكن تحسينه وربطه؛ لا يحل محل وثيقة أخرى تلقائيًا |
| `CANONICAL-ACTIVE` | مصدر حقيقة معتمد ومراجع | يستخدم في PRs والتتبّع حتى موعد المراجعة |
| `LEGACY-REFERENCE` | وثيقة محفوظة للمرجعية وليست مصدرًا حاليًا | يمنع استخدامها لإثبات الحالة الحالية |
| `ARCHIVE-CANDIDATE` | مرشح أرشفة بعد فحص الروابط والمالك | لا ينقل أو يحذف قبل قرار ARCHIVE |
| `PENDING-MIGRATION` | له خطة نقل/دمج غير منفذة | يبقى في مكانه مع رابط خطة الهجرة |

## نطاق هذه المسودة

لا تعتمد هذه المسودة دمجًا أو حذفًا لأي من مرشحات التكرار التي حددها تدقيق BKIP. تفاصيل المرشحات وخطة الموافقات والتسلسل المرحلي موجودة في [خطة هجرة P4](../audits/bkip-2026-08/P4_DOCUMENTATION_MIGRATION_PLAN_2026-08.md). بعد موافقة Repository Owner وEngineering Lead، يحدث هذا السجل بمرجع PR وSHA، ثم تتحول الحالة من `DRAFT` إلى `ACTIVE` فقط إذا اكتملت الأدلة المطلوبة.

## المراجع

[1]: DOCUMENT_OWNERSHIP.md "ملكية الوثائق والمجالات"
[2]: DOCUMENT_METADATA_TEMPLATE.md "قالب metadata للوثائق الحاكمة"
[3]: ../audits/bkip-2026-08/EXECUTION_ROADMAP.md "خارطة تنفيذ BKIP — P4"
[4]: ../audits/bkip-2026-08/appendices/DUPLICATION_CANDIDATES.csv "مرشحات التكرار"
[5]: ../audits/bkip-2026-08/REQUIREMENTS_TRACEABILITY_MATRIX.md "مصفوفة التتبع"
