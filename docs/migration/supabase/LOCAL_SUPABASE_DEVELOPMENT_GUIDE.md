# دليل تطوير Supabase المحلي لـBasir Accounting

يوثق هذا الدليل كيفية تشغيل واختبار طبقة البيانات السحابية محليًا باستخدام Supabase CLI، لضمان سلامة migrations وسياسات RLS قبل دفعها إلى المشروع البعيد.

## المتطلبات الأساسية

1. **Docker Desktop:** مطلوب لتشغيل حاويات PostgreSQL وSupabase.
2. **Supabase CLI:** أداة الإدارة الرئيسية.
3. **pgTAP:** (اختياري) لتشغيل اختبارات SQL البنيوية.

## دورة التطوير الآمنة

تعتمد الدورة على مبدأ "الاختبار المحلي أولًا":

1. **التهيئة:** `supabase init` (تمت تهيئة مجلد `supabase/` بالفعل في هذا الفرع).
2. **بدء البيئة:** `supabase start`. سيقوم هذا الأمر بتشغيل قاعدة بيانات PostgreSQL محلية وتطبيق جميع migrations الموجودة في `supabase/migrations/`.
3. **إضافة تغيير:** أنشئ migration جديدة عبر `supabase migration new <name>`.
4. **التحقق والتحسين:** عدل ملف SQL في `supabase/migrations/` ثم نفذ `supabase db reset` لإعادة بناء القاعدة من الصفر والتحقق من صحة السجل.
5. **اختبار RLS:** ضع اختباراتك في `supabase/tests/` ونفذها عبر `supabase test db`.

## هيكل المجلدات

| المسار | الغرض |
|---|---|
| `supabase/migrations/` | سجل التغييرات البنيوية (Versioned SQL). |
| `supabase/tests/` | اختبارات pgTAP للتحقق من الجداول والسياسات والوظائف. |
| `supabase/config.toml` | إعدادات المنافذ والخدمات المحلية (لا تحتوي أسرارًا). |
| `supabase/seed.sql` | بيانات أولية للاختبار المحلي فقط. |

## أوامر هامة

| الأمر | الوصف |
|---|---|
| `supabase start` | تشغيل البيئة المحلية وتطبيق migrations. |
| `supabase stop` | إيقاف البيئة المحلية (استخدم `--clean` لمسح البيانات). |
| `supabase db reset` | مسح القاعدة وإعادة تطبيق migrations وseed. |
| `supabase db diff --schema public` | توليد SQL للفروقات بين القاعدة المحلية والملفات. |
| `supabase test db` | تشغيل اختبارات pgTAP الموجودة في مجلد `tests`. |

## محاذير أمنية

- **لا تضع أسرارًا** في `config.toml` أو `migrations/`. استخدم متغيرات البيئة.
- **لا تستخدم `db push`** مباشرة على مشروع الإنتاج دون مراجعة بشرية ونسخة احتياطية.
- **تأكد من `db reset`** محليًا قبل كل commit لضمان أن migrations قابلة للإعادة من الصفر.

## المراجع

[1] [Supabase Local Development](https://supabase.com/docs/guides/local-development)
[2] [Database Testing with pgTAP](https://supabase.com/docs/guides/database/extensions/pgtap)
