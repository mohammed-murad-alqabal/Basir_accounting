# Runbook: Drift Goals وBudgets Snapshot

## الغرض والنطاق

يتيح هذا المسار التحقق من importer وparity لموجة **Goals وBudgets** على لقطة بيانات معقمة، من دون فتح قاعدة Isar التشغيلية أو تغيير Providers التطبيق أو تفعيل أي كتابة Drift في الإنتاج. ينشئ runner قاعدة SQLite مؤقتة داخل الذاكرة، يستورد السجلات على دفعات، يشغّل parity، ثم يغلق القاعدة في مسار `finally`.

> هذا المسار أداة قبول offline، وليس مسار ترحيل إنتاجي ولا آلية cutover تلقائية.

## حدود الأمان

يجب أن تكون اللقطة نسخة معقمة صراحةً، وأن تحتوي على معرفات pseudonymized لا يمكن ربطها بمستخدم حقيقي، وألا تحتوي على كلمات مرور أو رموز وصول أو أسرار أو payloads غير لازمة. لا تُرفع اللقطة إلى Git أو إلى issue أو إلى artifact عام. يبقى `Isar` مصدر التنفيذ الفعلي، ولا يستدعي runner أي Provider نشط.

| الضمان | السلوك |
|---|---|
| عزل قاعدة البيانات | `NativeDatabase.memory()` فقط؛ لا يوجد ملف SQLite دائم |
| مصدر البيانات | JSON معقم يمر عبر parser typed قبل الاستيراد |
| الكتابة | إلى SQLite المؤقتة فقط؛ لا كتابة إلى Isar أو Supabase |
| الاستمرارية | لا يحتفظ runner باللقطة أو القاعدة بعد الإغلاق |
| الخصوصية في التقرير | counts وbooleans فقط؛ لا userId ولا payload ولا رسائل استثناء |
| قرار القبول | لا قبول إلا عند `clean: true` وصفر ambiguous scopes |

## عقد اللقطة، الإصدار 1

يجب أن يكون الجذر JSON object، وأن يحتوي على `sanitized: true` و`schemaVersion: 1` ومجموعتي `goals` و`budgets`. يحتفظ importer بقيم Decimal كنص حتى لا تُفقد الدقة، ويحوّل التواريخ إلى UTC. يجب أن تكون الحقول الإلزامية موجودة وبالأنواع الصحيحة.

| المجموعة | الحقول المطلوبة |
|---|---|
| `goals` | `id`, `name`, `category`, `targetAmount`, `currentAmount`, `startDate`, `targetDate`, `isActive` |
| `goals` الاختيارية | `description`, `userId` |
| `budgets` | `id`, `name`, `category`, `limitAmount`, `spentAmount`, `startDate`, `endDate`, `alertThreshold`, `isRollover`, `isActive` |
| `budgets` الاختيارية | `userId` |

يجب أن تكون حقول المبالغ النصية قابلة للتحليل بواسطة `Decimal.parse`، وأن يكون `alertThreshold` رقمًا finite، وأن تكون التواريخ قابلة للتحليل. يمنع parser القيم الناقصة أو الأنواع غير الصحيحة قبل إنشاء قاعدة SQLite.

مثال مختصر غير صالح للاستخدام الإنتاجي:

```json
{
  "sanitized": true,
  "schemaVersion": 1,
  "goals": [
    {
      "id": "goal-a",
      "name": "Emergency fund",
      "category": "emergencyFund",
      "targetAmount": "100.00",
      "currentAmount": "12.50",
      "startDate": "2026-01-01T00:00:00Z",
      "targetDate": "2026-12-31T00:00:00Z",
      "isActive": true,
      "description": "sanitized fixture",
      "userId": "scope-a"
    }
  ],
  "budgets": []
}
```

## التشغيل

من جذر المستودع، يُشغّل operator الأمر التالي بعد مراجعة أن الملف محلي ومُعقم:

```bash
dart run tool/run_drift_goals_budgets_snapshot.dart /secure/local/goals_budgets_snapshot.json
```

يكتب CLI تقرير JSON مختصرًا إلى stdout. في حالة خطأ الاستخدام يعيد exit code `64`، وفي حالة فشل القراءة أو التحقق أو الاستيراد يعيد exit code غير صفري ويطبع نوع الخطأ فقط. لا يعتمد التشغيل على اتصال شبكة أو جلسة مستخدم.

## تفسير التقرير وبوابات القبول

يُعد التشغيل ناجحًا فقط عندما تكون `clean` مساوية لـ`true`، وتكون migration مكتملة لكل من Goals وBudgets، وتكون parity مطابقة، وتكون عدادات ambiguous scopes مساوية للصفر. لا يكفي تساوي counts وحدها؛ إذ يعتمد parity أيضًا على fingerprint حتمي للحقول بعد الترتيب حسب scope ثم id.

| النتيجة | القرار |
|---|---|
| `clean: true`، parity للشريحتين مطابقة، ambiguous = 0 | يمكن رفع تقرير القبول للمراجعة البشرية فقط |
| mismatch في Goals أو Budgets | إيقاف الموجة والتحقيق في mapping أو البيانات |
| ambiguous scope count أكبر من صفر | إيقاف الموجة؛ لا يُسمح بقراءة canary |
| migration غير مكتملة | إيقاف الموجة وفحص checkpoint والـbatch size |
| parser أو Decimal أو date error | رفض اللقطة وإعادة توليدها معقمة |

حتى مع تقرير نظيف، لا يفعّل هذا المسار shadow-read تلقائيًا ولا يبدّل `driftRolloutStageProvider`. تظل flags الخاصة بـGoals وBudgets مغلقة، وتبقى Isar مصدر القراءة والكتابة، إلى أن تُراجع اللقطة وتُعتمد بوابة مستقلة.

## التعامل مع الفشل وإعادة التشغيل

لا ينفذ runner إصلاحًا تلقائيًا ولا يحذف أي سجل. عند mismatch، يحتفظ operator بالخطأ التشغيلي دون نشر اللقطة، ويراجع mapping والـschema والـscope والعلامات الزمنية. يمكن إعادة التشغيل بعد تصحيح نسخة اللقطة؛ لأن كل تشغيل يستخدم SQLite جديدة داخل الذاكرة ولا يترك checkpoint دائمًا.

عند ظهور ambiguous scope، لا ينبغي حل المشكلة بتغيير معرفات المصدر عشوائيًا. يجب أولًا إثبات أن التكرار متوقع ومفهوم في نموذج النطاق، ثم تحديث عقد الموجة والاختبارات في تغيير مستقل. لا يُسمح بالانتقال إلى canary أو الكتابة في Drift قبل إغلاق هذه الحالة بمراجعة بشرية.

## الأدلة المطلوبة قبل التقدم

يُحفظ تقرير stdout بعد إزالة أي مسار محلي حساس، مع نتيجة الاختبارات الخاصة بالـsnapshot وshadow-read، وcommit diff للمراجعة. لا تُحفظ اللقطة الخام في المستودع. بعد اعتماد التقرير فقط يمكن إعداد خطة canary مستقلة؛ ولا يتضمن هذا runbook أي merge أو push أو تغيير مباشر في الفرع الأساسي.
