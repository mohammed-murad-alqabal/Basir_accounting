import 'dart:async';

import 'package:basir_accounting_system/core/theme/glass_theme.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/navigation/presentation/providers/omnibar_provider.dart';
import 'package:basir_accounting_system/shared/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows the Omnibar overlay.
Future<T?> showOmnibar<T>(BuildContext context) => showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Omnibar',
      barrierColor: Colors.black.withValues(alpha: 0.3),
      pageBuilder: (context, animation, secondaryAnimation) => const Omnibar(),
      transitionBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutQuart,
            ),
          ),
          child: child,
        ),
      ),
    );

class Omnibar extends ConsumerStatefulWidget {
  /// Creates an [Omnibar].
  const Omnibar({super.key});

  @override
  ConsumerState<Omnibar> createState() => _OmnibarState();
}

class _OmnibarState extends ConsumerState<Omnibar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _query = '';

  @override
  void initState() {
    super.initState();
    // Auto-focus the search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: lines_longer_than_80_chars
    final glassTheme =
        Theme.of(context).extension<GlassTheme>() ?? GlassTheme.light();
    final size = MediaQuery.of(context).size;
    final searchResults = ref.watch(omnibarSearchProvider(_query));

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: size.width * 0.6, // Desktop-centric width
          constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
          margin: const EdgeInsets.all(24),
          child: GlassCard(
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Search Field
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: glassTheme.glassColor == Colors.white
                            ? Colors.grey[800]
                            : Colors.white70,
                        size: 28,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          style: const TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            hintText: 'Type a command or search...',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintStyle: TextStyle(
                              color: glassTheme.glassColor == Colors.white
                                  ? Colors.grey[500]
                                  : Colors.white38,
                            ),
                          ),
                          onChanged: (val) {
                            setState(() => _query = val);
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.5),
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'ESC',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Results Area
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    children: [
                      if (_query.isEmpty) ...[
                        _buildSectionHeader('Suggestions'),
                        _buildActionItem(
                          Icons.add,
                          'New Invoice',
                          'Create a new sales invoice',
                          onTap: () =>
                              Navigator.of(context).pushNamed('/invoice-form'),
                        ),
                        _buildActionItem(
                          Icons.person_add,
                          'New Customer',
                          'Register a new client',
                          onTap: () =>
                              Navigator.of(context).pushNamed('/customer-form'),
                        ),
                        _buildActionItem(
                          Icons.assignment_return_outlined,
                          'Returns & Damages',
                          'Process returns or damaged items',
                          onTap: () => Navigator.of(context)
                              .pushNamed('/returns-and-damages'),
                        ),
                      ] else ...[
                        _buildSectionHeader('Results for "$_query"'),
                        ...searchResults.map(
                          (result) => _buildActionItem(
                            _getIconForResult(result.type),
                            result.title,
                            result.subtitle,
                            onTap: () => _handleResult(result),
                          ),
                        ),
                        if (searchResults.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'No results found',
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ],
                  ),
                ),

                // Footer
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.black.withValues(alpha: 0.05),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Basir "Diamond" Omnibar',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForResult(OmnibarResultType type) {
    switch (type) {
      case OmnibarResultType.invoice:
        return Icons.receipt_long;
      case OmnibarResultType.customer:
        return Icons.person;
      case OmnibarResultType.item:
        return Icons.inventory_2;
      case OmnibarResultType.action:
        return Icons.bolt;
    }
  }

  void _handleResult(OmnibarResult result) {
    Navigator.pop(context);
    switch (result.type) {
      case OmnibarResultType.invoice:
        unawaited(
          Navigator.of(context).pushNamed(
            '/invoice-detail',
            arguments: result.data as Invoice,
          ),
        );
      case OmnibarResultType.customer:
        unawaited(
          Navigator.of(context).pushNamed(
            '/customer-detail',
            arguments: result.data as Customer,
          ),
        );
      case OmnibarResultType.item:
        // Navigate to item form in view/edit mode
        unawaited(
          Navigator.of(context).pushNamed(
            '/inventory-form',
            arguments: result.data,
          ),
        );
      case OmnibarResultType.action:
        if (result.data is String) {
          unawaited(
            Navigator.of(context).pushNamed(result.data as String),
          );
        }
    }
  }

  Widget _buildSectionHeader(String title) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1,
          ),
        ),
      );

  Widget _buildActionItem(
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) =>
      ListTile(
        leading: Icon(icon, size: 20),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        hoverColor: Colors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap: () {
          if (onTap != null) {
            Navigator.pop(context);
            onTap();
          }
        },
      );
}
