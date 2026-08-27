# Basir Accounting — Production Readiness Report

> **تاريخ التدقيق:** 2026-08-26 UTC
> **الفرع المرجعي:** `main`
> **SHA المرجعي قبل الإصلاحات:** `740328f5d994b554b102d59b8203a25109db6e58`
> **فرع الإصلاحات الآمنة:** `audit/production-readiness-20260826`
> **القرار النهائي:** **NO-GO**

## Current State

المستودع يعمل كنظام Flutter/Dart مع محرك Rust وقاعدة Isar محلية، بينما توجد طبقة PostgreSQL/Rust مستقلة ومسارات Drift جزئية على فروع وPRs غير مدمجة. يظل `main` هو الفرع الافتراضي والمصدر الفعلي للكود الحالي، وكان نظيفًا ومتزامنًا مع `origin/main` عند بدء التدقيق. لا يثبت ذلك جاهزية إنتاجية؛ بل يحدد فقط نقطة القياس القابلة لإعادة الإنتاج.

تظهر في المستودع بنية قوية للاختبارات: تحقق Rust من التوازن، العملة، التتبّع، الفترات، السلسلة، والتقارير، واختبارات Flutter واسعة للطبقات والواجهات. لكن الأدلة التنفيذية كشفت أن الاختبارات الناجحة لا تكفي لإثبات اكتمال السلطة المحاسبية أو قابلية بناء كل المنصات.

## Findings

| المعرّف | النتيجة | الشدة | الدليل | التصنيف |
|---|---|---:|---|---|
| `FND-001` | مسار الترحيل الفعلي في Dart يمر عبر `AccountingService` ثم `IsarAccountingRepository.addJournalEntry` ويحدّث الأرصدة محليًا؛ ولا يستدعي Rust ledger أو PostgreSQL RPC. | حرجة | [مسار الخدمة][2]، [مسار Isar][3] | مانع إنتاج |
| `FND-002` | توجد مسارات كتابة محاسبية متعددة، منها ترحيل الفواتير مباشرة داخل `IsarSalesInvoicePostingGateway`، ما يمنع إثبات أن Ledger واحد هو المصدر المحاسبي الوحيد. | حرجة | [بوابة الفواتير][4] | مانع إنتاج |
| `FND-003` | كانت `create-issue.yml` و`pr-comment.yml` غير صالحتين نحويًا؛ بعد الإصلاح المحلي أصبحت ملفات workflows وعددها 23 قابلة للقراءة بـYAML. الإصلاح نفسه موجود حرفيًا في PRs مفتوحة متعددة، لذلك هو عمل مكرر يحتاج إلى توحيد لا إلى PR جديد موازٍ. | عالية | [إصلاح CI الأول][5]، [إصلاح CI الثاني][6] | يحتاج دمجًا منظمًا |
| `FND-004` | مولّدات Isar تحتوي 94 ثابتًا رقميًا لا يمكن تمثيلها بدقة في JavaScript، ولذلك فشل `flutter build web --release`. تتأثر 21 مجموعة من الملفات المولّدة. تغيير معرفات مخطط Isar عشوائيًا قد يكسر التوافق، ولذلك لم يُنفّذ دون تصميم ترحيل معتمد. | حرجة | [مصدر Isar المولّد][7] | مانع Web |
| `FND-005` | فشل بناء Android المحلي لغياب Android SDK. هذا ليس عيبًا مثبتًا في الكود، لكنه يمنع إثبات artifact المحمول من بيئة التدقيق الحالية. | عالية | سجل الأمر: `No Android SDK found` | دليل ناقص |
| `FND-006` | دالة Rust الخاصة بحركات التحويل كانت تولّد `hash_<uuid>` كقيمة مؤقتة بدل hash تشفيري فعلي، بينما نموذج السلسلة والتحقق يتطلبان hash محسوبًا من المحتوى. | عالية | [خدمة التحويل][8]، [أداة التحقق][9] | أُصلح |
| `FND-007` | تقرير Trial Balance كان يعالج كل القيود التي يمررها المستدعي، دون حارس داخلي لحالة `Posted`؛ أُضيف الحارس واختبار regression كي لا تدخل المسودات أو القيود قيد الاعتماد في التقرير. | عالية | [مولّد Trial Balance][10] | أُصلح |
| `FND-008` | توجد 45 PR مفتوحة، منها 31 تستهدف `main`، مع سلاسل Drift متفرعة عن فروع وسيطة، وPRs متعددة لإصلاحات CI والمصادر المولّدة. لا يمكن اعتبار جميعها مدمجة أو obsolete تلقائيًا. | عالية | [قائمة PRs العامة][1] | يتطلب قرار مالك المستودع |
| `FND-009` | تدقيق الترحيل Isar → Drift لم يثبت parity على بيانات إنتاج معقمة؛ على `main` توجد مسارات Isar الفعلية للمخزون وحركاته، بينما معظم طبقات Drift ذات الصلة موجودة في فروع/PRs غير مدمجة. | حرجة | [مستودع حركات المخزون][11]، [سلسلة PRs الخاصة بـDrift][12] | مانع Migration |
| `FND-010` | الوثائق الحديثة تنص على أن واقع التنفيذ هو السلطة، وتحظر claims مثل `production ready` دون SHA وartifact ومالك نطاق؛ في المقابل توجد وثائق تاريخية مؤرشفة تحمل claims جاهزية قديمة، وهي معلّمة بأنها غير حاكمة لكنها ما زالت قابلة لإحداث document drift عند القراءة غير المنضبطة. | متوسطة | [نموذج السلطة][13]، [الحالة المؤرشفة][14] | أُدير جزئيًا |

