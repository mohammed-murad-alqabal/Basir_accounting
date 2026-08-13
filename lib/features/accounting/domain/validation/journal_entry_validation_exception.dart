/// أسباب رفض قيد اليومية قبل أن يصبح أثرًا مرحلًا في دفتر الأستاذ.
enum JournalEntryValidationCode {
  /// القيد يحتوي على أقل من سطرين.
  tooFewLines,

  /// رقم الحساب أو اسمه غائب عن السطر.
  missingAccount,

  /// يحمل السطر مبلغًا سالبًا.
  negativeAmount,

  /// يحمل السطر مدينًا ودائنًا موجبين في الوقت نفسه.
  debitAndCreditSet,

  /// لا يحمل السطر أي مبلغ موجب.
  zeroAmount,

  /// مجموع المدين لا يساوي مجموع الدائن.
  unbalanced,

  /// بيانات العملة الأصلية ناقصة أو غير متسقة.
  invalidOriginalCurrency,

  /// لا يجوز ترحيل قيد أُلغي أو عُكس.
  invalidStatus,
}

/// تفصيل ثابت لفشل قاعدة واحدة؛ لا يعتمد على نص استثناء حر فقط.
class JournalEntryValidationFailure {
  const JournalEntryValidationFailure({
    required this.code,
    required this.message,
    this.lineIndex,
  });

  final JournalEntryValidationCode code;
  final String message;
  final int? lineIndex;

  @override
  String toString() {
    final lineSuffix = lineIndex == null ? '' : ' at line ${lineIndex! + 1}';
    return '${code.name}$lineSuffix: $message';
  }
}

/// استثناء نطاقي يوقف الترحيل قبل أي كتابة في المستودع.
class JournalEntryValidationException implements Exception {
  const JournalEntryValidationException(this.failures);

  final List<JournalEntryValidationFailure> failures;

  @override
  String toString() => 'JournalEntryValidationException: '
      '${failures.map((failure) => failure.toString()).join('; ')}';
}
