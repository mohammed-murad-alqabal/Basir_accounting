# خلاصة بحث cargo-nextest

## المصادر الرسمية

- التثبيت من binary الجاهز في CI: https://nexte.st/docs/installation/pre-built-binaries/
- التثبيت من المصدر واشتراط `--locked`: https://nexte.st/docs/installation/from-source/
- إجراء التثبيت المستخدم في GitHub Actions: https://github.com/taiki-e/install-action

## النتائج

توصي وثائق cargo-nextest باستخدام binary جاهز في GitHub Actions لتقليل زمن التثبيت، وتعرض `taiki-e/install-action@v2` مع `tool: nextest` كطريقة مدعومة. يمكن تثبيت سلسلة أو إصدار محدد بدل أحدث إصدار، وهو الأنسب لقابلية إعادة الإنتاج وتقليل مخاطر تغيّر السلوك.

توضح وثائق التثبيت من المصدر أن `cargo install cargo-nextest` يجب أن يستخدم `--locked`، وأن التثبيت من المصدر أبطأ من binary الجاهز. لذلك سيستخدم Workflow binary جاهزًا بإصدار مثبت، مع cache Cargo المعتادة، ولن يغيّر اختبارات PostgreSQL.

## قرار المشروع

يُجرّب nextest أولًا داخل Job `rust-quality` على اختبارات `accounting_core` و`accounting_zatca` و`accounting_data --lib` فقط. تبقى أهداف `db_persistence` و`db_hash_chain` تحت `cargo test` مع `--test-threads=1` لأن لها حالة PostgreSQL مشتركة داخل كل shard وتستخدم `TRUNCATE` في setup.

يجب مقارنة عدد الاختبارات الناجحة قبل وبعد، وإبقاء `cargo test` كبديل واضح عند فشل تثبيت nextest أو عدم توافق الإصدار. لا يجب استخدام nextest لتجاوز اختبار فاشل أو إخفاء إخفاقات flaky؛ أي retry يجب أن يكون قرارًا موثقًا ومحدودًا.
