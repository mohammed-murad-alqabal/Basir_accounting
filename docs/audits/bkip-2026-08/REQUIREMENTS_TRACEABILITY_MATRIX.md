# BKIP — مصفوفة تتبّع المتطلبات

> **القاعدة:** لا تعني تسمية ملف أو وجود خدمة أن المتطلب منفذ أو متحقق. الحالة هنا مستندة إلى روابط محددة في الكود/الاختبارات وأدلة CI المتاحة.

## مقياس الحالة

| الحالة | المعنى |
|---|---|
| IMPLEMENTED | يوجد تنفيذ مباشر وسلوك يمكن تتبعه. |
| PARTIAL | يوجد تنفيذ جزئي، أو جزء من السلوك/الدليل مفقود. |
| MISSING | لا يظهر تنفيذ للمطلب ضمن نطاق الفحص المباشر. |
| UNVERIFIED | لا تكفي الأدلة لتأكيد الادعاء. |
| CONTRADICTED | يختلف النص عن المصدر/السلوك المرصود. |
| GAP | انقطعت سلسلة التتبّع عند رابط محدد. |

## المصفوفة الأساسية

| REQ / قاعدة | المصدر النصي | التصميم/المهمة | التنفيذ | الاختبار | الدليل | الحالة | الفجوة أو الإجراء التالي |
|---|---|---|---|---|---|---|---|
| ACC-INV-001: لا يُرحّل قيد غير متوازن | `02_ACCOUNTING_ENGINE` Rule 1 | لا يوجد ADR أو task ID موحد | `JournalEntry.isBalanced` و`AccountingService.postJournalEntry` | `test/unit/features/accounting/accounting_service_test.dart` و`fiscal_control_test.dart` | تحقق CI Flutter حديث مرّ؛ يلزم artifact دائم | IMPLEMENTED | امنح المتطلب ID داخل المواصفة واكتب معيار قبول. |
| ACC-INV-002: لا يتم الترحيل ضمن فترة مغلقة/مقفلة | `02_ACCOUNTING_ENGINE` Rule 4 | `FinancialYearService` | `canPostToDate` مستدعى قبل الترحيل | `invoice_posting_test.dart` و`treasury_service_test.dart` | اختبارات موجودة؛ لا يوجد evidence index موحد | IMPLEMENTED | أضف property test لكل حدود التاريخ والمنطقة الزمنية. |
| ACC-INV-003: قيد مرحل لا يعدل، والعكس يولد قيدًا معاكسًا | `02_ACCOUNTING_ENGINE` Rule 2 | تعليق `FR-ACC-011` في الكود فقط | `reverseJournalEntry` يبدل debit/credit ويعيد النشر | لا يوجد ربط اختبار ID مباشر | ترحيلات Rust تحتوي حمايات append-only، لكن مسار التطبيق يتطلب توحيدًا | PARTIAL | ثبت idempotency، منع العكس المكرر، وعلاقة original↔reversal. |
| ACC-INV-004: السطر لا يحمل مدينًا ودائنًا معًا | `02_ACCOUNTING_ENGINE` §1.2 | غير موجود | `JournalEntryLine` يسمح بالقيمتين؛ `isBalanced` لا يمنع ذلك | لا اختبار invariant ظاهر | — | GAP / UNVERIFIED | أضف constructor validation وproperty tests للمدين/الدائن والسطر الصفري. |
| ACC-INV-005: القيد يحوي سطرين على الأقل | `02_ACCOUNTING_ENGINE` §1.1 | غير موجود | لا يظهر فحص طول `lines` في الكيان أو خدمة الترحيل المراجعة | لا اختبار مباشر | — | GAP / UNVERIFIED | أضف `lines.length >= 2` في نطاق النشر واختبار رفض. |
| ACC-INV-006: كل قيد منشور يدخل hash chain | `02_ACCOUNTING_ENGINE` §4.3 | Forensic audit design متفرق | `hash` و`previousHash` اختياريان؛ خدمة جنائية وRust chain موجودان | اختبارات Rust chain + `forensic_audit_service_test.dart` | ليس هناك دليل أن `postJournalEntry` يولده إلزاميًا | PARTIAL | اجعل توليد/تحقق hash transactional ومفروضًا في boundary حاكم. |
| ACC-INV-007: يخزن المال كـDecimal لا double | Manifesto + Integration §7.2 | `ADR-DATA-001` و`DATA-LEDGER-MAPPING-001` | Isar يكتب `Decimal` نصيًا ويعيده بـ`Decimal.parse`؛ قارئ Rust يزيل مسار `f64` | `journal_entry_model_round_trip_test.dart` و`ledger.rs` unit tests | [Quality Gates 31750243155](https://github.com/mohammed-murad-alqabal/Basir_accounting/actions/runs/31750243155): `1,223` نجاح، `2` تخطٍ، تغطية `26.18%`، وتحليل معلوماتي `177/177` | PARTIAL | أثبت PostgreSQL integration round-trip وسياسة `DECIMAL(20,4)/(20,10)` من قاعدة نظيفة قبل الترقية. |
| REQ-DATA-002: mapping دقيق للـDecimal والعملات | `DATA_REQUIREMENTS` §REQ-DATA-002 | `ADR-DATA-001` و`DATA-LEDGER-MAPPING-001` | `JournalEntryModel` يحفظ decimals والعملة وسجل التدقيق، وRust يحلل JSON decimal بلا `f64` | اختبار Isar شامل وحالة نص غير صالح؛ اختبار Rust مضاف لكن تعذر تشغيله محليًا بسبب cache Cargo غير مكتمل | [Quality Gates 31750243155](https://github.com/mohammed-murad-alqabal/Basir_accounting/actions/runs/31750243155) يثبت المسار Flutter؛ لا دليل PostgreSQL integration بعد | PARTIAL | تشغيل اختبار Rust في بيئة cache مستقرة، ثم اختبار PostgreSQL حقيقي للـscale والتواريخ والحقول الخاسرة. |
| ACC-REP-001: ميزان مراجعة وتقارير قابلة للحفر | Functional Architecture + Accounting §5 | لا يوجد requirement ID | خدمات/شاشات تقرير موجودة | اختبار مؤسسي يشير إلى Trial Balance | لا اختبار E2E موحد من تقرير إلى قيد | PARTIAL | أنشئ acceptance flow مرقّمًا مع fixture ثابت. |
| REQ-SEC-001: المصادقة تخزن كلمات المرور بخوارزمية ومسار ترحيل محددين | `SECURITY_REQUIREMENTS` §REQ-SEC-001 | `ADR-SEC-001` (DRAFT؛ الموافقة الرسمية معلقة) | `PasswordHasher` يفرض bcrypt cost 12؛ و`AuthService` و`UserRepositoryImpl` يرقّيان SHA-256 التاريخي بعد تحقق ناجح | `password_hasher_test.dart` و`auth_service_test.dart` و`user_repository_test.dart` تغطي bcrypt والحد البايتي والترحيل | [Quality Gates 31746115542](https://github.com/mohammed-murad-alqabal/Basir_accounting/actions/runs/31746115542): `1,221` نجاح، `2` تخطٍ، تحليل 177 معلوماتية | IMPLEMENTED | اعتماد ADR رسميًا، ثم قياس bcrypt على الأجهزة المدعومة وتحديد نافذة إنهاء دعم hashes التاريخية. |
| SEC-RBAC-001: RBAC يتبع مصفوفة أدوار وصلاحيات | Security §2 | `PermissionGuard` | `hasPermission` وواجهة guard موجودان | لا مصفوفة test لكل permission/role | لا دليل رفض على المسارات الحساسة كلها | PARTIAL | ثبّت permission codes وأضف parameterized authorization tests. |
| SEC-AUD-001: أحداث جوهرية تسجل سجل تدقيق غير قابل للتعديل | Security §3 | AuditService / Rust audit | `AuditLogEntry` وRust audit chain موجودان | اختبارات chain ومراجعة forensic | لا proof أن كل جدول audited action يمر عبر مسار واحد | PARTIAL | Contract test يثبت USER_LOGIN/JOURNAL_POSTED/PERIOD_LOCKED وغيرها. |
| REQ-SEC-005: دفاع تسجيل الدخول وrate limiting | `SECURITY_REQUIREMENTS` §REQ-SEC-005 | ADR-SEC-001 يقرر الحالة `PLANNED` | لا توجد آلية rate limiting مقصودة في المصادقة المحلية الحالية | لا اختبار؛ لا تدّعي الوثائق وجوده | ADR والمواصفة يصرحان بأنه `PLANNED` | MISSING / PLANNED | أنشئ threat model يحدد نطاق العداد ومدة القفل وآثار DoS، ثم ADR/اختبار رفض قبل التنفيذ. |
| COM-VAT-001: VAT افتراضي 15% مع حالات صفرية/معفاة | Compliance §1 | Tax engine | دلائل `0.15` وخدمة tax | `zatca_verification_test.dart` وغيرها | لا مراجعة قانونية ضمن التدقيق | PARTIAL | وثق المصدر التنظيمي وإصداره واختبر التصنيفات. |
| COM-ZATCA-001: إنشاء XML/UBL وQR وتوقيع | Compliance §2 | Rust ZATCA | ملفات UBL/XML/QR/Rust crypto موجودة | اختبار ZATCA موجود | crypto/source يتضمن mock/simulation | PARTIAL — SIMULATION | فصل اختبار تنسيق عن اعتماد جهة تنظيمية، ومنع كلمة compliant. |
| COM-ZATCA-002: onboarding CSR→CCSID→PCSID وإرسال إنتاجي | Compliance §2 | لا contract إنتاجي | simulation service وشاشة محاكاة | اختبارات محاكاة | لا requestCCSID/PCSID مباشر | MISSING / UNVERIFIED | عقد API موصد + بيئة sandbox + evidence package قبل الإعلان. |
| COM-GOSI-001: حساب GOSI ورواتب | Compliance §5 | مصرح أنه مستقبل | لا مصدر GOSI | لا اختبار | — | MISSING | انقل إلى backlog مؤرخ أو أنشئ spec منفصل عند البدء. |
| INT-SYNC-001: مزامنة Isar↔PostgreSQL وحل التعارض | Integration §2 | SyncService | حقول sync/services موجودة | `sync_service_test.dart` محدود | لم يظهر API endpoint أو evidence conflict E2E | PARTIAL | ADR synchronization + API schema + conflict test harness. |
| INT-API-001: REST `/api/v1` موثق ومطبق | Integration §1 | Planned endpoints | لم يظهر `/api/v1` أو HTTP client في نطاق المصدر | لا اختبار contract | لا backend executable مرصود | MISSING | انقل الجدول إلى planned API contract، لا مواصفة تنفيذ. |
| REQ-UX-001: مصدر tokens بصري واحد | `UX_REQUIREMENTS` §REQ-UX-001 | `ADR-UX-001` (DRAFT؛ موافقة المالك معلقة) | `AppColors` و`AppPalette` طبقتان حاكمتان، و`AppTheme` يحولهما إلى `ColorScheme`؛ أزيل تكرار primitives الداكنة من `AppTheme` | `app_theme_token_contract_test.dart` يثبت العقدين الفاتح والداكن | [Quality Gates 31751982823](https://github.com/mohammed-murad-alqabal/Basir_accounting/actions/runs/31751982823): `1,225` نجاح، `2` تخطٍ، `26.19%`، وتحليل `177/177` معلوماتية | PARTIAL | اعتماد ADR، وربط تحقق custom seed بالوصولية، ثم تنفيذ أي انتقال brand معتمد وفق خطة الترحيل. |
| REQ-UX-004: سجل ميزات Atlas قابل للتتبع | `UX_REQUIREMENTS` §REQ-UX-004 | `ATLAS-FEATURE-REGISTER-001` (DRAFT؛ موافقة Product + QA معلقة) | `atlas_screen_legacy_inventory.csv` يمثل `FR-ATLAS-001…099`؛ أعيد تصنيف Atlas كمدخل legacy لا حالة تنفيذ | `atlas_register_contract_test.dart` يحرس تسلسل المجال، و4 تكرارات، و8 فجوات، ومنع COMPLETE بلا دليل | [Quality Gates 31759934847](https://github.com/mohammed-murad-alqabal/Basir_accounting/actions/runs/31759934847): `1,228` نجاح، `2` تخطٍ، `26.18%`، وتحليل `177/177` معلوماتية؛ اجتازت بوابات dependency/ERP/security/docs المصححة | PARTIAL | مراجعة Product للمعرفات المكررة/المفقودة وربط معايير قبول ذات اختبار للصفوف عالية الأثر. |
| UX-A11Y-001: WCAG AA وsemantics/touch targets | UI §6 + roadmap | معايير roadmap | helper contrast وبعض tests/semantics موجودة | لا evidence suite موحدة لكل flow | لا شهادة/نتيجة وصولية شاملة | PARTIAL / UNVERIFIED | Define a11y acceptance suite وartifact per release. |

## تحليل جودة المتطلبات

لا يكفي أن تكون العبارة تقنية. المتطلب الجيد محدد وقابل للقياس والاختبار والتنفيذ والتتبع. تُظهر العينة أن قواعد المحاسبة الأقوى محددة معنويًا، لكن متطلبات مثل «premium UI»، «high-performance»، «ready»، «full compliance»، و«all icons» ليست معرّفة بمعايير قبول أو أدلة في نفس السلسلة.

| نمط غير قابل للتحقق | سبب المشكلة | إعادة الصياغة المقترحة |
|---|---|---|
| «ZATCA Phase 2 Complete» | لا يحدد بيئة أو حالات أو شهادة أو evidence. | `COM-ZATCA-002`: في بيئة sandbox محددة، تولّد الفاتورة UBL... وتنجح حالات الاختبار X/Y/Z؛ لا يعلن production compliance حتى اعتماد الدليل التنظيمي. |
| «All code has zero lints» | غير مؤرخ ولا يحدد SHA أو أمر التنفيذ. | `NFR-QLT-001`: عند SHA، ينتهي الأمر المحدد في CI بحالة success ويخزن artifact الرابط. |
| «كل شاشة مكتملة» | الشاشة بلا قائمة قبول أو اختبار مسار. | `UX-SCR-###`: شاشة X تحقق الحقول والحالات والوصولية ومسار الترحيل، مع widget/E2E IDs. |
| «Hash chain every mutation» | نطاق mutation وحدود transaction غير محددة. | `ACC-INV-006`: كل إنشاء/ترحيل/عكس لقيد حاكم يولد record hash داخل المعاملة، ويُرفض الإدخال إذا فشل التحقق. |

## فجوات السلسلة الإلزامية

```text
المواصفة الرئيسة
  ↓ GAP: متطلبات بلا IDs ثابتة أو acceptance criteria
التصميم
  ↓ GAP: ADRs وعقود schema/security/sync متفرقة أو غير حاكمة
المهام
  ↓ GAP: roadmap/PR/task لا تحمل REQ linkage إلزاميًا
الكود
  ↓ PARTIAL: تطبيق قوي في بعض القواعد، ومحاكاة أو وصول اختياري في أخرى
الاختبارات
  ↓ GAP: وجود الاختبار لا يثبت علاقته بالمتطلب
الدليل
  ↓ GAP: نتائج CI/coverage لا تجمع في سجل evidence بحسب SHA وREQ
```

## الحد الأدنى لقبول متطلب جديد

أي `REQ-*` جديد يجب أن يتضمن: مالكًا، حالة، نسخة، وصفًا واحدًا قابلًا للاختبار، معيار قبول Given/When/Then، روابط `ADR-*` و`TASK-*`، مسار الكود، اختبارًا واحدًا على الأقل، ورابط artifact CI/نتيجة مراجعة. لا تتحول حالة المتطلب إلى `VERIFIED` قبل اكتمال هذه الحقول.

## المراجع

[1]: ../../../.kiro/specs/active/basir_master_specification/02_ACCOUNTING_ENGINE.md "مواصفة المحرك المحاسبي"
[2]: ../../../lib/features/accounting/domain/entities/journal_entry.dart "كيان JournalEntry"
[3]: ../../../lib/features/accounting/application/accounting_service.dart "AccountingService"
[4]: ../../../lib/features/accounting/application/financial_year_service.dart "FinancialYearService"
[5]: ../../../.kiro/specs/active/basir_master_specification/05_SECURITY_GOVERNANCE.md "مواصفة الأمن"
[6]: ../../../.kiro/specs/active/basir_master_specification/06_COMPLIANCE_ENGINES.md "مواصفة الامتثال"
[7]: ../../../.kiro/specs/active/basir_master_specification/07_INTEGRATION_PROTOCOLS.md "مواصفة التكامل"
[8]: ../../../lib/core/theme/tokens/app_colors.dart "رموز الألوان الفعلية"

**المؤلف:** Manus AI
