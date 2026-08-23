# ملخص تحقق cargo-nextest بعد التنفيذ

**التاريخ:** 23 أغسطس 2026

## نطاق التغيير

اعتمد المشروع `cargo-nextest 0.9.143` داخل Job الجودة غير المعتمد على PostgreSQL فقط. يُثبّت Workflow الـ binary الرسمي مباشرة، ويتحقق من SHA-256 قبل وضعه في `~/.cargo/bin`، لأن سياسة المستودع لا تسمح بالاعتماد على `taiki-e/install-action`. بقيت اختبارات PostgreSQL على `cargo test` مع `--test-threads=1` داخل كل shard.

## التحقق المحلي

تم تشغيل التحقق باستخدام `rustc 1.98.0` و`cargo 1.98.0` و`cargo-nextest 0.9.143`، مع `git diff --check` وفحص التنسيق الكامل عبر `cargo fmt --manifest-path rust/Cargo.toml --all -- --check`.

| المجموعة | الاختبارات | ناجحة | متخطاة | فاشلة |
|---|---:|---:|---:|---:|
| `accounting_core` و`accounting_zatca` | 112 | 112 | 0 | 0 |
| `accounting_data --lib` | 2 | 2 | 0 | 0 |
| **المجموع** | **114** | **114** | **0** | **0** |

يحفظ الملف `audit/nextest_post_change_local_output.txt` مخرجات التشغيل المحلي، بما فيها الإصدار والعدادات النهائية. لم تُجرَ اختبارات PostgreSQL المحلية في هذه الجولة لأن ملفات الاختبارات وعزلها لم تتغير؛ وقد تحقق منها CI باستخدام PostgreSQL مؤقت مستقل لكل shard.

## التحقق عن بُعد

شغّل Pull Request رقم [167](https://github.com/mohammed-murad-alqabal/Basir_accounting/pull/167) تشغيل Rust Integration Tests رقم [32658053355](https://github.com/mohammed-murad-alqabal/Basir_accounting/actions/runs/32658053355) على commit `7a47fe24ac10fa0d31f79b5429367445398e8c17` وانتهى بالنتيجة `success`.

| Job | النتيجة | المدة التقريبية |
|---|---|---:|
| `Rust quality + unit tests` | نجاح | 1m 05s |
| `PostgreSQL integration (persistence)` | نجاح | 1m 01s |
| `PostgreSQL integration (hash_chain)` | نجاح | 49s |
| `Rust CI gate` | نجاح | 3s |

كشف التشغيل السابق رقم `32657677969` فشلًا بنيويًا في pinning: بعد تثبيت `dtolnay/rust-toolchain` على SHA لم تعد قيمة `stable` تصل تلقائيًا إلى input الإجراء. عولج ذلك بإضافة `toolchain: stable` صراحةً إلى Job الجودة وشاردتي PostgreSQL، ثم نجح التشغيل اللاحق.

## ضوابط السلامة

لا تُنقل اختبارات PostgreSQL إلى nextest مع التوازي الداخلي قبل عزل كل حالة اختبار بقاعدة أو schema مستقل. التوازي الحالي بين `persistence` و`hash_chain` آمن على مستوى Matrix لأن لكل shard قاعدة PostgreSQL مؤقتة مستقلة، بينما يظل التنفيذ الداخلي أحادي الخيط لتجنب تنافس fixtures وعمليات `TRUNCATE`.

كما أن Job الجودة يشغّل مجموعتي nextest ويجمع حالتيهما بدل إخفاء فشل المجموعة الثانية خلف فشل المجموعة الأولى. لا يحتوي هذا التغيير على رموز GitHub أو `DATABASE_URL` إنتاجية.

## المراجع

[1]: https://nexte.st/docs/installation/pre-built-binaries/ "cargo-nextest: Pre-built binaries"
[2]: https://nexte.st/docs/getting-started/installation/ "cargo-nextest: Installation and getting started"
[3]: https://github.com/nextest-rs/nextest "nextest-rs/nextest"
[4]: https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/workflow-syntax-for-github-actions "GitHub Actions workflow syntax"

**المؤلف:** Manus AI
