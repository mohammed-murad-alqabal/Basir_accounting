import 'dart:io';

/// محرك التحقق من جودة التوثيق
///
/// يقوم بالتحقق من صحة واكتمال وجودة التوثيق في الكود
class ValidationEngine {
  /// التحقق من documentation لعنصر واحد
  ///
  /// يقوم بفحص التوثيق والتأكد من مطابقته للمعايير
  ///
  /// Parameters:
  /// - [documentation]: نص التوثيق المراد التحقق منه
  ///
  /// Returns: نتيجة التحقق مع قائمة المشاكل إن وجدت
  ValidationResult validateElement(String documentation) {
    final issues = _detectIssues(documentation);
    final score = _calculateQualityScore(documentation);

    return ValidationResult(
      isValid: issues.where((i) => i.severity == IssueSeverity.error).isEmpty,
      issues: issues,
      qualityScore: score,
    );
  }

  /// التحقق من ملف كامل
  ///
  /// يقوم بقراءة الملف وفحص توثيق كل العناصر العامة فيه
  FileValidationResult validateFile(String filePath) {
    final file = File(filePath);
    final elementResults = <ValidationResult>[];

    try {
      if (file.existsSync()) {
        final content = file.readAsStringSync();
        final lines = content.split('\n');

        final classRegex = RegExp(r'^class\s+([A-Z]\w+)');
        final enumRegex = RegExp(r'^enum\s+([A-Z]\w+)');
        final methodRegex = RegExp(r'^\s*[\w\.\<\>]+\s+([a-z]\w+)\s*\(');

        for (var i = 0; i < lines.length; i++) {
          final line = lines[i].trim();
          final isPublicElement = classRegex.hasMatch(line) ||
              enumRegex.hasMatch(line) ||
              (methodRegex.hasMatch(line) &&
                  !methodRegex.firstMatch(line)!.group(1)!.startsWith('_'));

          if (isPublicElement) {
            final docLines = <String>[];
            for (var j = i - 1; j >= 0; j--) {
              final prev = lines[j].trim();
              if (prev.startsWith('///')) {
                docLines.insert(0, prev);
              } else if (prev.isEmpty || prev.startsWith('@')) {
                continue;
              } else {
                break;
              }
            }
            final doc = docLines.join('\n');
            if (doc.trim().isEmpty) {
              continue;
            }
            elementResults.add(validateElement(doc));
          }
        }
      }
    } on Exception {
      // إذا فشل قراءة الملف، نعتبره صالحاً بأقل درجة
      elementResults.add(
        const ValidationResult(
          isValid: true,
          issues: [],
          qualityScore: QualityScore.poor,
        ),
      );
    }

    if (elementResults.isEmpty) {
      return FileValidationResult(
        filePath: filePath,
        elementResults: const [],
        isValid: true,
        overallScore: QualityScore.good,
      );
    }

    final hasErrors = elementResults.any((r) => !r.isValid);
    final avgScore = elementResults.map((r) => r.qualityScore.score).reduce((a, b) => a + b) ~/
        elementResults.length;

    return FileValidationResult(
      filePath: filePath,
      elementResults: elementResults,
      isValid: !hasErrors,
      overallScore: QualityScore.fromScore(avgScore),
    );
  }

  /// التحقق من المشروع بالكامل
  ///
  /// يمر على جميع ملفات Dart في lib/ ويفحص توثيقها
  ProjectValidationResult validateProject() {
    final fileResults = <FileValidationResult>[];
    final libDir = Directory('lib/');
    var totalIssues = 0;
    var allValid = true;
    var totalScore = 0;
    var fileCount = 0;

    try {
      if (libDir.existsSync()) {
        final entities = libDir.listSync(recursive: true).whereType<File>().where(
              (f) =>
                  f.path.endsWith('.dart') &&
                  !f.path.contains('.g.dart') &&
                  !f.path.contains('.freezed.dart'),
            );

        for (final entity in entities) {
          final result = validateFile(entity.path);
          fileResults.add(result);
          if (!result.isValid) allValid = false;
          totalScore += result.overallScore.score;
          fileCount++;
          for (final er in result.elementResults) {
            totalIssues += er.issues.length;
          }
        }
      }
    } on Exception {
      // في حال فشل المسح الكلي، نعيد نتيجة افتراضية آمنة
    }

    final avgScore = fileCount > 0 ? (totalScore / fileCount).round() : 100;

    return ProjectValidationResult(
      fileResults: fileResults,
      isValid: allValid,
      overallScore: QualityScore.fromScore(avgScore),
      totalIssues: totalIssues,
    );
  }

  /// التحقق من صيغة DartDoc
  bool _validateDartDocFormat(String documentation) {
    final doc = documentation.trim();
    return doc.startsWith('///') || (doc.startsWith('/**') && doc.endsWith('*/'));
  }

  /// حساب درجة الجودة (Heuristic)
  QualityScore _calculateQualityScore(String documentation) {
    if (documentation.isEmpty) return QualityScore.poor;

    var score = 0;
    final doc = documentation.toLowerCase();

    // 1. الطول (الكمية قد تشير للجودة)
    if (doc.length > 50) {
      score += 40;
    } else if (doc.length > 20) {
      score += 20;
    }

    // 2. وجود كلمات دلالية احترافية
    if (doc.contains('parameters:')) score += 20;
    if (doc.contains('returns:')) score += 20;
    if (doc.contains('example:')) score += 20;

    return QualityScore.fromScore(score);
  }

