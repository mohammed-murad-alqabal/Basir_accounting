# GitHub Actions: Rust وPostgreSQL Integration CI

أصبح المستودع يحتوي على Workflow في `.github/workflows/rust-integration.yml` يشغّل اختبارات المحرك المحاسبي واختبار التكامل مع PostgreSQL تلقائيًا عند كل `push` إلى الفروع الرئيسية أو فروع التدقيق، وعند فتح أو تحديث Pull Request إلى `main` أو `master`، مع إمكانية التشغيل اليدوي عبر `workflow_dispatch`.

## ما ينفذه الـ Workflow

يحتوي الـ Workflow على Job جودة سريع، وJob تكامل يعمل عبر Matrix من shardين مستقلين. ينفذ Job الجودة فحص التنسيق والاختبارات غير المعتمدة على قاعدة البيانات وفحص ترجمة مساحة العمل. أما كل shard تكاملي فينشئ حاوية PostgreSQL 16 خاصة به، وينتظر جاهزيتها، ويطبّق ملفات `rust/migrations/*.sql` بترتيبها الزمني، ثم يشغّل اختبارًا واحدًا مستقلًا:

| الـ shard | هدف Cargo | التغطية |
|---|---|---|
| `persistence` | `cargo test --locked -p accounting_data --test db_persistence -- --test-threads=1` | حفظ القيد، الأسطر، وسجل التدقيق |
| `hash_chain` | `cargo test --locked -p accounting_data --test db_hash_chain -- --test-threads=1` | استمرارية سلسلة hash بين قيدين |

كل shard يحصل على `DATABASE_URL` مختلف مبني من `${{ matrix.shard }}`، لذلك لا يتشارك `TRUNCATE` أو بيانات الاختبار مع shard آخر. يتم رفع سجل مستقل لكل shard كـ artifact لمدة 14 يومًا، وتنتظر وظيفة `Rust CI gate` نجاح Job الجودة وجميع shards قبل اعتبار الفحص ناجحًا.

## تفعيل الحماية على الفرع الرئيسي

بعد أول تشغيل ناجح، يوصى بإضافة نتيجة الوظيفة إلى قواعد حماية `main` أو `master` في إعدادات المستودع، بحيث لا يمكن دمج Pull Request إلا بعد نجاح الفحص التجميعي:

```text
Rust CI gate
```

لا تجعل فحص shard واحد هو الشرط الوحيد؛ الفحص التجميعي يتأكد من نجاح `Rust quality + unit tests` وجميع تركيبات Matrix.

يجب تفعيل خيار انتظار نجاح الفحوصات قبل الدمج، ومنع تجاوز القاعدة إلا للمسؤولين عند الحاجة الاستثنائية.

## تشغيل يدوي

من واجهة GitHub افتح تبويب **Actions**، اختر **Rust Integration Tests**، ثم **Run workflow** وحدد الفرع. لا يحتاج التشغيل إلى إدخال `DATABASE_URL` لأن القاعدة تُنشأ تلقائيًا داخل خدمة الاختبار.

## إعادة الإنتاج محليًا

يمكن إعادة إنتاج نفس السيناريو محليًا باستخدام PostgreSQL وقاعدة اختبار معزولة، كما هو موثق في [دليل تشغيل اختبار التكامل](../audit/دليل_تشغيل_اختبار_التكامل_PostgreSQL.md). بعد تطبيق migrations شغّل الهدفين بالتتابع على قاعدة محلية واحدة، أو أنشئ قاعدة مستقلة لكل shard إذا أردت محاكاة التوازي. لا تستخدم قاعدة التطوير المشتركة لأن كل shard ينفذ `TRUNCATE` على جداول الحسابات والقيود وسجل التدقيق.

```bash
DATABASE_URL='postgres://basir_test:password@127.0.0.1:5432/basir_accounting_test' \
  cargo test --locked -p accounting_data --test db_persistence -- --test-threads=1

DATABASE_URL='postgres://basir_test:password@127.0.0.1:5432/basir_accounting_test' \
  cargo test --locked -p accounting_data --test db_hash_chain -- --test-threads=1
```

## استخدام قاعدة خارجية بدل خدمة GitHub

إذا احتاج الفريق لاحقًا إلى PostgreSQL مُدار أو بيئة staging، يجب استبدال قيمة الاتصال الثابتة بسر GitHub Actions مثل `DATABASE_URL`، ثم تمريره عبر:

```yaml
env:
  DATABASE_URL: ${{ secrets.DATABASE_URL }}
```

في هذه الحالة يجب تقييد السر إلى بيئة أو فروع موثوقة، وعدم تشغيله على Pull Requests من forks، وتجنب طباعة قيمة المتغير في السجلات. تظل خدمة PostgreSQL المؤقتة هي الخيار الأبسط والأكثر أمانًا لاختبارات التكامل العادية.
