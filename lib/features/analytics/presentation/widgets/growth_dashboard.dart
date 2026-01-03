import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:basir_app/features/analytics/application/analytics_service.dart';
import 'package:basir_app/features/analytics/domain/entities/analytics_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// لوحة تحكم النمو والتحليلات
class GrowthDashboard extends ConsumerWidget {
  /// إنشاء لوحة تحكم النمو
  const GrowthDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final analytics = ref.watch(analyticsServiceProvider);

    if (analytics == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'نظرة عامة على النمو',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.lg),

          // ملخص المقاييس
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: Spacing.md,
            crossAxisSpacing: Spacing.md,
            childAspectRatio: 1.5,
            children: [
              _MetricCard(
                title: 'الفواتير المُنشأة',
                future: analytics.getEventCount(
                  AnalyticsEventType.invoiceCreated,
                ),
                icon: Icons.description_outlined,
                color: theme.colorScheme.primary,
              ),
              _MetricCard(
                title: 'العملاء الجدد',
                future: analytics.getEventCount(
                  AnalyticsEventType.customerAdded,
                ),
                icon: Icons.people_outline,
                color: theme.colorScheme.secondary,
              ),
              _MetricCard(
                title: 'جلسات العمل',
                future:
                    analytics.getEventCount(AnalyticsEventType.sessionStart),
                icon: Icons.ads_click,
                color: theme.colorScheme.tertiary,
              ),
              _MetricCard(
                title: 'نشاط اليوم',
                future: analytics.getDailyActiveUsersCount(),
                icon: Icons.today_outlined,
                color: theme.colorScheme.secondary,
              ),
            ],
          ),

          const SizedBox(height: Spacing.xl),

          // Placeholder للرسم البياني (سيتم تطويره في 7.2)
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bar_chart,
                    size: 48,
                    color: theme.colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    'الرسوم البيانية المتقدمة قيد التطوير',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.future,
    required this.icon,
    required this.color,
  });

  final String title;
  final Future<int> future;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: color.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: color.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: Spacing.xs),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.sm),
            FutureBuilder<int>(
              future: future,
              builder: (context, snapshot) => Text(
                snapshot.data?.toString() ?? '...',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
