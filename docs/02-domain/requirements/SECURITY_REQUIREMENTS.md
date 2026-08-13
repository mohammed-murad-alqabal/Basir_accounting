# متطلبات الأمن عالية الخطورة

> **document_id:** REQ-SEC-CATALOG-001
> **status:** DRAFT
> **authority_level:** 1
> **owner:** Security Owner
> **approved_by:** Pending formal repository owner approval
> **effective_from:** 2026-08-13
> **last_verified_sha:** Not applicable — proposed requirements pending approval and evidence linkage
> **review_due:** 2026-09-13
> **related_adrs:** ADR-SEC-001 (authentication), ADR-SEC-002 (audit controls), to be created

| ID | المتطلب | الأولوية |
|---|---|---|
| REQ-SEC-001 | سياسة مصادقة وكلمات مرور معتمدة | P0 |
| REQ-SEC-002 | تفويض مبني على صلاحيات محددة | P0 |
| REQ-SEC-003 | سجل تدقيق للأحداث الحساسة | P0 |
| REQ-SEC-004 | إدارة الأسرار والبيانات الحساسة | P0 |
| REQ-SEC-005 | دفاع تسجيل الدخول ومراقبة CI | P1 |

## REQ-SEC-001 — سياسة المصادقة وكلمات المرور

**البيان:** يجب أن يحدد ADR واحد خوارزمية اشتقاق/تجزئة كلمة المرور، معاملات الكلفة، سياسات الترحيل، وتخزين الجلسة، وأن يطابق الكود والاختبارات والوثائق هذا القرار.

**معيار القبول:** Given إنشاء أو تغيير كلمة مرور، Then لا تخزن كلمة المرور نصًا صريحًا وتتحقق عبر الخوارزمية المعتمدة. Given hash قديم مدعوم، Then ينفذ مسار ترحيل موثق أو يرفض بشكل آمن. لا يذكر أي مستند bcrypt أو SHA-256 أو أي خوارزمية بلا ADR ودليل تنفيذ.

**الدليل المطلوب:** ADR، unit tests، secret scan، وSHA/Run ID.

## REQ-SEC-002 — تفويض مبني على صلاحيات

**البيان:** يجب أن يمر كل فعل حساس — مثل الترحيل، العكس، قفل الفترة، إدارة المستخدمين، النسخ والاستعادة، وتصدير التقارير — عبر تحقق permission حاكم لا عبر إخفاء UI فقط.

**معيار القبول:** Given مستخدم بلا permission مطلوبة، When يستدعي API/service أو الواجهة، Then يرفض الفعل دون أثر جانبي. Given مستخدم مخول، Then يسمح بعد تحقق القواعد النطاقية الأخرى. تكون أكواد الصلاحيات ثابتة وموثقة.

**الدليل المطلوب:** parameterized authorization tests لكل فعل حساس.

## REQ-SEC-003 — سجل تدقيق للأحداث الحساسة

**البيان:** يجب أن تنشئ الأحداث الحساسة المحددة في ADR سجلًا تدقيقيًا يحتوي actor وtime وaction وtarget وسبب/سياق مناسبًا، وأن يحمي التخزين السجل من التعديل غير المصرح.

**معيار القبول:** Given login/logout/failure أو ترحيل/عكس/قفل/تغيير إعدادات أو backup/restore، Then يسجل الحدث وفق العقد. Given محاولة تغيير سجل تدقيق محمي، Then ترفض. لا تعتبر log print بديلاً عن audit evidence.

**الدليل المطلوب:** integration tests ومسار فحص نزاهة وسجل artifact.

## REQ-SEC-004 — إدارة الأسرار والبيانات الحساسة

**البيان:** لا يجوز تخزين secret أو token أو password أو private key داخل المصدر أو التوثيق أو artifact غير المصرح. تحفظ القيم التشغيلية عبر نظام أسرار البيئة المعتمد، وتملك مفاتيح التشفير دورة حياة موثقة.

**معيار القبول:** Given PR يحتوي نمط سر موثوق، Then تفشل بوابة الأمن أو يتطلب الاستثناء توثيقًا وموافقة. Given config مثال، Then يستعمل placeholder غير حساس. لا تعرض تقارير CI قيمة حساسة.

**الدليل المطلوب:** secret scanning workflow وتمرين negative fixture آمن.

## REQ-SEC-005 — دفاع تسجيل الدخول ومراقبة CI

**البيان:** يجب أن يحدد ADR ما إذا كان rate limiting أو lockout أو control مكافئ مطلوبًا للمصادقة المحلية/البعيدة، وأن تكون حالته `PLANNED` أو `IMPLEMENTED` وفق دليل واضح، لا checkbox غامض.

**معيار القبول:** Given القرار يفرض rate limiting، When تتجاوز المحاولات الحد، Then يرفض المسار لمدة/سياسة محددة واختبارها. Given القرار لا يفرضه في نمط محلي، Then تشرح الوثيقة حدود التهديد والتعويضات. تنشر CI نتائج security checks الفعلية لا status مصطنعًا.

**الدليل المطلوب:** threat model، ADR، tests، وCI artifact.

## المراجع

[1]: ../../../.kiro/specs/active/basir_master_specification/05_SECURITY_GOVERNANCE.md "المواصفة الأمنية"
[2]: ../../00-governance/DOCUMENT_OWNERSHIP.md "الملكية"
[3]: ../../audits/bkip-2026-08/FINDINGS_REGISTER.md "نتائج BKIP"
