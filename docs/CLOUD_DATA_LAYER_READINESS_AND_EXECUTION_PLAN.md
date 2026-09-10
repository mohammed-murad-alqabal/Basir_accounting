# قرار جاهزية طبقة البيانات السحابية لـBasir Accounting

**المؤلف:** Manus AI
**التاريخ:** 2026-08-26
**النطاق:** تقييم البدء، التصميم، التهيئة، التنفيذ المرحلي، الاختبار، والتوثيق دون تطبيق تغييرات خارجية في هذه المرحلة.

## القرار التنفيذي

> **البدء إيجابي الآن، ولكن في نطاق هندسي مضبوط فقط:** التصميم، تثبيت العقود، migrations محلية، اختبارات RLS، وفصل طبقة التخزين عن واجهة التطبيق. أما تحميل بيانات حقيقية، أو ربط الإنتاج، أو تطبيق migrations على مشروع Supabase الرئيسي، فمبكر حاليًا ويجب تأجيله إلى ما بعد اجتياز بوابات جاهزية محددة.

هذا ليس تأجيلًا للمشروع؛ بل تقسيم للمخاطر. المشروع يملك حزمة `supabase_flutter` وتهيئة أولية ومصادقة Supabase، لكنه لا يملك طبقة بيانات سحابية مكتملة. مشروع Supabase `basir` موجود لكنه كان/هو بحاجة إلى تهيئة مخطط؛ والفحص الحالي للمستودع يثبت أن معظم القراءة والكتابة ما زالت مرتبطة بـIsar المحلي.

## تقييم الجاهزية

| المحور | الحالة | الحكم |
|---|---|---|
| مشروع Supabase | موجود ويمكن إدارته | جاهز مبدئيًا، وليس دليلًا على جاهزية schema |
| مخطط PostgreSQL | غير ممثل في المستودع كمسار migrations مكتمل | غير جاهز للإنتاج |
| Flutter SDK/package | `supabase_flutter` موجود | أساس جيد |
| التهيئة | `SupabaseConfig.initialize()` موجودة، لكنها تستخدم قيمًا افتراضية وهمية وتبتلع فشل التهيئة | تحتاج تشديدًا قبل الإنتاج |
| Auth | wrapper وRiverpod providers موجودان | صالح كنقطة بداية، بلا provisioning/tenant membership |
| التخزين الحالي | Isar في 21 مستودعًا تقريبًا، و`core/providers.dart` يستورد `dart:io` وIsar مباشرة | غير قابل لمسار Web مباشر |
| المزامنة | موجودة، لكنها ترسل JSON camelCase وتستعلم عن `server_updated_at`؛ mapper غير صريح | غير صالحة كأساس Cloud Sync إنتاجي |
| العزل الأمني | المستودعات الحالية user-scoped لا organization-scoped | يلزم تصميم tenant isolation |
| القيود المحاسبية | posting وclosed periods وDecimal موجودة محليًا | يجب ألا تُستبدل CRUD سحابيًا قبل حفظ invariants |
| النسخ والاستعادة | لا توجد سياسة موثقة للمشروع | بوابة مانعة قبل البيانات التشغيلية |

## لماذا لا نبدأ بترحيل كل شيء دفعة واحدة؟

الترحيل الكامل الآن سيحوّل أخطاء بنيوية إلى مخاطر بيانات. `core/providers.dart` يهيئ Isar ويستورد `dart:io` وملفات النماذج المولدة مباشرة، لذلك لن يكفي إضافة Supabase لإنجاح Web. كما أن دفتر الأستاذ لا يقتصر على حفظ صفوف: خدمة المحاسبة تتحقق من السنة المفتوحة، تمنع الفترات المغلقة، وتعدّل الأرصدة باستخدام `Decimal`. وأي طبقة سحابية يجب أن تحافظ على هذه القواعد ذريًا في PostgreSQL، لا أن تقلدها من واجهة Flutter.

إضافة إلى ذلك، هوية البيانات الحالية مبنية غالبًا على `userId`، بينما العزل السليم للحسابات يتطلب `organization_id` وسياسات RLS. نقل البيانات قبل قرار tenancy سيجعل التصحيح اللاحق مكلفًا وخطرًا.

## المسار المثالي

### المرحلة A: عقد البيانات والحوكمة

يُعرّف النظام organization كحد العزل الأساسي. كل جدول أعمال يحمل `organization_id NOT NULL`، وكل طلب Web يمر عبر RLS وليس عبر فلترة Dart. توضع العضويات والأدوار في جداول مستقلة، ويُمنع الاعتماد على `user_metadata` لتحديد الصلاحيات. تبدأ الأدوار بـowner/admin/accountant/auditor/operator/viewer، ويكون كل تغيير في العضوية أو الإعدادات قابلًا للتدقيق.

### المرحلة B: migrations قابلة للإعادة

يحتوي المستودع على `supabase/migrations/`، وتُختبر migrations محليًا قبل أي ربط بالمشروع. يُستخدم `db reset` على قاعدة محلية، ثم development branch، ثم يطلب تطبيق الإنتاج كقرار منفصل. لا تُنشأ الجداول يدويًا من Dashboard دون capture إلى Git.

