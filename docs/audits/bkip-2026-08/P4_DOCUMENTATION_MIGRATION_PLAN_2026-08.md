# خطة هجرة وتنظيم الوثائق — BKIP P4

> **document_id:** BKIP-P4-PLAN-001
> **status:** DRAFT
> **authority_level:** 3
> **owner:** Documentation Steward
> **approved_by:** Pending formal repository owner approval
> **effective_from:** 2026-08-15
> **last_verified_sha:** `93df611433a62f7935e7aa622d3741c2bb1869d6`
> **review_due:** 2026-09-15
> **related_requirements:** REQ-UX-004
> **related_adrs:** None
> **supersedes:** None
> **superseded_by:** None

## القرار الحاكم

هذه **خطة هجرة وليست تصريح حذف**. لا تنفذ أي `git mv` أو `MERGE` أو حذف أو إعادة تصنيف نهائي قبل أن يحمل الجدول قرارًا برقم PR وموافقة المالك وفحص روابط ناجح. تبقى كل الأصول في أماكنها الحالية أثناء المراجعة. أي تقرير تاريخي يستمر في الوجود مع banner يصرح بأنه ليس مصدر الحقيقة الحالي.

تستند الخطة إلى خارطة BKIP التي تشترط النقل بـ`git mv` مع redirects وإصلاح الروابط، ودمج النسخ المتطابقة فقط بعد فحص الروابط، وأرشفة تقارير 2025 و2026-01 مع banner تاريخي، وإنشاء فهرس واحد، وإعادة تصنيف specs وفق evidence.[1]

## خط الأساس المرصود

| المقياس | القيمة | الدلالة |
|---|---:|---|
| أصول الوثائق المفهرسة في نطاق `docs` و`.kiro` | 1,069 ملفًا | جرد قابل لإعادة الإنتاج على SHA الحالي |
| مرشحات تطابق المحتوى المطبع | 5 مجموعات | ليست موافقة دمج؛ تحتاج lineage وروابط ومالك |
| مرشحات تصادم العنوان | 17 مجموعة | قد تكون إصدارات أو نطاقات مختلفة؛ لا تعد تكرارًا تلقائيًا |
| ملفات specs تحت `active` | 254 ملف Markdown | تحتاج تفكيكًا على مستوى spec لا اعتمادًا من اسم المجلد |
| ملفات `docs/archive` | 28 ملف Markdown | مستودع تاريخي قائم يحتاج فهرسة/banner متسقًا |
| ملفات ذات metadata governance ظاهرة في الجرد الأولي | 49 ملفًا | لا يطبق القالب على كل تقرير تاريخي حسب السياسة الحالية |
| تشغيل CI المرجعي | `ba23c61b` / PR #68 | آخر main مدمج قبل بدء P4 |

## سجل قرارات الهجرة

لا توجد قرارات تنفيذية معتمدة في هذه الدفعة؛ الجدول التالي هو سجل عمل يجب أن يملأه المالك قبل التنفيذ.

