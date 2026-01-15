import 'package:flutter/material.dart';

/// A custom route that uses "Spring" physics for transitions.
/// Designed to make the app feel "Alive" and "Responsive".
class SpringRoute<T> extends PageRouteBuilder<T> {
  /// Standard constructor for the spring route.
  SpringRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // "Alive" Spring Curve
            // Using easeOutQuart for snappy yet smooth finish,
            // approximating a critical damp spring.
            const curve = Curves.easeOutQuart;

            final tween = Tween(
              begin: const Offset(0, 0.05), // Slight vertical slide from bottom
              end: Offset.zero,
            ).chain(CurveTween(curve: curve));

            final fadeTween = Tween<double>(begin: 0, end: 1).chain(
              CurveTween(curve: curve),
            );

            // Scale effect for depth
            final scaleTween = Tween<double>(begin: 0.95, end: 1).chain(
              CurveTween(curve: curve),
            );

            return FadeTransition(
              opacity: animation.drive(fadeTween),
              child: SlideTransition(
                position: animation.drive(tween),
                child: ScaleTransition(
                  scale: animation.drive(scaleTween),
                  child: child,
                ),
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 400),
        );

  /// The page to navigate to.
  final Widget page;
}
