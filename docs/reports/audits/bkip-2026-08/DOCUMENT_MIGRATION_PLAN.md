# BKIP — خطة هجرة الوثائق

> **قاعدة أمان:** هذه الخطة لا تنفذ حذفًا أو نقلًا تلقائيًا. كل عنصر يحتاج مالكًا ومراجعة روابط وقرارًا قابلًا للعكس قبل تغيير المسار أو الإزالة.

## 1. الهدف ومعايير القرار

الهدف هو الوصول إلى أقل عدد منطقي من الوثائق، مع وظيفة واحدة ومالك وسلطة وحالة لكل وثيقة. لا يعني التشابه أن وثيقة مكررة، ولا يعني العمر أنها غير صحيحة. تتخذ القرارات فقط بعد مقارنة: نطاق الوثيقة، آخر SHA ذي صلة، الروابط الداخلة، الأدلة التي تحتفظ بها، والوثيقة الحاكمة التي تحل محلها.

| القرار | متى يستخدم | شرط الإغلاق |
|---|---|---|
| KEEP | وثيقة حية تؤدي وظيفة فريدة. | تعيين مالك/سلطة/تاريخ مراجعة وروابط مرجعية. |
| MERGE | وثيقتان حيتان تغطيان الموضوع نفسه. | دمج محتوى فريد، redirect، إصلاح روابط، وموافقة. |
| REWRITE | السلطة صحيحة لكن الواقع/الهيكل تغير. | PR به IDs ومعايير قبول وتاريخ تحقق. |
| MOVE | المحتوى صحيح لكن الطبقة/الموقع خطأ. | `git mv` مع redirect وإصلاح روابط. |
| ARCHIVE | سجل تاريخي غير حاكم لكنه ذو قيمة دليلية. | نقل إلى `docs/archive/` مع banner تاريخي وسياق SHA. |
| DELETE | نسخة غير حاكمة متطابقة أو ناتج آلي منتهي بعد حفظ أصل/احتفاظ. | إثبات عدم وجود روابط + موافقة + قابلية استرجاع Git. |
| CREATE | توجد فجوة معرفية تؤثر في تغيير أو تدقيق أو تشغيل. | قالب ومالك وسبب ورابط المتطلبات. |

## 2. سجل الهجرة الأولي

| العنصر | الحالة الحالية | القرار المقترح | السبب | التحقق قبل التنفيذ |
|---|---|---|---|---|
| `README.md` | بوابة مشروع تحمل ادعاءات منتج/اختبار/امتثال ثابتة. | REWRITE | يتنافس مع خارطة 2026-08 ويضم روابط غير متحققة/قديمة. | راجع كل badge/عدد اختبار/رابط وتحقق منه على SHA/CI. |
| `.kiro/specs/active/basir_master_specification/` | مواصفة رئيسة نشطة. | REWRITE | نية مهمة، لكن بلا IDs وحالات/مصطلحات/قيم منجرفة. | أضف metadata وREQ IDs وlinks إلى code/test/evidence. |
| `08_FORENSIC_ATLAS_INDEX.md` | خريطة «92% Complete». | REWRITE | أعلى كثافة ادعاءات اكتمال بلا evidence matrix. | لكل شاشة: REQ، مسار، test، PR، حالة. |
| `06_COMPLIANCE_ENGINES.md` | مواصفة امتثال نشطة. | REWRITE | لا يفصل simulation عن verified/production. | حزمة evidence قانونية/تقنية ومراجعة owner. |
| `05_SECURITY_GOVERNANCE.md` | مواصفة أمن نشطة. | REWRITE | تضارب bcrypt/SHA-256 وcheckbox مستقبلية مكتملة. | ADR authentication، tests، CI evidence. |
| `04_UI_DESIGN_SYSTEM.md` | design-system نشط. | REWRITE | 3 مصادر قيم design tokens. | ADR design tokens واختيار code-generated canonical source. |
| `03_DATA_SCHEMA.md` | مخطط بيانات نشط. | REWRITE | عقود Isar/PostgreSQL واختلافات تمثيل Decimal/الحقول غير مفصولة. | قاموس بيانات ومصفوفة mapping وmigration review. |
| `docs/Strategic/خطة_تنفيذ_بصير.md` | خطة حديثة معتمدة. | KEEP | أحدث خطة عمل مهيكلة وتربط PRs؛ ليست سجل حقيقة تنفيذية مستقلًا. | أضف metadata وlinks to REQ/TASK/evidence لكل صف. |
| `docs/Strategic/Phase_5_Development/02_Implementation_Status.md` | حالة «Active» مؤرخة 2025-12. | ARCHIVE | تصف Go/Backend وخطة واختبارات تاريخية لا تطابق مرحلة الكود الحالي. | أضف banner تاريخي وSHA/تاريخ وانقل دون كسر روابط. |
| `.kiro/FINAL_STATUS.md` | تقرير 2025 «100% ready». | ARCHIVE | يدعي مكونات لا تظهر كجذور حية على HEAD. | تحقق من الروابط، ثم archive وredirect من المسار القديم. |
| `.kiro/BLUEPRINT_STATUS.md` | حالة Blueprint. | ARCHIVE | يتداخل مع تقرير/حالة تاريخية. | حفظ المصدر وسبب السياق. |
| `.kiro/FINAL_STATUS.md` + `.kiro/docs/reports/FINAL_STATUS.md` | محتوى مطبّع متطابق. | MERGE ثم DELETE الثانوية | تكرار مثبت آليًا، لكن قد توجد روابط خارجة. | `git grep` للمسارين، ثم redirect/قرار مراجعة. |
| `.kiro/BLUEPRINT_STATUS.md` + النسخة التقرير | محتوى مطبّع متطابق. | MERGE ثم DELETE الثانوية | تكرار مثبت آليًا. | كما سبق. |
| تقارير `logs/reports` المتطابقة | نواتج جودة آلية. | ARCHIVE / DELETE وفق retention | ليست مواصفات ولا حالة حاكمة. | ضع سياسة retention واحتفظ بالـartifact الأصلي. |
| وثائق `docs/archive/...` | أرشيف متنوع. | KEEP / NORMALIZE | الأرشيف ليس فوضى إذا وُسم بالسياق. | فهرس archive وbanner لا حاكمية. |
| `ui-ux-improvements` | active specification متعددة الملفات. | SPLIT + REWRITE | تتداخل design/requirements/tasks/reports وتزعم readiness. | أنشئ requirements متسلسلة وتطابق roadmap الحديثة. |
| `widget-tests-phase3/requirements.md` | requirement file منفرد نشط. | CREATE أو ARCHIVE | سلسلة spec→design→tasks→evidence مقطوعة. | أضف missing artifacts أو انقله إلى planning/archive. |
| `accounting-standards-framework` completed | حزمة كبيرة مكتملة. | REVERIFY ثم KEEP/ARCHIVE | «completed» ليس دليل قبول. | اربط reports/tests الحالية أو انقلها كسجل قرار. |

