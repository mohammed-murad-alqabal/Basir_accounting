// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/extensions/invoice_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/core/utils/format_helpers.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_accounting_system/features/invoices/presentation/providers/invoice_pdf_provider.dart';
import 'package:basir_accounting_system/features/invoices/presentation/screens/invoice_form_screen.dart';
import 'package:basir_accounting_system/features/zatca/presentation/widgets/zatca_status_badge.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Invoice Detail Screen displaying ZATCA-compliant QR and metadata.
class InvoiceDetailScreen extends ConsumerWidget {
  /// Localized constructor.
  const InvoiceDetailScreen({required this.invoice, super.key});

  /// The invoice entity to display.
  final Invoice invoice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appIcons = ref.watch(appIconsProvider);
    final calendarVal = ref.watch(calendarProvider).value;
    final calendarType = calendarVal ?? CalendarType.gregorian;
    final isDraft = invoice.status == InvoiceStatus.draft;
    final isCancelled = invoice.status == InvoiceStatus.cancelled;
    final isPaid = invoice.status == InvoiceStatus.paid;

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
            icon: const Icon(Icons.email_outlined),
            tooltip: context.l10n.actionEmailInvoice,
            onPressed: () => ref.refresh(emailInvoiceProvider(invoice)),
          ),
          IconButton(
            icon: Icon(appIcons.pdf),
            tooltip: context.l10n.actionExportPdf,
            onPressed: () => ref.refresh(exportInvoicePdfProvider(invoice)),
          ),
          IconButton(
            icon: Icon(appIcons.print),
            tooltip: context.l10n.tooltipPrintReceipt,
            onPressed: () => ref.refresh(
              printReceiptProvider((invoice: invoice, l10n: context.l10n)),
            ),
          ),
          if (isDraft)
            IconButton(
              icon: Icon(appIcons.edit),
              tooltip: context.l10n.btnUpdateInvoice,
              onPressed: () => _editInvoice(context),
            ),
          if (!isDraft && !isCancelled)
            IconButton(
              icon: Icon(appIcons.delete),
              tooltip: context.l10n.tooltipReverseInvoice,
              onPressed: () => _reverseInvoice(context, ref),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(context, appIcons, isPaid),
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
            const SizedBox(height: Spacing.lg),
            _buildComplianceSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext ctx, AppIconsBase icons, bool isPaid) {
    final statusColor = invoice.getStatusColor(Theme.of(ctx).colorScheme);
    final statusIcon = invoice.getStatusIcon(icons);

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
                invoice.status.toDisplayString(ctx),
                style: AppTextStyles.titleMedium.copyWith(
                  color: statusColor,
                  fontWeight: FontWeights.bold,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              ZatcaStatusBadge(status: invoice.zatcaStatus),
              if (isPaid && invoice.paidDate != null)
                Text(
                  '${ctx.l10n.labelPaidDate}: '
                  '${FormatHelpers.formatDate(
                    invoice.paidDate!,
                    locale: ctx.l10n.localeName,
                  )}',
                  textDirection: TextDirection.ltr,
                  style: AppTextStyles.bodySmall,
                ),
            ],
          ),
          if (invoice.currency != 'SAR') ...[
            const SizedBox(height: Spacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ctx.l10n.labelBaseCurrencyEquivalent,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeights.medium,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  FormatHelpers.formatCurrency(
                    invoice.totalAmountBaseCurrency,
                  ),
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeights.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomerCard(BuildContext ctx, AppIconsBase icons) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icons.person, color: AppColors.primary, size: 20),
                const SizedBox(width: Spacing.sm),
                Text(
                  ctx.l10n.labelCustomer,
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
    BuildContext ctx,
    AppIconsBase icons,
    CalendarType cal,
  ) {
    if (invoice.currency != 'SAR') {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppCard(
                  padding: Spacing.paddingSm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ctx.l10n.labelIssuedDate,
                        style: AppTextStyles.labelSmall,
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        FormatHelpers.formatDate(
                          invoice.issuedDate,
                          locale: ctx.l10n.localeName,
                          calendarType: cal,
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
                        ctx.l10n.labelDueDate,
                        style: AppTextStyles.labelSmall,
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        FormatHelpers.formatDate(
                          invoice.dueDate,
                          locale: ctx.l10n.localeName,
                          calendarType: cal,
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
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Expanded(
                child: AppCard(
                  padding: Spacing.paddingSm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ctx.l10n.labelCurrency,
                        style: AppTextStyles.labelSmall,
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        invoice.currency,
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
                        ctx.l10n.labelExchangeRate,
                        style: AppTextStyles.labelSmall,
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        FormatHelpers.formatNumber(invoice.exchangeRate),
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeights.medium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
    return Row(
      children: [
        Expanded(
          child: AppCard(
            padding: Spacing.paddingSm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ctx.l10n.labelIssuedDate,
                  style: AppTextStyles.labelSmall,
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  FormatHelpers.formatDate(
                    invoice.issuedDate,
                    locale: ctx.l10n.localeName,
                    calendarType: cal,
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
                  ctx.l10n.labelDueDate,
                  style: AppTextStyles.labelSmall,
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  FormatHelpers.formatDate(
                    invoice.dueDate,
                    locale: ctx.l10n.localeName,
                    calendarType: cal,
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
  }

  Widget _buildItemsCard(BuildContext ctx) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ctx.l10n.labelInvoiceItems,
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
                            '${FormatHelpers.formatCurrency(item.price)} '
                            '(${ctx.l10n.labelVatRate}: ${FormatHelpers.formatNumber(item.taxRate * Decimal.fromInt(100))}%)',
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

  Widget _buildTotalsCard(BuildContext ctx) => AppCard(
        backgroundColor: AppColors.surfaceVariant.withValues(alpha: 0.5),
        child: Column(
          children: [
            _buildTotalRow(ctx.l10n.labelSubtotal, invoice.subtotalAmount),
            _buildTotalRow(
              ctx.l10n.labelTaxTotal,
              invoice.taxAmount,
            ),
            if (invoice.discountAmount > Decimal.zero)
              _buildTotalRow(
                ctx.l10n.labelDiscountAmount,
                -invoice.discountAmount,
              ),
            const Divider(height: Spacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ctx.l10n.labelGrandTotal,
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
            if (invoice.currency != 'SAR') ...[
              const SizedBox(height: Spacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ctx.l10n.labelBaseCurrencyEquivalent,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeights.medium,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    FormatHelpers.formatCurrency(
                      invoice.totalAmountBaseCurrency,
                    ),
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeights.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      );

  Widget _buildTotalRow(String label, Decimal amount) => Padding(
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

  Widget _buildQrCodeSection(BuildContext ctx) {
    if (invoice.qrCode == null || invoice.qrCode!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Center(
      child: Column(
        children: [
          Text(
            ctx.l10n.labelZatcaQrCode,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: Spacing.md),
          AppQrCode(data: invoice.qrCode!, size: 160),
          const SizedBox(height: Spacing.sm),
          Text(
            ctx.l10n.zatcaComplianceText,
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.textHint),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceSection(BuildContext ctx) {
    if (invoice.zatcaUuid == null && invoice.zatcaHash == null) {
      return const SizedBox.shrink();
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.security, size: 20, color: AppColors.primary),
              const SizedBox(width: Spacing.sm),
              Text(
                ctx.l10n.zatcaComplianceText,
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeights.bold,
                ),
              ),
            ],
          ),
          const Divider(height: Spacing.lg),
          if (invoice.zatcaUuid != null)
            _buildMetadataRow(
              ctx,
              ctx.l10n.labelZatcaUuid,
              invoice.zatcaUuid!,
            ),
          if (invoice.zatcaHash != null)
            _buildMetadataRow(
              ctx,
              ctx.l10n.labelZatcaHash,
              invoice.zatcaHash!,
            ),
        ],
      ),
    );
  }

  Widget _buildMetadataRow(BuildContext ctx, String label, String value) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            InkWell(
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: value));
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(
                      content: Text(ctx.l10n.msgValueCopiedToClipboard),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Text(
                value,
                style: AppTextStyles.bodySmall.copyWith(
                  fontFamily: 'monospace',
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );

  Future<void> _editInvoice(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => InvoiceFormScreen(invoice: invoice),
      ),
    );
  }

  Future<void> _reverseInvoice(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.titleReverseInvoice),
        content: Text(ctx.l10n.msgConfirmReverseInvoice),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(ctx.l10n.dialogCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(ctx.l10n.btnConfirmReverse),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      try {
        final service = ref.read(accountingServiceProvider.notifier);
        await service.reverseInvoice(invoice);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.msgInvoiceReversed)),
          );
          Navigator.pop(context);
        }
      } on Exception catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }
}
