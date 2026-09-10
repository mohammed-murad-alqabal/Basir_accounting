# BKIP — خارطة التنفيذ الموحدة

> **الهدف:** نقل Basir من مخزون وثائقي واسع ومتعارض جزئيًا إلى نظام معرفة حاكم، قابل للتتبع، ومثبت بالأدلة.
> **نقطة البداية:** نتائج تدقيق BKIP في 2026-08-13؛ لا تمثل الخطة شهادة جاهزية أو امتثال.
> **مبدأ التنفيذ:** لا حذف مباشر، ولا ادعاء «مكتمل/متوافق/جاهز» من دون متطلب واختبار ودليل مؤرخ.

## 1. القرار التشغيلي المطلوب اليوم

تعتمد الإدارة نموذجًا مرحليًا: تبدأ ضوابط الحوكمة في **وضع استشاري** لمدة قصيرة لتكشف الاستثناءات الحقيقية، ثم تتحول القواعد الحرجة فقط إلى بوابات دمج مانعة. يحقق ذلك الانضباط دون تعطيل التطوير القائم، ويحمي المتطلبات المحاسبية والأمنية والتنظيمية قبل بقية الوثائق.

| القرار | المطلوب من المالكين | أثره الفوري |
|---|---|---|
| اعتماد هرمية السلطة | تعيين Engineering Lead ومالكي المحاسبة والبيانات والأمن والامتثال وQA. | لا تستخدم التقارير أو README لإثبات السلوك بدل الكود/الاختبار/CI. |
| اعتماد معجم الحالة | `DRAFT`, `ACTIVE`, `APPROVED`, `SUPERSEDED`, `ARCHIVED` للوثائق؛ و`IMPLEMENTED`, `PARTIAL`, `UNVERIFIED`, `VERIFIED` للمتطلبات. | ينهي استعمال «Complete» كحالة غامضة. |
| اعتماد اسم الدليل | `REQ → ADR → TASK/PR → CODE → TEST → EVIDENCE`. | يحدد ما يلزم قبل ادعاء تحقق. |
| اعتماد مسار الأتمتة | مراقبة استشارية ثم فرض تدريجي. | لا تكسر PRs الحالية فجأة. |

## 2. برنامج العمل بحسب الأولوية

### P0 — خلال أول 48 ساعة: إيقاف التضليل وتثبيت نقطة الحقيقة

| ID | العمل | المالك | المخرج | معيار القبول |
|---|---|---|---|---|
| P0-01 | إنشاء صفحة `docs/00-governance/authority-model.md` من سياسة BKIP المعتمدة. | Engineering Lead | هرمية سلطة ومالك لكل طبقة. | يعلن المصدر الحاكم للسلوك والنية والدليل صراحة. |
| P0-02 | وضع banner تاريخي على `FINAL_STATUS` و`BLUEPRINT_STATUS` وتقارير الحالة القديمة، من دون حذف أو نقل بعد. | Documentation Steward | وسم `HISTORICAL — NOT CURRENT SOURCE OF TRUTH`. | لا تبقى وثيقة تاريخية توحي بأنها حالة حية بلا سياق. |
| P0-03 | تصحيح README و`06_COMPLIANCE_ENGINES` لتبديل ادعاءات الجاهزية/ZATCA المطلقة بحالة مؤرخة ونطاق محاكاة واضح. | Product + Compliance Owner | PR claims correction. | لا تظهر `production ready` أو `compliant` بلا رابط SHA/evidence. |
| P0-04 | تسجيل أحدث SHA ونتائج CI في evidence index، وفصل نجاح Workflow محدد عن نجاح المشروع كله. | QA Owner | `docs/09-testing/evidence-index.md`. | كل رقم اختبار/تغطية/بناء مرتبط بـSHA وRun ID. |
| P0-05 | تعيين مالك ونقطة مراجعة للمواصفة الرئيسة وخارطة التنفيذ وREADME. | Engineering Lead | جدول ownership. | لا وثيقة حاكمة بلا owner و`review_due`. |

### P1 — خلال الأسبوع الأول: بناء أساس التتبّع والحوكمة

