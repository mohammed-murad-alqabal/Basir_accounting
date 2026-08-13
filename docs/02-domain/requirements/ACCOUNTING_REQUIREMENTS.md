# متطلبات المحاسبة عالية الخطورة

> **document_id:** REQ-ACC-CATALOG-001
> **status:** DRAFT
> **authority_level:** 1
> **owner:** Accounting Domain Owner
> **approved_by:** Pending formal repository owner approval
> **effective_from:** 2026-08-13
> **last_verified_sha:** Not applicable — proposed requirements pending approval and evidence linkage
> **review_due:** 2026-09-13
> **related_adrs:** ADR-ACC-001 (to be created)

هذه المتطلبات تحوّل قواعد المواصفة المحاسبية إلى التزامات محددة قابلة للاختبار. لا يثبت وجودها في هذا الملف أن التطبيق يحققها؛ ترتبط حالة التنفيذ في evidence index لاحقًا.

| ID | المتطلب | الأولوية | المالك |
|---|---|---|---|
| REQ-ACC-001 | توازن القيد | P0 | Accounting Domain Owner |
| REQ-ACC-002 | حد أدنى وحصرية سطور القيد | P0 | Accounting Domain Owner |
| REQ-ACC-003 | مبالغ صالحة وغير سالبة | P0 | Accounting Domain Owner |
| REQ-ACC-004 | قفل الفترة المالية | P0 | Accounting Domain Owner |
| REQ-ACC-005 | عدم قابلية تعديل القيد المرحل | P0 | Accounting Domain Owner |
| REQ-ACC-006 | عكس قابل للتتبع وغير متكرر | P0 | Accounting Domain Owner |
| REQ-ACC-007 | ترحيل idempotent | P0 | Accounting Domain Owner |
| REQ-ACC-008 | دقة Decimal والعملات | P0 | Accounting Domain Owner |
| REQ-ACC-009 | سلسلة التدقيق الجنائي | P1 | Accounting + Security Owners |
| REQ-ACC-010 | تقرير ميزان مراجعة قابل للحفر | P1 | Accounting + QA Owners |

## REQ-ACC-001 — توازن القيد

**البيان:** يجب أن يرفض حد الترحيل الحاكم أي `JournalEntry` لا يساوي فيه مجموع المدين مجموع الدائن باستخدام `Decimal`.

**معيار القبول:** Given قيدًا بفارق غير صفري، When يطلب العميل ترحيله، Then يفشل الطلب دون حفظ أثر مرحل أو تحديث أرصدة، وتسجل رسالة قابلة للتدقيق. Given قيدًا متوازنًا صحيحًا، Then لا يفشل بسبب قاعدة التوازن.

**الاختبار المطلوب:** unit + integration test لمسار boundary الحاكم.
**الدليل المطلوب:** اسم الاختبار وSHA وRun ID.

## REQ-ACC-002 — حد أدنى وحصرية سطور القيد

**البيان:** يجب أن يحتوي القيد القابل للترحيل على سطرين على الأقل؛ وكل سطر يحمل **إما** مبلغًا مدينًا موجبًا **أو** مبلغًا دائنًا موجبًا، وليس كليهما ولا صفرًا لكليهما.

**معيار القبول:** Given قيد بسطر واحد، أو سطر debit+credit، أو سطر صفري، When يحاول الترحيل، Then يرفض الحد الطلب. Given سطرًا مدينًا موجبًا أو دائنًا موجبًا منفردًا، Then يمر تحقق السطر قبل تحقق توازن القيد.

**الاختبار المطلوب:** property tests للحالات الحدية وintegration test للنشر.

## REQ-ACC-003 — صحة المبالغ

**البيان:** يجب أن تكون مبالغ القيد غير سالبة، قابلة للتمثيل بالدقة المعتمدة، وألا تتجاوز حدود القياس أو العملة المقررة.

**معيار القبول:** Given قيمة سالبة أو non-finite أو دقة غير مدعومة، When يبنى أو يرحل السطر، Then يرفض مع رمز خطأ نطاقي ثابت. Given قيمة صحيحة بالدقة المعتمدة، Then تحافظ round-trip بين domain والتخزين على القيمة.

**الاختبار المطلوب:** unit tests وround-trip tests مع decimal fixtures.

## REQ-ACC-004 — قفل الفترة المالية

**البيان:** يجب أن يمنع النظام ترحيل القيد عندما تقع تاريخه الفعال ضمن فترة مالية مقفلة أو سنة مالية مغلقة.

