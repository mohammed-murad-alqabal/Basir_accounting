# Supabase Deployment and Recovery Runbook

## الهدف

يحدد هذا الدليل دورة تشغيل طبقة البيانات السحابية لـBasir Accounting من التطوير المحلي إلى بيئة التطوير ثم الإنتاج، مع منع التعديل المباشر غير القابل للتتبع.

## البيئات

| البيئة | الغرض | البيانات | طريقة التغيير |
|---|---|---|---|
| Local | parsing وdb reset وpgTAP | اصطناعية فقط | migrations محلية |
| Development branch/project | اختبار RLS وDTO وWeb adapter | بيانات اختبار معزولة | `db push` بعد موافقة المرحلة |
| Staging | اختبار التكامل وreconciliation | نسخة منقحة/اختبارية | PR + CI + موافقة مراجعين |
| Production | التشغيل | بيانات حقيقية | نافذة تغيير، backup، rollback plan، موافقة المالك |

## بوابة ما قبل التطبيق

لا يطبق أي migration إذا لم تتوافر: نسخة Git محددة، نتيجة `db reset` ناجحة، نتيجة اختبارات RLS ناجحة، مراجعة SQL، فحص عدم وجود أسرار، خطة rollback، وتحديد الشخص المخول بالموافقة. لا تستخدم `service_role` داخل تطبيق Flutter؛ يبقى client access عبر publishable/anon key مع RLS.

## مسار التطوير المحلي

بعد تثبيت Supabase CLI وDocker، شغل `supabase start` ثم `supabase db reset` لتطبيق migrations من الصفر. شغل `supabase test db` لاختبارات pgTAP، ثم نفذ اختبارات Flutter للـDTO والـrepository. إذا كان التغيير غير متوافق مع إعادة البناء، لا تُستخدم `db diff` لإخفاء المشكلة؛ أصلح migration نفسها أو أنشئ migration تصحيحية جديدة.

## مسار development

اربط نسخة محلية بمشروع/فرع تطوير منفصل، اسحب أي schema بعيدة أولًا بواسطة `supabase db pull` فقط إذا وجدت تغييرات غير ممثلة، ثم راجع الناتج. بعد موافقة صريحة، استخدم `supabase db push` على development فقط. نفذ اختبارات مستخدمين من منظمتين مختلفتين، واختبر الوصول المسموح والممنوع، وتغيير العضوية، وحماية آخر owner.

## مسار production

لا يبدأ cutover قبل نجاح development وstaging. خذ نسخة database وصدّر Storage metadata والملفات بحسب سياسة المشروع. طبّق migrations في نافذة تغيير محددة، راقب logs وadvisors، ونفذ smoke tests. لا تُعتبر migration قابلة للتراجع لمجرد وجود `down.sql`: بعض تغييرات البيانات غير قابلة للعكس؛ لذلك يجب اعتماد expand/contract وbackfill قابل لإعادة التشغيل.

## الاستعادة

عند فشل migration: أوقف الإصدارات التي تكتب إلى الجداول المتأثرة، احفظ logs، لا تحذف الجداول لتجاوز الخطأ، وقرر بين migration تصحيحية أو restore بعد تقييم فقد البيانات. أي restore قد يسبب downtime ويحتاج خطة اتصالات. ملفات Storage لا تعود تلقائيًا من backup قاعدة البيانات، لذلك تحفظ استراتيجية Storage مستقلة.

## مراقبة ما بعد التطبيق

راقب أخطاء API، معدلات رفض RLS، latency، حالات تعارض المزامنة، وفروقات reconciliation. سجل version migration وcommit SHA في تقرير التغيير. لا تُغلق PR إلا بعد أن تكون فحوص CI وتدقيق البيانات قابلة لإعادة الإنتاج.

## المراجع

[1] [Supabase Database migrations](https://supabase.com/docs/guides/local-development/database-migrations)
[2] [Supabase Database Backups](https://supabase.com/docs/guides/platform/backups)
[3] [Supabase Row Level Security](https://supabase.com/docs/guides/database/postgres/row-level-security)
