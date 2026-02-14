
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AuroraBackground extends StatelessWidget {
  final Widget child;

  const AuroraBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // A simplified Aurora effect using animated gradients or shapes
    // For MVP/V2, we'll use a stack of blurred, moving circles + glass overlay
    
    return Stack(
      children: [
        // Base Background
        Container(color: Theme.of(context).scaffoldBackgroundColor),

        // Aurora Blob 1 (Top Left - Sage/Green)
        Positioned(
          top: -100,
          left: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF8FA395).withValues(alpha: 0.4),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .scale(duration: 4.seconds, begin: const Offset(1, 1), end: const Offset(1.2, 1.2))
           .move(duration: 5.seconds, begin: const Offset(0, 0), end: const Offset(20, 20)),
        ),

        // Aurora Blob 2 (Bottom Right - Lavender)
        Positioned(
          bottom: -50,
          right: -50,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFDCD6F7).withValues(alpha: 0.4),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .scale(duration: 6.seconds, begin: const Offset(1, 1), end: const Offset(1.3, 1.3))
           .move(duration: 7.seconds, begin: const Offset(0, 0), end: const Offset(-30, -30)),
        ),

        // Backdrop Blur for the whole scene (creates the diffusion)
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.white.withValues(alpha: 0.01)), // Hint
          ),
        ),

        // Main Content on top
        Positioned.fill(child: child),
      ],
    );
  }
}