| ID | العمل | المالك | التبعية | معيار القبول |
|---|---|---|---|---|
| P1-01 | اعتماد 20–30 متطلبًا عالي الخطورة أولًا، مع IDs من `REQ-ACC-*`, `REQ-SEC-*`, `REQ-COM-*`, `REQ-DATA-*`, `REQ-UX-*`. | Domain Owners + QA | P0-01 | كل متطلب يملك معيار قبول Given/When/Then ومالكًا وحالة. |
| P1-02 | تحويل قواعد المحاسبة إلى `Accounting Invariants` حاكمة. | Accounting Owner | P1-01 | تشمل التوازن، ≥2 سطر، حصرية debit/credit، غير الصفرية، القفل، العكس، والعملات. |
| P1-03 | إعداد أربعة ADRs: حدود Isar/PostgreSQL، المصادقة/تخزين كلمات المرور، tokens التصميم، وحالة تكامل ZATCA. | Architect + Owners | P0-01 | لكل ADR قرار ونطاق وتبعات و`supersedes` إن وجد. |
| P1-04 | إنشاء قاموس بيانات ومصفوفة mapping بين Domain وIsar وترحيلات PostgreSQL. | Data Owner | ADR-data | يحدد نوع وتخزين كل Decimal وfield ونقطة التحويل. |
| P1-05 | استبدال جدول الامتثال العام بسجل أدلة: `SIMULATION`, `SANDBOX-VERIFIED`, `PRODUCTION-INTEGRATED`, `REGULATORY-EVIDENCED`. | Compliance Owner | P1-01 | لا تظهر علامة امتثال من دون artifact/بيئة/مالك. |
| P1-06 | تعديل قالب PR لطلب `REQ-*`, `ADR-*`, الاختبارات، وevidence، مع اختيار «لا أثر حوكمة» مشروح للتغييرات المحدودة. | Documentation Steward + QA | P0-01 | لا يمر PR عالي الأثر بلا بيان أثر وتبرير. |

### P2 — الأسبوع الثاني: تحويل الحوكمة إلى فحص آلي استشاري

| ID | العمل | المالك | المخرج | معيار القبول |
|---|---|---|---|---|
| P2-01 | إنشاء `.github/governance/documentation-policy.yml`. | Documentation Steward | ملف سياسة machine-readable. | يعرّف paths عالية الأثر والmetadata والكلمات المحكومة. |
| P2-02 | توسيع `lib/tools/documentation/cli/documentation_cli.dart` أو إضافة فاحص Dart مجاور له. | Tooling Owner | `governance analyze --base --head`. | يصدر Markdown + JSON وexit code واضح. |
| P2-03 | إضافة اختبارات وحدات للفاحص للـmetadata والروابط وREQ/evidence والكلمات المحكومة. | QA Owner | suite deterministic. | حالات success/failure/exception مغطاة. |
| P2-04 | إنشاء Workflow `documentation-governance.yml` على PR وpush. | DevOps Owner | تقرير artifact وتعليق PR محدث. | التقرير يقرأ النتائج الفعلية ولا يطبع أرقامًا ثابتة. |
| P2-05 | إصلاح `documentation_check.yml` الحالي؛ تعليق PR فيه يتضمن الآن `Coverage: 85.5%` و`Quality Score: 92.3/100` ثابتتين. | DevOps Owner | comment ديناميكي مستند إلى report JSON. | تطابق أرقام التعليق artifact أو يحذف الرقم عند غيابه. |
| P2-06 | وضع workflow في advisory mode: warning/label/PR comment، لا منع. | Engineering Lead | baseline أسبوعي. | تصنيف false positives والاستثناءات في سجل. |

#### قواعد الفاحص الآلي في النسخة الأولى

| القاعدة | تطبق على | الناتج في الوضع الاستشاري | تصبح مانعة متى؟ |
|---|---|---|---|
| metadata إلزامية | وثائق `APPROVED` و`ACTIVE` تحت المسارات الحاكمة. | Warning. | بعد استكمال metadata للوثائق الحاكمة القائمة. |
| روابط محلية سليمة | كل Markdown معدل. | Failure في التقرير. | فورًا؛ هي قاعدة منخفضة المخاطر. |
| `REQ-*` للتغييرات المحاسبية/الأمنية/ZATCA/schema | تغييرات في paths عالية الأثر. | Warning + label. | بعد فترة تجريبية ووجود catalog أولي. |
| `ADR-*` لتغير القرار المعماري | migrations/auth/sync/design tokens. | Warning. | بعد إقرار ADR templates. |
| evidence للادعاءات المحكومة | `compliant`, `production ready`, `verified`, `100%`, وأشباهها. | Failure في التقرير. | فورًا للكلمات التنظيمية/الأمنية؛ تدريجيًا للبقية. |
| review due | الوثائق الحاكمة. | Issue/label أسبوعي. | لا يوقف PR؛ يدار كدين توثيقي. |

### P3 — الأسبوعان الثالث والرابع: جعل القواعد الحرجة مانعة وإصلاح المخاطر التقنية

