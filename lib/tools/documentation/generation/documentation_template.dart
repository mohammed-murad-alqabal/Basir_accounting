import 'package:basir_accounting_system/tools/documentation/analysis/analysis_engine.dart';

/// قالب التوثيق
///
/// يوفر قوالب جاهزة لتوليد documentation لأنواع مختلفة من العناصر
class DocumentationTemplate {
  /// إنشاء قالب توثيق
  const DocumentationTemplate({
    required this.type,
    required this.arabicTemplate,
    required this.englishTemplate,
    required this.requiredSections,
  });

  /// الحصول على القالب المناسب حسب النوع
  factory DocumentationTemplate.fromType(ElementType type) {
    switch (type) {
      case ElementType.classType:
        return DocumentationTemplate.classTemplate();
      case ElementType.method:
        return DocumentationTemplate.methodTemplate();
      case ElementType.property:
        return DocumentationTemplate.propertyTemplate();
      case ElementType.enumType:
        return DocumentationTemplate.enumTemplate();
      case ElementType.typedef:
        // استخدام قالب الكلاس للـ typedef
        return DocumentationTemplate.classTemplate();
    }
  }

  /// قالب للـ enums
  factory DocumentationTemplate.enumTemplate() => const DocumentationTemplate(
        type: ElementType.enumType,
        arabicTemplate: '''
/// {description}
///
/// {details}
''',
        englishTemplate: '''
/// {description}
///
/// {details}
''',
        requiredSections: ['description', 'details'],
      );

  /// قالب للكلاسات
  factory DocumentationTemplate.classTemplate() => const DocumentationTemplate(
        type: ElementType.classType,
        arabicTemplate: '''
/// {description}
///
/// {details}
''',
        englishTemplate: '''
/// {description}
///
/// {details}
''',
        requiredSections: ['description', 'details'],
      );

  /// قالب للدوال
  factory DocumentationTemplate.methodTemplate() => const DocumentationTemplate(
        type: ElementType.method,
        arabicTemplate: '''
/// {description}
///
/// {details}
///
/// Parameters:
{parameters}
///
/// Returns: {returns}
''',
        englishTemplate: '''
/// {description}
///
/// {details}
///
/// Parameters:
{parameters}
///
/// Returns: {returns}
''',
        requiredSections: ['description', 'parameters', 'returns'],
      );

  /// قالب للخصائص
  // ignore: prefer_expression_function_bodies
  factory DocumentationTemplate.propertyTemplate() {
    return const DocumentationTemplate(
      type: ElementType.property,
      arabicTemplate: '''
/// {description}
''',
      englishTemplate: '''
/// {description}
''',
      requiredSections: ['description'],
    );
  }

  /// نوع العنصر
  final ElementType type;

  /// القالب العربي
  final String arabicTemplate;

  /// القالب الإنجليزي
  final String englishTemplate;

  /// الأقسام المطلوبة
  final List<String> requiredSections;

  /// توليد documentation بناءً على السياق
  ///
  /// Parameters:
  /// - [context]: معلومات السياق للعنصر
  ///
  /// Returns: نص التوثيق المولد
  String generate(Map<String, dynamic> context) {
    final useArabic = context['useArabic'] as bool? ?? true;
    final template = useArabic ? arabicTemplate : englishTemplate;
    var result = template;

    for (final entry in context.entries) {
      final key = entry.key;
      final value = entry.value;
      if (key == 'useArabic') continue;
      final placeholder = '{$key}';
      if (result.contains(placeholder)) {
        result = result.replaceAll(placeholder, _formatValue(value, key));
      }
    }

    for (final section in requiredSections) {
      final placeholder = '{$section}';
      if (result.contains(placeholder)) {
        result = result.replaceAll(
          placeholder,
          context[section]?.toString() ?? _fallbackForSection(section),
        );
      }
    }

    return result.trim();
  }

  String _formatValue(dynamic value, String key) {
    if (value is List) {
      if (key == 'parameters') {
        return value.map((p) {
          if (p is Map<String, dynamic>) {
            final Object? nameValue = p['name'];
            final Object? descriptionValue = p['description'];
            final name =
                nameValue is String ? nameValue : nameValue?.toString() ?? '';
            final description = descriptionValue is String
                ? descriptionValue
                : (descriptionValue?.toString() ?? name);
            return '/// - [$name]: $description';
          }
          return '/// - $p';
        }).join('\n');
      }
      return value.map((e) => '/// $e').join('\n');
    }
    return value.toString();
  }

  String _fallbackForSection(String section) {
    switch (section) {
      case 'description':
        return 'Element documentation placeholder.';
      case 'details':
        return 'No additional details available.';
      case 'parameters':
        return '/// No parameters.';
      case 'returns':
        return 'No return value description.';
      default:
        return '';
    }
  }
}