## Repairs Performed

تم إنشاء فرع إصلاح مستقل دون تعديل أو حذف أو إعادة كتابة تاريخ `main`. الإصلاحات الآمنة المنفذة هي الآتية:

أولًا، تم تصحيح indentation لكتل JavaScript متعددة الأسطر داخل `create-issue.yml` و`pr-comment.yml`، وإزالة trailing whitespace. تحققت جميع ملفات GitHub Actions البالغ عددها 23 ملفًا من خلال محلل YAML محلي، ولم يعد هناك أي parse failure. هذا التغيير مطابق حرفيًا لفروع إصلاح مفتوحة، ولذلك لا ينبغي إنشاء مسار موازٍ له؛ ينبغي اختيار PR واحد، مراجعته، ثم إغلاق النسخ المتكررة بعد إثبات التطابق.

ثانيًا، تم استبدال placeholder hash في حركات تحويل المخزون باستدعاء `compute_movement_hash`، مع تمرير hash الحركة السابقة فعليًا إلى الحركة التالية. أضيفت assertions تثبت أن كل حركة تحمل hash غير فارغ، وأن السلسلة متصلة، وأن hash كل حركة يساوي ناتج الحساب الحتمي.

ثالثًا، تم جعل Trial Balance يستهلك القيود المرحّلة فقط (`EntryStatus::Posted`) وإضافة اختبار يثبت أن المسودة المتزنة لا تؤثر في التقرير. هذا حارس دفاعي داخل طبقة التقرير ولا يعالج وحده مشكلة مصدر الحقيقة في طبقة الكتابة.

لم تُنفذ تغييرات عالية الخطورة على مسار السلطة المحاسبية، أو معرفات مخطط Isar، أو دمج/إغلاق/حذف PRs، لأن ذلك يحتاج قرارًا معماريًا ومالكًا واضحًا ودليل parity وقرارًا صريحًا قبل التأثير في البيانات أو `main`.

## Test and CI Evidence

