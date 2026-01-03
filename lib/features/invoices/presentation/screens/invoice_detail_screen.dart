import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/core/extensions/invoice_extensions.dart';
import 'package:basir_app/core/providers.dart';
import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:basir_app/core/utils/format_helpers.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_app/features/invoices/presentation/providers/invoice_pdf_provider.dart';
import 'package:basir_app/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة تفاصيل الفاتورة (Invoice Detail Screen)
///
/// تعرض معلومات مفصلة عن الفاتورة مع رمز QR متوافق مع ZATCA.
class InvoiceDetailScreen extends ConsumerWidget {
  /// إنشاء شاشة تفاصيل الفاتورة
  const InvoiceDetailScreen({required this.invoice, super.key});

  /// الفاتورة المراد عرض تفاصيلها
  final Invoice invoice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appIcons = ref.watch(appIconsProvider);
    final calendarType = ref.watch(calendarProvider).valueOrNull ?? CalendarType.gregorian;

    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.invoiceTitle(invoice.invoiceNumber),
        actions: [
          IconButton(
            icon: Icon(appIcons.share),
            tooltip: context.l10n.actionShare,
            onPressed: () => ref.refresh(shareInvoicePdfProvider(invoice)),
          ),
          IconButton(
            icon: Icon(appIcons.pdf),
            tooltip: context.l10n.actionExportPdf,
            onPressed: () => ref.refresh(exportInvoicePdfProvider(invoice)),
          ),
          IconButton(
            icon: Icon(appIcons.edit),
            onPressed: () => _editInvoice(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(context, appIcons),
            const SizedBox(height: Spacing.lg),
            _buildCustomerCard(context, appIcons),
            const SizedBox(height: Spacing.lg),
            _buildInfoCard(context, appIcons, calendarType),
            const SizedBox(height: Spacing.lg),
            _buildItemsCard(context),
            const SizedBox(height: Spacing.lg),
            _buildTotalsCard(context),
            const SizedBox(height: Spacing.xl),
            _buildQrCodeSection(context),
            const SizedBox(height: Spacing.xl),
            if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
              _buildNotesSection(
                context,
                context.l10n.labelNotes,
                invoice.notes!,
              ),
              const SizedBox(height: Spacing.lg),
            ],
            if (invoice.terms != null && invoice.terms!.isNotEmpty) ...[
              _buildNotesSection(
                context,
                context.l10n.labelTermsAndConditions,
                invoice.terms!,
              ),
              const SizedBox(height: Spacing.lg),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, AppIcons appIcons) {
    final statusColor = invoice.getStatusColor(Theme.of(context).colorScheme);
    final statusIcon = invoice.getStatusIcon(appIcons);

    return AppCard(
      backgroundColor: statusColor.withValues(alpha: 0.1),
      borderColor: statusColor.withValues(alpha: 0.3),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 24),
          const SizedBox(width: Spacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                invoice.status.toDisplayString(context),
                style: AppTextStyles.titleMedium.copyWith(
                  color: statusColor,
                  fontWeight: FontWeights.bold,
                ),
              ),
              if (invoice.status == InvoiceStatus.paid && invoice.paidDate != null)
                Text(
                  '${context.l10n.labelPaidDate}: '
                  '${FormatHelpers.formatDate(invoice.paidDate!, locale: context.l10n.localeName)}',
                  style: AppTextStyles.bodySmall,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(BuildContext context, AppIcons appIcons) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(appIcons.person, color: AppColors.primary, size: 20),
                const SizedBox(width: Spacing.sm),
                Text(
                  context.l10n.labelCustomer,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              invoice.customerName,
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeights.bold,
              ),
            ),
          ],
        ),
      );

  Widget _buildInfoCard(
    BuildContext context,
    AppIcons appIcons,
    CalendarType calendarType,
  ) =>
      Row(
        children: [
          Expanded(
            child: AppCard(
              padding: Spacing.paddingSm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.labelIssuedDate,
                    style: AppTextStyles.labelSmall,
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    FormatHelpers.formatDate(
                      invoice.issuedDate,
                      locale: context.l10n.localeName,
                      calendarType: calendarType,
                    ),
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeights.medium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: AppCard(
              padding: Spacing.paddingSm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.labelDueDate,
                    style: AppTextStyles.labelSmall,
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    FormatHelpers.formatDate(
                      invoice.dueDate,
                      locale: context.l10n.localeName,
                      calendarType: calendarType,
                    ),
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeights.medium,
                      color: invoice.isOverdue ? AppColors.error : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  Widget _buildItemsCard(BuildContext context) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.labelInvoiceItems,
              style: AppTextStyles.titleSmall.copyWith(
                fontWeight: FontWeights.bold,
              ),
            ),
            const Divider(height: Spacing.lg),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: invoice.items.length,
              separatorBuilder: (_, __) => const Divider(height: Spacing.md),
              itemBuilder: (context, index) {
                final item = invoice.items[index];
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeights.medium,
                            ),
                          ),
                          Text(
                            '${FormatHelpers.formatNumber(item.quantity)} × '
                            '${FormatHelpers.formatCurrency(item.price)}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      FormatHelpers.formatCurrency(item.total),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeights.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );

  Widget _buildTotalsCard(BuildContext context) => AppCard(
        backgroundColor: AppColors.surfaceVariant.withValues(alpha: 0.5),
        child: Column(
          children: [
            _buildTotalRow(context.l10n.labelSubtotal, invoice.subtotalAmount),
            _buildTotalRow(
              '${context.l10n.labelTax}: '
              '${FormatHelpers.formatNumber(invoice.taxRate * 100)}%',
              invoice.taxAmount,
            ),
            if (invoice.discountAmount > 0)
              _buildTotalRow(
                context.l10n.labelDiscountAmount,
                -invoice.discountAmount,
              ),
            const Divider(height: Spacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.labelGrandTotal,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeights.bold,
                  ),
                ),
                Text(
                  FormatHelpers.formatCurrency(
                    invoice.totalAmount,
                    currencyCode: invoice.currency,
                  ),
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeights.extraBold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildTotalRow(String label, double amount) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodyMedium),
            Text(
              FormatHelpers.formatCurrency(amount),
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeights.medium,
              ),
            ),
          ],
        ),
      );

  Widget _buildQrCodeSection(BuildContext context) {
    if (invoice.qrCode == null || invoice.qrCode!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Column(
        children: [
          Text(
            context.l10n.labelZatcaQrCode,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: Spacing.md),
          AppQrCode(
            data: invoice.qrCode!,
            size: 160,
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            context.l10n.zatcaComplianceText,
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.textHint),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(
    BuildContext context,
    String title,
    String content,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeights.bold),
          ),
          const SizedBox(height: Spacing.sm),
          Text(content, style: AppTextStyles.bodyMedium),
        ],
      );

  void _editInvoice(BuildContext context) {
    // منطق التعديل
  }
}