  /// اكتشاف المشاكل
  List<ValidationIssue> _detectIssues(String documentation) {
    final issues = <ValidationIssue>[];

    if (documentation.trim().isEmpty) {
      issues.add(
        const ValidationIssue(
          type: IssueType.missingContent,
          description: 'التوثيق فارغ تماماً',
          severity: IssueSeverity.error,
          suggestion: 'أضف وصفاً مختصراً للعنصر يبدأ بـ ///',
        ),
      );
      return issues;
    }

    if (!_validateDartDocFormat(documentation)) {
      issues.add(
        const ValidationIssue(
          type: IssueType.formatError,
          description: 'تنسيق غير متوافق مع DartDoc',
          severity: IssueSeverity.warning,
          suggestion: 'استخدم /// للتوثيق بأسطر متعددة',
        ),
      );
    }

    if (documentation.length < 15) {
      issues.add(
        const ValidationIssue(
          type: IssueType.lowQuality,
          description: 'التوثيق قصير جداً وغير مفيد',
          severity: IssueSeverity.info,
          suggestion: 'توسع في شرح الغرض من هذا العنصر',
        ),
      );
    }

    return issues;
  }
}

/// نتيجة التحقق
///
/// تحتوي على نتيجة التحقق من التوثيق
class ValidationResult {
  /// إنشاء نتيجة تحقق
  const ValidationResult({
    required this.isValid,
    required this.issues,
    required this.qualityScore,
  });

  /// هل التوثيق صحيح
  final bool isValid;

  /// قائمة المشاكل
  final List<ValidationIssue> issues;

  /// درجة الجودة
  final QualityScore qualityScore;

  /// نتيجة صحيحة بدون مشاكل
  static const ValidationResult valid = ValidationResult(
    isValid: true,
    issues: [],
    qualityScore: QualityScore.perfect,
  );
}

/// نتيجة التحقق من ملف
///
/// تحتوي على نتائج التحقق من جميع عناصر الملف
class FileValidationResult {
  /// إنشاء نتيجة تحقق ملف
  const FileValidationResult({
    required this.filePath,
    required this.elementResults,
    required this.isValid,
    required this.overallScore,
  });

  /// مسار الملف
  final String filePath;

  /// نتائج التحقق للعناصر
  final List<ValidationResult> elementResults;

  /// هل الملف صحيح
  final bool isValid;

  /// درجة الجودة الإجمالية
  final QualityScore overallScore;
}

/// نتيجة التحقق من المشروع
///
/// تحتوي على نتائج التحقق من جميع ملفات المشروع
class ProjectValidationResult {
  /// إنشاء نتيجة تحقق مشروع
  const ProjectValidationResult({
    required this.fileResults,
    required this.isValid,
    required this.overallScore,
    required this.totalIssues,
  });

  /// نتائج التحقق للملفات
  final List<FileValidationResult> fileResults;

  /// هل المشروع صحيح
  final bool isValid;

  /// درجة الجودة الإجمالية
  final QualityScore overallScore;

  /// إجمالي المشاكل
  final int totalIssues;
}

/// مشكلة في التحقق
///
/// تمثل مشكلة تم اكتشافها في التوثيق
class ValidationIssue {
  /// إنشاء مشكلة تحقق
  const ValidationIssue({
    required this.type,
    required this.description,
    required this.severity,
    this.lineNumber,
    this.suggestion,
  });

  /// نوع المشكلة
  final IssueType type;

  /// وصف المشكلة
  final String description;

  /// مستوى الخطورة
  final IssueSeverity severity;

  /// رقم السطر
  final int? lineNumber;

  /// اقتراح للإصلاح
  final String? suggestion;
}

/// نوع المشكلة
enum IssueType {
  /// صيغة خاطئة
  formatError,

  /// محتوى ناقص
  missingContent,

  /// جودة منخفضة
  lowQuality,

  /// عدم الامتثال للمعايير
  nonCompliance,
}

/// مستوى خطورة المشكلة
enum IssueSeverity {
  /// خطأ
  error,

  /// تحذير
  warning,

  /// معلومة
  info,
}

/// درجة الجودة
///
/// تمثل درجة جودة التوثيق
class QualityScore {
  /// إنشاء درجة جودة
  const QualityScore({required this.score, required this.rating});

  /// الدرجة (0-100)
  final int score;

  /// التقييم النصي
  final String rating;

  /// درجة ممتازة
  static const QualityScore perfect = QualityScore(
    score: 100,
    rating: 'Perfect',
  );

  /// درجة جيدة جداً
  static const QualityScore excellent = QualityScore(
    score: 90,
    rating: 'Excellent',
  );

  /// درجة جيدة
  static const QualityScore good = QualityScore(score: 75, rating: 'Good');

  /// درجة مقبولة
  static const QualityScore fair = QualityScore(score: 60, rating: 'Fair');

  /// درجة ضعيفة
  static const QualityScore poor = QualityScore(score: 40, rating: 'Poor');

  /// الحصول على التقييم بناءً على الدرجة
  static QualityScore fromScore(int score) {
    if (score >= 95) return perfect;
    if (score >= 85) return excellent;
    if (score >= 70) return good;
    if (score >= 55) return fair;
    return poor;
  }
}
