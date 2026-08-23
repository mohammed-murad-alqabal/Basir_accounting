# ملخص تحقق cargo-nextest

**التاريخ:** 23 أغسطس 2026

## القرار

تم اعتماد `cargo-nextest` في Job الجودة فقط، مع تثبيت الإصدار `0.9.143` عبر `taiki-e/install-action@v2`. بقيت اختبارات PostgreSQL التكاملية على `cargo test` مع `--test-threads=1` داخل كل shard؛ لأن كل binary تكاملي يستخدم قاعدة shard مستقلة، لكنه قد يشترك داخل binary نفسه في حالة قاعدة البيانات والتنظيف.

## الأوامر التي تم التحقق منها

```bash
cargo nextest run --locked -p accounting_core -p accounting_zatca --all-targets
cargo nextest run --locked -p accounting_data --lib
SQLX_OFFLINE=true cargo check --locked --workspace
cargo fmt --all -- --check
```

## النتائج

| المجموعة | الاختبارات | ناجحة | متخطاة | فاشلة |
|---|---:|---:|---:|---:|
| `accounting_core` + `accounting_zatca` | 112 | 112 | 0 | 0 |
| `accounting_data --lib` | 2 | 2 | 0 | 0 |
| المجموع | 114 | 114 | 0 | 0 |

نجح فحص الترجمة الكامل في وضع SQLx offline، ونجح فحص التنسيق. أظهر التشغيل المحلي أن زمن تنفيذ اختبارات nextest بعد اكتمال build قصير، بينما يبقى جزء معتبر من زمن Job مرتبطًا بإنشاء Runner واستعادة cache وبناء workspace.

## سلامة الفشل

يشغّل Job الجودة مجموعتي nextest حتى عند فشل المجموعة الأولى، ثم يعيد حالة فشل إذا فشلت أي مجموعة. يمنع ذلك الإيقاف المبكر من إخفاء فشل `accounting_data` خلف فشل المحرك أو العكس.

## حدود التوسعة

لا ينبغي نقل اختبارات PostgreSQL إلى `cargo nextest` مع تفعيل التوازي الداخلي قبل إعطاء كل حالة اختبار قاعدة أو schema مستقلًا. التوازي الحالي بين `persistence` و`hash_chain` آمن لأنه يتم عبر Matrix ولكل shard قاعدة PostgreSQL مستقلة.

## مراجع

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"

[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"

[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"

[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

## References

[1] [cargo-nextest: Pre-built binaries](https://nexte.st/docs/installation/pre-built-binaries/)

[2] [cargo-nextest: Installation and getting started](https://nexte.st/docs/getting-started/installation/)

[3] [taiki-e/install-action](https://github.com/taiki-e/install-action)

[4] [nextest-rs/nextest](https://github.com/nextest-rs/nextest)

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معزولة.

## References

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/taiki-e/install-action "taiki-e/install-action"
[4]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"

**المؤلف:** Manus AI

الأدلة الخام محفوظة في `audit/nextest_post_change_local_output.txt` و`audit/cargo_test_baseline_output.txt`.

> لا يُعد هذا الملخص بديلًا عن تشغيل PostgreSQL integration؛ فهو يوثق Job الجودة غير المعتمد على قاعدة البيانات فقط، بينما تُتحقق shards التكاملية في Workflow مستقل بقواعد معز
