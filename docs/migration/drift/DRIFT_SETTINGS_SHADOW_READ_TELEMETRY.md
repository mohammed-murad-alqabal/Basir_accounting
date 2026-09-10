# Telemetry للـShadow-Read في موجة الإعدادات

## الهدف

يوفر `DriftSettingsShadowReadComparator` طبقة تشخيصية قابلة للحقن لمقارنة قراءة Isar بقراءة Drift من دون تغيير القيمة التي يراها المستخدم. هذه الطبقة ليست Provider ولا تُستدعى تلقائيًا، ولذلك لا تغيّر مسار التطبيق الحالي.

## نموذج الحدث

| الحقل | المعنى | سياسة البيانات |
|---|---|---|
| `slice` | `profiles` أو `business-settings` | قيمة ثابتة غير حساسة |
| `operation` | اسم عملية القراءة مثل `getProfile` | اسم معلن مسبقًا فقط |
| `outcome` | `match` أو `mismatch` أو `sourceError` أو `candidateError` | لا يحتوي رسالة استثناء |
| `recordedAt` | وقت الحدث UTC | وقت تشخيصي فقط |

لا يحتوي الحدث على `userId` أو entity payload أو fingerprint أو نص الخطأ. يجب أن يبقى أي sink شبكي لاحقًا محدودًا بهذه الحقول، مع sampling وrate limit ومراجعة خصوصية قبل الربط بمراقبة خارجية.

## السلوك

يستدعي comparator المصدر أولًا ثم المرشح. إذا فشل المصدر يسجل `sourceError` ولا يستدعي المرشح، وإذا فشل المرشح يسجل `candidateError`. غياب السجل في الطرفين يعد تطابقًا؛ ووجوده في طرف واحد أو اختلاف أي حقل يعد `mismatch`. لا يعيد comparator قيمة المرشح إلى caller ولا يسمح له باستبدال القراءة النشطة.

## بوابات التفعيل

1. تشغيله أولًا في اختبارات التكامل وعلى لقطة بيانات معقمة، مع `InMemoryDriftShadowReadSink` أو sink محلي.
2. بعد مراجعة الخصوصية، يمكن ربط sink بعداد مراقبة داخلي لا يسجل payload.
3. يبدأ shadow-read على repository واحد وبنسبة sampling منخفضة، مع بقاء Isar مصدر النتيجة.
4. يوقف canary عند أي `mismatch` أو `sourceError` أو `candidateError` متكرر، ولا يتحول Drift إلى primary بناءً على telemetry وحدها.

## التحقق الحالي

تغطي الاختبارات التطابق، الاختلاف، غياب السجل في الطرفين، وفشل كل من المصدر والمرشح، وتثبت أن الحدث لا يملك حقول payload أو userId. لا يوجد تسجيل للـcomparator في Providers الحالية ضمن هذه المرحلة.