| الفحص | النتيجة |
|---|---|
| Flutter dependencies باستخدام Flutter `3.44.9` / Dart `3.12.2` | ناجح |
| `flutter analyze` | ناجح: `No issues found!` |
| `flutter test --no-pub` | ناجح: **1571 اختبارًا ناجحًا، اختبار واحد متخطى** |
| Dart formatting على `lib` و`test` | ناجح: 775 ملفًا، 0 تغييرات |
| YAML workflow parse | ناجح بعد الإصلاح: 23/23 |
| `cargo fmt --all -- --check` | ناجح |
| `cargo clippy --workspace --all-targets --all-features --locked -- -D warnings` | ناجح |
| `cargo test --workspace --all-targets --all-features --locked` مع PostgreSQL محلي وتطبيق migrations | ناجح، بما في ذلك اختبار `accounting_data` |
| `flutter build web --release` | فشل: 94 خطأ JavaScript-safe-integer في مصادر Isar المولّدة |
| `flutter build apk --debug` | تعذر الإثبات محليًا: Android SDK غير مثبت |

نجاح الاختبارات أعلاه يثبت السلوك الذي تغطيه الاختبارات فقط. لا يثبت أن Dart posting path أصبح تابعًا للـRust/Postgres ledger، ولا يثبت migration parity على بيانات واقعية معقمة، ولا يثبت نجاح artifact Web أو Android في بيئة إنتاجية.

## Remaining Risks and Required Decisions

الخطر الأهم هو استمرار مسار محاسبي محلي بديل عن السلطة المركزية المقترحة. الإصلاح الصحيح ليس إضافة شرط شكلي إلى الواجهة، بل اعتماد boundary واحد متكامل: command، authorization، idempotency، transaction، immutable receipt، ثم cache محلي لا ينشئ `Posted` fact من تلقاء نفسه. يوجد PR مخصص لهذا الاتجاه، لكنه واسع وعالي الخطورة ويحتاج مراجعة معمارية وبيانات اختبار قبل الدمج [15].

الخطر الثاني هو Web build. يجب اختيار أحد تصميمين موثقين: إما دعم Web فعليًا مع استراتيجية schema آمنة لا تغيّر هوية Isar القائمة دون migration، أو إعلان أن Web غير مدعوم وإزالة claims/jobs الخاصة به. لا يجوز ترقيع الأرقام المولّدة يدويًا.

الخطر الثالث هو migration parity. لا توجد على `main` أدلة كافية تربط snapshot معقمًا واقعيًا بنتائج Isar وDrift المتطابقة، خصوصًا Inventory وStock Movements. يجب أن تكون بوابة الانتقال fail-closed، وأن تتضمن fixtures معقمة ذات provenance، وعدًّا ومجموعًا وتوقيعًا وحالة rollback قابلة للإثبات.

الخطر الرابع هو مستودع Git نفسه. PRs ذات قواعد أساسية قديمة أو فروع مبنية على فروع وسيطة لا يمكن دمجها عميانيًا. يجب على مالك المستودع اعتماد مصفوفة قرار: `merge`, `rebase`, `superseded`, `obsolete`, `blocked`, أو `close-after-evidence`، ثم تنفيذ الدمج بترتيب dependency graph. لم تُنفذ عمليات destructive في هذا التدقيق.

## Evidence and Reconciliation

تم تثبيت نقطة القياس على `main` عند SHA `740328f5d994b554b102d59b8203a25109db6e58`. قبل الإصلاحات كان العمل نظيفًا ومتزامنًا مع `origin/main`. تم الاحتفاظ بالإصلاحات على فرع مستقل باسم `audit/production-readiness-20260826`، وأصبح نطاق التعديل محصورًا في أربعة ملفات: ملفا CI، وملف خدمة تحويل المخزون، وملف Trial Balance، إضافة إلى هذا التقرير.

