import 'package:basser_app/tools/documentation/analysis/analysis_engine.dart';

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
    // TODO(dev): تنفيذ توليد التوثيق
    throw UnimplementedError('generate not implemented yet');
  }

  /// قالب للكلاسات
  static DocumentationTemplate get classTemplate => const DocumentationTemplate(
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
  static DocumentationTemplate get methodTemplate =>
      const DocumentationTemplate(
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
  static DocumentationTemplate get propertyTemplate =>
      const DocumentationTemplate(
        type: ElementType.property,
        arabicTemplate: '''
/// {description}
''',
        englishTemplate: '''
/// {description}
''',
        requiredSections: ['description'],
      );

  /// قالب للـ enums
  static DocumentationTemplate get enumTemplate => const DocumentationTemplate(
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

  /// الحصول على القالب المناسب حسب النوع
  static DocumentationTemplate getTemplate(ElementType type) {
    switch (type) {
      case ElementType.classType:
        return classTemplate;
      case ElementType.method:
        return methodTemplate;
      case ElementType.property:
        return propertyTemplate;
      case ElementType.enumType:
        return enumTemplate;
      case ElementType.typedef:
        return classTemplate; // استخدام قالب الكلاس للـ typedef
    }
  }
}
