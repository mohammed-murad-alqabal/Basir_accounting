import 'package:basser_app/core/widgets/app_button.dart';
import 'package:basser_app/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

/// صفحة اختبار شاملة للمكونات المحدثة
///
/// تحتوي على جميع المكونات المحدثة في المهام 7 و 8:
/// - AppPrimaryButton
/// - AppSecondaryButton
/// - AppTextButton
/// - AppTextField
/// - AppSearchField
class TestUIImprovementsPage extends StatefulWidget {
  /// ينشئ صفحة اختبار للمكونات المحدثة
  const TestUIImprovementsPage({super.key});

  @override
  State<TestUIImprovementsPage> createState() => _TestUIImprovementsPageState();
}

class _TestUIImprovementsPageState extends State<TestUIImprovementsPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleLoading() {
    setState(() => _isLoading = !_isLoading);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('اختبار تحسينات واجهة المستخدم'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const Text(
                'المهمة 7 و 8: اختبار المكونات المحدثة',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'اختبر جميع الحالات والتفاعلات',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Section 1: AppPrimaryButton
              _buildSectionTitle('1. AppPrimaryButton'),
              const SizedBox(height: 16),

              AppPrimaryButton(
                label: 'زر أساسي عادي',
                onPressed: () => _showSnackBar('تم الضغط على الزر الأساسي'),
              ),
              const SizedBox(height: 12),

              AppPrimaryButton(
                label: 'زر أساسي مع أيقونة',
                icon: Icons.save,
                onPressed: () => _showSnackBar('تم الضغط على الزر مع الأيقونة'),
              ),
              const SizedBox(height: 12),

              const AppPrimaryButton(
                label: 'زر أساسي معطل',
                onPressed: null,
              ),
              const SizedBox(height: 12),

              AppPrimaryButton(
                label: 'زر أساسي في حالة تحميل',
                isLoading: _isLoading,
                onPressed: _toggleLoading,
              ),
              const SizedBox(height: 32),

              // Section 2: AppSecondaryButton
              _buildSectionTitle('2. AppSecondaryButton'),
              const SizedBox(height: 16),

              AppSecondaryButton(
                label: 'زر ثانوي عادي',
                onPressed: () => _showSnackBar('تم الضغط على الزر الثانوي'),
              ),
              const SizedBox(height: 12),

              AppSecondaryButton(
                label: 'زر ثانوي مع أيقونة',
                icon: Icons.close,
                onPressed: () =>
                    _showSnackBar('تم الضغط على الزر الثانوي مع الأيقونة'),
              ),
              const SizedBox(height: 12),

              const AppSecondaryButton(
                label: 'زر ثانوي معطل',
                onPressed: null,
              ),
              const SizedBox(height: 12),

              AppSecondaryButton(
                label: 'زر ثانوي في حالة تحميل',
                isLoading: _isLoading,
                onPressed: _toggleLoading,
              ),
              const SizedBox(height: 32),

              // Section 3: AppTextButton
              _buildSectionTitle('3. AppTextButton'),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AppTextButton(
                    label: 'زر نصي',
                    onPressed: () => _showSnackBar('تم الضغط على الزر النصي'),
                  ),
                  AppTextButton(
                    label: 'مع أيقونة',
                    icon: Icons.help,
                    onPressed: () =>
                        _showSnackBar('تم الضغط على الزر النصي مع الأيقونة'),
                  ),
                  const AppTextButton(
                    label: 'معطل',
                    onPressed: null,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Section 4: AppTextField
              _buildSectionTitle('4. AppTextField'),
              const SizedBox(height: 16),

              AppTextField(
                label: 'البريد الإلكتروني',
                hint: 'أدخل بريدك الإلكتروني',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'البريد الإلكتروني مطلوب';
                  }
                  if (!value.contains('@')) {
                    return 'البريد الإلكتروني غير صحيح';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              AppTextField(
                label: 'كلمة المرور',
                hint: 'أدخل كلمة المرور',
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'كلمة المرور مطلوبة';
                  }
                  if (value.length < 6) {
                    return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              const AppTextField(
                label: 'حقل معطل',
                hint: 'هذا الحقل معطل',
                enabled: false,
              ),
              const SizedBox(height: 16),

              const AppTextField(
                label: 'ملاحظات',
                hint: 'أدخل ملاحظاتك هنا...',
                maxLines: 4,
              ),
              const SizedBox(height: 32),

              // Section 5: AppSearchField
              _buildSectionTitle('5. AppSearchField'),
              const SizedBox(height: 16),

              AppSearchField(
                hint: 'ابحث عن شيء...',
                controller: _searchController,
                onChanged: (value) => _showSnackBar('البحث عن: $value'),
                onClear: () => _showSnackBar('تم مسح البحث'),
              ),
              const SizedBox(height: 32),

              // Validation Button
              AppPrimaryButton(
                label: 'التحقق من صحة النموذج',
                icon: Icons.check_circle,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _showSnackBar('✅ النموذج صحيح!');
                  } else {
                    _showSnackBar('❌ يرجى تصحيح الأخطاء');
                  }
                },
              ),
              const SizedBox(height: 16),

              // Instructions
              _buildInstructionsCard(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );

  Widget _buildSectionTitle(String title) => Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );

  Widget _buildInstructionsCard() => Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  'تعليمات الاختبار',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInstruction('1', 'اختبر جميع الأزرار (عادي، معطل، تحميل)'),
            _buildInstruction('2', 'تحقق من ripple effect عند الضغط'),
            _buildInstruction(
              '3',
              'اختبر حقول الإدخال (كتابة، تحرير، نسخ، لصق)',
            ),
            _buildInstruction('4', 'اختبر إظهار/إخفاء كلمة المرور'),
            _buildInstruction('5', 'اختبر رسائل الخطأ (اضغط على زر التحقق)'),
            _buildInstruction('6', 'اختبر حقل البحث (اكتب ثم امسح)'),
            _buildInstruction('7', 'تحقق من وضوح الحدود عند التركيز'),
            _buildInstruction('8', 'اختبر في ظروف إضاءة مختلفة'),
          ],
        ),
      ),
    );

  Widget _buildInstruction(String number, String text) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number.',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
}
