# أتمتة حوكمة الوثائق

> **document_id:** GOV-AUTO-001
> **status:** ACTIVE
> **authority_level:** 4
> **owner:** DevOps Owner
> **approved_by:** Engineering Lead
> **effective_from:** 2026-08-13
> **last_verified_sha:** `df1c1feb20c68ce91bca2a503c4b5eb6faaa04f5`
> **review_due:** 2026-10-13
> **related_requirements:** REQ-ACC-001, REQ-SEC-001, REQ-COM-003, REQ-DATA-003, REQ-UX-001

## الغرض

يعمل فاحص الحوكمة بصورة حتمية داخل طلبات الدمج. لا يستخدم نموذجًا لغويًا ولا يقرر صحة المحتوى المحاسبي أو القانوني؛ بل يفحص بنية قابلة للقياس: metadata، والروابط المحلية، ووجود مراجع `REQ-*` و`ADR-*` لتغييرات المسارات عالية الأثر، والادعاءات المحكومة.

في مرحلة **advisory** الحالية، تنشر الملاحظات في artifact وتعليق واحد يتجدد على PR ولا تمنع الدمج. يجب أن يحل المساهم الملاحظة أو يسجل استثناءً محدد السبب والمالك وتاريخ الانتهاء. لا يستخدم الاستثناء لإخفاء خرق أمني أو محاسبي أو تنظيمي.

## التشغيل المحلي

```bash
# تحديد الملفات المتغيرة من مقارنة Git
 dart lib/tools/documentation/cli/documentation_cli.dart governance \
  --base origin/main \
  --head HEAD \
  --pr-body-file .governance-pr-body.md \
  --output governance-report.json \
  --markdown-output governance-report.md
```

يمكن استخدام `--changed-files <file>` عند الحاجة إلى قائمة files منتهية بأسطر جديدة، و`--enforce` فقط بعد اعتماد مرحلة المنع. لا يضاف `--enforce` إلى سير العمل الحالي.

## السياسة وقواعدها

السياسة المفسّرة آليًا في [`.github/governance/documentation-policy.yml`](../../.github/governance/documentation-policy.yml). تحدد مسارات الوثائق الحاكمة وحقول metadata المطلوبة، والمسارات المحاسبية/الأمنية/الامتثالية/البيانية/البصرية عالية الأثر، والـprefix المناسب لكل متطلب، وحالات الحاجة إلى ADR.

| القاعدة | نطاقها | المخرج الحالي |
|---|---|---|
| `metadata.required` | وثائق حية تحت طبقات الحوكمة/المنتج/النطاق/البنية/البيانات/الأمن/الامتثال/التكامل. | Warning عند غياب أي حقل حاكم. |
| `links.local` | Markdown معدل، باستثناء الأرشيف وتقارير BKIP. | Warning مع مسار ورقم السطر. |
| `traceability.requirement` | تغير source في مجال عالي الأثر. | Warning إذا غاب `REQ-*` الملائم من نص PR. |
| `traceability.adr` | تغير أمني أو امتثال أو data/migration أو tokens/UX. | Warning إذا غاب `ADR-*` من نص PR. |
| `claims.governed` | ادعاءات مثل `production ready` و`compliant`. | Warning يطلب evidence package أو استثناء منتهي. |

## الدليل وتعليق PR

ينشئ workflow `Documentation Governance` الملفين `governance-report.json` و`governance-report.md` ويحفظهما artifact. ويحدّث تعليقًا واحدًا يحمل marker ثابت، فلا تتكرر التعليقات مع كل push. ويستعمل workflow `Documentation Check` تقرير JSON فعليًا لتحديث coverage بدل نسب ثابتة.

يبقى هدف تغطية التوثيق **80%** ظاهرًا بوصفه حدًا استشاريًا في هذه المرحلة. إذا كانت القيمة الفعلية أدنى منه، ينجح سير العمل مع warning وartifact واضح بدل إخفاء الرقم أو خفض الهدف اصطناعيًا. لا يتحول هذا الحد إلى شرط دمج مانع إلا بعد خطة رفع تغطية ومراجعة نتائج فترتين متتاليتين من طلبات الدمج.

## الانتقال إلى بوابة مانعة

لا تتحول قاعدة إلى منع تلقائي إلا بعد قياس أسبوعين على الأقل من PRs، وتوثيق false positives والاستثناءات، وإقرار Engineering Lead ومالك المجال. يوصى بالترتيب التالي: روابط Markdown المحلية أولًا، ثم metadata في الوثائق الحاكمة الجديدة، ثم ادعاءات الامتثال، ثم REQ/ADR للمسارات المحاسبية والأمنية والبيانية.

## المراجع

[1]: AUTHORITY_MODEL.md "نموذج السلطة"
[2]: DOCUMENT_OWNERSHIP.md "ملكية الوثائق"
[3]: ../audits/bkip-2026-08/EXECUTION_ROADMAP.md "خارطة تنفيذ BKIP"
