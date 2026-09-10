# مراقبة وتقليل زمن اختبارات CI/CD

## الوضع الحالي

أثبت أول تشغيل منشور لخط **Rust Integration Tests** أن التنفيذ الكامل يستغرق نحو دقيقة و51 ثانية، وكانت مرحلة `Run full Rust workspace tests` هي الجزء الأطول، بنحو دقيقة تقريبًا. هذا زمن جيد كبداية، لكن نمو عدد الحزم والاختبارات سيجعل القياس المستمر أهم من التحسين العشوائي. رابط التشغيل المرجعي موجود في [GitHub Actions Run #32518194359](https://github.com/mohammed-murad-alqabal/Basir_accounting/actions/runs/32518194359).

الهدف ليس جعل كل تشغيل أقصر بأي ثمن؛ الهدف هو تقليل **زمن التغذية الراجعة على Pull Request** مع إبقاء الاختبارات المحاسبية الحرجة، وخصوصًا التكامل والمعاملات، موثوقة وقابلة لإعادة الإنتاج.

## حالة التنفيذ الحالية

تم تنفيذ دفعات القياس، الفصل، والتقسيم على الفرع [`audit/accounting-engine-hardening`](https://github.com/mohammed-murad-alqabal/Basir_accounting/tree/audit/accounting-engine-hardening). يحتوي Workflow المنشور الآن على Job جودة مستقل، وJob PostgreSQL يعمل عبر Matrix من shardين متوازيين: `persistence` و`hash_chain`. لكل shard حاوية PostgreSQL واسم قاعدة مختلفان، وتوجد وظيفة `Rust CI gate` لتجميع نجاح Job الجودة وجميع shards كشرط واحد قابل للاستخدام في حماية الفرع. بعد تثبيت إجراءات GitHub على SHAs وإضافة `toolchain: stable` صراحةً، نجح تشغيل PR رقم [167](https://github.com/mohammed-murad-alqabal/Basir_accounting/pull/167) رقم [32658053355](https://github.com/mohammed-murad-alqabal/Basir_accounting/actions/runs/32658053355) على commit `7a47fe24ac10fa0d31f79b5429367445398e8c17`.

قبل التقسيم كان لدينا هدف تكامل واحد يجمع حفظ القيد والتحقق من سلسلة hash. أصبح لدينا الآن هدفان مستقلان: `db_persistence` و`db_hash_chain`. تحقق الاختبار المحلي من كل shard على حدة، وتضمن تشغيل كل واحد بعد migrations على قاعدة اختبار معزولة. لا يعني زمن Job الكلي زمن الاختبار فقط؛ فالتشغيلين المتوازيين يستهلكان Runner مستقلًا، وتظل أزمنة تجهيز Rust وPostgreSQL وcache ضمن الزمن الظاهر للوظيفة.

## استراتيجية القياس أولًا

ينبغي تسجيل ثلاثة أرقام لكل تشغيل: زمن الانتظار في الطابور، زمن تجهيز البيئة، وزمن الاختبار الفعلي. داخل الوظيفة، يمكن كتابة مدة كل مرحلة في `GITHUB_STEP_SUMMARY` حتى تظهر في صفحة التشغيل بدل البحث اليدوي في السجل. GitHub يوفّر ملف `GITHUB_STEP_SUMMARY` لعرض ملخص Markdown خاص بكل Job [1].

أضف خطوة قياس بسيطة حول المراحل البطيئة:

```yaml
- name: Measure test duration
  id: test_duration
  run: |
    start=$(date +%s)
    set -o pipefail
    cargo test --workspace -- --test-threads=1 2>&1 | tee "$GITHUB_WORKSPACE/rust-workspace-test.log"
    end=$(date +%s)
    seconds=$((end - start))
    echo "seconds=$seconds" >> "$GITHUB_OUTPUT"
    {
      echo "## Rust test timing"
      echo "- Workspace test duration: **${seconds}s**"
      echo "- Commit: \\`${GITHUB_SHA::12}\\`"
    } >> "$GITHUB_STEP_SUMMARY"
```

وللمراقبة التاريخية، يكفي في البداية حفظ سجل التشغيل وقراءة متوسط آخر 20 تشغيلًا عبر واجهة Actions أو `gh run list`، ثم الانتقال لاحقًا إلى GitHub API أو مستودع metrics إذا احتاج الفريق إلى رسوم بيانية واتجاهات طويلة المدى. لا ينبغي حفظ كلمات المرور أو `DATABASE_URL` ضمن artifacts أو cache؛ توصي وثائق GitHub بعدم وضع بيانات حساسة في مسارات التخزين المؤقت لأن مستخدمين لديهم حق قراءة المستودع قد يستطيعون الوصول إليها [2].

## التحسينات ذات أعلى عائد

| الأولوية | الإجراء | الأثر المتوقع | مستوى المخاطرة |
|---|---|---:|---:|
| 1 | الحفاظ على cache لـ Cargo registry وGit dependencies و`rust/target` مع مفتاح مبني على `Cargo.lock` وملفات `Cargo.toml` | تقليل زمن البناء بعد أول تشغيل | منخفض |
| 2 | تقسيم الاختبارات إلى Job سريع بلا قاعدة بيانات وJob تكامل مستقل | تقليل زمن التغذية الراجعة عبر التشغيل المتوازي | منخفض إلى متوسط |
| 3 | إلغاء التشغيل السابق لنفس الفرع عند وصول commit أحدث | تقليل تشغيلات مهدرة وطوابير CI | منخفض |
| 4 | تشغيل Workflow فقط عند تغيير Rust أو migrations أو ملفات Workflow | منع تشغيل محاسبي كامل بسبب تعديل وثائق غير مؤثر | منخفض، مع ضرورة ضبط المسارات جيدًا |
| 5 | استخدام `cargo nextest` لاختبارات الجودة غير المعتمدة على قاعدة البيانات | تشغيل متوازٍ أفضل وتحديد الاختبارات البطيئة | منخفض إلى متوسط، مع تثبيت الإصدار |
| 6 | اختبار workspace الكامل على `main` وNightly، واختبارات متدرجة على Pull Requests | تقليل زمن PR مع إبقاء بوابة شاملة | متوسط، ويحتاج سياسة واضحة |

## 1. تحسين cache دون إفسادها

الـ Workflow الحالي يستخدم cache، وهذا صحيح. ينبغي تعديل مفتاحه بحيث يتغير عند تغير Rust dependencies أو toolchain، لا عند تغير migrations فقط. تغيير migration لا يستلزم إعادة ترجمة كل ملفات Rust، لذلك إدراج `rust/migrations/*.sql` في مفتاح cache قد يؤدي إلى cache miss غير ضروري.

صيغة أكثر دقة:

```yaml
- name: Cache Cargo registry, Git dependencies, and build output
  uses: actions/cache@v4
  with:
    path: |
      ~/.cargo/registry
      ~/.cargo/git
      rust/target
    key: ${{ runner.os }}-rust-${{ hashFiles('rust/Cargo.lock', 'rust/**/Cargo.toml', 'rust/rust-toolchain.toml') }}
    restore-keys: |
      ${{ runner.os }}-rust-
```

إذا لم يوجد `rust/rust-toolchain.toml`، احذفه من `hashFiles` أو أضف ملف toolchain مثبتًا في المستودع. تستخدم GitHub مفاتيح cache و`restore-keys` للبحث عن تطابق كامل ثم تطابقات جزئية [2]. يجب مراقبة حجم `rust/target`؛ إذا أصبح الاسترجاع أكبر من زمن إعادة البناء، فالأفضل الاكتفاء بـ registry وGit cache أو استخدام cache متخصصة لـ Rust.

## 2. تقسيم الاختبارات إلى Jobs وShards متوازية

يفصل الـ Workflow المنشور بين Job الجودة وJob PostgreSQL، ثم يقسم Job PostgreSQL إلى shardين مستقلين عبر Matrix. هذا يجعل الاختبارات غير المعتمدة على قاعدة البيانات تعمل بالتوازي مع التكامل، ويجعل سيناريوهات التكامل المستقلة تعمل بالتوازي مع بعضها.

```text
rust-quality                 -> format + unit + workspace check
rust-integration[persistence] -> PostgreSQL + migrations + db_persistence
rust-integration[hash_chain]  -> PostgreSQL + migrations + db_hash_chain
ci-gate                      -> ينتظر نجاح الجودة وجميع shards
```

التقسيم الحالي مقصود ومحدود؛ فهو لا يكرر نفس الاختبار، بل نقل حالتي التحقق الموجودتين في الاختبار القديم إلى هدفين مستقلين. مثال Matrix الأساسي:

```yaml
strategy:
  fail-fast: false
  max-parallel: 2
  matrix:
    shard: [persistence, hash_chain]

env:
  DATABASE_URL: postgres://basir_test:basir_test_password@127.0.0.1:5432/basir_accounting_${{ matrix.shard }}
```

يُختار هدف Cargo من قيمة `matrix.shard` عبر `case` صريح، وتستخدم كل تركيبة قاعدة PostgreSQL خاصة بها. أما `Rust CI gate` فيفحص نتيجة Job التكامل كاملة، ولذلك لا يمر الدمج إذا فشل shard واحد.

## 3. حماية اختبارات التكامل أثناء Sharding

كانت حالة التكامل الأصلية تنفذ `TRUNCATE` على جداول محاسبية مشتركة؛ لذلك لا يجوز تشغيل عدة حالات منها بالتوازي على قاعدة واحدة. الحل المنفذ هو تقسيم التغطية إلى test binaries مستقلة مع قاعدة لكل shard:

```text
persistence -> basir_accounting_persistence -> db_persistence
hash_chain  -> basir_accounting_hash_chain  -> db_hash_chain
```

كل test binary يستدعي `common::setup()`، ويطبق `TRUNCATE` داخل قاعدته الخاصة فقط، ثم يزرع الحسابات الافتراضية قبل التنفيذ. لذلك يمكن تشغيل shardين بالتوازي بأمان، مع إبقاء كل shard داخليًا على `--test-threads=1` حتى لا تتنافس حالاته المحلية على نفس البيانات.

```bash
cargo test --locked -p accounting_data --test db_persistence -- --test-threads=1
cargo test --locked -p accounting_data --test db_hash_chain -- --test-threads=1
```

في GitHub Actions، تنشئ Matrix تركيبة مستقلة لكل قيمة، وتبني `DATABASE_URL` من `${{ matrix.shard }}`، بينما تطبق كل تركيبة migrations داخل PostgreSQL الخاص بها. لا تستخدم قاعدة staging مشتركة، ولا ترفع `DATABASE_URL` أو كلمات المرور إلى artifacts أو cache.

إذا أضيفت اختبارات تكامل جديدة، يجب وضعها في binary مستقل أو مجموعة متجانسة، وإضافتها إلى قائمة Matrix و`case` مع قاعدة معزولة. إذا تجاوز عدد shards قدرة الـ Runner أو أصبح إنشاء PostgreSQL هو عنق الزجاجة، اضبط `max-parallel` بدل إزالة العزل.

## 4. الاستفادة من concurrency

الـ Workflow الحالي يستخدم `concurrency` مع `cancel-in-progress: true`. هذا قرار صحيح لفروع Pull Request: إذا وصل commit أحدث، تُلغى النتيجة القديمة بدل استهلاك Runner عليها. توضح وثائق GitHub أن مجموعة concurrency يمكنها إبقاء تشغيل واحد فقط وإلغاء التشغيل الجاري عند تفعيل `cancel-in-progress` [3].

يفضل الإبقاء على الإلغاء في فروع التطوير، مع تعطيله للإصدارات أو الفروع التي يجب أن تمر كل تشغيلاتها:

```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: ${{ !startsWith(github.ref, 'refs/tags/') }}
```

## 5. تشغيل الاختبارات المناسبة حسب نوع التغيير

يمكن تقليل التشغيلات غير الضرورية بإضافة path filters، مثل تشغيل Workflow المحاسبي عند تغيير:

```yaml
on:
  pull_request:
    branches: [main, master]
    paths:
      - 'rust/**'
      - '.github/workflows/**'
      - 'docs/CI_*.md'
  push:
    branches: [main, master]
    paths:
      - 'rust/**'
      - '.github/workflows/**'
```

لكن يجب عدم استخدام filter ضيق جدًا؛ تغيير ملف إعداد أو migration أو Cargo lock يجب أن يشغّل الاختبار. التعديلات الوثائقية العامة لا تحتاج عادةً إلى PostgreSQL integration run.

سياسة مناسبة للمشروع هي:

| نوع الحدث | الاختبارات |
|---|---|
| Pull Request يغير Rust أو migrations | format + unit + integration |
| Pull Request وثائق فقط | لا يشغل Rust integration |
| Push إلى `main` | جميع الاختبارات + clippy + artifacts |
| تشغيل ليلي | workspace كامل، اختبارات property، وتدقيق أبطأ |
| Tag release | workspace كامل مع بوابة إصدار منفصلة |

## 6. استخدام Matrix بحذر

تسمح Matrix بتشغيل نسخ أو أنظمة متعددة من Job واحدة، لكنها تضاعف عدد Jobs مع كل بعد جديد. وثائق GitHub توضح أن كل تركيبة من قيم Matrix تنشئ Job مستقلة، كما يمكن ضبط `max-parallel` للحد من التزامن [4].

للمشروع المحاسبي، لا تبدأ بـ Matrix واسعة. ابدأ بإصدار Rust واحد وUbuntu واحد، ثم أضف نسخة ثانية فقط إذا كان المنتج يحتاجها:

```yaml
strategy:
  fail-fast: true
  max-parallel: 2
  matrix:
    rust: [stable]
```

استخدم Matrix لاحقًا لـ `stable` ونسخة دنيا مدعومة، أو لاختبارات property الثقيلة، وليس لتكرار PostgreSQL نفسه بلا حاجة.

## 7. اعتماد `cargo nextest` في المرحلة المناسبة — منفذ

`cargo nextest` مفيد عندما يصبح عدد اختبارات Rust كبيرًا لأنه يشغّل الاختبارات بصورة أكثر كفاءة ويعطي قياسات أوضح للاختبارات البطيئة. بعد فصل اختبارات PostgreSQL إلى shards بقواعد مستقلة، أصبح مطبقًا في Job الجودة فقط بالإصدار المثبت `0.9.143`. يُثبّت Workflow الـ binary الرسمي مباشرة مع تحقق SHA-256، بدل إجراء خارجي غير موجود في allowlist. بقيت اختبارات PostgreSQL على `cargo test` مع `--test-threads=1` داخل كل shard لأن كل binary يتعامل مع قاعدة shard واحدة ويستخدم تنظيفًا مشتركًا للبيانات. تحقق محليًا من نجاح 114 اختبارًا، كما نجح تشغيل CI رقم [32658053355](https://github.com/mohammed-murad-alqabal/Basir_accounting/actions/runs/32658053355).

المسار المنفذ:

```text
المرحلة الأولى: قياس cargo test ومدة Jobs.
المرحلة الثانية: فصل unit عن integration وتشغيلهما بالتوازي.
المرحلة الثالثة: تقسيم PostgreSQL إلى shards بقواعد مستقلة.
المرحلة الرابعة: nextest لاختبارات core وZATCA وaccounting_data --lib.
المرحلة الخامسة: إبقاء PostgreSQL على cargo test حتى تصبح عزلية كل حالة داخلية ضرورية ومثبتة.
```

## خطة تنفيذ عملية من ثلاث دفعات

### الدفعة الأولى: دون تغيير السلوك

أضف قياس المدة إلى `GITHUB_STEP_SUMMARY`، وراقب آخر 20 تشغيلًا، وعدّل cache key لإزالة migrations منه، وحافظ على `concurrency`. هذه الدفعة آمنة ولا تغير مجموعة الاختبارات.

### الدفعة الثانية: تقليل زمن Pull Request — منفذة

تم فصل unit عن integration وتشغيلهما بالتوازي، مع إضافة Job تجميعية تنتظر نجاح الاثنين. لم تُضف path filters بعد، لأن تحديدها يحتاج جردًا دوريًا لمسارات التطبيق وملفات الإعداد حتى لا يفلت تغيير يؤثر في المحرك المحاسبي. الخطوة التالية الآمنة هي إضافة filters مع إبقاء `rust/**` و`migrations` و`.github/workflows/**` ضمن النطاق.

### الدفعة الثالثة: التوازي المتقدم — منفذة

تم إدخال `cargo-nextest` بالإصدار المثبت `0.9.143` إلى Job الجودة فقط، مع إبقاء PostgreSQL shards على `cargo test`. تحقق محليًا من نجاح 112 اختبارًا في `accounting_core` و`accounting_zatca` واختبارين في `accounting_data --lib`، ونجح CI عن بُعد بعد إصلاح `toolchain: stable` المفقود إثر تثبيت إجراء dtolnay على SHA. كما صُحّح تجميع حالات الفشل بحيث تُنفّذ مجموعتا الجودة كلتاهما، ثم يفشل الـ Job إذا فشلت أي مجموعة؛ وهذا يمنع الإيقاف المبكر من إخفاء نتيجة المجموعة الثانية.

لا تُنقل اختبارات PostgreSQL إلى nextest إلا بعد إعطاء كل حالة تشغيل قاعدة أو schema مستقلًا؛ أما التوازي الحالي بين `persistence` و`hash_chain` فهو آمن على مستوى Matrix لأن لكل منهما قاعدة مستقلة.

## مؤشرات نجاح يجب مراقبتها

| المؤشر | الهدف الأولي |
|---|---:|
| متوسط زمن PR منذ بدء Job | أقل من دقيقتين |
| زمن مرحلة الاختبارات بعد cache hit | أقل من 45 ثانية عند نمو متوسط |
| نسبة cache hit | أعلى من 80% |
| نسبة التشغيلات الملغاة بسبب commit أحدث | مرتفعة في الفروع النشطة، دون إلغاء releases |
| نسبة إعادة الاختبار بسبب flakiness | صفر أو قريبة من الصفر |
| زمن اختبار integration وحده | يراقب منفصلًا ولا يخلط مع unit |

الأهم هو ألا نستخدم **retries** لإخفاء flakiness؛ إعادة المحاولة قد تقلل الإزعاج الظاهري لكنها تخفي مشكلة تزامن أو عزل في الاختبار. ينبغي تسجيل الفشل أولًا ثم إصلاح سببه.

## الخلاصة

الخطوة الأولى الموصى بها لهذا المستودع هي **إضافة قياس زمني إلى الملخص، ثم فصل unit عن integration مع الإبقاء على PostgreSQL integration أحادي الخيط**. بعد ذلك يمكن اختبار أثر cache وتحليل متوسط الزمن. هذا سيحافظ على صحة القيود المحاسبية ويمنح الفريق طريقًا تدريجيًا إلى التوازي بدل المخاطرة بتشغيل اختبارات تنظيف قاعدة مشتركة بالتزامن.

## المراجع

[1]: https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-commands "GitHub Docs: Workflow commands and job summaries"

[2]: https://docs.github.com/en/actions/reference/workflows-and-actions/dependency-caching "GitHub Docs: Dependency caching reference"

[3]: https://docs.github.com/actions/writing-workflows/choosing-what-your-workflow-does/control-the-concurrency-of-workflows-and-jobs "GitHub Docs: Control the concurrency of workflows and jobs"

[4]: https://docs.github.com/actions/writing-workflows/choosing-what-your-workflow-does/running-variations-of-jobs-in-a-workflow "GitHub Docs: Running variations of jobs in a workflow"