## 3. مستندات تنشأ قبل أي نقل واسع

| المستند الجديد | الموقع المقترح | المالك المقترح | السبب |
|---|---|---|---|
| سياسة سلطة وحوكمة التوثيق | `docs/00-governance/` | Engineering lead | تمنع مصادر الحقيقة المتنافسة. |
| فهرس ADR | `docs/03-architecture/adrs/` | Architect | يحسم قرارات التخزين، auth، sync، design tokens. |
| Accounting invariants | `docs/02-domain/` | Accounting domain owner | يحول القواعد إلى عقود قابلة للاختبار. |
| Data dictionary + mapping | `docs/04-data/` | Data owner | يفصل Isar/PostgreSQL ويمسك التحويل. |
| Security controls + threat model | `docs/05-security/` | Security owner | يربط السياسة بالتنفيذ والاختبار. |
| ZATCA evidence register | `docs/06-compliance/` | Compliance owner | يمنع خلط المحاكاة بالاعتماد. |
| API/integration contracts | `docs/07-integrations/` | Integration owner | يضبط المستقبل بدل عرضه كمنفذ. |
| Testing/evidence index | `docs/09-testing/` | QA owner | يربط REQ بالـCI وartifact وSHA. |

## 4. مراحل التنفيذ

| المرحلة | المحتوى | المخرج | بوابة القبول |
|---|---|---|---|
| A — تجميد السلطة | اعتماد الهرمية وإضافة banners للوثائق غير الحاكمة. | authority policy + status taxonomy. | لا صفحة حية تدعي Source of Truth خارج السياسة. |
| B — إصلاح الادعاءات الحرجة | README وZATCA وsecurity/design status. | claims مؤرخة ومسنودة. | لا `production ready` أو `compliant` بلا evidence link. |
| C — إعادة تأسيس المواصفة | IDs ومتطلبات/معايير قبول وADRs. | master spec rebased. | كل REQ حرج يملك design/task/code/test/evidence. |
| D — توحيد البنية | نقل تدريجي وredirects وفهرس. | `docs/` المنظم. | لا broken links؛ archive قابل للاكتشاف. |
| E — تنظيف متحكم به | دمج التكرارات والنواتج الآلية حسب retention. | سجل حذف/دمج. | مراجعة روابط + موافقة مالك + Git reversible. |
| F — وقاية مستمرة | PR templates/CI checks/ownership. | docs-as-code gate. | التغيير الحرج لا يدمج قبل تحديث الوثائق المرتبطة. |

## 5. ما لا يحذف الآن

لا تحذف ملفات المواصفات أو التقارير أو الترحيلات أو مخرجات الأدلة التي تتصل بادعاء قانوني/مالي/أمني. ولا تحذف النسخ المتطابقة قبل فحص الروابط الصريحة وغير الصريحة في README وملفات Kiro والـGitHub workflows. يحتفظ Git بالتاريخ، لكنه لا يعفي من مسؤولية روابط المستخدمين أو إجراءات تدقيق لاحقة.

## المراجع

[1]: STATUS_AND_DUPLICATION_EVIDENCE.md "سجل التكرار وادعاءات الحالة"
[2]: KNOWLEDGE_INTEGRITY_REPORT.md "تقرير نزاهة المعرفة"
[3]: DOCUMENT_CENSUS.md "جرد الوثائق"

**المؤلف:** Manus AI