### المرحلة C: أول شريحة بيانات منخفضة المخاطر

تبدأ الشريحة الأولى بـorganizations وorganization_members وprofiles وbusiness_settings، ثم accounts وfinancial_years وcustomers وvendors. لا تشمل في البداية journal entries أو invoices أو ZATCA أو inventory أو payments. الهدف إثبات العزل والـDTO والـWeb build، لا ادعاء اكتمال ERP.

### المرحلة D: طبقة repositories متعددة المنصات

يُفصل domain repository interface عن implementation. Native/desktop يحتفظ بـIsar، وWeb يستخدم Supabase repositories. لا تُحمّل ملفات Isar إلى Web عبر import غير مشروط. يُنفذ mapper صريح بين Dart camelCase وPostgreSQL snake_case، ويُعامل `numeric` كنص/Decimal في DTO حتى لا يتحول إلى double.

### المرحلة E: دفتر الأستاذ والمعاملات

بعد نجاح الشريحة المرجعية، يضاف journal_entries/journal_entry_lines بعملية PostgreSQL ذرية تتحقق من توازن المدين والدائن، والسنة المفتوحة، وعدم تعديل القيد المرحّل. بعدها تأتي invoices وZATCA، ثم inventory/payments. كل مرحلة لها migration واختبارات مستقلة ولا توجد migration ضخمة غير قابلة للعكس.

## خطة التنفيذ العملية

| المرحلة | المخرجات | بوابة الخروج |
|---|---|---|
| 0. تثبيت baseline | branch نظيف، secrets policy، توثيق plan وRPO/RTO | لا أسرار في Git، ونسخة Git مرجعية |
| 1. Foundation | migrations للمنظمات والعضويات وRLS | اختبارات cross-tenant وlast-owner |
| 2. Reference slice | accounts/years/customers/vendors | CRUD وRLS وnumeric round-trip |
| 3. Web adapter | اختيار repository حسب المنصة، mapper، auth context | `flutter build web` + اختبارات providers |
| 4. Ledger | journal header/lines، posting function، audit trail | balance invariant وclosed-period tests |
| 5. Documents | invoices، ZATCA payloads، attachments policy | compliance tests وStorage backup |
| 6. Cutover | migration data، dual-read، reconciliation، rollback | reconciliation صفر فروقات وقرار تشغيل |

## ما ينفذ الآن بأمان

يمكن تنفيذ الآتي في فرع محلي معزول: إنشاء migrations 0001/0002، إضافة اختبارات SQL/RLS، إنشاء DTO interfaces وmappers دون تشغيلها، تشديد فشل `SupabaseConfig` عند غياب الإعدادات في staging/production، وفصل provider interface عن Isar. يمكن كذلك توثيق التشغيل المحلي والنسخ والاستعادة وCI.

## ما لا ينفذ الآن

لا تُطبق migrations على المشروع الرئيسي، ولا تُحمّل بيانات المستخدمين، ولا تُستبدل Isar بالكامل، ولا تُحذف خدمة المزامنة، ولا تُستخدم service-role key داخل تطبيق Flutter، ولا تُعتبر قيم `.env` الافتراضية اتصالًا صالحًا. كما لا تُبنى قواعد ZATCA أو دفتر الأستاذ على افتراضات لم تُختبر في PostgreSQL.

## بوابات الموافقة

| القرار | هل يحتاج موافقة منفصلة؟ |
|---|---|
| إعداد ملفات محلية غير متتبعة | لا، ما دام دون نشر |
| commit محلي | يفضّل تأكيده قبل إنشاء تاريخ فرعي قابل للنشر |
| push أو فتح/تعديل PR | نعم، صراحة قبل كل push |
| إنشاء Supabase development branch | نعم، مع مراجعة التكلفة |
| تطبيق migration على development | نعم، لأنه تعديل خارجي |
| تطبيق migration على الإنتاج | نعم، بعد مراجعة بشرية ونسخة احتياطية واختبار rollback |
| تحميل أو تحويل بيانات حقيقية | نعم، مع خطة reconciliation وrollback |

## الخلاصة

**ابدأ الآن بمرحلة التأسيس والتحقق فقط.** هذه هي المرحلة الإيجابية والآمنة. لا تبدأ بعد بمرحلة تشغيلية كاملة؛ فالمشروع يحتاج أولًا إلى tenant model، RLS، migrations versioned، Web adapter، وفحوص استعادة. بعد اجتياز هذه الحواجز يمكن تحويل Supabase من حزمة موجودة في `pubspec.yaml` إلى طبقة بيانات سحابية حقيقية دون تعريض السجل المحاسبي للخطر.

## المراجع

[1]: https://supabase.com/docs/guides/local-development/database-migrations "Supabase Database migrations"

[2]: https://supabase.com/docs/guides/database/postgres/row-level-security "Supabase Row Level Security"

[3]: https://supabase.com/docs/guides/platform/backups "Supabase Database Backups"