التحقق المحاسبي أثبت أن Rust core يمرر invariants المغطاة، وأن PostgreSQL schema migrations قابلة للتطبيق على قاعدة اختبار محلية وأن اختبار persistence ينجح. لكنه كشف في الوقت نفسه أن التطبيق الفعلي في Dart لا يمر عبر هذه السلطة؛ لذلك لا يجوز تحويل نجاح Rust إلى claim عن النظام الكامل.

## Final GO / NO-GO

> **القرار: NO-GO للإنتاج.**

لا تبرر الأدلة الحالية إعلان `GO`، لأن بوابتين حرجتين غير متحققتين: **مصدر الحقيقة المحاسبي الموحد** و**قابلية بناء Web/إثبات منصات الإنتاج**، إضافة إلى غياب parity واقعية مثبتة لـIsar → Drift. الإصلاحات الآمنة المنفذة حسّنت سلامة سلسلة المخزون وحصانة التقارير وصحة YAML، لكنها لا تلغي هذه الموانع.

الانتقال إلى `GO` يتطلب على الأقل اعتماد boundary Ledger واحد ودمج اختباره طرفيًا، إثبات parity على snapshot معقم واقعي للمخزون وحركاته، حلًا معتمدًا لمعرفات Isar في Web أو إعلان دعم المنصة، تشغيل artifacts Android/Web من CI على SHA محدد، ثم إغلاق أو دمج جميع PRs المهمة وفق مصفوفة قرار موثقة.

## References

[1]: https://github.com/mohammed-murad-alqabal/Basir_accounting/pulls "Basir Accounting — Pull Requests"
[2]: https://github.com/mohammed-murad-alqabal/Basir_accounting/blob/main/lib/features/accounting/application/accounting_service.dart "AccountingService posting path"
[3]: https://github.com/mohammed-murad-alqabal/Basir_accounting/blob/main/lib/features/accounting/data/repositories/accounting_repository_impl.dart "Isar accounting repository"
[4]: https://github.com/mohammed-murad-alqabal/Basir_accounting/blob/main/lib/features/invoices/data/repositories/isar_sales_invoice_posting_gateway.dart "Isar sales invoice posting gateway"
[5]: https://github.com/mohammed-murad-alqabal/Basir_accounting/pull/154 "PR #154 — restore create-issue workflow YAML"
[6]: https://github.com/mohammed-murad-alqabal/Basir_accounting/pull/155 "PR #155 — restore PR comment workflow YAML"
[7]: https://github.com/mohammed-murad-alqabal/Basir_accounting/blob/main/lib/features/inventory/data/models/inventory_item_model.g.dart "Generated Isar inventory schema"
[8]: https://github.com/mohammed-murad-alqabal/Basir_accounting/blob/main/rust/crates/accounting_core/src/inventory/transfer_service.rs "Warehouse transfer service"
[9]: https://github.com/mohammed-murad-alqabal/Basir_accounting/blob/main/rust/crates/accounting_core/src/inventory/chain.rs "Inventory hash-chain verification"
[10]: https://github.com/mohammed-murad-alqabal/Basir_accounting/blob/main/rust/crates/accounting_core/src/reporting/trial_balance.rs "Rust Trial Balance generator"
[11]: https://github.com/mohammed-murad-alqabal/Basir_accounting/blob/main/lib/features/inventory/data/repositories/stock_movement_repository_impl.dart "Active Isar stock-movement repository"
[12]: https://github.com/mohammed-murad-alqabal/Basir_accounting/pull/159 "PR #159 — stock movements Drift storage"
[13]: https://github.com/mohammed-murad-alqabal/Basir_accounting/blob/main/docs/00-governance/AUTHORITY_MODEL.md "Active authority model"
[14]: https://github.com/mohammed-murad-alqabal/Basir_accounting/blob/main/.kiro/FINAL_STATUS.md "Archived historical status document"
[15]: https://github.com/mohammed-murad-alqabal/Basir_accounting/pull/17 "PR #17 — authoritative ledger authority boundary"