**معيار القبول:** Given فترة مقفلة أو سنة مغلقة، When يرحل قيد أو فاتورة أو سند، Then يرفض العملية قبل أي كتابة محاسبية. Given فترة مفتوحة، Then يسمح بالترحيل إذا تحققت بقية القواعد.

**الاختبار المطلوب:** integration tests للفواتير والقيود والسندات، بما فيها حدود الشهر والسنة.

## REQ-ACC-005 — عدم قابلية تعديل القيد المرحل

**البيان:** لا يجوز تعديل أو حذف قيد مرحل أو سطوره؛ تصحح الأخطاء عبر عملية عكس محددة.

**معيار القبول:** Given قيدًا بحالة posted، When يطلب عميل تعديل مبلغ أو حساب أو حذف، Then يرفض boundary الحاكم العملية. لا تؤدي التحديثات غير المحاسبية إلى تغيير البيانات الموقعة أو hash دون سجل تدقيق صريح.

**الاختبار المطلوب:** repository/database integration tests وحالات concurrency ذات الصلة.

## REQ-ACC-006 — عكس قابل للتتبع وغير متكرر

**البيان:** يجب أن ينشئ عكس القيد قيدًا جديدًا متوازنًا، مرتبطًا بأصل مرحل واحد، ويمنع إنشاء عكس مكرر للأصل نفسه دون مسار تصحيح موثق.

**معيار القبول:** Given قيدًا posted غير معكوس، When يطلب مستخدم مخول العكس، Then ينشأ قيد جديد يبدل debit/credit ويرتبط بمعرف الأصل وسبب العكس. Given أصلًا معكوسًا، When يتكرر الطلب، Then يرفض أو يعيد نتيجة idempotent موثقة.

**الاختبار المطلوب:** unit + integration + audit trail assertions.

## REQ-ACC-007 — ترحيل idempotent

**البيان:** لا يجب أن ينتج إرسال نفس طلب الترحيل مرتين أكثر من أثر محاسبي مرحل واحد.

**معيار القبول:** Given مفتاح مصدر أو idempotency key ثابت، When يكرر العميل الطلب بسبب retry أو انقطاع، Then يكون الناتج قيدًا واحدًا فقط أو استجابة تشير إلى القيد الموجود.

**الاختبار المطلوب:** integration test متزامن وfixture لإعادة المحاولة.

## REQ-ACC-008 — Decimal والعملات

**البيان:** تستخدم جميع القيم المالية `Decimal` في domain، وتحفظ العملة الأصلية وسعر الصرف والمبلغ الأصلي عند تطبيق عملة غير الأساس، مع mapping موثق إلى التخزين.

**معيار القبول:** Given عملية بعملة غير أساسية، Then تحفظ `originalCurrency`, `originalAmount`, `exchangeRate`, والقيمة الأساسية دون فقد دقة. Given serialize/deserialize، Then تساوي القيمة الأصلية value-for-value.

**الاختبار المطلوب:** round-trip test لـIsar/domain وtest للترحيل/التقرير متعدد العملات.

## REQ-ACC-009 — سلسلة التدقيق الجنائي

**البيان:** كل حدث محاسبي حاكم محدد في ADR يجب أن ينتج سجلاً تدقيقيًا غير قابل للعبث، مع ارتباط hash أو آلية نزاهة معتمدة.

**معيار القبول:** Given إنشاء/ترحيل/عكس من الأحداث المشمولة، Then يوجد audit record قابل للتحقق. Given تغيير hash أو previous link، Then يفشل التحقق ويظهر السبب.

**الاختبار المطلوب:** tamper tests وسلسلة متعددة الأحداث وtransaction boundary tests.

## REQ-ACC-010 — ميزان مراجعة قابل للحفر

**البيان:** يجب أن يمكن تقرير ميزان المراجعة من الوصول إلى القيود المصدرية ضمن صلاحيات المستخدم والفترة المختارة دون تغيير الأرصدة.

**معيار القبول:** Given رصيد معروض، When يطلب المستخدم المخول drill-down، Then تعاد القيود ذات الصلة فقط وبمجموع متوافق مع الرصيد المعروض. Given مستخدم غير مخول، Then يرفض الوصول وفق REQ-SEC-002.

**الاختبار المطلوب:** report integration tests وauthorization test.

## المراجع

[1]: ../../../.kiro/specs/active/basir_master_specification/02_ACCOUNTING_ENGINE.md "مواصفة المحرك المحاسبي"
[2]: ../../00-governance/AUTHORITY_MODEL.md "نموذج السلطة"
[3]: ../../audits/bkip-2026-08/REQUIREMENTS_TRACEABILITY_MATRIX.md "نتائج BKIP"