| ID | العمل | المالك | معيار القبول |
|---|---|---|---|
| P3-01 | جعل سلامة روابط Markdown وادعاءات الامتثال غير المثبتة وغياب metadata الحاكمة بوابات مانعة. | DevOps + Engineering Lead | الحالة المطلوبة في حماية `main` خضراء على PR نموذجي وتفشل على fixture سلبي. |
| P3-02 | فرض invariants المحاسبية في boundary الحاكم وإضافة property/integration tests. | Accounting Owner | ترفض الاختبارات قيدًا بسطر واحد، أو debit+credit، أو فترة مقفلة، أو عكسًا غير سليم. |
| P3-03 | حسم وتنفيذ ADR المصادقة؛ توحيد وثيقة الأمن والاختبارات حول خوارزمية معتمدة وحالة rate limiting. | Security Owner | لا يبقى تعارض bcrypt/SHA-256 أو بند Future بعلامة مكتمل. |
| P3-04 | فصل مخطط Isar وPostgreSQL وربطهما بmapping contract واختبار migration/round-trip. | Data Owner | schema diff ومصفوفة التحويل تمر في CI. |
| P3-05 | اعتماد canonical design tokens ثم تحديث UI spec أو الكود وفق ADR واحد. | UX Owner | لا توجد قيم primary متنافسة في الوثائق الحاكمة. |
| P3-06 | تحويل Atlas الشاشات إلى feature register؛ لا تعلن شاشة Complete بلا اختبار/PR/evidence. | Product + QA | كل حالة complete تحمل ID وروابط مباشرة. |

### P4 — من الأسبوع الخامس إلى الثامن: إعادة تنظيم المعرفة والأرشفة المنضبطة

| ID | العمل | المالك | معيار القبول |
|---|---|---|---|
| P4-01 | نقل الوثائق طبقًا لخطة الهجرة إلى طبقات product/domain/architecture/data/security/compliance/testing/operations. | Documentation Steward | `git mv` فقط مع redirects وإصلاح روابط. |
| P4-02 | دمج النسخ المتطابقة المؤكدة بعد فحص الروابط. | Documentation Steward | سجل قرار `MERGE/DELETE` وموافقة؛ لا حذف صامت. |
| P4-03 | أرشفة تقارير 2025/2026-01 التي لا تصف SHA الحالي. | Owners | banner تاريخي وفهرس archive وسبب الأرشفة. |
| P4-04 | إنشاء index واحد للوثائق الحاكمة ومصفوفة ownership. | Engineering Lead | لا توجد حقيقتان متنافستان لنفس المجال. |
| P4-05 | مراجعة جميع specs تحت active/completed/planning وإعادة تصنيفها حسب evidence. | Product + QA | لا يتبقى spec «completed» بلا acceptance evidence. |

### P5 — عمل مستمر: تشغيل الحوكمة وقياسها

| التكرار | العمل | المخرج |
|---|---|---|
| مع كل PR | فحص governance، التقرير، وربط REQ/ADR/test/evidence. | Check قابل للمراجعة وتعليق ديناميكي. |
| أسبوعيًا | مسح review_due والروابط والتكرارات والادعاءات غير المؤرخة. | Issue/label backlog؛ لا يجمد التطوير. |
| شهريًا | مجلس معماري/نطاقي لمراجعة ADRs وrequirements عالية المخاطر. | محضر قرار وقرارات إحلال. |
| مع كل إصدار | تثبيت evidence index وZATCA/security/test release pack. | تقرير إصدار مؤرخ بـSHA، لا ملخص تسويقي عام. |
| كل ربع | إعادة تشغيل BKIP census/drift audit. | تغير score ومصفوفة debt وقرارات archive. |

## 3. تصميم الأتمتة داخل المستودع

```text
PR opened or updated
  → identifies changed paths
  → reads governance policy
  → checks metadata and Markdown links
  → maps high-impact paths to REQ/ADR/Test/Evidence requirements
  → scans governed claims
  → writes governance-report.json + governance-report.md
  → uploads artifact
  → updates one PR comment
  → advisory label or required status
```

### الملفات التي تنشأ أو تعدل

| المسار | الإجراء | الغرض |
|---|---|---|
| `.github/governance/documentation-policy.yml` | CREATE | قواعد المسارات والmetadata والكلمات والاستثناءات. |
| `lib/tools/documentation/...` | MODIFY أو CREATE | فاحص deterministic منسجم مع أداة التوثيق القائمة. |
| `test/tools/documentation/...` | CREATE | fixtures واختبارات الفاحص. |
| `.github/workflows/documentation-governance.yml` | CREATE | تشغيل PR/push، artifact، وتعليق ديناميكي. |
| `.github/workflows/documentation_check.yml` | MODIFY | إلغاء الأرقام الثابتة وربط التعليق بالنتائج الحقيقية. |
| `.github/pull_request_template.md` | MODIFY | حقول REQ/ADR/tests/evidence/impact. |
| `docs/00-governance/*` | CREATE | authority، templates، ownership، policy. |
| `docs/02-domain/accounting-invariants.md` | CREATE | قواعد محاسبية قابلة للاختبار. |
| `docs/03-architecture/adrs/*` | CREATE | قرارات حاكمة قابلة للإحلال. |

