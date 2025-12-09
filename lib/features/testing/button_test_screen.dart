import 'package:basser_app/core/widgets/index.dart';
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
/// );
/// ```
class ButtonTestScreen extends StatelessWidget {
  /// ينشئ شاشة اختبار الأزرار.
  const ButtonTestScreen({super.key});

  /// يبني شاشة اختبار الأزرار مع جميع أنواع الأزرار.
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('اختبار الأزرار'),
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
              title: 'أزرار Primary',
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
              title: 'أزرار Secondary',
              icon: Icons.radio_button_unchecked,
              children: [
                AppEnhancedButton(
                  text: 'نص قصير',
                  onPressed: () {},
                  type: AppEnhancedButtonType.secondary,
                ),
                const SizedBox(height: 12),
                AppEnhancedButton(
                  text: 'نص متوسط الطول للاختبار',
                  onPressed: () {},
                  type: AppEnhancedButtonType.secondary,
                ),
                const SizedBox(height: 12),
                AppEnhancedButton(
                  text: 'نص طويل جداً جداً جداً قد يسبب مشاكل في العرض',
                  onPressed: () {},
                  type: AppEnhancedButtonType.secondary,
                ),
                const SizedBox(height: 12),
                AppEnhancedButton(
                  text: 'مع أيقونة',
                  icon: Icons.edit,
                  onPressed: () {},
                  type: AppEnhancedButtonType.secondary,
                ),
                const SizedBox(height: 12),
                const AppEnhancedButton(
                  text: 'معطل',
                  onPressed: null,
                  type: AppEnhancedButtonType.secondary,
                ),
                const SizedBox(height: 12),
                AppEnhancedButton(
                  text: 'تحميل',
                  onPressed: () {},
                  isLoading: true,
                  type: AppEnhancedButtonType.secondary,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // قسم: أزرار Text
            _buildSection(
              title: 'أزرار Text',
              icon: Icons.text_fields,
              children: [
                AppEnhancedButton(
                  text: 'نص قصير',
                  onPressed: () {},
                  type: AppEnhancedButtonType.text,
                ),
                const SizedBox(height: 12),
                AppEnhancedButton(
                  text: 'نص متوسط الطول للاختبار',
                  onPressed: () {},
                  type: AppEnhancedButtonType.text,
                ),
                const SizedBox(height: 12),
                AppEnhancedButton(
                  text: 'نص طويل جداً جداً جداً قد يسبب مشاكل في العرض',
                  onPressed: () {},
                  type: AppEnhancedButtonType.text,
                ),
                const SizedBox(height: 12),
                AppEnhancedButton(
                  text: 'مع أيقونة',
                  icon: Icons.delete,
                  onPressed: () {},
                  type: AppEnhancedButtonType.text,
                ),
                const SizedBox(height: 12),
                const AppEnhancedButton(
                  text: 'معطل',
                  onPressed: null,
                  type: AppEnhancedButtonType.text,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // قسم: أزرار في Row
            _buildSection(
              title: 'أزرار في Row',
              icon: Icons.view_column,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppEnhancedButton(
                        text: 'إلغاء',
                        onPressed: () {},
                        type: AppEnhancedButtonType.secondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppEnhancedButton(text: 'موافق', onPressed: () {}),
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
                        type: AppEnhancedButtonType.text,
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
                        type: AppEnhancedButtonType.secondary,
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
              title: 'حالات خاصة',
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
                  width: 200,
                ),
                const SizedBox(height: 12),
                AppEnhancedButton(
                  text: 'نص طويل جداً في زر بعرض محدد',
                  onPressed: () {},
                  type: AppEnhancedButtonType.secondary,
                  width: 250,
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
  Widget _buildIntroCard() => Card(
    color: Colors.blue.shade50,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text(
                'شاشة اختبار الأزرار',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'استخدم شريط التحكم أعلاه لتغيير textScaleFactor '
            'واختبار جميع الأزرار للتأكد من عدم وجود قص للنصوص.',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    ),
  );

  /// بناء بطاقة الملاحظة
  Widget _buildNoteCard() => Card(
    color: Colors.amber.shade50,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.amber.shade700),
              const SizedBox(width: 8),
              Text(
                'ملاحظة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '• جرب جميع قيم textScaleFactor (1.0x - 2.0x)\n'
            '• تحقق من عدم وجود قص أفقي أو عمودي\n'
            '• تحقق من وضوح النصوص في جميع الحالات\n'
            '• اختبر الأزرار في Row للتأكد من التوزيع الصحيح',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    ),
  );

  /// بناء قسم من الأزرار
  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, size: 24, color: Colors.blue.shade700),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      ...children,
    ],
  );
}
