
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(2),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Dot(),
            const SizedBox(width: 4),
            _Dot(delay: 200.ms),
            const SizedBox(width: 4),
            _Dot(delay: 400.ms),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Duration delay;

  const _Dot({this.delay = Duration.zero});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
     .scale(duration: 600.ms, delay: delay, begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2))
     .fade(duration: 600.ms, delay: delay, begin: 0.5, end: 1.0);
  }
}
