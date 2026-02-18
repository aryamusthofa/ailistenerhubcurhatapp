import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme/theme_provider.dart';
import 'fx/rgb_animated_background.dart';

/// ThemeableContainer — Container yang berubah background warna sesuai theme
class ThemeableContainer extends ConsumerWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool useGradient;

  const ThemeableContainer({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.all(0),
    this.width,
    this.height,
    this.borderRadius,
    this.useGradient = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final theme = Theme.of(context);
    
    // Get appropriate background color based on theme
    final bgColor = theme.scaffoldBackgroundColor;
    final surface = theme.colorScheme.surface;

    Widget content = Container(
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: useGradient || themeMode == AppThemeMode.rgb ? null : bgColor,
        gradient: useGradient 
          ? _buildGradient(themeMode, bgColor, surface)
          : null,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: child,
    );

    if (themeMode == AppThemeMode.rgb) {
      return RGBAnimatedBackground(child: content);
    }

    return content;
  }

  LinearGradient _buildGradient(
    AppThemeMode mode,
    Color primary,
    Color secondary,
  ) {
    return switch (mode) {
      AppThemeMode.calming => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primary.withValues(alpha: 0.9),
          secondary.withValues(alpha: 0.7),
        ],
      ),
      AppThemeMode.cyberpunk => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primary.withValues(alpha: 0.8),
          secondary.withValues(alpha: 0.6),
        ],
      ),
      _ => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primary, secondary],
      ),
    };
  }
}