| القرار | الأصول/النطاق | الإجراء المقترح | الحالة | شرط التنفيذ |
|---|---|---|---|---|
| `MOVE-P4-001` | وثائق المجال الحية خارج `docs/02-domain/` | نقل طبقي بـ`git mv` مع redirects | PENDING_REVIEW | جرد روابط كامل + موافقة Documentation Steward وEngineering Lead |
| `MOVE-P4-002` | ADRs خارج `docs/03-architecture/adrs/` | توحيد موضع ADRs | PENDING_REVIEW | مراجعة authority وsupersedes لكل ADR |
| `ARCHIVE-P4-001` | تقارير 2025 و2026-01 التي لا تصف SHA الحالي | إضافة banner وفهرسة في archive | PENDING_REVIEW | historical SHA/date + مراجعة مالك التقرير |
| `MERGE-P4-001` | `.kiro/FINAL_STATUS.md` و`.kiro/docs/reports/FINAL_STATUS.md` | اختيار مصدر حاكم وإبقاء redirect تاريخي | PENDING_REVIEW | مقارنة الروابط + موافقة Product/Engineering؛ لا حذف الآن |
| `MERGE-P4-002` | `.kiro/BLUEPRINT_STATUS.md` و`.kiro/docs/reports/BLUEPRINT_STATUS.md` | اختيار مصدر حاكم وإبقاء lineage | PENDING_REVIEW | مقارنة التاريخ والادعاءات + موافقة المالك |
| `MERGE-P4-003` | `logs/reports/latest_report.md` ونسخة التقرير المؤرخة | فصل latest pointer عن التقرير التاريخي | PENDING_REVIEW | التحقق من الروابط وسياسة توليد latest |
| `MERGE-P4-004` | ملفات dependencies الثلاثة المتطابقة | إبقاء archive كمرجع وفحص current source | PENDING_REVIEW | تحديد أي ملف يعكس الحالة الحالية قبل merge |
| `MERGE-P4-005` | `l10n_errors.txt` ونسخة archive | إبقاء artifact التاريخي أو redirect | PENDING_REVIEW | فحص استعمال أدوات الترجمة والروابط |
| `RECLASSIFY-P4-001` | `.kiro/specs/active`, `completed`, `planning` | تصنيف كل spec حسب acceptance evidence | PENDING_REVIEW | owner + REQ/ADR/test/evidence لكل spec عالي الأثر |
| `INDEX-P4-001` | `docs/INDEX.md` وفهارس `.kiro` | جعل [DOCUMENTATION_REGISTER](../../00-governance/DOCUMENTATION_REGISTER.md) الفهرس الحاكم | DRAFT | اعتماد هذا السجل وتحديث redirects دون حذف الفهارس القديمة |

## موجات التنفيذ

### الموجة صفر — حماية المصدر

تجميد الحذف والدمج التلقائي، واستخراج نسخة من الجرد، وتشغيل فحص الروابط، وتسجيل SHA قبل كل موجة. لا يسمح CI بعملية `git mv` واسعة في PR واحد بلا قائمة قرارات واضحة.

### الموجة الأولى — الفهرسة والـbanners

اعتماد سجل الوثائق الحاكم، ثم إضافة banners فقط إلى التقارير التاريخية المؤكدة. هذه الموجة لا تغير أسماء المسارات ولا تدمج محتوى، ولذلك هي أقل مخاطرة وأسهل رجوعًا.

### الموجة الثانية — النقل الطبقي المحدود

تنقل الوثائق الحية التي يوافق عليها المالك فقط باستخدام `git mv`. يضاف redirect في الفهارس القديمة، وتصلح كل الروابط الداخلية، ثم يشغل فحص الروابط وفاحص governance قبل الدمج.

### الموجة الثالثة — الدمج وإعادة التصنيف

تنفذ قرارات `MERGE` للنسخ المتطابقة المؤكدة فقط. كل دمج يجب أن يذكر الملف الحاكم، والنسخة التاريخية، والفروق الدلالية، والروابط المتأثرة، وموافقة المالك. تعاد تصنيفات specs منفردة ولا تستخدم كلمة `completed` كبديل عن acceptance evidence.

## معايير القبول

| المعيار | الدليل المطلوب |
|---|---|
| عدم وجود حذف صامت | `git diff --summary` + سجل قرار لكل حذف/دمج |
| سلامة الروابط | فحص روابط ناجح على SHA الـPR، مع قائمة الاستثناءات المعروفة |
| مصدر حقيقة واحد | `DOCUMENTATION_REGISTER.md` ومصفوفة ownership محدثان ومراجعان |
| صحة التاريخ | كل archive candidate يحمل `historical_as_of_sha/date` و`not_current_source_of_truth` |
| قابلية الرجوع | كل MOVE/MERGE يحدد commit الرجوع والمسارات السابقة |
| اكتمال التتبع | REQ/ADR/Test/CI evidence لكل ادعاء سلوكي أو حالة حية |
| سلامة الحوكمة | نجاح governance engine مع بقاء mode advisory حتى قياس baseline جديد |

