# مراجع Supabase الرسمية المستخدمة في خطة طبقة البيانات

## Database migrations

المصدر: [Database migrations](https://supabase.com/docs/guides/local-development/database-migrations).

توصي Supabase بالعمل محليًا، حفظ migrations في version control، تطبيقها على قاعدة محلية للاختبار، ثم ربط المشروع البعيد ودفع migrations بعد اتساق السجل. عند وجود تغييرات بعيدة غير ممثلة محليًا، يسبق الدفع استخدام `db pull` ثم `db reset` للتحقق من الاتساق. وبما أن مشروع Basir لا يملك جداول أو migrations بعد، فالمسار الصحيح يبدأ من migrations محلية قابلة للمراجعة، لا من SQL مباشر في Dashboard.

## Row Level Security

المصدر: [Row Level Security](https://supabase.com/docs/guides/database/postgres/row-level-security).

تؤكد الوثائق أن الجداول في schema مكشوفة مثل `public` يجب أن تكون محمية بـRLS، وأن `auth.uid()` يعيد `null` للطلب غير المصادق. كما تميز سياسات `USING` للصفوف الحالية عن `WITH CHECK` للصفوف الجديدة/المعدلة، وتوضح أن UPDATE يحتاج سياسة SELECT مقابلة لكي يعمل كما هو متوقع. لذلك يجب أن تكون سياسات Basir معزولة حسب `organization_id`، مع تحقق عضوية صريح وسياسات insert/update/delete منفصلة أو موثقة، لا مجرد فلترة من جانب Flutter.

## نتيجة تطبيق المراجع على Basir

| المبدأ | أثره على المشروع |
|---|---|
| migrations versioned | إنشاء `supabase/migrations/` داخل Git قبل أي تطبيق خارجي |
| local reset/test first | فحص SQL محليًا ثم اختبار RLS على development branch |
| RLS for exposed tables | عدم إنشاء جدول أعمال دون `enable row level security` وسياسات موثقة |
| `USING` + `WITH CHECK` | منع نقل صف إلى منظمة أخرى عبر UPDATE، وليس فقط منع القراءة العابرة |
| auth-based authorization | عدم الاعتماد على `user_id` أو `kIsWeb` كحد أمني وحيد |

## Backups and recovery

المصدر: [Database Backups](https://supabase.com/docs/guides/platform/backups).

توضح الوثائق أن سياسة النسخ تختلف حسب الخطة؛ وتوصي مشاريع Free بالتصدير المنتظم عبر Supabase CLI وحفظ النسخ خارج الموقع. كما أن النسخ الاحتياطية لا تتضمن ملفات Storage نفسها، بل metadata فقط، وأن الاستعادة تجعل المشروع غير متاح أثناء العملية. لذلك يجب أن تتضمن طبقة Basir خطة نسخ SQL/Storage منفصلة، واختبار استعادة دوري، وقرارًا صريحًا بشأن خطة Supabase قبل تخزين بيانات محاسبية تشغيلية.

## أثر ذلك على قرار البدء

يمكن البدء الآن في **التصميم، migrations المحلية، واختبارات RLS**. لا يُنصح بعد بتحميل بيانات حقيقية أو ربط شاشات الإنتاج أو تطبيق migrations على المشروع الرئيسي قبل تثبيت خطة النسخ والاستعادة، وتحديد بيئة development، ومراجعة SQL، واستكمال عزل المستأجرين.
