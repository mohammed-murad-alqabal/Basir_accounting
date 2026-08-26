# سجل تسوية طلبات الدمج إلى `main`

> هذا السجل ناتج عن لقطة GitHub مقروءة في 2026-08-26 UTC. لا ينفذ إغلاقًا أو دمجًا أو تعليقًا خارجيًا، ويجعل لكل PR قرارًا مبدئيًا قابلًا للمراجعة.

| PR | الفئة | Draft | Mergeable | حالة الدمج | Ahead | Behind | الملفات | القرار المبدئي |
|---:|---|:---:|---|---|---:|---:|---:|---|
| 11 | Dependencies | لا | MERGEABLE | BEHIND | 1 | 7 | 10 | DEPENDENCY_REVIEW_REQUIRED |
| 12 | Dependencies | لا | MERGEABLE | BEHIND | 1 | 7 | 10 | DEPENDENCY_REVIEW_REQUIRED |
| 14 | Accounting authority / security | لا | CONFLICTING | DIRTY | 4 | 192 | 492 | BLOCKED_HIGH_RISK_ARCHITECTURE_REVIEW |
| 17 | Accounting authority / security | لا | CONFLICTING | DIRTY | 13 | 178 | 486 | BLOCKED_HIGH_RISK_ARCHITECTURE_REVIEW |
| 38 | Baseline / generated sources | نعم | CONFLICTING | DIRTY | 2 | 169 | 406 | BASELINE_REBASE_REQUIRED |
| 52 | Baseline / generated sources | نعم | CONFLICTING | DIRTY | 5 | 163 | 264 | BASELINE_REBASE_REQUIRED |
| 59 | Storage / migration | نعم | MERGEABLE | BEHIND | 1 | 157 | 371 | BLOCKED_MIGRATION_PARITY_REQUIRED |
| 83 | Baseline / generated sources | نعم | CONFLICTING | DIRTY | 6 | 152 | 239 | BASELINE_REBASE_REQUIRED |
| 98 | Baseline / generated sources | نعم | CONFLICTING | DIRTY | 1 | 152 | 356 | BASELINE_REBASE_REQUIRED |
| 124 | Product / inventory | لا | CONFLICTING | DIRTY | 4 | 129 | 330 | FEATURE_REVIEW_AFTER_BASELINE |
| 127 | Baseline / generated sources | نعم | CONFLICTING | DIRTY | 1 | 128 | 196 | BASELINE_REBASE_REQUIRED |
| 142 | Storage / migration | نعم | CONFLICTING | DIRTY | 4 | 124 | 203 | BLOCKED_MIGRATION_PARITY_REQUIRED |
| 150 | CI / workflow | لا | MERGEABLE | BEHIND | 3 | 7 | 25 | SEPARATE_AND_REBASE |
| 151 | Dependencies | لا | MERGEABLE | BEHIND | 1 | 7 | 11 | SEPARATE_AND_REBASE |
| 152 | Other | لا | MERGEABLE | BEHIND | 1 | 7 | 11 | SEPARATE_AND_REBASE |
| 153 | Other | لا | MERGEABLE | BEHIND | 1 | 7 | 10 | SEPARATE_AND_REBASE |
| 154 | CI / workflow | لا | MERGEABLE | BEHIND | 1 | 7 | 10 | REVIEW_DUPLICATE_CI_FAMILY |
| 155 | CI / workflow | لا | MERGEABLE | BEHIND | 2 | 3 | 4 | REVIEW_DUPLICATE_CI_FAMILY |
| 161 | Storage / migration | نعم | MERGEABLE | BEHIND | 2 | 1 | 10 | BLOCKED_MIGRATION_PARITY_REQUIRED |
| 162 | UI foundation | نعم | MERGEABLE | BEHIND | 12 | 1 | 16 | FEATURE_REVIEW_AFTER_BASELINE |
| 164 | CI / workflow | نعم | CONFLICTING | DIRTY | 33 | 163 | 401 | REBASE_OR_CLOSE_AFTER_165 |
| 165 | CI / workflow | لا | MERGEABLE | BLOCKED | 1 | 0 | 2 | CANONICAL_CI_CANDIDATE |
| 167 | Accounting authority / security | لا | MERGEABLE | BLOCKED | 11 | 0 | 30 | BLOCKED_HIGH_RISK_ARCHITECTURE_REVIEW |
| 168 | Dependencies | لا | MERGEABLE | BLOCKED | 1 | 0 | 2 | DEPENDENCY_REVIEW_REQUIRED |
| 169 | Dependencies | لا | MERGEABLE | BLOCKED | 1 | 0 | 2 | DEPENDENCY_REVIEW_REQUIRED |
| 170 | Dependencies | لا | MERGEABLE | BLOCKED | 1 | 0 | 2 | DEPENDENCY_REVIEW_REQUIRED |
| 171 | Dependencies | لا | MERGEABLE | BLOCKED | 1 | 0 | 2 | DEPENDENCY_REVIEW_REQUIRED |
| 172 | Other | لا | MERGEABLE | BLOCKED | 3 | 0 | 6 | SEPARATE_AND_REBASE |
| 173 | CI / workflow | لا | MERGEABLE | BLOCKED | 1 | 0 | 2 | SUPERSEDED_BY_165 (exact diff hash) |
| 174 | Accounting authority / security | لا | MERGEABLE | BLOCKED | 3 | 0 | 4 | BLOCKED_HIGH_RISK_ARCHITECTURE_REVIEW |
| 175 | Accounting authority / security | لا | MERGEABLE | BLOCKED | 5 | 0 | 27 | BLOCKED_HIGH_RISK_ARCHITECTURE_REVIEW |

