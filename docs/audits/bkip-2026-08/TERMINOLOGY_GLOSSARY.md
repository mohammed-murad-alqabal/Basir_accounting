# BKIP — قاموس المصطلحات الأولي

> **الحالة:** مقترح؛ يحتاج اعتماد مالك النطاق المحاسبي قبل اعتباره حاكمًا.

المصطلح ليس زخرفة لغوية في نظام محاسبي. الاختلاف بين `void`, `cancel`, `reverse`, `delete`, أو بين invoice وvoucher وjournal entry يغير السلوك والأثر المالي وسجل التدقيق. تستخدم هذه الوثيقة الاسم القانوني المقترح وتمنع استخدام المرادفات في العقود/المتطلبات عندما يكون لها معنى تشغيلي مختلف.

| Term | العربية | التعريف | Canonical Name | Aliases المسموحة في الشرح فقط | Forbidden Variants في العقود/الكود |
|---|---|---|---|---|---|
| Journal Entry | قيد يومية | سجل محاسبي مكوّن من سطور متوازنة ويؤثر في دفتر الأستاذ. | `JournalEntry` | قيد | Transaction, Voucher, Entry عندما يقصد القيد. |
| Journal Entry Line | سطر قيد | سطر مدين أو دائن يربط مبلغًا بحساب. | `JournalEntryLine` | بند قيد | Journal row, accounting item. |
| Posting | ترحيل | اعتماد قيد/مستند لتسجيل أثره المحاسبي وفق الضوابط. | `post` / `posting` | اعتماد | Save عندما يقصد أثرًا محاسبيًا. |
| Draft | مسودة | مستند قابل للتعديل لا يحمل أثرًا محاسبيًا مرحّلًا. | `draft` | مسودة غير مرحلة | Pending إذا لم تكن حالة معرّفة. |
| Reversal | عكس | إنشاء قيد جديد معاكس لقيد مرحّل، مع حفظ الأصل وسلسلة التدقيق. | `reverseJournalEntry` | قيد عكسي | Delete entry, edit posted entry. |
| Void | إبطال | حالة عمل تدل على عدم استمرار المستند؛ يجب أن تحدد المواصفة هل تنتج عكسًا أم لا. | `voided` | إلغاء | Cancel بلا تحديد أثر. |
| Delete | حذف | إزالة تقنية/منطقية من سجل غير حاكم أو قبل الترحيل؛ لا تستخدم لقيد مرحّل. | `delete` | إزالة | Void أو reverse. |
| Invoice | فاتورة | مستند بيع أو شراء يمثل مطالبة/معاملة تجارية وقد يولّد أثرًا محاسبيًا. | `Invoice` | فاتورة مبيعات/مشتريات | Journal Entry, Voucher. |
| Voucher | سند | مستند إثبات قبض/صرف أو حركة محددة؛ تعريفه ونطاقه يحددان في REQ منفصل. | `ReceiptVoucher` / `PaymentVoucher` | سند قبض/صرف | Invoice إذا كان المستند فاتورة. |
| Ledger | دفتر الأستاذ | سجل الحسابات والقيود المرحّلة. | `ledger` | الأستاذ العام | Journal عندما يقصد التجميع. |
| Chart of Accounts | دليل الحسابات | شجرة الحسابات المستخدمة للتصنيف والترحيل والتقارير. | `ChartOfAccounts` / `Account` | COA | Account list. |
| Account | حساب | عنصر في دليل الحسابات له نوع ورصيد وطبيعة وقيود ترحيل. | `Account` | حساب محاسبي | Ledger إذا كان يقصد السجل. |
| Trial Balance | ميزان المراجعة | تقرير أرصدة/حركات يفحص توازن المدين والدائن. | `TrialBalance` | ميزان | Balance Sheet. |
| Balance Sheet | قائمة المركز المالي | تقرير الأصول والالتزامات وحقوق الملكية. | `BalanceSheet` | الميزانية العمومية | Trial Balance. |
| Income Statement | قائمة الدخل | تقرير الإيرادات والمصروفات والنتيجة. | `IncomeStatement` | الأرباح والخسائر | Cash Flow. |
| Fiscal Year | سنة مالية | فترة التقرير السنوية التي تحوي فترات قابلة للقفل أو الإغلاق. | `FinancialYear` | السنة المالية | Accounting period. |
| Fiscal Period | فترة مالية | جزء من السنة المالية يخضع لحالة open/locked/closed. | `FinancialPeriod` | الشهر المحاسبي | Fiscal year. |
| Period Lock | قفل الفترة | منع الترحيل في فترة محددة. | `lockPeriod` | إغلاق شهر | Year close إذا لم تغلق السنة. |
| Multi-currency | تعدد العملات | تسجيل القيمة الأصلية وسعر الصرف وقيمة الأساس. | `originalCurrency`, `exchangeRate`, `originalAmount` | عملات متعددة | Currency conversion بلا حقول محددة. |
| VAT | ضريبة القيمة المضافة | ضريبة محكومة بمعدل/فئة/حساب وإثبات قانوني. | `VAT` / `TaxEngine` | الضريبة | Zakat. |
| Zakat | الزكاة | حساب شرعي منفصل عن VAT يخضع لقاعدة نطاق وتاريخ. | `ZakatCalculation` | زكاة | Tax بشكل عام. |
| ZATCA | هيئة الزكاة والضريبة والجمارك | جهة/نطاق متطلبات الفوترة الإلكترونية السعودي. | `ZATCA` | فاتورة | Compliance بلا نطاق. |
| Simulation | محاكاة | سلوك يختبر أو يحاكي خدمة/اعتمادًا، ولا يثبت اتصالًا إنتاجيًا أو امتثالًا. | `simulation` | mock | production integration, compliant. |
| Evidence | دليل | artifact مؤرخ ومربوط بـSHA يثبت claim محددًا. | `evidence` | برهان | Report بلا SHA أو نتيجة. |
| Verified | متحقق | claim له REQ وtest وartifact evidence قابل للتدقيق. | `VERIFIED` | مؤكد | Complete, done, ready. |
| Authoritative | حاكم | أصل معتمد بسلطة معلنة لنوع سؤال محدد. | `authoritative` | مصدر حقيقة | Latest، final، official بلا policy. |

## قواعد استخدام مختصرة

لا تستخدم `complete` أو `production ready` أو `compliant` كحالة متطلب؛ تستخدم بدلاً منها `IMPLEMENTED`, `PARTIAL`, `UNVERIFIED`, أو `VERIFIED` وفق الدليل. ولا تستخدم `cancel` لمعنى عكس قيد إلا إذا ربطت صراحةً بـ`Reversal` وسجل الأصل. يُبقي التقرير كلمة «محاكاة» ظاهرة في جميع تدفقات ZATCA غير المتصلة بدليل اعتماد إنتاجي.

## المراجع

[1]: ../../../.kiro/specs/active/basir_master_specification/02_ACCOUNTING_ENGINE.md "مصطلحات المحرك المحاسبي"
[2]: ../../../.kiro/specs/active/basir_master_specification/06_COMPLIANCE_ENGINES.md "مصطلحات الامتثال"
[3]: ../../../lib/features/accounting/domain/entities/journal_entry.dart "أسماء الكيانات الفعلية"

**المؤلف:** Manus AI
