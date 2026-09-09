# تحقق موجة Drift: Goals وBudgets

## النطاق

تضيف هذه الموجة جداول Drift وDAOs ومكيّفات تجريبية لـ`Goal` و`Budget`. لا تُسجل المكيّفات في Providers، ولا تغيّر Isar أو بياناته، ولا تضيف importer أو parity أو shadow-read لهذه الكيانات بعد. لذلك يبقى Isar مصدر القراءة والكتابة الفعلي.

## المخطط

ترفع الحزمة `schemaVersion` من 3 إلى 4 وتضيف جدولي `goals` و`budgets`. تستخدم الجداول مفتاحًا مركبًا من `scopeKey` ومعرف الكيان، ما يمنع اختلاط مستخدمين ويتيح UUID متطابقًا داخل نطاقات مختلفة. تُحفظ المبالغ المالية في أعمدة نصية، كما في Isar، وتُستخدم حزمة `decimal` لتحديث تقدم الهدف دون تحويله إلى `double`.

| الجدول | المفتاح | الحقول المالية | قواعد النطاق |
|---|---|---|---|
| `goals` | `scopeKey + uuid` | `targetAmount`, `currentAmount` كنص | كل قراءة وتحديث وحذف مقيد بـ`scopeKey` |
| `budgets` | `scopeKey + budgetId` | `limitAmount`, `spentAmount` كنص، `alertThreshold` كـreal | كل قراءة وحذف واستبدال مقيد بـ`scopeKey` |

## الفروق الآمنة عن Isar الحالي

المستودع الحالي يسمح عند غياب `userId` بإرجاع سجلات جميع المستخدمين، كما أن بعض عمليات القراءة والحذف بالمعرف لا تعيد فرض النطاق. عقد Drift الجديد يتعمد منع ذلك: `null` يمثل نطاقًا مجهولًا مستقلًا، وليس wildcard. هذا تشديد أمني مقصود، ولا يُفعّل تشغيلًا قبل مراجعة parity حتى لا يخفي اختلافًا دلاليًا.

يبقى active filtering في `GoalService` و`BudgetService` خارج التخزين. ويستمر `updateGoalProgress` في جمع Decimal داخل طبقة التخزين مع حفظ النتيجة كنص.

## التحقق المنفذ

| المجال | النتيجة |
|---|---|
| code generation | نجح بعد إضافة schema v4 |
| تحليل الحزمة والمكيّفات | بلا ملاحظات مستهدفة |
| DAO على SQLite في الذاكرة | اختبار عزل المستخدم، upsert، الحذف، وتحديث Decimal نجح |
| مكيّفات التطبيق | اختبار فرض userId وتحويل enum وDecimal نجح |
| Providers | تحقق مباشر من بقاء `IsarBudgetRepository` و`IsarGoalRepository` في المسار النشط |

## ما لم يُنفذ بعد

لم تُضف importer أو parity أو snapshot أو shadow-read لهذه الموجة. يجب تنفيذها قبل أي flag أو cutover، مع اختبار خاص لاختلاف دلالة `userId = null` بين Isar الحالي وDrift الآمن.
