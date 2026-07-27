import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/settings/application/cloud_backup_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة النسخ الاحتياطي السحابي والمحلي.
class CloudBackupScreen extends ConsumerStatefulWidget {
  /// Creates the [CloudBackupScreen].
  const CloudBackupScreen({super.key});

  @override
  ConsumerState<CloudBackupScreen> createState() => _CloudBackupScreenState();
}

class _CloudBackupScreenState extends ConsumerState<CloudBackupScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final serviceState = ref.watch(cloudBackupServiceProvider);
    final service = ref.read(cloudBackupServiceProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأمان والنسخ الاحتياطي'),
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.onSecondary,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'نسخ محلي', icon: Icon(Icons.storage_outlined)),
            Tab(text: 'Google Drive', icon: Icon(Icons.cloud_upload_outlined)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLocalBackupTab(serviceState, service),
          _buildCloudSyncTab(serviceState, service),
        ],
      ),
    );
  }

  Widget _buildLocalBackupTab(
    AsyncValue<void> state,
    CloudBackupService service,
  ) =>
      Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoCard(
              title: 'النسخ الاحتياطي المحلي',
              description: 'يتم حفظ نسخة من قاعدة البيانات في ذاكرة الهاتف '
                  'الداخلية. يمكنك استخدامها لاستعادة البيانات يدوياً.',
              icon: Icons.sd_storage,
              color: Colors.blue,
            ),
            const SizedBox(height: Spacing.xl),
            ElevatedButton.icon(
              onPressed: state.isLoading
                  ? null
                  : () async {
                      final file = await service.createLocalBackup();
                      if (file != null && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('تم إنشاء النسخة في: ${file.path}'),
                          ),
                        );
                      }
                    },
              icon: const Icon(Icons.backup),
              label: const Text('إنشاء نسخة احتياطية الآن'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.onSecondary,
                padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildCloudSyncTab(
    AsyncValue<void> state,
    CloudBackupService service,
  ) {
    final isSignedIn = service.isSignedIn;

    return Padding(
      padding: const EdgeInsets.all(Spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInfoCard(
            title: 'مزامنة Google Drive',
            description: 'اربط حسابك لتتمكن من رفع واستعادة بياناتك من السحابة '
                'تلقائياً. المزامنة تضمن عدم فقدان بياناتك '
                'حتى عند تغيير الهاتف.',
            icon: Icons.cloud_done,
            color: Colors.orange,
          ),
          const SizedBox(height: Spacing.xl),
          if (!isSignedIn)
            ElevatedButton.icon(
              onPressed: () async {
                final account = await service.signIn();
                if (account != null) setState(() {});
              },
              icon: const Icon(Icons.login),
              label: const Text('ربط حساب Google'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
          else ...[
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(service.userEmail ?? 'تم تسجيل الدخول'),
              subtitle: const Text('حساب Google المرتبط'),
              trailing: TextButton(
                onPressed: () async {
                  await service.signOut();
                  setState(() {});
                },
                child: const Text(
                  'تغيير الحساب',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            const Divider(),
            const SizedBox(height: Spacing.md),
            ElevatedButton.icon(
              onPressed: state.isLoading
                  ? null
                  : () async {
                      final success = await service.uploadToDrive();
                      if (success && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تمت مزامنة البيانات بنجاح'),
                          ),
                        );
                      }
                    },
              icon: state.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.sync),
              label: const Text('مزامنة الآن إلى Google Drive'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.onSecondary,
                padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) =>
      Card(
        elevation: 0,
        color: color.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color.withValues(alpha: 0.2)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Row(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: color.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 13, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
