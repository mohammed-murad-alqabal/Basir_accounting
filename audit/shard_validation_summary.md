# ملخص التحقق من Test Sharding

## النطاق

تم تقسيم اختبار التكامل القديم إلى هدفين مستقلين، مع قاعدة PostgreSQL منفصلة لكل shard:

| shard | هدف Cargo | قاعدة الاختبار |
|---|---|---|
| `persistence` | `db_persistence` | `basir_accounting_shard_validation` محليًا، و`basir_accounting_persistence` في CI |
| `hash_chain` | `db_hash_chain` | قاعدة مستقلة في CI باسم مشتق من `matrix.shard` |

## النتيجة المحلية

طُبقت جميع ملفات `rust/migrations/*.sql` بترتيبها على قاعدة PostgreSQL جديدة، ثم شُغّل كل هدف بخيط واحد:

```bash
cargo test --locked -p accounting_data --test db_persistence -- --test-threads=1
cargo test --locked -p accounting_data --test db_hash_chain -- --test-threads=1
```

النتيجة لكل shard: **نجاح، اختبار واحد ناجح، ولا إخفاقات**.

كما اجتازت التحققات غير المعتمدة على قاعدة البيانات:

```bash
SQLX_OFFLINE=true cargo test --locked -p accounting_core -p accounting_zatca --all-targets
SQLX_OFFLINE=true cargo test --locked -p accounting_data --lib
SQLX_OFFLINE=true cargo check --locked --workspace
```

إجمالي الحالات المبلغ عنها في الاختبارات غير المعتمدة على قاعدة البيانات: **73 + 3 + 2 + 2 + 1 + 3 + 3 + 2 + 2 + 1 + 2 + 2 + 1 + 3 + 2 + 1 + 1 + 1 + 3 + 2 = 109 حالة ناجحة، دون إخفاقات**، إضافة إلى اختباري التكامل الناجحين.

## ضوابط السلامة

يستخدم كل shard PostgreSQL مستقلًا، ويطبق migrations قبل الاختبار، ويستدعي `common::setup()` الذي ينفذ `TRUNCATE` داخل قاعدة ذلك shard فقط. لذلك لا يوجد تعارض بين عمليات التنظيف أو بيانات الاختبارات. بقي `--test-threads=1` داخل كل shard لأن الحالات المحلية في binary الواحد ما زالت تشترك في قاعدة shard نفسها.

## Workflow

الملف المنفذ هو `.github/workflows/rust-integration.yml`، ويستخدم:

```yaml
strategy:
  fail-fast: false
  max-parallel: 2
  matrix:
    shard: [persistence, hash_chain]
```

وتُجمع النتيجة في `Rust CI gate`؛ لا ينجح الفحص المطلوب للدمج إذا فشل Job الجودة أو أي shard من shards التكامل.

## ملاحظة تشغيلية

عند إضافة اختبار تكامل جديد، يجب وضعه في binary مستقل أو مجموعة متجانسة، وإضافة قيمة shard إلى Matrix، وهدف Cargo إلى `case` الاختيار، وقاعدة اختبار معزولة. لا تستخدم قاعدة staging مشتركة ولا تحفظ `DATABASE_URL` في artifacts أو cache.

## الملفات ذات الصلة

- `.github/workflows/rust-integration.yml`
- `rust/crates/accounting_data/tests/common/mod.rs`
- `rust/crates/accounting_data/tests/db_persistence.rs`
- `rust/crates/accounting_data/tests/db_hash_chain.rs`
- `docs/CI_GITHUB_ACTIONS.md`
- `docs/CI_PERFORMANCE_GUIDE.md`

سجل الاختبار الكامل موجود في `audit/shard_validation_output.txt`.
