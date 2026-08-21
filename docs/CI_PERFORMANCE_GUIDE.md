# مراقبة وتقليل زمن اختبارات CI/CD

## الوضع الحالي

أثبت أول تشغيل منشور لخط **Rust Integration Tests** أن التنفيذ الكامل يستغرق نحو دقيقة و51 ثانية، وكانت مرحلة `Run full Rust workspace tests` هي الجزء الأطول، بنحو دقيقة تقريبًا. هذا زمن جيد كبداية، لكن نمو عدد الحزم والاختبارات سيجعل القياس المستمر أهم من التحسين العشوائي. رابط التشغيل المرجعي موجود في [GitHub Actions Run #32518194359](https://github.com/mohammed-murad-alqabal/Basir_accounting/actions/runs/32518194359).

الهدف ليس جعل كل تشغيل أقصر بأي ثمن؛ الهدف هو تقليل **زمن التغذية الراجعة على Pull Request** مع إبقاء الاختبارات المحاسبية الحرجة، وخصوصًا التكامل والمعاملات، موثوقة وقابلة لإعادة الإنتاج.

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
| 5 | استخدام `cargo nextest` بعد عزل اختبارات قاعدة البيانات | تشغيل متوازٍ أفضل وتحديد الاختبارات البطيئة | متوسط |
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

## 2. تقسيم الاختبارات إلى Jobs متوازية

الـ Workflow الحالي يضع فحص التنسيق، الاختبارات الداخلية، واختبار قاعدة البيانات في Job واحد. مع نمو المشروع، الأفضل فصلها إلى ثلاث وحدات:

```text
quality       -> cargo fmt --check وcargo clippy
unit           -> accounting_core وaccounting_zatca واختبارات data unit
integration    -> PostgreSQL + migrations + db_integration
```

يمكن تشغيل `unit` و`integration` بالتوازي، ثم جعل Job تجميعية مطلوبة للفرع الرئيسي. مثال مختصر:

```yaml
jobs:
  unit:
    name: Rust unit tests
    runs-on: ubuntu-24.04
    defaults:
      run:
        working-directory: rust
    steps:
      - uses: actions/checkout@v4
      - uses: dtolnay/rust-toolchain@stable
        with:
          components: rustfmt
      - uses: actions/cache@v4
        with:
          path: |
            ~/.cargo/registry
            ~/.cargo/git
            rust/target
          key: ${{ runner.os }}-rust-${{ hashFiles('rust/Cargo.lock', 'rust/**/Cargo.toml') }}
          restore-keys: |
            ${{ runner.os }}-rust-
      - run: cargo fmt --all -- --check
      - run: cargo test -p accounting_core -p accounting_zatca -p accounting_data --lib

  integration:
    name: PostgreSQL integration
    runs-on: ubuntu-24.04
    services:
      postgres:
        image: postgres:16-alpine
        env:
          POSTGRES_USER: basir_test
          POSTGRES_PASSWORD: basir_test_password
          POSTGRES_DB: basir_accounting_test
        ports:
          - 5432:5432
        options: >-
          --health-cmd "pg_isready -U basir_test -d basir_accounting_test"
          --health-interval 5s
          --health-timeout 5s
          --health-retries 20
    defaults:
      run:
        working-directory: rust
    env:
      DATABASE_URL: postgres://basir_test:basir_test_password@127.0.0.1:5432/basir_accounting_test
    steps:
      - uses: actions/checkout@v4
      - uses: dtolnay/rust-toolchain@stable
      - run: sudo apt-get update -y && sudo apt-get install -y postgresql-client
      - run: pg_isready -h 127.0.0.1 -p 5432 -U basir_test -d basir_accounting_test
      - name: Apply migrations
        run: |
          set -euo pipefail
          for migration in migrations/*.sql; do
            psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f "$migration"
          done
      - run: cargo test -p accounting_data --test db_integration -- --nocapture
```

هذا المثال يوضح الفكرة، وليس استبدالًا فوريًا للـ Workflow المنشور؛ يجب أولًا التأكد من أن الاختبارات التي نُقلت إلى `unit` لا تحتاج اتصالًا بقاعدة البيانات.

## 3. حماية اختبارات التكامل من التوازي غير الآمن

اختبار التكامل الحالي ينفذ `TRUNCATE` على جداول محاسبية مشتركة. لذلك لا يجوز تشغيل عدة حالات منه بالتوازي على قاعدة واحدة. يمكن إبقاء:

```bash
cargo test -p accounting_data --test db_integration -- --test-threads=1
```

حتى يتم عزل كل اختبار في قاعدة مختلفة أو schema مختلف. بعد ذلك فقط يمكن استخدام `cargo nextest` أو Matrix لتشغيل الحالات بالتوازي. تسريع الاختبارات بإزالة العزل قد ينتج نجاحات وهمية أو تلفًا في بيانات الاختبار، وهو أسوأ من بطء CI في نظام محاسبي.

عند الحاجة إلى التوازي الحقيقي، استخدم قاعدة أو schema لكل worker، مثل:

```text
basir_test_${{ github.run_id }}_${{ strategy.job-index }}
```

ثم طبّق migrations داخل كل قاعدة. يجب أن يكون التنظيف مضمونًا عبر `if: always()` أو سياسة انتهاء تلقائي، وألا تستخدم أي قاعدة staging مشتركة.

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

## 7. اعتماد `cargo nextest` في المرحلة المناسبة

`cargo nextest` مفيد عندما يصبح عدد اختبارات Rust كبيرًا لأنه يشغل الاختبارات بصورة أكثر كفاءة ويعطي قياسات أوضح للاختبارات البطيئة. قبل اعتماده في هذا المشروع، يجب فصل `db_integration` أو إعطاؤه قاعدة مستقلة لكل worker. لا تستبدل `cargo test` بالكامل قبل مقارنة النتائج في تشغيلات متكررة.

مسار آمن:

```text
المرحلة الأولى: cargo test الحالي مع قياس Job durations.
المرحلة الثانية: nextest لاختبارات core وZATCA فقط.
المرحلة الثالثة: عزل اختبارات PostgreSQL ثم إدخالها تدريجيًا في nextest.
المرحلة الرابعة: مقارنة الفشل والمدة قبل جعل nextest بوابة الدمج.
```

## خطة تنفيذ عملية من ثلاث دفعات

### الدفعة الأولى: دون تغيير السلوك

أضف قياس المدة إلى `GITHUB_STEP_SUMMARY`، وراقب آخر 20 تشغيلًا، وعدّل cache key لإزالة migrations منه، وحافظ على `concurrency`. هذه الدفعة آمنة ولا تغير مجموعة الاختبارات.

### الدفعة الثانية: تقليل زمن Pull Request

افصل unit عن integration، وشغّلهما بالتوازي، وأضف path filters محسوبة. اجعل كل Job مطلوبًا في Branch protection أو استخدم Job تجميعية تنتظر نجاح الاثنين.

### الدفعة الثالثة: التوازي المتقدم

أدخل `cargo nextest` لاختبارات لا تعتمد على قاعدة البيانات، ثم صمّم عزلًا مستقلًا لقاعدة كل worker. لا تنتقل إلى هذه الدفعة قبل وجود قياس يثبت أن زمن الاختبارات هو المشكلة، لا زمن إنشاء Runner أو تنزيل cache.

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
