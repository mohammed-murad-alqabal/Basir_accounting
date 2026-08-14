# سجل ميزات Atlas والشاشات

> **document_id:** ATLAS-FEATURE-REGISTER-001
> **status:** DRAFT
> **authority_level:** 2
> **owner:** Product Owner + QA Owner
> **approved_by:** Pending formal repository owner approval
> **effective_from:** 2026-08-14
> **last_verified_sha:** `2a72f677904b997c8b977a55520a696a51323c66` — [Quality Gates 31757216700](https://github.com/mohammed-murad-alqabal/Basir_accounting/actions/runs/31757216700)
> **review_due:** 2026-09-14
> **related_requirements:** REQ-UX-004, REQ-UX-002, REQ-UX-003
> **source_inventory:** `atlas_screen_legacy_inventory.csv`
> **supersedes:** No document; this governs future status assessment while retaining Atlas as historical source input.

## الغرض والحدود

هذا السجل هو المرجع الحاكم لتحويل معرّفات صور Atlas التاريخية `001–099` إلى ميزات قابلة للتتبع. لا يحذف Atlas ولا يعيد كتابة الصورة التاريخية؛ بل يحتفظ بـ`08_FORENSIC_ATLAS_INDEX.md` كمدخل legacy ويجعل حالة التنفيذ المعتمدة تتطلب سلسلة **معرّف سجل → تنفيذ/قرار → اختبار أو فجوة معلنة → دليل CI مؤرخ**.[1] [2]

لا تعني تسمية ملف screen أو تسجيل مسار أو وجود اختبار widget أن كامل السلوك المستخرج من الصورة مكتمل. لذلك لا يحتوي هذا السجل على أي حالة `COMPLETE` في هذه الدفعة. وهو يفصل بين **ادعاء Atlas الأصلي** و**حالة الأدلة الحالية** ويمنع تحويل أي ادعاء مرئي قديم إلى ادعاء وظيفي أو إنتاجي غير مثبت.[1] [3]

## مصادر الحقيقة وترتيب السلطة

| الترتيب | المصدر | وظيفته | لا يستخدم لإثباته منفردًا |
|---|---|---|---|
| 1 | هذا السجل و`REQ-UX-004` | تعريف حالة الميزة المطلوبة ومعيار قبولها وفجواتها. | اكتمال سلوك بلا رابط أدلة. |
| 2 | `atlas_screen_legacy_inventory.csv` | جرد حتمي للمعرّفات `001–099` المستخرج من Atlas. | جودة أو اكتمال التنفيذ. |
| 3 | `lib/core/router.dart` ومسارات العرض | دليل الوصول أو وجود implementation candidate. | أن الشاشة تغطي سمات الصورة كاملة. |
| 4 | اختبارات widget/screen ودليل CI | دليل محدود للسلوك الذي يسميه الاختبار. | قبول بصري أو وظيفي شامل ما لم يحدد الاختبار معيار القبول. |
| 5 | `08_FORENSIC_ATLAS_INDEX.md` | أسماء وصور ومطالبات legacy وهدف الحفاظ على النطاق. | حالة `Complete` الحالية. |

## نتيجة تسوية المصدر

استخرج الجرد `95` صفًا من Atlas، لكن المجال المعلن هو `001–099`. يوجد `91` معرّفًا فريدًا، وأربعة معرّفات مكررة (`034` و`041` و`042` و`043`)، وثمانية معرّفات لا يظهر لها صف (`022` و`025` و`036` و`051` و`052` و`076` و`083` و`084`). لذلك ينشئ الجرد كل قيمة ضمن المجال باسم `FR-ATLAS-NNN`، ولو كان مدخل Atlas غائبًا أو مكررًا.[2]

| فئة التسوية | العدد | السياسة |
|---|---:|---|
| `EXTRACTED_FROM_ATLAS` | 87 | يُحتفظ بالاسم والسمات وادعاء الحالة legacy، لكن الأدلة تبدأ `UNVERIFIED`. |
| `DUPLICATE_LEGACY_REFERENCE` | 4 | لا يدمج السجل المرجعين؛ يطلب من Product Owner تحديد ما إذا كانا نفس feature أو مشهدين مختلفين. |
| `MISSING_IN_ATLAS` | 8 | يبقى `FR-ATLAS-NNN` ظاهرًا بلا اسم افتراضي وبحالة `UNVERIFIED` حتى تعثر المراجعة على الأصل أو تقرر إلغاء النطاق. |
| الصفوف التي أعلنها Atlas مكتملة | 92 | مطالبات تاريخية فقط؛ لا تترجم إلى `COMPLETE` في هذا السجل بلا أدلة الروابط المطلوبة. |
| الصفوف التي أعلنها Atlas مخططة | 3 | تبقى `UNVERIFIED / PLANNED-LEGACY`، ولا تعد backlog معتمدًا بلا Product Owner. |

## قاموس حالات الأدلة

| الحالة | معناها التشغيلي | الحد الأدنى للانتقال |
|---|---|---|
| `UNVERIFIED` | لا يوجد بعد رابط تنفيذ موثوق أو أن صف Atlas مفقود/مكرر. | ربط code candidate أو قرار Product صريح. |
| `MAPPED` | توجد شاشة أو مسار مرشح، لكن لا يوجد اختبار مباشر للسلوك المستخرج. | اختبار قبول أو توثيق فجوة اختبار مع مالك. |
| `PARTIAL` | توجد شاشات واختبارات تسمي السطح، لكن لم يثبت كل سلوك Atlas ومعيار قبوله. | قبول محدد + اختبار مباشر + دليل CI على SHA. |
| `VERIFIED` | أثبتت روابط التنفيذ والاختبار وCI معيار القبول المحدد في الصف. | مراجعة دورية عند تغير feature. |
| `COMPLETE` | حالة منتج معتمدة فقط بعد `VERIFIED` وموافقة Product + QA Owner. | لا تنشأ تلقائيًا من CI أو من Atlas. |

> **دليل هذه الدفعة:** اجتازت [Quality Gates 31757216700](https://github.com/mohammed-murad-alqabal/Basir_accounting/actions/runs/31757216700) على `2a72f677` اختبار عقد السجل ضمن مجموعة `1,228` نجاحًا و`2` تخطٍ، مع تغطية `26.19%` وتحليل معلوماتي `177/177`. يثبت هذا سلامة الجرد والروابط الحالية، لا اكتمال أي feature من Atlas.

## فهرس الأدلة المرصودة

الصفوف أدناه هي **مرشحات علاقة مدعومة باسم الشاشة أو المسار**. لا تدعي التطابق الكامل مع الصورة أو كل السمات في Atlas. كل `FR-ATLAS-*` غير موجود هنا يبقى في CSV بحالة `UNVERIFIED` لحين المراجعة الفردية.

| Feature ID | Atlas ID | evidence التنفيذ أو المسار | evidence الاختبار | حالة الأدلة | الفجوة التالية |
|---|---:|---|---|---|---|
| FR-ATLAS-001 | 001 | [`dashboard_screen.dart`](../../lib/features/dashboard/presentation/screens/dashboard_screen.dart)؛ [`/dashboard`](../../lib/core/router.dart) | [`dashboard_screen_test.dart`](../../test/widget/features/dashboard/dashboard_screen_test.dart) | PARTIAL | معيار قبول لـKPI وquick actions وnavigation grid. |
| FR-ATLAS-003 | 003 | [`invoice_form_screen.dart`](../../lib/features/invoices/presentation/screens/invoice_form_screen.dart)؛ [`/invoice-form`](../../lib/core/router.dart) | [`invoice_form_screen_test.dart`](../../test/widget/features/invoices/invoice_form_screen_test.dart) | PARTIAL | إثبات line items والباركود والإجماليات المقصودة في Atlas. |
| FR-ATLAS-005 | 005 | [`invoices_screen.dart`](../../lib/features/invoices/presentation/screens/invoices_screen.dart)؛ [`/invoices`](../../lib/core/router.dart) | [`invoices_screen_test.dart`](../../test/widget/features/invoices/invoices_screen_test.dart) | PARTIAL | اختبار filter/sort/export محدد بالـREQ. |
| FR-ATLAS-006 | 006 | [`invoice_form_screen.dart`](../../lib/features/invoices/presentation/screens/invoice_form_screen.dart) | [`invoice_form_screen_test.dart`](../../test/widget/features/invoices/invoice_form_screen_test.dart) | PARTIAL | فصل معيار تعديل السطور وإعادة الحساب عن إنشاء الفاتورة. |
| FR-ATLAS-009 | 009 | [`inventory_items_screen.dart`](../../lib/features/inventory/presentation/screens/inventory_items_screen.dart)؛ [`/inventory`](../../lib/core/router.dart) | لا اختبار screen مباشر مرصود | MAPPED | اختبار search/master list. |
| FR-ATLAS-010 | 010 | [`returns_and_damages_screen.dart`](../../lib/features/invoices/presentation/screens/returns_and_damages_screen.dart)؛ [`/returns-and-damages`](../../lib/core/router.dart) | لا اختبار screen مباشر مرصود | MAPPED | اختبار RMA ومعيار صلاحيات وحالة. |
| FR-ATLAS-024 | 024 | [`barcode_creation_screen.dart`](../../lib/features/inventory/presentation/screens/barcode_creation_screen.dart)؛ [`/barcode-creation`](../../lib/core/router.dart) | لا اختبار screen مباشر مرصود | MAPPED | اختبار إنشاء label ونطاق أنواع الباركود. |
| FR-ATLAS-026 | 026 | [`reports_dashboard_screen.dart`](../../lib/features/reports/presentation/screens/reports_dashboard_screen.dart)؛ [`/reports-dashboard`](../../lib/core/router.dart) | [`reports_dashboard_screen_test.dart`](../../test/widget/features/reports/reports_dashboard_screen_test.dart) | PARTIAL | اختبار روابط report hub ومعايير الوصول والفترة. |
| FR-ATLAS-033 | 033 | [`cloud_backup_screen.dart`](../../lib/features/settings/presentation/screens/cloud_backup_screen.dart)؛ [`/cloud-backup`](../../lib/core/router.dart) | لا اختبار screen مباشر مرصود | MAPPED | لا يرفع ادعاء sync؛ يحتاج contract وخدمة واختبار وفق `INT-SYNC-001`. |
| FR-ATLAS-034 | 034 | [`tax_config_screen.dart`](../../lib/features/settings/presentation/screens/tax_config_screen.dart) | لا اختبار screen مباشر مرصود | MAPPED | اختبار إعداد الضريبة؛ لا يثبت ZATCA production. |
| FR-ATLAS-041 | 041 | [`print_settings_screen.dart`](../../lib/features/settings/presentation/screens/print_settings_screen.dart) | لا اختبار screen مباشر مرصود | UNVERIFIED | أصل Atlas مكرر؛ احسم العلاقة بين الاختيار والإعداد قبل ربط code. |
| FR-ATLAS-042 | 042 | لا candidate مؤكد | لا اختبار screen مباشر مرصود | UNVERIFIED | أصل Atlas مكرر؛ يتطلب تحديد Product لميزة preview مستقلة. |
| FR-ATLAS-043 | 043 | [`print_settings_screen.dart`](../../lib/features/settings/presentation/screens/print_settings_screen.dart) | لا اختبار screen مباشر مرصود | UNVERIFIED | أصل Atlas مكرر؛ أثبت paper-size behavior قبل الربط. |
| FR-ATLAS-047 | 047 | [`inventory_items_screen.dart`](../../lib/features/inventory/presentation/screens/inventory_items_screen.dart) | لا اختبار screen مباشر مرصود | MAPPED | إثبات CRUD وإدارة الفهرس عبر اختبار قبول. |
| FR-ATLAS-048 | 048 | [`inventory_item_form_screen.dart`](../../lib/features/inventory/presentation/screens/inventory_item_form_screen.dart)؛ [`/inventory-form`](../../lib/core/router.dart) | لا اختبار screen مباشر مرصود | MAPPED | اختبار إنشاء صنف وحالات تحقق الإدخال. |
| FR-ATLAS-058 | 058 | [`voucher_form_screen.dart`](../../lib/features/accounting/presentation/screens/voucher_form_screen.dart)؛ [`/voucher-form`](../../lib/core/router.dart) | لا اختبار screen مباشر مرصود | MAPPED | ربط نوع السند والتدفق المحاسبي بمعيار قبول. |
| FR-ATLAS-059 | 059 | [`voucher_form_screen.dart`](../../lib/features/accounting/presentation/screens/voucher_form_screen.dart) | لا اختبار screen مباشر مرصود | MAPPED | اختبار receipt voucher ومنع الأثر غير المصرح به. |
| FR-ATLAS-060 | 060 | [`voucher_form_screen.dart`](../../lib/features/accounting/presentation/screens/voucher_form_screen.dart) | لا اختبار screen مباشر مرصود | MAPPED | اختبار payment voucher ومنع الأثر غير المصرح به. |
| FR-ATLAS-063 | 063 | [`journal_entries_screen.dart`](../../lib/features/accounting/presentation/screens/journal_entries_screen.dart)؛ [`/journal-entries`](../../lib/core/router.dart) | لا اختبار screen مباشر مرصود | MAPPED | اختبار سجل القيود والفلاتر، مع إحالة إلى invariants المحاسبية. |
| FR-ATLAS-067 | 067 | [`journal_entries_screen.dart`](../../lib/features/accounting/presentation/screens/journal_entries_screen.dart) | لا اختبار screen مباشر مرصود | MAPPED | معيار بحث القيد وحدود الصلاحية. |
| FR-ATLAS-069 | 069 | [`cash_reconciliation_screen.dart`](../../lib/features/accounting/presentation/screens/cash_reconciliation_screen.dart)؛ [`/cash-reconciliation`](../../lib/core/router.dart) | لا اختبار screen مباشر مرصود | MAPPED | اختبار reconciliation وشروط الفترة. |
| FR-ATLAS-074 | 074 | [`inventory_items_screen.dart`](../../lib/features/inventory/presentation/screens/inventory_items_screen.dart) | لا اختبار screen مباشر مرصود | MAPPED | إثبات مستويات المخزون الآنية ومصدر البيانات. |
| FR-ATLAS-077 | 077 | [`chart_of_accounts_screen.dart`](../../lib/features/accounting/presentation/screens/chart_of_accounts_screen.dart)؛ [`/chart-of-accounts`](../../lib/core/router.dart) | لا اختبار screen مباشر مرصود | MAPPED | اختبار شجرة الحسابات والصلاحيات. |
| FR-ATLAS-078 | 078 | [`assets_screen.dart`](../../lib/features/assets/presentation/screens/assets_screen.dart)؛ [`/assets`](../../lib/core/router.dart) | لا اختبار screen مباشر مرصود | MAPPED | تحديد ما إذا كان Assets يغطي index الحسابات الثابتة أو feature مختلفًا. |
| FR-ATLAS-086 | 086 | [`journal_entries_screen.dart`](../../lib/features/accounting/presentation/screens/journal_entries_screen.dart) | لا اختبار screen مباشر مرصود | MAPPED | إثبات ledger drill-down لكل حساب. |
| FR-ATLAS-092 | 092 | [`users_dashboard_screen.dart`](../../lib/features/users/presentation/screens/users_dashboard_screen.dart)؛ [`/users`](../../lib/core/router.dart) | لا اختبار dashboard مباشر مرصود | MAPPED | اختبار user CRUD وربط RBAC. |
| FR-ATLAS-094 | 094 | [`user_form_screen.dart`](../../lib/features/users/presentation/screens/user_form_screen.dart)؛ [`/user-form`](../../lib/core/router.dart) | [`user_form_screen_test.dart`](../../test/features/users/presentation/screens/user_form_screen_test.dart) | PARTIAL | معيار profile update وصلاحيات التعديل. |
| FR-ATLAS-095 | 095 | [`appearance_settings_screen.dart`](../../lib/features/settings/presentation/screens/appearance_settings_screen.dart) | [`appearance_settings_screen_test.dart`](../../test/widget/features/settings/presentation/screens/appearance_settings_screen_test.dart) | PARTIAL | لا يثبت screen وحده policy الهوية؛ يظل تابعًا لـ`ADR-UX-001`. |
| FR-ATLAS-098 | 098 | [`barcode_settings_screen.dart`](../../lib/features/settings/presentation/screens/barcode_settings_screen.dart)؛ [`/barcode-settings`](../../lib/core/router.dart) | لا اختبار screen مباشر مرصود | MAPPED | اختبار scanner settings وfallbacks. |

## قواعد تحديث السجل

يحدث أي pull request يمس شاشة مسجلة الصف المرتبط في CSV والسجل، ويضيف أو يحدّث اختبار القبول ودليل CI في التغيير نفسه. لا يغيّر PR حالة feature إلى `COMPLETE` أو `VERIFIED` إذا كان اختبارها عامًا لا يسمي السلوك، أو إذا كان الرابط يشير إلى code candidate لا يثبت قبول feature. يحفظ تكرار Atlas أو غيابه في الجرد حتى اعتماد خطة تسوية وهجرة من Product Owner؛ لا يحل بالتخمين أو الحذف.[2] [4]

## خطة التسوية التالية

| الأولوية | النطاق | المخرج المطلوب | المالك |
|---|---|---|---|
| P3-06a | الصفوف ذات اختبار مباشر (`001`, `003`, `005`, `006`, `026`, `094`, `095`) | معايير قبول feature-level تحدد ما يغطيه الاختبار وما لا يغطيه. | QA Owner |
| P3-06b | مجموعة المحاسبة والمخزون (`009`, `047–048`, `058–070`, `074`, `077`, `086`) | قبول محدد واختبارات widget/integration للمسارات عالية الأثر. | Accounting + Inventory Owners |
| P3-06c | التكرار والغموض (`034`, `041–043`) والمعرّفات المفقودة الثمانية | قرار mapping من Product Owner وخطة هجرة بلا حذف تلقائي. | Product Owner |
| P3-06d | المطالبات الحساسة (`033`, `034`, `096`, `097`) | فصل UI presence عن sync/compliance/production evidence في المصفوفة. | Security + Compliance Owners |

## المراجع

[1]: [فهرس Atlas النشط](../../.kiro/specs/active/basir_master_specification/08_FORENSIC_ATLAS_INDEX.md) — مدخل أسماء وصور ومطالبات legacy.
[2]: [جرد Atlas الحتمي](atlas_screen_legacy_inventory.csv) — المعرفات `FR-ATLAS-001` حتى `FR-ATLAS-099` والتكرار والفجوات المستخرجة.
[3]: [خارطة BKIP P3-06](../audits/bkip-2026-08/EXECUTION_ROADMAP.md) — معيار عدم إعلان Complete بلا اختبار/PR/evidence.
[4]: [نموذج سلطة الوثائق](../00-governance/AUTHORITY_MODEL.md) — قواعد التغيير والموافقة وعدم الحذف التلقائي.
[5]: [REQ-UX-004](requirements/UX_REQUIREMENTS.md) — المتطلب الحاكم للسجل.

**المؤلف:** Manus AI