## نتائج فحص الروابط القراءة فقط — 2026-08-15

أُجري فحص قراءة فقط على SHA `320674cebfde7305d14c5d86ab407193978b5839` للمرشحات التاريخية وفهرس `docs/INDEX.md`. فحصت الأداة 9 ملفات، واستخرجت الروابط النسبية المحلية، واستبعدت الروابط الخارجية وanchors، ثم تحققت من وجود الهدف على القرص. النتيجة: **22 رابطًا صالحًا و8 روابط مكسورة**. لا يمثل هذا الفحص موافقة نقل أو دمج؛ بل يسجل المخاطر التي يجب حلها قبل أي PR تغييري.

| المجموعة | النتيجة القابلة للتحقق | القرار الآمن المؤقت |
|---|---|---|
| `MERGE-P4-001` و`MERGE-P4-002` | أجسام `FINAL_STATUS` و`BLUEPRINT_STATUS` متطابقة بعد إزالة metadata والفراغات، لكن الفحص سجل روابط مكسورة في `FINAL_STATUS` التاريخي | إبقاء النسختين، حفظ lineage، وإصلاح/تصنيف الروابط قبل redirect أو MERGE |
| `MERGE-P4-003` | `logs/reports/latest_report.md` symlink إلى `quality_report_20260110_155129.md`، والسكربت يعيد إنشاءه | `KEEP`: pointer تشغيلي وليس نسخة قابلة للحذف |
| `MERGE-P4-005` | `l10n_errors.txt` الجذري مطابق لنسخة archive، و`l10n.yaml` يحدد الجذري كملف مخرجات الترجمة | `KEEP` للجذري؛ لا حذف ولا تحويل إلى archive |
| `INDEX-P4-001` | `docs/INDEX.md` يحوي 18 رابطًا صالحًا ورابطين مكسورين | إبقاء الفهرس، وإصلاح الروابط في PR مستقل قبل أي نقل طبقي |

الروابط المكسورة المرصودة في `.kiro/FINAL_STATUS.md` هي `WORKSPACE_ACTIVATION.md` و`WORKSPACE_STATUS.md` و`VERIFICATION_REPORT.md` و`TRANSFORMATION_COMPLETE.md` عند حلها نسبيًا من `.kiro/`. أما النسخة التاريخية في `.kiro/docs/reports/FINAL_STATUS.md` فتحتوي رابطين مكسورين. تُعامل هذه الروابط بوصفها قيود lineage تاريخية؛ لا يجوز إصلاحها بإضافة ملفات أو حذف مراجع دون قرار ملكية.

## مخاطر غير مغلقة

لا يثبت الجرد وحده أن نسخ العنوان المتصادم متطابقة، ولا أن `latest_report` ينبغي أن يكون مؤشرًا حيًا، ولا أن specs المكتملة تاريخيًا تملك اختبارات قبول. كما أن وجود 13,360 سطرًا في سجل ادعاءات الحالة لا يعني أن كل ادعاء خاطئ؛ يعني فقط أن كل ادعاء يحتاج تصنيفًا وسياقًا ودليلًا قبل اعتماده.

## المراجع

[1]: EXECUTION_ROADMAP.md "خارطة تنفيذ BKIP — P4"
[2]: FINDINGS_REGISTER.md "سجل نتائج BKIP، خصوصًا BKIP-001 وBKIP-007 وBKIP-008"
[3]: ../../00-governance/DOCUMENTATION_REGISTER.md "سجل الوثائق الحاكم"
[4]: appendices/DUPLICATION_CANDIDATES.csv "مرشحات التكرار"
[5]: appendices/STATUS_CLAIMS.csv "سجل ادعاءات الحالة التاريخي"
