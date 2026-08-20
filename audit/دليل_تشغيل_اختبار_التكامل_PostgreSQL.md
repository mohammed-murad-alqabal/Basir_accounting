# دليل تشغيل اختبار التكامل مع PostgreSQL

## المتطلبات

يلزم وجود Rust/Cargo، وPostgreSQL، وأدوات `psql`. يعمل الاختبار على قاعدة اختبار منفصلة؛ لا تستخدم قاعدة الإنتاج أو قاعدة التطوير المشتركة لأن الاختبار ينفذ أمر `TRUNCATE` على جداول المحاسبة والحسابات.

## 1. تشغيل PostgreSQL

على Ubuntu يمكن تثبيت وتشغيل PostgreSQL كما يلي:

```bash
sudo apt-get update -y
sudo apt-get install -y postgresql postgresql-client
sudo pg_ctlcluster 16 main start
```

إذا كان إصدار PostgreSQL مختلفًا، استبدل `16` بالإصدار المثبت، أو استخدم:

```bash
pg_lsclusters
```

## 2. إنشاء مستخدم وقاعدة اختبار

نفّذ الأوامر التالية مرة واحدة. يمكن تغيير اسم المستخدم وكلمة المرور، لكن يجب تحديث قيمة `DATABASE_URL` وفقًا لذلك.

```bash
sudo -u postgres psql -v ON_ERROR_STOP=1 \
  -c "DO \$\$ BEGIN
        IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'basir_test') THEN
          CREATE ROLE basir_test LOGIN PASSWORD 'ضع_كلمة_مرور_اختبار_قوية';
        ELSE
          ALTER ROLE basir_test WITH LOGIN PASSWORD 'ضع_كلمة_مرور_اختبار_قوية';
        END IF;
      END \$\$;"

sudo -u postgres createdb -O basir_test basir_accounting_test
```

إذا كانت القاعدة موجودة مسبقًا، لا تعِد إنشاءها؛ استخدمها فقط بعد التأكد أنها قاعدة اختبار مخصصة.

## 3. إعداد `DATABASE_URL`

من مجلد المشروع، استخدم متغيرًا مؤقتًا للجلسة الحالية، وهو الأسلوب الموصى به لتجنب تسريب كلمة المرور إلى Git:

```bash
cd /path/to/Basir_accounting/rust
export DATABASE_URL='postgres://basir_test:كلمة_المرور@127.0.0.1:5432/basir_accounting_test'
```

أو شغّل الاختبار دون تصدير دائم:

```bash
DATABASE_URL='postgres://basir_test:كلمة_المرور@127.0.0.1:5432/basir_accounting_test' \
  cargo test -p accounting_data --test db_integration -- --nocapture
```

لا تضع كلمة المرور الحقيقية داخل ملف متعقب، ولا تضف `.env` إلى Git. إذا أردت استخدام ملف بيئة محلي، ضعه في مكان غير متعقب وتأكد من مسار التحميل؛ تمرير المتغير في سطر الأمر أو عبر `export` أكثر وضوحًا لهذا الاختبار.

## 4. تطبيق migrations

اختبار `db_integration` يتوقع وجود المخطط، ولا يطبق migrations تلقائيًا. طبّق ملفات migrations بالترتيب الزمني من جذر المستودع:

```bash
cd /path/to/Basir_accounting
for migration in rust/migrations/*.sql; do
  echo "Applying $migration"
  PGPASSWORD='كلمة_المرور' psql \
    -h 127.0.0.1 \
    -U basir_test \
    -d basir_accounting_test \
    -v ON_ERROR_STOP=1 \
    -f "$migration" || exit 1
done
```

في بيئة CI يمكن استخدام أداة migrations موحدة مثل `sqlx-cli` بدل الحلقة، بشرط استخدام مجلد `rust/migrations` نفسه وقاعدة اختبار جديدة لكل تشغيل.

## 5. اختبار الاتصال ثم تشغيل الاختبار

تحقق أولًا من الاتصال:

```bash
PGPASSWORD='كلمة_المرور' psql \
  -h 127.0.0.1 \
  -U basir_test \
  -d basir_accounting_test \
  -c 'SELECT current_database(), current_user;'
```

ثم شغّل الاختبار المحدد:

```bash
cd /path/to/Basir_accounting/rust
. "$HOME/.cargo/env" 2>/dev/null || true
DATABASE_URL='postgres://basir_test:كلمة_المرور@127.0.0.1:5432/basir_accounting_test' \
  cargo test -p accounting_data --test db_integration -- --nocapture
```

ولتشغيل مساحة Rust كاملة مع اختبار التكامل:

```bash
DATABASE_URL='postgres://basir_test:كلمة_المرور@127.0.0.1:5432/basir_accounting_test' \
  cargo test --workspace -- --test-threads=1
```

استخدام `--test-threads=1` يقلل تداخل الاختبارات التي تنظف جداول قاعدة الاختبار نفسها.

## النتيجة المثبتة في هذه المراجعة

تم تنفيذ نفس المسار في بيئة التدقيق باستخدام قاعدة `basir_accounting_test` محلية، ونجح اختبار `test_persistence_flow`، ثم نجح `cargo test --workspace -- --test-threads=1` بالكامل. النتيجة تضمنت نجاح اختبار التكامل، واختبارات المحرك، واختبارات ZATCA، واختبارات طبقة البيانات، واختبارات المكتبة الأصلية، واختبارات التوثيق.

## تنظيف البيئة بعد الانتهاء

لإيقاف الخادم مؤقتًا:

```bash
sudo pg_ctlcluster 16 main stop
```

ولحذف قاعدة الاختبار والمستخدم نهائيًا، بعد التأكد من عدم الحاجة إليهما:

```bash
sudo -u postgres dropdb basir_accounting_test
sudo -u postgres psql -c "DROP ROLE IF EXISTS basir_test;"
```

لا تنفذ أمر الحذف على اسم قاعدة غير مخصص للاختبار.
