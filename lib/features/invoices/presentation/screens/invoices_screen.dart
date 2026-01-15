import 'dart:async';

import 'package:basir_accounting_system/core/assets/app_illustrations.dart';
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/extensions/invoice_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/services/color_customization_service.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/core/utils/format_helpers.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_accounting_system/features/invoices/presentation/providers/invoice_provider.dart';
import 'package:basir_accounting_system/features/invoices/presentation/screens/invoice_form_screen.dart';
import 'package:basir_accounting_system/features/onboarding/presentation/widgets/cognitive_overlay.dart';
import 'package:basir_accounting_system/features/reports/application/pdf_invoice_service.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';

/// شاشة قائمة الفواتير (Invoices Screen)
class InvoicesScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة الفواتير
  const InvoicesScreen({super.key});

  @override
  ConsumerState<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends ConsumerState<InvoicesScreen> {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final invoicesAsync = ref.watch(filteredInvoicesProvider);
    final statsAsync = ref.watch(invoiceStatisticsProvider);
    final appIcons = ref.watch(appIconsProvider);
    final calendarType =
        ref.watch(calendarProvider).value ?? CalendarType.gregorian;

    // Trigger Cognitive Hint on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (invoicesAsync.hasValue &&
          invoicesAsync.value!.isEmpty &&
          _selectedFilter == 'all') {
        showCognitiveHint(
          context,
          'هنا يمكنك متابعة جميع فواتيرك. ابدأ بإنشاء فاتورة جديدة بالضغط على زر الإضافة (+).',
          title: 'إدارة الفواتير',
        );
      }
    });

    return GlassScaffold(
      title: context.l10n.invoicesTitle,
      actions: [
        IconButton(
          icon: Icon(appIcons.add),
          onPressed: _createNewInvoice,
          tooltip: context.l10n.tooltipAddInvoice,
        ),
        IconButton(
          icon: Icon(appIcons.pdf),
          onPressed: _exportInvoice,
          tooltip: context.l10n.tooltipExportAll,
        ),
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewInvoice,
        backgroundColor: AppColors.primary,
        child: Icon(appIcons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          _buildStatsHeader(statsAsync),
          _buildFilterBar(),
          Expanded(
            child: invoicesAsync.when(
              data: (invoices) =>
                  _buildInvoicesList(invoices, appIcons, calendarType),
              loading: () => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                itemCount: 5,
                itemBuilder: (context, index) => const AppListSkeleton(),
              ),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ErrorIllustration(size: 80),
                      const SizedBox(height: Spacing.lg),
                      Text(
                        context.l10n.errorLoadingInvoices,
                        style: const TextStyle(
                          fontSize: AppTypography.bodyLarge,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Spacing.xl),
                      AppEnhancedButton(
                        label: context.l10n.retryLabel,
                        onPressed: () {
                          ref.invalidate(invoicesProvider);
                        },
                        icon: appIcons.refresh,
                        type: AppEnhancedButtonType.secondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader(AsyncValue<InvoiceStatistics> statsAsync) =>
      Container(
        padding: const EdgeInsets.all(Spacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
          ),
        ),
        child: statsAsync.when(
          data: (stats) => Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context.l10n.statTotal,
                  FormatHelpers.formatNumber(
                    stats.totalInvoices,
                    locale: context.l10n.localeName,
                  ),
                  AppColors.primary,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context.l10n.statPaid,
                  FormatHelpers.formatNumber(
                    stats.paidInvoices,
                    locale: context.l10n.localeName,
                  ),
                  AppColors.success,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context.l10n.statOverdue,
                  FormatHelpers.formatNumber(
                    stats.overdueInvoices,
                    locale: context.l10n.localeName,
                  ),
                  AppColors.error,
                ),
              ),
            ],
          ),
          loading: () => const LinearProgressIndicator(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      );

  Widget _buildStatItem(String label, String value, Color color) => Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: AppTypography.titleLarge,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: AppTypography.bodySmall,
              color: AppColors.textHint,
            ),
          ),
        ],
      );

  Widget _buildFilterBar() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.lg,
          vertical: Spacing.sm,
        ),
        child: Row(
          children: [
            _buildFilterChip(context.l10n.filterAll, 'all'),
            _buildFilterChip(context.l10n.filterDraft, 'draft'),
            _buildFilterChip(context.l10n.filterIssued, 'issued'),
            _buildFilterChip(context.l10n.filterPaid, 'paid'),
            _buildFilterChip(context.l10n.filterOverdue, 'overdue'),
          ],
        ),
      );

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: Spacing.sm),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _selectedFilter = value);
          ref.read(invoiceFilterProvider.notifier).state = value;
        },
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.full),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
      ),
    );
  }

  Widget _buildInvoicesList(
    List<Invoice> invoices,
    AppIcons appIcons,
    CalendarType calendarType,
  ) {
    if (invoices.isEmpty) {
      return AppEmptyState(
        title: context.l10n.noInvoicesTitle,
        description: context.l10n.noInvoicesDescription,
        onActionPressed: _createNewInvoice,
        actionLabel: context.l10n.actionCreateFirstInvoice,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      itemCount: invoices.length,
      itemBuilder: (context, index) {
        final invoice = invoices[index];
        final dateStr = FormatHelpers.formatDate(
          invoice.issuedDate,
          locale: context.l10n.localeName,
          calendarType: calendarType,
        );
        final statusText = switch (invoice.status) {
          InvoiceStatus.paid => context.l10n.statusPaid,
          InvoiceStatus.overdue => context.l10n.statusOverdue,
          InvoiceStatus.sent => context.l10n.statusPending,
          InvoiceStatus.draft => context.l10n.filterDraft,
          InvoiceStatus.cancelled => context.l10n.statusCancelled,
          _ => invoice.status.toString(),
        };
        final amountStr = FormatHelpers.formatCurrency(
          invoice.totalAmount,
          locale: context.l10n.localeName,
        );
        final semanticsLabel =
            '${context.l10n.invoiceTitle(invoice.invoiceNumber)}, '
            '${invoice.customerName}, $dateStr, $amountStr, $statusText';

        return Semantics(
          label: semanticsLabel,
          button: true,
          child: AppListCard(
            title: context.l10n.invoiceTitle(invoice.invoiceNumber),
            subtitle: '${invoice.customerName} - $dateStr',
            trailing: amountStr,
            leading: Container(
              padding: const EdgeInsets.all(Spacing.sm),
              decoration: BoxDecoration(
                color: invoice
                    .getStatusColor(Theme.of(context).colorScheme)
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(Radii.sm),
              ),
              child: Icon(
                invoice.getStatusIcon(appIcons),
                color: invoice.getStatusColor(Theme.of(context).colorScheme),
                size: 20,
              ),
            ),
            onTap: () {
              unawaited(
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => InvoiceFormScreen(invoice: invoice),
                  ),
                ),
              );
            },
            onLongPress: () =>
                _showInvoiceActions(invoice, appIcons, calendarType),
          ),
        );
      },
    );
  }

  // وظيفة تصدير الفاتورة
  Future<void> _exportInvoice() async {
    if (!mounted) return;
    // منطق التصدير...
  }

  Future<void> _createNewInvoice() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (context) => const InvoiceFormScreen()),
    );
  }

  void _showInvoiceActions(
    Invoice invoice,
    AppIcons appIcons,
    CalendarType calendarType,
  ) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(appIcons.pdf),
                title: Text(context.l10n.actionSharePdf),
                onTap: () {
                  Navigator.pop(context);
                  unawaited(_shareInvoicePdf(invoice));
                },
              ),
              ListTile(
                leading: Icon(appIcons.message),
                title: Text(context.l10n.actionShareWhatsappText),
                onTap: () {
                  Navigator.pop(context);
                  unawaited(
                    _shareInvoiceViaWhatsApp(
                      invoice,
                      asPdf: false,
                      calendarType: calendarType,
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(appIcons.share),
                title: Text(context.l10n.actionShareWhatsappPdf),
                onTap: () {
                  Navigator.pop(context);
                  unawaited(
                    _shareInvoiceViaWhatsApp(
                      invoice,
                      asPdf: true,
                      calendarType: calendarType,
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: Icon(appIcons.delete, color: AppColors.error),
                title: Text(
                  context.l10n.actionDeleteInvoice,
                  style: const TextStyle(color: AppColors.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  unawaited(_deleteInvoice(invoice));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _shareInvoicePdf(Invoice invoice) async {
    try {
      final customerRepo = ref.read(customerRepositoryProvider);
      final customer = await customerRepo.getCustomerById(invoice.customerId);

      if (customer == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.errorCustomerNotFound)),
        );
        return;
      }

      final pdfService = ref.read(pdfInvoiceServiceProvider.notifier);
      final primaryColor = ref.read(colorCustomizationProvider).value;
      final pdfBytes = await pdfService.generateInvoice(
        invoice,
        customer,
        primaryColor: primaryColor != null
            ? PdfColor.fromInt(primaryColor.toARGB32())
            : null,
      );

      if (!mounted) return;
      final sharingService = ref.read(sharingServiceProvider);
      await sharingService.sharePdfFile(
        bytes: pdfBytes,
        fileName: 'invoice_${invoice.id}.pdf',
        subject: context.l10n.pdfShareSubject(invoice.id),
        text: context.l10n.pdfShareText(invoice.customerName),
      );
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.errorSharePdf(e.toString()))),
      );
    }
  }

  Future<void> _shareInvoiceViaWhatsApp(
    Invoice invoice, {
    required bool asPdf,
    required CalendarType calendarType,
  }) async {
    try {
      final customerRepo = ref.read(customerRepositoryProvider);
      final customer = await customerRepo.getCustomerById(invoice.customerId);

      if (customer == null ||
          (customer.phone == null || customer.phone!.isEmpty)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.errorCustomerPhone)),
        );
        return;
      }

      final sharingService = ref.read(sharingServiceProvider);

      if (asPdf) {
        final pdfService = ref.read(pdfInvoiceServiceProvider.notifier);
        final primaryColor = ref.read(colorCustomizationProvider).value;
        final pdfBytes = await pdfService.generateInvoice(
          invoice,
          customer,
          primaryColor: primaryColor != null
              ? PdfColor.fromInt(primaryColor.toARGB32())
              : null,
        );
        if (!mounted) return;
        await sharingService.sharePdfFile(
          bytes: pdfBytes,
          fileName: 'invoice_${invoice.invoiceNumber}.pdf',
          text: context.l10n.pdfShareSubject(invoice.invoiceNumber),
        );
      } else {
        if (!mounted) return;
        final settingsService = ref.read(settingsServiceProvider);
        final currencyCode = await settingsService.getCurrencyCode();

        if (!mounted) return;
        final message = context.l10n.msgInvoiceShare(
          customer.nameAr,
          invoice.invoiceNumber,
          FormatHelpers.formatNumber(
            invoice.totalAmount,
            locale: context.l10n.localeName,
            // Removed undefined named parameter 'currencySymbol'
          ),
          currencyCode,
        );
        await sharingService.shareToWhatsApp(
          phone: customer.phone!,
          message: message,
        );
      }
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.errorShareWhatsapp(e.toString()))),
      );
    }
  }

  Future<void> _deleteInvoice(Invoice invoice) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.actionDeleteInvoice),
        content: Text(context.l10n.msgConfirmDeleteInvoice),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.dialogCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              context.l10n.btnDelete,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await ref.read(deleteInvoiceProvider(invoice.id).future);
    }
  }
}