## نتائج مثبتة

إجمالي الطلبات: **31**. عدد الطلبات المتعارضة بحسب GitHub: **10**. عدد الطلبات Draft: **10**. عدد الطلبات التي تحتاج مراجعة: **31**.

الطلبان **#165 و#173 متطابقان تمامًا** بالنسبة إلى `origin/main`؛ بصمة diff SHA-256 لهما هي `880103d866b006bbf2b81bcbb3f7b73b0f5cf02f2280617e31915dc0a2cdbc92`. لذلك يُقترح اعتماد #165 كمرشح canonical، وإغلاق #173 لاحقًا بوصفه superseded فقط بعد مراجعة مالك المستودع ونجاح البوابات.

وجود `MERGEABLE` لا يعني أن PR جاهز للدمج؛ فجميع الطلبات تحتاج مراجعة وموافقة قبل الدمج.

## قاعدة التنفيذ

لا يُسمح بالدمج المباشر من هذا السجل. لكل صف يجب تنفيذ مراجعة diff، التحقق من الفحوصات، التأكد من عدم التكرار، ثم موافقة المالك. PRs `BLOCKED_HIGH_RISK_ARCHITECTURE_REVIEW` و`BLOCKED_MIGRATION_PARITY_REQUIRED` لا تُدمج آليًا لأنها تمس سلطة القيود أو schema/بيانات الانتقال.

## ملاحظة عن الدمج الآمن

الخطوة الآمنة التالية هي إنشاء PR تكاملية واحدة لكل عائلة متداخلة، لا دمج 31 PR مستقلة. يبدأ المسار بمرشح CI واحد، ثم baseline، ثم الاعتماديات، ثم الميزات، ثم السلطة المحاسبية، ثم migration/parity. بعد كل merge يُعاد توليد هذا السجل وتُمنع القرارات المبنية على لقطة قديمة.

## تنفيذ آمن مكتمل

تم إنشاء فرع تكاملي محلي غير تدميري باسم `reconcile/ci-yaml-canonical` من `origin/main`، ثم تطبيق رأس PR **#165** فقط. النتيجة: جميع ملفات workflows البالغ عددها 23 ملفًا اجتازت تحقق YAML، ونجح `flutter analyze`، ونجح `flutter test --no-pub` بنتيجة 1571 اختبارًا ناجحًا واختبار واحد متخطى. بقي الفرع محليًا ولم يُرفع إلى GitHub لأنه نسخة تحقق فقط؛ أما PR #165 نفسها فتبقى المرشح canonical للدمج.

الطلب **#173** ليس مجرد طلب مشابه؛ بل ثبت أن diff الخاص به مطابق تمامًا لـ#165 ببصمة SHA-256 التالية: `880103d866b006bbf2b81bcbb3f7b73b0f5cf02f2280617e31915dc0a2cdbc92`. لا ينبغي إغلاقه أو دمج أي منهما قبل موافقة مالك المستودع على اعتماد #165 كنسخة وحيدة.
