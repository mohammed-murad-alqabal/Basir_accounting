// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/forensics/application/ledger_integrity_service.dart';
import 'package:basir_accounting_system/features/forensics/domain/entities/integrity_status.dart';
import 'package:basir_accounting_system/features/forensics/presentation/screens/forensic_guardian_screen.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A small, translucent pulse widget that indicates the real-time health of the ledger.
class IntegrityPulseWidget extends ConsumerWidget {
  /// Creates the [IntegrityPulseWidget].
  const IntegrityPulseWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final health = ref.watch(ledgerIntegrityServiceProvider);

    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => const ForensicGuardianScreen(),
          ),
        );
      },
      child: GlassCard(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.sm,
          vertical: Spacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PulseIndicator(color: health.color),
            const SizedBox(width: Spacing.xs),
            Text(
              health.status == IntegrityStatus.healthy
                  ? 'Ledger Secure'
                  : 'Action Required',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: health.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PulseIndicator extends StatefulWidget {
  const _PulseIndicator({required this.color});
  final Color color;

  @override
  State<_PulseIndicator> createState() => _PulseIndicatorState();
}

class _PulseIndicatorState extends State<_PulseIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _controller.repeat(reverse: true).ignore();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
        scale: Tween(begin: 0.8, end: 1.2).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        ),
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: 0.8),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.4),
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      );
}
