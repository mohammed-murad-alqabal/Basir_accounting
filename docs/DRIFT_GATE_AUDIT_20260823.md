# سجل بوابة Drift — 2026-08-23

## نطاق التدقيق

أُجري هذا التدقيق قراءةً فقط بعد رفع commit `38282c30` إلى الفرع `work/stock-movements-contract-fix-20260817`. لم يُفتح أو يُعدّل أي PR، ولم يُنفذ merge أو حذف أو force push. بقيت Isar مصدر التنفيذ والكتابة الفعلية طوال التحقق.

## حالة الفرع وPRs

| العنصر | النتيجة |
|---|---|
| الفرع الحالي | `work/stock-movements-contract-fix-20260817` |
| commit البعيد | `38282c307b95d05f64570c880ec81b506634817c` |
| التزامن | بعد `git fetch` كان الفرع متقدمًا محليًا بcommit واحد قبل الرفع، وأصبح متزامنًا بعده |
| PR #163 | Open / Draft / CLEAN |
| عنوان PR #163 | `fix: clarify stock movements repository contract` |
| قاعدة PR #163 | `work/stock-movements-importer-parity-20260817` عند `806d4455` |
| PRs الطبقات السابقة | #148 و#149 و#159 و#160 مفتوحة Draft وCLEAN حسب القراءة الحالية؛ لا دمج تلقائي |
| PR #161 | مفتوحة Draft، وحالتها `UNKNOWN` في القراءة الحالية؛ تحتاج مراجعة مستقلة قبل اعتبارها مسار دمج |

## نتائج CI البعيد

ظهر بعد push runان فاشلان لـ`pr-comment.yml` و`create-issue.yml` عند نفس SHA. كلاهما يحمل `jobs: []`، وواجهة GitHub تصفه بأنه فشل محتمل في ملف workflow قبل إنشاء job. لم يُستنتج من ذلك فشل في كود Drift، ولم تُنفذ إعادة تشغيل أو إصلاح خارجي.

كما ظهرت وظيفتا `Auto Merge` و`حذف الفرع` بحالة `skipped`. لذلك لا تُعد حالة CI البعيدة بوابة قبول خضراء. إصلاح workflowين وصلاحياتهما يجب أن يكون PR مستقلًا بعد مراجعة YAML وسبب startup failure، ولا يجوز خلطه مع موجة التخزين.

### نتيجة التشخيص المحلي

كشف مدقق YAML أن `pr-comment.yml` كان يحتوي محتوى template literal غير مزاح داخل `script: |` ابتداءً من السطر 223، وأن `create-issue.yml` كان يحتوي المشكلة نفسها ابتداءً من السطر 142. أُصلحت المسافات في فرع مستقل `fix/ci-workflow-yaml-20260823` فقط؛ لم يتغير منطق JavaScript أو trigger أو permissions. بعد الإصلاح اجتازت ملفات workflows وعددها 22 فحص YAML، كما أثبتت مقارنة `git diff --ignore-all-space` عدم وجود فرق دلالي غير متعلق بالمسافات.

## بوابات التحقق المحلية

| البوابة | النتيجة |
|---|---|
| Bash syntax وsecurity suite | نجاح؛ 3 مجموعات و77 حالة فرعية، 100% |
| Drift package tests | 45 اختبارًا ناجحًا |
| Drift root targeted tests | 96 اختبارًا ناجحًا |
| Flutter analyze | 204 ملاحظة `info` فقط، بلا warnings جديدة؛ النجاح محقق مع `--no-fatal-infos` |
| `git diff --check` | نجاح |
| تغييرات Providers/Isar | لا تعديل في `core/providers.dart` أو `sync_service.dart` أو مستودعات Isar الإنتاجية |

## Snapshot وparity المعقمة

شُغّل `run_drift_stock_movements_snapshot.dart` على `test/fixtures/stock_movements_golden_fixtures.json` محليًا. النتيجة الآمنة كانت `clean: true`، مع 6 fixtures نظيفة و4 fixtures محجوبة. لم يتضمن الخرج user IDs أو item IDs أو payload.

| المؤشر | القيمة |
|---|---:|
| clean fixtures | 6 |
| blocked fixtures | 4 |
| mismatches | 0 |
| duplicate scoped keys | 0 في fixtures النظيفة |
| source/migrated count | متطابق في كل fixture نظيفة |

هذه النتيجة تثبت replay وstorage/importer parity على fixtures مصممة، ولا تثبت parity على snapshot حقيقية معقمة. ما تزال snapshot الواقعية، وقرار barcode، وحالات transfer/negative adjustment المحجوبة، وبوابة CI البعيدة عناصر لازمة قبل canary.

## القرار

**الحالة: مواصلة التحضير، ممنوع التفعيل.** لا يجوز تفعيل shadow-read في بيئة فعلية، ولا read canary، ولا Drift writes، ولا تغيير Provider، ولا dual-write، ولا cutover. الخطوة الآمنة التالية هي تجهيز snapshot واقعية معقمة عبر مسار موثق، ثم تشغيل raw/reference/derived parity لكل شريحة. وبالتوازي يُعالج فشل workflow في مسار CI مستقل وبموافقة منفصلة.

## مراجع التدقيق

[1]: https://github.com/mohammed-murad-alqabal/Basir_accounting/pull/163 "PR #163 — Stock movements repository contract"

[2]: https://github.com/mohammed-murad-alqabal/Basir_accounting/actions "GitHub Actions — Basir Accounting"
