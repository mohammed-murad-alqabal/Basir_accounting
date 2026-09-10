/// Widget template for reusable UI components
///
/// Usage: Replace [Widget] with your widget name
/// 
/// Example:
/// ```dart
/// class CustomerCard extends StatelessWidget {
///   final Customer customer;
///   const CustomerCard({super.key, required this.customer});
///   // ... implementation
/// }
/// ```

import 'package:flutter/material.dart';

/// [Widget] - A reusable widget component
class [Widget] extends StatelessWidget {
  /// Required data
  final dynamic data;

  /// Optional callback
  final VoidCallback? onTap;

  /// Optional styling
  final EdgeInsets? padding;

  const [Widget]({
    super.key,
    required this.data,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Title',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        
        // Subtitle
        Text(
          'Subtitle',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

/// Stateful widget template
class [Widget]Stateful extends StatefulWidget {
  final dynamic data;

  const [Widget]Stateful({
    super.key,
    required this.data,
  });

  @override
  State<[Widget]Stateful> createState() => _[Widget]StatefulState();
}

class _[Widget]StatefulState extends State<[Widget]Stateful> {
  // State variables
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    setState(() => _isLoading = true);
    // Initialize logic
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    // Cleanup resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      // Widget content
      child: const Text('Content'),
    );
  }
}
