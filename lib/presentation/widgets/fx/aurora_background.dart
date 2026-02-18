import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/theme/theme_provider.dart';
import 'rgb_animated_background.dart';

class AuroraBackground extends ConsumerWidget {
  final Widget child;

  const AuroraBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final theme = Theme.of(context);

    if (themeMode == AppThemeMode.rgb) {
      return RGBAnimatedBackground(child: child);
    }

    return Stack(
      children: [
        // Base Background Color
        Container(color: theme.scaffoldBackgroundColor),

        // Aurora Blob 1 (Top Left)
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary.withValues(alpha: 0.4),
            ),
          )
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scale(duration: 4.seconds, begin: const Offset(1, 1), end: const Offset(1.2, 1.2))
          .move(duration: 5.seconds, begin: const Offset(0, 0), end: const Offset(20, 20)),
        ),

        // Aurora Blob 2 (Bottom Right)
        Positioned(
          bottom: -50,
          right: -50,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.secondary.withValues(alpha: 0.4),
            ),
          )
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scale(duration: 6.seconds, begin: const Offset(1, 1), end: const Offset(1.3, 1.3))
          .move(duration: 7.seconds, begin: const Offset(0, 0), end: const Offset(-30, -30)),
        ),

        // Blur Filter (Glassmorphism effect)
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60), // Heavy blur for aurora effect
            child: Container(color: Colors.white.withValues(alpha: 0.01)), // Hint
          ),
        ),

        // Content
        Positioned.fill(child: child),
      ],
    );
  }
}
