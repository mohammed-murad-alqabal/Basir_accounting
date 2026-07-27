import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/settings/application/excel_import_service.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/import_row.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen for importing bulk data from Excel files.
class ExcelImportScreen extends ConsumerWidget {
  /// Creates the excel import screen.
  const ExcelImportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final importState = ref.watch(excelImportServiceProvider);
    final service = ref.read(excelImportServiceProvider.notifier);

    return GlassScaffold(
      title: 'استيراد البيانات من Excel',
      body: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInstructionsCard(context, service),
            const SizedBox(height: Spacing.md),
            _buildActionButtons(context, service, importState),
            const SizedBox(height: Spacing.md),
            const Text(
              'معاينة البيانات السابقة:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: Spacing.xs),
            Expanded(
              child: _buildPreviewTable(importState),
            ),
            if (importState.valueOrNull != null)
              if (importState.value!.isNotEmpty)
                _buildSaveButton(service, importState),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionsCard(
    BuildContext context,
    ExcelImportService service,
  ) =>
      Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'تعليمات الاستيراد:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              const Text(
                '• يجب أن يحتوي الملف على 5 أعمدة: '
                'اسم الحساب، الهاتف، العنوان، الرصيد، طبيعة الحساب.',
              ),
              const Text('• تأكد من صحة قيم المبالغ (أرقام عشرية).'),
              const Text(
                '• طبيعة الحساب تكون (Debit / مدين) أو (Credit / دائن).',
              ),
              TextButton(
                onPressed: () => service.generateTemplate(),
                child: const Text(
                  'تحميل القالب الجاهز (Template)',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildActionButtons(
    BuildContext context,
    ExcelImportService service,
    AsyncValue<List<ImportRow>> state,
  ) =>
      ElevatedButton.icon(
        onPressed: state.isLoading ? null : () => service.pickAndParse(),
        icon: state.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.file_upload),
        label: const Text('اختيار ملف Excel'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: AppColors.onSecondary,
          padding: const EdgeInsets.symmetric(vertical: Spacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

  Widget _buildPreviewTable(AsyncValue<List<ImportRow>> state) => state.when(
        data: (rows) {
          if (rows.isEmpty) {
            return const Center(
              child: Text('لم يتم اختيار ملف بعد أو الملف فارغ'),
            );
          }
          return ListView.builder(
            itemCount: rows.length,
            itemBuilder: (context, index) {
              final row = rows[index];
              return Card(
                margin: const EdgeInsets.only(bottom: Spacing.xs),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: row.isValid ? Colors.teal : Colors.red,
                    child: Icon(
                      row.isValid ? Icons.check : Icons.error,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(row.name),
                  subtitle: Text(
                    '${row.balance} • ${row.nature.name} • '
                    '${row.phone ?? "بدون هاتف"}',
                  ),
                  trailing: row.error == null
                      ? null
                      : const Icon(Icons.info_outline, color: Colors.red),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
      );

  Widget _buildSaveButton(
    ExcelImportService service,
    AsyncValue<List<ImportRow>> state,
  ) =>
      Container(
        padding: const EdgeInsets.only(top: Spacing.sm),
        child: ElevatedButton(
          onPressed: state.isLoading ? null : () => service.commitImport(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: Spacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('حفظ واستيراد كافة البيانات'),
        ),
      );
}