## 4. ترتيب التنفيذ الدقيق للـPRs

ينفذ كل عنصر في PR مستقل صغير، ويمنع الجمع بين إصلاحات سلوكية واسعة وإعادة تنظيم وثائق كبيرة في نفس طلب الدمج.

| PR | العنوان المقترح | النطاق |
|---:|---|---|
| 1 | `docs(governance): establish authority model and metadata templates` | سياسة السلطة والقوالب والمالكين. |
| 2 | `docs(claims): qualify production and compliance status` | README/ZATCA/banners تاريخية فقط. |
| 3 | `docs(requirements): define high-risk accounting and compliance requirements` | IDs ومعايير قبول أولية. |
| 4 | `docs(architecture): add data auth and token ADRs` | ADRs وقاموس بيانات أساس. |
| 5 | `ci(docs): add advisory documentation governance check` | config/fاحص/tests/workflow/artifacts. |
| 6 | `ci(docs): report actual documentation metrics in PR comments` | إصلاح تعليق الأرقام الثابتة. |
| 7 | `test(accounting): enforce core journal invariants` | حمايات نطاقية واختبارات. |
| 8 | `ci(docs): require critical governance checks on main` | branch protection بعد baseline. |
| 9+ | `docs(migration): archive and consolidate validated historical documents` | نقل/redirects/دمج تدريجي. |

## 5. المخاطر والضوابط

| الخطر | الضبط |
|---|---|
| تعطيل PRs سليمة بسبب قاعدة جديدة | تبدأ كل قاعدة high-impact بوضع advisory، وتضم allowlist منتهية الصلاحية مع سبب وowner. |
| تحول metadata إلى عبء شكلي | لا تجعل كل Markdown حاكمًا؛ تطبقها على الوثائق ذات السلطة فقط. |
| حذف تاريخ مهم | لا تنفيذ `DELETE` إلا بعد link audit وقرار موثق وموافقة مالك. |
| ادعاء امتثال ناقص | لا يمر اللفظ الحساس بلا evidence أو وسم simulation واضح. |
| استثناءات دائمة | كل exception يحمل تاريخ انتهاء ويظهر في التقرير الأسبوعي. |
| تعارض الكود والوثيقة | تغير paths عالية الأثر يفرض REQ/ADR/test/evidence linkage في PR. |

## 6. مؤشرات النجاح

| المؤشر | خط الأساس | الهدف خلال 30 يومًا | الهدف خلال 90 يومًا |
|---|---:|---:|---:|
| متطلبات عالية الخطورة مرتبطة بدليل | منخفض/غير موحد | 100% لأعلى 20–30 REQ | 100% لكل REQ approved. |
| ادعاءات امتثال/إنتاج بلا SHA/evidence | موجودة | صفر في الوثائق الحاكمة | صفر في كل الوثائق الحية. |
| وثائق حاكمة بلا owner/review_due | موجودة | صفر | صفر مع تنبيه آلي قبل الاستحقاق. |
| روابط محلية مكسورة في Markdown المعدل | غير مثبت | صفر | صفر مستمر. |
| specs completed بلا acceptance evidence | موجودة | مراجعة أعلى الحزم | صفر أو مؤرشفة. |
| false positives في فاحص الحوكمة | غير معلوم | قياس baseline | أقل من 5% من PRs. |

## 7. تعريف «مكتمل الآن»

لا تعد الخطة مكتملة لمجرد كتابة الوثائق أو تشغيل Workflow. تتحقق المرحلة الأولى فقط عندما: يكون نموذج السلطة معتمدًا؛ تصحح الادعاءات الحرجة؛ تملك المتطلبات عالية الخطورة IDs واختبارات وأدلة؛ يعمل الفاحص بوضع استشاري بنتائج حقيقية؛ ثم تصبح ثلاث قواعد حرجة على الأقل بوابات دمج مانعة. بعدها تنتقل إعادة التنظيم من «تنظيف ملفات» إلى تشغيل معماري مستدام للمعرفة.

## المراجع

[1]: KNOWLEDGE_INTEGRITY_REPORT.md "تقرير BKIP النهائي"
[2]: FINDINGS_REGISTER.md "سجل النتائج"
[3]: REQUIREMENTS_TRACEABILITY_MATRIX.md "مصفوفة التتبع"
[4]: DOCUMENT_MIGRATION_PLAN.md "خطة الهجرة"
[5]: DOCUMENTATION_GOVERNANCE_POLICY.md "سياسة الحوكمة"
[6]: ../../../.github/workflows/documentation_check.yml "بوابة التوثيق الحالية"
[7]: ../../../.github/workflows/quality_gates.yml "بوابات الجودة الحالية"

**المؤلف:** Manus AI
