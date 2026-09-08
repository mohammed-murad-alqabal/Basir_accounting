# بوابة الإنتاج في GitHub Actions

> **المالك:** فريق تطوير مشروع نظام بصير المحاسبي الذكي
> **الملف التشغيلي:** `.github/workflows/production-quality-gate.yml`

تتحقق بوابة الإنتاج من تطبيق Flutter ومحرك Rust وملفات الاعتماديات قبل إنشاء أي artifact إنتاجي. لا تنشر هذه البوابة إصدارًا إلى GitHub أو متجر التطبيقات؛ فهي تنشئ artifact موقّعًا للمراجعة داخل بيئة GitHub المحمية باسم `production`.

| طبقة الحماية | الضبط المفروض في الـWorkflow | شرط التشغيل |
|---|---|---|
| Flutter | توليد المصادر، التنسيق، التحليل، الاختبارات، حد تغطية 70%، وبناء APK تجريبي | يجب أن يكون `pubspec.lock` موجودًا ومُلتزمًا بالمستودع. |
| Rust | `fmt` و`clippy` و`test` مع `--locked`، بالإضافة إلى `cargo audit` | يجب أن يكون `rust/Cargo.lock` موجودًا ومُحدّثًا. |
| الأسرار | مسح السجل الكامل عبر Gitleaks | لا يُسمح باستثناءات إلا في ملف إعداد موثق ومراجع. |
| الاعتماديات | Dependency Review على طلبات الدمج ومنع التراخيص المحددة | يجب تفعيل Dependabot alerts في إعدادات المستودع. |
| إصدار Android | artifacts موقعة، checksums SHA-256، وإزالة مادة التوقيع بعد البناء | يحتاج أسرار بيئة الإنتاج وتكوين Gradle للتوقيع. |

## التفعيل الآمن

أضف الملف إلى الفرع المقصود ثم افتح طلب دمج. لا تدمجه مباشرة في `main`؛ إذ يجب التأكد من أن كل dependencies الحالية يمكن أن تجتاز الفحوص. من واجهة GitHub، افتح **Settings → Branches → Add branch protection rule** للفرع `main`، وفعّل طلب مراجعة واحدة على الأقل، وحظر force pushes، وحظر الحذف، وطلب فحص الحالة التالي قبل الدمج:

```text
Required production quality gate
```

كما يجب حماية بيئة `production` عبر **Settings → Environments** وجعلها تتطلب مراجعين محددين، بحيث لا يستطيع أي workflow غير معتمد الوصول إلى أسرار التوقيع.

## أسرار إصدار Android

تُضاف الأسرار التالية في بيئة `production` فقط، وليس كأسرار عامة للمستودع:

| السر | القيمة المتوقعة |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | محتوى keystore بصيغة Base64 دون سجل أو مسافات زائدة. |
| `ANDROID_KEYSTORE_PASSWORD` | كلمة مرور مخزن المفاتيح. |
| `ANDROID_KEY_ALIAS` | الاسم المستعار لمفتاح توقيع الإصدار. |
| `ANDROID_KEY_PASSWORD` | كلمة مرور مفتاح التوقيع. |

لإنشاء قيمة `ANDROID_KEYSTORE_BASE64` محليًا، نفّذ الأمر التالي في جهاز موثوق، ثم انسخ المخرجات إلى GitHub Secrets فقط:

```bash
base64 --wrap=0 upload-keystore.jks
```

لا تضع ملف keystore أو `key.properties` أو القيم الناتجة في المستودع أو في سجلات CI.

## شرط Gradle الإلزامي

الـWorkflow يرفض عمدًا بناء artifact إنتاجي ما دام `android/app/build.gradle` يضبط `signingConfigs.debug` لإصدار `release`. هذا منع أمني مقصود، لأن توقيع APK بمفتاح debug لا يصلح للإنتاج.

قبل تفعيل tag أو التشغيل اليدوي للإصدار، يجب أن يحمّل `android/app/build.gradle` ملف `android/key.properties` وقت البناء، وأن يعرف `signingConfigs.release` باستخدام `storeFile` و`storePassword` و`keyAlias` و`keyPassword` من الملف. يجب إضافة `android/key.properties` و`android/app/upload-keystore.jks` إلى `.gitignore`.

## تشغيل بوابة إصدار مرشح

تعمل فحوص الجودة على طلبات الدمج ودفعات `main` و`develop`. أما بناء artifact موقّع فيعمل فقط عند وسم إصدار بصيغة `vX.Y.Z` أو عند تشغيل workflow يدويًا مع الخيار `build_release_candidate=true`، ويتطلب موافقة بيئة `production` وأسرارها.

```bash
git tag -a v1.2.3 -m "release: 1.2.3"
git push origin v1.2.3
```

بعد النجاح، راجع checksum الملف ومحتوى artifact قبل أي توزيع خارجي. لا تستخدم artifact الناتج كإصدار رسمي قبل اجتياز التحقق اليدوي في staging واختبار النسخ الاحتياطي والاستعادة والاختبارات الوظيفية على الأجهزة المستهدفة.

## الضوابط المتبقية خارج YAML

لا يمكن لملف GitHub Actions وحده أن يفعّل الحماية الإدارية للمستودع. يجب على مسؤول المستودع أن يفعّل branch protection وبيئة الإنتاج وDependabot alerts، وأن يقيّد من يملك حق إنشاء tags ودمج التغييرات. كما ينبغي تثبيت كل GitHub Action خارجية إلى commit SHA موثوق قبل تفعيل الإصدار الإنتاجي، ثم مراجعة تلك المراجع دوريًا ضمن طلب دمج مخصص للأتمتة.
