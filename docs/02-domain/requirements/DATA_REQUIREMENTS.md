# متطلبات البيانات عالية الخطورة

> **document_id:** REQ-DATA-CATALOG-001
> **status:** DRAFT
> **authority_level:** 1
> **owner:** Data Owner
> **approved_by:** Pending formal repository owner approval
> **effective_from:** 2026-08-13
> **last_verified_sha:** Not applicable — proposed requirements pending approval and evidence linkage
> **review_due:** 2026-09-13
> **related_adrs:** ADR-DATA-001 (storage boundaries), ADR-DATA-002 (sync), to be created

| ID | المتطلب | الأولوية |
|---|---|---|
| REQ-DATA-001 | قاموس بيانات وحيد المصدر | P1 |
| REQ-DATA-002 | mapping دقيق للـDecimal والعملات | P0 |
| REQ-DATA-003 | توافق الترحيلات والعقود | P0 |
| REQ-DATA-004 | مزامنة وحل تعارضات محددان | P1 |

## REQ-DATA-001 — قاموس بيانات وحيد المصدر

**البيان:** يجب أن يصف قاموس بيانات حاكم كل entity وfield حرج، نوعه النطاقي، تمثيله في Isar وPostgreSQL، الفهارس، القيود، المالك، وحالة الإحلال.

**معيار القبول:** Given entity حرج مثل `JournalEntry` أو `Account` أو `Invoice`, Then توجد بطاقة قاموس تربط كل field بمسارات التنفيذ والترحيل. Given تغير field أو migration، Then يحدث القاموس في نفس PR أو يقدم استثناء منتهيًا.

## REQ-DATA-002 — mapping Decimal والعملات

**البيان:** يجب أن يحدد contract صريح تمثيل `Decimal` والمبالغ الأصلية وأسعار الصرف عبر domain وIsar وPostgreSQL، مع قواعد parsing/rounding/error.

**معيار القبول:** Given أي قيمة مالية مسموحة، Then يعيد serialize/deserialize القيمة نفسها من دون فقد دقة. Given string أو قيمة غير قابلة للتحليل، Then يفشل بمسار نطاقي محدد. لا تستخدم اختلافات تخزين النص كدليل على اختلاف القيمة.

## REQ-DATA-003 — توافق الترحيلات والعقود

**البيان:** كل migration يعدل نموذجًا حاكمًا يجب أن يذكر ADR/REQ المتأثرين، وخطة توافق/rollback، واختبارًا يثبت إنشاء schema وترحيل البيانات ضمن النطاق.

**معيار القبول:** Given migration جديدة، Then تمر على قاعدة نظيفة وعلى نسخة سابقة مدعومة. Given فشل migration، Then يملك التشغيل مسار rollback أو recovery موثقًا. لا يحدث تغيير field صامت بين المخازن.

## REQ-DATA-004 — مزامنة وحل تعارضات

**البيان:** يجب أن يحدد ADR المزامنة source of authority لكل entity، حالة `syncStatus`، نموذج التعارض، idempotency، وسلوك soft deletion قبل إعلان دعم تعدد الأجهزة أو cloud sync.

**معيار القبول:** Given تعديل متزامن محلي/بعيد، Then يطبق النظام سياسة موثقة أو يعلن conflict قابلًا للحل. Given retry، Then لا ينشأ أثر محاسبي مكرر. لا تستخدم حقول sync موجودة كدليل على اكتمال التكامل.

## المراجع

[1]: ../../../.kiro/specs/active/basir_master_specification/03_DATA_SCHEMA.md "مواصفة البيانات"
[2]: ../../00-governance/DOCUMENT_OWNERSHIP.md "الملكية"
[3]: ../../audits/bkip-2026-08/FINDINGS_REGISTER.md "نتائج BKIP"
