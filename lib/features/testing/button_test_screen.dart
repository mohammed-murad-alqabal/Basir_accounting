import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/core/widgets/index.dart';
import 'package:flutter/material.dart';

/// شاشة اختبار شاملة لجميع أنواع الأزرار.
///
/// تحتوي على جميع أنواع الأزرار (primary, secondary, text) في حالات مختلفة
/// (عادي، مع أيقونة، معطل، تحميل، نص طويل) لاختبار عدم وجود قص للنصوص.
///
/// **الاستخدام:**
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(builder: (_) => const ButtonTestScreen()),
///,);
/// ```
class ButtonTestScreen extends StatelessWidget {
  /// ينشئ شاشة اختبار الأزرار.
  const ButtonTestScreen({super.key});

  /// يبني شاشة اختبار الأزرار مع جميع أنواع الأزرار.
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.testButtonsTitle),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: TextScaleFactorTester(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // مقدمة
                _buildIntroCard(),

                const SizedBox(height: 24),

                // قسم: أزرار Primary
                _buildSection(
                  title: context.l10n.sectionPrimaryButtons,
                  icon: Icons.touch_app,
                  children: [
                    AppEnhancedButton(text: 'نص قصير', onPressed: () {}),
                    const SizedBox(height: 12),
                    AppEnhancedButton(
                      text: 'نص متوسط الطول للاختبار',
                      onPressed: () {},
                    ),
                    const SizedBox(height: 12),
                    AppEnhancedButton(
                      text: 'نص طويل جداً جداً جداً قد يسبب مشاكل في العرض',
                      onPressed: () {},
                    ),
                    const SizedBox(height: 12),
                    AppEnhancedButton(
                      text: 'مع أيقونة',
                      icon: Icons.add,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 12),
                    const AppEnhancedButton(text: 'معطل', onPressed: null),
                    const SizedBox(height: 12),
                    AppEnhancedButton(
                      text: 'تحميل',
                      onPressed: () {},
                      isLoading: true,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // قسم: أزرار Secondary
                _buildSection(
                  title: context.l10n.sectionSecondaryButtons,
                  icon: Icons.radio_button_unchecked,
                  children: [
                    AppEnhancedButton(
                      text: 'نص قصير',
                      onPressed: () {},
                      style: AppEnhancedButtonStyle.secondary,
                    ),
                    const SizedBox(height: 12),
                    AppEnhancedButton(
                      text: 'نص متوسط الطول للاختبار',
                      onPressed: () {},
                      style: AppEnhancedButtonStyle.secondary,
                    ),
                    const SizedBox(height: 12),
                    AppEnhancedButton(
                      text: 'نص طويل جداً جداً جداً قد يسبب مشاكل في العرض',
                      onPressed: () {},
                      style: AppEnhancedButtonStyle.secondary,
                    ),
                    const SizedBox(height: 12),
                    AppEnhancedButton(
                      text: 'مع أيقونة',
                      icon: Icons.edit,
                      onPressed: () {},
                      style: AppEnhancedButtonStyle.secondary,
                    ),
                    const SizedBox(height: 12),
                    const AppEnhancedButton(
                      text: 'معطل',
                      onPressed: null,
                      style: AppEnhancedButtonStyle.secondary,
                    ),
                    const SizedBox(height: 12),
                    AppEnhancedButton(
                      text: 'تحميل',
                      onPressed: () {},
                      isLoading: true,
                      style: AppEnhancedButtonStyle.secondary,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // قسم: أزرار Text
                _buildSection(
                  title: context.l10n.sectionTextButtons,
                  icon: Icons.text_fields,
                  children: [
                    AppEnhancedButton(
                      text: 'نص قصير',
                      onPressed: () {},
                      style: AppEnhancedButtonStyle.text,
                    ),
                    const SizedBox(height: 12),
                    AppEnhancedButton(
                      text: 'نص متوسط الطول للاختبار',
                      onPressed: () {},
                      style: AppEnhancedButtonStyle.text,
                    ),
                    const SizedBox(height: 12),
                    AppEnhancedButton(
                      text: 'نص طويل جداً جداً جداً قد يسبب مشاكل في العرض',
                      onPressed: () {},
                      style: AppEnhancedButtonStyle.text,
                    ),
                    const SizedBox(height: 12),
                    AppEnhancedButton(
                      text: 'مع أيقونة',
                      icon: Icons.delete,
                      onPressed: () {},
                      style: AppEnhancedButtonStyle.text,
                    ),
                    const SizedBox(height: 12),
                    const AppEnhancedButton(
                      text: 'معطل',
                      onPressed: null,
                      style: AppEnhancedButtonStyle.text,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // قسم: أزرار في Row
                _buildSection(
                  title: context.l10n.sectionRowButtons,
                  icon: Icons.view_column,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppEnhancedButton(
                            text: 'إلغاء',
                            onPressed: () {},
                            style: AppEnhancedButtonStyle.secondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppEnhancedButton(
                            text: 'موافق',
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: AppEnhancedButton(
                            text: 'حذف',
                            icon: Icons.delete,
                            onPressed: () {},
                            style: AppEnhancedButtonStyle.text,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppEnhancedButton(
                            text: 'حفظ',
                            icon: Icons.save,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: AppEnhancedButton(
                            text: 'نص طويل جداً',
                            onPressed: () {},
                            style: AppEnhancedButtonStyle.secondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppEnhancedButton(
                            text: 'نص طويل جداً أيضاً',
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // قسم: حالات خاصة
                _buildSection(
                  title: context.l10n.sectionSpecialCases,
                  icon: Icons.warning,
                  children: [
                    AppEnhancedButton(
                      text: 'نص عربي طويل جداً جداً جداً مع أيقونة',
                      icon: Icons.info,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 12),
                    AppEnhancedButton(
                      text: 'نص قصير',
                      icon: Icons.check_circle,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 12),
                    AppEnhancedButton(
                      text: 'نص طويل جداً في زر بعرض محدد',
                      onPressed: () {},
                      style: AppEnhancedButtonStyle.secondary,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // ملاحظة نهائية
                _buildNoteCard(),
              ],
            ),
          ),
        ),
      );

  /// بناء بطاقة المقدمة
  Widget _buildIntroCard() => Builder(
        builder: (context) {
          final colorScheme = Theme.of(context).colorScheme;
          return Card(
            color: colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'شاشة اختبار الأزرار',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'استخدم شريط التحكم أعلاه لتغيير textScaleFactor '
                    'واختبار جميع الأزرار للتأكد من عدم وجود قص للنصوص.',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

  /// بناء بطاقة الملاحظة
  Widget _buildNoteCard() => Builder(
        builder: (context) {
          final colorScheme = Theme.of(context).colorScheme;
          return Card(
            color: colorScheme.tertiaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: colorScheme.tertiary),
                      const SizedBox(width: 8),
                      Text(
                        'ملاحظة',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• جرب جميع قيم textScaleFactor (1.0x - 2.0x)\n'
                    '• تحقق من عدم وجود قص أفقي أو عمودي\n'
                    '• تحقق من وضوح النصوص في جميع الحالات\n'
                    '• اختبر الأزرار في Row للتأكد من التوزيع الصحيح',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onTertiaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

  /// بناء قسم من الأزرار
  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) =>
      Builder(
        builder: (context) {
          final colorScheme = Theme.of(context).colorScheme;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 24, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...children,
            ],
          );
        },
      );
}
