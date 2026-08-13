# متطلبات الامتثال عالية الخطورة

> **document_id:** REQ-COM-CATALOG-001
> **status:** DRAFT
> **authority_level:** 1
> **owner:** Compliance Owner
> **approved_by:** Pending formal repository owner approval
> **effective_from:** 2026-08-13
> **last_verified_sha:** Not applicable — proposed requirements pending approval and evidence linkage
> **review_due:** 2026-09-13
> **related_adrs:** ADR-COM-001 (compliance evidence model), to be created

> **قاعدة الحالة:** `SIMULATION` لا تعني `SANDBOX-VERIFIED`، و`SANDBOX-VERIFIED` لا تعني `PRODUCTION-INTEGRATED`، و`PRODUCTION-INTEGRATED` لا تعني `REGULATORY-EVIDENCED`. لا ينتقل أي مطلب إلى الحالة الأخيرة إلا بموافقة Compliance Owner وحزمة دليل مرتبطة بـSHA.

| ID | المتطلب | الأولوية |
|---|---|---|
| REQ-COM-001 | VAT والتصنيفات الضريبية | P0 |
| REQ-COM-002 | مستندات XML/UBL وQR التقنية | P0 |
| REQ-COM-003 | تكامل ZATCA والإرسال | P0 |
| REQ-COM-004 | زكاة وIFRS وتصنيف الحسابات | P1 |
| REQ-COM-005 | GOSI كنطاق مخطط | P1 |

## REQ-COM-001 — VAT والتصنيفات الضريبية

**البيان:** يجب أن تحسب محركات الضريبة المبالغ وفق tax category وrate مصدرهما سياسة معتمدة ذات إصدار، لا وفق قيمة عامة مفترضة فقط.

**معيار القبول:** Given فاتورة بفئة ومعدل صالحين، Then يساوي مجموع ضريبة السطور والتجميع النتيجة المتوقعة بالدقة المعتمدة. Given فئة صفرية أو معفاة أو غير صالحة، Then يعالجها النظام وفق policy معتمدة أو يرفضها بوضوح. لا تعد الحسابات وحدها دليلاً قانونيًا.

**الدليل المطلوب:** policy version، unit/integration fixtures لكل فئة، ومراجعة Compliance Owner.

## REQ-COM-002 — XML/UBL وQR التقنية

**البيان:** يجب أن تنتج الوثيقة الإلكترونية artifacts محددة بإصدار profile/format معلوم، وأن تغطي الاختبارات الحقول الإلزامية والحالات السلبية ضمن النطاق التقني المعلن.

**معيار القبول:** Given invoice fixture صالح، Then ينتج XML وQR قابلين للتحقق بvalidator/fixture محدد. Given حقل إلزامي مفقود أو قيمة غير صالحة، Then يفشل التوليد أو validation برمز خطأ يمكن اختباره.

**الدليل المطلوب:** profile/version، generated fixtures، validator result، SHA، وartifact CI.

## REQ-COM-003 — تكامل ZATCA والإرسال

**البيان:** يجب أن يوسم كل مسار onboarding أو إرسال باعتباره `SIMULATION` أو `SANDBOX-VERIFIED` أو `PRODUCTION-INTEGRATED` صراحة. يمنع استخدام كلمة `compliant` أو `submitted` لإثبات علاقة إنتاجية بلا evidence package.

**معيار القبول:** Given مسار محاكاة، Then تظهر simulation في code/docs/UI حيث يلزم ولا تعتمد credentials إنتاجية. Given sandbox أو production path، Then يسجل environment وendpoint governance وcredential ownership وrequest/response artifacts غير الحساسة وحالة retry/failure. لا تعلن Regulatory-Evidenced إلا بموافقة مالك الامتثال.

**الدليل المطلوب:** integration contract، environment evidence، redacted response artifacts، وapproval.

## REQ-COM-004 — زكاة وIFRS وتصنيف الحسابات

**البيان:** يجب أن تفصل سياسة الحسابات/التصنيف التقني عن الرأي المحاسبي أو الشرعي. لا تكون category أو keyword guard وحدها دليلاً على امتثال IFRS أو الزكاة.

**معيار القبول:** Given حساب أو عملية ضمن النطاق، Then تنطبق policy معتمدة ومحددة الإصدار وتظهر assumptions. Given تقرير أو calculation، Then يمكن تتبع input accounts والسياسة ووقت الحساب. أي claim تنظيمي يحتاج sign-off مناسبًا.

**الدليل المطلوب:** policy، fixtures، تقرير قابل للتتبع، وموافقة Domain/Compliance Owners.

## REQ-COM-005 — GOSI كنطاق مخطط

**البيان:** يبقى GOSI في الحالة `PLANNED` حتى يملك requirement تفصيليًا وتصميمًا وتطبيقًا واختبارات. لا يعرض كقدرة متاحة أو مكتملة في README أو المواصفات أو واجهة المنتج قبل ذلك.

**معيار القبول:** Given عدم وجود implementation/evidence، Then تظهر الحالة planned فقط. Given بدء التنفيذ، Then ينشأ REQ مستقل لعوامل الحساب والحدود والتسويات والقيود الناتجة.

**الدليل المطلوب:** design approved، implementation links، tests، ومراجعة policy.

## المراجع

[1]: ../../../.kiro/specs/active/basir_master_specification/06_COMPLIANCE_ENGINES.md "مواصفة الامتثال المنقحة"
[2]: ../../00-governance/AUTHORITY_MODEL.md "نموذج السلطة"
[3]: ../../audits/bkip-2026-08/appendices/CI_EVIDENCE.md "سجل CI"
