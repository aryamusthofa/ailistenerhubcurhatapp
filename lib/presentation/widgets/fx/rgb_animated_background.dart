import 'package:flutter/material.dart';

class RGBAnimatedBackground extends StatefulWidget {
  final Widget child;
  const RGBAnimatedBackground({super.key, required this.child});

  @override
  State<RGBAnimatedBackground> createState() => _RGBAnimatedBackgroundState();
}

class _RGBAnimatedBackgroundState extends State<RGBAnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: SweepGradient(
              center: Alignment.center,
              colors: const [
                Colors.red,
                Colors.yellow,
                Colors.green,
                Colors.cyan,
                Colors.blue,
                Colors.pink,
                Colors.red,
              ],
              stops: const [0.0, 0.17, 0.34, 0.51, 0.68, 0.85, 1.0],
              transform: GradientRotation(_controller.value * 2 * 3.14159),
            ),
          ),
          child: Container(
            // Dark overlay to make it look like a "border" or subtle effect if needed
            // or just the content with some opacity
            color: Colors.black.withValues(alpha: 0.85),
            child: widget.child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
