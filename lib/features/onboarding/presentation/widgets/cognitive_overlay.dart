import 'package:basir_accounting_system/shared/widgets/glass_card.dart';
import 'package:flutter/material.dart';

/// Shows a contextual cognitive hint.
void showCognitiveHint(BuildContext context, String message, {String? title}) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 100,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 500),
          tween: Tween(begin: 0, end: 1),
          curve: Curves.easeOutBack,
          builder: (context, val, child) => Transform.scale(
            scale: val,
            child: Opacity(
              opacity: val,
              child: SizedBox(
                width: 300,
                child: GlassCard(
                  opacity: 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.lightbulb_outline,
                            color: Colors.amber,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            title ?? 'Cognitive Hint',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close, size: 16),
                            onPressed: () => entry.remove(),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        message,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);

  // Auto-dismiss after 5 seconds
  Future.delayed(const Duration(seconds: 5), () {
    if (entry.mounted) {
      entry.remove();
    }
  });
}

/// An overlay widget that displays cognitive feedback.
class CognitiveOverlay extends StatelessWidget {
  /// Creates a [CognitiveOverlay].
  const CognitiveOverlay({required this.child, super.key});

  /// The child widget to display below the overlay.
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
