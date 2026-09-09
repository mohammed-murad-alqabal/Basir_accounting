# خلاصة بحث cargo-nextest

## المصادر الرسمية

- التثبيت من binary الجاهز في CI: https://nexte.st/docs/installation/pre-built-binaries/
- التثبيت من المصدر واشتراط `--locked`: https://nexte.st/docs/installation/from-source/
- مستودع الإصدارات الرسمية: https://github.com/nextest-rs/nextest/releases

## النتائج

توضح وثائق cargo-nextest أن استخدام binary جاهز يقلل زمن التثبيت في GitHub Actions. يعتمد Workflow الحالي الإصدار `0.9.143` من الإصدار الرسمي، ويتحقق من SHA-256 المنشور قبل تثبيته، وهو أنسب لقابلية إعادة الإنتاج وتقليل مخاطر تغيّر السلوك في مستودع يفرض allowlist على Actions الخارجية.

توضح وثائق التثبيت من المصدر أن `cargo install cargo-nextest` يجب أن يستخدم `--locked`، وأن التثبيت من المصدر أبطأ من binary الجاهز. لذلك يستخدم Workflow binary جاهزًا بإصدار مثبت مع تحقق SHA-256 وcache Cargo المعتادة، ولا يغيّر اختبارات PostgreSQL.

## قرار المشروع

يُجرّب nextest أولًا داخل Job `rust-quality` على اختبارات `accounting_core` و`accounting_zatca` و`accounting_data --lib` فقط. تبقى أهداف `db_persistence` و`db_hash_chain` تحت `cargo test` مع `--test-threads=1` لأن لها حالة PostgreSQL مشتركة داخل كل shard وتستخدم `TRUNCATE` في setup.

يجب مقارنة عدد الاختبارات الناجحة قبل وبعد، وإبقاء `cargo test` كبديل واضح عند فشل تثبيت nextest أو عدم توافق الإصدار. لا يجب استخدام nextest لتجاوز اختبار فاشل أو إخفاء إخفاقات flaky؛ أي retry يجب أن يكون قرارًا موثقًا ومحدودًا.
