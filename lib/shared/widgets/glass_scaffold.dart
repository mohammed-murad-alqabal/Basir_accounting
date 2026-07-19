import 'dart:ui';

import 'package:basir_accounting_system/core/theme/glass_theme.dart';
import 'package:basir_accounting_system/features/navigation/presentation/widgets/omnibar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The foundational layout for all "Genius" screens.
/// Provides the gradients, mesh background, and glass app bar.
class GlassScaffold extends StatelessWidget {
  /// Standard constructor for the genius foundational layout.
  const GlassScaffold({
    required this.body,
    super.key,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  /// The main content of the screen.
  final Widget body;

  /// Optional title displayed in the center of the app bar.
  final String? title;

  /// List of widgets to display in the app bar actions.
  final List<Widget>? actions;

  /// The floating action button for the scaffold.
  final Widget? floatingActionButton;

  /// The bottom navigation bar for the scaffold.
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    final glassTheme =
        Theme.of(context).extension<GlassTheme>() ?? GlassTheme.light();

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyK, meta: true): () =>
            showOmnibar<void>(context),
        const SingleActivator(LogicalKeyboardKey.keyK, control: true): () =>
            showOmnibar<void>(context),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          backgroundColor: Colors.transparent,
          appBar: title != null
              ? AppBar(
                  title: Text(
                    title!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  centerTitle: true,
                  backgroundColor: glassTheme.glassColor.withValues(alpha: 0.5),
                  elevation: 0,
                  flexibleSpace: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  actions: actions,
                )
              : null,
          body: Stack(
            children: [
              // Layer 0: The Mesh Gradient Background
              Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(-0.8, -0.8),
                    radius: 1.5,
                    colors: [
                      glassTheme.primaryGradient.colors.first
                          .withValues(alpha: 0.15),
                      Theme.of(context).scaffoldBackgroundColor,
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0.8, 0.8),
                    radius: 1.5,
                    colors: [
                      glassTheme.primaryGradient.colors.last
                          .withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              // Layer 1: Content
              SafeArea(
                bottom: false, // Let content flow behind bottom nav
                child: body,
              ),
            ],
          ),
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar,
        ),
      ),
    );
  }
}
