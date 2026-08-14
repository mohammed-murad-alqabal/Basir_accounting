# متطلبات تجربة الاستخدام عالية الخطورة

> **document_id:** REQ-UX-CATALOG-001
> **status:** DRAFT
> **authority_level:** 1
> **owner:** UX Owner
> **approved_by:** Pending formal repository owner approval
> **effective_from:** 2026-08-13
> **last_verified_sha:** Not applicable — proposed requirements pending approval and evidence linkage
> **review_due:** 2026-09-13
> **related_adrs:** ADR-UX-001 (canonical design tokens), to be created
> **related_registers:** ATLAS-FEATURE-REGISTER-001

| ID | المتطلب | الأولوية |
|---|---|---|
| REQ-UX-001 | مصدر tokens بصري واحد | P1 |
| REQ-UX-002 | وصولية وRTL قابلان للتحقق | P1 |
| REQ-UX-003 | حالة المستند وأثر الترحيل واضحان | P0 |
| REQ-UX-004 | سجل ميزات Atlas قابل للتتبع | P1 |

## REQ-UX-001 — مصدر tokens بصري واحد

**البيان:** يجب أن يحدد ADR واحد مصدرًا حاكمًا للون والمسافة والخط ونصف القطر والحالات، وأن يتطابق الكود والمواصفة وواجهات المنتج معه أو يعلنوا خطة إحلال واضحة.

**معيار القبول:** Given token حاكم، Then لا توجد ثلاث قيم متنافسة للمعنى نفسه في الوثائق الحية. Given تغيير token، Then يحدث مصدره وتوثيقه وsnapshot/visual test في PR نفسه.

## REQ-UX-002 — الوصولية وRTL

**البيان:** يجب أن تدعم التدفقات عالية الأثر RTL/AR وLTR/EN، labels دلالية، وtouch target وcontrast وفق policy معتمدة، مع اختبار آلي أو دليل يدوي منظم لكل تدفق.

**معيار القبول:** Given شاشة عالية الأثر، Then يمر widget/semantic test أو checklist evidence يثبت اللغة والاتجاه والـSemantics والحالة غير المعتمدة على اللون وحده.

## REQ-UX-004 — سجل ميزات Atlas قابل للتتبع

**البيان:** يجب أن يمثل سجل ميزات حاكم كل معرّف شاشة Atlas ضمن المجال `001–099` مرة واحدة، أو يعلنه صراحةً مفقودًا أو مكررًا في المصدر. لا تُصنّف الشاشة أو الميزة `COMPLETE` إلا عند وجود معرّف سجل، ومسار تنفيذ أو قرار مبرر، واختبار قبول أو فجوة اختبار معلنة، ودليل CI مؤرخ مرتبط بـSHA.

**معيار القبول:** Given شاشة Atlas، Then يحمل صفها `FR-ATLAS-*` وحالة reconciliation ودليلًا أو فجوة معلنة. Given ادعاء `COMPLETE`، Then يحمل الصف رابط code ورابط test ودليل CI مباشر؛ وإلا تكون الحالة `MAPPED` أو `PARTIAL` أو `UNVERIFIED` بحسب الدليل المتاح. Given تكرار أو معرّف مفقود في Atlas، Then يبقى ظاهرًا في السجل ولا يحذف أو يدمج دون خطة هجرة وموافقة.

## REQ-UX-003 — حالة المستند وأثر الترحيل

**البيان:** يجب أن يوضح محرر المستندات للمستخدم ما إذا كان المستند مسودة أو مرحلًا أو ملغى/معكوسًا، وما أثر فعل الترحيل قبل التأكيد، دون أن تتخذ واجهة العرض سياسة محاسبية خارج خدمة النطاق.

**معيار القبول:** Given فاتورة/سند في مسودة، When يطلب المستخدم الترحيل، Then تعرض معاينة أثر تستمد قواعد صحيحة من خدمة نطاقية. Given فترة مقفلة أو صلاحية مفقودة، Then تمنع الواجهة الفعل وتعرض سببًا قابلاً للفهم، مع بقاء boundary الحاكم مسؤولاً عن الإنفاذ.

## المراجع

[1]: ../../../.kiro/specs/active/basir_master_specification/04_UI_DESIGN_SYSTEM.md "مواصفة UI الحالية"
[2]: ../../audits/bkip-2026-08/EXECUTION_ROADMAP.md "خارطة التنفيذ"
[3]: ../../00-governance/AUTHORITY_MODEL.md "نموذج السلطة"
