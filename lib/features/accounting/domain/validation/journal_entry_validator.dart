import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/domain/validation/journal_entry_validation_exception.dart';
import 'package:decimal/decimal.dart';

/// حارس نطاقي حتمي لقواعد دفتر الأستاذ قبل أي كتابة مرحّلة.
///
/// يغطي هذا الحارس REQ-ACC-001 وREQ-ACC-002 وREQ-ACC-003 وجزء العملة من
/// REQ-ACC-008. لا يستبدل التحقق من الفترة أو الصلاحيات أو idempotency، إذ
/// تنفذها خدمة الترحيل في حدودها المناسبة.
class JournalEntryValidator {
  const JournalEntryValidator._();

  /// يعيد جميع إخفاقات القيد كي يحصل العميل والاختبار على سبب قابل للتدقيق.
  static List<JournalEntryValidationFailure> validate(JournalEntry entry) {
    final failures = <JournalEntryValidationFailure>[];

    if (entry.status == JournalEntryStatus.voided) {
      failures.add(
        const JournalEntryValidationFailure(
          code: JournalEntryValidationCode.invalidStatus,
          message: 'A voided journal entry cannot be posted.',
        ),
      );
    }

    if (entry.lines.length < 2) {
      failures.add(
        const JournalEntryValidationFailure(
          code: JournalEntryValidationCode.tooFewLines,
          message: 'A postable journal entry must contain at least two lines.',
        ),
      );
    }

    for (var index = 0; index < entry.lines.length; index++) {
      final line = entry.lines[index];
      _validateLine(line, index, failures);
    }

    if (entry.totalDebit != entry.totalCredit) {
      failures.add(
        JournalEntryValidationFailure(
          code: JournalEntryValidationCode.unbalanced,
          message: 'Debit ${entry.totalDebit} does not equal credit '
              '${entry.totalCredit}.',
        ),
      );
    }

    return failures;
  }

  /// يرمي استثناء نطاقيًا واحدًا قبل إجراء أي كتابة في المستودع.
  static void ensurePostable(JournalEntry entry) {
    final failures = validate(entry);
    if (failures.isNotEmpty) {
      throw JournalEntryValidationException(failures);
    }
  }

  static void _validateLine(
    JournalEntryLine line,
    int index,
    List<JournalEntryValidationFailure> failures,
  ) {
    if (line.accountId.trim().isEmpty || line.accountName.trim().isEmpty) {
      failures.add(
        JournalEntryValidationFailure(
          code: JournalEntryValidationCode.missingAccount,
          lineIndex: index,
          message: 'Every line must identify a non-empty account.',
        ),
      );
    }

    if (line.debit < Decimal.zero || line.credit < Decimal.zero) {
      failures.add(
        JournalEntryValidationFailure(
          code: JournalEntryValidationCode.negativeAmount,
          lineIndex: index,
          message: 'Debit and credit amounts cannot be negative.',
        ),
      );
    }

    final hasDebit = line.debit > Decimal.zero;
    final hasCredit = line.credit > Decimal.zero;
    if (hasDebit && hasCredit) {
      failures.add(
        JournalEntryValidationFailure(
          code: JournalEntryValidationCode.debitAndCreditSet,
          lineIndex: index,
          message: 'A line may carry either debit or credit, not both.',
        ),
      );
    } else if (!hasDebit && !hasCredit) {
      failures.add(
        JournalEntryValidationFailure(
          code: JournalEntryValidationCode.zeroAmount,
          lineIndex: index,
          message: 'A line must carry a positive debit or credit amount.',
        ),
      );
    }

    final hasCurrency = line.originalCurrency?.trim().isNotEmpty ?? false;
    final hasOriginalAmount = line.originalAmount != null;
    final hasExchangeRate = line.exchangeRate != null;
    final hasCompleteCurrencyContext =
        hasCurrency && hasOriginalAmount && hasExchangeRate;
    final hasUnexpectedCurrencyData =
        !hasCurrency && (hasOriginalAmount || hasExchangeRate);
    final hasInvalidCurrencyValues =
        (line.originalAmount != null && line.originalAmount! <= Decimal.zero) ||
            (line.exchangeRate != null && line.exchangeRate! <= Decimal.zero);

    if (!hasCompleteCurrencyContext &&
            (hasCurrency || hasOriginalAmount || hasExchangeRate) ||
        hasUnexpectedCurrencyData ||
        hasInvalidCurrencyValues) {
      failures.add(
        JournalEntryValidationFailure(
          code: JournalEntryValidationCode.invalidOriginalCurrency,
          lineIndex: index,
          message: 'Original currency, amount, and exchange rate must be '
              'provided together and be positive.',
        ),
      );
    }
  }
}
